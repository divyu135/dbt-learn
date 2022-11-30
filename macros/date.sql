-- How to calculate century for 19xx, 20xx,
{%- macro calc_century(column_name) -%}
    CASE
        WHEN CAST({{ column_name }} AS INT) < 49 THEN '20'
        ELSE '19'
    END
{%- endmacro -%}


-- String to  date conversion
{%- macro string_to_date(column_name, input_format = '%F') -%}
    {{ return(adapter.dispatch('string_to_date')(column_name, input_format)) }}
{%- endmacro -%}

{%- macro default__string_to_date(column_name, input_format) -%}
    PARSE_DATE('{{ input_format }}', {{ column_name }})
{%- endmacro -%}

{%- macro postgres__string_to_date(column_name, input_format) -%}
    TO_DATE({{ column_name }}, '{{ input_format }}')
{%- endmacro -%}




-- Standardize date resulting from concating different columns
{%- macro standardize_date(day, month, year, century) -%}
    {{ adapter.dispatch('standardize_date')(day, month, year, century, output_format) }}
{%- endmacro -%}

{%- macro default__standardize_date(day, month, year, century) -%}
    
    {%- if century -%}
        CAST( 
            CONCAT ({{ century }}, {{ year }},'-', {{ month }},'-', {{ day }}) 
            AS DATE FORMAT 'YYYY-MM-DD' 
        )
    {%- else -%}
        CASE WHEN CHAR_LENGTH(CAST({{ year }} AS STRING)) = 2 
            THEN CAST ( 
                CONCAT ({{ calc_century(year) }}, {{ year }},'-', {{ month }},'-', {{ day }}) 
                AS DATE FORMAT 'YYYY-MM-DD' 
            )
            ELSE CAST ( 
                CONCAT ({{ year }},'-', {{ month }},'-', {{ day }}) 
                AS DATE FORMAT 'YYYY-MM-DD' 
            )
        END
    {%- endif -%}
{%- endmacro -%}



-- Format list of dates
-- pass date fields as list of dictionary
-- {% set date_fields = [
--     {'DATE_COLUMN': 'date_col1', 'DATE_FORMAT': '%d/%m/%y', 'CENTURY_COLUMN': 'cc_col1', 'F_NAME': 'new_date_col1' } ,
--     {'DATE_COLUMN': 'date_col2', 'DATE_FORMAT': '%d/%m/%y', 'CENTURY_COLUMN': 'cc_col2', 'F_NAME': 'new_date_col2' } ,
--     {'DATE_COLUMN': 'date_col3', 'DATE_FORMAT': '%d/%m/%Y', 'F_NAME': 'new_date_col2' } 
-- ] %}

{%- macro format_date_fields(fields) -%}
    {% for field in fields %}
        {%- if field.CENTURY_COLUMN -%}
            {%- set new_date_format  = field.DATE_FORMAT+"%C" -%}
            {{ string_to_date( dbt.concat([field.DATE_COLUMN, field.CENTURY_COLUMN]) , input_format = new_date_format ) }} as {{ field.F_NAME | d(field.DATE_COLUMN) }} 
        {%- else -%}
            {{ string_to_date( field.DATE_COLUMN, input_format = field.DATE_FORMAT) }} as {{ field.F_NAME | d(field.DATE_COLUMN) }}
        {%- endif -%}
        {%- if not loop.last -%}
        ,
        {%- endif %}
    {% endfor -%}
{%- endmacro -%}