-- ASSIGNMENT 9-1: CREATING A TRIGGER TO HANDLE PRODUCT RESTOCKING
-- BREWBEAN’S HAS A COUPLE OF COLUMNS IN THE PRODUCT TABLE TO ASSIST IN INVENTORY TRACKING. THE
-- REORDER COLUMN CONTAINS THE STOCK LEVEL AT WHICH THE PRODUCT SHOULD BE REORDERED. IF THE
-- STOCK FALLS TO THIS LEVEL, BREWBEAN’S WANTS THE APPLICATION TO INSERT A ROW IN THE
-- BB_PRODUCT_REQUEST TABLE AUTOMATICALLY TO ALERT THE ORDERING CLERK THAT ADDITIONAL
-- INVENTORY IS NEEDED. BREWBEAN’S CURRENTLY USES THE REORDER LEVEL AMOUNT AS THE QUANTITY THAT
-- SHOULD BE ORDERED. THIS TASK CAN BE HANDLED BY USING A TRIGGER.
-- 1. Take out some scrap paper and a pencil. Think about the tasks the triggers needs to
-- PERFORM, INCLUDING CHECKING WHETHER THE NEW STOCK LEVEL FALLS BELOW THE REORDER POINT. IF SO,
-- check whether the product is already on order by viewing the product request table; if not,
-- ENTER A NEW PRODUCT REQUEST. TRY TO WRITE THE TRIGGER CODE ON PAPER. EVEN THOUGH YOU LEARN
-- a lot by reviewing code, you improve your skills faster when you create the code on
-- YOUR OWN.
-- 2. Open the c9reorder.txt file in the Chapter09 folder. Review this trigger code, and
-- DETERMINE HOW IT COMPARES WITH YOUR CODE.
-- 3. In SQL Developer, create the trigger with the provided code.
-- 4. Test the trigger with product ID 4. First, run the query shown in Figure 9-36 to verify the
-- CURRENT STOCK DATA FOR THIS PRODUCT. NOTICE THAT A SALE OF ONE MORE ITEM SHOULD INITIATE
-- a reorder.
-- SELECT
--   stock,
--   reorder
-- FROM
--   bb_product
-- WHERE
--   idProduct = 4;
-- FIGURE 9-36 Checking stock data
-- 5. Run the UPDATE statement shown in Figure 9-37. It should cause the trigger to fire. Notice
-- the query to check whether the trigger fired and whether a product stock request was
-- inserted in the BB_PRODUCT_REQUEST table.
-- UPDATE bb_product SET stock = 25
-- WHERE idProduct = 4;
-- SELECT *
-- FROM bb_product_request;
-- FIGURE 9-37 Updating the stock level for product 4
-- 6. Issue a ROLLBACK statement to undo these DML actions to restore data to its original state
-- for use in later assignments.
-- 7. Run the following statement to disable this trigger so that it doesn’t affect other projects:
-- ALTER TRIGGER bb_reorder_trg DISABLE;

CREATE OR REPLACE TRIGGER bb_reorder_trg AFTER
  UPDATE OF stock ON bb_product FOR EACH ROW
DECLARE
  v_onorder_num NUMBER(4);
BEGIN
  IF :NEW.stock <= :NEW.reorder THEN
    SELECT
      SUM(qty) INTO v_onorder_num
    FROM
      bb_product_request
    WHERE
      idProduct = :NEW.idProduct
      AND dtRecd IS NULL;
    IF v_onorder_num IS NULL THEN
      v_onorder_num := 0;
    END IF;

    IF v_onorder_num = 0 THEN
      INSERT INTO bb_product_request (
        idRequest,
        idProduct,
        dtRequest,
        qty
      ) VALUES (
        bb_prodreq_seq.NEXTVAL,
        :NEW.idProduct,
        SYSDATE,
        :NEW.reorder
      );
    END IF;
  END IF;
END;
/

SELECT
  stock,
  reorder
FROM
  bb_product
WHERE
  idProduct = 4;

UPDATE bb_product
SET
  stock = 25
WHERE
  idProduct = 4;

SELECT
  *
FROM
  bb_product_request;

ROLLBACK;

ALTER TRIGGER bb_reorder_trg DISABLE;

