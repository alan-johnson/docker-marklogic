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

# Set environment variable that MarkLogic uses
ENV MARKLOGIC_INSTALL_DIR /opt/MarkLogic
ENV MARKLOGIC_DATA_DIR /data

ENV MARKLOGIC_FSTYPE ext4
ENV MARKLOGIC_USER daemon
ENV MARKLOGIC_PID_FILE /var/run/MarkLogic.pid
ENV MARKLOGIC_MLCMD_PID_FILE /var/run/mlcmd.pid
ENV MARKLOGIC_UMASK 022

# Set the Path
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/MarkLogic/mlcmd/bin

# Install VIM for simple text editing needs
RUN yum -y install vim && yum clean all

# Copy the MarkLogic installer to a temp directory in the Docker image being built
COPY MarkLogic-RHEL7-9.0-20160510.x8664-EA2.rpm /tmp/MarkLogic.rpm

# Copy XQuery files so initial MarkLogic post-installation steps do not fail
COPY task-servers.xqy /tmp/task-servers.xqy
COPY task-server-properties-model.xqy /tmp/task-server-properties-model.xqy
COPY request-model.xqy /tmp/request-model.xqy

# Install MarkLogic then remove the installer file if successful
RUN yum -y install /tmp/MarkLogic.rpm && rm /tmp/MarkLogic.rpm

# Expose MarkLogic Server ports
# Also expose any ports your own MarkLogic App Servers use such as
# HTTP, REST and XDBC App Servers for your applications
EXPOSE 7997 7998 7999 8000 8001 8002

# Delete files with errors that prevent 9ea install, copy good files into place
RUN rm -rf /opt/MarkLogic/Modules/MarkLogic/manage/endpoints/task-servers/task-servers.xqy /opt/MarkLogic/Modules/MarkLogic/manage/models/task-server-properties-model.xqy /opt/MarkLogic/Modules/MarkLogic/manage/models/request-model.xqy

RUN cp /tmp/task-servers.xqy /opt/MarkLogic/Modules/MarkLogic/manage/endpoints/task-servers/task-servers.xqy
RUN cp /tmp/task-server-properties-model.xqy /opt/MarkLogic/Modules/MarkLogic/manage/models/task-server-properties-model.xqy
RUN cp /tmp/request-model.xqy /opt/MarkLogic/Modules/MarkLogic/manage/models/request-model.xqy

# Define default command (which avoids immediate shutdown)
CMD /etc/init.d/MarkLogic start && tail -f /dev/null
