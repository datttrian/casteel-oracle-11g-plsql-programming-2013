-- Assignment 4-1: Using an Explicit Cursor
-- In the Brewbean’s application, a customer can ask to check whether all items in his or her
-- basket are in stock. In this assignment, you create a block that uses an explicit cursor to
-- retrieve all items in the basket and determine whether all items are in stock by comparing the
-- item quantity with the product stock amount. If all items are in stock, display the message
-- “All items in stock!” onscreen. If not, display the message “All items NOT in stock!” onscreen.
-- The basket number is provided with an initialized variable. Follow these steps:
-- 1. In SQL Developer, open the assignment04-01.sql file in the Chapter04 folder.
-- 2. Run the block. Notice that both a cursor and a record variable are created in the DECLARE
-- section. The cursor must be manipulated with explicit actions of OPEN, FETCH, and CLOSE.
-- A variable named lv_flag_txt is used to store the status of the stock check. The results
-- should look like Figure 4-33.

DECLARE
   CURSOR cur_basket IS
     SELECT bi.idBasket, bi.quantity, p.stock
       FROM bb_basketitem bi INNER JOIN bb_product p
         USING (idProduct)
       WHERE bi.idBasket = 6;
   TYPE type_basket IS RECORD (
     basket bb_basketitem.idBasket%TYPE,
     qty bb_basketitem.quantity%TYPE,
     stock bb_product.stock%TYPE);
   rec_basket type_basket;
   lv_flag_txt CHAR(1) := 'Y';
BEGIN
   OPEN cur_basket;
   LOOP 
     FETCH cur_basket INTO rec_basket;
      EXIT WHEN cur_basket%NOTFOUND;
      IF rec_basket.stock < rec_basket.qty THEN lv_flag_txt := 'N'; END IF;
   END LOOP;
   CLOSE cur_basket;
   IF lv_flag_txt = 'Y' THEN DBMS_OUTPUT.PUT_LINE('All items in stock!'); END IF;
   IF lv_flag_txt = 'N' THEN DBMS_OUTPUT.PUT_LINE('All items NOT in stock!'); END IF;   
END;

-- Assignment 4-2: Using a CURSOR FOR Loop
-- Brewbean’s wants to send a promotion via e-mail to shoppers. A shopper who has purchased
-- more than $50 at the site receives a $5 coupon for his or her next purchase over $25. A
-- shopper who has spent more than $100 receives a free shipping coupon.
-- The BB_SHOPPER table contains a column named PROMO for storing promotion codes.
-- Follow the steps to create a block with a CURSOR FOR loop to check the total spent by each
-- shopper and update the PROMO column in the BB_SHOPPER table accordingly. The cursor’s
-- SELECT statement contains a subquery in the FROM clause to retrieve the shopper totals
-- because a cursor using a GROUP BY statement can’t use the FOR UPDATE clause. Its results are
-- summarized data rather than separate rows from the database.
-- 1. In SQL Developer, open the assignment04-02.sql file in the Chapter04 folder.
-- 2. Run the block. Notice the subquery in the SELECT statement. Also, because an UPDATE is
-- performed, the FOR UPDATE and WHERE CURRENT OF clauses are used.
-- 3. Run a query, as shown in Figure 4-34, to check the results.

DECLARE
  CURSOR cur_shopper IS
  SELECT
    a.idShopper,
    a.promo,
    b.total
  FROM
    bb_shopper a,
    (
      SELECT
        b.idShopper,
        SUM(bi.quantity*bi.price) total
      FROM
        bb_basketitem bi,
        bb_basket     b
      WHERE
        bi.idBasket = b.idBasket
      GROUP BY
        idShopper
    )          b
  WHERE
    a.idShopper = b.idShopper FOR UPDATE OF a.idShopper NOWAIT;
  lv_promo_txt CHAR(1);
