# See https://github.com/docker-library/rails/blob/9fb5d2b7e0f2e7029855028e07e86ab7ec54abaa/onbuild/Dockerfile
# and https://github.com/docker-library/rails/blob/7926577517fb974f9de9ca1511162d6d5e000435/Dockerfile
# for reference
FROM ruby:2.2.3

RUN apt-get update -qq
RUN apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /myapp
WORKDIR /myapp

ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

ADD . /myapp

EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
