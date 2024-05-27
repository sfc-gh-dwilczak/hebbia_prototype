with 

source as (

    select * from {{ loaded('sp', 'ciqcharfirmtype') }}

),

renamed as (

    select
        chartypeid,
        chartypevalue,
        pacvertofeedpop

    from source

)

select * from renamed