BEGIN
  FOR rec_shopper IN cur_shopper LOOP
    lv_promo_txt := 'X';
    IF rec_shopper.total > 100 THEN
      lv_promo_txt := 'A';
    END IF;

    IF rec_shopper.total BETWEEN 50 AND 99 THEN
      lv_promo_txt := 'B';
    END IF;

    IF lv_promo_txt <> 'X' THEN
      UPDATE bb_shopper
      SET
        promo = lv_promo_txt
      WHERE
        CURRENT OF cur_shopper;
    END IF;
  END LOOP;

  COMMIT;
END;
/

-- FIGURE 4-34 Querying the BB_SHOPPER table to check the PROMO column
SELECT
  idShopper,
  s.promo,
  SUM(bi.quantity*bi.price) total
FROM
  bb_shopper    s
  INNER JOIN bb_basket b
  USING (idShopper)
  INNER JOIN bb_basketitem bi
  USING (idBasket)
GROUP BY
  idShopper,
  s.promo
ORDER BY
  idShopper;

-- Assignment 4-3: Using Implicit Cursors
-- The BB_SHOPPER table in the Brewbean’s database contains a column named PROMO that
-- specifies promotions to send to shoppers. This column needs to be cleared after the promotion
-- has been sent. First, open the assignment04-03.txt file in the Chapter04 folder in a text
-- editor (such as Notepad). Run the UPDATE and COMMIT statements at the top of this file (not
-- the anonymous block at the end). Modify the anonymous block so that it displays the number of
-- rows updated onscreen. Run the block.

UPDATE bb_shopper
SET
  promo = NULL;

UPDATE bb_shopper
SET
  promo = 'B'
WHERE
  idShopper IN (21, 23, 25);

UPDATE bb_shopper
SET
  promo = 'A'
WHERE
  idShopper = 22;

COMMIT;

DECLARE
 -- Declare a variable to store the number of rows updated
  lv_rows_updated NUMBER;
BEGIN
 -- Update the bb_shopper table
  UPDATE bb_shopper
 -- Set the promo column to NULL where it is not already NULL
  SET
    promo = NULL
  WHERE
    promo IS NOT NULL;
 -- Store the number of rows affected by the update operation
  lv_rows_updated := SQL%ROWCOUNT;
 -- Output the number of rows updated to the console
  DBMS_OUTPUT.PUT_LINE('Number of rows updated: '
                       || lv_rows_updated);
END;
/

-- Query to count the number of rows in bb_shopper where promo is not NULL
SELECT
  COUNT(*)
FROM
  bb_shopper
WHERE
  promo IS NOT NULL;

-- Assignment 4-4: Using Exception Handling
-- In this assignment, you test a block containing a CASE statement for errors, and then add an
-- exception handler for a predefined exception:
-- 1. In Notepad, open the assignment04-04.sql file in the Chapter04 folder. Review the
-- block, which contains a CASE statement and no exception handlers.
-- 2. Copy and paste the block into SQL Developer, and run the block. Your results should
-- look like Figure 4-35. An error is raised because the state of NJ isn’t included in the CASE
-- statement; recall that a CASE statement must find a matching case.
-- 3. To correct this problem, add a predefined EXCEPTION handler that addresses this error
-- and displays “No tax” onscreen.
-- 4. Run the block again. Your results should look like Figure 4-36. Now the error is handled in
-- the block’s EXCEPTION section.

-- FIGURE 4-35 Raising an error with a CASE statement
DECLARE
  lv_tax_num NUMBER(2,2);
BEGIN
 CASE  'NJ' 
  WHEN 'VA' THEN lv_tax_num := .04;
  WHEN 'NC' THEN lv_tax_num := .02;  
  WHEN 'NY' THEN lv_tax_num := .06;  
 END CASE;
 DBMS_OUTPUT.PUT_LINE('tax rate = '||lv_tax_num);
END;
/

-- FIGURE 4-36 Using the CASE_NOT_FOUND exception handler
DECLARE
  lv_tax_num NUMBER (2,2);
