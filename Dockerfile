FROM ruby:2.6
MAINTAINER Donapieppo <donapieppo@yahoo.it>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y -y --no-install-recommends mysql-client libmariadbclient18 git nodejs apt-transport-https vim locales

RUN echo 'deb https://deb.nodesource.com/node_10.x stretch main' > /etc/apt/sources.list.d/nodesource.list
RUN echo 'deb https://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

RUN curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

RUN apt-get update \
    && apt-get install nodejs yarn \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .

# configuration
RUN ["/bin/cp", "doc/docker_database.yml", "config/database.yml"]
RUN ["/bin/cp", "doc/docker_seeds.rb", "db/seeds.rb"]

# old without docker compose
# db
#RUN ["rake", "db:create"]
#RUN ["rake", "db:schema:load"]
#EXPOSE 3000
#CMD ["rails", "server", "-b", "0.0.0.0"]



