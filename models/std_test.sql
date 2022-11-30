{%- set col_cast_to_boolean = ["test_bool", "test_boolean"]  -%}

{%- set col_cast_to_date = [{"DATE_COLUMN": "temp_date", "DATE_FORMAT": "YYYY-MM-DD"}] -%}

{%- set straight_moves = ["settlement_system", "debit_credit_flag"] -%}



select 
    -- String standardization
    {{ standardize_name('test_name') }},

    -- Date standardization
    {{ format_date_fields(col_cast_to_date) }},

    -- Boolean standardization
    {{ standardize_boolean('test_bool') }},
    {{ standardize_boolean('test_boolean') }},

    --Datetime standardization
    {{ standardize_datetime('test_datetime') }},
    {{ standardize_datetime('test2_datetime','%Y-%m-%d %H:%M:%E*S') }}


from {{ source('dbt_divya','test_table') }}