This repository creates a web service which its purpose is to deliver my CV

Since my CV is written in latex, it contains a seperate Dockerfile for compiling latex into pdf.

It also contains another dockerfile which has a simple node.js server to serve my CV.

I have decided to chose Github Actions as CI/CD provider, since i can use it without installing it on a server (and without configuring nodes that jobs wil run on). Also, its open source community to provide custom actions simplifies CI/CD operations immensely.   

I have created github workflows that will build the images. I have seperated their file triggers, so only the image that needs to be rebuild will be rebuild on changes.

One of the container images in this takes a long time to build. Because of this, i needed to use a image registery. Since i also decided to host my server container in AWS ECS, i decided to use ECR to have more control over the infrastructure by using same provider. This can ease setting up a IaaC solution. 

