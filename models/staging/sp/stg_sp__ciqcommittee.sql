with 

source as (

    select * from {{ loaded('sp', 'ciqcommittee') }}

),

renamed as (

    select
        committeeid,
        committeename

    from source

)

select * from renamed
