FROM instructure/spark:2.1-hadoop2.7

ENV ZEPPELIN_VERSION 0.7.0

ENV ZEPPELIN_PORT 8080
ENV ZEPPELIN_HOME /usr/zeppelin
ENV ZEPPELIN_CONF_DIR $ZEPPELIN_HOME/conf
ENV ZEPPELIN_NOTEBOOK_DIR $ZEPPELIN_HOME/notebook

USER root

WORKDIR /root
RUN curl -sS http://apache.cs.utah.edu/zeppelin/zeppelin-${ZEPPELIN_VERSION}/zeppelin-${ZEPPELIN_VERSION}-bin-netinst.tgz | tar -xzf - && \
    mv /root/zeppelin* $ZEPPELIN_HOME && \
    mkdir -p $ZEPPELIN_HOME/logs \
             $ZEPPELIN_HOME/run && \
    chown -R docker:docker $ZEPPELIN_HOME && \
    rm -rf /root/zeppelin*

USER docker
WORKDIR $ZEPPELIN_HOME
CMD ["bin/zeppelin.sh"]
