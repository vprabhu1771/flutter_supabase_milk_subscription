```sql
CREATE TABLE milk_subscriptions (
    id SERIAL PRIMARY KEY,
    customer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    subscription_plans_id int NOT NULL REFERENCES subscription_plans(id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status TEXT CHECK (status IN ('active', 'expired', 'cancelled')) NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT NOW()
);
```

```sql
SELECT * 
FROM milk_subscriptions ms
JOIN subscription_plans sp ON ms.subscription_plans_id = sp.id
WHERE ms.status = 'active';
```