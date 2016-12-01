# docker-marklogic
Here you'll find Dockerfiles to create a Docker container image with MarkLogic installed. Instructions are also provided, including some Docker commands that are useful for starting and stopping containers.
<p>
Windows has an optional hypervisor feature (Hyper-V). Newer versions of Docker enable this feature. Since one cannot have simultaneous hypervisors, this causes an issue when trying to use Docker along with other hypervisors such as VMWare or Virtual Box. Information has also been included on managing this. This information contains no guarantees, your mileage may vary.
</p>

At the end of this README, instructions and example files for creating a MarkLogic Docker container and have it fully initialzed. Script files use MarkLogic's REST api to initialze the MarkLogic installation and create an administrator account rather than doing it manually. Please read the instructions fully. Proper environment variables must be set for the scripts to work correctly.

Please use the GitHub Issues feature to report any issues found or updates.

##Getting Started
<ol>
<li>Download MarkLogic
  <ul>
    <li>http://developer.marklogic.com/
    <li>MarkLogic 9 Early Access can be downloaded from the early access site once you have joined and logged in.
  </ul>
<li>Download the Dockerfile
    <ul>
      <li>Docker-ML folder - contains a Dockerfile for MarkLogic.
      <li>Check the name of the MarkLogic .rpm in the Dockerfile against the one you've downloaded. Rename the name of the .rpm in the Dockerfile as necessary.
    </ul>
<li>Use the instructions to create your Docker container.
  <ul>
    <li>https://github.com/alan-johnson/docker-marklogic/blob/master/creating-docker-images-with-marklogic.pdf
  </ul>
</ol>

##Buiding a 3-node MarkLogic Cluster
<ol>
<li>Download MarkLogic
  <ul>
    <li>http://developer.marklogic.com/
    <li>The example <code>docker-compose.yml</code> file references the same Dockerfile as in <code>Docker-ML</code> above.
  </ul>
<li>Download the <code>docker-compose.yml</code> and the example MarkLogic version 8 <code>Dockerfile</code> from the <code>marklogic-cluster</code> directory.
  </ul>
  <p/>
<li>Copy the MarkLogic Version 8 .rpm file to the same directory that contains the <code>docker-compose.yml</code> and the Dockerfile. Ensure the name of the .rpm in the Dockerfile is the same as the name of the .rpm downloaded.
<p/>
<li>Run the docker-compose command, <code>docker-compose up</code> in the current directory.
<p/>
<li>Go to the Admin Interface on port 8001 on each of the 3-nodes and proceed through the post-installation steps.
<ul>
<li>The <code>docker-compose.yml</code> file exposes MarkLogic ports 8000 through 8002 for nodes 1, 2 and 3 as your localhost ports as follows:
<ul>
<li> node1 - ports 8000 through 8002 on the host's computer is equal to the MarkLogic container's ports 8000 through 8002.
<li> node2 - ports 18000 through 18002 on the host's computer is equal to the MarkLogic container's ports 8000 through 8002.
<li> node3 - ports 28000 through 28002 on the host's computer is equal to the MarkLogic container's ports 8000 through 8002.
</ul>
<li>Skip joining a cluster for node1.
<p/>
<li>For node2 and node3, join the cluster using <code>localhost</code> for the Host Name and leave the port at 8001. For the following pages, accept the  default settings.
</ul>
<li>For more information on Docker-Compose, please see the Docker website, https://docs.docker.com/compose/gettingstarted/
</ol>
##Automating the MarkLogic Installation
The `marklogic-automated` directory contains examples of using MarkLogic's REST api to initialize a MarkLogic install, including creating an administrator account. There is also a `docker-compose.yml` file for creating an initialized 3-node MarkLogic cluster. Scripts call the MarkLogic REST api to either initialize the MarkLogic server installation or to join an initialized MarkLogic server as part of a MarkLogic cluster.

To use the scripts, 2 environment variables are assumed to be set.
<ul>
<li>USER - the value is the administrator account name to be created.
<li>PASS - the value is the administrator account's password.
</ul>
To use these scripts, follow the instructions below.

####Using the Dockerfile to create an initialized MarkLogic server.
>Note: This will install MarkLogic in a Docker container, initialize that installation and create an adminstrator account. MarkLogic will be ready to be used without any post-install steps. It does **not** join a cluster of MarkLogic servers.

1. Use the Docker build command to create an image, same as in above steps.
2. When using `docker run`, set the `USER` and `PASS` environment variables by using Docker's `-e` option.


	**Example:**
	`docker run -d --name=<desired container name> -e USER=<admin> -e PASS=<some-password> -p 8000-8002:8000-8002 <image name:tag>`
	
	where:  
	`\<desired container name>` is the name you want for the Docker container.  
	`\<admin>` is the desired username of the administrator account.  
	`\<some-password>` is the desired password for the administrator account.

####Using the `docker-compose.yml` file
The `docker-compose.yml` file also uses the environment variables, `USER` and `PASS` to pass the desired administrator username and password to the created MarkLogic server nodes. 
>Important: Ensure you set these variables to desired values **before** calling `docker-compose up`. 

**Example**  
`set USER=<admin>`  
`set PASS=<some-password>`  
`docker-compose up`  

where:  
`\<admin>` is the desired username of the administrator account.  
`\<some-password>` is the desired password for the administrator account.