FROM instructure/ruby:2.5

USER root

RUN mkdir -p /fakes3/fakes3_data_root
COPY entrypoint.sh /fakes3/

# setup for fakes3
RUN chmod +x /fakes3/entrypoint.sh && \
    chown -R docker:docker /fakes3

USER docker

# install fake-s3 - 0.2.5 is the last release licensed under MIT
RUN gem install fakes3 -v 0.2.5


# run fake-s3
EXPOSE 4569
ENTRYPOINT ["/fakes3/entrypoint.sh"]
