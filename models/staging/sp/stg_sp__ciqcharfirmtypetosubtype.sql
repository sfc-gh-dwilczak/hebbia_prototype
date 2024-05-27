with 

source as (

    select * from {{ loaded('sp', 'ciqcharfirmtypetosubtype') }}

),

renamed as (

    select
        chartypeid,
        subtypeid,
        pacvertofeedpop

    from source

)

select * from renamed
