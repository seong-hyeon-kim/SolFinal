pipeline {
  agent any

  environment {
    AWS_REGION = 'ap-northeast-2'
    ECR_REGISTRY = '058264360223.dkr.ecr.ap-northeast-2.amazonaws.com'
    ECR_REPOSITORY = 'jenkins-ecr'
	githubCredential = 'b3554db2-0a4a-48c6-a9df-050674004325'
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
                        sh 'aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY'
                        dockerImage.push("${IMAGE_TAG}")
                        // dockerImage.push('latest')
                }
            }
        }
		stage('K8S Manifest Update') {
			steps {
			// git 계정 로그인, 해당 레포지토리의 main 브랜치에서 클론
			git credentialsId: githubCredential,
				url: 'https://github.com/seong-hyeon-kim/SolFinal.git',
				branch: 'main'  
	 
			// 이미지 태그 변경 후 메인 브랜치에 푸시
			sh "git config --global user.email ${gitEmail}"
			sh "git config --global user.name ${gitName}"
			// sh "sed -i 's/tomcat:.*/tomcat:${currentBuild.number}/g' deploy/production.yaml"
			sh "sed -i 's|058264360223.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins-ecr:.*|058264360223.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins-ecr:${currentBuild.number}|g' k8s/tomcat-deployment.yaml"
			sh "git add ."
			sh "git commit -m 'fix:${ECR_REGISTRY}/${ECR_REPOSITORY ${currentBuild.number} image versioning'"
			sh "git branch -M main"
			sh "git remote remove origin"
			// sh "git remote add origin git@github.com:mini-cicd-project/mini-cicd-project.git"
			sh "git remote add origin git@github.com:seong-hyeon-kim/SolFinal.git"

			sh "git push -u origin main"
			}

		}
	}
	

}

