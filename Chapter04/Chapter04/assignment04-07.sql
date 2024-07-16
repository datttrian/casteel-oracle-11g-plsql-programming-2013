BEGIN
  UPDATE bb_basketitem
   SET idBasket = ??
   WHERE idBasket = ??;
END;
