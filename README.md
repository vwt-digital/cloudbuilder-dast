# Container-DAST

This container allows us to run dynamic application security tests in our Cloud Build pipelines.
It allows us to add new dynamic testers without adding them to individual cloudbuild.yaml files of our front-end and API projects.

## Prerequisites

1. A deployed and running https service

## Usage

Two arguments are required to run this container: 
1. a domain name, without http:// or https:// 
2. type of service, `frontend` or `api`

Typically this container would run as a custom build step in a Cloud Build pipeline after deploying it to Google App Engine.

```
- name: 'gcr.io/$PROJECT_ID/container-dast'
  args: ['api.example.com', 'api']
```

```
docker run -ti container-dash api.example.com api
```

