FROM phusion/baseimage:master

# Use APT mirror for better performance
RUN sed -i 's|http://security.ubuntu.com/ubuntu/|mirror://mirrors.ubuntu.com/mirrors.txt|' /etc/apt/sources.list \
    && sed -i 's|http://extras.ubuntu.com/ubuntu/|mirror://mirrors.ubuntu.com/mirrors.txt|' /etc/apt/sources.list \
    && sed -i 's|http://archive.ubuntu.com/ubuntu/|mirror://mirrors.ubuntu.com/mirrors.txt|' /etc/apt/sources.list

ENV LANGUAGE en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive 

# Install os dependencies
RUN apt-add-repository ppa:brightbox/ruby-ng && \
    apt-get update && \
    apt-get install -y nodejs \
    ruby2.3 \
    ruby2.3-dev \
    build-essential \
    curl \
    zlib1g-dev \
    libssl-dev \
    libreadline-dev \
    libyaml-dev \
    libxml2-dev \
    libxslt-dev \
    libpq-dev \
    git python-virtualenv \
    libmysqlclient-dev \
    libmagickwand-dev \
    gnuplot \
    imagemagick-doc \
    imagemagick \
    wkhtmltopdf

RUN gem install bundler -v 1.17.3

ENV APP_HOME /share
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use baseimage-docker's init system then start the server
CMD ["bash", "-c", "/sbin/my_init & rails server"]
