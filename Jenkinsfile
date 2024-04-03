#! /usr/bin/env groovy

import com.cloudbees.groovy.cps.NonCPS

def dockerfileStages = [:]
def imageChanges = [:]

@NonCPS
def getKeyNamesText(imageChanges) {
  imageChanges.keySet().toArray().collect { k ->
    "${k}"
  }.sort().join(", ")
}

@NonCPS
def sortFileList(fileList) {
  return fileList.sort { it.name.split("_")[1].split("\\.")[0].toInteger() }
}

def getBuildRegistryPath() {
  if (env.GERRIT_EVENT_TYPE == 'change-merged') {
    return "jenkins"
  }

  return (commitMessageFlag("build-registry-path") as String) ?: "jenkins"
}

def isRoverEnabled() {
  return commitMessageFlag("build-rover") as Boolean
}

def isChangeMerged() {
  return env.GERRIT_EVENT_TYPE == 'change-merged' || (commitMessageFlag("change-merged") as Boolean)
}

def isDockerhubUploadEnabled() {
  return env.GERRIT_EVENT_TYPE == 'change-merged'
}

def isSlackReportingEnabled() {
  return env.GERRIT_EVENT_TYPE == 'change-merged' || (commitMessageFlag("slack-reporting") as Boolean)
}

pipeline {
  agent { label 'docker' }

  environment {
    TEST_IMAGE_NAME = 'dockerfiles_build'
    DEFAULT_ROOT_PATH = "${BUILD_REGISTRY_FQDN}/jenkins"
    ROOT_PATH = "${BUILD_REGISTRY_FQDN}/${getBuildRegistryPath()}"
  }

  stages {
    stage('Sanity Check') {
      steps {
        script {
          if(isChangeMerged() && env.GERRIT_EVENT_TYPE != 'change-merged' && env.CHANGE_MERGED != 'true' && ROOT_PATH == DEFAULT_ROOT_PATH) {
            error "[build-registry-path] must be specified at the same time as [change-merged]"
          }
        }
      }
    }

    stage('Rebase') {
      steps {
        script {
          if(!isChangeMerged()) {
            withGerritCredentials {
              sh "git fetch origin && git rebase origin/master"
            }
          }
        }
      }
    }

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
          withMultiPlatformBuilder {
            def sortedFiles = sortFileList(findFiles(glob: "ci_files/dockerfiles_*.yml"))

            if(isDockerhubUploadEnabled()) {
              withCredentials([string(credentialsId: 'dockerhub-rw', variable: 'DOCKERHUB_RW_PASSWORD')]) {
                sh 'docker login --username $DOCKERHUB_RW_USERNAME --password $DOCKERHUB_RW_PASSWORD'
              }
            }

            sortedFiles.each { file ->
              stage("Build Docker Images (Set ${file.name})") {
                timeout(activity: true, time: 30, unit: 'MINUTES') {
                  def parallelStages = readYaml(file: file.path).collectEntries {
                    [(it) : {
                      stage(file.path) {

                        if("${it}".trim() == "rover/v0.4.8" && !isRoverEnabled()) {
                          echo "Skipping rover build -- add [build-rover] to commit message"
                          return
                        }

                        def baseTag = it.replaceAll('appliances\\/', '')
                        def dockerhubTag = isDockerhubUploadEnabled() ? "--tag instructure/${baseTag.replaceAll('\\/', ':')}" : ''
                        def imageTag = "${ROOT_PATH}/${baseTag.replaceAll('\\/', ':')}"

                        def platform = sh(script: """
                          if grep -q TARGETPLATFORM ${it}/Dockerfile; then
                            echo "linux/arm64,linux/amd64"
                          else
                            echo "linux/amd64"
                          fi
                        """, returnStdout: true).trim()

                        def beforeManifest = sh(script: """
                          ci/docker-manifest.sh inspect ${imageTag} --verbose | jq -r '.[].OCIManifest.layers[] | select(.mediaType | contains("layer")) | .digest' | sort -
                        """, returnStdout: true).trim()

                        sh """
                        docker buildx build \
                          --build-arg ROOT_PATH=${ROOT_PATH} \
                          --cache-from=type=registry,ref=${imageTag} \
                          --cache-to=type=local,dest=${it}/cache_result \
                          --platform ${platform} \
                          --builder multi-platform-builder \
                          ${dockerhubTag} --tag ${imageTag} \
                          ${it}
                        """

                        def afterManifest = sh(script: "ci/get-cache-layers.sh ${it}/cache_result", returnStdout: true).trim()

                        if (beforeManifest != afterManifest) {
                          echo "=== IMAGE CHANGE DETECTED!"
                          echo "=== Manifest Before"
                          echo beforeManifest
                          echo "=== Manifest After"
                          echo afterManifest

                          imageChanges[baseTag.replaceAll('\\/', ':')] = true

                          if(isChangeMerged()) {
                            sh """
                            docker buildx build \
                              --build-arg BUILDKIT_INLINE_CACHE=1 \
                              --build-arg ROOT_PATH=${ROOT_PATH} \
                              --cache-from=type=registry,ref=${imageTag} \
                              --platform ${platform} \
                              --push \
                              --builder multi-platform-builder \
                              ${dockerhubTag} --tag ${imageTag} \
                              ${it}
                            """
                          }
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
  }

  post {
    always {
      script {
        sh 'docker rm -f dockerfiles_index || :'

        if (isSlackReportingEnabled() && imageChanges.size() == 0) {
          slackSend channel: '#devx-bots', color: 'good', message: "[Docker Image Sync @ <${env.BUILD_URL}|Build Link>] No images were updated."
        } else if (isSlackReportingEnabled()) {
          slackSend channel: '#docker', color: 'good', message: "[Docker Image Sync @ <${env.BUILD_URL}|Build Link>] ${imageChanges.size()} images were updated.```${getKeyNamesText(imageChanges)}```"
        }
      }
    }

    failure {
      script {
        if (env.GERRIT_EVENT_TYPE == 'change-merged') {
          slackSend failOnError: true, channel: '#docker', color: 'danger', message: "@${GERRIT_CHANGE_OWNER_EMAIL.split("@")[0]} the dockerfiles post-merge <${env.BUILD_URL}|build> for your recently merged patch failed!"
        } else if (isSlackReportingEnabled()) {
          slackSend failOnError: true, channel: '#docker', color: 'danger', message: "The dockerfiles cron <${env.BUILD_URL}|build> failed!"
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
