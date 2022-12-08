DROP TABLE sol7_order_aggr_t;

CREATE TABLE sol7_order_aggr_t (topic VARCHAR2(100)
                              , partition NUMBER(10)
									, offset NUMBER(10)
									, json_string CLOB
									, timestamp TIMESTAMP
									, created_date TIMESTAMP);
ALTER TABLE sol7_order_aggr_t ADD CONSTRAINT pk_sol7_order_aggr_t PRIMARY KEY (topic, partition, offset); 						



DROP TABLE sol7_order_line_t;
DROP TABLE sol7_order_t;

CREATE TABLE sol7_order_t (id VARCHAR2(100) PRIMARY KEY
							, customer_id NUMBER(32)
							, order_date TIMESTAMP);

CREATE TABLE sol7_order_line_t (id VARCHAR2(100) PRIMARY KEY
									, order_id VARCHAR2(100)
									, product_id NUMBER(32)
									, quantity NUMBER(3));
									
ALTER TABLE sol7_order_line_t 
	ADD CONSTRAINT sol7_fk_ordl_ord FOREIGN KEY (order_id)
	  REFERENCES sol7_order_t (id);