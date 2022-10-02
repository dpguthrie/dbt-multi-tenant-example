with customers as (
    select *
    from {{ ref('cust_1_dim_customers')}}
)

select
    market_segment,
    sum(account_balance) as total_account_balance
from customers
group by 1