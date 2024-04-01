with source as (
      select * from {{ source('jaffle_shop', 'orders') }}
),
renamed as (
    select
        ID as order_id,
        USER_ID as customer_id,
        ORDER_DATE as order_date,
        STATUS as status

    from source
)
select * from renamed
  