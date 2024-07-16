-- Assignment 6-1: Formatting Numbers as Currency
-- Many of the Brewbean’s application pages and reports generated from the database display
-- dollar amounts. Follow these steps to create a function that formats the number provided as
-- an argument with a dollar sign, commas, and two decimal places:
-- 1. Create a function named DOLLAR_FMT_SF with the following code:
-- CREATE OR REPLACE FUNCTION dollar_fmt_sf
-- (p_num NUMBER)
-- RETURN VARCHAR2
-- IS
-- lv_amt_txt VARCHAR2(20);
-- BEGIN
-- lv_amt_txt := TO_CHAR(p_num,'$99,999.99');
-- RETURN lv_amt_txt;
-- END;
-- 2. Test the function by running the following anonymous PL/SQL block. Your results should
-- match Figure 6-23.
-- DECLARE
-- lv_amt_num NUMBER(8,2) := 9999.55;
-- BEGIN
-- DBMS_OUTPUT.PUT_LINE(dollar_fmt_sf(lv_amt_num));
-- END;
-- 3. Test the function with the following SQL statement. Your results should match Figure 6-24.
-- SELECT dollar_fmt_sf(shipping), dollar_fmt_sf(total)
-- FROM bb_basket
-- WHERE idBasket = 3;

-- Step 1: Create a function named DOLLAR_FMT_SF
CREATE OR REPLACE FUNCTION dollar_fmt_sf (
  p_num NUMBER
) RETURN VARCHAR2 IS
  lv_amt_txt VARCHAR2(20);
BEGIN
  lv_amt_txt := TO_CHAR(p_num, '$99,999.99');
  RETURN lv_amt_txt;
END;
/

-- Step 2: Test the function by running the following anonymous PL/SQL block
DECLARE
  lv_amt_num NUMBER(8, 2) := 9999.55;
BEGIN
  DBMS_OUTPUT.PUT_LINE(dollar_fmt_sf(lv_amt_num));
END;
/

-- Step 3: Test the function with the following SQL statement
SELECT
  dollar_fmt_sf(shipping),
  dollar_fmt_sf(total)
FROM
  bb_basket
WHERE
  idBasket = 3;

-- Assignment 6-2: Calculating a Shopper’s Total Spending
-- Many of the reports generated from the system calculate the total dollars in a shopper’s
-- purchases. Follow these steps to create a function named TOT_PURCH_SF that accepts a
-- shopper ID as input and returns the total dollars the shopper has spent with Brewbean’s. Use
-- the function in a SELECT statement that shows the shopper ID and total purchases for every
-- shopper in the database.
-- 1. Develop and run a CREATE FUNCTION statement to create the TOT_PURCH_SF function.
-- The function code needs a formal parameter for the shopper ID and to sum the TOTAL
-- column of the BB_BASKET table.
-- 2. Develop a SELECT statement, using the BB_SHOPPER table, to produce a list of each
-- shopper in the database and his or her total purchases.

-- Step 1: Create the function TOT_PURCH_SF
CREATE OR REPLACE FUNCTION TOT_PURCH_SF(
  shopper_id IN NUMBER
) RETURN NUMBER IS
  total_spent NUMBER(7, 2);
BEGIN
 -- Calculate the total dollars spent by the shopper
  SELECT
    SUM(b.Total) INTO total_spent
  FROM
    bb_basket b
  WHERE
    b.idShopper = shopper_id;
  RETURN total_spent;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0;
END;
/

-- Step 2: Use the function in a SELECT statement
SELECT
  idShopper,
  TOT_PURCH_SF(idShopper) AS Total_Purchases
FROM
  bb_shopper;

-- Assignment 6-3: Calculating a Shopper’s Total Number of Orders
-- Another commonly used statistic in reports is the total number of orders a shopper has placed.
-- Follow these steps to create a function named NUM_PURCH_SF that accepts a shopper ID and
-- returns a shopper’s total number of orders. Use the function in a SELECT statement to display
-- the number of orders for shopper 23.
-- 1. Develop and run a CREATE FUNCTION statement to create the NUM_PURCH_SF function.
-- The function code needs to tally the number of orders (using an Oracle built-in function)
-- by shopper. Keep in mind that the ORDERPLACED column contains a 1 if an order has
-- been placed.
-- 2. Create a SELECT query by using the NUM_PURCH_SF function on the IDSHOPPER column
-- of the BB_SHOPPER table. Be sure to select only shopper 23.

