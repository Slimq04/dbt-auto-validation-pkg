{#-
  Aggregated baseline vs model via audit_helper.compare_queries (GROUP BY + sum/count).

  Optional date filter when time_column is set (non-blank): both subqueries add
  where to_date(<time_column>) between to_date('<start>') and to_date('<end>').
  Omitted start_date / end_date default at compile time like auto_validation_no_data_gaps_calendar:
    end → calendar day of run_started_at; start → end minus 3 calendar days.
  Partial overrides: only end_date → start defaults to end−3; only start_date → end defaults to run_started_at day.

  group_by_columns: if empty, falls back to composite_key_columns for GROUP BY / primary_key.
-#}
{% test auto_validation_compare_queries(
    model,
    baseline,
    composite_key_columns,
    group_by_columns=[],
    sum_columns=[],
    count_columns=[],
    time_column=none,
    start_date=none,
    end_date=none,
    summarize=false,
    limit=500
) %}

  {% set _grp = group_by_columns if group_by_columns is not none and (group_by_columns | length) > 0 else composite_key_columns %}
  {% set _sum_cols = sum_columns if sum_columns is not none else [] %}
  {% set _cnt_cols = count_columns if count_columns is not none else [] %}

  {% set _tc_nonempty = time_column is not none and (time_column | string | trim) != '' %}
  {% set _end_absent = end_date is none or end_date == '' or (end_date | string | trim == '') %}
  {% set _start_absent = start_date is none or start_date == '' or (start_date | string | trim == '') %}

  {% if _tc_nonempty %}
    {% if _end_absent %}
      {% set _gap_end = run_started_at.strftime('%Y-%m-%d') %}
    {% else %}
      {% set _gap_end = end_date | string | trim %}
    {% endif %}

    {% if _start_absent %}
      {% set _end_dt = modules.datetime.datetime.strptime(_gap_end | string, '%Y-%m-%d') %}
      {% set _gap_start = (_end_dt - modules.datetime.timedelta(days=3)).strftime('%Y-%m-%d') %}
    {% else %}
      {% set _gap_start = start_date | string | trim %}
    {% endif %}

    {% set _tc_q = adapter.quote(time_column | string | trim) %}
    {% set _sd_lit = _gap_start %}
    {% set _ed_lit = _gap_end %}
  {% endif %}

  {% if (_grp | length) == 0 %}
    {% do exceptions.raise_compiler_error(
      "auto_validation_compare_queries: set group_by_columns (non-empty) or composite_key_columns for GROUP BY."
    ) %}
  {% endif %}

  {% if (_sum_cols | length) == 0 and (_cnt_cols | length) == 0 %}
    {% do exceptions.raise_compiler_error(
      "auto_validation_compare_queries: provide at least one column in sum_columns and/or count_columns."
    ) %}
  {% endif %}

  {% for c in _grp %}
    {% if c in _sum_cols %}
      {% do exceptions.raise_compiler_error(
        "auto_validation_compare_queries: group-by columns must not appear in sum_columns (" ~ c ~ ")."
      ) %}
    {% endif %}
  {% endfor %}

  {% set group_by_expr = dbt_auto_validation_pkg.auto_validation_composite_key_order_expression(_grp) %}
  {% set key_select = group_by_expr %}
  {% set primary_key = group_by_expr %}

  {% set metric_exprs = [] %}
  {% for c in _sum_cols %}
    {% do metric_exprs.append(
      'sum(coalesce(' ~ adapter.quote(c) ~ ', 0)) as ' ~ adapter.quote('sum__' ~ c)
    ) %}
  {% endfor %}
  {% for c in _cnt_cols %}
    {% do metric_exprs.append(
      'count(' ~ adapter.quote(c) ~ ') as ' ~ adapter.quote('cnt__' ~ c)
    ) %}
  {% endfor %}
  {% set metric_select = metric_exprs | join(', ') %}

  {% set a_query %}
    select
      {{ key_select }},
      {{ metric_select }}
    from {{ baseline }}
    {% if _tc_nonempty %}
    where to_date({{ _tc_q }}) between to_date('{{ _sd_lit }}') and to_date('{{ _ed_lit }}')
    {% endif %}
    group by {{ group_by_expr }}
  {% endset %}

  {% set b_query %}
    select
      {{ key_select }},
      {{ metric_select }}
    from {{ model }}
    {% if _tc_nonempty %}
    where to_date({{ _tc_q }}) between to_date('{{ _sd_lit }}') and to_date('{{ _ed_lit }}')
    {% endif %}
    group by {{ group_by_expr }}
  {% endset %}

  {{ audit_helper.compare_queries(
      a_query=a_query,
      b_query=b_query,
      primary_key=primary_key,
      summarize=summarize,
      limit=limit
  ) }}

{% endtest %}
