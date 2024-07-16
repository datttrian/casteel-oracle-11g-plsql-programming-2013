CREATE OR REPLACE PACKAGE shopid_pkg IS
 PROCEDURE shop_pp 
  (p_id IN bb_shopper.idshopper%TYPE,
   p_name OUT VARCHAR2,
   p_cnt OUT NUMBER);
 PROCEDURE shop_pp 
  (p_user IN bb_shopper.username%TYPE,
   p_name OUT VARCHAR2,
   p_cnt OUT NUMBER);
END;

CREATE OR REPLACE PACKAGE BODY shopid_pkg IS
 PROCEDURE shop_pp 
  (p_id IN bb_shopper.idshopper%TYPE,
   p_name OUT VARCHAR2,
   p_cnt OUT NUMBER)
  IS
  BEGIN
   SELECT firstname||' '||lastname, COUNT(idbasket)
    INTO p_name, p_cnt
    FROM bb_shopper JOIN bb_basket
            USING(idshopper)
    WHERE idShopper = p_id
    GROUP BY firstname||' '||lastname;
  EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('No match');
 END;
 PROCEDURE shop_pp 
  (p_user IN bb_shopper.username%TYPE,
   p_name OUT VARCHAR2,
   p_cnt OUT NUMBER)
  IS
  BEGIN
   SELECT firstname||' '||lastname, COUNT(idbasket)
    INTO p_name, p_cnt
    FROM bb_shopper JOIN bb_basket
            USING(idshopper)
    WHERE username = p_user
    GROUP BY firstname||' '||lastname;
  EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('No match');
 END;
END;

DECLARE
    g_name VARCHAR2(25);
    g_cnt NUMBER(4);
BEGIN
     shopid_pkg.shop_pp(21,g_name,g_cnt);
     DBMS_OUTPUT.PUT_LINE(g_name);
     DBMS_OUTPUT.PUT_LINE(g_cnt);
END;

DECLARE
    g_name VARCHAR2(25);
    g_cnt NUMBER(4);
BEGIN
     shopid_pkg.shop_pp('Crackj',g_name,g_cnt);
     DBMS_OUTPUT.PUT_LINE(g_name);
     DBMS_OUTPUT.PUT_LINE(g_cnt);
END;