-- Step 1: Create the function NUM_PURCH_SF
CREATE OR REPLACE FUNCTION NUM_PURCH_SF(
  p_shopper_id IN NUMBER
) RETURN NUMBER AS
  lv_total_orders NUMBER;
BEGIN
 -- Count the total number of orders for the specified shopper
  SELECT
    COUNT(*) INTO lv_total_orders
  FROM
    bb_basket
  WHERE
    idShopper = p_shopper_id
    AND orderplaced = 1; -- considering 'orderplaced' column contains 1 for placed orders
  RETURN lv_total_orders;
END;
/

-- Step 2: Use the function to display the number of orders for shopper 23
SELECT
  NUM_PURCH_SF(23) AS Total_Orders
FROM
  dual;

-- Assignment 6-4: Identifying the Weekday for an Order Date
-- The day of the week that baskets are created is often analyzed to determine consumershopping patterns. Create a function named DAY_ORD_SF that accepts an order date and
-- returns the weekday. Use the function in a SELECT statement to display each basket ID and the
-- weekday the order was created. Write a second SELECT statement, using this function to
-- display the total number of orders for each weekday. (Hint: Call the TO_CHAR function to retrieve
-- the weekday from a date.)
-- 1. Develop and run a CREATE FUNCTION statement to create the DAY_ORD_SF function. Use
-- the DTCREATED column of the BB_BASKET table as the date the basket is created. Call
-- the TO_CHAR function with the DAY option to retrieve the weekday for a date value.
-- 2. Create a SELECT statement that lists the basket ID and weekday for every basket.
-- 3. Create a SELECT statement, using a GROUP BY clause to list the total number of baskets
-- per weekday. Based on the results, what’s the most popular shopping day?

-- 1. Create the DAY_ORD_SF function
CREATE OR REPLACE FUNCTION DAY_ORD_SF(
  order_date IN DATE
) RETURN VARCHAR2 IS
BEGIN
  RETURN TO_CHAR(order_date, 'Day');
END;
/

-- 2. Use the function to display each basket ID and the weekday
SELECT
  idBasket,
  DAY_ORD_SF(dtCreated) AS weekday
FROM
  bb_basket;

-- 3. Use the function in another SELECT statement with a GROUP BY clause
--    to list the total number of baskets per weekday
SELECT
  DAY_ORD_SF(dtCreated) AS weekday,
  COUNT(*)              AS total_orders
FROM
  bb_basket
GROUP BY
  DAY_ORD_SF(dtCreated)
ORDER BY
  total_orders DESC;

-- Assignment 6-5: Calculating Days Between Ordering and Shipping
-- An analyst in the quality assurance office reviews the time elapsed between receiving an order
-- and shipping the order. Any orders that haven’t been shipped within a day of the order being
-- placed are investigated. Create a function named ORD_SHIP_SF that calculates the number of
-- days between the basket’s creation date and the shipping date. The function should return a
-- character string that states OK if the order was shipped within a day or CHECK if it wasn’t. If the
-- order hasn’t shipped, return the string Not shipped. The IDSTAGE column of the
-- BB_BASKETSTATUS table indicates a shipped item with the value 5, and the DTSTAGE
-- column is the shipping date. The DTORDERED column of the BB_BASKET table is the order
-- date. Review data in the BB_BASKETSTATUS table, and create an anonymous block to test all
-- three outcomes the function should handle.
CREATE OR REPLACE FUNCTION ORD_SHIP_SF(
  p_basket_id IN NUMBER
) RETURN VARCHAR2 AS
  lv_ship_date  DATE;
  lv_order_date DATE;
  lv_days_diff  NUMBER;
  lv_status_id  NUMBER;
