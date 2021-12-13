#! /usr/bin/env groovy

def dockerfileStages = [:]

pipeline {
  agent { label 'docker' }

  environment {
    TEST_IMAGE_NAME = 'dockerfiles_build'
    CHANGE_OWNER = "${GERRIT_CHANGE_OWNER_EMAIL.split("@")[0]}"
  }

  stages {
    stage('Ensure "generate" action has been done') {
      steps {
        timeout(activity: true, time: 30, unit: 'SECONDS') {
          dockerCacheLoad(image: "dockerfiles-ci")
          sh 'docker build --pull --tag dockerfiles-ci --file ci/Dockerfile .'
          sh """docker run --rm dockerfiles-ci sh -c "rake && git diff --exit-code" """
        }
      }
    }

    stage('Initialize dockerfiles stage') {
      steps {
        sh """
          docker rm -f dockerfiles_index || :
          docker run --name dockerfiles_index dockerfiles-ci sh -c "rake ci:index"
          docker cp dockerfiles_index:ci ci_files/
        """
        script {
          for (int i=0; i < 5; i++) {
            dockerfiles = readYaml file: "ci_files/dockerfiles_${i}.yml"
            dockerfileStages[i] = dockerfiles.collectEntries {
              [(it) : {
                timeout(activity: true, time: 10, unit: 'MINUTES') {
                  sh """docker build ${it}"""
                }
              }]
            }
          }
        }
      }
    }

    stage('Build dockerfiles (Set #1)') {
      steps {
        script { parallel dockerfileStages[0] }
      }
    }
    stage('Build dockerfiles (Set #2)') {
      steps {
        script { parallel dockerfileStages[1] }
      }
    }
    stage('Build dockerfiles (Set #3)') {
      steps {
        script { parallel dockerfileStages[2] }
      }
    }
    stage('Build dockerfiles (Set #4)') {
      steps {
        script { parallel dockerfileStages[3] }
      }
    }
    stage('Build dockerfiles (Set #5)') {
      steps {
        script { parallel dockerfileStages[4] }
      }
    }
  }

  post {
    always {
      sh 'docker rm -f dockerfiles_index || :'
    }

    failure {
      script {
        if (env.GERRIT_EVENT_TYPE == 'change-merged') {
          slackSend failOnError: true, channel: '#docker', color: 'danger', message: "@${CHANGE_OWNER} the dockerfiles post-merge <${env.BUILD_URL}|build> for your recently merged patch failed!"
        }
      }
    }

    success {
      script {
        if (env.GERRIT_EVENT_TYPE == 'change-merged') {
          dockerCacheStore(image: 'dockerfiles-ci')
        }
      }
    }
  }
}