-- Assignment 9-2: Updating Stock Information When a Product Request Is Filled
-- Brewbean’s has a BB_PRODUCT_REQUEST table where requests to refill stock levels are
-- inserted automatically via a trigger. After the stock level falls below the reorder level, this trigger
-- fires and enters a request in the table. This procedure works great; however, when store clerks
-- record that the product request has been filled by updating the table’s DTRECD and COST
-- columns, they want the stock level in the product table to be updated. Create a trigger named
-- BB_REQFILL_TRG to handle this task, using the following steps as a guideline:
-- 1. In SQL Developer, run the following INSERT statement to create a product request you can
-- use in this assignment:
-- INSERT INTO bb_product_request (idRequest, idProduct, dtRequest, qty)
-- VALUES (3, 5, SYSDATE, 45);
-- COMMIT;
-- 2. Create the trigger (BB_REQFILL_TRG) so that it fires when a received date is entered in the
-- BB_PRODUCT_REQUEST table. This trigger needs to modify the STOCK column in the
-- BB_PRODUCT table to reflect the increased inventory.
-- 3. Now test the trigger. First, query the stock and reorder data for product 5, as shown in
-- Figure 9-38.
-- SELECT stock, reorder FROM bb_product
-- WHERE idProduct = 5;
-- SELECT *
-- FROM bb_product_request WHERE idProduct = 5;
-- FIGURE 9-38 Querying the data for product 5 stock and reorder amount
-- 4. Now update the product request to record it as fulfilled by using the UPDATE statement
-- shown in Figure 9-39.
-- UPDATE
-- bb_product_request
-- SET dtRecd= SYSDATE, cost = 225
-- WHERE idRequest = 3;
-- SELECT *
-- FROM bb_product_request WHERE idProduct = 5;
-- SELECT stock, reorder FROM bb_product
-- WHERE idProduct = 5;
-- 5. Issue queries to verify that the trigger fired and the stock level of product 5 has been
-- modified correctly. Then issue a ROLLBACK statement to undo the modifications.
-- 6. If you aren’t doing Assignment 9-3, disable the trigger so that it doesn’t affect
-- other assignments.

-- Insert a product request
INSERT INTO bb_product_request (
  idRequest,
  idProduct,
  dtRequest,
  qty
) VALUES (
  3,
  5,
  SYSDATE,
  45
);

COMMIT;

-- Create the trigger
CREATE OR REPLACE TRIGGER BB_REQFILL_TRG AFTER
  UPDATE OF dtRecd, cost ON bb_product_request FOR EACH ROW
BEGIN
  IF :OLD.dtRecd IS NULL AND :NEW.dtRecd IS NOT NULL THEN -- Check if dtRecd is updated
 -- Update stock level in bb_product table
    UPDATE bb_product
    SET
      stock = stock + :NEW.qty
    WHERE
      idProduct = :NEW.idProduct;
  END IF;
END;
/

-- Test the trigger
-- Query stock and reorder data for product 5
SELECT
  stock,
  reorder
FROM
  bb_product
WHERE
  idProduct = 5;

SELECT
  *
FROM
  bb_product_request
WHERE
  idProduct = 5;

-- Update the product request to record it as fulfilled
UPDATE bb_product_request
SET
  dtRecd = SYSDATE,
  cost = 225
WHERE
  idRequest = 3;

SELECT
  *
FROM
  bb_product_request
WHERE
  idProduct = 5;

SELECT
  stock,
  reorder
FROM
  bb_product
WHERE
  idProduct = 5;

-- Verify trigger fired and stock level modified correctly
-- Rollback changes
ROLLBACK;

-- Disable the trigger (if not needed for other assignments)
-- ALTER TRIGGER BB_REQFILL_TRG DISABLE;

