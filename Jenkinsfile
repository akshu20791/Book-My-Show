pipeline {
    agent any

    tools {
        jdk 'jdk17'                // Ensure JDK 17 is configured in Jenkins
        nodejs 'node23'            // Node.js version for NPM
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'            // SonarQube scanner
        SONAR_TOKEN = credentials('Sonar-token')      // Jenkins Sonar token
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds') // Jenkins DockerHub creds
        REPO_NAME = 'khushijain0910/capstone-project' // DockerHub repo
        IMAGE_NAME = 'bms-app'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Khushijain0910-png/Capstone.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {  // SonarQube server name in Jenkins
                    sh """
                    ${SCANNER_HOME}/bin/sonar-scanner \
                    -Dsonar.projectKey=capstone-bms \
                    -Dsonar.projectName=Capstone-BMS \
                    -Dsonar.host.url=http://3.138.67.55:9000 \
                    -Dsonar.login=${SONAR_TOKEN}
                    """
                }
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
                    // Build Docker image
                    sh "docker build -t ${REPO_NAME}:${env.BUILD_NUMBER} ."

                    // Login to DockerHub
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"

                    // Push image
                    sh "docker push ${REPO_NAME}:${env.BUILD_NUMBER}"
                }
            }
        }

        stage('Deploy to Docker Container') {
            steps {
                script {
                    // Stop and remove old container if exists
                    sh "docker rm -f ${IMAGE_NAME} || true"

                    // Run new container
                    sh "docker run -d -p 3130:3130 --name ${IMAGE_NAME} ${REPO_NAME}:${env.BUILD_NUMBER}"
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished. Email notifications are disabled."
        }
    }
}

