pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "narasimha0001/bookmyshow"
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/akshu20791/Book-My-Show.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube-server') {
                    sh '''
                    sonar-scanner \
                      -Dsonar.projectKey=bookmyshow \
                      -Dsonar.sources=./bookmyshow-app \
                      -Dsonar.host.url=$SONAR_HOST_URL \
                      -Dsonar.login=$SONAR_AUTH_TOKEN
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'cd bookmyshow-app && npm install'
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker build -t $DOCKER_IMAGE:${BUILD_NUMBER} ./bookmyshow-app
                    docker push $DOCKER_IMAGE:${BUILD_NUMBER}
                    docker tag $DOCKER_IMAGE:${BUILD_NUMBER} $DOCKER_IMAGE:latest
                    docker push $DOCKER_IMAGE:latest
                    '''
                }
            }
        }

        stage('Deploy to Docker') {
            steps {
                sh 'docker run -d -p 3000:3000 --name bookmyshow $DOCKER_IMAGE:latest || true'
            }
        }
    }

    post {
        always {
            mail to: 'mudhenanarasimharao@gmail.com',
                 subject: "Build #${env.BUILD_NUMBER} - ${currentBuild.currentResult}",
                 body: "Check Jenkins console for details."
        }
    }
}
