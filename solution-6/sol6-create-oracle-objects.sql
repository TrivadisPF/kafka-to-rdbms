DROP TABLE sol6_order_aggr_t;

CREATE TABLE sol6_order_aggr_t (topic VARCHAR2(100)
                              , partition NUMBER(10)
									, offset NUMBER(10)
									, json_string CLOB
									, timestamp TIMESTAMP);
ALTER TABLE sol6_order_aggr_t ADD CONSTRAINT pk_sol6_order_aggr_t PRIMARY KEY (topic, partition, offset); 						



DROP TABLE sol6_order_line_t;
DROP TABLE sol6_order_t;

CREATE TABLE sol6_order_t (id VARCHAR2(100) PRIMARY KEY
							, customer_id NUMBER(32)
							, order_date TIMESTAMP);

CREATE TABLE sol6_order_line_t (id VARCHAR2(100) PRIMARY KEY
									, order_id VARCHAR2(100)
									, product_id NUMBER(32)
									, quantity NUMBER(3));
									
ALTER TABLE sol6_order_line_t 
	ADD CONSTRAINT sol6_fk_ordl_ord FOREIGN KEY (order_id)
	  REFERENCES sol6_order_t (id);

CREATE OR REPLACE VIEW sol6_order_aggr_v 
AS 
SELECT topic
,      partition
,      offset
,      json_string
,      timestamp 
FROM sol6_order_aggr_t;



CREATE OR REPLACE TRIGGER sol6_order_aggr_iot
INSTEAD OF INSERT OR UPDATE ON sol6_order_aggr_v
DECLARE
BEGIN
   INSERT INTO sol6_order_aggr_t (topic, partition, offset, json_string, timestamp)
   VALUES(:NEW.topic, :NEW.partition, :NEW.offset, :NEW.json_string, :NEW.timestamp);
   
   INSERT INTO sol6_order_t (id, customer_id, order_date)
   SELECT id, customer_id, TO_TIMESTAMP(order_date, 'YYYY-MM-DD"T"HH24:MI:SS.FF"Z"') 
   FROM json_table (:NEW.json_string FORMAT JSON, '$.order'
        COLUMNS (
            id VARCHAR2 PATH id,
            customer_id NUMBER PATH customerId,
            order_date VARCHAR2 PATH orderDate));

   INSERT INTO sol6_order_line_t (id, order_id, product_id, quantity)
   SELECT order_id || ':' || id, order_id, product_id, quantity
   FROM json_table (:NEW.json_string FORMAT JSON, '$.order'
        COLUMNS (
            order_id VARCHAR2 PATH id,
            NESTED PATH '$.orderLines[*]' 
            COLUMNS
                (id NUMBER PATH lineId,
                product_id NUMBER PATH productId,
                quantity NUMBER PATH quantity)));

END sol6_order_aggr_iot;
/
