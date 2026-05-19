{% test auto_validation_no_data_gaps_calendar(
    model,
    time_column,
    start_date=none,
    end_date=none
) %}

  {% set _end_absent = end_date is none or end_date == '' or (end_date | string | trim == '') %}
  {% set _start_absent = start_date is none or start_date == '' or (start_date | string | trim == '') %}

  {% if _end_absent %}
    {% set _gap_end = run_started_at.strftime('%Y-%m-%d') %}
  {% else %}
    {% set _gap_end = end_date %}
  {% endif %}

  {% if _start_absent %}
    {% set _end_dt = modules.datetime.datetime.strptime(_gap_end | string, '%Y-%m-%d') %}
    {% set _gap_start = (_end_dt - modules.datetime.timedelta(days=3)).strftime('%Y-%m-%d') %}
  {% else %}
    {% set _gap_start = start_date %}
  {% endif %}

  {% set tc = adapter.quote(time_column) %}

  with bounds as (
    select
      to_date('{{ _gap_start }}') as start_dt,
      to_date('{{ _gap_end }}') as end_dt,
      datediff(day, to_date('{{ _gap_start }}'), to_date('{{ _gap_end }}')) + 1 as n_days
  ),
  spine as (
    select dateadd(day, s.n, b.start_dt)::date as expected_period
    from bounds b
    inner join (
      select row_number() over (order by seq4()) - 1 as n
      from table(generator(rowcount => 100000))
    ) s
      on s.n < b.n_days
  ),
  actual as (
    select distinct to_date({{ tc }}) as actual_period
    from {{ model }}
    cross join bounds b
    where to_date({{ tc }}) between b.start_dt and b.end_dt
  )
  select s.expected_period
  from spine s
  left join actual a on s.expected_period = a.actual_period
  where a.actual_period is null

{% endtest %}
