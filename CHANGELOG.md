# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-05-19

### Changed (breaking)

- Renamed generic tests and helpers from `openflow_migration_*` to **`auto_validation_*`** so they are not tied to Openflow only:
  - `openflow_migration_no_duplicates` → `auto_validation_no_duplicates`
  - `openflow_migration_compare_queries` → `auto_validation_compare_queries`
  - `openflow_migration_compare_columns` → `auto_validation_compare_columns`
  - `openflow_migration_no_data_gaps_calendar` → `auto_validation_no_data_gaps_calendar`
- Renamed helper macro `openflow_migration_composite_key_order_expression` → **`auto_validation_composite_key_order_expression`** (`macros/auto_validation__composite_key.sql`).
- Renamed snippet generator **`generate_openflow_migration_tests`** → **`generate_auto_validation_tests`** (`macros/generate_auto_validation_tests.sql`).
- `generate_openflow_migration_tests` remains as a **deprecated** thin wrapper (same arguments) until a future removal.

See **`docs/migration.md`** for a copy-paste rename table.

[2.0.0]: https://github.com/Slimq04/dbt-auto-validation-pkg/releases/tag/v2.0.0

## [1.1.1] - 2026-05-19

### Fixed

- `openflow_migration_compare_queries`: call `openflow_migration_composite_key_order_expression` via `dbt_auto_validation_pkg.` so the helper resolves when the package is installed in another project (avoids `'...' is undefined` at compile time).

[1.1.1]: https://github.com/Slimq04/dbt-auto-validation-pkg/releases/tag/v1.1.1

## [1.1.0] - 2026-05-19

### Changed

- Renamed macro directory `audit_helper_comparisons` → `comparison` (Openflow migration tests unchanged by name).

### Added

- `docs/usage.md` — install, `run-operation`, parameter tables, `dbt test`.
- `docs/migration.md` — placeholder (filled in v2.0.0 with v1 → v2 rename guide).
- `macros/integrity/` — placeholder directory for future integrity macros.

[1.1.0]: https://github.com/Slimq04/dbt-auto-validation-pkg/releases/tag/v1.1.0

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
