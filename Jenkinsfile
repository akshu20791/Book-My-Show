pipeline {
    agent any

    environment {
        DOCKERHUB_USER = "wajihamahek"
        DOCKER_IMAGE = "wajihamahek/bms-app"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'feat/wajiha/JIRA-2-jenkinsfile', url: 'https://github.com/WajihaMahek/Book-My-Show.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    sh """
                    docker build -t $DOCKER_IMAGE:$BUILD_NUMBER .
                    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKERHUB_USER" --password-stdin
                    docker push $DOCKER_IMAGE:$BUILD_NUMBER
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml
                """
            }
        }
    }
}

