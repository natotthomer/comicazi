FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y nodejs mariadb-client nano
RUN echo "# deb http://snapshot.debian.org/archive/debian/20200514T145000Z buster main" > /etc/apt/sources.list
RUN echo "deb http://deb.debian.org/debian buster main contrib non-free" >> /etc/apt/sources.list
RUN echo "# deb http://snapshot.debian.org/archive/debian-security/20200514T145000Z buster/updates main" >> /etc/apt/sources.list
RUN echo "deb http://security.debian.org/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list
RUN echo "# deb http://snapshot.debian.org/archive/debian/20200514T145000Z buster-updates main" >> /etc/apt/sources.list
RUN echo "deb http://deb.debian.org/debian buster-updates main contrib non-free" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y rar unrar zip unzip
RUN gem install cbr2cbz

RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

RUN bundle install
COPY . /myapp

# Add a script to be executed every time the container starts.
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]