{% test openflow_migration_no_duplicates(model, composite_key_columns) %}

  select
    {% for col in composite_key_columns -%}
      {{ adapter.quote(col) }}{% if not loop.last %},
      {% endif %}
    {%- endfor %},
    count(*) as duplicate_row_count
  from {{ model }}
  group by
    {% for col in composite_key_columns -%}
      {{ adapter.quote(col) }}{% if not loop.last %},
      {% endif %}
    {%- endfor %}
  having count(*) > 1

{% endtest %}
