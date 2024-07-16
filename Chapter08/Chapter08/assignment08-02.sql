CREATE OR REPLACE FUNCTION status_desc_sf
  (p_stage IN NUMBER)
  RETURN VARCHAR2
 IS
  lv_stage_txt VARCHAR2(30);
BEGIN
 IF p_stage = 1 THEN
   lv_stage_txt := 'Order Submitted';
 ELSIF p_stage = 2 THEN
   lv_stage_txt := 'Accepted, sent to shipping';
 ELSIF p_stage = 3 THEN
   lv_stage_txt := 'Backordered';
 ELSIF p_stage = 4 THEN
   lv_stage_txt := 'Cancelled';
 ELSIF p_stage = 5 THEN
   lv_stage_txt := 'Shipped';
 END IF;
 RETURN lv_stage_txt;
END;

CREATE OR REPLACE PROCEDURE status_check_sp
  (p_bask IN NUMBER,
   p_stage OUT NUMBER,
   p_desc OUT VARCHAR2)
 IS
BEGIN
  SELECT idstage
   INTO p_stage
   FROM bb_basketstatus
   WHERE idBasket = p_bask;
  p_desc := status_desc_sf(p_stage);
END;
/ 