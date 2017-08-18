# SBT

This is a base docker image for building SBT based projects.

Includes a wrapper around __sbt__ named __sbt-private__ for the purpose of providing artifactory credentials from the environment at runtime.

## Tags

Available tags are `0.13` and `1.0`, which point to the respective SBT minor versions.

## Usage

Even with different tags, you can always use the any SBT version you want by specifying the SBT version you want to use in `project/build.properties` file. This is a valid pattern SBT 0.13.15 onwards. See [this link](http://www.scala-sbt.org/0.13/docs/Basic-Def.html) for more details.

When using the image as a base for another image, always cache the SBT jars by running an SBT command (eg. `sbt clean`) in the directory where the `project/build.properties` file resides, if you're using it, or anywhere if you're not. Make sure you run the command as the user you will be using SBT with, as it will download the JARs to the user's home directory.

## Adding new versions

Make changes to the `manifest.yml` file in the root of the project to add new versions.
