# Appliances

These are docker images that are intended to be used as "appliances" the same
way that you'd use the postgres or redis images. Typically they use ENDPOINT and
define their own VOLUME if they store data on disk between runs.

Many appliances are third party applications that other Instructure projects
use, and we've created our own appliance for them here because there was no
existing good option in the Docker Registry.
