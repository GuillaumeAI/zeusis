# Maintainers: Microsoft Corporation 
#jgwill/ubuntu:16.04
#FROM jgwill/ubuntu:16.04-py3.7.1
FROM docker.io/jgwill/ubuntu:16.04-py3.7.1-ml

ARG DEBIAN_FRONTEND=noninteractive


# Adding custom MS repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2019.list > /etc/apt/sources.list.d/mssql-server-2019.list




# SSIS

RUN sudo apt-get update && \
	apt-get install -y mssql-server-is && \
    # Cleanup the Dockerfile
    apt-get clean && \
    rm -rf /var/apt/cache/* /tmp/* /var/tmp/* /var/lib/apt/lists

COPY ssis.conf /var/opt/ssis/ssis.conf

