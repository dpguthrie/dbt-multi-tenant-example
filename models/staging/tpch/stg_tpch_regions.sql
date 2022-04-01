with source as (

    {{ union_source('cust_%', 'region') }}

),

renamed as (

    select
        r_regionkey as region_key,
        r_name as name,
        r_comment as comment,
        split(_customer_schema, '.')[1]::string as customer

    from source

)

select * from renamed