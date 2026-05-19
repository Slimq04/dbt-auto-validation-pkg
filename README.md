# dbt-auto-validation-pkg

dbt package: **`auto_validation_*`** generic tests (duplicates, grouped metric compare, column diff, calendar gaps) plus **`generate_auto_validation_tests`** for pasting YAML snippets. See [Usage](docs/usage.md) and [Migrating from v1.x](docs/migration.md).

Requires [`audit_helper`](https://hub.getdbt.com/) for the comparison-based tests. Add this repo to **`packages.yml`** and run **`dbt deps`**.

## Development

```bash
git clone git@github.com:Slimq04/dbt-auto-validation-pkg.git
cd dbt-auto-validation-pkg
```
