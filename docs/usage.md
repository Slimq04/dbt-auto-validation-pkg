# Usage

## 1. Dependencies (once)

In **`packages.yml`**: this package, **`audit_helper`** (needed for `compare_queries` / `compare_columns`), optional **`codegen`**. Then:

```bash
dbt deps
```

## 2. Models & YAML

Create or reuse a **`.yml`** (e.g. `_openflow_migration_models.yml`) for the models under test.

## 3. Generate snippets

```bash
dbt run-operation generate_openflow_migration_tests --args '{
  "model_name": "your_new_model",
  "stage": "raw_ingestion",
  "composite_key_columns": ["id", "other_key"],
  "baseline": "ref('legacy_baseline_model')",
  "group_by_columns": ["dim_a"],
  "sum_columns": ["amount"],
  "count_columns": []
}'
```

Paste the **log output** into that YAML under the right model. Full signature: `macros/generate_openflow_migration_tests.sql`.

### Parameters by stage

**`raw_ingestion` / `raw_snapshotting`**

| Check | Arguments |
| --- | --- |
| No dups | `model_name`, `stage`, `composite_key_columns` |
| Metrics match | above + `baseline`, non-empty `group_by_columns`, at least one of `sum_columns` / `count_columns`; optional `time_column`, `start_date`, `end_date` |

**`modeling_downstream`**

| Check | Arguments |
| --- | --- |
| No dups | `model_name`, `stage`, `composite_key_columns` |
| Column match | `baseline` |
| No data gaps | `time_column`; optional `start_date`, `end_date` |

## 4. Run tests

```bash
dbt test --select your_new_model
```