BEGIN
 -- Retrieve shipping date and order date
  SELECT
    bs.dtstage,
    b.dtordered,
    bs.idstage INTO lv_ship_date,
    lv_order_date,
    lv_status_id
  FROM
    bb_basketstatus bs
    JOIN bb_basket b
    ON bs.idbasket = b.idbasket
  WHERE
    b.idbasket = p_basket_id
    AND bs.idstage = 5; -- Assuming IDSTAGE 5 indicates shipped status
 -- If the order hasn't been shipped, return 'Not shipped'
  IF lv_ship_date IS NULL THEN
    RETURN 'Not shipped';
  ELSE
 -- Calculate days difference
    lv_days_diff := lv_ship_date - lv_order_date;
 -- If shipped within a day, return 'OK'
    IF lv_days_diff <= 1 THEN
      RETURN 'OK';
    ELSE
      RETURN 'CHECK';
    END IF;
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'No such basket found';
END;
/

-- Anonymous block to test the function
DECLARE
  lv_result VARCHAR2(20);
BEGIN
 -- Test case 1: Order shipped within a day
  lv_result := ORD_SHIP_SF(3); -- Assuming basket ID 3
  DBMS_OUTPUT.PUT_LINE('Result for Basket 3: '
                       || lv_result);
 -- Test case 2: Order shipped after a day
  lv_result := ORD_SHIP_SF(4); -- Assuming basket ID 4
  DBMS_OUTPUT.PUT_LINE('Result for Basket 4: '
                       || lv_result);
 -- Test case 3: Order not yet shipped
  lv_result := ORD_SHIP_SF(7); -- Assuming basket ID 7
  DBMS_OUTPUT.PUT_LINE('Result for Basket 7: '
                       || lv_result);
END;

-- Assignment 6-6: Adding Descriptions for Order Status Codes
-- When a shopper returns to the Web site to check an order’s status, information from the
-- BB_BASKETSTATUS table is displayed. However, only the status code is available in the
-- BB_BASKETSTATUS table, not the status description. Create a function named STATUS_DESC_SF
-- that accepts a stage ID and returns the status description. The descriptions for stage IDs
-- are listed in Table 6-3. Test the function in a SELECT statement that retrieves all rows in the
-- BB_BASKETSTATUS table for basket 4 and displays the stage ID and its description.
-- Create the function STATUS_DESC_SF
CREATE OR REPLACE FUNCTION STATUS_DESC_SF(
  stage_id IN NUMBER
) RETURN VARCHAR2 IS
  status_desc VARCHAR2(100);
BEGIN
  CASE stage_id
    WHEN 1 THEN
      status_desc := 'Order submitted';
    WHEN 2 THEN
      status_desc := 'Accepted, sent to shipping';
    WHEN 3 THEN
      status_desc := 'Back-ordered';
    WHEN 4 THEN
      status_desc := 'Cancelled';
    WHEN 5 THEN
      status_desc := 'Shipped';
    ELSE
      status_desc := 'Unknown';
  END CASE;

  RETURN status_desc;
END STATUS_DESC_SF;
/

-- Test the function using a SELECT statement
SELECT
  bs.idStage,
  STATUS_DESC_SF(bs.idStage) AS Status_Description
FROM
  bb_basketstatus bs
WHERE
  bs.idBasket = 4;

-- Assignment 6-7: Calculating an Order’s Tax Amount
-- Create a function named TAX_CALC_SF that accepts a basket ID, calculates the tax amount
-- by using the basket subtotal, and returns the correct tax amount for the order. The tax is
-- determined by the shipping state, which is stored in the BB_BASKET table. The BB_TAX table
-- contains the tax rate for states that require taxes on Internet purchases. If the state isn’t listed
-- in the tax table or no shipping state is assigned to the basket, a tax amount of zero should be
-- applied to the order. Use the function in a SELECT statement that displays the shipping costs for
-- a basket that has tax applied and a basket with no shipping state.
-- TABLE 6-3 Basket Stage Descriptions
-- Stage ID Description
-- 1 Order submitted
-- 2 Accepted, sent to shipping
-- 3 Back-ordered
-- 4 Cancelled
-- 5 Shipped
-- Step 1: Define the function TAX_CALC_SF
CREATE OR REPLACE FUNCTION TAX_CALC_SF(
  basket_id IN NUMBER
) RETURN NUMBER AS
  tax_amount NUMBER(5, 2);
