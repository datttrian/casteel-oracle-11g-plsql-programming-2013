-- Assignment 5-1: Creating a Procedure
-- Use these steps to create a procedure that allows a company employee to make corrections to
-- a product’s assigned name. Review the BB_PRODUCT table and identify the PRODUCT NAME
-- and PRIMARY KEY columns. The procedure needs two IN parameters to identify the product
-- ID and supply the new description. This procedure needs to perform only a DML action, so no
-- OUT parameters are necessary.
-- 1. In SQL Developer, create the following procedure:
-- CREATE OR REPLACE PROCEDURE prod_name_sp
-- (p_prodid IN bb_product.idproduct%TYPE,
-- p_descrip IN bb_product.description%TYPE)
-- IS
-- BEGIN
-- UPDATE bb_product
-- SET description = p_descrip
-- WHERE idproduct = p_prodid;
-- COMMIT;
-- END;
-- 2. Before testing the procedure, verify the current description value for product ID 1 with
-- SELECT * FROM bb_product;.
-- 3. Call the procedure with parameter values of 1 for the product ID and CapressoBar Model
-- #388 for the description.
-- 4. Verify that the update was successful by querying the table with SELECT * FROM
-- bb_product;.

-- Step 1: Create the procedure
CREATE OR REPLACE PROCEDURE prod_name_sp (
  p_prodid IN bb_product.idProduct%TYPE,
  p_descrip IN bb_product.Description%TYPE
) IS
BEGIN
  UPDATE bb_product
  SET
    Description = p_descrip
  WHERE
    idProduct = p_prodid;
  COMMIT;
END;
/

-- Step 2: Verify the current description value
SELECT
  *
FROM
  bb_product;

-- Step 3: Call the procedure
BEGIN
  prod_name_sp(1, 'CapressoBar Model #388');
END;
/

-- Step 4: Verify that the update was successful
SELECT
  *
FROM
  bb_product;

