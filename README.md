# README

## DOCKER INTEGRATION WITH RAILS APPLICATION

The objetive is developing a Rails Application that interacts with the Docker API to:

    1. Build a Docker Image from a provided Dockerfile
    2. Run the containerized application.
    3. Optionally, push the built image to a Docker registry


### The App

This is an rails API without databse or ActiveRecord as they were not needed for the original purpose
of the exercise.

There are a suite of rspec test ready to be run. Requisites:

    1. Docker registry running
    2. Create Rails credentials for test environment to access to that registry

Then run:
`rspec`

### API endpoints

#### Images
```
GET /v1/images
List images

GET /v1/images/:id
Show image details using its ID or Name

POST /v1/images/
Create new image from posted body raw text

POST /v1/images/from_file
Create new image from posted file as param[:dockerfile]

DELETE /v1/images/:id
Delete image details using its ID or Name

POST /v1/images/:id/push
Push Image to registry. Mandatory params: username, password, serveraddress, repo, tag
```

#### Containers
```
GET /v1/containers
List containers

GET /v1/containers/:id
Show container details

POST /v1/containers
Create container from image id/name, Mandatory params: image

DELETE /v1/containers/:id
Delete container

POST /v1/containers/:id/action
Use param 'command' to send start/stop request for specific container
```



