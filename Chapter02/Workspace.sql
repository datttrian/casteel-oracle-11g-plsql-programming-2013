-- Assignment 2-1: Using Scalar Variables
-- Create a PL/SQL block containing the following variables:
-- Name Data Type Option Initial Value
-- lv_test_date DATE December 10, 2012
-- lv_test_num NUMBER(3) CONSTANT 10
-- lv_test_txt VARCHAR2(10)
-- Assign your last name as the value of the text variable in the executable section of the
-- block. Include statements in the block to display each variable’s value onscreen.

DECLARE
    lv_test_date DATE := TO_DATE('10-DEC-2012', 'DD-MON-YYYY');
    lv_test_num CONSTANT NUMBER(3) := 10;
    lv_test_txt VARCHAR2(10);
BEGIN
    lv_test_txt := 'Copilot';
    DBMS_OUTPUT.PUT_LINE('Date: ' || TO_CHAR(lv_test_date, 'DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE('Number: ' || lv_test_num);
    DBMS_OUTPUT.PUT_LINE('Text: ' || lv_test_txt);
END;

# Assignment 2-2: Creating a Flowchart 

The Brewbean’s application needs a block that determines whether a customer is rated high,
mid, or low based on his or her total purchases. The block needs to determine the rating and
then display the results onscreen. The code rates the customer high if total purchases are
greater than $200, mid if greater than $100, and low if $100 or lower. Develop a flowchart to
outline the conditional processing steps needed for this block.

## Brewbean's Customer Rating Based Flowchart

``` txt
Start
|
v
[Declare TOTAL_PURCHASES, HIGH_LIMIT, MID_LIMIT]
|
v
[Initialize TOTAL_PURCHASES to 150]
|
v
[Display "Enter Total Purchases: 150"]
|
v
[Check if TOTAL_PURCHASES > HIGH_LIMIT]
|
v
|-----[True]
|       |
|       v
|       [Display "Customer Rated High"]
|       |
|       v
|       [Display "High Rating"]
|       |
|       v
|       [Display "End of Flowchart"]
|
|-----[False]
|       |
|       v
|       [Check if TOTAL_PURCHASES > MID_LIMIT]
|       |
|       v
|       |-----[True]
|       |       |
|       |       v
|       |       [Display "Customer Rated Mid"]
|       |       |
|       |       v
|       |       [Display "Mid Rating"]
|       |       |
|       |       v
|       |       [Display "End of Flowchart"]
|       |
|       |-----[False]
|               |
|               v
|               [Display "Customer Rated Low"]
|               |
|               v
|               [Display "Low Rating"]
|               |
|               v
|               [Display "End of Flowchart"]
|
v
[End]
```

-- Assignment 2-3: Using IF Statements
-- Create a block using an IF statement to perform the actions described in Assignment 2-2. Use
-- a scalar variable for the total purchase amount, and initialize this variable to different values to
-- test your block.

DECLARE
    lv_total_purchases NUMBER := 150;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Enter Total Purchases: ' || lv_total_purchases);

    IF lv_total_purchases > 200 THEN
        DBMS_OUTPUT.PUT_LINE('Customer Rated High');
        DBMS_OUTPUT.PUT_LINE('Display "High Rating"');
    ELSIF lv_total_purchases > 100 THEN
        DBMS_OUTPUT.PUT_LINE('Customer Rated Mid');
        DBMS_OUTPUT.PUT_LINE('Display "Mid Rating"');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Customer Rated Low');
        DBMS_OUTPUT.PUT_LINE('Display "Low Rating"');
    END IF;

    DBMS_OUTPUT.PUT_LINE('End of Flowchart');
END;

-- Assignment 2-4: Using CASE Statements
-- Create a block using a CASE statement to perform the actions described in Assignment 2-2. Use
-- a scalar variable for the total purchase amount, and initialize this variable to different values to
-- test your block.

DECLARE
    lv_total_purchases NUMBER := 150;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Enter Total Purchases: ' || lv_total_purchases);

    CASE
        WHEN lv_total_purchases > 200 THEN
            DBMS_OUTPUT.PUT_LINE('Customer Rated High');
            DBMS_OUTPUT.PUT_LINE('Display "High Rating"');
        WHEN lv_total_purchases > 100 THEN
            DBMS_OUTPUT.PUT_LINE('Customer Rated Mid');
            DBMS_OUTPUT.PUT_LINE('Display "Mid Rating"');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Customer Rated Low');
            DBMS_OUTPUT.PUT_LINE('Display "Low Rating"');
    END CASE;

    DBMS_OUTPUT.PUT_LINE('End of Flowchart');
END;

-- Assignment 2-5: Using a Boolean Variable
-- Brewbean’s needs program code to indicate whether an amount is still due on an account when
-- a payment is received. Create a PL/SQL block using a Boolean variable to indicate whether an
-- amount is still due. Declare and initialize two variables to provide input for the account balance
-- and the payment amount received. A TRUE Boolean value should indicate an amount is still
-- owed, and a FALSE value should indicate the account is paid in full. Use output statements to
-- confirm that the Boolean variable is working correctly.

DECLARE
    lv_account_balance NUMBER := 1000;
    lv_payment_received NUMBER := 500;
    lv_amount_due BOOLEAN;
BEGIN
    IF lv_payment_received < lv_account_balance THEN
        lv_amount_due := TRUE;
    ELSE
        lv_amount_due := FALSE;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Account Balance: ' || lv_account_balance);
    DBMS_OUTPUT.PUT_LINE('Payment Received: ' || lv_payment_received);

    IF lv_amount_due THEN
        DBMS_OUTPUT.PUT_LINE('Amount is still due on the account.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Account is paid in full.');
    END IF;
END;

-- Assignment 2-6: Using Looping Statements
-- Create a block using a loop that determines the number of items that can be purchased based
-- on the item prices and the total available to spend. Include one initialized variable to represent
-- the price and another to represent the total available to spend. (You could solve it with division,
-- but you need to practice using loop structures.) The block should include statements to display
-- the total number of items that can be purchased and the total amount spent.

DECLARE
    lv_item_price NUMBER := 50;
    lv_total_available NUMBER := 320;
    lv_items_purchased NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Item Price: ' || lv_item_price);
    DBMS_OUTPUT.PUT_LINE('Total Available: ' || lv_total_available);

    WHILE lv_total_available >= lv_item_price LOOP
        lv_items_purchased := lv_items_purchased + 1;
        lv_total_available := lv_total_available - lv_item_price;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total items purchased: ' || lv_items_purchased);
    DBMS_OUTPUT.PUT_LINE('Total amount spent: ' || (lv_items_purchased * lv_item_price));
END;

# Assignment 2-7: Creating a Flowchart

Brewbean’s determines shipping costs based on the number of items ordered and club membership status. The applicable rates are shown in the following chart. Develop a flowchart to outline the condition-processing steps needed to handle this calculation.

| Quantity of Items | Nonmember Shipping Cost | Member Shipping Cost |
|-------------------|--------------------------|----------------------|
| Up to 3            | $5.00                    | $3.00                |
| 4–6               | $7.50                    | $5.00                |
| 7–10              | $10.00                   | $7.00                |
| More than 10      | $12.00                   | $9.00                |

## Brewbean's Shipping Cost Calculation Flowchart

``` txt
Start
|
v
[Declare QUANTITY_OF_ITEMS, NONMEMBER_COST, MEMBER_COST, IS_MEMBER]
|
v
[Initialize QUANTITY_OF_ITEMS to 5, IS_MEMBER to False]
|
v
[Display "Enter Quantity of Items: 5"]
|
v
[Display "Are you a Club Member? (Yes/No)"]
|
v
[Check if QUANTITY_OF_ITEMS <= 3]
|
v
|-----[True]
|       |
|       v
|       [Check if IS_MEMBER is True]
|       |
|       v
|       |-----[True]
|       |       |
|       |       v
|       |       [Display "Member Shipping Cost: $3.00"]
|       |       |
|       |       v
|       |       [Display "End of Flowchart"]
|       |
|       |-----[False]
|       |       |
|       |       v
|       |       [Display "Nonmember Shipping Cost: $5.00"]
|       |       |
|       |       v
|       |       [Display "End of Flowchart"]
|
|-----[False]
|       |
|       v
|       [Check if QUANTITY_OF_ITEMS <= 6]
|       |
|       v
|       |-----[True]
|       |       |
|       |       v
|       |       [Check if IS_MEMBER is True]
|       |       |
|       |       v
|       |       |-----[True]
|       |       |       |
|       |       |       v
|       |       |       [Display "Member Shipping Cost: $5.00"]
|       |       |       |
|       |       |       v
|       |       |       [Display "End of Flowchart"]
|       |       |
|       |       |-----[False]
|       |       |       |
|       |       |       v
|       |       |       [Display "Nonmember Shipping Cost: $7.50"]
|       |       |       |
|       |       |       v
|       |       |       [Display "End of Flowchart"]
|       |
|       |-----[False]
|               |
|               v
|               [Check if QUANTITY_OF_ITEMS <= 10]
|               |
|               v
|               |-----[True]
|               |       |
|               |       v
|               |       [Check if IS_MEMBER is True]
|               |       |
|               |       v
|               |       |-----[True]
|               |       |       |
|               |       |       v
|               |       |       [Display "Member Shipping Cost: $7.00"]
|               |       |       |
|               |       |       v
|               |       |       [Display "End of Flowchart"]
|               |       |
|               |       |-----[False]
|               |       |       |
|               |       |       v
|               |       |       [Display "Nonmember Shipping Cost: $10.00"]
|               |       |       |
|               |       |       v
|               |       |       [Display "End of Flowchart"]
|               |
|               |-----[False]
|                       |
|                       v
|                       [Check if IS_MEMBER is True]
|                       |
|                       v
|                       |-----[True]
|                       |       |
|                       |       v
|                       |       [Display "Member Shipping Cost: $9.00"]
|                       |       |
|                       |       v
|                       |       [Display "End of Flowchart"]
|                       |
|                       |-----[False]
|                               |
|                               v
|                               [Display "Nonmember Shipping Cost: $12.00"]
|                               |
|                               v
|                               [Display "End of Flowchart"]
|
v
[End]
```

-- Assignment 2-8: Using IF Statements
-- Create a block to accomplish the task outlined in Assignment 2-7. Include a variable containing
-- a Y or N to indicate membership status and a variable to represent the number of items
-- purchased. Test with a variety of values.

DECLARE
    lv_nonmember_cost NUMBER;
    lv_member_cost NUMBER;
    lv_quantity_of_items NUMBER := 5;
    lv_is_member CHAR := 'Y';
BEGIN
    IF lv_quantity_of_items <= 3 THEN
        lv_nonmember_cost := 5.00;
        lv_member_cost := 3.00;
    ELSIF lv_quantity_of_items <= 6 THEN
        lv_nonmember_cost := 7.50;
        lv_member_cost := 5.00;
    ELSIF lv_quantity_of_items <= 10 THEN
        lv_nonmember_cost := 10.00;
        lv_member_cost := 7.00;
    ELSE
        lv_nonmember_cost := 12.00;
        lv_member_cost := 9.00;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Quantity of Items: ' || lv_quantity_of_items);
    DBMS_OUTPUT.PUT_LINE('Is Member: ' || lv_is_member);

    IF UPPER(lv_is_member) = 'Y' THEN
        DBMS_OUTPUT.PUT_LINE('Member Shipping Cost: $' || TO_CHAR(lv_member_cost, '99.99'));
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nonmember Shipping Cost: $' || TO_CHAR(lv_nonmember_cost, '99.99'));
    END IF;
END;

-- Assignment 2-9: Using a FOR Loop
-- Create a PL/SQL block using a FOR loop to generate a payment schedule for a donor’s pledge,
-- which is to be paid monthly in equal increments. Values available for the block are starting
-- payment due date, monthly payment amount, and number of total monthly payments for the
-- pledge. The list that’s generated should display a line for each monthly payment showing
-- payment number, date due, payment amount, and donation balance (remaining amount of
-- pledge owed).

DECLARE
    lv_start_date DATE := TO_DATE('2024-01-01', 'YYYY-MM-DD');
    lv_monthly_payment NUMBER := 1000;
    lv_total_payments NUMBER := 12;
    lv_balance NUMBER := lv_monthly_payment * lv_total_payments;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Payment# | Due Date   | Payment Amount | Donation Balance');

    FOR payment_number IN 1..lv_total_payments LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(payment_number, 9) ||
            ' | ' || TO_CHAR(lv_start_date, 'YYYY-MM-DD') ||
            ' | ' || lv_monthly_payment ||
            ' | ' || lv_balance
        );
        lv_start_date := ADD_MONTHS(lv_start_date, 1);
        lv_balance := lv_balance - lv_monthly_payment;
    END LOOP;
END;

-- Assignment 2-10: Using a Basic Loop
-- Accomplish the task in Assignment 2-9 by using a basic loop structure.

DECLARE
    lv_start_date DATE := TO_DATE('2024-01-01', 'YYYY-MM-DD');
    lv_monthly_payment NUMBER := 1000;
    lv_total_payments NUMBER := 12;
    lv_balance NUMBER := lv_monthly_payment * lv_total_payments;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Payment# | Due Date   | Payment Amount | Donation Balance');

    LOOP
        EXIT WHEN lv_total_payments = 0;
        DBMS_OUTPUT.PUT_LINE(
            RPAD(lv_total_payments, 9) ||
            ' | ' || TO_CHAR(lv_start_date, 'YYYY-MM-DD') ||
            ' | ' || lv_monthly_payment ||
            ' | ' || lv_balance
        );
        lv_start_date := ADD_MONTHS(lv_start_date, 1);
        lv_balance := lv_balance - lv_monthly_payment;
        lv_total_payments := lv_total_payments - 1;
    END LOOP;
END;

-- Assignment 2-11: Using a WHILE Loop
-- Accomplish the task in Assignment 2-9 by using a WHILE loop structure. Instead of displaying
-- the donation balance (remaining amount of pledge owed) on each line of output, display the
-- total paid to date.

DECLARE
    lv_start_date DATE := TO_DATE('2024-01-01', 'YYYY-MM-DD');
    lv_monthly_payment NUMBER := 1000;
    lv_total_payments NUMBER := 12;
    lv_balance NUMBER := lv_monthly_payment * lv_total_payments;
    lv_total_paid NUMBER := 0;
    lv_payment_number NUMBER := 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Payment# | Due Date   | Payment Amount | Total Paid to Date');
    WHILE lv_payment_number <= lv_total_payments LOOP
        lv_total_paid := lv_total_paid + lv_monthly_payment;
        lv_start_date := ADD_MONTHS(TO_DATE('2024-01-01', 'YYYY-MM-DD'), lv_payment_number - 1);

        DBMS_OUTPUT.PUT_LINE(
            RPAD(lv_payment_number, 9) ||
            ' | ' || TO_CHAR(lv_start_date, 'YYYY-MM-DD') ||
            ' | ' || lv_monthly_payment ||
            ' | ' || lv_total_paid
        );

        lv_payment_number := lv_payment_number + 1;
    END LOOP;
END;

-- Assignment 2-12: Using a CASE Expression
-- Donors can select one of three payment plans for a pledge indicated by the following codes:
-- 0 = one-time (lump sum) payment, 1 = monthly payments over one year, and 2 = monthly
-- payments over two years. A local business has agreed to pay matching amounts on pledge
-- payments during the current month. A PL/SQL block is needed to identify the matching
-- amount for a pledge payment. Create a block using input values of a payment plan code
-- and a payment amount. Use a CASE expression to calculate the matching amount, based on
-- the payment plan codes 0 = 25%, 1 = 50%, 2 = 100%, and other = 0. Display the
-- calculated amount.

DECLARE
    lv_payment_plan_code NUMBER := 1;
    lv_payment_amount NUMBER := 1000;
    lv_matching_amount NUMBER;
BEGIN
    lv_matching_amount := 
        CASE lv_payment_plan_code
            WHEN 0 THEN lv_payment_amount * 0.25
            WHEN 1 THEN lv_payment_amount * 0.50
            WHEN 2 THEN lv_payment_amount * 1.00
            ELSE 0
        END;

    DBMS_OUTPUT.PUT_LINE('Payment Plan Code: ' || lv_payment_plan_code);
    DBMS_OUTPUT.PUT_LINE('Payment Amount: ' || lv_payment_amount);
    DBMS_OUTPUT.PUT_LINE('Calculated Matching Amount: ' || lv_matching_amount);
END;

-- Assignment 2-13: Using Nested IF Statements
-- An organization has committed to matching pledge amounts based on the donor type and
-- pledge amount. Donor types include I = Individual, B = Business organization, and G = Grant
-- funds. The matching percents are to be applied as follows:
-- Donor Type Pledge Amount Matching %
-- I $100–$249 50%
-- I $250–$499 30%
-- I $500 or more 20%
-- B $100–$499 20%
-- B $500–$999 10%
-- B $1,000 or more 5%
-- G $100 or more 5%
-- Create a PL/SQL block using nested IF statements to accomplish the task. Input values for
-- the block are the donor type code and the pledge amount.

DECLARE
    lv_donor_type CHAR(1) := 'I';
    lv_pledge_amount NUMBER := 300;

    lv_matching_percent NUMBER;
    lv_matching_amount NUMBER;
BEGIN
    IF lv_donor_type = 'I' THEN
        IF lv_pledge_amount >= 100 AND lv_pledge_amount <= 249 THEN
            lv_matching_percent := 0.5;
        ELSIF lv_pledge_amount >= 250 AND lv_pledge_amount <= 499 THEN
            lv_matching_percent := 0.3;
        ELSE
            lv_matching_percent := 0.2;
        END IF;
    ELSIF lv_donor_type = 'B' THEN
        IF lv_pledge_amount >= 100 AND lv_pledge_amount <= 499 THEN
            lv_matching_percent := 0.2;
        ELSIF lv_pledge_amount >= 500 AND lv_pledge_amount <= 999 THEN
            lv_matching_percent := 0.1;
        ELSE
            lv_matching_percent := 0.05;
        END IF;
    ELSIF lv_donor_type = 'G' THEN
        IF lv_pledge_amount >= 100 THEN
            lv_matching_percent := 0.05;
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Invalid donor type');
        RETURN;
    END IF;
   
    lv_matching_amount := lv_pledge_amount * lv_matching_percent;

    DBMS_OUTPUT.PUT_LINE('Donor Type: ' || lv_donor_type);
    DBMS_OUTPUT.PUT_LINE('Pledge Amount: $' || lv_pledge_amount);
    DBMS_OUTPUT.PUT_LINE('Matching Percentage: ' || TO_CHAR(lv_matching_percent * 100) || '%');
    DBMS_OUTPUT.PUT_LINE('Matching Amount: $' || lv_matching_amount);
END;

# Case 2-1: Flowcharting

Find a Web site with basic information on flowcharting. Describe at least two interesting aspects of flowcharting discussed on the Web site.

1. Flowcharting is a visual representation of a process or algorithm, using different shapes and symbols to represent different steps and decisions in the process.
2. Flowcharting is a useful tool for planning and documenting processes, as well as for communicating complex processes to others in a clear and understandable manner.

-- Case 2-2: Working with More Movie Rentals
-- The More Movie Rentals Company wants to display a rating value for a movie based on the
-- number of times the movie has been rented. The rating assignments are outlined in the
-- following chart:
-- Number of Rentals Rental Rating
-- Up to 5 Dump
-- 5–20 Low
-- 21–35 Mid
-- More than 35 High
-- Create a flowchart and then a PL/SQL block to address the processing needed. The block
-- should determine and then display the correct rental rating. Test the block, using a variety of
-- rental amounts.

DECLARE
    v_number_of_rentals NUMBER := 25; -- Replace with the actual number of rentals

    v_rental_rating VARCHAR2(10);

BEGIN
    IF v_number_of_rentals <= 5 THEN
        v_rental_rating := 'Dump';
    ELSIF v_number_of_rentals <= 20 THEN
        v_rental_rating := 'Low';
    ELSIF v_number_of_rentals <= 35 THEN
        v_rental_rating := 'Mid';
    ELSE
        v_rental_rating := 'High';
    END IF;

    DBMS_OUTPUT.PUT_LINE('Number of Rentals: ' || v_number_of_rentals);
    DBMS_OUTPUT.PUT_LINE('Rental Rating: ' || v_rental_rating);

END;