BEGIN
  CASE 'NJ'
    WHEN 'VA' THEN lv_tax_num := 0.04;
    WHEN 'NO' THEN lv_tax_num := 0.02;
    WHEN 'NY' THEN lv_tax_num := 0.06;
  END CASE;
  
  DBMS_OUTPUT.PUT_LINE('tax rate = ' || lv_tax_num);
EXCEPTION
  WHEN CASE_NOT_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No tax');
END;

-- Assignment 4-5: Handling Predefined Exceptions
-- A block of code has been created to retrieve basic customer information (see the
-- assignment04-05.sql file in the Chapter04 folder). The application page was modified so
-- that an employee can enter a customer number that could cause an error. An exception handler
-- needs to be added to the block that displays the message “Invalid shopper ID” onscreen. Use
-- an initialized variable named lv_shopper_num to provide a shopper ID. Test the block with the
-- shopper ID 99.

DECLARE
  -- Declare a record variable to store data from the bb_shopper table
  rec_shopper    bb_shopper%ROWTYPE;
  -- Declare a variable to store the shopper ID, initialized to 99
  lv_shopper_num bb_shopper.idShopper%TYPE := 99;

BEGIN
  -- Attempt to select a record from the bb_shopper table where the idShopper matches lv_shopper_num
  SELECT
      * INTO rec_shopper
    FROM
      bb_shopper
    WHERE
      idShopper = lv_shopper_num;

  -- Exception handling block
  EXCEPTION
    -- If no data is found for the specified shopper ID, handle the NO_DATA_FOUND exception
    WHEN NO_DATA_FOUND THEN
      -- Output a message indicating that the shopper ID is invalid
      DBMS_OUTPUT.PUT_LINE('Invalid shopper ID');

END;

-- Assignment 4-6: Handling Exceptions with Undefined Errors
-- Brewbean’s wants to add a check constraint on the QUANTITY column of the
-- BB_BASKETITEM table. If a shopper enters a quantity value greater than 20 for an item,
-- Brewbean’s wants to display the message “Check Quantity” onscreen. Using a text editor, open
-- the assignment04-06.txt file in the Chapter04 folder. The first statement, ALTER TABLE,
-- must be executed to add the check constraint. The next item is a PL/SQL block containing an
-- INSERT action that tests this check constraint. Add code to this block to trap the check
-- constraint violation and display the message.
ALTER TABLE bb_basketitem ADD CONSTRAINT bitems_qty_ck CHECK (quantity < 20);

BEGIN
 -- Attempt to insert values into the bb_basketitem table
  INSERT INTO bb_basketitem VALUES (
    88,
    8,
    10.8,
    21,
    16,
    2,
    3
  );
 -- Handle any exception that occurs
  EXCEPTION
    WHEN OTHERS THEN
   -- Check if the exception is due to integrity constraint violation (-2290)
      IF SQLCODE = -2290 THEN
   -- Output a message indicating a constraint violation related to quantity
        DBMS_OUTPUT.PUT_LINE('Check Quantity');
      ELSE
   -- Re-raise the exception if it's not related to the specific constraint violation
        RAISE;
      END IF;
END;

-- Assignment 4-7: Handling Exceptions with User-Defined Errors
-- Sometimes Brewbean’s customers mistakenly leave an item out of a basket that’s already been
-- checked out, so they create a new basket containing the missing items. However, they request
-- FIGURE 4-36 Using the CASE_NOT_FOUND exception handler
-- that the baskets be combined so that they aren’t charged extra shipping. An application page
-- has been developed that enables employees to change the basket ID of items in the
-- BB_BASKETITEM table to another existing basket’s ID to combine the baskets. A block has
-- been constructed to support this page (see the assignment04−07.sql file in the Chapter04
-- folder). However, an exception handler needs to be added to trap the situation of an invalid
-- basket ID being entered for the original basket. In this case, the UPDATE affects no rows but
-- doesn’t raise an Oracle error. The handler should display the message “Invalid original basket
-- ID” onscreen. Use an initialized variable named lv_old_num with a value of 30 and another
-- named lv_new_num with a value of 4 to provide values to the block. First, verify that no item
-- rows with the basket ID 30 exist in the BB_BASKETITEM table.

