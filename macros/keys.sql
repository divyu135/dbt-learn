{%- macro composite_key(fields) -%}
    {{ adapter.dispatch('composite_key')(fields) }}
{%- endmacro -%}


{%- macro default__composite_key(fields,sep = '~', def_null_val = '') -%}
    {%- set new_fields = [] -%}

    {%- for field in fields -%}
        {%- do new_fields.append(
            "COALESCE(CAST( " ~field~ " as STRING ), '" ~def_null_val~ "' )" )
        -%}
        {%- if not loop.last %}
            {%- do new_fields.append(sep) -%}
        {%- endif -%}
    {%- endfor -%}
    
    {{ dbt.concat(new_fields) }}

{%- endmacro -%}