BEGIN
 -- Step 2: Calculate the tax based on the shipping state
  SELECT
    COALESCE(SUM(b.SubTotal * t.TaxRate), 0) INTO tax_amount
  FROM
    bb_basket b
    LEFT JOIN bb_tax t
    ON b.ShipState = t.State
  WHERE
    b.idBasket = basket_id;
  RETURN tax_amount;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0;
END TAX_CALC_SF;
/

-- Step 3: Use the function in a SELECT statement
SELECT
  idBasket,
  SubTotal,
  TAX_CALC_SF(idBasket) AS TaxAmount,
  Shipping
FROM
  bb_basket;

-- Assignment 6-8: Identifying Sale Products
-- When a product is placed on sale, Brewbean’s records the sale’s start and end dates in
-- columns of the BB_PRODUCT table. A function is needed to provide sales information when a
-- shopper selects an item. If a product is on sale, the function should return the value ON SALE!.
-- However, if it isn’t on sale, the function should return the value Great Deal!. These values are
-- used on the product display page. Create a function named CK_SALE_SF that accepts a date and
-- product ID as arguments, checks whether the date falls within the product’s sale period, and returns
-- the corresponding string value. Test the function with the product ID 6 and two dates: 10-JUN-12
-- and 19-JUN-12. Verify your results by reviewing the product sales information.
CREATE OR REPLACE FUNCTION CK_SALE_SF(
  p_date DATE,
  p_product_id NUMBER
) RETURN VARCHAR2 IS
  lv_sale_start DATE;
  lv_sale_end   DATE;
  lv_sale_price NUMBER(6, 2);
BEGIN
 -- Retrieve sale start date, end date, and sale price for the given product ID
  SELECT
    SaleStart,
    SaleEnd,
    SalePrice INTO lv_sale_start,
    lv_sale_end,
    lv_sale_price
  FROM
    bb_product
  WHERE
    idProduct = p_product_id;
 -- Check if the provided date falls within the sale period
  IF p_date BETWEEN lv_sale_start AND lv_sale_end THEN
    RETURN 'ON SALE!';
  ELSE
    RETURN 'Great Deal!';
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'Product not found';
END CK_SALE_SF;
/

-- Test the function with the provided product ID (6) and two dates
SELECT
  CK_SALE_SF('10-JUN-2012', 6) AS Sale_Info_1,
  CK_SALE_SF('19-JUN-2012', 6) AS Sale_Info_2
FROM
  dual;

-- Assignment 6-9: Determining the Monthly Payment Amount
-- Create a function named DD_MTHPAY_SF that calculates and returns the monthly payment
-- amount for donor pledges paid on a monthly basis. Input values should be the number of
-- monthly payments and the pledge amount. Use the function in an anonymous PL/SQL block
-- to show its use with the following pledge information: pledge amount = $240 and monthly
-- payments = 12. Also, use the function in an SQL statement that displays information for all
-- donor pledges in the database on a monthly payment plan.
CREATE OR REPLACE FUNCTION DD_MTHPAY_SF(
  lv_paymonths IN NUMBER,
  lv_pledgeamt IN NUMBER
) RETURN NUMBER IS
  lv_monthly_payment NUMBER;
BEGIN
  lv_monthly_payment := lv_pledgeamt / lv_paymonths;
  RETURN lv_monthly_payment;
END DD_MTHPAY_SF;
/

-- Anonymous PL/SQL block demonstrating the use of the function
DECLARE
  lv_pledge_amount          NUMBER := 240;
  lv_monthly_payments       NUMBER := 12;
  lv_monthly_payment_amount NUMBER;
BEGIN
  lv_monthly_payment_amount := DD_MTHPAY_SF(lv_monthly_payments, lv_pledge_amount);
  DBMS_OUTPUT.PUT_LINE('Monthly payment amount for the pledge: $'
                       || lv_monthly_payment_amount);
END;
/

-- SQL statement to display information for all donor pledges in the database on a monthly payment plan
SELECT
  dp.idPledge,
  dp.idDonor,
  d.Firstname
  || ' '
  || d.Lastname                            AS Donor_Name,
  dp.Pledgeamt                             AS Pledge_Amount,
  dp.paymonths                             AS Payment_Months,
  DD_MTHPAY_SF(dp.paymonths, dp.Pledgeamt) AS Monthly_Payment_Amount
FROM
  dd_pledge dp
  JOIN dd_donor d
  ON dp.idDonor = d.idDonor
