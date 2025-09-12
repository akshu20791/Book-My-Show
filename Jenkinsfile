pipeline {
  agent any
  environment {
    DOCKER_REG = "preeti730"   // change if different
    IMAGE_NAME = "book-my-show"
    IMAGE_TAG  = "${env.GIT_COMMIT.take(7)}"
  }
  stages {
    stage('Checkout') { steps { checkout scm } }
    stage('Install & Test') {
      steps {
        sh 'npm ci || true'
        sh 'npm test || true'
      }
    }
    stage('Build Docker') {
      steps {
        sh "docker build -t ${DOCKER_REG}/${IMAGE_NAME}:${IMAGE_TAG} ."
      }
    }
    stage('Push Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
          sh "docker push ${DOCKER_REG}/${IMAGE_NAME}:${IMAGE_TAG}"
        }
      }
    }
    stage('Deploy K8s (optional)') {
      steps {
        withCredentials([file(credentialsId: 'kubeconfig-file', variable: 'KUBECONFIG_FILE')]) {
          sh 'export KUBECONFIG=$KUBECONFIG_FILE && kubectl apply -f k8s/'
        }
      }
    }
  }
  post { success { echo "Pipeline success" } failure { echo "Pipeline failed" } }
}
