FROM rockylinux:8

RUN dnf install -y git ruby-devel gcc make rpm-build libffi-devel wget \
    && gem install --no-document fpm