WHERE
  dp.paymonths > 0;

-- Assignment 6-10: Calculating the Total Project Pledge Amount
-- Create a function named DD_PROJTOT_SF that determines the total pledge amount for a project.
-- Use the function in an SQL statement that lists all projects, displaying project ID, project name,
-- and project pledge total amount. Format the pledge total to display zero if no pledges have been
-- made so far, and have it show a dollar sign, comma, and two decimal places for dollar values.
CREATE OR REPLACE FUNCTION DD_PROJTOT_SF(
  lv_project_id IN NUMBER
) RETURN NUMBER IS
  lv_total_pledge_amount NUMBER;
BEGIN
  SELECT
    NVL(SUM(Pledgeamt), 0) INTO lv_total_pledge_amount
  FROM
    dd_pledge
  WHERE
    idProj = lv_project_id;
  RETURN lv_total_pledge_amount;
END DD_PROJTOT_SF;
/

SELECT
  idProj,
  Projname,
  TO_CHAR(DD_PROJTOT_SF(idProj), '$999,999,999.99') AS Project_Pledge_Total
FROM
  dd_project;

-- Assignment 6-11: Identifying Pledge Status
-- The DoGood Donor organization decided to reduce SQL join activity in its application by
-- eliminating the DD_STATUS table and replacing it with a function that returns a status description
-- based on the status ID value. Create this function and name it DD_PLSTAT_SF. Use the function
-- in an SQL statement that displays the pledge ID, pledge date, and pledge status for all pledges.
-- Also, use it in an SQL statement that displays the same values but for only a specified pledge.

CREATE OR REPLACE FUNCTION DD_PLSTAT_SF(
  lv_status_id IN NUMBER
) RETURN VARCHAR2 IS
  lv_status_desc VARCHAR2(15);
BEGIN
  CASE lv_status_id
    WHEN 10 THEN
      lv_status_desc := 'Open';
    WHEN 20 THEN
      lv_status_desc := 'Complete';
    WHEN 30 THEN
      lv_status_desc := 'Overdue';
    WHEN 40 THEN
      lv_status_desc := 'Closed';
    WHEN 50 THEN
      lv_status_desc := 'Hold';
    ELSE
      lv_status_desc := 'Unknown';
  END CASE;

  RETURN lv_status_desc;
END DD_PLSTAT_SF;
/

SELECT
  idPledge,
  Pledgedate,
  DD_PLSTAT_SF(idStatus) AS Pledge_Status
FROM
  dd_pledge;

SELECT
  idPledge,
  Pledgedate,
  DD_PLSTAT_SF(idStatus) AS Pledge_Status
FROM
  dd_pledge
WHERE
  idPledge = :specified_pledge_id;

-- Assignment 6-12: Determining a Pledge’s First Payment Date
-- Create a function named DD_PAYDATE1_SF that determines the first payment due date for a
-- pledge based on pledge ID. The first payment due date is always the first day of the month
-- after the date the pledge was made, even if a pledge is made on the first of a month. Keep in
-- mind that a pledge made in December should reflect a first payment date with the following
-- year. Use the function in an anonymous block.
CREATE OR REPLACE FUNCTION DD_PAYDATE1_SF(
  lv_pledge_id IN NUMBER
) RETURN DATE IS
  lv_pledge_date        DATE;
  lv_first_payment_date DATE;
BEGIN
 -- Get the pledge date for the given pledge ID
  SELECT
    Pledgedate INTO lv_pledge_date
  FROM
    dd_pledge
  WHERE
    idPledge = lv_pledge_id;
 -- Calculate the first payment date
  IF EXTRACT(MONTH FROM lv_pledge_date) = 12 THEN
 -- If pledge made in December, first payment is in January of next year
    lv_first_payment_date := ADD_MONTHS(TRUNC(lv_pledge_date, 'YYYY'), 1);
  ELSE
 -- Otherwise, first payment is in the next month
    lv_first_payment_date := ADD_MONTHS(lv_pledge_date, 1);
  END IF;

  RETURN lv_first_payment_date;
END DD_PAYDATE1_SF;
/

DECLARE
  lv_pledge_id          NUMBER := 104; -- Replace with the desired pledge ID
  lv_first_payment_date DATE;
