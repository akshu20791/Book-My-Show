# **Devops Project:Book My show App Deployment**

Welcome to the **Book My Show App Deployment** project! This project demonstrates how to deploy a *Book My show-clone application** using modern Devops tools and practices, following a **DevOps** approach.

---

Step 1: Jira Workflow
• Each candidate must assign themselves tasks in Jira.
• Track task progress using Jira board (To Do → In Progress → Done).
• Export the board as part of the final submission.
Step 2: GitHub Workflow
• Clone the GitHub repository: https://github.com/akshu20791/Book-My-Show/
• Create a feature branch and make changes.
• Push changes and raise a Pull Request (PR).
• Review peers' PRs and approve before merging into the main branch.
• Submit the final PR link as deliverable.
Step 3: Jenkins CI/CD Pipeline
Pipeline stages to implement:
1. Clean Workspace
2. Checkout Code from GitHub
3. SonarQube Analysis (Quality Gate)
4. Install Dependencies (NPM)
5. Trivy FS Scan (Optional)
6. OWASP Dependency Check (Optional)
7. Docker Build & Push to DockerHub (via Jenkins)
8. Deploy to Docker Container
9. (Optional) Deploy to Kubernetes (EKS)
10. Email Notification on build result
Step 4: Docker Deployment
• Candidates must write their own Dockerfile to build the BMS app image.
• Build Docker image and push to DockerHub via Jenkins.
• Run container locally and validate accessibility on port 3000.
Step 5: Kubernetes Deployment (EKS)
• Candidates must write their own Kubernetes manifests (`deployment.yaml`, `service.yaml`).
• Deploy the application on EKS cluster.
• Expose service using NodePort or LoadBalancer.
• Validate deployment using 'kubectl get pods' and 'kubectl get svc'.
Step 6: Monitoring & Observability
• Install Prometheus and Node Exporter to collect metrics.
• Integrate Jenkins metrics into Prometheus.
• Install Grafana, configure Prometheus as a data source.
• Add dashboards for Node health and Jenkins performance.
• Submit Grafana screenshots in deliverables.
