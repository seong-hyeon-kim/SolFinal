pipeline {
  agent any

  environment {
    AWS_REGION = 'ap-northeast-2'
    ECR_REGISTRY = '058264360223.dkr.ecr.ap-northeast-2.amazonaws.com'
    ECR_REPOSITORY = 'jenkins-ecr'
    IMAGE_TAG = "${env.BUILD_ID}"
  }

 stages {
        stage('Checkoutzzzzzzzzzzzzzz') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}")
                }
            }
        }
        stage('Push to ECR') {
            steps {
                script {
                        sh 'aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY'
                        dockerImage.push("${IMAGE_TAG}")
                        // dockerImage.push('latest')
                }
            }
        }
    }
}