-- Assignment 9-3: Updating the Stock Level If a Product Fulfillment Is Canceled
-- The Brewbean’s developers have made progress on the inventory-handling processes;
-- however, they hit a snag when a store clerk incorrectly recorded a product request as fulfilled.
-- When the product request was updated to record a DTRECD value, the product’s stock level
-- was updated automatically via an existing trigger, BB_REQFILL_TRG. If the clerk empties the
-- DTRECD column to indicate that the product request hasn’t been filled, the product’s stock
-- level needs to be corrected or reduced, too. Modify the BB_REQFILL_TRG trigger to solve
-- this problem.
-- 1. Modify the trigger code from Assignment 9-2 as needed. Add code to check whether the
-- DTRECD column already has a date in it and is now being set to NULL.
-- 2. Issue the following DML actions to create and update rows that you can use to test
-- the trigger:
-- INSERT INTO bb_product_request (idRequest, idProduct, dtRequest, qty,
-- dtRecd, cost)
-- VALUES (4, 5, SYSDATE, 45, '15-JUN-2012',225);
-- UPDATE bb_product
-- SET stock = 86
-- WHERE idProduct = 5;
-- COMMIT;
-- 3. Run the following UPDATE statement to test the trigger, and issue queries to verify that the
-- data has been modified correctly.
-- UPDATE bb_product_request
-- SET dtRecd = NULL
-- WHERE idRequest = 4;
-- 4. Be sure to run the following statement to disable this trigger so that it doesn’t affect other
-- assignments:
-- ALTER TRIGGER bb_reqfill_trg DISABLE;
-- Create the trigger
CREATE OR REPLACE TRIGGER BB_REQFILL_TRG AFTER
  UPDATE OF dtRecd, cost ON bb_product_request FOR EACH ROW
BEGIN
  -- Check if dtRecd is updated from not null to null
  IF :OLD.dtRecd IS NOT NULL AND :NEW.dtRecd IS NULL THEN
    -- Reduce stock level in bb_product table
    UPDATE bb_product
    SET
      stock = stock - :OLD.qty
    WHERE
      idProduct = :NEW.idProduct;
  ELSIF :OLD.dtRecd IS NULL AND :NEW.dtRecd IS NOT NULL THEN
    -- Update stock level in bb_product table
    UPDATE bb_product
    SET
      stock = stock + :NEW.qty
    WHERE
      idProduct = :NEW.idProduct;
  END IF;
END;
/

-- Test the trigger
-- Insert a product request
INSERT INTO bb_product_request (
  idRequest,
  idProduct,
  dtRequest,
  qty
) VALUES (
  4,
  5,
  SYSDATE,
  45
);
COMMIT;

-- Update the product stock to a specific value
UPDATE bb_product
SET
  stock = 86
WHERE
  idProduct = 5;
COMMIT;

-- Update the product request to record it as unfulfilled
UPDATE bb_product_request
SET
  dtRecd = NULL
WHERE
  idRequest = 4;

-- Query to verify data modifications
SELECT * FROM bb_product_request WHERE idRequest = 4;
SELECT stock FROM bb_product WHERE idProduct = 5;

-- Disable the trigger (if not needed for other assignments)
ALTER TRIGGER BB_REQFILL_TRG DISABLE;


-- Assignment 9-4: Updating Stock Levels When an Order Is Canceled
-- At times, customers make mistakes in submitting orders and call to cancel an order. Brewbean’s
-- wants to create a trigger that automatically updates the stock level of all products associated
-- with a canceled order and updates the ORDERPLACED column of the BB_BASKET table to
-- zero, reflecting that the order wasn’t completed. Create a trigger named BB_ORDCANCEL_TRG to
-- perform this task, taking into account the following points:
-- • The trigger needs to fire when a new status record is added to the
-- BB_BASKETSTATUS table and when the IDSTAGE column is set to 4,
-- which indicates an order has been canceled.
--  Each basket can contain multiple items in the BB_BASKETITEM table, so a
-- CURSOR FOR loop might be a suitable mechanism for updating each item’s stock
-- level.
-- • Keep in mind that coffee can be ordered in half or whole pounds.
-- • Use basket 6, which contains two items, for testing.
-- 1. Run this INSERT statement to test the trigger:
-- INSERT INTO bb_basketstatus (idStatus, idBasket, idStage, dtStage)
-- VALUES (bb_status_seq.NEXTVAL, 6, 4, SYSDATE);
-- 2. Issue queries to confirm that the trigger has modified the basket’s order status and product
-- stock levels correctly.
-- 3. Be sure to run the following statement to disable this trigger so that it doesn’t affect other
-- assignments:
-- ALTER TRIGGER bb_ordcancel_trg DISABLE;

CREATE OR REPLACE TRIGGER BB_ORDCANCEL_TRG AFTER
  INSERT ON BB_BASKETSTATUS FOR EACH ROW WHEN (NEW.IDSTAGE = 4)
DECLARE
  CURSOR c_basket_items IS
  SELECT
    idProduct,
    Quantity,
    option1,
    option2
  FROM
    bb_basketItem
  WHERE
    idBasket = :NEW.idBasket;
