ALTER TABLE product ADD CONSTRAINT pk_product PRIMARY KEY (id);

ALTER TABLE orders ADD CONSTRAINT pk_orders PRIMARY KEY (id);

CREATE UNIQUE INDEX idx_order_product_order_id ON order_product (order_id);

CREATE INDEX idx_order_product_product_id ON order_product (product_id);
