CREATE OR REPLACE TRIGGER bb_ship_trg
  INSTEAD OF UPDATE ON bb_ship_vu
  FOR EACH ROW
BEGIN
  UPDATE bb_basket
   SET shipflag = :NEW.shipflag
   WHERE idBasket = :NEW.idBasket;
  UPDATE bb_basketstatus
   SET dtStage = :NEW.dtStage, 
       notes = :NEW.notes, 
       shipper = :NEW.shipper, 
       shippingnum = :NEW.shippingnum
   WHERE idBasket = :NEW.idBasket AND idStage = 3;
END;
