# Setting up Dockerize Expres_Note: The recommended distro for running this setup is Ubuntu 18.04 and above. If you are using windows, setup first your WSL (I recommend you use WSL 2 rather than WSL 1)._

----

## Windows Subsytem for Linux Documentation
[Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/) lets developers run a GNU/Linux environment -- including most command-line tools, utilities, and applications -- directly on Windows, unmodified, without the overhead of a traditional virtual machine or dual-boot setup.

### Why I recommend WSL 2:
- [What is WSL 2](https://docs.microsoft.com/en-us/windows/wsl/about)
- [Comparing WSL 1 and WSL 2](https://docs.microsoft.com/en-us/windows/wsl/compare-versions)

----

## Docket Desktop WSL 2 Backend
Docker Desktop uses the dynamic memory allocation feature in WSL 2 to greatly improve the resource consumption. This means, Docker Desktop only uses the required amount of CPU and memory resources it needs, while enabling CPU and memory-intensive tasks such as building a container to run much faster.

### Read more aboud WSL 2 Backend and Installation can be found here:
#### [Docket Desktop WSL 2 Backend](https://docs.docker.com/desktop/windows/wsl/)

## 1. Setup Dockerfile
_A Dockerfile is already provided. You only have to set it up._

Copy and Paste this in your Dockerfile.
``` Docker
# Initialize an Image
FROM node:14.4.0-alpine3.12 

# Create a /var/www/app directory
RUN mkdir -p /var/www/app

# Set WORKDIR to /var/ww/app which was created in the RUN instruction.
WORKDIR /var/www/app

# COPY whatever is in the <package*.json> to <./>
COPY package*.json ./

# execute a npm command 
RUN npm install && npm cache clean --force

# set /var/www/app/src as the work directory.
ENV PATH=/var/www/app/node_modules/.bin:$PATH

RUN mkdir -p /var/www/app/src

WORKDIR /var/www/app/src
```

## 2. Setup Docker Compose
Compose is a tool for defining and running multi-container Docker applications.

_A dockerfile-compose file is already provide you just have to set it up_

A sample docker compose:
``` YAML
version: "3.2" # We set the version of our Dockerfile to 3.2
services:
    db:
      image: mysql:5.7 # instructs Docker that the db service is going to use a MySQL image version 5.7
      volumes:
        # db_data is a name we set for the /var/lib/mysql path (We can change db_data to whatever) 
        # that we can then use to share data between two or more services.
        - db_data:/var/lib/mysql
        # this is a way for us to auto IMPORT a .sql file to the database in your MySQL container
        # it auto imports the db.sql file in the mysql-dump folder
        - ./mysql-dump:/docker-entrypoint-initdb.d
      restart: always
      environment: # It creates the MySQL credentials for us, as well as a database called hh. This is the credential you'll need in order for your express app to communicate with the MySQL service. 
        MYSQL_ROOT_PASSWORD: password
        MYSQL_DATABASE: hh
      ports:
        # Private port for MySQL is 3306 and Public port is 3307. To connect to our MySQL container using Workbench, we use port 3307
        - 3307:3306

    web_app:
      depends_on: # This will tell Docker to start services in dependency order. In this example, before starting the app service, it waits for db to be started.
        - db
      build: ./
      volumes:
        # This maps our host project files to our container's WORKDIR. Whatever changes we make to our local copy, will reflect those changes in WORKDIR.
        - ./src:/var/www/app/src
        - ./package.json:/var/www/app/package.json
      command: npm start
      restart: always
      ports:
        - 3001:3000

volumes: # it means that that specified volume (in this case, db_data) is available to all services (both app and db).
    db_data: {}
```

### 2.1 Running a Docker Compose
There are two ways of running a docker compose file. You could use the linux terminal or the VSCODE extension (I recommend this one it is much more easier)

Linux Command Terminal:
``` properties
$ docker compose -f docker-compose.yml
```

Visual Studio Code Extension:

_just right click the docker compose file and you will some options._

#### Demo:
![Sample Demo](https://code.visualstudio.com/assets/docs/containers/overview/select-subset.gif)






