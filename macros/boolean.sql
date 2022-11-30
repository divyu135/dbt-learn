{%- macro standardize_boolean(column_name) -%}
  cast(
        case
          when lower(trim(cast({{ column_name }} as string ) )) IN ('true', 't', '1', 'yes', 'y') then true
          when lower(trim(cast({{ column_name }} as string ) )) IN ('false', 'f', '0', 'no', 'n') then false
        end
    as boolean) as {{ column_name }}
{%- endmacro -%}