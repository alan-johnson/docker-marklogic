# Credit to Patrick McElwee for the Starting Point of this Dockerfile
#
# https://github.com/patrickmcelwee/marklogic-dependencies/blob/master/Dockerfile
# https://hub.docker.com/r/patrickmcelwee/marklogic-dependencies/
# Thanks for the great starting point!!!
#
FROM centos:7
MAINTAINER Alan Johnson <alan.johnson@marklogic.com>

# Get any CentOS updates then clear the Docker cache
RUN yum -y update && yum clean all

# Install MarkLogic dependencies
RUN yum -y install glibc.i686 gdb.x86_64 redhat-lsb.x86_64

# install the initscripts package so MarkLogic starts ok
RUN yum -y install initscripts && yum clean all

# Set the Path
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/MarkLogic/mlcmd/bin

# Install VIM for simple text editing needs
RUN yum -y install vim && yum clean all

# Copy the MarkLogic installer to a temp directory in the Docker image being built
COPY MarkLogic-RHEL7-9.0-20160909.x86_64-EA3.rpm /tmp/MarkLogic.rpm

# Install MarkLogic then remove the installer file if successful
RUN yum -y install /tmp/MarkLogic.rpm && rm /tmp/MarkLogic.rpm

# Expose MarkLogic Server ports
# Also expose any ports your own MarkLogic App Servers use such as
# HTTP, REST and XDBC App Servers for your applications
EXPOSE 7997 7998 7999 8000 8001 8002

# Define default command (which avoids immediate shutdown)
CMD /etc/init.d/MarkLogic start && tail -f /dev/null
