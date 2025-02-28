```sql
-- Drop existing product_variants table if necessary
DROP TABLE IF EXISTS product_variants;

-- Recreate with UUID
CREATE TABLE product_variants (
    "id" SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id) ON DELETE SET NULL,
    qty VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);
```

```sql
insert into product_variants (product_id, qty, unit_price) values
(1, '1L', 60.00),
(1, '500ML', 32.00),
(1, '250ML', 18.00),
(1, '100ML', 10.00),
(2, '1L', 55.00),
(2, '500ML', 30.00),
(2, '250ML', 17.00),
(2, '100ML', 9.00),
(3, '1L', 50.00),
(3, '500ML', 28.00),
(3, '250ML', 15.00),
(3, '100ML', 8.00),
(4, '1L', 48.00),
(4, '500ML', 26.00),
(4, '250ML', 14.00),
(4, '100ML', 7.00);
```

```sql
ALTER TABLE product_variants
ADD CONSTRAINT variants
FOREIGN KEY (product_id)
REFERENCES products(id);
```