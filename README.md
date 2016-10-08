# docker-marklogic
Here you'll find Dockerfiles to create a Docker container image with MarkLogic installed. Instructions are also provided, including some Docker commands that are useful for starting and stopping containers.
<p>
Windows has an optional hypervisor feature (Hyper-V). Newer versions of Docker enable this feature. Since one cannot have simultaneous hypervisors, this causes an issue when trying to use Docker along with other hypervisors such as VMWare or Virtual Box. Information has also been included on managing this. This information contains no guarantees, your mileage may vary.
</p>

Please use the GitHub Issues feature to report any issues found or updates.

##Getting Started
<ol>
<li>Download MarkLogic
  <ul>
    <li>http://developer.marklogic.com/
    <li>MarkLogic 9 Early Access can be downloaded from the early access site once you have joined and logged in.
  </ul>
<li>Download the correct Dockerfile
    <ul>
      <li>Docker-ML8 folder - contains the Dockerfile for MarkLogic 8.
      <li>Docker-ML9EA folder - contains the Dockerfile for MarkLogic 9 Early Access. With MarkLogic 9 EA3, the Dockerfile is essentially the same as the MarkLogic version 8. The name of the .rpm differs
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
    <li>The example <code>docker-compose.yml</code> file references the same Dockerfile as in <code>Docker-ML8</code> above.
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
