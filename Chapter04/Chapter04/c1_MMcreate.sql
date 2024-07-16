CREATE TABLE mm_movie_type
     (movie_cat_id   NUMBER(2),
      movie_category VARCHAR(12),
      CONSTRAINT movie_cat_id_pk PRIMARY KEY (movie_cat_id));
CREATE TABLE mm_pay_type
     (payment_methods_id  NUMBER(2),
      payment_methods     VARCHAR(14),
      CONSTRAINT payment_methods_id_pk PRIMARY KEY (payment_methods_id));
CREATE TABLE mm_member
   (member_id  NUMBER(4),
   last         VARCHAR(12),
   first        VARCHAR(8),
   license_no   VARCHAR(9),
   license_st   VARCHAR(2),
   credit_card  VARCHAR(12),
   suspension   VARCHAR(1) DEFAULT 'N',
   mailing_list VARCHAR(1),
   CONSTRAINT cust_custid_pk PRIMARY KEY (member_id),
   CONSTRAINT cust_credcard_ck CHECK (LENGTH(credit_card) = 12));
CREATE TABLE mm_movie
     (movie_id     NUMBER(4),
      movie_title  VARCHAR(40),
      movie_cat_id   NUMBER(2) NOT NULL,
      movie_value  DECIMAL(5,2),
      movie_qty NUMBER(2),
      CONSTRAINT movies_id_pk PRIMARY KEY (movie_id),
      CONSTRAINT movie_type_fk FOREIGN KEY (movie_cat_id)
            REFERENCES mm_movie_type(movie_cat_id),
      CONSTRAINT movies_value_ck CHECK (movie_value BETWEEN 5 and 100));
CREATE TABLE mm_rental
      (rental_id NUMBER(4),
       member_id   NUMBER(4),
       movie_id      NUMBER(4),
       checkout_date DATE DEFAULT SYSDATE,
       checkin_date  DATE,
       payment_methods_id  NUMBER(2),
       CONSTRAINT rentals_pk PRIMARY KEY (rental_id),
       CONSTRAINT member_id_fk FOREIGN KEY (member_id)
            REFERENCES mm_member(member_id),
       CONSTRAINT movie_id_fk FOREIGN KEY (movie_id)
            REFERENCES mm_movie(movie_id),
       CONSTRAINT pay_id_fk FOREIGN KEY (payment_methods_id)
            REFERENCES mm_pay_type(payment_methods_id));
Create sequence mm_rental_seq  start with 13;
INSERT INTO mm_member (member_id, last, first, license_no, license_st, credit_card)
   VALUES (10, 'Tangier', 'Tim', '111111111', 'VA', '123456789111');
INSERT INTO mm_member (member_id, last, first, license_no, license_st, credit_card, mailing_list)
   VALUES (11, 'Ruth', 'Babe', '222222222', 'VA', '222222222222', 'Y');
INSERT INTO mm_member (member_id, last, first, license_no, license_st, credit_card, mailing_list)
   VALUES (12, 'Maulder', 'Fox', '333333333', 'FL', '333333333333', 'Y');
INSERT INTO mm_member (member_id, last, first, license_no, license_st, credit_card)
   VALUES (13, 'Wild', 'Coyote', '444444444', 'VA', '444444444444');
INSERT INTO mm_member (member_id, last, first, license_no, license_st, credit_card, mailing_list)
   VALUES (14, 'Casteel', 'Joan', '555555555', 'VA', '555555555555', 'Y');
INSERT INTO mm_movie_type (movie_cat_id, movie_category)
  VALUES ( '1', 'SciFi');
INSERT INTO mm_movie_type (movie_cat_id, movie_category)
  VALUES ( '2', 'Horror');
INSERT INTO mm_movie_type (movie_cat_id, movie_category)
  VALUES ( '3', 'Western');
INSERT INTO mm_movie_type (movie_cat_id, movie_category)
  VALUES ( '4', 'Comedy');
INSERT INTO mm_movie_type (movie_cat_id, movie_category)
  VALUES ( '5', 'Drama');
INSERT INTO mm_movie (movie_id, movie_title, movie_cat_id, movie_value, movie_qty)
  VALUES (1, 'Alien', '1', 10.00, 5);
