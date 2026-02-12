<%= generation_message %>
<%= from_image(base_image) %>
LABEL maintainer="Instructure"

USER root

# Install Node.js from NodeSource, jq, and enable corepack for pnpm
RUN mkdir -p /etc/apt/keyrings && \
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_<%= node_version %>.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
  apt-get update && \
  apt-get install -y --no-install-recommends nodejs jq moreutils && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  corepack enable && \
  corepack prepare pnpm@8.15.0 --activate

USER docker
