#!groovy

pipeline {
    agent {
        node {
            label 'metersphere'
        }
    }
    triggers {
        pollSCM('20 * * * *')
    }
    environment {
        IMAGE_PREFIX = 'registry.cn-qingdao.aliyuncs.com/metersphere'
    }
    stages {
        stage('Community build & push') {
            steps {
                sh '''#!/bin/bash -xe
                docker --config /home/metersphere/.docker buildx build --no-cache --build-arg MS_VERSION=\${TAG_NAME:-\$BRANCH_NAME}-\${GIT_COMMIT:0:8} --build-arg IMG_TAG=\${TAG_NAME:-\$BRANCH_NAME} -t ${IMAGE_PREFIX}/metersphere-community:\${TAG_NAME:-\$BRANCH_NAME} -t metersphere/metersphere-community:\${TAG_NAME:-\$BRANCH_NAME} -f Dockerfile.community --platform linux/amd64,linux/arm64 . --push
                '''
            }
        }
        stage('Enterprise build & push') {
            steps {
                sh '''#!/bin/bash -xe

                sed -i -e "s#-community#-enterprise#g" Dockerfile

                docker --config /home/metersphere/.docker buildx build --no-cache --build-arg MS_VERSION=\${TAG_NAME:-\$BRANCH_NAME}-\${GIT_COMMIT:0:8} --build-arg IMG_TAG=\${TAG_NAME:-\$BRANCH_NAME} -t ${IMAGE_PREFIX}/metersphere-enterprise:\${TAG_NAME:-\$BRANCH_NAME} -t metersphere/metersphere-enterprise:\${TAG_NAME:-\$BRANCH_NAME} --platform linux/amd64,linux/arm64 . --push

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
