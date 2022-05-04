#! /usr/bin/env groovy

import com.cloudbees.groovy.cps.NonCPS

@groovy.transform.Field final static BUILD_REGISTRY_PATH_REGEX = /\[build\-registry\-path=(.+?)\]/
@groovy.transform.Field final static CHANGE_MERGED_REGEX = /\[change\-merged\]/
@groovy.transform.Field final static SLACK_REPORTING_REGEX = /\[slack\-reporting\]/

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
  def commitMessage = env.GERRIT_CHANGE_COMMIT_MESSAGE ? new String(env.GERRIT_CHANGE_COMMIT_MESSAGE.decodeBase64()) : null

  if (env.GERRIT_EVENT_TYPE == 'change-merged' || !commitMessage || !(commitMessage =~ BUILD_REGISTRY_PATH_REGEX).find()) {
    return 'jenkins'
  }

  return (commitMessage =~ BUILD_REGISTRY_PATH_REGEX).findAll()[0][1]
}

def getChangeMergedFlag() {
  def commitMessage = env.GERRIT_CHANGE_COMMIT_MESSAGE ? new String(env.GERRIT_CHANGE_COMMIT_MESSAGE.decodeBase64()) : null

  return commitMessage && (commitMessage =~ CHANGE_MERGED_REGEX).find()
}

def getSlackReportingEnabledFlag() {
  def commitMessage = env.GERRIT_CHANGE_COMMIT_MESSAGE ? new String(env.GERRIT_CHANGE_COMMIT_MESSAGE.decodeBase64()) : null

  return commitMessage && (commitMessage =~ SLACK_REPORTING_REGEX).find()
}

def isChangeMerged() {
  return env.GERRIT_EVENT_TYPE == 'change-merged' || getChangeMergedFlag()
}

def isDockerhubUploadEnabled() {
  return env.GERRIT_EVENT_TYPE == 'change-merged'
}

def isSlackReportingEnabled() {
  return env.GERRIT_EVENT_TYPE == 'change-merged' || getSlackReportingEnabledFlag() || env.SLACK_REPORTING == 'true'
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
          if(isChangeMerged() && env.GERRIT_EVENT_TYPE != 'change-merged' && ROOT_PATH == DEFAULT_ROOT_PATH) {
            error "[build-registry-path] must be specified at the same time as [change-merged]"
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
          def sortedFiles = sortFileList(findFiles(glob: "ci_files/dockerfiles_*.yml"))

          if(isDockerhubUploadEnabled()) {
            withCredentials([string(credentialsId: 'dockerhub-rw', variable: 'DOCKERHUB_RW_PASSWORD')]) {
              sh 'docker login --username $DOCKERHUB_RW_USERNAME --password $DOCKERHUB_RW_PASSWORD'
            }
          }

          sortedFiles.each { file ->
            stage("Build Docker Images (Set ${file.name})") {
              timeout(activity: true, time: 10, unit: 'MINUTES') {
                def parallelStages = readYaml(file: file.path).collectEntries {
                  [(it) : {
                    stage(file.path) {
                      timeout(activity: true, time: 10, unit: 'MINUTES') {
                        def baseTag = it.replaceAll('appliances\\/', '')
                        def dockerhubTag = isDockerhubUploadEnabled() ? "--tag instructure/${baseTag.replaceAll('\\/', ':')}" : ''
                        def imageTag = "${ROOT_PATH}/${baseTag.replaceAll('\\/', ':')}"

                        def manifestScript = { failureText ->
                          """
                          if grep -q TARGETPLATFORM ${it}/Dockerfile; then
                            docker manifest inspect ${imageTag} --verbose | jq -r '.[].SchemaV2Manifest.layers[].digest' | sort - || echo "${failureText}"
                          else
                            docker manifest inspect ${imageTag} --verbose | jq -r '.SchemaV2Manifest.layers[].digest' | sort - || echo "${failureText}"
                          fi
                          """
                        }

                        def platform = sh(script: """
                          if grep -q TARGETPLATFORM ${it}/Dockerfile; then
                            echo "linux/arm64,linux/amd64"
                          else
                            echo "linux/amd64"
                          fi
                        """, returnStdout: true).trim()

                        def beforeManifest = sh(script: manifestScript('LOAD_MANIFEST_FAILED'), returnStdout: true).trim()

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
      script {
        sh 'docker rm -f dockerfiles_index || :'

        if (isSlackReportingEnabled() && imageChanges.size() == 0) {
          slackSend channel: '#docker', color: 'good', message: "[Docker Image Sync] No images were updated."
        } else if (isSlackReportingEnabled()) {
          slackSend channel: '#docker', color: 'good', message: "[Docker Image Sync] ${imageChanges.size()} images were updated.```${getKeyNamesText(imageChanges)}```"
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