BEGIN
 -- Update stock levels for each item in the canceled order
  FOR item_rec IN c_basket_items LOOP
    UPDATE bb_product
    SET
      stock = stock + item_rec.Quantity * CASE WHEN item_rec.option1 IS NOT NULL THEN (
        SELECT
          Price
        FROM
          bb_ProductOption
        WHERE
          idProduct = item_rec.idProduct
          AND idProductOption = item_rec.option1
      ) ELSE 1 END * CASE WHEN item_rec.option2 IS NOT NULL THEN (
        SELECT
          Price
        FROM
          bb_ProductOption
        WHERE
          idProduct = item_rec.idProduct
          AND idProductOption = item_rec.option2
      ) ELSE 1 END
    WHERE
      idProduct = item_rec.idProduct;
  END LOOP;
 -- Update ORDERPLACED column of BB_BASKET table to zero
  UPDATE bb_basket
  SET
    OrderPlaced = 0
  WHERE
    idBasket = :NEW.idBasket;
END;
/

INSERT INTO bb_basketstatus (
  idStatus,
  idBasket,
  idStage,
  dtStage
) VALUES (
  bb_status_seq.NEXTVAL,
  6,
  4,
  SYSDATE
);

ALTER TRIGGER bb_ordcancel_trg DISABLE;

-- Assignment 9-5: Processing Discounts
-- Brewbean’s is offering a new discount for return shoppers: Every fifth completed order gets a
-- 10% discount. The count of orders for a shopper is placed in a packaged variable named
-- pv_disc_num during the ordering process. This count needs to be tested at checkout to
-- determine whether a discount should be applied. Create a trigger named BB_DISCOUNT_TRG
-- so that when an order is confirmed (the ORDERPLACED value is changed from 0 to 1), the
-- pv_disc_num packaged variable is checked. If it’s equal to 5, set a second variable named
-- pv_disc_txt to Y. This variable is used in calculating the order summary so that a discount is
-- applied, if necessary.
-- Create a package specification named DISC_PKG containing the necessary packaged
-- variables. Use an anonymous block to initialize the packaged variables to use for testing the
-- trigger. Test the trigger with the following UPDATE statement:
-- UPDATE bb_basket
-- SET orderplaced = 1
-- WHERE idBasket = 13;
-- If you need to test the trigger multiple times, simply reset the ORDERPLACED column to 0
-- for basket 13 and then run the UPDATE again. Also, disable this trigger when you’re finished so
-- that it doesn’t affect other assignments.
CREATE OR REPLACE PACKAGE DISC_PKG AS
  pv_disc_num NUMBER;
  pv_disc_txt VARCHAR2(1);
END DISC_PKG;
/

CREATE OR REPLACE TRIGGER BB_DISCOUNT_TRG AFTER
  UPDATE OF orderplaced ON bb_basket FOR EACH ROW
BEGIN
  IF :NEW.orderplaced = 1 THEN
    IF DISC_PKG.pv_disc_num = 5 THEN
      DISC_PKG.pv_disc_txt := 'Y';
    END IF;
  END IF;
END;
/

BEGIN
  DISC_PKG.pv_disc_num := 5; -- Set the count of orders for testing
  DISC_PKG.pv_disc_txt := 'N'; -- Initialize pv_disc_txt
END;
/

UPDATE bb_basket
SET
  orderplaced = 1
WHERE
  idBasket = 13;

ALTER TRIGGER BB_DISCOUNT_TRG DISABLE;

-- Assignment 9-6: Using Triggers to Maintain Referential Integrity
-- At times, Brewbean’s has changed the ID numbers for existing products. In the past, developers
-- had to add a new product row with the new ID to the BB_PRODUCT table, modify all the
-- corresponding BB_BASKETITEM and BB_PRODUCTOPTION table rows, and then delete the
-- original product row. Can a trigger be developed to avoid all these steps and handle the update
-- of the BB_BASKETITEM and BB_PRODUCTOPTION table rows automatically for a change in
-- product ID? If so, create the trigger and test it by issuing an UPDATE statement that changes the
-- IDPRODUCT 7 to 22. Do a rollback to return the data to its original state, and disable the new
-- trigger after you have finished this assignment.
CREATE OR REPLACE TRIGGER BB_PRODUCT_ID_UPDATE_TRG AFTER
  UPDATE OF IDPRODUCT ON BB_PRODUCT FOR EACH ROW
