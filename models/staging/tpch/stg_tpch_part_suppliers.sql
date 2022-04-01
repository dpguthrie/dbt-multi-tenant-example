with source as (

    {{ union_source('cust_%', 'partsupp') }}

),

renamed as (

    select
    
        {{ dbt_utils.surrogate_key(
            ['ps_partkey', 
            'ps_suppkey']) }} 
                as part_supplier_key,
        ps_partkey as part_key,
        ps_suppkey as supplier_key,
        ps_availqty as available_quantity,
        ps_supplycost as cost,
        ps_comment as comment,
        split(_customer_schema, '.')[1]::string as customer

    from source

)

select * from renamed