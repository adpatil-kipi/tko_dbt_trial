{{
    config(
        
        materialized='table',
        schema='DEV' 
    )
}}

with source_listings as (


    select 
        host_is_superhost,
        listing_id
    from 
        {{ ref('dim_listings_w_hosts') }} 


)


select

    case 
        when host_is_superhost = 't' then TRUE 
        else FALSE 
    end as host_is_superhost_flag,
    

    count(listing_id) as total_listings

from
    source_listings

group by
    1