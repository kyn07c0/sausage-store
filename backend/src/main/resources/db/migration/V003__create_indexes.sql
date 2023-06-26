CREATE UNIQUE INDEX IF NOT EXISTS idx_product_id ON product (id);

CREATE UNIQUE INDEX IF NOT EXISTS idx_orders_id ON orders (id);

CREATE UNIQUE INDEX IF NOT EXISTS idx_order_product_order_id ON order_product (order_id);

CREATE INDEX IF NOT EXISTS idx_order_product_product_id ON order_product (product_id);
