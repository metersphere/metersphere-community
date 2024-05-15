#!groovy

pipeline {
    agent {
        node {
            label 'meterspherex'
        }
    }
    triggers {
        pollSCM('20 * * * *')
    }
    environment {
        IMAGE_PREFIX = 'registry.fit2cloud.com/metersphere'
    }
    stages {
        stage('Community build & push') {
            steps {
                sh '''#!/bin/bash -xe
                docker --config /home/metersphere/.docker buildx build --no-cache --build-arg MS_VERSION=\${TAG_NAME:-\$BRANCH_NAME}-\${GIT_COMMIT:0:8} --build-arg IMG_TAG=\${TAG_NAME:-\$BRANCH_NAME} -t ${IMAGE_PREFIX}/metersphere-ce:\${TAG_NAME:-\$BRANCH_NAME} -f Dockerfile.community --platform linux/amd64,linux/arm64 . --push
                '''
            }
        }
        stage('Enterprise build & push') {
            steps {
                sh '''#!/bin/bash -xe
                docker --config /home/metersphere/.docker buildx build --no-cache --build-arg MS_VERSION=\${TAG_NAME:-\$BRANCH_NAME}-\${GIT_COMMIT:0:8} --build-arg IMG_TAG=\${TAG_NAME:-\$BRANCH_NAME} -t ${IMAGE_PREFIX}/metersphere-ee:\${TAG_NAME:-\$BRANCH_NAME} --platform linux/amd64,linux/arm64 . --push
                '''
            }
        }
        stage('Allinone build & push') {
            steps {
                sh '''#!/bin/bash -xe
                docker --config /home/metersphere/.docker buildx build --no-cache --build-arg MS_VERSION=\${TAG_NAME:-\$BRANCH_NAME}-\${GIT_COMMIT:0:8} --build-arg IMG_TAG=\${TAG_NAME:-\$BRANCH_NAME} \
                 -t ${IMAGE_PREFIX}/metersphere-ce-allinone:\${TAG_NAME:-\$BRANCH_NAME} \
                 -t metersphere/metersphere-ce-allinone:\${TAG_NAME:-\$BRANCH_NAME} \
                 -f Dockerfile.all --platform linux/amd64,linux/arm64 . --push
                '''
            }
        }
        stage('Allinone release build & push') {
            when {
                anyOf {
                    tag pattern: "^v\\d+\\.\\d+\\.\\d+-alpha\$", comparator: "REGEXP";
                    tag pattern: "^v\\d+\\.\\d+\\.\\d+-beta\$", comparator: "REGEXP";

                    tag pattern: "^v\\d+\\.\\d+\\.\\d+\$", comparator: "REGEXP";
                    tag pattern: "^v\\d+\\.\\d+\\.\\d+-lts\$", comparator: "REGEXP";
                }
            }
            steps {
                sh '''#!/bin/bash -xe
                docker --config /home/metersphere/.docker buildx build --no-cache --build-arg MS_VERSION=\${TAG_NAME:-\$BRANCH_NAME}-\${GIT_COMMIT:0:8} --build-arg IMG_TAG=\${TAG_NAME:-\$BRANCH_NAME} \
                 -t ${IMAGE_PREFIX}/metersphere-ce-allinone:latest \
                 -t metersphere/metersphere-ce-allinone:latest \
                 -f Dockerfile.all --platform linux/amd64,linux/arm64 . --push
                '''
            }
        }
    }
    post('Notification') {
        always {
            sh "echo \$WEBHOOK\n"
            withCredentials([string(credentialsId: 'wechat-bot-webhook', variable: 'WEBHOOK')]) {
                qyWechatNotification failNotify: true, mentionedId: '', mentionedMobile: '', webhookUrl: "$WEBHOOK"
            }
        }
    }
}
