ALTER TABLE bb_basketitem
  ADD CONSTRAINT bitems_qty_ck CHECK (quantity < 20);

BEGIN
  INSERT INTO bb_basketitem 
   VALUES (88,8,10.8,21,16,2,3);
END;
