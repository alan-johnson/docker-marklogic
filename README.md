# docker-marklogic
Here you'll find Dockerfiles to create a Docker container image with MarkLogic installed. Instructions are also provided, including some Docker commands that are useful for starting and stopping containers.

Windows has an optional hypervisor feature (Hyper-V). Newer versions of Docker enable this feature. Since one cannot have simultaneous hypervisors, this causes an issue when trying to use Docker along with other hypervisors such as VMWare or Virtual Box. Information has also been included on managing this. This information contains no guarantees, your mileage may vary.  

> Note: Windows is now offering Windows-based containers. This README and accompanying data files, including any Dockerfile, targets CentOS 7-based MarkLogic installations. Creating Windows-based containers is beyond the scope of this document.

At the end of this README, you'll find instructions and example files for creating a MarkLogic Docker container and have it fully initialzed. Script files use MarkLogic's REST api to initialze the MarkLogic installation and create an administrator account rather than doing it manually. Please read the instructions fully. Proper environment variables must be set for the scripts to work correctly.

Please use the GitHub Issues feature to report any issues found or updates.

## Requirements
* Download the MarkLogic installer, version 9.0-5 or later. <http://developer.marklogic.com/products/>
* Ensure ports 8000, 8001 and 8002 are avaialable on the host that will run the Docker container.
* Ensure Docker is installed and running.

## Getting Started
1. Download MarkLogic
    * <http://developer.marklogic.com/products/>
    * MarkLogic version 9.0-5 and greater is required for container support. Previously versions of both MarkLogic 8 and MarkLogic 9 may be used but for testing only. These version do not fully support being containerized.

2. Download the Dockerfile
      * Docker-ML folder - contains a Dockerfile for MarkLogic.
      * Check the name of the MarkLogic .rpm in the Dockerfile against the one you've downloaded. Rename the name of the .rpm in the Dockerfile as necessary.

3. Use the instructions to create your Docker container.
  * <https://github.com/alan-johnson/docker-marklogic/blob/master/creating-docker-images-with-marklogic.pdf>

## Buiding a 3-node MarkLogic Cluster
1. Download MarkLogic
   * <http://developer.marklogic.com/products/>
   * The example `docker-compose.yml` file references the same Dockerfile as in `Docker-ML` above.

2. Download the `docker-compose.yml` and the example MarkLogic  `Dockerfile` from the `marklogic-cluster` directory.

3. Copy the MarkLogic .rpm file to the same directory that contains the `docker-compose.yml` and the Dockerfile. Ensure the name of the .rpm in the Dockerfile is the same as the name of the .rpm downloaded.

4. Run the docker-compose command, `docker-compose up -d` in the current directory.

5. Go to the Admin Interface on port 8001 on each of the 3-nodes and proceed through the post-installation steps.

6. The `docker-compose.yml` file exposes MarkLogic ports 8000 through 8002 for node1, node2 and node3 as your localhost ports as follows:
	* node1 - ports 8000 through 8002 on the host's computer is equal to the MarkLogic container's ports 8000 through 8002.
	* node2 - ports 18000 through 18002 on the host's computer is equal to the MarkLogic container's ports 8000 through 8002.
	* node3 - ports 28000 through 28002 on the host's computer is equal to the MarkLogic container's ports 8000 through 8002.

7. Skip joining a cluster for node1.

8. For node2 and node3, join the cluster using `localhost` for the Host Name and leave the port at 8001. For the following pages, accept the  default settings.

9. For more information on Docker-Compose, please see the Docker website, <https://docs.docker.com/compose/gettingstarted/>

## Automating the MarkLogic Installation
The `marklogic-automated` directory contains examples of using MarkLogic's REST api to initialize a MarkLogic install, including creating an administrator account. There is also a `docker-compose.yml` file for creating an initialized 3-node MarkLogic cluster. Scripts call the MarkLogic REST api to either initialize the MarkLogic server installation or to join an initialized MarkLogic server as part of a MarkLogic cluster.

To use the scripts, 2 environment variables are assumed to be set:

* USER - the value is the administrator account name to be created.
* PASS - the value is the administrator account's password.

To use these scripts, follow the instructions below.

#### Using the Dockerfile to create an initialized MarkLogic server.
>Note: This will install MarkLogic in a Docker container, initialize that installation and create an adminstrator account. MarkLogic will be ready to be used without any post-install steps. It does **not** join a cluster of MarkLogic servers.

1. Use the Docker build command to create an image, same as in above steps.
2. When using `docker run`, set the `USER` and `PASS` environment variables by using Docker's `-e` option.


	**Example:**
	`docker run -d --name=<desired container name> -e USER=<admin> -e PASS=<some-password> -p 8000-8002:8000-8002 <image name:tag>`

	where:  
	`<desired container name>` is the name you want for the Docker container.  
	`<admin>` is the desired username of the administrator account.  
	`<some-password>` is the desired password for the administrator account.

#### Using the `docker-compose.yml` file
The `docker-compose.yml` file also uses the environment variables, `USER` and `PASS` to pass the desired administrator username and password to the created MarkLogic server nodes.
>Important: Ensure you set these variables to desired values **before** calling `docker-compose up`.

**Example**  
`set USER=<admin>`  
`set PASS=<some-password>`  
`docker-compose up -d`  

where:  
`<admin>` is the desired username of the administrator account.  
`<some-password>` is the desired password for the administrator account.
