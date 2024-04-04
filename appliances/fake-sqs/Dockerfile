FROM --platform=${TARGETPLATFORM} ruby:3.3-alpine

RUN gem install fake_sqs -v 0.4.3

EXPOSE 3000

ENTRYPOINT ["/usr/local/bundle/bin/fake_sqs"]
CMD ["-p", "3000", "--no-daemonize"]
