# 🚀 AWS 3-Tier Architecture with Terraform, Docker & GitHub Actions

![AWS](https://img.shields.io/badge/AWS-Cloud-orange)
![Terraform](https://img.shields.io/badge/Terraform-IaC-purple)
![Docker](https://img.shields.io/badge/Docker-Containers-blue)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-CI%2FCD-black)
![Nginx](https://img.shields.io/badge/Nginx-Reverse%20Proxy-green)
![Node.js](https://img.shields.io/badge/Node.js-Backend-brightgreen)
![React](https://img.shields.io/badge/React-Frontend-blue)
![MySQL](https://img.shields.io/badge/MySQL-Database-blue)

A **3-Tier Web Application deployed on AWS** using **Terraform, Docker, Amazon ECR, EC2, Application Load Balancers, Amazon RDS, Nginx, AWS Systems Manager and GitHub Actions**.

This project demonstrates how to build and automate a complete AWS infrastructure and application deployment using **Infrastructure as Code (IaC)** and **CI/CD**.

---

# 📌 Project Overview

This project implements a traditional **3-Tier Architecture**:

                    Internet
                       │
                       ▼
              ┌─────────────────┐
              │   Public ALB    │
              │      :80        │
              └────────┬────────┘
                       │
                       ▼
          ┌─────────────────────────┐
          │     Frontend EC2s       │
          │   React + Nginx :80     │
          │                         │
          │      Public Subnets     │
          └────────────┬────────────┘
                       │
                    /api/
                       │
                       ▼
              ┌─────────────────┐
              │  Internal ALB  │
              │      :80       │
              └────────┬────────┘
                       │
                       ▼
          ┌─────────────────────────┐
          │      Backend EC2s       │
          │     Node.js :4000       │
          │                         │
          │      Private Subnets    │
          └────────────┬────────────┘
                       │
                    :3306
                       │
                       ▼
              ┌─────────────────┐
              │   Amazon RDS    │
              │     MySQL       │
              │                 │
              │   DB Subnets    │
              └─────────────────┘

---

#🏗️ Architecture

🔥 Architecture Components
## 1️⃣ Presentation Tier
The frontend is built using React.

The React application is:
Built using Node.js
Packaged into a Docker image
Served using Nginx
Deployed on EC2 instances
Located in public subnets
Registered with the Public Application Load Balancer

Frontend flow:
User
  ↓
Public ALB
  ↓
Frontend EC2
  ↓
Nginx
  ↓
React Application


## 2️⃣ Application Tier
The backend is built using Node.js + Express.

The backend:

* Runs inside Docker
* Listens on port 4000
* Runs on private EC2 instances
* Is registered with the Internal Application Load Balancer
* Communicates with Amazon RDS

Backend flow:

Frontend
   ↓
Internal ALB
   ↓
Backend EC2
   ↓
Node.js Application
   ↓
RDS MySQL

## 3️⃣ Database Tier
The database tier uses Amazon RDS for MySQL.

The database:

Runs in private DB subnets
Uses a DB subnet group
Is not directly accessible from the internet
Accepts traffic only from the backend security group
Uses port 3306

## ☁️ AWS Infrastructure
The infrastructure is created using Terraform.

## AWS services used
Amazon VPC
Public Subnets
Private Subnets
DB Subnets
Internet Gateway
NAT Gateway
Elastic IP
Route Tables
Security Groups
EC2
Application Load Balancer
Target Groups
Amazon ECR
Amazon RDS MySQL
IAM
AWS Systems Manager


## 🌐 VPC Architecture

VPC CIDR:
10.0.0.0/16

Public Subnets
10.0.0.0/24
10.0.1.0/24
Used for:
Frontend EC2 instances
Public ALB
NAT Gateway

Private Subnets
10.0.2.0/24
10.0.3.0/24
Used for:
Backend EC2 instances
Internal ALB

Database Subnets
10.0.4.0/24
10.0.5.0/24
Used for:
Amazon RDS MySQL


## 🔐 Security Group Architecture
Traffic is restricted using security groups.

Internet
   │
   ▼
Public ALB Security Group
   │
   │ Port 80
   ▼
Frontend Security Group
   │
   │ Port 80
   ▼
Internal ALB Security Group
   │
   │ Port 4000
   ▼
Backend Security Group
   │
   │ Port 3306
   ▼
Database Security Group

## Rules
Component	    Port	Source
Public ALB	    80	    Internet
Frontend EC2	80	    Public ALB SG
Internal ALB	80	    Frontend SG
Backend EC2	    4000	Internal ALB SG
RDS MySQL	    3306	Backend SG
This prevents direct internet access to the backend and database.

## 🐳 Docker Architecture
Both frontend and backend applications are containerized.

## Frontend Docker flow
React Source Code
       ↓
Node.js Build
       ↓
npm run build
       ↓
Nginx Docker Image
       ↓
Frontend Container
       ↓
Port 80

## Backend Docker flow
Node.js Source Code
       ↓
Docker Build
       ↓
Backend Docker Image
       ↓
Backend Container
       ↓
Port 4000


## 🔄 Frontend → Backend Communication
The React application does not directly connect to the backend EC2 private IP.

The frontend sends API requests through Nginx.

Example:
fetch('/api/transaction')

Nginx receives:
/api/transaction

and forwards the request to the Internal ALB.

Browser
   ↓
Public ALB
   ↓
Frontend EC2
   ↓
Nginx
   ↓
Internal ALB
   ↓
Backend EC2
   ↓
Node.js

The Nginx configuration uses:
location /api/ {
    proxy_pass http://${INTERNAL_ALB_DNS}/;
}

Therefore:
/api/transaction
        ↓
/transaction

The backend exposes:
GET /transaction


## 🗄️ Backend → Database Communication
The Node.js backend connects to RDS using:

DB_HOST
DB_USER
DB_PWD
DB_DATABASE

## The connection uses:
Backend EC2
    ↓
RDS Endpoint
    ↓
Port 3306
    ↓
MySQL
The backend never needs the database's IP address.
Instead, it uses the RDS DNS endpoint.

## 🏗️ Infrastructure as Code
Terraform is used to create and manage the AWS infrastructure.

## Terraform manages:
VPC
Subnets
Route Tables
Internet Gateway
NAT Gateway
Elastic IP
Security Groups
EC2
IAM
ECR
RDS
ALB
Target Groups
Listeners

## 📁 Project Structure
```
aws-3-tier-architecture-terraform/
│
├── .github/
│   └── workflows/
│       └── ci.yml
│
├── 3-tier-workflow/
│   └── Architecture.gif
│
├── application-code/
│   │
│   ├── nginx.conf
│   │
│   ├── app-tier/
│   │   └── app-tier/
│   │       ├── DbConfig.js
│   │       ├── Dockerfile
│   │       ├── index.js
│   │       ├── package.json
│   │       ├── package-lock.json
│   │       └── TransactionService.js
│   │
│   └── web-tier/
│       └── web-tier/
│           ├── Dockerfile
│           ├── nginx.conf
│           ├── package.json
│           ├── package-lock.json
│           ├── public/
│           └── src/
│
├── auto-scaling.tf
├── ec2.tf
├── ecr.tf
├── eip.tf
├── iam.tf
├── internet-gateway.tf
├── lb.tf
├── main.tf
├── nat-gateway.tf
├── outputs.tf
├── provider.tf
├── rds.tf
├── rout-table.tf
├── security.tf
├── subnet.tf
├── target-group.tf
└── vpc.tf
```

## 🔧 Terraform Files
File	                Purpose
provider.tf	            AWS provider configuration
vpc.tf	                Creates VPC
subnet.tf	            Creates subnets
internet-gateway.tf	    Internet Gateway
nat-gateway.tf	        NAT Gateway
eip.tf	                Elastic IP
rout-table.tf	        Route tables
security.tf	            Security groups
ec2.tf	                EC2 instances
iam.tf	                IAM roles and permissions
ecr.tf	                ECR repositories
lb.tf	                Load Balancers
target-group.tf	        Target groups
rds.tf	                RDS MySQL
outputs.tf	            Terraform outputs
auto-scaling.tf	        Auto Scaling configuration/work area


## 🚀 CI/CD Pipeline
GitHub Actions is used to automate Docker image creation and deployment.
```
Developer
    │
    │ git push
    ▼
GitHub Repository
    │
    ▼
GitHub Actions
    │
    ├───────────────┐
    │               │
    ▼               ▼
Frontend Build   Backend Build
    │               │
    ▼               ▼
Docker Build     Docker Build
    │               │
    ▼               ▼
Amazon ECR       Amazon ECR
    │               │
    └───────┬───────┘
            │
            ▼
       AWS SSM
            │
            ▼
       EC2 Instances
            │
            ▼
     Docker Pull Image
            │
            ▼
     Start New Container
```

## 🔄 CI/CD Process

When code is pushed to the main branch:
git push
   ↓
GitHub Actions starts
   ↓
Configure AWS credentials
   ↓
Login to Amazon ECR
   ↓
Build Docker image
   ↓
Tag Docker image
   ↓
Push image to ECR
   ↓
Use AWS SSM
   ↓
Connect to EC2
   ↓
Pull latest Docker image
   ↓
Remove old container
   ↓
Start new container
The workflow can also be started manually using:
GitHub Actions → Run workflow


## 📦 Amazon ECR

Two ECR repositories are used:
frontend-image
backend-image

Images are stored as:
<account-id>.dkr.ecr.ap-south-1.amazonaws.com/frontend-image:latest
<account-id>.dkr.ecr.ap-south-1.amazonaws.com/backend-image:latest


## 🖥️ EC2 Deployment

Frontend EC2 instances run in public subnets.
Backend EC2 instances run in private subnets.
Docker is installed automatically using EC2 user_data.

The EC2 setup installs:
Docker
AWS CLI v2
AWS Systems Manager Agent


## 🔑 IAM

EC2 instances use an IAM instance profile.
The EC2 IAM role provides permissions for:

    Pulling images from ECR
    Connecting to AWS Systems Manager
This allows deployment without storing AWS credentials inside the EC2 instance.

## 📡 AWS Systems Manager
GitHub Actions uses AWS Systems Manager to execute deployment commands on EC2.

## Example deployment flow:
GitHub Actions
      ↓
AWS SSM
      ↓
Frontend EC2
      ↓
docker pull
      ↓
docker run

and:

GitHub Actions
      ↓
AWS SSM
      ↓
Backend EC2
      ↓
docker pull
      ↓
docker run


## 🧪 Terraform Commands

Initialize Terraform:
terraform init

Format Terraform files:
terraform fmt

Validate configuration:
terraform validate

Create execution plan:
terraform plan

Create infrastructure:
terraform apply

Destroy infrastructure:
terraform destroy

Check Terraform state:
terraform state list


## 🔐 GitHub Secrets
The GitHub Actions workflow requires these secrets:

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_ACCOUNT_ID

These values must be stored in:
GitHub Repository
   ↓
Settings
   ↓
Secrets and variables
   ↓
Actions
### ⚠️ Never commit AWS credentials directly into the repository.


## 🌍 Application Access
After Terraform deployment, Terraform outputs the ALB DNS names.

Example:
public_alb_dns_name
internal_alb_dns_name

The public ALB is the application entry point.

Example:
http://public-alb-dns-name
The internal ALB is not directly accessible from the internet.
It is used only for communication between the frontend and backend tiers.


## 🔍 Application Request Flow

When a user opens the application:
```
User Browser
     │
     ▼
Public ALB
     │
     ▼
Frontend EC2
     │
     ▼
Nginx
     │
     ├── Static React Files
     │
     └── /api/
            │
            ▼
       Internal ALB
            │
            ▼
       Backend EC2
            │
            ▼
        Node.js
            │
            ▼
        RDS MySQL
```

## 🩺 Health Checks
The Application Load Balancers use target groups to check application health.

### Frontend
ALB
 ↓
Frontend EC2 :80
 ↓
HTTP health check

### Backend
Internal ALB
 ↓
Backend EC2 :4000
 ↓
/transaction
The backend target group uses:

Health Check Path:
/transaction


## 💰 Cost Considerations

This project uses AWS resources that may incur charges, including:
EC2
Application Load Balancer
NAT Gateway
RDS
Elastic IP
ECR
CloudWatch
Other AWS services
For learning purposes, infrastructure should be destroyed when it is no longer required.
terraform destroy


## ⚠️ Security Notes
This repository is intended for learning and demonstration purposes.
The current configuration contains simplified settings suitable for a learning environment.

For production environments, improve the configuration by using:
AWS Secrets Manager
AWS Systems Manager Parameter Store
IAM least-privilege policies
GitHub Actions OIDC
HTTPS/TLS certificates
Route 53
WAF
Private ECR repositories
Database encryption
CloudWatch monitoring and alarms
Auto Scaling
Multi-AZ architecture
Automated backups
Remote Terraform state
Terraform state locking


## 🛠️ Technologies Used
Cloud
AWS
EC2
VPC
ALB
RDS
ECR
IAM
SSM
CloudWatch
Infrastructure
Terraform
Containers
Docker
Dockerfile
Frontend
React
Nginx
Backend
Node.js
Express
Database
MySQL
Amazon RDS
CI/CD
GitHub Actions
Operating System
Ubuntu


## 📚 DevOps Concepts Demonstrated

This project demonstrates practical knowledge of:
Infrastructure as Code
AWS networking
VPC architecture
Public and private subnets
Internet Gateway
NAT Gateway
Route tables
Security groups
EC2
Application Load Balancer
Target groups
Docker
Docker image management
Amazon ECR
IAM
AWS Systems Manager
Nginx reverse proxy
Frontend/backend communication
Backend/database communication
GitHub Actions
CI/CD
Terraform
Automated deployment
Application health checks


## 🎯 Project Goal

The main goal of this project is to understand how a real-world application can be:
Developed
    ↓
Containerized
    ↓
Stored in ECR
    ↓
Infrastructure created using Terraform
    ↓
Deployed to AWS
    ↓
Connected using Load Balancers
    ↓
Connected to RDS
    ↓
Automatically deployed using GitHub Actions


## 🚀 Future Improvements

Possible improvements include:
 HTTPS using AWS Certificate Manager
 Route 53 domain
 Auto Scaling Groups
 CloudWatch dashboards
 CloudWatch alarms
 AWS Secrets Manager
 GitHub Actions OIDC
 Terraform remote backend
 Terraform state locking
 Blue/Green deployment
 Rolling deployments
 WAF
 Multi-AZ RDS
 Automated rollback
 Container vulnerability scanning
 Production-grade monitoring

===================================================================================*
#  Author
## Syed Salman N
DevOps Engineer | AWS | Terraform | Docker | CI/CD
GitHub:
https://github.com/syedSalman23
https://www.linkedin.com/in/syed-salman-n/
===================================================================================*


## ⭐ Project
If you find this project useful for learning AWS, Terraform and DevOps concepts, feel free to explore the repository.
Repository:
https://github.com/syedSalman23/aws-3-tier-architecture-terraform