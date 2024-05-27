with 

source as (

    select * from {{ loaded('sp', 'ciqcompany') }}

),

renamed as (

    select
        companyid,
        companyname,
        city,
        companystatustypeid,
        companytypeid,
        officefaxvalue,
        officephonevalue,
        otherphonevalue,
        simpleindustryid,
        streetaddress,
        streetaddress2,
        streetaddress3,
        streetaddress4,
        yearfounded,
        monthfounded,
        dayfounded,
        zipcode,
        webpage,
        reportingtemplatetypeid,
        countryid,
        stateid,
        incorporationcountryid,
        incorporationstateid

    from source

)

select * from renamed
