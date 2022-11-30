{%- macro standardize_datetime(column_name, input_format='%Y-%m-%d %H:%M:%S') -%}
    PARSE_DATETIME('{{ input_format }}', cast({{ column_name }} as string) )
{%- endmacro -%}