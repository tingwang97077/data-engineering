# Homework 1 — Docker - SQL - Terraform

## Statement

### Context

This homework focuses on preparing the environment and practicing **Docker**, **Docker Compose**, **SQL**, and **Terraform**.

When submitting the homework, you must include a link to your GitHub repository (or another public code-hosting platform).  
If your solution consists only of SQL or shell commands (and not source code files), they should be included directly in this `README.md`.

---

### Question 1 — Understanding Docker images

Run Docker using the `python:3.13` image and use `bash` as the entrypoint to interact with the container.

**Question:**  
What is the version of `pip` installed in the image?

Possible answers:
- 25.3  
- 24.3.1  
- 24.2.1  
- 23.3.1  

Commands used:
```bash
docker pull python:3.13
docker run -it --entrypoint bash python:3.13
pip -V
```
Answer : **25.3**

### Question 2 — Understanding Docker networking and docker-compose

Given the following `docker-compose.yaml`, what hostname and port should pgAdmin use to connect to the PostgreSQL database?

```YAML
services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      POSTGRES_DB: 'ny_taxi'
    ports:
      - '5433:5432'
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin

volumes:
  vol-pgdata:
    name: vol-pgdata
  vol-pgadmin_data:
    name: vol-pgadmin_data
```

Possible answers:
- postgres:5433
- localhost:5432
- db:5433
- postgres:5432
- db:5432

Answer : **postgres:5432**

### Question 3 — Counting short trips

For trips in November 2025 (lpep_pickup_datetime between 2025-11-01 and 2025-12-01, with the upper bound excluded), how many trips had a trip_distance less than or equal to **1 mile**?

Possible answers:
- 7,853
- 8,007
- 8,254
- 8,421

SQL query :

```SQL
SELECT COUNT(1)
FROM terraform-demo-484421.nyc_green_taxi_trip_dataset.green_taxi_trips
WHERE lpep_pickup_datetime BETWEEN '2025-11-01' AND '2025-12-01'
AND trip_distance <= 1.0;
```

Answer : **8,007**

### Question 4 — Longest trip for each day

Which pickup day had the longest trip distance?
Only consider trips with trip_distance less than **100** miles to exclude data errors.

Possible answers:
- 2025-11-14
- 2025-11-20
- 2025-11-23
- 2025-11-25

SQL query :

```SQL
SELECT
  DATE(lpep_pickup_datetime) AS pickup_day,
  MAX(trip_distance) AS longest_trip_distance
FROM terraform-demo-484421.nyc_green_taxi_trip_dataset.green_taxi_trips
WHERE trip_distance < 100
GROUP BY DATE(lpep_pickup_datetime)
ORDER BY longest_trip_distance DESC
LIMIT 1;
```

Answer : **2025-11-14**

### Question 5 — Biggest pickup zone

Which pickup zone had the largest total amount (total_amount) on November 18, 2025?

Possible answers:
- East Harlem North
- East Harlem South
- Morningside Heights
- Forest Hills

SQL query : 

```SQL
SELECT
  tz.Zone,
  SUM(t.total_amount) AS total_amount_sum
FROM terraform-demo-484421.nyc_green_taxi_trip_dataset.green_taxi_trips t
JOIN terraform-demo-484421.nyc_green_taxi_trip_dataset.taxi_zones tz
  ON t.PULocationID = tz.LocationID
WHERE DATE(t.lpep_pickup_datetime) = '2025-11-18'
AND tz.Zone IN (
  'East Harlem North',
  'East Harlem South',
  'Morningside Heights',
  'Forest Hills'
)
GROUP BY tz.Zone
ORDER BY total_amount_sum DESC;
```

Answer : **East Harlem North**

### Question 6 — Largest tip

For passengers picked up in the zone "East Harlem North" in November 2025, which drop-off zone had the largest tip?

Note: This refers to tip, not trip. The zone name is required, not the ID.

Possible answers:
- JFK Airport
- Yorkville West
- East Harlem North
- LaGuardia Airport

SQL query : 

```SQL
SELECT
  tz_dropoff.Zone AS dropoff_zone,
  MAX(t.tip_amount) AS largest_tip
FROM terraform-demo-484421.nyc_green_taxi_trip_dataset.green_taxi_trips t
JOIN terraform-demo-484421.nyc_green_taxi_trip_dataset.taxi_zones tz_pickup
  ON t.PULocationID = tz_pickup.LocationID
JOIN terraform-demo-484421.nyc_green_taxi_trip_dataset.taxi_zones tz_dropoff
  ON t.DOLocationID = tz_dropoff.LocationID
WHERE tz_pickup.Zone = 'East Harlem North'
AND DATE(t.lpep_pickup_datetime) BETWEEN '2025-11-01' AND '2025-11-30'
AND tz_dropoff.Zone IN (
  'JFK Airport',
  'Yorkville West',
  'East Harlem North',
  'LaGuardia Airport'
)
GROUP BY tz_dropoff.Zone
ORDER BY largest_tip DESC
LIMIT 1;
```

Answer : **Yorkville West**

### Question 7 — Terraform Workflow

Which of the following sequences correctly describes the Terraform workflow for:

1. Downloading provider plugins and setting up the backend

2. Generating and automatically executing the planned changes

3. Removing all resources managed by Terraform

Possible answers:

- terraform import, terraform apply -y, terraform destroy

- terraform init, terraform plan -auto-apply, terraform rm

- terraform init, terraform run -auto-approve, terraform destroy

- terraform init, terraform apply -auto-approve, terraform destroy

- terraform import, terraform apply -y, terraform rm

Answer : **terraform init, terraform apply -auto-approve, terraform destroy**