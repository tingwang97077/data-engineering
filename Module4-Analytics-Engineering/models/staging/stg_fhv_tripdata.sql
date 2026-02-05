{{
    config(
        materialized='view'
    )
}}

with source as (
    select * from {{ source('raw', 'fhv_tripdata') }}
),

renamed as (
    select
        -- identifiers
        unique_row_id,
        filename,
        dispatching_base_num,
        Affiliated_base_number as affiliated_base_number,
        
        -- locations
        cast(PULocationID as integer) as pickup_location_id,
        cast(DOLocationID as integer) as dropoff_location_id,
        
        -- timestamps
        cast(pickup_datetime as timestamp) as pickup_datetime,
        cast(dropoff_datetime as timestamp) as dropoff_datetime,
        
        -- trip info
        SR_Flag as sr_flag
        
    from source
    -- Filter out records with null dispatching_base_num (data quality requirement)
    where dispatching_base_num is not null
)

select * from renamed