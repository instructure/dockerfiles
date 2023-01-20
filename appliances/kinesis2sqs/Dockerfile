FROM --platform=${TARGETPLATFORM} ruby:2.7-alpine
MAINTAINER Instructure

COPY Gemfile Gemfile.lock ./
RUN bundle install --quiet --jobs 8

COPY entrypoint.rb .

CMD ["ruby", "./entrypoint.rb"]
