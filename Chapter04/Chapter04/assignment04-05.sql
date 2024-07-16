DECLARE
 rec_shopper bb_shopper%ROWTYPE;
BEGIN
 SELECT *
  INTO rec_shopper
  FROM bb_shopper
  WHERE idShopper = ??;
END;
