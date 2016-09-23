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
    </ul>
<li>Use the instructions to create your Docker container.
  <ul>
    <li>https://github.com/alan-johnson/docker-marklogic/blob/master/creating-docker-images-with-marklogic.pdf
  </ul>
</ol>
