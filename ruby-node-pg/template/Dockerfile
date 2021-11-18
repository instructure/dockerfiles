<%= generation_message %>
FROM instructure/ruby-passenger:<%= ruby_version %>
MAINTAINER Instructure

USER root

# install postgres client
RUN apt-get update \
    && apt-get install -yqq postgresql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && gem update --system

<% if yarn_version -%>
<%= Template.render_into_dockerfile("templates/yarn_install.Dockerfile", yarn_version: yarn_version) -%>
<% end -%>

<%= Template.render_into_dockerfile("templates/node_install.Dockerfile", node_version: node_version, npm_version: npm_version, base_distro: base_distro) %>

USER docker
