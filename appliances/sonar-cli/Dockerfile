FROM openjdk:8-alpine

RUN apk add --no-cache \
      curl \
      gnupg \
      nodejs \
      sed \
      unzip

ENV SONARQUBE_SCANNER_VERSION "3.3.0.1492"

RUN curl -sSO https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONARQUBE_SCANNER_VERSION-linux.zip \
 && curl -sSO https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONARQUBE_SCANNER_VERSION-linux.zip.asc \
 && gpg --recv-keys CFCA4A29D26468DE && gpg --verify sonar-scanner-cli-$SONARQUBE_SCANNER_VERSION-linux.zip.asc \
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
