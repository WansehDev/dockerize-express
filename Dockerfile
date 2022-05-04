# FROM node:latest : FROM is an instruction that sets/initialize our base image for our docker image. Every Dockerfile must start with a FORM instruction. Images can be pulled in https://hub.docker.com/ - Public Repositories
FROM node:14.4.0-alpine3.12 

# RUN instruction executes any commands (Depends which os/distro is used). Here, we are using Ubuntu 18.04, that's why we are using linux based commands. We are actually telling Docker to create a /var/www/app directory
RUN mkdir -p /var/www/app

# WORKDIR instruction sets the working directory for any instructions that follows it in the Dockerfile. Here, We are setting our WORKDIR to /var/ww/app which was created in the RUN instruction. This work directory is where our local express app files will be saved in the container.
WORKDIR /var/www/app

# COPY instruction copies new files or directories from <src> to the container's filesystem at the path <dest>. This basically tells the Docker whatever is in the <package*.json> should be copied and pasted over to the guest's work directory <./>
COPY package*.json ./

# We execute a npm command using the RUN instruction.
RUN npm install && npm cache clean --force

# ENV instruction set the environment variable <key> to the <value>. Here, we are setting the path environemtn variable <PATH> to </var/www/app/node_modules/.bin:$PATH>. Node Modules are needed in order to create a express app.
ENV PATH=/var/www/app/node_modules/.bin:$PATH

# We create a directory /var/www/app/src.
RUN mkdir -p /var/www/app/src

# We set /var/www/app/src as the work directory.
WORKDIR /var/www/app/src


# We copy whatever is in the <src> should also be copied and pasted in </var/www/app>. Dot Symbol is just a shortcut name for the /var/www/app directory which we specified as our WORKDIR.
COPY src .