DECLARE
  -- Declare variables to store the original and new basket IDs, and a count of basket items
  lv_old_num NUMBER := 30;
  lv_new_num NUMBER := 4;
  lv_count NUMBER;
BEGIN
  -- Count the number of items in the bb_basketitem table with the original basket ID
  SELECT
    COUNT(*) INTO lv_count
  FROM
    bb_basketitem
  WHERE
    idBasket = lv_old_num;
    
  -- Check if no items are found with the original basket ID
  IF lv_count = 0 THEN
    -- Output a message indicating no items were found with the original basket ID
    DBMS_OUTPUT.PUT_LINE('No items found with the original basket ID.');
  ELSE
    -- If items are found with the original basket ID, update the basket ID to the new value
    UPDATE bb_basketitem
    SET
      idBasket = lv_new_num
    WHERE
      idBasket = lv_old_num;
  END IF;
EXCEPTION
  -- Exception handling block to catch NO_DATA_FOUND exception
  WHEN NO_DATA_FOUND THEN
    -- Output a message indicating an invalid original basket ID
    DBMS_OUTPUT.PUT_LINE('Invalid original basket ID');
END;

-- Assignment 4-8: Processing and Updating a Group of Rows
-- To help track employee information, a new EMPLOYEE table was added to the Brewbean’s
-- database. Review the data in this table. A PL/SQL block is needed to calculate annual raises
-- and update employee salary amounts in the table. Create a block that addresses all the
-- requirements in the following list. All salaries in the EMPLOYEE table are recorded as
-- monthly amounts. Tip: Display the calculated salaries for verification before including the
-- update action.
-- • Calculate 6% annual raises for all employees except the president.
-- • If a 6% raise totals more than $2,000, cap the raise at $2,000.
-- • Update the salary for each employee in the table.
-- • For each employee number, display the current annual salary, raise, and proposed
-- new annual salary.
-- • Finally, following the details for each employee, show the total cost of all
-- employees’ salary increases for Brewbean’s.

DECLARE
  -- Declare constants for annual raise limit and raise percentage
  lv_annual_raise_limit    CONSTANT NUMBER := 2000;
  lv_raise_percentage      CONSTANT NUMBER := 0.06;
  -- Variable to store total salary increase
  lv_total_salary_increase NUMBER := 0;
  -- Cursor to select employee data
  CURSOR c_employee IS
  SELECT
    EMPNO,
    ENAME,
    SAL
  FROM
    EMPLOYEE
  WHERE
    JOB != 'PRESIDENT';
BEGIN
  -- Loop through each employee record fetched by the cursor
  FOR emp_rec IN c_employee LOOP
    -- Declare variables for raise amount and proposed salary
    DECLARE
      lv_raise_amount    NUMBER;
      lv_proposed_salary NUMBER;
    BEGIN
      -- Calculate raise amount based on raise percentage
      lv_raise_amount := emp_rec.SAL * lv_raise_percentage;
      -- Check if raise amount exceeds the annual raise limit
      IF lv_raise_amount > lv_annual_raise_limit THEN
        lv_raise_amount := lv_annual_raise_limit;
      END IF;

      -- Calculate proposed new salary after raise
      lv_proposed_salary := emp_rec.SAL + lv_raise_amount;
      
      -- Output information about employee's current salary, raise, and proposed new salary
      DBMS_OUTPUT.PUT_LINE('Employee '
                           || emp_rec.EMPNO
                           || ': '
                           || 'Current Salary: $'
                           || emp_rec.SAL
                           || ', '
                           || 'Raise: $'
                           || lv_raise_amount
                           || ', '
                           || 'Proposed New Salary: $'
                           || lv_proposed_salary);

      -- Update employee's salary in the EMPLOYEE table
      UPDATE EMPLOYEE
      SET
        SAL = lv_proposed_salary
      WHERE
        EMPNO = emp_rec.EMPNO;

      -- Add raise amount to total salary increase
      lv_total_salary_increase := lv_total_salary_increase + lv_raise_amount;
    END;
  END LOOP;
  -- Output total cost of salary increases
  DBMS_OUTPUT.PUT_LINE('Total Cost of Salary Increases: $'
                       || lv_total_salary_increase);
END;

-- Assignment 4-9: Using an Explicit Cursor
-- Create a block to retrieve and display pledge and payment information for a specific donor. For
-- each pledge payment from the donor, display the pledge ID, pledge amount, number of monthly
-- payments, payment date, and payment amount. The list should be sorted by pledge ID and then
-- by payment date. For the first payment made for each pledge, display “first payment” on that
-- output row.

DECLARE
 -- Variables to store pledge and payment information
  lv_pledge_id     dd_pledge.idPledge%TYPE;
  lv_pledge_amt    dd_pledge.Pledgeamt%TYPE;
  lv_paymonths     dd_pledge.paymonths%TYPE;
  lv_payment_id    dd_payment.idPay%TYPE;
  lv_payment_date  dd_payment.Paydate%TYPE;
  lv_payment_amt   dd_payment.Payamt%TYPE;
  lv_first_payment VARCHAR2(20);
 -- Cursor declaration
  CURSOR c_pledges IS
  SELECT
    p.idPledge,
    p.Pledgeamt,
    p.paymonths,
    pay.idPay,
    pay.Paydate,
    pay.Payamt
  FROM
    dd_pledge  p
    LEFT JOIN dd_payment pay
    ON p.idPledge = pay.idPledge
  WHERE
    p.idDonor = 301 -- Change this to the specific donor ID you want to retrieve information for
  ORDER BY
    p.idPledge,
    pay.Paydate;
BEGIN
 -- Open cursor
  OPEN c_pledges;
 -- Fetching data from cursor
  LOOP
    FETCH c_pledges INTO lv_pledge_id, lv_pledge_amt, lv_paymonths, lv_payment_id, lv_payment_date, lv_payment_amt;
    EXIT WHEN c_pledges%NOTFOUND;
 -- Checking if it's the first payment
    IF lv_payment_id IS NULL THEN
      lv_first_payment := 'First payment';
    ELSE
      lv_first_payment := '';
    END IF;
 -- Displaying pledge and payment information
    DBMS_OUTPUT.PUT_LINE('Pledge ID: '
                         || lv_pledge_id
                         || ', Pledge Amount: '
                         || lv_pledge_amt
                         || ', Number of Monthly Payments: '
                         || lv_paymonths
                         || ', Payment Date: '
                         || lv_payment_date
                         || ', Payment Amount: '
                         || lv_payment_amt
                         || ' '
                         || lv_first_payment);
  END LOOP;
 -- Close cursor
  CLOSE c_pledges;
END;
/

-- Assignment 4-10: Using a Different Form of Explicit Cursors
-- Redo Assignment 4-9, but use a different cursor form to perform the same task.

DECLARE
 -- Variables to store pledge and payment information
  lv_first_payment VARCHAR2(20);
BEGIN
 -- Cursor declaration using cursor FOR loop
  FOR pledge_rec IN (
    SELECT
      p.idPledge,
      p.Pledgeamt,
      p.paymonths,
      pay.idPay,
      pay.Paydate,
      pay.Payamt
    FROM
      dd_pledge  p
      LEFT JOIN dd_payment pay
      ON p.idPledge = pay.idPledge
    WHERE
      p.idDonor = 301 -- Change this to the specific donor ID you want to retrieve information for
    ORDER BY
      p.idPledge,
      pay.Paydate
  ) LOOP
 -- Checking if it's the first payment
    IF pledge_rec.idPay IS NULL THEN
      lv_first_payment := 'First payment';
    ELSE
      lv_first_payment := '';
    END IF;
 -- Displaying pledge and payment information
    DBMS_OUTPUT.PUT_LINE('Pledge ID: '
                         || pledge_rec.idPledge
                         || ', Pledge Amount: '
                         || pledge_rec.Pledgeamt
                         || ', Number of Monthly Payments: '
                         || pledge_rec.paymonths
                         || ', Payment Date: '
                         || pledge_rec.Paydate
                         || ', Payment Amount: '
                         || pledge_rec.Payamt
                         || ' '
                         || lv_first_payment);
  END LOOP;
