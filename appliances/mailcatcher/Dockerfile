FROM instructure/ruby:2.5
MAINTAINER Instructure

USER docker
RUN gem install mailcatcher -v 0.6.4

EXPOSE 1025 8080

ENTRYPOINT ["mailcatcher", "-f", "--ip=0.0.0.0", "--http-port=8080"]
