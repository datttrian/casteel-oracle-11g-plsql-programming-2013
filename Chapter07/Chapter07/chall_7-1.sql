CREATE OR REPLACE PACKAGE prod_pkg IS
 PROCEDURE stkup_pp 
  (p_id IN bb_product.idproduct%TYPE,
   p_qty IN NUMBER);
END;

CREATE OR REPLACE PACKAGE BODY prod_pkg IS
 FUNCTION stk_pf 
  (p_id IN bb_product.idproduct%TYPE)
   RETURN NUMBER
  IS
   lv_stk_num bb_product.stock%TYPE;
 BEGIN
   SELECT stock
    INTO lv_stk_num
    FROM bb_product
    WHERE idproduct = p_id;
   RETURN lv_stk_num;
 EXCEPTION
  WHEN NO_DATA_FOUND THEN
   RETURN 0;
 END; 
 PROCEDURE stkup_pp 
  (p_id IN bb_product.idproduct%TYPE,
   p_qty IN NUMBER)
  IS
   lv_stk_num bb_product.stock%TYPE;
 BEGIN
   lv_stk_num := stk_pf(p_id);
   IF lv_stk_num >= p_qty THEN
     UPDATE bb_product
      SET stock = stock - p_qty
      WHERE idproduct = p_id;
     COMMIT;
   ELSE
     DBMS_OUTPUT.PUT_LINE('Insufficient Stock');
   END IF;
 END;
END;


---- test insufficient stock----
BEGIN
  prod_pkg.stkup_pp(1,25);
END;

OR

EXECUTE prod_pkg.stkup_pp(1,25);

----- test update -----------
BEGIN
  prod_pkg.stkup_pp(1,3);
END;

OR

EXECUTE prod_pkg.stkup_pp(1,3);
