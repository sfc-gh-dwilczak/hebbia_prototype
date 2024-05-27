{# macro loaded docs: #}
{# Reload a source table using "create or replace transient table" if the data has changed. #}
{# Return the name of the loaded table. #}
{# Usage: select * from {{ loaded("sp", "ciqcompany") }} #}

{% macro loaded(source_name, table_name) %}
    {# DBT source reference defined in souorce__sp.yml file. #}
    {% set source_model = source(source_name, table_name) %}

    {# Parse the name of the loaded table. #}
    {# Use dev/prod database. #}
    {% set database = this.database.lower() %}
    {# Use schema/table name based on the data source. #}
    {% set schema = "loaded_" ~ source_model.schema.lower() %}
    {% set identifier = source_model.identifier.lower() %}
    {# Combine for final table name. #}
    {% set loaded_model = database ~ "." ~ schema ~ "." ~ identifier %}

    {# Example loaded_model name: #}
    {# loaded("sp", "ciqcompany") = dev.loaded_xpressfeed.ciqcompany #}

    {# DBT has runtime vs compile time. #}
    {# Executing queries against the database cannot be done during compile time. #}
    {# Check if not execution time and just return the loaded table name. #}
    {% if not execute %}
        {{ return(loaded_model) }}
    {% endif %}

    {# Setup the schema and table if they don't exist. #}
    {% do run_query("create schema if not exists " ~ database ~ "." ~ schema) %}
    {% do run_query("create transient table if not exists " ~ loaded_model ~ " as select * from " ~ source_model) %}
    
    {# Check the hash of the source table and loaded table. #}
    {% set query %}
        select hash_agg(*) from {{ source_model }}
        minus
        select hash_agg(*) from {{ loaded_model }}
    {% endset %}

    {# If there are no rows, the hash is the same. #}
    {# If there are rows, reload the table. #}
    {% for row in run_query(query) %}
        {% do run_query("create or replace transient table " ~ loaded_model ~ " as select * from " ~ source_model) %}
    {% endfor %}

    {# Return the loaded table name. #}
    {{ return(loaded_model) }}

{% endmacro %}

