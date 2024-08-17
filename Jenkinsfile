pipeline {
  agent any

  environment {
    AWS_REGION = 'ap-northeast-2'
    ECR_REGISTRY = '058264360223.dkr.ecr.ap-northeast-2.amazonaws.com'
    ECR_REPOSITORY = 'jenkins-ecr'
    githubCredential = 'git_hub'
    IMAGE_TAG = "${env.BUILD_ID}"
    gitEmail = 'sung44428@gmail.com'
    gitName = 'seong-hyeon-kim'
  }

 stages {
        stage('Checkout') {
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
                    sh 'aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}'
                    dockerImage.push("${IMAGE_TAG}")
                }
            }
        }
        stage('K8S Manifest Update') {
            steps {
		git credentialsId: githubCredential,
     	        url: 'https://github.com/seong-hyeon-kim/SolFinal.git',
                branch: 'main'               



                sh "git config --global user.email ${gitEmail}"
                sh "git config --global user.name ${gitName}"
                sh "sed -i 's|${ECR_REGISTRY}/${ECR_REPOSITORY}:.*|${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}|g' final/k8s/tomcat-deployment.yaml"
                sh "git add ."
                sh "git commit -m 'fix:${ECR_REGISTRY}/${ECR_REPOSITORY} ${IMAGE_TAG} image versioning'"
       	        sh "git remote remove origin"
                sh "git remote add origin git@github.com:seong-hyeon-kim/SolFinal.git"	       
                sh "git push -u origin main"
            }
        }
    }
}

