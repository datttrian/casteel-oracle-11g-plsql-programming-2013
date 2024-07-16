UPDATE bb_shopper
  SET promo = NULL;
UPDATE bb_shopper
  SET promo = 'B'
  WHERE idShopper IN (21,23,25);
UPDATE bb_shopper
  SET promo = 'A'
  WHERE idShopper = 22;
COMMIT;

BEGIN
 UPDATE bb_shopper
  SET promo = NULL
  WHERE promo IS NOT NULL;
END;
