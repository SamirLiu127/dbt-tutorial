SELECT
    id as payment_id,
    orderid as order_id,
    paymentmethod as payment_method,
    STATUS as status,
    -- `amount` is currently stored in cents, so we convert it to dollars
    amount / 100 as amount,
    created as created_at

FROM {{ source('stripe', 'payment') }}