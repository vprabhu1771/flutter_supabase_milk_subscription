You need tables for `order_items` in PostgreSQL for Supabase. Here’s a schema that aligns with your `carts` table:

### `order_items` Table
Each order can have multiple items linked to products and variants.

```sql
CREATE TABLE public.order_items (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    variant_id INT NOT NULL,
    qty INT NOT NULL CHECK (qty > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    attributes JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE,
    FOREIGN KEY (variant_id) REFERENCES public.variants(id) ON DELETE CASCADE
);
```

### Moving Items from `carts` to `orders`
You can insert data into `orders` and `order_items` by selecting from `carts`:

```sql
WITH new_order AS (
    INSERT INTO public.orders (user_id, total_price, status)
    SELECT user_id, SUM(price * qty), 'pending'
    FROM public.carts
    WHERE user_id = 'd47ea404-9072-48c7-9ab7-1aab44aa40cb'
    GROUP BY user_id
    RETURNING id
)
INSERT INTO public.order_items (order_id, product_id, variant_id, qty, price, attributes)
SELECT new_order.id, c.product_id, c.variant_id, c.qty, c.price, c.attributes
FROM public.carts c, new_order
WHERE c.user_id = 'd47ea404-9072-48c7-9ab7-1aab44aa40cb';
```

### Clear Cart After Order
```sql
DELETE FROM public.carts WHERE user_id = 'd47ea404-9072-48c7-9ab7-1aab44aa40cb';
```

This setup ensures users can place orders, and the cart is cleared after checkout. Let me know if you need further adjustments! 🚀