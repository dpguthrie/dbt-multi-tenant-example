with source as (

    {{ union_source('cust_%', 'part') }}

),

renamed as (

    select
    
        p_partkey as part_key,
        p_name as name,
        p_mfgr as manufacturer,
        p_brand as brand,
        p_type as type,
        p_size as size,
        p_container as container,
        p_retailprice as retail_price,
        p_comment as comment,
        split(_customer_schema, '.')[1]::string as customer

    from source

)

select * from renamed