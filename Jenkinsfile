pipeline {
  agent any
  environment {
    DOCKER_IMAGE = "sri642/bms-bms:${BUILD_NUMBER}"
    DOCKERHUB_CREDENTIALS = credentials('Docker-token')
  }
  stages {
    stage('Clean Workspace') { steps { cleanWs() } }
    stage('Checkout Code') { steps { git 'https://github.com/Srilatha7525/Book-My-Show-Devops.git' } }
    stage('SonarQube Analysis') {
      steps { withSonarQubeEnv('SonarQube') { sh 'mvn clean verify sonar:sonar' } }
    }
    stage('Install Dependencies') { steps { sh 'npm install' } }
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
        sh "docker run -d -p 3000:3000 ${DOCKER_IMAGE}"
      }
    }
  }
  post {
    success { mail to: 'srilathamaddasani05@gmail.com', subject: "Build SUCCESS", body: "See Jenkins for results." }
    failure { mail to: 'srilathamaddasani05@gmail.com', subject: "Build FAILED", body: "See Jenkins for results." }
  }
}
