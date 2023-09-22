<%= generation_message %>
ARG OPENSEARCH_VERSION=<%= opensearch_version %>

FROM --platform=${TARGETPLATFORM} opensearchproject/opensearch:$OPENSEARCH_VERSION as builder

USER root

RUN yum install -y gcc gcc-c++ make cmake pkg-config wget git

ENV JAVA_HOME=/usr/share/opensearch/jdk
ENV PATH=$JAVA_HOME/bin:$PATH

# Build coccoc-tokenizer (required by analysis-vietnamese)
RUN echo "Building coccoc-tokenizer"
WORKDIR /tmp
RUN git clone https://github.com/duydo/coccoc-tokenizer.git
RUN mkdir /tmp/coccoc-tokenizer/build
WORKDIR /tmp/coccoc-tokenizer/build
RUN cmake -DBUILD_JAVA=1 ..
RUN make install

# Build analysis-vietnamese
RUN echo "Building analysis-vietnamese"
WORKDIR /tmp
RUN wget https://dlcdn.apache.org/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.tar.gz \
    && tar xvf apache-maven-3.8.8-bin.tar.gz
ENV MVN_HOME=/tmp/apache-maven-3.8.8
ENV PATH=$MVN_HOME/bin:$PATH

WORKDIR /tmp
RUN git clone https://github.com/duydo/opensearch-analysis-vietnamese.git
WORKDIR /tmp/opensearch-analysis-vietnamese
RUN mvn verify clean --fail-never
RUN mvn --batch-mode -Dmaven.test.skip -e package

FROM opensearchproject/opensearch:$OPENSEARCH_VERSION
ARG OPENSEARCH_VERSION=<%= opensearch_version %>
ARG COCCOC_INSTALL_PATH=/usr/local
ENV COCCOC_DICT_PATH=$COCCOC_INSTALL_PATH/share/tokenizer/dicts

RUN echo "Installing analysis-vietnamese plugin"
COPY --from=builder $COCCOC_INSTALL_PATH/lib/libcoccoc_tokenizer_jni.so /usr/lib
COPY --from=builder $COCCOC_DICT_PATH $COCCOC_DICT_PATH
COPY --from=builder /tmp/opensearch-analysis-vietnamese/target/releases/opensearch-analysis-vietnamese-$OPENSEARCH_VERSION.zip /
RUN echo "Y" | /usr/share/opensearch/bin/opensearch-plugin install --batch file:///opensearch-analysis-vietnamese-$OPENSEARCH_VERSION.zip
