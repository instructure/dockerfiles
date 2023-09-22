# OpenSearch

Docker image for OpenSearch, including [plugins](#plugins). This is provided to help mirror the functionality of AWS hosted OpenSearch in a local development environment.

### Example docker-compose.yml

```
version: "3.8"

services:
  opensearch:
    image: instructure/opensearch:1.3.2
    ports:
      - "9200:9200"
      - "5601:5601"
    environment:
      plugins.security.disabled: "true"
      discovery.type: single-node
      ES_JAVA_OPTS: -Xms512m -Xmx512m
    volumes:
      - os-data:/usr/share/opensearch/data

volumes:
  os-data: {}
```

# Plugins

| Plugin      | Description                                    | Source                                                  |
| ----------- | ---------------------------------------------- | ------------------------------------------------------- |
| vi-analyzer | Provides Vietnamese language analysis support. | https://github.com/duydo/opensearch-analysis-vietnamese |