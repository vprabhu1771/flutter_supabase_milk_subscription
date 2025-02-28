```sql
CREATE TABLE carts (
    id SERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    subscription_plan_id INTEGER REFERENCES subscription_plans(id),
    created_at TIMESTAMP DEFAULT NOW()
);
```

```sql
-- Cart Items Table
CREATE TABLE cart_items (
    id SERIAL PRIMARY KEY,
    cart_id INTEGER REFERENCES carts(id) ON DELETE CASCADE,
    product_variant_id INTEGER REFERENCES product_variants(id),
    quantity INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);
```

```sql
INSERT INTO carts (user_id, subscription_plan_id, created_at)
VALUES (
    'c56a4180-65aa-42ec-a945-5fd21dec0538', -- Replace with an actual user UUID
    1,                                      -- Assuming a valid subscription_plan_id
    NOW()
);
```

```sql
INSERT INTO cart_items (
    user_id,
    cart_id,
    product_variant_id,
    subscription_plan_id,
    quantity,
    created_at
)
VALUES (
    'c56a4180-65aa-42ec-a945-5fd21dec0538', -- Same user_id as above
    1,                                      -- Replace with the cart_id inserted above
    2,                                      -- Replace with a valid product_variant_id
    1,                                      -- Replace with a valid subscription_plan_id
    3,                                      -- Quantity of the product
    NOW()
);
```
```sql
ALTER TABLE carts
ADD CONSTRAINT subscription
FOREIGN KEY (subscription_plan_id)
REFERENCES subscription_plans(id);
```