-- Assignment 5-2: Using a Procedure with IN Parameters
-- Follow these steps to create a procedure that allows a company employee to add a new
-- product to the database. This procedure needs only IN parameters.
-- 1. In SQL Developer, create a procedure named PROD_ADD_SP that adds a row for a new
-- product in the BB_PRODUCT table. Keep in mind that the user provides values for the
-- product name, description, image filename, price, and active status. Address the input
-- values or parameters in the same order as in the preceding sentence.
-- 2. Call the procedure with these parameter values: ('Roasted Blend', 'Well-balanced
-- mix of roasted beans, a medium body', 'roasted.jpg',9.50,1).
-- 3. Check whether the update was successful by querying the BB_PRODUCT table.

-- Step 1: Create the procedure
CREATE OR REPLACE PROCEDURE PROD_ADD_SP (
  p_product_name IN VARCHAR2,
  p_description IN VARCHAR2,
  p_image_filename IN VARCHAR2,
  p_price IN NUMBER,
  p_active_status IN NUMBER
) AS
BEGIN
  INSERT INTO BB_PRODUCT (
    product_name,
    description,
    image_filename,
    price,
    active_status
  ) VALUES (
    p_product_name,
    p_description,
    p_image_filename,
    p_price,
    p_active_status
  );
  COMMIT;
END;
/

-- Step 2: Call the procedure with the specified parameter values
BEGIN
  PROD_ADD_SP('Roasted Blend', 'Well-balanced mix of roasted beans, a medium body', 'roasted.jpg', 9.50, 1);
END;
/

-- Step 3: Check whether the update was successful by querying the BB_PRODUCT table
SELECT
  *
FROM
  BB_PRODUCT;

-- Assignment 5-3: Calculating the Tax on an Order
-- Follow these steps to create a procedure for calculating the tax on an order. The BB_TAX table
-- contains states that require submitting taxes for Internet sales. If the state isn’t listed in the
-- table, no tax should be assessed on the order. The shopper’s state and basket subtotal are the
-- inputs to the procedure, and the tax amount should be returned.
-- 1. In SQL Developer, create a procedure named TAX_COST_SP. Remember that the state
-- and subtotal values are inputs to the procedure, which should return the tax amount.
-- Review the BB_TAX table, which contains the tax rate for each applicable state.
-- 2. Call the procedure with the values VA for the state and $100 for the subtotal. Display the
-- tax amount the procedure returns. (It should be $4.50.)

-- Step 1: Create the procedure
CREATE OR REPLACE PROCEDURE TAX_COST_SP (
  p_state IN VARCHAR2,
  p_subtotal IN NUMBER,
  p_tax OUT NUMBER
) AS
BEGIN
  SELECT
    TaxRate INTO p_tax
  FROM
    bb_tax
  WHERE
    State = p_state;
  IF p_tax IS NULL THEN
    p_tax := 0;
  ELSE
    p_tax := p_subtotal * p_tax;
  END IF;
END TAX_COST_SP;
/

-- Step 2: Call the procedure with the specified parameter values
DECLARE
  lv_state    VARCHAR2(2) := 'VA';
  lv_subtotal NUMBER := 100;
  lv_tax      NUMBER;
BEGIN
  TAX_COST_SP(lv_state, lv_subtotal, lv_tax);
  DBMS_OUTPUT.PUT_LINE('Tax Amount: $'
                       || TO_CHAR(lv_tax, '999.99'));
END;

-- Assignment 5-4: Updating Columns in a Table
-- After a shopper completes an order, a procedure is called to update the following columns in the
-- BASKET table: ORDERPLACED, SUBTOTAL, SHIPPING, TAX, and TOTAL. The value 1
-- entered in the ORDERPLACED column indicates that the shopper has completed an order.
-- Inputs to the procedure are the basket ID and amounts for the subtotal, shipping, tax, and total.
-- 1. In SQL Developer, create a procedure named BASKET_CONFIRM_SP that accepts the input
-- values specified in the preceding description. Keep in mind that you’re modifying an existing
-- row of the BB_BASKET table in this procedure.
-- 2. Enter the following statements to create a new basket containing two items:
-- INSERT INTO BB_BASKET (IDBASKET, QUANTITY, IDSHOPPER,
-- ORDERPLACED, SUBTOTAL, TOTAL,
-- SHIPPING, TAX, DTCREATED, PROMO)
-- VALUES (17, 2, 22, 0, 0, 0, 0, 0, '28-FEB-12', 0);
-- INSERT INTO BB_BASKETITEM (IDBASKETITEM, IDPRODUCT, PRICE,
-- QUANTITY, IDBASKET, OPTION1, OPTION2)
-- VALUES (44, 7, 10.8, 3, 17, 2, 3);
-- INSERT INTO BB_BASKETITEM (IDBASKETITEM, IDPRODUCT, PRICE,
-- QUANTITY, IDBASKET, OPTION1, OPTION2)
-- VALUES (45, 8, 10.8, 3, 17, 2, 3);
-- 3. Type and run COMMIT; to save the data from these statements.
-- 4. Call the procedure with the following parameter values: 17, 64.80, 8.00, 1.94, 74.74.
-- As mentioned, these values represent the basket ID and the amounts for the subtotal,
-- shipping, tax, and total.
-- 5. Query the BB_BASKET table to confirm that the procedure was successful:
-- SELECT subtotal, shipping, tax, total, orderplaced
-- FROM bb_basket
-- WHERE idbasket = 17;.

-- Step 1: Create the procedure
CREATE OR REPLACE PROCEDURE BASKET_CONFIRM_SP (
  p_idbasket IN BB_BASKET.IDBASKET%TYPE,
  p_subtotal IN BB_BASKET.SUBTOTAL%TYPE,
  p_shipping IN BB_BASKET.SHIPPING%TYPE,
  p_tax IN BB_BASKET.TAX%TYPE,
  p_total IN BB_BASKET.TOTAL%TYPE
) IS
BEGIN
  UPDATE BB_BASKET
  SET
    ORDERPLACED = 1,
    SUBTOTAL = p_subtotal,
    SHIPPING = p_shipping,
    TAX = p_tax,
    TOTAL = p_total
  WHERE
    IDBASKET = p_idbasket;
  COMMIT;
END;
/

-- Step 2: Execute the provided INSERT statements to create a new basket and basket items
INSERT INTO BB_BASKET (
  IDBASKET,
  QUANTITY,
  IDSHOPPER,
  ORDERPLACED,
  SUBTOTAL,
  TOTAL,
  SHIPPING,
  TAX,
  DTCREATED,
  PROMO
) VALUES (
  17,
  2,
  22,
  0,
  0,
  0,
  0,
  0,
  TO_DATE('28-FEB-12', 'DD-MON-YY'),
  0
);

INSERT INTO BB_BASKETITEM (
  IDBASKETITEM,
  IDPRODUCT,
  PRICE,
  QUANTITY,
  IDBASKET,
  OPTION1,
  OPTION2
) VALUES (
  44,
  7,
  10.8,
  3,
  17,
  2,
  3
);

INSERT INTO BB_BASKETITEM (
  IDBASKETITEM,
  IDPRODUCT,
  PRICE,
  QUANTITY,
  IDBASKET,
  OPTION1,
  OPTION2
) VALUES (
  45,
  8,
  10.8,
  3,
  17,
  2,
  3
);

COMMIT;

-- Step 3: Commit the transaction to save the data
COMMIT;

-- Step 4: Call the procedure with the provided parameter values
BEGIN
  BASKET_CONFIRM_SP(17, 64.80, 8.00, 1.94, 74.74);
END;
/

-- Step 5: Query the BB_BASKET table to confirm the changes
SELECT
  subtotal,
  shipping,
  tax,
  total,
  orderplaced
FROM
  bb_basket
WHERE
  idbasket = 17;

-- Assignment 5-5: Updating Order Status
-- Create a procedure named STATUS_SHIP_SP that allows an employee in the Shipping
-- Department to update an order status to add shipping information. The BB_BASKETSTATUS
-- table lists events for each order so that a shopper can see the current status, date, and
-- comments as each stage of the order process is finished. The IDSTAGE column of the
-- BB_BASKETSTATUS table identifies each stage; the value 3 in this column indicates that an
-- order has been shipped.
-- The procedure should allow adding a row with an IDSTAGE of 3, date shipped, tracking
-- number, and shipper. The BB_STATUS_SEQ sequence is used to provide a value for the primary
-- key column. Test the procedure with the following information:
-- Basket # = 3
-- Date shipped = 20-FEB-12
-- Shipper = UPS
-- Tracking # = ZW2384YXK4957

-- Step 1: Create the procedure
CREATE OR REPLACE PROCEDURE STATUS_SHIP_SP (
  p_basket_id IN bb_basket.idBasket%TYPE,
  p_date_shipped IN DATE,
  p_tracking_number IN VARCHAR2,
  p_shipper IN VARCHAR2
) AS
  v_status_id bb_basketstatus.idStatus%TYPE;
BEGIN
 -- Get the next sequence value for the status ID
  SELECT
    bb_status_seq.NEXTVAL INTO v_status_id
  FROM
    dual;
 -- Insert the shipping information into bb_basketstatus table
  INSERT INTO bb_basketstatus (
    idStatus,
    idBasket,
    idStage,
    dtStage,
    shipper,
    ShippingNum
  ) VALUES (
    v_status_id,
    p_basket_id,
    3,
    p_date_shipped,
    p_shipper,
    p_tracking_number
  );
 -- Update the shipflag in bb_basket table
  UPDATE bb_basket
  SET
    shipflag = 'Y'
  WHERE
    idBasket = p_basket_id;
 -- Commit the transaction
  COMMIT;
 -- Display success message
  DBMS_OUTPUT.PUT_LINE('Order status updated successfully.');
EXCEPTION
  WHEN OTHERS THEN
 -- Rollback the transaction if an error occurs
    ROLLBACK;
 -- Display error message
    DBMS_OUTPUT.PUT_LINE('Error updating order status: '
                         || SQLERRM);
END STATUS_SHIP_SP;
/

-- Step 2: Test the procedure with the provided information
BEGIN
  STATUS_SHIP_SP(3, TO_DATE('20-FEB-12', 'DD-MON-YY'), 'UPS', 'ZW2384YXK4957');
END;

-- Assignment 5-6: Returning Order Status Information
-- Create a procedure that returns the most recent order status information for a specified basket.
-- This procedure should determine the most recent ordering-stage entry in the BB_BASKETSTATUS
-- table and return the data. Use an IF or CASE clause to return a stage description instead
-- of an IDSTAGE number, which means little to shoppers. The IDSTAGE column of the
-- BB_BASKETSTATUS table identifies each stage as follows:
-- • 1—Submitted and received
-- • 2—Confirmed, processed, sent to shipping
-- • 3—Shipped
-- • 4—Cancelled
-- • 5—Back-ordered
-- The procedure should accept a basket ID number and return the most recent status
-- description and date the status was recorded. If no status is available for the specified basket
-- ID, return a message stating that no status is available. Name the procedure STATUS_SP. Test
-- the procedure twice with the basket ID 4 and then 6.

CREATE OR REPLACE PROCEDURE STATUS_SP (
  basket_id_param IN bb_basket.idBasket%TYPE,
  status_desc OUT VARCHAR2,
  status_date OUT DATE
) AS
  lv_status_id bb_basketstatus.idStatus%TYPE;
  lv_stage_id  bb_basketstatus.idStage%TYPE;
BEGIN
 -- Get the most recent status ID for the specified basket ID
  SELECT
    MAX(idStatus) INTO lv_status_id
  FROM
    bb_basketstatus
  WHERE
    idBasket = basket_id_param;
 -- Check if there is a status available for the specified basket ID
  IF lv_status_id IS NOT NULL THEN
 -- Get the stage ID and status date for the most recent status
    SELECT
      idStage,
      dtStage INTO lv_stage_id,
      status_date
    FROM
      bb_basketstatus
    WHERE
      idStatus = lv_status_id;
 -- Return the stage description based on the stage ID
    CASE lv_stage_id
      WHEN 1 THEN
        status_desc := 'Submitted and received';
      WHEN 2 THEN
        status_desc := 'Confirmed, processed, sent to shipping';
      WHEN 3 THEN
        status_desc := 'Shipped';
      WHEN 4 THEN
        status_desc := 'Cancelled';
      WHEN 5 THEN
        status_desc := 'Back-ordered';
    END CASE;
  ELSE
 -- If no status is available for the specified basket ID, return a message
    status_desc := 'No status available';
    status_date := NULL;
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    status_desc := 'No status available';
    status_date := NULL;
END STATUS_SP;
/

DECLARE
  lv_status_desc VARCHAR2(100);
  lv_status_date DATE;
BEGIN
 -- Test with basket ID 4
  STATUS_SP(4, lv_status_desc, lv_status_date);
  DBMS_OUTPUT.PUT_LINE('Basket 4 Status: '
                       || lv_status_desc
                       || ' (Date: '
                       || TO_CHAR(v_status_date, 'DD-MON-YYYY')
                          || ')');
 -- Test with basket ID 6
  STATUS_SP(6, lv_status_desc, lv_status_date);
  DBMS_OUTPUT.PUT_LINE('Basket 6 Status: '
                       || lv_status_desc
                       || ' (Date: '
                       || TO_CHAR(v_status_date, 'DD-MON-YYYY')
                          || ')');
END;

-- Assignment 5-7: Identifying Customers
-- Brewbean’s wants to offer an incentive of free shipping to customers who haven’t returned to
-- the site since a specified date. Create a procedure named PROMO_SHIP_SP that determines
-- who these customers are and then updates the BB_PROMOLIST table accordingly. The
-- procedure uses the following information:
-- • Date cutoff—Any customers who haven’t shopped on the site since this date
-- should be included as incentive participants. Use the basket creation date to
-- reflect shopper activity dates.
-- • Month—A three-character month (such as APR) should be added to the promotion
-- table to indicate which month free shipping is effective.
-- • Year—A four-digit year indicates the year the promotion is effective.
-- • promo_flag—1 represents free shipping.
-- The BB_PROMOLIST table also has a USED column, which contains the default value N
-- and is updated to Y when the shopper uses the promotion. Test the procedure with the cutoff
-- date 15-FEB-12. Assign free shipping for the month APR and the year 2012.

CREATE OR REPLACE PROCEDURE PROMO_SHIP_SP (
  p_cutoff_date IN DATE,
  p_month IN VARCHAR2,
  p_year IN NUMBER
) AS
BEGIN
 -- Identify customers who haven't shopped since the cutoff date
  FOR customer IN (
    SELECT
      DISTINCT bs.IDSHOPPER
    FROM
      BB_BASKET bs
    WHERE
      bs.DTCREATED < p_cutoff_date
      AND NOT EXISTS (
        SELECT
          1
        FROM
          BB_BASKET bs2
        WHERE
          bs2.IDSHOPPER = bs.IDSHOPPER
          AND bs2.DTCREATED > p_cutoff_date
      )
  ) LOOP
 -- Update BB_PROMOLIST for each eligible customer
    INSERT INTO BB_PROMOLIST (
      IDSHOPPER,
      MONTH,
      YEAR,
      PROMO_FLAG,
      USED
    ) VALUES (
      customer.IDSHOPPER,
      p_month,
      p_year,
      1,
      'N'
    );
  END LOOP;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Promotion records updated successfully.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: '
                         || SQLERRM);
