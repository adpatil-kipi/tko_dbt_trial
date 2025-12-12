{{
    config(

        materialized='table',
        schema='MARTS' 

    )
}}

WITH listing_reviews_pre_agg AS (

    SELECT
        l.host_id,
        l.host_name,
        l.price, 
        COUNT(r.listing_id) AS review_count 
    FROM

        {{ ref('dim_listings_w_hosts') }} l 
    LEFT JOIN

        {{ ref('fact_reviews') }} r 
        ON l.listing_id = r.listing_id
    GROUP BY
        l.host_id, 
        l.host_name, 
        l.price 
),

final_host_metrics AS (
    SELECT
        host_id,

        MAX(host_name) AS host_name,

        COUNT(price) AS total_listings, 
        AVG(price) AS avg_listing_price,

        SUM(review_count) AS total_reviews,
        

        (AVG(price) * SUM(review_count)) / NULLIF(COUNT(price), 0) AS host_performance_score
    FROM
        listing_reviews_pre_agg
    GROUP BY
        host_id
)


SELECT
    host_id,
    host_name,
    total_listings,
    avg_listing_price,
    total_reviews,
    host_performance_score
FROM
    final_host_metrics
ORDER BY
    host_performance_score DESC