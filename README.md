# Cloudbuilder-DAST

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
- name: 'gcr.io/$PROJECT_ID/cloudbuilder-dast'
  args: ['api.example.com', 'api']
```

```
docker run -ti cloudbuilder-dast api.example.com api
```
####Optional arguments:
1. Development branch name replacement, E.g. `test`

As an example:

```
docker run cloudbuilder-dast develop-api.example.com api test
```
Will result in `test-api.example.com` to be set as the domain.
```
docker run cloudbuilder-dast master-api.example.com api test
```
Will result in `api.example.com` to be set as the domain.

If no 3rd argument is given, the domain will remain unchanged.


