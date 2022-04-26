#! /usr/bin/env groovy

import com.cloudbees.groovy.cps.NonCPS

def dockerfileStages = [:]

@NonCPS
def sortFileList(fileList) {
  return fileList.sort { it.name.split("_")[1].split("\\.")[0].toInteger() }
}

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
          rm -rf ci_files/*
          docker rm -f dockerfiles_index || :
          docker run --name dockerfiles_index dockerfiles-ci sh -c "rm -rf ci/dockerfiles* && rake ci:index && find ci"
          docker cp dockerfiles_index:ci/. ci_files/
          find ci_files
        """
        script {
          def sortedFiles = sortFileList(findFiles(glob: "ci_files/dockerfiles_*.yml"))

          sortedFiles.each { file ->
            stage("Build Docker Images (Set ${file.name})") {
              timeout(activity: true, time: 10, unit: 'MINUTES') {
                def parallelStages = readYaml(file: file.path).collectEntries {
                  [(it) : {
                    stage(file.path) {
                      timeout(activity: true, time: 10, unit: 'MINUTES') {
                        sh """docker build ${it}"""
                      }
                    }
                  }]
                }

                parallel(parallelStages)
              }
            }
          }
        }
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
