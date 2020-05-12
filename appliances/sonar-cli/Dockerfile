FROM openjdk:11-jre-slim

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
      curl \
      dirmngr \
      gnupg2 \
      nodejs \
      unzip \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/

ENV SONARQUBE_SCANNER_VERSION "4.3.0.2102"

RUN curl -sSO https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONARQUBE_SCANNER_VERSION-linux.zip \
 && curl -sSO https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONARQUBE_SCANNER_VERSION-linux.zip.asc \
 && gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys CFCA4A29D26468DE \
 && gpg --verify sonar-scanner-cli-$SONARQUBE_SCANNER_VERSION-linux.zip.asc \
 && unzip sonar-scanner-cli-$SONARQUBE_SCANNER_VERSION-linux.zip \
 && rm sonar-scanner-cli-$SONARQUBE_SCANNER_VERSION-linux.zip* \
 && mv sonar-scanner-$SONARQUBE_SCANNER_VERSION-linux sonar-scanner \
 && sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' /sonar-scanner/bin/sonar-scanner

ENV PATH "/sonar-scanner/bin:$PATH"

# SonarQube Scanner sometimes relies on matching absolute paths in coverage reports,
# so we create common paths we've used in projects, but just default to /usr/src/app.
RUN mkdir -p /app /src
WORKDIR /usr/src/app

ENTRYPOINT ["sonar-scanner"]
