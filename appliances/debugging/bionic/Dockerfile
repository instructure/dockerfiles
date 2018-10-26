FROM ubuntu:bionic

USER root

RUN apt-get update && \
    apt-get install -y \
            curl \
            gdb \
            lsof \
            net-tools \
            pstack \
            strace && \
    apt-get clean

CMD ["bash"]
