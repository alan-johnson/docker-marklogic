# Many thanks to Tom McGrath and Patrick McElwee for their initial Dockerfiles
#
# https://github.com/patrickmcelwee/marklogic-dependencies/blob/master/Dockerfile
# https://hub.docker.com/r/patrickmcelwee/marklogic-dependencies/
#
# Get the latest CentOS 7 image
FROM centos:7
MAINTAINER Alan Johnson <alan.johnson@marklogic.com>

# Get any CentOS updates then clear the Docker cache
RUN yum -y update && yum clean all

# Install MarkLogic dependencies
RUN yum -y install glibc.i686 gdb.x86_64 redhat-lsb.x86_64 && yum clean all

# install the initscripts package so MarkLogic starts ok
RUN yum -y install initscripts && yum clean all

# Set the Path
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/MarkLogic/mlcmd/bin

# Copy the MarkLogic installer to a temp directory in the Docker image being built
COPY MarkLogic-RHEL7-8.0-5.5.x86_64.rpm /tmp/MarkLogic.rpm

COPY initialize-ml.sh /tmp/initialize-ml.sh
COPY add-to-cluster.sh /tmp/add-to-cluster.sh
RUN chmod +x /tmp/*.sh

# Install MarkLogic then delete the .RPM file if the install succeeded
RUN yum -y install /tmp/MarkLogic.rpm && rm /tmp/MarkLogic.rpm

# Expose MarkLogic Server ports
# Also expose any ports your own MarkLogic App Servers use such as
# HTTP, REST and XDBC App Servers for your applications
EXPOSE 7997 7998 7999 8000 8001 8002

# Start MarkLogic and initialize. This creates default databases
# and app servers and also creates the first admin account.
# Also, execute tail such that it waits forever. This prevents 
# the container from automatically stopping after starting MarkLogic.
CMD /etc/init.d/MarkLogic start && ./tmp/initialize-ml.sh -u $USER -p $PASS -r public && tail -f /dev/null