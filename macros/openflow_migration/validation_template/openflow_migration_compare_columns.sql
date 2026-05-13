{#- Schema / column inventory: audit_helper.compare_relation_columns (names, types, ordinals). -#}
{% test openflow_migration_compare_columns(model, baseline) %}

  select *
  from (
    {{ audit_helper.compare_relation_columns(
        a_relation=baseline,
        b_relation=model
    ) }}
  ) column_diffs
  where in_a_only or in_b_only

{% endtest %}
