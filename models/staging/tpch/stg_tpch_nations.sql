with source as (

    {{ union_source('cust_%', 'nation') }}

),

renamed as (

    select
    
        n_nationkey as nation_key,
        n_name as name,
        n_regionkey as region_key,
        n_comment as comment,
        split(_customer_schema, '.')[1]::string as customer

    from source

)

select * from renamed