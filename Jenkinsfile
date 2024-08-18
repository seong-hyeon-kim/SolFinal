pipeline {
  agent any
  // Global Tool Configuration 에서 설정한 Name
  tools {
    maven 'Maven3' 
  }
 
  // 해당 스크립트 내에서 사용할 로컬 변수들 설정
  // 레포지토리가 없으면 생성됨
  // Credential들에는 젠킨스 크레덴셜에서 설정한 ID를 사용
  environment {
    AWS_REGION = 'ap-northeast-2'
    ECR_REGISTRY = '058264360223.dkr.ecr.ap-northeast-2.amazonaws.com'
    ECR_REPOSITORY = 'jenkins-ecr'
    githubCredential = 'git_hub'
    gitEmail = 'sung44428@gmail.com'
    gitName = 'seong-hyeon-kim'
  }
 
  stages {
	
    stage('Check for [skip ci]') {
        steps {
            script {
                def commitMessage = sh(script: 'git log -1 --pretty=%B', returnStdout: true).trim()
                if (commitMessage.contains('[skip ci]')) {
                    echo "Skipping build due to commit message: ${commitMessage}"
                    currentBuild.result = 'SUCCESS'
                    error("Build skipped due to [skip ci] tag in the commit message.")
                } else {
                    echo "No [skip ci] found in the commit message. Proceeding with the build."
                }
            }
        }
    }


 
    // 깃허브 계정으로 레포지토리를 클론한다.
    stage('Checkout Application Git Branch') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: githubCredential, url: 'https://github.com/seong-hyeon-kim/SolFinal.git']]])
      }
      // steps 가 끝날 경우 실행한다.
      // steps 가 실패할 경우에는 failure 를 실행하고 성공할 경우에는 success 를 실행한다.
      post {
        failure {
          echo 'Repository clone failure' 
        }
        success {
          echo 'Repository clone success' 
        }
      }
    }
 
    // Maven 을 사용하여 Jar 파일 생성    
    stage('Maven Jar Build') {
      steps {
        sh 'mvn clean install'  
      }
      post {
        failure {
          echo 'Maven war build failure' 
        }
        success {
          echo 'Maven war build success'
        }
      }
    }
    stage('Docker Image Build') {
      steps {
        // 도커 이미지 빌드
        sh "docker build . -t ${ECR_REGISTRY}/${ECR_REPOSITORY}:${currentBuild.number}"
        sh "docker build . -t ${ECR_REGISTRY}:latest"
      }
      // 성공, 실패 시 슬랙에 알람오도록 설정
      post {
        failure {
          echo 'Docker image build failure'
        }
        success {
          echo 'Docker image build success'
        }
      }
    }  
 
    stage('Docker Image Push') {
      steps {
	// AWS 자격 증명을 사용하여 ECR 로그인 및 Docker 이미지 푸시
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'jenkins-aws-credentials']]) {
            // ECR 로그인
            sh 'aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 058264360223.dkr.ecr.ap-northeast-2.amazonaws.com'

            // Docker 이미지 태그 설정
            sh "docker tag ${ECR_REGISTRY}/${ECR_REPOSITORY}:${currentBuild.number} ${ECR_REGISTRY}/${ECR_REPOSITORY}:${currentBuild.number}"
            sh "docker tag ${ECR_REGISTRY}/${ECR_REPOSITORY}:${currentBuild.number} ${ECR_REGISTRY}/${ECR_REPOSITORY}:latest"

            // ECR에 Docker 이미지 푸시
            sh "docker push ${ECR_REGISTRY}/${ECR_REPOSITORY}:${currentBuild.number}"
            sh "docker push ${ECR_REGISTRY}/${ECR_REPOSITORY}:latest"

            // 10초 쉰 후에 다음 작업 이어나가도록 함
            sleep 10
        }
        } 
      
 
      post {
        failure {
          echo 'Docker Image Push failure'
          // sh "docker rmi ${ECR_REGISTRY}/${ECR_REPOSITORY}:${currentBuild.number}"
          // sh "docker rmi ${ECR_REGISTRY}/${ECR_REPOSITORY}:latest"
        }
        success {
          echo 'Docker Image Push success'
          // sh "docker rmi ${ECR_REGISTRY}/${ECR_REPOSITORY}:${currentBuild.number}"
          // sh "docker rmi ${ECR_REGISTRY}/${ECR_REPOSITORY}:latest"
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
	sh "pwd"
	sh "sed -i 's|image: .*|image: 058264360223.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins-ecr:${currentBuild.number}|' final/k8s/tomcat-deployment.yaml"
        sh "git add ."
        sh "git commit -m '[skip ci] fix:${ECR_REGISTRY}/${ECR_REPOSITORY} ${currentBuild.number} image versioning'"
        sh "git branch -M main"
        sh "git remote remove origin"
        sh "git remote add origin git@github.com:seong-hyeon-kim/SolFinal.git"
        sh "git push -u origin main"
      }
      post {
        failure {
          echo 'K8S Manifest Update failure'
        }
        success {
          echo 'K8s Manifest Update success'
        }
      }
    }
 
  }
}
