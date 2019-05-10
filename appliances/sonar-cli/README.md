# SonarQube Scanner CLI

Docker image containing [SonarQube Scanner][scanner], allowing easy use from CI
build systems.

[scanner]: https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner

## Usage

Create your project in SonarQube, along with a token to configure with CI.

Configure your `sonar-project.properties` in your project's root directory:

```
sonar.projectKey=my-project
sonar.sources=app,config,db,lib
sonar.ruby.coverage.reportPaths=coverage/.resultset.json
```

If you're using Jenkins pipelines, add your project token to your Jenkins
credentials store, then load that token in your pipeline stage like so:

```
stage('SonarQube') {
  when { environment name: "GERRIT_EVENT_TYPE", value: "change-merged" }
  environment { SONAR_TOKEN = credentials('SONAR_TOKEN') }
  steps {
    sh '''
      docker run --rm \
        -v `pwd`:/usr/src/app \
        -v coverage:/usr/src/app/coverage \
        instructure/sonar-cli \
        -Dsonar.host.url=https://sonarqube.core.inseng.net \
        -Dsonar.login=$SONAR_TOKEN \
        -Dsonar.projectBaseDir=/usr/src/app \
        -Dsonar.working.directory=/tmp
    '''
  }
}
```

Note: Setting `sonar.working.directory` to `/tmp` prevents the scanner from
writing `.scannerwork` intermediate files to your bind-mounted volume (which
would result in `root`-owned files in your Jenkins working directory). This
is also why it's necessary to configure `sonar.projectBaseDir`.
