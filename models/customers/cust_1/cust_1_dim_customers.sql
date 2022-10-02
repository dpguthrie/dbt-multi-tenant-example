with customer_subset as (
    select
        *,
        case
            when market_segment = 'HOUSEHOLD' then .1
            when market_segment = 'AUTOMOBILE' then .2
            when market_segment = 'MACHINERY' then .3
            else .4
        end as balance_discount
    from {{ ref('dim_customers')}}
    where customer = 'CUST_1'
)

select
    customer_key,
    name,
    address, 
    nation,
    region,
    phone_number,
    market_segment,
    account_balance * balance_discount as account_balance
from customer_subset