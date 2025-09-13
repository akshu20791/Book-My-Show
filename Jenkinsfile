pipeline {
    agent any

    // Tools installed via Jenkins Global Tool Configuration
    tools {
        nodejs "NodeJS"                // NodeJS configured in Jenkins
        
    }

    environment {
        DOCKERHUB_USER   = 'raf1345'                    // DockerHub username
        APP_NAME         = 'bookmyshow'                 // App name
        IMAGE_TAG        = "v${BUILD_NUMBER}"           // Unique tag per build
        DOCKERHUB_CREDS  = 'dockerhub-creds'           // Jenkins DockerHub credentials ID
        // SONAR_HOST     = 'http://35.180.109.34:9000'   
        // SONAR_SERVER     = 'SonarQube'              
        // SONAR_TOKEN      = credentials('sonar-token')  // Jenkins secret text credential
        AWS_REGION       = 'eu-west-3'                 // EKS region
        CLUSTER_NAME     = 'batch4-team2-eks-cluster'  // EKS cluster name
    }

    stages {
        stage('Clean Workspace') {
            steps { cleanWs() }
        }

    stage('Checkout Code') {
        steps {
            git branch: 'feature/update-readme',
            url: 'https://github.com/Rafi345/Book-My-Show.git',
            credentialsId: 'github_id' // add this if private repo
    }
}


       stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                    sh """
                      /opt/sonar-scanner/bin/sonar-scanner \
                      -Dsonar.projectKey=bookmyshow \
                      -Dsonar.sources=${env.WORKSPACE} \
                      -Dsonar.host.url=http://35.180.109.34:9000 \
                      -Dsonar.login=$SONAR_TOKEN
                    """
                }
            }
        }



        // stage('Quality Gate') {
        //     steps {
        //         waitForQualityGate abortPipeline: true
        //     }
        // }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "Building Docker image..."
                        docker build -t ${DOCKERHUB_USER}/${APP_NAME}:${IMAGE_TAG} .

                        echo "Logging in to DockerHub..."
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin

                        echo "Pushing image..."
                        docker push ${DOCKERHUB_USER}/${APP_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }

        stage('Deploy to Docker (Local)') {
            steps {
                sh """
                    docker rm -f bms-app || true
                    docker run -d --name bms-app -p 3000:3000 ${DOCKERHUB_USER}/${APP_NAME}:${IMAGE_TAG}
                """
            }
        }

        stage('Update Kubeconfig') {
            steps {
                sh "aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml
                    kubectl set image deployment/bookmyshow-deployment \
                      bookmyshow-container=${DOCKERHUB_USER}/${APP_NAME}:${IMAGE_TAG} --record

                    kubectl rollout status deployment/bookmyshow-deployment
                    kubectl get pods -o wide
                    kubectl get svc -o wide
                """
            }
        }
    }

    post {
        success {
            mail to: "rafishaik0066@gnail.com",
                 subject: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "Build & deploy succeeded. Image: ${DOCKERHUB_USER}/${APP_NAME}:${IMAGE_TAG}"
        }
        failure {
            mail to: "rafishaik0066@gmail.com",
                 subject: "FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "Build failed. Check logs: ${env.BUILD_URL}"
        }
    }
}
