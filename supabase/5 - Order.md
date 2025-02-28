You need tables for `orders` in PostgreSQL for Supabase. Here’s a schema that aligns with your `carts` table:


### `orders` Table
Each order is associated with a user and contains details such as status and total amount.

```sql
CREATE TABLE public.orders (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL,
    total_price DECIMAL(10,2) NOT NULL CHECK (total_price >= 0),
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE
);
```