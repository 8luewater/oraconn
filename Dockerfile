#FROM python:3.11.3-slim-buster
#FROM amazonlinux:latest
#FROM alpine:latest
#FROM ubuntu:latest

#WORKDIR /app

# ensure local python is preferred over distribution python
#ENV PATH /usr/local/bin:$PATH

#RUN python3 --version

#RUN yum -y install wget
#RUN wget https://download.oracle.com/otn_software/linux/instantclient/1918000/oracle-instantclient19.18-basic-19.18.0.0.0-2.x86_64.rpm
#RUN apt-get -y install oracle-instantclient19.18-basic-19.18.0.0.0-2.x86_64.rpm

#INstall python3.x
#RUN yum update -y && \
#    yum install -y python3 && \
#    yum install -y python3-pip

#RUN apt-get update && apt-get -y upgrade
#RUN apt-get -y install apt-utils
#RUN apt-get -y install wget
#RUN wget https://download.oracle.com/otn_software/linux/instantclient/1918000/oracle-instantclient19.18-basic-19.18.0.0.0-2.x86_64.rpm
#RUN apt-get -y install oracle-instantclient19.18-basic-19.18.0.0.0-2.x86_64.rpm

#COPY requirements.txt .
#RUN pip3 install -r requirements.txt

#COPY oracleconn.py .

#CMD [ "python3", "oracleconn.py" ]


# Use Python 3.11 Slim Buster as base image
FROM python:3.11.3-slim-buster

# Set the working directory to /opt/oracle
WORKDIR /opt/oracle

# Install necessary packages and download Oracle Instant Client
RUN apt-get update && apt-get install -y libaio1 wget unzip \
  && wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linuxx64.zip \
  && unzip instantclient-basiclite-linuxx64.zip \
  && rm -f instantclient-basiclite-linuxx64.zip

# Set up Oracle Instant Client
RUN cd /opt/oracle/instantclient* \
  && rm -f *jdbc* *occi* *mysql* *README *jar uidrvci genezi adrci \
  && echo /opt/oracle/instantclient* > /etc/ld.so.conf.d/oracle-instantclient.conf \
  && ldconfig

# Set the working directory to /app
WORKDIR /app

# Copy the rest of your app's source code from your host to your image filesystem.
COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY oracleconn.py . 

ENTRYPOINT [ "python", "oracleconn.py" ]
