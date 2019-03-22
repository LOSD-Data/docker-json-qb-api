# docker-json-qb-api
Docker image for JSON-QB API on Alpine Linux.

### Usage
Update the configuration file ```config.prop``` and provide SPARQL endpoint URL - ```SPARQLservice```. See more at: https://github.com/LOSD-Data/docker-json-qb-api

Build an image from a Dockerfile:
```docker build -t json-qb-api .```

Run Docker container:
```docker run -d -p 8000:8000 json-qb-api```

### Requirements
 - Docker 
 - SPARQL endpoint