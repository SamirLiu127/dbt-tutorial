WITH customers AS (
  SELECT
    *
  FROM
    {{ ref('stg_customers') }}
),
orders AS (
  SELECT
    *
  FROM
    {{ ref('fct_orders') }}
),
payments AS (
  SELECT
    *
  FROM
    {{ ref('stg_payments') }}
),
customer_orders AS (
  SELECT
    customer_id,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS most_recent_order_date,
    COUNT(order_id) AS number_of_orders,
    SUM(amount) AS lifetime_value
  FROM
    orders
  GROUP BY
    customer_id
),
final AS (
  SELECT
    customers.customer_id,
    customers.first_name,
    customers.last_name,
    customer_orders.first_order_date,
    customer_orders.most_recent_order_date,
    coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
    customer_orders.lifetime_value
  FROM customers
  LEFT JOIN customer_orders USING(customer_id)
)
SELECT
  *
FROM
  final
