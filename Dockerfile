FROM centos:8

RUN dnf install -y ruby-devel gcc make rpm-build libffi-devel wget \
    && gem install --no-document fpm
