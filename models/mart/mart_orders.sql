with orders as (

    select * from {{ ref('staging_jaffle_shop__orders') }}

),

payments as (

    select * from {{ ref('staging_stripe__payment') }}

),

order_payments as (

    select
        order_id,

        {% for payment_method in var('payment_methods') %}

        sum(case when payment_method = '{{ payment_method }}' then amount else 0 end) as {{ payment_method }}_amount,
        
        {% endfor -%}

        sum(amount) as total_amount

    from payments

    group by order_id

),

final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        orders.status,

        {% for payment_method in var('payment_methods') %}

        order_payments.{{ payment_method }}_amount,

        {% endfor -%}

        order_payments.total_amount as amount

    from orders


    left join order_payments
        on orders.order_id = order_payments.order_id

)

select * from final