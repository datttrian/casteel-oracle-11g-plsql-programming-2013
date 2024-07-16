DECLARE
 lv_total_num NUMBER(6,2);
 lv_rating_txt VARCHAR2(4);
 lv_shop_num bb_basket.idshopper%TYPE := 22;
BEGIN
 SELECT SUM(total)

  FROM bb_basket
  WHERE idShopper = 
    AND orderplaced = 1
  GROUP BY idshopper;
  IF lv_total_num > 200 THEN


  END IF; 
   DBMS_OUTPUT.PUT_LINE('Shopper '||:g_shopper||' is rated '||lv_rating_txt);
END;