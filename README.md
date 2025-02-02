# 02233 - Network Security (2025)

Here you can find a `docker-compose` file to start all the required services and applications we are going to use throughout the Network Security course and its laboratory exercises.

First, compose up the containers.

For the kali environment, open `https://localhost:6901/` in your browser, and continue with credentials:

```sh
User : kasm_user
Password: password
```

To use `bloodhound`, you have to start the `neo4j` service:

```sh
sudo neo4j start
```