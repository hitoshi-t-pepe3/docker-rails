FROM centos:centos6
MAINTAINER pepechoko

RUN yum update -y
RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN yum install -y \
  build-essential \
  which \
  tar \
  git \
  tree \
  curl \
  passwd \
  openssh \
  openssh-server \
  openssh-clients \
  sudo
  zlib-devel \
  openssl-devel \
  readline-devel \
  libyaml-devel \
  libxml2-devel \
  libxslt-devel
  gcc\
  gcc-c++\
  sqlite-devel

## add rbenv group
RUN groupadd rbenv

# Install rbenv 
RUN cd /usr/local && git clone https://github.com/sstephenson/rbenv.git 
RUN chgrp -R rbenv /usr/local/rbenv
RUN chmod -R g+rwxXs /usr/local/rbenv

# Install ruby-build 
RUN mkdir /usr/local/rbenv/plugins
RUN cd /usr/local/rbenv/plugins && git clone https://github.com/sstephenson/ruby-build.git 
RUN chgrp -R rbenv /usr/local/rbenv/plugins/ruby-build
RUN chmod -R g+rwxXs /usr/local/rbenv/plugins/ruby-build
RUN cd /usr/local/rbenv/plugins/ruby-build && ./install.sh

ENV RBENV_ROOT /usr/local/rbenv
ENV PATH /usr/local/rbenv/bin:$PATH
ADD rbenv.sh /etc/profile.d/rbenv.sh
RUN chmod +x /etc/profile.d/rbenv.sh

# install rbenv-default-gems
RUN cd /usr/local/rbenv/plugins && git clone git://github.com/sstephenson/rbenv-default-gems.git
ADD ./default-gems /usr/local/rbenv/default-gems

# install rbevn-binstub
RUN cd /usr/local/rbenv/plugins && git clone git://github.com/ianheggie/rbenv-binstubs.git

# Install multiple versions of ruby
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc
ENV CONFIGURE_OPTS --disable-install-doc
ADD ./versions.txt /usr/local/rbenv/versions.txt
RUN xargs -L 1 rbenv install < /usr/local/rbenv/versions.txt

