-- Standardize name
{%- macro standardize_name(column_name, null_list=['', 'n/a', 'na', 'n.a', 'undef', 'null', 'nil', '404040404040.4000']) -%}
    {{ adapter.dispatch('standardize_name')(column_name, null_list) }}
{%- endmacro -%}

{%- macro default__standardize_name(column_name, null_list) -%}
    case
      when lower(trim({{ column_name }})) in ({%- for null_str in null_list -%} '{{ null_str }}'{%- if not loop.last -%},{%- endif -%} {%- endfor -%})
        then null
      else
        trim({{ column_name }})
end as {{ column_name }}
{%- endmacro -%}




-- Standardize strings
{%- macro standardize_string(column_name, null_list = ['', 'n/a', 'n.a', 'undef', 'null', 'nan', 'nil']) -%}
    {{ adapter.dispatch('standardize_string')(column_name, null_list) }}
{%- endmacro -%}

{%- macro default__standardize_string(column_name, null_list) -%}
  case
      when lower(trim({{ column_name }})) in ({%- for null_str in null_list -%} '{{ null_str }}'{%- if not loop.last -%},{%- endif -%} {%- endfor -%})
        then null
      else
        trim({{ column_name }})
end as {{ column_name }}
{%- endmacro -%}