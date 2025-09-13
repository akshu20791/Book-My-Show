pipeline {
  agent any
  environment {
    PATH = "/opt/sonar-scanner/bin:${env.PATH}"
    DOCKER_IMAGE = "sri642/bms-bms:${BUILD_NUMBER}"
    DOCKERHUB_CREDENTIALS = credentials('Docker-token')
  }
  stages {
    stage('Clean Workspace') {
      steps {
        cleanWs()
      }
    }
    stage('Checkout Code') {
      steps {
        git branch: 'feature/docker-integration', url: 'https://github.com/Srilatha7525/Book-My-Show-Devops.git'
      }
    }
    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv('SonarQube') {
          sh 'sonar-scanner -Dsonar.projectKey=BookMyShow -Dsonar.sources=.'
        }
      }
    }
    stage('Install Dependencies') {
      steps {
        // Adjust directory if package.json is inside a subfolder
        dir('bookmyshow-app') {
          sh 'sh 'npm ci --cache .npm-cache''
        }
      }
    }
    stage('Docker Build & Push') {
      steps {
        script {
          docker.withRegistry('', env.DOCKERHUB_CREDENTIALS) {
            def app = docker.build(env.DOCKER_IMAGE)
            app.push()
          }
        }
      }
    }
    stage('Deploy to Docker') {
      steps {
        script {
          sh '''
            cid=$(docker ps -q -f "publish=3000")
            if [ ! -z "$cid" ]; then
              docker rm -f $cid
            fi
          '''
          sh "docker run -d -p 3000:3000 ${DOCKER_IMAGE}"
        }
      }
    }
  }
  post {
    success {
      mail to: 'srilathamaddasani05@gmail.com',
           subject: "Build SUCCESS",
           body: "Jenkins build ${env.BUILD_NUMBER} succeeded! Check Jenkins for details."
    }
    failure {
      mail to: 'srilathamaddasani05@gmail.com',
           subject: "Build FAILED",
           body: "Jenkins build ${env.BUILD_NUMBER} failed. Check Jenkins for details."
    }
  }
}
