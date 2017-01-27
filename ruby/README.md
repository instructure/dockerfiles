# Introduction
Your one-stop-shop for Instructure official Docker/Ruby love. If you
need ruby (2.1, 2.2, or 2.3) in Docker but don't need web services (we've
got `instructure/ruby-passenger` for that) you're in the right place.
Batteries (finicky C libs, see Dockerfile for full listing) are
included, so drop your app in (we suggest /usr/src/app) and start hacking.

# Making changes
Aside from the RVM image all of these files are generated using a Rake task
(generate:ruby) from the Dockerfile in the template directory. If you need to
make changes, make them to the template and then run the generation task.

# RVM
Included in this directory is a Dockerfile that installs RVM and all three
supported ruby versions. This setup is intended for use in CI environments
testing gems against multiple ruby versions. Sadly, due to the way RVM works
you'll need to run most commands with the -l flag supplied to bash to ensure
RVM works as you expect.
