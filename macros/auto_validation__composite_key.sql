{#-
  Shared SQL fragment helpers for auto_validation comparison tests.
-#}

{% macro auto_validation_composite_key_order_expression(composite_key_columns) %}
  {%- for col in composite_key_columns -%}
    {{ adapter.quote(col) }}{% if not loop.last %}, {% endif %}
  {%- endfor -%}
{% endmacro %}
