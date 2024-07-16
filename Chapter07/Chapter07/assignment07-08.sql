CREATE OR REPLACE PACKAGE login_pkg IS
 pv_id_num NUMBER(3);
 FUNCTION login_ck_pf 
  (p_user IN VARCHAR2,
   p_pass IN VARCHAR2)
   RETURN CHAR;
END;

CREATE OR REPLACE PACKAGE BODY login_pkg IS
 FUNCTION login_ck_pf 
  (p_user IN VARCHAR2,
   p_pass IN VARCHAR2)
   RETURN CHAR
  IS
   lv_ck_txt CHAR(1) := 'N';
   lv_id_num NUMBER(5);
 BEGIN
   SELECT idShopper
    INTO lv_id_num
    FROM bb_shopper
    WHERE username = p_user
     AND password = p_pass;
      lv_ck_txt := 'Y';
      pv_id_num := lv_id_num;
   RETURN lv_ck_txt;
 EXCEPTION
  WHEN NO_DATA_FOUND THEN
   RETURN lv_ck_txt;
 END; 
END;