INSERT INTO mm_movie (movie_id, movie_title, movie_cat_id, movie_value, movie_qty)
  VALUES (2, 'Bladerunner', '1', 8.00, 3);
INSERT INTO mm_movie (movie_id, movie_title, movie_cat_id, movie_value, movie_qty)
  VALUES (3, 'Star Wars', '1', 15.00, 11);
INSERT INTO mm_movie (movie_id, movie_title, movie_cat_id, movie_value, movie_qty)
  VALUES (4,'Texas Chainsaw Masacre', '2', 7.00, 2);
INSERT INTO mm_movie (movie_id, movie_title, movie_cat_id, movie_value, movie_qty)
  VALUES (5, 'Jaws', '2', 7.00,1);
INSERT INTO mm_movie (movie_id, movie_title, movie_cat_id, movie_value, movie_qty)
  VALUES (6, 'The good, the bad and the ugly', '3', 7.00,2);
INSERT INTO mm_movie (movie_id, movie_title, movie_cat_id, movie_value, movie_qty)
  VALUES (7, 'Silverado', '3', 7.00,1);
INSERT INTO mm_movie (movie_id, movie_title, movie_cat_id, movie_value, movie_qty)
  VALUES (8, 'Duck Soup', '4', 5.00,1);
INSERT INTO mm_movie (movie_id, movie_title, movie_cat_id, movie_value, movie_qty)
  VALUES (9, 'Planes, trains and automobiles', '4', 5.00,3);
INSERT INTO mm_movie (movie_id, movie_title, movie_cat_id, movie_value, movie_qty)
  VALUES (10, 'Waking Ned Devine', '4', 12.00,4);
INSERT INTO mm_movie (movie_id, movie_title, movie_cat_id, movie_value, movie_qty)
  VALUES (11, 'Deep Blue Sea', '5', 14.00,3);
INSERT INTO mm_movie (movie_id, movie_title, movie_cat_id, movie_value, movie_qty)
  VALUES (12, 'The Fifth Element', '5', 15.00,5);
INSERT INTO mm_pay_type (payment_methods_id, payment_methods)
  VALUES ('1', 'Account');
INSERT INTO mm_pay_type (payment_methods_id, payment_methods)
  VALUES ('2', 'Credit Card');
INSERT INTO mm_pay_type (payment_methods_id, payment_methods)
  VALUES ('3', 'Check');
INSERT INTO mm_pay_type (payment_methods_id, payment_methods)
  VALUES ('4', 'Cash');
INSERT INTO mm_pay_type (payment_methods_id, payment_methods)
  VALUES ('5', 'Debit Card');
INSERT INTO mm_rental (rental_id, member_id, movie_id, payment_methods_id)
  VALUES (1,'10', '11', '2');
INSERT INTO mm_rental (rental_id, member_id, movie_id, payment_methods_id)
  VALUES (2,'10', '8', '2');
INSERT INTO mm_rental (rental_id, member_id, movie_id, payment_methods_id)
  VALUES (3,'12', '6', '2');
INSERT INTO mm_rental (rental_id, member_id, movie_id, payment_methods_id)
  VALUES (4,'13', '3', '5');
INSERT INTO mm_rental (rental_id, member_id, movie_id, payment_methods_id)
  VALUES (5,'13', '5', '5');
INSERT INTO mm_rental (rental_id, member_id, movie_id, payment_methods_id)
  VALUES (6,'13', '11', '5');
INSERT INTO mm_rental (rental_id, member_id, movie_id, payment_methods_id)
  VALUES (7,'14', '10', '2');
INSERT INTO mm_rental (rental_id, member_id, movie_id, payment_methods_id)
  VALUES (8,'14', '7', '2');
INSERT INTO mm_rental (rental_id, member_id, movie_id, payment_methods_id)
  VALUES (9,'12', '4', '4');
INSERT INTO mm_rental (rental_id, member_id, movie_id, payment_methods_id)
  VALUES (10,'12', '12', '4');
INSERT INTO mm_rental (rental_id, member_id, movie_id, payment_methods_id)
  VALUES (11,'12', '3', '4');
INSERT INTO mm_rental (rental_id, member_id, movie_id, payment_methods_id)
  VALUES (12,'13', '4', '5');
UPDATE mm_rental 
 SET checkout_date = '04-JUN-2012';
COMMIT;