BEGIN
 -- Update BB_BASKETITEM table
  UPDATE BB_BASKETITEM
  SET
    IDPRODUCT = :NEW.IDPRODUCT
  WHERE
    IDPRODUCT = :OLD.IDPRODUCT;
 -- Update BB_PRODUCTOPTION table
  UPDATE BB_PRODUCTOPTION
  SET
    IDPRODUCT = :NEW.IDPRODUCT
  WHERE
    IDPRODUCT = :OLD.IDPRODUCT;
END;
/

UPDATE BB_PRODUCT
SET
  IDPRODUCT = 22
WHERE
  IDPRODUCT = 7;

ROLLBACK;

ALTER TRIGGER BB_PRODUCT_ID_UPDATE_TRG DISABLE;

-- Assignment 9-7: Updating Summary Data Tables
-- The Brewbean’s owner uses several summary sales data tables every day to monitor business
-- activity. The BB_SALES_SUM table holds the product ID, total sales in dollars, and total
-- quantity sold for each product. A trigger is needed so that every time an order is confirmed or
-- the ORDERPLACED column is updated to 1, the BB_SALES_SUM table is updated
-- accordingly. Create a trigger named BB_SALESUM_TRG that performs this task. Before testing,
-- reset the ORDERPLACED column to 0 for basket 3, as shown in the following code, and use
-- this basket to test the trigger:
-- UPDATE bb_basket
-- SET orderplaced = 0
-- WHERE idBasket = 3;
-- Notice that the BB_SALES_SUM table already contains some data. Test the trigger with
-- the following UPDATE statement, and confirm that the trigger is working correctly:
-- UPDATE bb_basket
-- SET orderplaced = 1
-- WHERE idBasket = 3;
-- Do a rollback and disable the trigger when you’re finished so that it doesn’t affect other
-- assignments.
CREATE TABLE BB_SALES_SUM (
  idProduct NUMBER(2),
  TotalSales NUMBER(6, 2),
  TotalQtySold NUMBER(5)
);

ALTER TABLE BB_SALES_SUM ADD CONSTRAINT pk_bb_sales_sum PRIMARY KEY (idProduct);

UPDATE bb_basket
SET
  orderplaced = 0
WHERE
  idBasket = 3;

CREATE OR REPLACE TRIGGER BB_SALESUM_TRG AFTER
  UPDATE OF orderplaced ON bb_basket FOR EACH ROW WHEN (NEW.orderplaced = 1)
BEGIN
  FOR cur IN (
    SELECT
      idProduct,
      SUM(Price * Quantity) AS TotalSales,
      SUM(Quantity)         AS TotalQty
    FROM
      bb_basketItem
    WHERE
      idBasket = :NEW.idBasket
    GROUP BY
      idProduct
  ) LOOP
    UPDATE BB_SALES_SUM
    SET
      TotalSales = TotalSales + cur.TotalSales,
      TotalQtySold = TotalQtySold + cur.TotalQty
    WHERE
      idProduct = cur.idProduct;
    IF SQL%NOTFOUND THEN
      INSERT INTO BB_SALES_SUM (
        idProduct,
        TotalSales,
        TotalQtySold
      ) VALUES (
        cur.idProduct,
        cur.TotalSales,
        cur.TotalQty
      );
    END IF;
  END LOOP;
END;
/

UPDATE bb_basket
SET
  orderplaced = 1
WHERE
  idBasket = 3;

ROLLBACK;

ALTER TRIGGER BB_SALESUM_TRG DISABLE;

-- Assignment 9-8: Maintaining an Audit Trail of Product Table Changes
-- The accuracy of product table data is critical, and the Brewbean’s owner wants to have an audit
-- file containing information on all DML activity on the BB_PRODUCT table. This information
-- should include the ID of the user performing the DML action, the date, the original values of the
-- changed row, and the new values. This audit table needs to track specific columns of concern,
-- including PRODUCTNAME, PRICE, SALESTART, SALEEND, and SALEPRICE. Create a table
-- named BB_PRODCHG_AUDIT to hold the relevant data, and then create a trigger named
-- BB_AUDIT_TRG that fires an update to this table whenever a specified column in the
-- BB_PRODUCT table changes.
-- TIP
-- Multiple columns can be listed in a trigger’s OF clause by separating them with commas.
-- Be sure to issue the following command. If you created the SALES_DATE_TRG trigger in the
-- chapter, it conflicts with this assignment.
-- ALTER TRIGGER sales_date_trg DISABLE;
-- Use the following UPDATE statement to test the trigger:
-- UPDATE bb_product
-- SET salestart = '05-MAY-2012',
-- saleend = '12-MAY-2012'
-- saleprice = 9
-- WHERE idProduct = 10;
-- When you’re finished, do a rollback and disable the trigger so that it doesn’t affect other
-- assignments.

