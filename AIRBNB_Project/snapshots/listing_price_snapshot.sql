{% snapshot listing_price_snapshot %}

{{
    config(
        strategy='check',
        check_cols=['price'], 
        unique_key='listing_id',
        target_schema='DEV')
}}

SELECT
    listing_id,
    price
FROM
    {{ ref('dim_listings_w_hosts') }}
{% endsnapshot %}