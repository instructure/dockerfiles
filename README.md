# Open source Instructure base docker images

# Updating an image

The language base images along with their web server (passenger) counterparts
are all generated using a template system. To make changes change the files in
the respective `template` directory then run `rake` to propagate the changes to
each version of the build directory. Parameters for building each templated
directory are supplied by the manifest file found in the project directory.
Each object supplied in the versions object corresponds to a version directory
in the respective language. This object is merged with the defaults object along
with version and generation_message keys are supplied to any template files
specified in the manifest.
