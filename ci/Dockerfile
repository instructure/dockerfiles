FROM ruby:alpine

RUN apk --no-cache add git \
 && gem install bundler

WORKDIR /

COPY Gemfile* .

RUN bundle install

COPY . ./
