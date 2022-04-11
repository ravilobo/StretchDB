# Pricing 

```sql
-- DS100 - ~750 DTU’s (7vCore) $2/Hr
-- DS200 – 1,500 DTU’s or (~14 vCores)
-- DS300 – 2250 DTU’s  (~22 vCores)
-- DS400 – 3,000 DTU’s (~30 vCores)
```

## Limitations

- Only on East US
- You cannot stretch to a local server
- No pause
- No published tables
- No CDC tables
- No SQL on Linux
- PK won't be enforced
- No data types
  - XML
  - text
- Constraints
  - default and check
- Limited DML on stretched tables
  - You add a column, but cannot drop one!