END;

-- Assignment 4-11: Adding Cursor Flexibility
-- An administration page in the DoGood Donor application allows employees to enter multiple
-- combinations of donor type and pledge amount to determine data to retrieve. Create a block
-- with a single cursor that allows retrieving data and handling multiple combinations of donor type
-- and pledge amount as input. The donor name and pledge amount should be retrieved and
-- displayed for each pledge that matches the donor type and is greater than the pledge amount
-- indicated. Use a collection to provide the input data. Test the block using the following input
-- data. Keep in mind that these inputs should be processed with one execution of the block. The
-- donor type code I represents Individual, and B represents Business.
-- Donor Type < Pledge Amount
-- I 250
-- B 500

DECLARE
  lv_donor_type    CHAR(1);
  lv_pledge_amount NUMBER(8, 2);
BEGIN
 -- Declare variables to store donor type and pledge amount
  lv_donor_type := 'I';
  lv_pledge_amount := 250;
 -- Iterate over pledges meeting specified criteria
  FOR pledge_rec IN (
 -- Select donor name, pledge date, and pledge amount for donors meeting criteria
    SELECT
      d.Firstname
      || ' '
      || d.Lastname AS donor_name,
      p.Pledgedate,
      p.Pledgeamt
    FROM
      DD_Donor  d
      JOIN DD_Pledge p
      ON d.idDonor = p.idDonor
    WHERE
      d.Typecode = lv_donor_type
      AND p.Pledgeamt > lv_pledge_amount
  ) LOOP
 -- Output donor name, pledge date, and pledge amount for each qualifying pledge
    DBMS_OUTPUT.PUT_LINE('Donor Name: '
                         || pledge_rec.donor_name);
    DBMS_OUTPUT.PUT_LINE('Pledge Date: '
                         || pledge_rec.Pledgedate);
    DBMS_OUTPUT.PUT_LINE('Pledge Amount: '
                         || pledge_rec.Pledgeamt);
    DBMS_OUTPUT.PUT_LINE('--------------------------');
  END LOOP;
END;

-- Assignment 4-12: Using a Cursor Variable
-- Create a block with a single cursor that can perform a different query of pledge payment data
-- based on user input. Input provided to the block includes a donor ID and an indicator value of
-- D or S. The D represents details and indicates that each payment on all pledges the donor has
-- made should be displayed. The S indicates displaying summary data of the pledge payment
-- total for each pledge the donor has made.

ACCEPT enter_donor_id PROMPT 'Enter donor ID [Default: 301]: ' DEFAULT 301
ACCEPT enter_indicator PROMPT 'Enter indicator (D or S) [Default: D]: ' DEFAULT 'D'

DECLARE
  lv_donor_id       dd_donor.idDonor%TYPE;
  lv_indicator      CHAR(1);
  lv_cursor         SYS_REFCURSOR;
  lv_payment_amount dd_payment.Payamt%TYPE;
  lv_payment_date   dd_payment.Paydate%TYPE;
  lv_pledge_id      dd_pledge.idPledge%TYPE;
