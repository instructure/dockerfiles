FROM instructure/ruby:2.1

USER root
COPY entrypoint.sh /usr/src/app/

RUN chmod +x /usr/src/app/entrypoint.sh && \
    chown -R docker:docker /usr/src/app

USER docker
RUN gem install fake_sqs

EXPOSE 3000

ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
