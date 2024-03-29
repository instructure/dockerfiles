ENV NODE_VERSION <%= node_version %>
ENV NPM_VERSION <%= npm_version %>

RUN mkdir -p /usr/src/app && chown docker:docker /usr/src/app
WORKDIR /usr/src/app

<% if node_version.to_i < 16 -%>
<%# Non-active Node versions do not work with the new method (so far) -%>
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | apt-key add - && \
  echo "deb https://deb.nodesource.com/node_<%= node_version %>.x <%= base_distro %> main" > /etc/apt/sources.list.d/nodesource.list && \
  apt-get update && \
  apt-get install -y --no-install-recommends nodejs && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/ && \
  npm install -g "npm@$NPM_VERSION" && \
  rm -rf /root/.npm/_cacache && \
  npm cache clean --force
<% else -%>
RUN apt-get update && \
  apt-get install -y curl && \
  mkdir -p /etc/apt/keyrings && \
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_<%= node_version %>.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
  apt-get update && \
  apt-get install -y --no-install-recommends nodejs && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/ && \
  npm install -g "npm@$NPM_VERSION" && \
  rm -rf /root/.npm/_cacache && \
  npm cache clean --force
<% end -%>

COPY npm-private /usr/local/bin
