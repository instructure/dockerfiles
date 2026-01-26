ENV YARN_VERSION <%= yarn_version %>

# Install Yarn via npm (more reliable than Corepack which depends on repo.yarnpkg.com)
RUN npm install -g yarn<%= yarn_version == 'latest' ? '' : "@$YARN_VERSION"%> \
  && rm -rf /root/.npm/_cacache \
  && npm cache clean --force

COPY yarn-private /usr/local/bin
