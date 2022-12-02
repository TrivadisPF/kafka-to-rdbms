
CONNECT ecomm_sales/abc123!@//localhost/XEPDB1

DROP TABLE order_t IF EXISTS;

CREATE TABLE order_t (
	id				     	NUMBER(32)     PRIMARY KEY,
	customer_id				NUMBER(32),
	order_date				TIMESTAMP);
    
CREATE SEQUENCE order_seq START WITH 1;

CREATE TABLE order_line_t (
	id				     	NUMBER(32)     PRIMARY KEY,
	order_id				NUMBER(32),
	product_id				NUMBER(32),
	quantity			    NUMBER(3)
	);

CREATE SEQUENCE order_line_seq START WITH 1;

ALTER TABLE order_line_t ADD CONSTRAINT fk_ordl_ord FOREIGN KEY (order_id) REFERENCES order_t(id);
