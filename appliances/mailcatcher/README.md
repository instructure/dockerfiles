# MailCatcher

A docker container appliance wrapping [MailCatcher](https://mailcatcher.me/).

This runs a SMTP server (on port 1025) that accepts any mail you send it, and a
web server (on port 8080) for browsing those emails in a webmail context.

This is particularly useful for configuring a default development SMTP server
in your application that works out of the box.

An entry in your docker-compose.yml file might look like this:

```yaml
mailcatcher:
  image: instructure/mailcatcher
  environment:
    VIRTUAL_HOST: mail.example.docker
    VIRTUAL_PORT: 8080
```

Next, configure your development SMTP server settings (no auth required):

- address: mailcatcher
- port: 1025

In a Rails application, your `config/environments/development.rb` would be:

```ruby
  config.action_mailer.smtp_settings = {
    address: 'mailcatcher', port: 1025
  }
```

After spinning up the container, you can then open up your browser to:

- http://mail.example.docker/

This inbox will automatically refresh with incoming mail.