END;
/

BEGIN
  PROMO_SHIP_SP(TO_DATE('15-FEB-12', 'DD-MON-YYYY'), 'APR', 2012);
END;

-- Assignment 5-8: Adding Items to a Basket
-- As a shopper selects products on the Brewbean’s site, a procedure is needed to add a newly
-- selected item to the current shopper’s basket. Create a procedure named BASKET_ADD_SP that
-- accepts a product ID, basket ID, price, quantity, size code option (1 or 2), and form code option
-- (3 or 4) and uses this information to add a new item to the BB_BASKETITEM table. The table’s
-- PRIMARY KEY column is generated by BB_IDBASKETITEM_SEQ. Run the procedure with the
-- following values:
-- • Basket ID—14
-- • Product ID—8
-- • Price—10.80
-- • Quantity—1
-- • Size code—2
-- • Form code—4

CREATE OR REPLACE PROCEDURE BASKET_ADD_SP (
  p_basket_id IN NUMBER,
  p_product_id IN NUMBER,
  p_price IN NUMBER,
  p_quantity IN NUMBER,
  p_size_code IN NUMBER,
  p_form_code IN NUMBER
) AS
BEGIN
  INSERT INTO BB_BASKETITEM (
    IDBASKETITEM,
    IDPRODUCT,
    PRICE,
    QUANTITY,
    IDBASKET,
    OPTION1,
    OPTION2
  ) VALUES (
    BB_IDBASKETITEM_SEQ.NEXTVAL,
    p_product_id,
    p_price,
    p_quantity,
    p_basket_id,
    p_size_code,
    p_form_code
  );
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Item added to basket successfully.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: '
                         || SQLERRM);
