CREATE OR REPLACE PACKAGE ordering_pkg
 IS
  pv_total_num NUMBER(3,2);
  PROCEDURE order_total_pp
    (p_bsktid IN bb_basketitem.idbasket%TYPE,
     p_cnt OUT NUMBER,
     p_sub OUT NUMBER,
     p_ship OUT NUMBER,
     p_total OUT NUMBER);
  FUNCTION ship_calc_pf 
    (p_qty IN NUMBER)
    RETURN NUMBER;
END;