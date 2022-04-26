<%= generation_message %>
<%= from_image(base_image) %>
LABEL maintainer="Instructure"

USER root

<% if yarn_version -%>
<%= Template.render_into_dockerfile("templates/yarn_install.Dockerfile", yarn_version: yarn_version) -%>
<% end -%>

<%= Template.render_into_dockerfile("templates/node_install.Dockerfile", node_version: node_version, npm_version: npm_version, base_distro: base_distro) %>

USER docker
