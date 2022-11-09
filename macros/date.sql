{% macro calc_century(year) %}
    case 
        when cast({{ year }} as INT ) < 49 then '20' 
        else '19' 
    end
{% endmacro %}

{% macro string_to_date(date_column, format_string) %}
    {%- if format_string -%}
        PARSE_DATE({{ format_string }}, trim({{ date_column }}))
    {%- else -%}
        PARSE_DATE('%Y-%m-%d', trim({{ date_column }}))
    {%- endif -%}
{% endmacro %}