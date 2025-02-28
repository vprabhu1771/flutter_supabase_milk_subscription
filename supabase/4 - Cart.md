```sql
CREATE TABLE public.carts (
    id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    variant_id INT NOT NULL,
    qty INT NOT NULL CHECK (qty > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    attributes JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    user_id UUID NOT NULL,
    subscription_plan_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE,
    FOREIGN KEY (variant_id) REFERENCES public.variants(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE,
    FOREIGN KEY (subscription_plan_id) REFERENCES public.subscription_plans(id) ON DELETE CASCADE
);
```

```sql
INSERT INTO "public"."carts" (
    "id", 
    "product_id", 
    "variant_id", 
    "qty", 
    "price", 
    "attributes", 
    "created_at", 
    "user_id", 
    "subscription_plan_id"
) VALUES 
('12', '1', '1', '1', '60.00', '{}', '2025-02-22 04:46:40.701496', 'd47ea404-9072-48c7-9ab7-1aab44aa40cb', '1'), 
('18', '4', '15', '1', '14.00', '{}', '2025-02-24 10:25:03.620097', 'd47ea404-9072-48c7-9ab7-1aab44aa40cb', '1'), 
('19', '1', '1', '1', '60.00', '{}', '2025-02-24 10:52:39.86984', 'd47ea404-9072-48c7-9ab7-1aab44aa40cb', '1'), 
('20', '1', '1', '1', '60.00', '{}', '2025-02-28 10:25:36.345743', '07c394b0-f515-4e3c-b066-b8ac0038e643', '1');
```