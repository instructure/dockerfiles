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
    }

    post {
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

