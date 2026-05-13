# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-05-13
### Infrastructure
```
dbt-auto-validation-pkg/
├── macros/
│   ├── comparison/        
│   │   ├── compare_queries.sql           
│   │   ├── compare_columns.sql             
│   │   ├── no_duplicates.sql             
│   │   └── no_data_gaps_calendar.sql      
│   │
│   └── generate_openflow_migration_tests.sql # run-operation: Print contents for .yml
└── ——— openflow_migration__composite_key.sql # helper used by compare_queries
```


### Added

- **Openflow migration validation tests** (under `macros/comparison/`), intended for comparing legacy Openflow pipelines to dbt models:
  - `openflow_migration_no_duplicates` — duplicate detection on a composite key.
  - `openflow_migration_compare_queries` — grouped baseline vs model comparison via `audit_helper.compare_queries` (optional time window defaults aligned with the calendar-gap test).
  - `openflow_migration_compare_columns` — column name / type / ordinal diffs via `audit_helper.compare_relation_columns`.
  - `openflow_migration_no_data_gaps_calendar` — calendar spine vs distinct dates in a configurable window.
- **`generate_openflow_migration_tests`** (`macros/generate_openflow_migration_tests.sql`) — logs ready-to-paste `schema.yml` snippets for `raw_ingestion`, `raw_snapshotting`, and `modeling_downstream` stages.
- **`openflow_migration_composite_key_order_expression`** (`macros/openflow_migration__composite_key.sql`) — shared quoted key list used by the compare-queries test.

### Notes

- Requires the [`audit_helper`](https://hub.getdbt.com/) package (or equivalent) providing `audit_helper.compare_queries` and `audit_helper.compare_relation_columns`.
- Macro paths remain `macros/`; consumers add this package in `packages.yml` and run `dbt deps`.

[1.0.0]: https://github.com/Slimq04/dbt-auto-validation-pkg/releases/tag/v1.0.0

### Infrastructure Expectation for v2.0.0
```
dbt-auto-validation-pkg/
├── macros/
│   ├── integrity/     
│   │   ├── no_duplicates_all_columns.sql
│   │   ├── unit_test_template.sql    
│   │   └── json_column_valid.sql      
│   │
│   ├── comparison/        
│   │   ├── compare_queries.sql           
│   │   ├── compare_columns.sql             
│   │   ├── no_duplicates.sql             
│   │   └── no_data_gaps_calendar.sql      
│   │
│   └── generate_openflow_migration_tests.sql
└── ——— openflow_migration__composite_key.sql
```
Expect delivery date: `2026/05/15`
