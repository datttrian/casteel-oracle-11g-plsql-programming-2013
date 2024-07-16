CREATE OR REPLACE PACKAGE BODY ordering_pkg IS
 PROCEDURE order_total_pp
    (p_bsktid IN bb_basketitem.idbasket%TYPE,
     p_cnt OUT NUMBER,
     p_sub OUT NUMBER,
     p_ship OUT NUMBER,
     p_total OUT NUMBER)
    IS
   BEGIN
    SELECT SUM(quantity),SUM(quantity*price)
	    INTO p_cnt, p_sub
	    FROM bb_basketitem
	    WHERE idbasket = p_bsktid;
    p_ship := ship_calc_pf(p_cnt);
    p_total := NVL(p_sub,0) + NVL(p_ship,0);
   END order_total_pp;
 FUNCTION ship_calc_pf  
    (p_qty IN NUMBER)
    RETURN NUMBER
   IS
    lv_ship_num NUMBER(5,2);
  BEGIN
   IF p_qty > 10 THEN
     lv_ship_num := 11.00;
    ELSIF p_qty > 5 THEN
     lv_ship_num := 8.00;
    ELSE
     lv_ship_num := 5.00;
   END IF;
   RETURN lv_ship_num;
  END ship_calc_pf;
END;