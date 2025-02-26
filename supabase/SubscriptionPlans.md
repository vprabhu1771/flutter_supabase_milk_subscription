```sql
-- Subscription Plans Table with UUID
CREATE TABLE subscription_plans (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);
```
```sql
INSERT INTO subscription_plans (name) VALUES ('Daily'),('Weekly');
```