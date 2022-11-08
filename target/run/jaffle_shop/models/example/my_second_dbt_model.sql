

  create or replace view `divya-dbt-learn`.`dbt_divya`.`my_second_dbt_model`
  OPTIONS()
  as -- Use the `ref` function to select from other models

select *
from `divya-dbt-learn`.`dbt_divya`.`my_first_dbt_model`
where id = 1;

