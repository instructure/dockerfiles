ARG ROOT_PATH=instructure
FROM --platform=${TARGETPLATFORM} ${ROOT_PATH}/ruby:2.7
MAINTAINER Instructure

USER root
RUN apt-get update \
  && apt-get install -y g++

USER docker
RUN gem install mailcatcher -v 0.8.0

EXPOSE 1025 8080

ENTRYPOINT ["mailcatcher", "-f", "--ip=0.0.0.0", "--http-port=8080"]
