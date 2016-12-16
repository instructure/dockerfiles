#scala

This is a base docker image for building sbt based projects.

Includes a wrapper around __sbt__ named __sbt-private__ for the
purpose of providing artifactory credentials from the environment at runtime.

A note about adding more versions. 
The version of sbt is managed in two locations, the Dockerfile has one, and there is a folder dependency in the 
sbt-private file.   If and when we add version X, you will need to manage that in both locations.  Dont forget.
