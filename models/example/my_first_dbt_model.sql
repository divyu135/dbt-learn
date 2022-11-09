
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/
{% set format_string = '%y-%m-%d' %}

{{ config(materialized='table') }}

with source_data as (

    select 1 as id,
    {{ calc_century('year') }} as century,
    {{ string_to_date( '22-12-14', format_string) }} as test_date
    union all
    select null as id, null as century, null as test_date

)

select *
from source_data

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