BEGIN
 -- Accept user input
  lv_donor_id := '&enter_donor_id';
  lv_indicator := UPPER('&enter_indicator');
 -- Check if the indicator is valid
  IF lv_indicator NOT IN ('D', 'S') THEN
    DBMS_OUTPUT.PUT_LINE('Invalid indicator. Please enter D or S.');
    RETURN;
  END IF;
 -- Open cursor
  IF lv_indicator = 'D' THEN
    OPEN lv_cursor FOR
      SELECT
        p.idPledge,
        py.Payamt,
        py.Paydate
      FROM
        dd_pledge  p
        JOIN dd_payment py
        ON p.idPledge = py.idPledge
      WHERE
        p.idDonor = lv_donor_id;
  ELSIF lv_indicator = 'S' THEN
    OPEN lv_cursor FOR
      SELECT
        p.idPledge,
        SUM(py.Payamt)
      FROM
        dd_pledge  p
        JOIN dd_payment py
        ON p.idPledge = py.idPledge
      WHERE
        p.idDonor = lv_donor_id
      GROUP BY
        p.idPledge;
  END IF;
 -- Fetch and display data
  LOOP
    FETCH lv_cursor INTO lv_pledge_id, lv_payment_amount, lv_payment_date;
    EXIT WHEN lv_cursor%NOTFOUND;
    IF lv_indicator = 'D' THEN
      DBMS_OUTPUT.PUT_LINE('Pledge ID: '
                           || lv_pledge_id
                           || ', Payment Amount: '
                           || lv_payment_amount
                           || ', Payment Date: '
                           || lv_payment_date);
    ELSIF lv_indicator = 'S' THEN
      DBMS_OUTPUT.PUT_LINE('Pledge ID: '
                           || lv_pledge_id
                           || ', Total Payment Amount: '
                           || lv_payment_amount);
    END IF;
  END LOOP;
 -- Close cursor
  CLOSE lv_cursor;
END;

-- Assignment 4-13: Exception Handling
-- The DoGood Donor application contains a page that allows administrators to change the ID
-- assigned to a donor in the DD_DONOR table. Create a PL/SQL block to handle this task.
-- Include exception-handling code to address an error raised by attempting to enter a duplicate
-- donor ID. If this error occurs, display the message “This ID is already assigned.” Test the code
-- by changing donor ID 305. (Don’t include a COMMIT statement; roll back any DML actions used.)

SET SERVEROUTPUT ON;

DECLARE
  lv_old_id    dd_donor.idDonor%TYPE := 305; -- Old donor ID
  lv_new_id    dd_donor.idDonor%TYPE := 999; -- New donor ID
  lv_row_count NUMBER;
BEGIN
 -- Check if the old ID exists
  SELECT
    COUNT(*) INTO lv_row_count
  FROM
    dd_donor
  WHERE
    idDonor = lv_old_id;
  IF lv_row_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('No donor with ID '
                         || lv_old_id
                         || ' found.');
  ELSE
 -- Attempt to change the donor ID
    UPDATE dd_donor
    SET
      idDonor = lv_new_id
    WHERE
      idDonor = lv_old_id;
 -- Check if any rows were affected by the update
    IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('This ID is already assigned.');
    ELSE
 -- Display success message if the update was successful
      DBMS_OUTPUT.PUT_LINE('Donor ID changed successfully from '
                           || lv_old_id
                           || ' to '
                           || lv_new_id);
    END IF;
  END IF;
EXCEPTION
 -- Handling other exceptions
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: '
                         || SQLERRM);
END;

# Case Projects

## Case 4-1: Using Exception Handlers in the Brewbean’s Application

A new part-time programming employee has been reviewing some PL/SQL code you
developed. The following two blocks contain a variety of exception handlers. Explain the
different types for the new employee.

Block 1:

This block uses a user-defined exception `ex_prod_update` to handle a specific condition when updating a product in the `bb_product` table. The `IF SQL%NOTFOUND` condition checks whether the `UPDATE` statement affected any rows. If no rows were affected, it raises the `ex_prod_update` exception. The `EXCEPTION` block then catches this specific exception and outputs a message indicating that an invalid product ID was entered. This is an example of using a user-defined exception for a specific situation.

Block 2:

This block involves a `SELECT` statement to retrieve basket information for a specific shopper (`lv_shopper_num`). It uses two different exception handlers:

