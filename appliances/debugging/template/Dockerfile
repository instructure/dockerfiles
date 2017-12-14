FROM ubuntu:<%= version %>

USER root

RUN apt-get update && \
    apt-get install -y \
            gdb \
            lsof \
            strace && \
    apt-get clean

CMD ["bash"]
