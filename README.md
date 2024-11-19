# CSV Server Solution

## Steps to Run the Solution

### Step 1: Generate the Input File

Run the gencsv.sh script to generate the input file:

```bash
./gencsv.sh 2 8
```

This will create a file named `inputFile` with random values.

### Step 2: Run the CSV Server

Run the `csvserver` Docker container with the generated `inputFile`:

```bash
docker run -d -v $(pwd)/inputFile:/csvserver/inputdata -p 9393:9300 infracloudio/csvserver:latest
```

Verify that the container is running:

```bash
docker ps
```

Access the application in your browser at http://localhost:9393.

### Step 3: Save Logs

Save the logs from the container:

```bash
docker logs [container_id] > part-1-logs
```

Download the raw output from the application:

```bash
curl -o part-1-output http://localhost:9393/raw
```

### Step 4: Run the Server with an Environment Variable

Stop the running container:

```bash
docker stop [container_id]
```

Restart the container with the `CSVSERVER_BORDER` environment variable:

```bash
docker run -d -v $(pwd)/inputFile:/csvserver/inputdata -p 9393:9300 -e CSVSERVER_BORDER=Orange infracloudio/csvserver:latest
```

Access the application again at http://localhost:9393. The border should now be orange.

### Step 5: Run Using Docker Compose

Stop and remove all running containers:

```bash
docker stop $(docker ps -q)
docker rm $(docker ps -aq)
```

Create a `docker-compose.yaml` file with the following content:

```yaml
version: "3.8"
services:
  csvserver:
    image: infracloudio/csvserver:latest
    container_name: csvserver
    environment:
      - CSVSERVER_BORDER=Orange
    ports:
      - "9393:9300"
    volumes:
      - ./inputFile:/csvserver/inputdata
```

Start the services:

```bash
docker-compose up -d
```

Verify the application at http://localhost:9393.

### Step 6: Add Prometheus

Update the `docker-compose.yaml` file to include Prometheus:

```yaml
version: "3.8"
services:
  csvserver:
    image: infracloudio/csvserver:latest
    container_name: csvserver
    environment:
      - CSVSERVER_BORDER=Orange
    ports:
      - "9393:9300"
    volumes:
      - ./inputFile:/csvserver/inputdata

  prometheus:
    image: prom/prometheus:v2.45.2
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
```

Create a `prometheus.yml` file with the following content:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "csvserver"
    static_configs:
      - targets: ["csvserver:9300"]
```

Start the services:

```bash
docker-compose up -d
```

Verify Prometheus at http://localhost:9090.
