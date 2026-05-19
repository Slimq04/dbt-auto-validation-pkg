{#- Deprecated: use `generate_auto_validation_tests` (same arguments). Will be removed later. -#}
{% macro generate_openflow_migration_tests(
    model_name,
    stage,
    composite_key_columns,
    baseline=none,
    time_column=none,
    start_date=none,
    end_date=none,
    group_by_columns=none,
    sum_columns=none,
    count_columns=none
) %}
  {% do dbt_auto_validation_pkg.generate_auto_validation_tests(
    model_name,
    stage,
    composite_key_columns,
    baseline,
    time_column,
    start_date,
    end_date,
    group_by_columns,
    sum_columns,
    count_columns
  ) %}
{% endmacro %}