END;
/

BEGIN
  BASKET_ADD_SP(14, 8, 10.80, 1, 2, 4);
END;

-- Assignment 5-9: Creating a Logon Procedure
-- The home page of the Brewbean’s Web site has an option for members to log on with their IDs
-- and passwords. Develop a procedure named MEMBER_CK_SP that accepts the ID and password
-- as inputs, checks whether they make up a valid logon, and returns the member name and cookie
-- value. The name should be returned as a single text string containing the first and last name.
-- The head developer wants the number of parameters minimized so that the same
-- parameter is used to accept the password and return the name value. Also, if the user doesn’t
-- enter a valid username and password, return the value INVALID in a parameter named
-- p_check. Test the procedure using a valid logon first, with the username rat55 and password
-- kile. Then try it with an invalid logon by changing the username to rat.

CREATE OR REPLACE PROCEDURE MEMBER_CK_SP (
  p_username IN VARCHAR2,
  p_password IN VARCHAR2,
  p_check OUT VARCHAR2,
  p_member_name OUT VARCHAR2,
  p_cookie OUT NUMBER
) IS
  lv_member_name VARCHAR2(50);
BEGIN
 -- Check if the username and password are valid
  SELECT
    FirstName
    || ' '
    || LastName INTO lv_member_name
  FROM
    bb_shopper
  WHERE
    UserName = p_username
    AND Password = p_password;
 -- If a member with the provided username and password is found
 -- Set p_check to 'VALID', return member name and cookie value
  p_check := 'VALID';
  p_member_name := lv_member_name;
  p_cookie := dbms_random.value(1, 9999); -- Generating a random cookie value
EXCEPTION
 -- If no member is found or an exception occurs, set p_check to 'INVALID'
  WHEN NO_DATA_FOUND THEN
    p_check := 'INVALID';
    p_member_name := NULL;
    p_cookie := NULL;
  WHEN OTHERS THEN
    p_check := 'INVALID';
    p_member_name := NULL;
    p_cookie := NULL;
END MEMBER_CK_SP;
/

DECLARE
  lv_check       VARCHAR2(10);
  lv_member_name VARCHAR2(50);
  lv_cookie      NUMBER;
BEGIN
 -- Testing with valid logon credentials
  MEMBER_CK_SP('rat55', 'kile', lv_check, lv_member_name, lv_cookie);
  DBMS_OUTPUT.PUT_LINE('Check: '
                       || lv_check);
  IF lv_check = 'VALID' THEN
    DBMS_OUTPUT.PUT_LINE('Member Name: '
                         || lv_member_name);
    DBMS_OUTPUT.PUT_LINE('Cookie: '
                         || lv_cookie);
  END IF;
 -- Testing with invalid logon credentials
  MEMBER_CK_SP('rat', 'password', lv_check, lv_member_name, lv_cookie);
  DBMS_OUTPUT.PUT_LINE('Check: '
                       || lv_check);
END;
