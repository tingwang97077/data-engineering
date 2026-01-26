# Homework 2 — Workflow Orchestration

### Question 1 

Within the execution for Yellow Taxi data for the year 2020 and month 12: what is the uncompressed file size (i.e. the output file yellow_tripdata_2020-12.csv of the extract task)?

    - 128.3 MiB
    - 134.5 MiB
    - 364.7 MiB
    - 692.6 MiB

Answer : 128.3 MiB

### Question 2

What is the rendered value of the variable file when the inputs taxi is set to green, year is set to 2020, and month is set to 04 during execution?

    - `{{inputs.taxi}}_tripdata_{{inputs.year}}-{{inputs.month}}.csv`
    - `green_tripdata_2020-04.csv`
    - `green_tripdata_04_2020.csv`
    - `green_tripdata_2020.csv`

Answer : green_tripdata_2020-04.csv

### Question 3

How many rows are there for the Yellow Taxi data for all CSV files in the year 2020?

    - 13,537.299
    - 24,648,499
    - 18,324,219
    - 29,430,127

```sql
SELECT 
  'total' as period,
  SUM(row_count) as total_rows
FROM (
  SELECT '01' as month, COUNT(*) as row_count FROM `kestra-sandbox-485115.zoomcamp.yellow_tripdata_2020_01`
  UNION ALL
  SELECT '02', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.yellow_tripdata_2020_02`
  UNION ALL
  SELECT '03', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.yellow_tripdata_2020_03`
  UNION ALL
  SELECT '04', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.yellow_tripdata_2020_04`
  UNION ALL
  SELECT '05', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.yellow_tripdata_2020_05`
  UNION ALL
  SELECT '06', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.yellow_tripdata_2020_06`
  UNION ALL
  SELECT '07', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.yellow_tripdata_2020_07`
  UNION ALL
  SELECT '08', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.yellow_tripdata_2020_08`
  UNION ALL
  SELECT '09', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.yellow_tripdata_2020_09`
  UNION ALL
  SELECT '10', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.yellow_tripdata_2020_10`
  UNION ALL
  SELECT '11', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.yellow_tripdata_2020_11`
  UNION ALL
  SELECT '12', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.yellow_tripdata_2020_12`
)
```

Answer : 24,648,499

### Question 4

How many rows are there for the Green Taxi data for all CSV files in the year 2020?

    - 5,327,301
    - 936,199
    - 1,734,051
    - 1,342,034

```sql
SELECT 
  'total' as period,
  SUM(row_count) as total_rows
FROM (
  SELECT '01' as month, COUNT(*) as row_count FROM `kestra-sandbox-485115.zoomcamp.green_tripdata_2020_01`
  UNION ALL
  SELECT '02', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.green_tripdata_2020_02`
  UNION ALL
  SELECT '03', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.green_tripdata_2020_03`
  UNION ALL
  SELECT '04', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.green_tripdata_2020_04`
  UNION ALL
  SELECT '05', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.green_tripdata_2020_05`
  UNION ALL
  SELECT '06', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.green_tripdata_2020_06`
  UNION ALL
  SELECT '07', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.green_tripdata_2020_07`
  UNION ALL
  SELECT '08', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.green_tripdata_2020_08`
  UNION ALL
  SELECT '09', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.green_tripdata_2020_09`
  UNION ALL
  SELECT '10', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.green_tripdata_2020_10`
  UNION ALL
  SELECT '11', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.green_tripdata_2020_11`
  UNION ALL
  SELECT '12', COUNT(*) FROM `kestra-sandbox-485115.zoomcamp.green_tripdata_2020_12`
)
```

Answer : 1,734,051

### Question 5

How many rows are there for the Yellow Taxi data for the March 2021 CSV file?

    - 1,428,092
    - 706,911
    - 1,925,152
    - 2,561,031

```sql
SELECT 
  SUM(row_count) as total_rows
FROM (
  SELECT COUNT(*) as row_count FROM `kestra-sandbox-485115.zoomcamp.yellow_tripdata_2021_03`
)
```

Answer : 1,925,152

### Question 6

How would you configure the timezone to New York in a Schedule trigger?

    - Add a `timezone` property set to `EST` in the `Schedule` trigger configuration
    - Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration
    - Add a `timezone` property set to `UTC-5` in the `Schedule` trigger configuration
    - Add a `location` property set to `New_York` in the `Schedule` trigger configuration

Answer : Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration