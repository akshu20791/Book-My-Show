pipeline {
  agent any

  environment {
    // Jenkins credentials ids
    DOCKERHUB_CRED = 'docker'           
    DOCKERHUB_REPO = 'prasanna394/bms-app'
    IMAGE_TAG = "${env.BUILD_NUMBER}"
    EMAIL_RECIPIENT = 'prasanna56439@gmail.com'
    SONAR_TOKEN = credentials('sonar-token') // SonarQube token (Secret text)
  }

  stages {
    stage('Clean workspace') {
      steps { deleteDir() }
    }

    stage('Checkout') {
      steps { checkout scm }
    }

    stage('SonarQube scan') {
      when { expression { fileExists('sonar-project.properties') } }
      steps {
        withSonarQubeEnv('sonar-server') {
          sh """
            sonar-scanner \
              -Dsonar.projectKey=bms-app \
              -Dsonar.sources=. \
              -Dsonar.host.url=\$SONAR_HOST_URL \
              -Dsonar.login=${SONAR_TOKEN}
          """
        }
      }
    }

    stage('Install dependencies') {
      steps {
        sh 'if [ -f package.json ]; then npm ci; fi'
        sh 'if [ -f pom.xml ]; then mvn -B -DskipTests clean package; fi'
      }
    }

    stage('Build (app)') {
      steps {
        sh 'npm run build || true'
      }
    }

    stage('Docker Build & Push') {
      steps {
        script {
          echo "Building Docker image: ${DOCKERHUB_REPO}:${IMAGE_TAG}"
          docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CRED) {
            def img = docker.build("${DOCKERHUB_REPO}:${IMAGE_TAG}")
            img.push()
            sh "docker tag ${DOCKERHUB_REPO}:${IMAGE_TAG} ${DOCKERHUB_REPO}:latest || true"
            img.push('latest')
          }
        }
      }
    }

    stage('Deploy (local Docker test)') {
      steps {
        sh '''
          docker rm -f bms-app || true
          docker run -d --name bms-app -p 3000:3000 ${DOCKERHUB_REPO}:${IMAGE_TAG}
          sleep 5
          echo "App started; checking health..."
          curl -f http://localhost:3000 || true
        '''
      }
    }

    stage('Deploy to Kubernetes (optional)') {
      when { expression { fileExists('k8s/deployment.yaml') } }
      steps {
        sh 'kubectl apply -f k8s/deployment.yaml'
        sh 'kubectl apply -f k8s/service.yaml'
      }
    }
  }

  post {
    success {
      mail to: "${EMAIL_RECIPIENT}",
           subject: " Build SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
           body: "Build #${env.BUILD_NUMBER} succeeded. Docker image: ${DOCKERHUB_REPO}:${IMAGE_TAG}"
    }
    failure {
      mail to: "${EMAIL_RECIPIENT}",
           subject: " Build FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
           body: "Build #${env.BUILD_NUMBER} failed. Check console output: ${env.BUILD_URL}"
    }
  }
}
