# ./Dockerfile
FROM ruby:2.5
# set the app directory var
ENV RAILS_ENV development
ENV BUNDLE_PATH /bundle
# set the app directory var
ENV APP_HOME /home/app
WORKDIR $APP_HOME
RUN apt-get update -qq
# Install apt dependencies
RUN apt-get install -y --no-install-recommends \
  rails
  nodejs \  
  build-essential \
  curl libssl-dev \
  git \
  unzip \
  zlib1g-dev \
  libxslt-dev \
  default-mysql-client \
  sqlite3 \
  yarn
# install bundler
RUN gem install bundler
# Separate task from `add . .` as it will be
# Skipped if gemfile.lock hasn't changed *
COPY Gemfile ./Gemfile
# Install gems to /bundle
RUN bundle install
RUN rails webpacker:install
RUN yarn install --check-files
ADD . .
# compile assets!
# RUN bundle exec rake assets:precompile
EXPOSE 3000
CMD ["/sbin/my_init"]