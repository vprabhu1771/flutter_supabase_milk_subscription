```sql
-- Drop existing product_variants table if necessary
DROP TABLE IF EXISTS products;

-- Recreate with UUID
CREATE TABLE "public"."products" (
    "id" SERIAL PRIMARY KEY,
    "created_at" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    "name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "image_path" TEXT DEFAULT 'https://bezzyxfbmfykhwqqioys.supabase.co/storage/v1/object/public/assets//no_image_available.jpg'
);
```

```sql
INSERT INTO "public"."products" ("name", "description")
VALUES
('Full Cream Milk', 'Rich and creamy milk, perfect for making desserts and adding extra flavor to tea or coffee.'),
('Standardized Milk', 'Milk with a consistent fat content, ideal for everyday use in cooking and beverages.'),
('Toned Milk', 'Low-fat milk with balanced nutrition, suitable for health-conscious individuals.'),
('Double Toned Milk', 'Ultra low-fat milk, an excellent choice for those on a calorie-controlled diet.');
```