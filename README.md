# 02233 - Network Security (2025)

Here you can find a `docker-compose` file to start all the required services and applications we are going to use throughout the Network Security course and its laboratory exercises.

## Requirements

Before cloning the repository and setting up the services, make sure you have the following tools installed: 

- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Docker](https://docs.docker.com/engine/install/)

## Steps

### Clone GitHub repository

```sh
git clone https://github.com/RicYaben/DTUNetSec.git
```

### Setup the services

Make sure that `docker` is running.
Then, compose up the containers from the root directory of the project.

```sh
# build containers from remote. This should work in most cases
./start.sh --lab <lab, e.g.: iot>
# This one also works
./start.sh iot

# build from local files. Use this option if you are running into errors
./start.sh --lab <lab, e.g.: iot> --local
# this one works too!
./start.sh iot --local
```

### Check containers health

To check the health of your containers, do:

```sh
# Lists the running containers
docker ps 
# See the logs of the specified container
docker logs <container-name>
```

### Login to Kali environment

For the kali environment, open `https://localhost:6901/` in the browser of your choice, and continue with credentials:

```sh
User: kasm_user
Password: password
```

For later labs, to use `bloodhound`, you have to start the `neo4j` service:

```sh
sudo neo4j start
```

### Additional docker commands

For additional docker commands check out the [cheatsheet](https://dockerlabs.collabnix.com/docker/cheatsheet/).