CREATE TABLE BB_PRODCHG_AUDIT (
  Audit_ID NUMBER GENERATED BY DEFAULT AS IDENTITY,
  User_ID VARCHAR2(10),
  Change_Date DATE,
  Product_ID NUMBER,
  Column_Name VARCHAR2(25),
  Old_Value VARCHAR2(100),
  New_Value VARCHAR2(100)
);

CREATE OR REPLACE TRIGGER BB_AUDIT_TRG AFTER
  UPDATE OF PRODUCTNAME, PRICE, SALESTART, SALEEND, SALEPRICE ON BB_PRODUCT FOR EACH ROW
DECLARE
  V_Old_ProductName BB_PRODUCT.PRODUCTNAME%TYPE;
  V_Old_Price       BB_PRODUCT.PRICE%TYPE;
  V_Old_SaleStart   BB_PRODUCT.SALESTART%TYPE;
  V_Old_SaleEnd     BB_PRODUCT.SALEEND%TYPE;
  V_Old_SalePrice   BB_PRODUCT.SALEPRICE%TYPE;
BEGIN
  IF UPDATING THEN
    IF :OLD.PRODUCTNAME <> :NEW.PRODUCTNAME THEN
      INSERT INTO BB_PRODCHG_AUDIT (
        User_ID,
        Change_Date,
        Product_ID,
        Column_Name,
        Old_Value,
        New_Value
      ) VALUES (
        USER,
        SYSDATE,
        :OLD.IDPRODUCT,
        'PRODUCTNAME',
        :OLD.PRODUCTNAME,
        :NEW.PRODUCTNAME
      );
    END IF;

    IF :OLD.PRICE <> :NEW.PRICE THEN
      INSERT INTO BB_PRODCHG_AUDIT (
        User_ID,
        Change_Date,
        Product_ID,
        Column_Name,
        Old_Value,
        New_Value
      ) VALUES (
        USER,
        SYSDATE,
        :OLD.IDPRODUCT,
        'PRICE',
        TO_CHAR(:OLD.PRICE),
        TO_CHAR(:NEW.PRICE)
      );
    END IF;

    IF :OLD.SALESTART <> :NEW.SALESTART THEN
      INSERT INTO BB_PRODCHG_AUDIT (
        User_ID,
        Change_Date,
        Product_ID,
        Column_Name,
        Old_Value,
        New_Value
      ) VALUES (
        USER,
        SYSDATE,
        :OLD.IDPRODUCT,
        'SALESTART',
        TO_CHAR(:OLD.SALESTART),
        TO_CHAR(:NEW.SALESTART)
      );
    END IF;

    IF :OLD.SALEEND <> :NEW.SALEEND THEN
      INSERT INTO BB_PRODCHG_AUDIT (
        User_ID,
        Change_Date,
        Product_ID,
        Column_Name,
        Old_Value,
        New_Value
      ) VALUES (
        USER,
        SYSDATE,
        :OLD.IDPRODUCT,
        'SALEEND',
        TO_CHAR(:OLD.SALEEND),
        TO_CHAR(:NEW.SALEEND)
      );
    END IF;

    IF :OLD.SALEPRICE <> :NEW.SALEPRICE THEN
      INSERT INTO BB_PRODCHG_AUDIT (
        User_ID,
        Change_Date,
        Product_ID,
        Column_Name,
        Old_Value,
        New_Value
      ) VALUES (
        USER,
        SYSDATE,
        :OLD.IDPRODUCT,
        'SALEPRICE',
        TO_CHAR(:OLD.SALEPRICE),
        TO_CHAR(:NEW.SALEPRICE)
      );
    END IF;
  END IF;
END;
/

-- Update statement to test the trigger
UPDATE bb_product
SET
  salestart = '05-MAY-2012',
  saleend = '12-MAY-2012',
  saleprice = 9
WHERE
  idProduct = 10;

-- Rollback changes
ROLLBACK;

-- Disable the trigger
ALTER TRIGGER BB_AUDIT_TRG DISABLE;
