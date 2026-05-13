{#-
  Helpers for Openflow migration validation tests.
-#}

{% macro openflow_migration_composite_key_order_expression(composite_key_columns) %}
  {%- for col in composite_key_columns -%}
    {{ adapter.quote(col) }}{% if not loop.last %}, {% endif %}
  {%- endfor -%}
{% endmacro %}
