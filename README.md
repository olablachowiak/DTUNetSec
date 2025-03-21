# 02233 - Network Security

This repository includes the material used throughout the Network Security course at DTU.
Make sure you have the following tools installed: 

- [Docker](https://docs.docker.com/engine/install/)
- On Windows only: [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install)

## Quick Setup

<div>
<center>

| Lab name | Code |
----- | --- |
Authentication | authentication
TLS | tls
Threat Detection | threat-detection
Blue Team | blue-team
IoT Security | iot
WIFI Security | wifi
Privacy | privacy
Red Team | red-team

<p>Table 1: Lab names and codes to run containers </p>
</center>
</div>

> **NOTE 1:** Make sure **Docker** is running.
>
> **NOTE 2:** If you are using **Windows**, make sure you have installed and working [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install). You can choose Ubuntu for the subsystem.
>
> **NOTE 3:** If you are using a **Macbook** use the `--local` flag with the runner script.

1.  From the root directory, execute the `run.sh` script followed by the name of the lab. 
If you are using a **Macbook**, please use the `--local` flag as well. 
The codes for each lab are shown in Table 1.

    **Usage:**

    ````sh
    Usage: ./run.sh <lab> [--local] or ./run.sh --lab <lab> [--local]

    Arguments:
    <lab>   (Required) Lab name to use
    --local (Optional) Run with local compose file
    ````

    **Example:**

    ```sh
    # build containers from remote. This should work in most cases
    bash ./run.sh --lab iot
    # This one also works
    bash ./run.sh iot

    # build from local files. Use this option if you are running into errors
    bash ./run.sh --lab iot --local
    # this one works too!
    bash ./run.sh iot --local
    ```

2. To access the **kali** container, open `https://localhost:6901/` in your browser and use the following credentials:

    ```sh
    User: kasm_user
    Password: password
    ```

    > **NOTE 1:** to use `bloodhound`, you have to start the `neo4j` service:
    > ```sh
    > sudo neo4j start
    > ```

    > **NOTE 2:** to use `wireshark`, you need to run it as sudo with the current environment
    > ```sh
    > sudo -E wireshark
    > ```
    
    > **NOTE 3:** to run `dnscat` server in `kali`, you need to run: 
    > ```sh
    > ruby material/dnscat2/server/dnscat2.rb <args>
    > ```
    