BEGIN
  lv_first_payment_date := DD_PAYDATE1_SF(lv_pledge_id);
  DBMS_OUTPUT.PUT_LINE('First payment due date for pledge '
                       || lv_pledge_id
                       || ': '
                       || TO_CHAR(lv_first_payment_date, 'DD-MON-YYYY'));
END;

-- Assignment 6-13: Determining a Pledge’s Final Payment Date
-- Create a function named DD_PAYEND_SF that determines the final payment date for a pledge
-- based on pledge ID. Use the function created in Assignment 6-12 in this new function to help
-- with the task. If the donation pledge indicates a lump sum payment, the final payment date is
-- the same as the first payment date. Use the function in an anonymous block.
CREATE OR REPLACE FUNCTION DD_PAYEND_SF(
  lv_pledge_id IN NUMBER
) RETURN DATE IS
  lv_final_payment_date DATE;
  lv_paymonths          NUMBER;
BEGIN
 -- Get the number of payment months for the given pledge ID
  SELECT
    paymonths INTO lv_paymonths
  FROM
    dd_pledge
  WHERE
    idPledge = lv_pledge_id;
  IF lv_paymonths IS NULL OR lv_paymonths = 0 THEN
 -- If lump sum payment, final payment date is the same as the first payment date
    lv_final_payment_date := DD_PAYDATE1_SF(lv_pledge_id);
  ELSE
 -- Calculate final payment date based on the first payment date and payment months
    lv_final_payment_date := ADD_MONTHS(DD_PAYDATE1_SF(lv_pledge_id), lv_paymonths);
  END IF;

  RETURN lv_final_payment_date;
END DD_PAYEND_SF;
/

DECLARE
  lv_pledge_id          NUMBER := 104; -- Replace with the desired pledge ID
  lv_final_payment_date DATE;
BEGIN
  lv_final_payment_date := DD_PAYEND_SF(lv_pledge_id);
  DBMS_OUTPUT.PUT_LINE('Final payment date for pledge '
                       || lv_pledge_id
                       || ': '
                       || TO_CHAR(lv_final_payment_date, 'DD-MON-YYYY'));
END;

-- Case 6-1: Updating Basket Data at Order Completion
-- A number of functions created in this chapter assume that the basket amounts, including
-- shipping, tax, and total, are already posted to the BB_BASKET table. However, the program
-- units for updating these columns when a shopper checks out haven’t been developed yet.
-- A procedure is needed to update the following columns in the BB_BASKET table when an order
-- is completed: ORDERPLACED, SUBTOTAL, SHIPPING, TAX, and TOTAL.
-- Construct three functions to perform the following tasks: calculating the subtotal by using
-- the BB_BASKETITEM table based on basket ID as input, calculating shipping costs based on
-- basket ID as input, and calculating the tax based on basket ID and subtotal as input. Use these
-- functions in a procedure.
-- A value of 1 entered in the ORDERPLACED column indicates that the shopper has
-- completed the order. The subtotal is determined by totaling the item lines of the BB_BASKETITEM
-- table for the applicable basket number. The shipping cost is based on the number of items in the
-- basket: 1 to 4 = $5, 5 to 9 = $8, and more than 10 = $11.
-- The tax is based on the rate applied by referencing the SHIPSTATE column of the
-- BB_BASKET table with the STATE column of the BB_TAX table. This rate should be multiplied
-- by the basket subtotal, which should be an INPUT parameter to the tax calculation because
-- the subtotal is being calculated in this same procedure. The total tallies all these amounts.
-- The only INPUT parameter for the procedure is a basket ID. The procedure needs to
-- update the correct row in the BB_BASKET table with all these amounts. To test, first set
-- all column values to NULL for basket 3 with the following UPDATE statement. Then call the
-- procedure for basket 3 and check the INSERT results.
-- UPDATE bb_basket
-- SET orderplaced = NULL,
-- Subtotal = NULL,
-- Tax = NULL,
-- Shipping = NULL,
-- Total = NULL
-- WHERE idBasket = 3;
-- COMMIT;
CREATE OR REPLACE FUNCTION CalculateSubtotal(
  basket_id IN NUMBER
) RETURN NUMBER IS
  total_price NUMBER(7, 2);
