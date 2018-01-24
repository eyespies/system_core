FROM centos:6.6
RUN curl -L https://www.opscode.com/chef/install.sh | /bin/bash

RUN rpm -ivh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum update -y && yum install -y wget curl git htop dstat

