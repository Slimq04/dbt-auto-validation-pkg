{#-
  Prints schema.yml snippets for auto_validation comparison tests (any baseline vs model workflow).
-#}

{% macro generate_auto_validation_tests(
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

  {% set lines = [] %}

  {% if stage in ['raw_ingestion', 'raw_snapshotting'] %}
    {% do lines.append('  - name: ' ~ model_name) %}
    {% do lines.append('    description: Auto validation (' ~ stage ~ ')') %}
    {% do lines.append('    tests:') %}
    {% do lines.append('      - auto_validation_no_duplicates:') %}
    {% do lines.append('          composite_key_columns:') %}
    {% for c in composite_key_columns %}
      {% do lines.append('            - ' ~ c) %}
    {% endfor %}
    {% if baseline is not none %}
      {% set _gb = group_by_columns if group_by_columns is not none else [] %}
      {% set _sum = sum_columns if sum_columns is not none else [] %}
      {% set _cnt = count_columns if count_columns is not none else [] %}
      {% if (_gb | length) > 0 and ((_sum | length) > 0 or (_cnt | length) > 0) %}
        {% do lines.append('      - auto_validation_compare_queries:') %}
        {% do lines.append('          baseline: ' ~ baseline) %}
        {% do lines.append('          composite_key_columns:') %}
        {% for c in composite_key_columns %}
          {% do lines.append('            - ' ~ c) %}
        {% endfor %}
        {% do lines.append('          group_by_columns:') %}
        {% for c in _gb %}
          {% do lines.append('            - ' ~ c) %}
        {% endfor %}
        {% if (_sum | length) > 0 %}
          {% do lines.append('          sum_columns:') %}
          {% for c in _sum %}
            {% do lines.append('            - ' ~ c) %}
          {% endfor %}
        {% else %}
          {% do lines.append('          sum_columns: []') %}
        {% endif %}
        {% if (_cnt | length) > 0 %}
          {% do lines.append('          count_columns:') %}
          {% for c in _cnt %}
            {% do lines.append('            - ' ~ c) %}
          {% endfor %}
        {% else %}
          {% do lines.append('          count_columns: []') %}
        {% endif %}
        {% do lines.append('          summarize: false') %}
        {% set _tcf = time_column is not none and (time_column | string | trim) != '' %}
        {% if _tcf %}
          {% do lines.append('          time_column: ' ~ (time_column | string | trim)) %}
          {% set _sdf = start_date is not none and (start_date | string | trim) != '' %}
          {% set _edf = end_date is not none and (end_date | string | trim) != '' %}
          {% if _sdf %}
            {% do lines.append('          start_date: \"' ~ (start_date | string | trim) ~ '\"') %}
          {% endif %}
          {% if _edf %}
            {% do lines.append('          end_date: \"' ~ (end_date | string | trim) ~ '\"') %}
          {% endif %}
        {% endif %}
      {% endif %}
    {% endif %}

  {% elif stage == 'modeling_downstream' %}
    {% do lines.append('  - name: ' ~ model_name) %}
    {% do lines.append('    description: Auto validation (modeling_downstream)') %}
    {% do lines.append('    tests:') %}
    {% do lines.append('      - auto_validation_no_duplicates:') %}
    {% do lines.append('          composite_key_columns:') %}
    {% for c in composite_key_columns %}
      {% do lines.append('            - ' ~ c) %}
    {% endfor %}
    {% if baseline is not none %}
      {% do lines.append('      - auto_validation_compare_columns:') %}
      {% do lines.append('          baseline: ' ~ baseline) %}
    {% endif %}
    {% if time_column is not none %}
      {% do lines.append('      - auto_validation_no_data_gaps_calendar:') %}
      {% do lines.append('          time_column: ' ~ time_column) %}
      {% if start_date is not none %}
        {% do lines.append('          start_date: "' ~ start_date ~ '"') %}
      {% endif %}
      {% if end_date is not none %}
        {% do lines.append('          end_date: "' ~ end_date ~ '"') %}
      {% endif %}
    {% endif %}

  {% else %}
    {% do exceptions.raise_compiler_error("Unknown stage: " ~ stage ~ ". Use raw_ingestion, raw_snapshotting, or modeling_downstream.") %}
  {% endif %}

  {% do log(lines | join('\n'), info=True) %}

{% endmacro %}
