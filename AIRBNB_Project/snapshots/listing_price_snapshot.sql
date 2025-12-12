{% snapshot listing_price_snapshot %}

{{
    config(
        strategy='check',
        check_cols=['price'], 
        unique_key='listing_id',
        target_model='dim_listings_w_hosts',
        target_schema='SCD_HISTORY' 
    )
}}


SELECT
    listing_id,
    price,
    updated_at AS dbt_updated_at
FROM
    {{ ref('dim_listings_w_hosts') }}

{% endsnapshot %}