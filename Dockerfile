# Maintainers: Microsoft Corporation 
#jgwill/ubuntu:16.04
FROM jgwill/ubuntu:16.04-py3.7.1-ml

ARG DEBIAN_FRONTEND=noninteractive

# copy in supervisord conf file
COPY ./supervisord.conf /usr/local/etc/supervisord.conf

# # install supporting packages (Included in jgwill/ubuntu:16.04)
# RUN apt-get update && \
#     apt-get install -y apt-transport-https \
#                        curl \
#                        supervisor \
#                        fakechroot \
#                        locales \
#                        iptables \
#                        sudo \
#                        wget \
#                        curl \
#                        zip \
#                        unzip \
#                        make \ 
#                        bzip2 \ 
#                        m4 \
#                        apt-transport-https \
#                        tzdata \
#                        libnuma-dev \
#                        libsss-nss-idmap-dev \
#                        software-properties-common

# Adding custom MS repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2019.list > /etc/apt/sources.list.d/mssql-server-2019.list





# MSSQL
#RUN apt-get update && \
#        apt-get install -y mssql-server && \
#    # Cleanup the Dockerfile
#    apt-get clean && \
#    rm -rf /var/apt/cache/* /tmp/* /var/tmp/* /var/lib/apt/lists


#    # Install optional packages
#RUN    apt-get update && \
#       apt-get install -y mssql-server-ha  && \
#    # Cleanup the Dockerfile
#    apt-get clean && \
#    rm -rf /var/apt/cache/* /tmp/* /var/tmp/* /var/lib/apt/lists

#    # Install optional packages
#RUN    apt-get update && \
#       apt-get install -y mssql-server-fts  && \
#    # Cleanup the Dockerfile
#    apt-get clean && \
#    rm -rf /var/apt/cache/* /tmp/* /var/tmp/* /var/lib/apt/lists


# SSIS

RUN sudo apt-get update && \
	apt-get install -y mssql-server-is && \
    # Cleanup the Dockerfile
    apt-get clean && \
    rm -rf /var/apt/cache/* /tmp/* /var/tmp/* /var/lib/apt/lists

COPY ssis.conf /var/opt/ssis/ssis.conf








# ML

# install SQL Server ML services R and Python packages which will also install the mssql-server pacakge, the package for SQL Server itself
# if you want to install only Python or only R, you can add/remove the package as needed below
RUN apt-get update && \
    apt-get install -y mssql-mlservices-packages-r \
                       mssql-mlservices-packages-py && \
    # Cleanup the Dockerfile
    apt-get clean && \
    rm -rf /var/apt/cache/* /tmp/* /var/tmp/* /var/lib/apt/lists
    
# Install mssql-cli
#RUN apt update && apt-get install mssql-cli -y

# run checkinstallextensibility.sh
RUN /opt/mssql/bin/checkinstallextensibility.sh && \
    # set/fix directory permissions and create default directories
    chown -R root:root /opt/mssql/bin/launchpadd && \
    chown -R root:root /opt/mssql/bin/setnetbr && \
    mkdir -p /var/opt/mssql-extensibility/data && \
    mkdir -p /var/opt/mssql-extensibility/log && \
    chown -R root:root /var/opt/mssql-extensibility && \
    chmod -R 777 /var/opt/mssql-extensibility && \
    # locale-gen
    locale-gen en_US.UTF-8



#old # Run SQL Server process
#CMD /opt/mssql/bin/sqlservr


# copy in supervisord conf file
COPY ./supervisord.conf /usr/local/etc/supervisord.conf

RUN apt update && \
    apt-get install -y   supervisor 

# expose SQL Server port
#EXPOSE 1433
#EXPOSE 1431

# would be SSIS, not sure
#EXPOSE 3882

# start services with supervisord
CMD /usr/bin/supervisord -n -c /usr/local/etc/supervisord.conf