BEGIN
  SELECT
    SUM(bi.Price * bi.Quantity) INTO total_price
  FROM
    bb_BasketItem bi
  WHERE
    bi.idBasket = basket_id;
  RETURN total_price;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0; -- No items in the basket
END CalculateSubtotal;
/

CREATE OR REPLACE FUNCTION CalculateShipping(
  basket_id IN NUMBER
) RETURN NUMBER IS
  num_items     INTEGER;
  shipping_cost NUMBER(5, 2);
BEGIN
  SELECT
    COUNT(*) INTO num_items
  FROM
    bb_BasketItem
  WHERE
    idBasket = basket_id;
  IF num_items BETWEEN 1 AND 4 THEN
    shipping_cost := 5.00;
  ELSIF num_items BETWEEN 5 AND 9 THEN
    shipping_cost := 8.00;
  ELSE
    shipping_cost := 11.00;
  END IF;

  RETURN shipping_cost;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0; -- No items in the basket
END CalculateShipping;
/

CREATE OR REPLACE FUNCTION CalculateTax(
  basket_id IN NUMBER,
  subtotal IN NUMBER
) RETURN NUMBER IS
  state_tax_rate NUMBER(4, 3);
  tax_amount     NUMBER(5, 2);
BEGIN
  SELECT
    t.TaxRate INTO state_tax_rate
  FROM
    bb_Tax    t
    JOIN bb_Basket b
    ON t.State = b.ShipState
  WHERE
    b.idBasket = basket_id;
  tax_amount := subtotal * state_tax_rate;
  RETURN tax_amount;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0; -- Tax rate not found for the state
END CalculateTax;
/

CREATE OR REPLACE PROCEDURE UpdateBasketData(
  basket_id IN NUMBER
) IS
  subtotal NUMBER(7, 2);
  shipping NUMBER(5, 2);
  tax      NUMBER(5, 2);
  total    NUMBER(7, 2);
BEGIN
  subtotal := CalculateSubtotal(basket_id);
  shipping := CalculateShipping(basket_id);
  tax := CalculateTax(basket_id, subtotal);
  total := subtotal + shipping + tax;
  UPDATE bb_Basket
  SET
    ORDERPLACED = 1,
    SUBTOTAL = subtotal,
    SHIPPING = shipping,
    TAX = tax,
    TOTAL = total
  WHERE
    idBasket = basket_id;
  COMMIT;
END UpdateBasketData;
/

BEGIN
  UpdateBasketData(3);
END;
/

-- Case 6-2: Working with More Movies Rentals
-- More Movies receives numerous requests to check whether movies are in stock. The company
-- needs a function that retrieves movie stock information and formats a clear message to display
-- to users requesting information. The display should resemble the following: “Star Wars is
-- Available: 11 on the shelf.”
-- Use movie ID as the input value for this function. Assume the MOVIE_QTY column in the
-- MM_MOVIES table indicates the number of movies currently available for checkout.
CREATE OR REPLACE FUNCTION get_movie_stock(
  movie_id_in NUMBER
) RETURN VARCHAR2 IS
  lv_movie_title mm_movie.movie_title%TYPE;
  lv_movie_qty   mm_movie.movie_qty%TYPE;
  lv_message     VARCHAR2(100);
BEGIN
 -- Retrieve movie title and quantity based on movie ID
  SELECT
    movie_title,
    movie_qty INTO lv_movie_title,
    lv_movie_qty
  FROM
    mm_movie
  WHERE
    movie_id = movie_id_in;
 -- Construct message
  lv_message := lv_movie_title
               || ' is ';
  IF lv_movie_qty > 0 THEN
    lv_message := lv_message
                 || 'Available: '
                 || lv_movie_qty
                 || ' on the shelf.';
  ELSE
    lv_message := lv_message
                 || 'Not available for rental at the moment.';
  END IF;
 -- Return the formatted message
  RETURN lv_message;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'Movie with ID '
           || movie_id_in
           || ' not found.';
END;
/

-- Example usage:
DECLARE
  lv_result VARCHAR2(100);
BEGIN
  lv_result := get_movie_stock(3); -- Check stock for "Star Wars"
  DBMS_OUTPUT.PUT_LINE(lv_result);
END;
