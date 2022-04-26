FROM <%= base_image %>

RUN mkdir -p /tmp/rover \
  && wget -O - https://github.com/apollographql/rover/tarball/<%= version %> | tar xz -C /tmp/rover --strip-components=1 \
  && cd /tmp/rover \
  && cargo run --release -- install
