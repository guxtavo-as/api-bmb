FROM ruby:3.2

RUN apt-get update -qq && apt-get install -y \
  unzip \
  curl \
  git-core \
  build-essential \
  postgresql-client \
  patch \
  libpq-dev \
  sqlite3 \
  locales

ENV APP_HOME /usr/src/app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/

RUN gem update --system
RUN gem install bundler
RUN bundle install --jobs=4 --retry=3

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

COPY . $APP_HOME