1. `WHEN NO_DATA_FOUND`: This handler is executed if the `SELECT` statement does not find any data, indicating that the shopper has no saved baskets. In this case, it outputs a message saying, "You have no saved baskets!"

2. `WHEN OTHERS`: This handler is a catch-all for any other exceptions that might occur during the execution of the block. It outputs a generic error message indicating that a problem has occurred and suggests that tech support will be notified.

The `OTHERS` exception handler is a general exception handler that catches any exception not explicitly handled by the previous `WHEN` conditions. It is useful for logging or notifying unexpected errors. However, it's important to note that using `OTHERS` should be done carefully, as it may hide specific errors if not used judiciously. In this case, it provides a generic message for any unforeseen issues.

DECLARE
  ex_prod_update EXCEPTION;
BEGIN
  UPDATE bb_product
  SET
    description = 'Mill grinder with 5 grind settings!'
  WHERE
    idProduct = 30;
  IF SQL%NOTFOUND THEN
    RAISE ex_prod_update;
  END IF;
EXCEPTION
  WHEN ex_prod_update THEN
    DBMS_OUTPUT.PUT_LINE('Invalid product ID entered');
END;
/

DECLARE
  TYPE type_basket IS RECORD (
    basket bb_basket.idBasket%TYPE,
    created bb_basket.dtcreated%TYPE,
    qty bb_basket.quantity%TYPE,
    sub bb_basket.subtotal%TYPE
  );
  rec_basket     type_basket;
  lv_days_num    NUMBER(3);
  lv_shopper_num NUMBER(3) := 26;
BEGIN
  SELECT
    idBasket,
    dtcreated,
    quantity,
    subtotal INTO rec_basket
  FROM
    bb_basket
  WHERE
    idShopper = lv_shopper_num
    AND orderplaced = 0;
  lv_days_num := SYSDATE - rec_basket.created;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('You have no saved baskets!');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('A problem has occurred.');
    DBMS_OUTPUT.PUT_LINE('Tech Support will be notified and
will contact you via e-mail.');
END;

-- Case 4-2: Working with More Movie Rentals
-- Because business is growing and the movie stock is increasing at More Movie Rentals, the
-- manager wants to do more inventory evaluations. One item of interest is any movie with a total
-- stock value of $75 or more. The manager wants to focus on the revenue these movies are
-- generating to make sure the stock level is warranted. To make these stock queries more
-- efficient, the application team decides to add a column named STK_FLAG to the MM_MOVIE
-- table that stores an asterisk (*) if the stock value is $75 or more. Otherwise, the value should
-- be NULL. Add the column and create an anonymous block containing a CURSOR FOR loop to
-- perform this task. The company plans to run this program monthly to update the STK_FLAG
-- column before the inventory evaluation.
-- Add the STK_FLAG column to the MM_MOVIE table

ALTER TABLE mm_movie ADD STK_FLAG VARCHAR(1);

-- Create an anonymous PL/SQL block to update the STK_FLAG column
DECLARE
  lv_movie_id    mm_movie.movie_id%TYPE;
  lv_movie_value mm_movie.movie_value%TYPE;
BEGIN
 -- Cursor to fetch movie_id and movie_value
  FOR movie_rec IN (
    SELECT
      movie_id,
      movie_value
    FROM
      mm_movie
  ) LOOP
    lv_movie_id := movie_rec.movie_id;
    lv_movie_value := movie_rec.movie_value;
 -- Update STK_FLAG based on the condition
    IF lv_movie_value >= 75 THEN
      UPDATE mm_movie
      SET
        STK_FLAG = '*'
      WHERE
        movie_id = lv_movie_id;
    ELSE
      UPDATE mm_movie
      SET
        STK_FLAG = NULL
      WHERE
        movie_id = lv_movie_id;
    END IF;
  END LOOP;

  COMMIT; -- Commit the changes
END;
/

SELECT
  movie_id,
  movie_title,
  movie_value,
  STK_FLAG
FROM
  mm_movie;
