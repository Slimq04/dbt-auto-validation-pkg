# Migrating from `openflow_migration_*` (v1.x)

Breaking change in **v2.0.0**: generic **`auto_validation_*`** names replace the Openflow-specific prefix.

## Tests in YAML

| Before (v1.x) | After (v2.0.0) |
| --- | --- |
| `openflow_migration_no_duplicates` | `auto_validation_no_duplicates` |
| `openflow_migration_compare_queries` | `auto_validation_compare_queries` |
| `openflow_migration_compare_columns` | `auto_validation_compare_columns` |
| `openflow_migration_no_data_gaps_calendar` | `auto_validation_no_data_gaps_calendar` |

## Snippet generator

| Before | After |
| --- | --- |
| `dbt run-operation generate_openflow_migration_tests` | `dbt run-operation generate_auto_validation_tests` |

`generate_openflow_migration_tests` still exists as a **deprecated** alias and forwards to `generate_auto_validation_tests`.

## Internal helper (only if you referenced it in custom code)

| Before | After |
| --- | --- |
| `openflow_migration_composite_key_order_expression` | `auto_validation_composite_key_order_expression` |

Installed packages should call via `dbt_auto_validation_pkg.auto_validation_composite_key_order_expression(...)`.
