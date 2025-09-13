# Book My Show - DevOps Capstone

This project demonstrates a complete DevOps lifecycle for the BookMyShow application.

## Contents
- Jenkinsfile (CI/CD pipeline)
- Dockerfile (containerizing the app)
- Kubernetes Manifests:
  - deployment.yaml
  - service.yaml

## How to Run
1. Build the project: `mvn clean package`
2. Build Docker image: `docker build -t wajihamahek/bms-app .`
3. Run container: `docker run -p 3000:8080 wajihamahek/bms-app`
4. Deploy on Kubernetes:
   ```bash
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml

