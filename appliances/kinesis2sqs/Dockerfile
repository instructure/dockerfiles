FROM instructure/ruby:2.3
MAINTAINER Instructure

USER docker

COPY Gemfile Gemfile.lock ./
RUN bundle install --quiet --jobs 8

COPY entrypoint.rb .

CMD ["/tini", "--", "ruby", "./entrypoint.rb"]
