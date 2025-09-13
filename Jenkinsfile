pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = '<your-dockerhub-username>'
        DOCKER_IMAGE = 'bms'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/<your-username>/Book-My-Show.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    sh """
                    docker build -t $DOCKER_HUB_USER/$DOCKER_IMAGE:latest .
                    echo $DOCKER_HUB_PASS | docker login -u $DOCKER_HUB_USER --password-stdin
                    docker push $DOCKER_HUB_USER/$DOCKER_IMAGE:latest
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                kubectl apply -f deployment.yaml
                kubectl apply -f service.yaml
                """
            }
        }
    }
}
