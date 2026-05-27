# Enterprise AWS Infrastructure & Microservices Deployment Guide

> Production-Ready AWS Architecture Notes for Terraform, Microservices, Networking, Security, Scaling, and Deployment

---

# Table of Contents

1. AWS Fundamentals
2. Networking Fundamentals
3. Security Architecture
4. Compute Services
5. Scaling & Load Balancing
6. DNS & Traffic Management
7. Application Architecture
8. Terraform Architecture
9. Terraform File Structure
10. Terraform Configuration Notes
11. Terraform Deployment Commands
12. AWS CLI Reference
13. Production Best Practices
14. Troubleshooting Guide
15. Disaster Recovery
16. DevOps & Interview Notes
17. Architecture Scenarios
18. Quick Revision Notes

---

# 1. AWS Fundamentals

## What happens if one server crashes?
### Solution
- Auto Scaling Group (ASG)
- Health checks
- Load Balancer reroutes traffic

### Explanation
If one EC2 instance fails:
1. ALB marks instance unhealthy
2. Traffic stops routing to failed instance
3. ASG launches a replacement automatically
4. Users continue using healthy instances

---

## What happens if an entire Availability Zone fails?
### Solution
- Multi-AZ Deployment
- Multi-AZ ASG
- Multi-AZ ALB

### Explanation
AWS spreads infrastructure across multiple Availability Zones.
If one AZ goes down:
- ALB routes traffic to healthy AZ
- ASG launches instances in remaining AZs
- Application remains online

---

## What happens if traffic suddenly becomes 100x?
### Solution
- Auto Scaling
- Load Balancer
- CloudFront
- Caching

### Explanation
Auto Scaling automatically launches additional EC2 instances based on:
- CPU usage
- Request count
- Memory usage
- Custom CloudWatch metrics

---

## What if hackers target your API?
### Solution
- Security Groups
- NACLs
- AWS WAF
- IAM Least Privilege
- MFA
- SCP

### Security Best Practices
1. Least privilege access
2. Use IAM Roles instead of access keys
3. Enable MFA everywhere
4. Use Service Control Policies (SCP)
5. Enable CloudTrail
6. Enable GuardDuty

---

## What if a developer accidentally deletes production?
### Solution
- IAM restrictions
- Terraform state management
- Backups
- Snapshots
- Version control
- Multi-account strategy

---

## What if logs disappear during an incident?
### Solution
- CloudWatch Logs
- Centralized logging
- S3 archival
- VPC Flow Logs
- CloudTrail

---

# EC2 Solution Stack

| Component | Purpose |
|---|---|
| Auto Scaling Group | Automatically replace failed instances |
| Application Load Balancer | Distribute traffic |
| Multi-AZ Deployment | High availability |
| Spot Instances | Cost optimization |

---

# 2. Networking Fundamentals

## Private IP Address Ranges

| Class | CIDR Range |
|---|---|
| Class A | 10.0.0.0 - 10.255.255.255 |
| Class B | 172.16.0.0 - 172.31.255.255 |
| Class C | 192.168.0.0 - 192.168.255.255 |

---

## Network Components

| Component | Meaning |
|---|---|
| NIC | Network Interface Card |
| ENI | Elastic Network Interface |
| ENA | Elastic Network Adapter |
| EFA | Elastic Fabric Adapter |

---

# VPC (Virtual Private Cloud)

A VPC is a logically isolated virtual network in AWS.

## Features
- Custom CIDR ranges
- Public and private subnets
- Route tables
- Security Groups
- NAT Gateway
- Internet Gateway

---

# Subnets

## Public Subnet
- Has route to Internet Gateway
- Used for:
  - Bastion Host
  - Public ALB
  - NAT Gateway

## Private Subnet
- No direct internet access
- Used for:
  - Frontend EC2
  - Backend EC2
  - Database

---

# Route Tables

Route tables determine where traffic goes.

## Public Route Table
```text
0.0.0.0/0 -> Internet Gateway
```

## Private Route Table
```text
0.0.0.0/0 -> NAT Gateway
```

---

# Internet Gateway (IGW)

Provides internet access to public subnets.

---

# NAT Gateway

Allows private subnet instances to access internet without exposing them publicly.

## Example
Private EC2 performing:
- yum update
- apt update
- docker pull
- npm install

---

# VPN Components

| Component | Purpose |
|---|---|
| Customer Gateway | On-premises side |
| Virtual Private Gateway | AWS side |
| VPN Connection | Secure tunnel |
| IPSec Tunnel | Encrypted communication |

---

# Route 53

AWS DNS Service.

## Steps
1. Create Hosted Zone
2. Copy NS records
3. Update GoDaddy nameservers
4. Create A record
5. Create subdomain records

---

# 3. Security Architecture

# Security Groups vs NACL

| Feature | Security Group | NACL |
|---|---|---|
| Type | Stateful | Stateless |
| Level | Instance | Subnet |
| Rules | Allow only | Allow & Deny |
| Return Traffic | Automatically allowed | Must be explicitly allowed |

---

# IAM Policies

## Identity-Based Policy
Attached to:
- Users
- Groups
- Roles

## Resource-Based Policy
Attached directly to resources.

Examples:
- S3 Bucket Policy
- Lambda permissions
- SNS topic policy

---

# S3 Bucket Policy Example

```json
{
  "Version": "18-05-2026",
  "Statement": [
    {
      "Sid": "PublicRead",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::examplebucket/*"
      ]
    }
  ]
}
```

---

# Enterprise Firewalls

| Firewall | Vendor |
|---|---|
| Palo Alto | Palo Alto Networks |
| Fortigate | Fortinet |
| Cisco ASA | Cisco |

---

# AWS Security Best Practices

## 1. Least Privilege
Grant minimum permissions required.

## 2. IAM Roles over Access Keys
Never hardcode credentials.

## 3. MFA Everywhere
Enable MFA for:
- Root account
- IAM users
- Production accounts

## 4. SCP (Service Control Policy)
Restrict actions at AWS Organization level.

---

# CloudTrail

Tracks:
- API calls
- User activity
- Console activity
- Resource changes

## Event Types
- Management Events
- Data Events

---

# 4. Compute Services

# EC2

Elastic Compute Cloud.

## EC2 Use Cases
- Web servers
- Backend APIs
- Docker hosts
- Bastion servers
- Database servers

---

# EC2 Instance Types

| Family | Purpose |
|---|---|
| T | Burstable workloads |
| M | General purpose |
| C | Compute optimized |
| R | Memory optimized |
| I | Storage optimized |
| G | GPU workloads |

---

# AMI (Amazon Machine Image)

AMI contains:
- Operating System
- Packages
- Configurations
- Startup scripts

Example:
```text
ami-07a00cf47dbbc844c
```

---

# EBS

Elastic Block Store.

Persistent storage for EC2.

## Features
- Snapshots
- Backup
- Encryption
- Resize support

---

# User Data

Bootstrap script executed during instance startup.

## Example
```bash
#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo systemctl start docker
```

---

# Launch Templates

Reusable EC2 configuration.

Contains:
- AMI
- Instance type
- Security groups
- User data
- IAM role

---

# 5. Scaling & Load Balancing

# Auto Scaling Group (ASG)

Automatically:
- Launches instances
- Replaces unhealthy instances
- Scales based on demand

## Scaling Types

### Dynamic Scaling
Based on:
- CPU
- Memory
- Requests

### Scheduled Scaling
Scale at fixed times.

### Predictive Scaling
Uses machine learning.

---

# Target Groups

Logical grouping of backend servers.

## Health Checks
Typical health check:
```text
/health
```

---

# Application Load Balancer (ALB)

Layer 7 Load Balancer.

## Features
- Path-based routing
- Host-based routing
- HTTPS support
- WebSockets

---

# ALB Routing Examples

## Path-Based Routing
```text
/users/* -> user-service
/bookings/* -> booking-service
```

## Host-Based Routing
```text
api.example.com
admin.example.com
```

---

# ALB vs NLB

| Feature | ALB | NLB |
|---|---|---|
| Layer | Layer 7 | Layer 4 |
| Protocol | HTTP/HTTPS | TCP/UDP |
| Routing | Advanced | Port based |
| Best For | Microservices | High performance TCP |

---

# Sticky Sessions

Routes same user to same server.

Better alternative:
- Redis
- JWT
- DynamoDB session store

---

# 6. DNS & Traffic Management

# DNS Flow

1. User enters domain
2. Browser checks cache
3. Resolver queries DNS
4. Route 53 returns ALB DNS
5. Browser connects to ALB

---

# Route 53 Routing Policies

| Policy | Purpose |
|---|---|
| Simple | Single endpoint |
| Weighted | Traffic splitting |
| Latency | Lowest latency region |
| Failover | Disaster recovery |
| Geolocation | Country-based routing |

---

# CloudFront

AWS CDN.

## Benefits
- Faster global delivery
- Caching
- DDoS protection
- Reduced backend load

---

# 7. Application Architecture

# 3-Tier Architecture

```text
Internet
   |
Public ALB
   |
Frontend EC2
   |
Internal ALB
   |
Backend EC2
   |
Database
```

---

# Microservices Architecture

## Services
- Frontend Service
- User Service
- Booking Service
- Trade Service
- Portfolio Service

---

# Stateless vs Stateful

| Feature | Stateful | Stateless |
|---|---|---|
| Session Storage | EC2 Memory | External Store |
| Scaling | Hard | Easy |
| Failure Recovery | Poor | Better |

Recommended:
- JWT
- Redis
- External session storage

---

# 8. Terraform Architecture

# Terraform Blocks

## Provider
```hcl
provider "aws" {}
```

## Resource
```hcl
resource "aws_instance" "example" {}
```

## Variable
```hcl
variable "region" {}
```

## Output
```hcl
output "alb_dns" {}
```

## Module
Reusable Terraform code.

## Remote Backend
Stores Terraform state remotely.

---

# Recommended Terraform Folder Structure

```text
terraform/
│
├── providers.tf
├── versions.tf
├── variables.tf
├── terraform.tfvars
├── locals.tf
├── vpc.tf
├── igw.tf
├── subnets.tf
├── nat.tf
├── route_tables.tf
├── security_groups.tf
├── keypair.tf
├── userdata/
│   ├── frontend.sh
│   ├── backend.sh
│   └── bastion.sh
├── launch_templates.tf
├── load_balancers.tf
├── target_groups.tf
├── autoscaling.tf
├── bastion.tf
├── database.tf
├── outputs.tf
└── data.tf
```

---

# Production Architecture

```text
Internet
   |
Frontend ALB (Public)
   |
Frontend ASG (Private)
   |
Internal Backend ALB
   |
Backend ASG (Private)
   |
Database EC2/RDS
```

---

# Multi-AZ Architecture

## Subnet Layout

| Subnet | CIDR | AZ |
|---|---|---|
| Public 1 | 10.0.1.0/24 | AZ1 |
| Public 2 | 10.0.2.0/24 | AZ2 |
| Frontend 1 | 10.0.11.0/24 | AZ1 |
| Frontend 2 | 10.0.12.0/24 | AZ2 |
| Backend 1 | 10.0.13.0/24 | AZ1 |
| Backend 2 | 10.0.14.0/24 | AZ2 |
| DB 1 | 10.0.21.0/24 | AZ1 |
| DB 2 | 10.0.22.0/24 | AZ2 |

---

# Security Group Architecture

## Bastion SG
- Allow SSH from your IP

## Frontend ALB SG
- Allow HTTP/HTTPS from internet

## Frontend SG
- Allow traffic from frontend ALB

## Backend ALB SG
- Allow traffic from frontend SG

## Backend SG
- Allow traffic from backend ALB

## Database SG
- Allow MongoDB/MySQL traffic from backend SG

---

# 9. Terraform Configuration Notes

# Important Fixes

## Problem 1
Missing:
```hcl
subnet_type
```
inside variable definitions.

---

## Problem 2
NAT Gateway indexing issue.

Avoid:
```hcl
aws_nat_gateway.nat[0]
```

Use AZ-specific mapping instead.

---

## Problem 3
Missing components:
- Bastion Host
- Internal ALB
- Target Groups
- Listener Rules
- IAM Roles
- User Data
- Outputs

---

# Recommended Improvements

## Use Secrets Manager
Never hardcode passwords.

---

## Use HTTPS
Add:
- ACM Certificate
- HTTPS listener
- Route 53

---

## Use Amazon ECR
Better than DockerHub for production.

---

## Use RDS Instead of EC2 Database
Production recommendation.

---

# 10. Terraform Deployment Commands

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
```

---

# Destroy Infrastructure

```bash
terraform destroy -auto-approve
```

---

# 11. AWS CLI Reference

# Configure AWS CLI

```bash
aws configure
```

---

# EC2 Commands

## List Instances
```bash
aws ec2 describe-instances
```

## Start Instance
```bash
aws ec2 start-instances --instance-ids i-xxxxx
```

## Stop Instance
```bash
aws ec2 stop-instances --instance-ids i-xxxxx
```

---

# Route 53 Commands

## List Hosted Zones
```bash
aws route53 list-hosted-zones
```

---

# Load Balancer Commands

## Check Target Health
```bash
aws elbv2 describe-target-health --target-group-arn TG_ARN
```

---

# Auto Scaling Commands

## Describe ASGs
```bash
aws autoscaling describe-auto-scaling-groups
```

---

# 12. Production Best Practices

# Security

- Use IAM Roles
- Avoid access keys
- Enable MFA
- Enable CloudTrail
- Enable GuardDuty
- Use HTTPS everywhere
- Use WAF
- Encrypt everything

---

# Monitoring

Use:
- CloudWatch Metrics
- CloudWatch Logs
- VPC Flow Logs
- ALB Access Logs

---

# Cost Optimization

| Service | Optimization |
|---|---|
| EC2 | Right sizing |
| NAT Gateway | Share per AZ |
| EBS | Use gp3 |
| ASG | Scale down automatically |
| Spot Instances | Use for batch jobs |

---

# 13. Troubleshooting Guide

# ALB Health Check Failure

## Causes
- Wrong path
- SG blocking
- App not running

## Fix
```bash
aws elbv2 describe-target-health
```

---

# SSH Issues

## Permission denied
Fix:
```bash
chmod 400 key.pem
```

---

# Docker Not Running

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

---

# User Data Logs

```bash
cat /var/log/cloud-init-output.log
```

---

# NAT Gateway Problems

## Symptoms
- No internet in private subnet

## Check
- Route tables
- NAT Gateway
- IGW

---

# MongoDB Connectivity Issues

## Verify Port
```bash
27017
```

## Check Security Group
Allow:
```text
Backend SG -> MongoDB SG
```

---

# 14. Disaster Recovery

# DR Strategies

| Strategy | Cost | Recovery Speed |
|---|---|---|
| Backup & Restore | Low | Slow |
| Pilot Light | Medium | Faster |
| Warm Standby | Medium | Fast |
| Active-Active | High | Fastest |

---

# Backups

Use:
- EBS Snapshots
- AMI Backups
- S3 Versioning
- RDS Snapshots

---

# 15. DevOps & Interview Notes

# Common Interview Questions

## Difference between ALB and NLB?
ALB:
- Layer 7
- HTTP/HTTPS
- Path-based routing

NLB:
- Layer 4
- TCP/UDP
- Ultra low latency

---

## What is Auto Scaling Group?
Automatically manages EC2 instances.

Features:
- Scaling
- Self healing
- Multi-AZ deployment

---

## What is VPC Peering?
Private connection between VPCs.

---

## Explain NAT Gateway
NAT Gateway allows private EC2 instances to access internet securely.

---

# 16. Architecture Scenarios

# Complete Request Flow

```text
User
  |
Route53
  |
Public ALB
  |
Frontend EC2
  |
Internal ALB
  |
Backend EC2
  |
MongoDB
```

---

# NAT Gateway Traffic Flow

```text
Private EC2
   |
NAT Gateway
   |
Internet Gateway
   |
Internet
```

---

# Defense in Depth

- Internet cannot directly access backend
- Backend cannot directly access frontend
- Database accessible only from backend
- SSH only through bastion host

---

# 17. Quick Revision Notes

# Important AWS Services

| Service | Purpose |
|---|---|
| EC2 | Virtual machine |
| VPC | Private network |
| ALB | HTTP Load Balancer |
| NLB | TCP Load Balancer |
| ASG | Auto Scaling |
| RDS | Managed database |
| S3 | Object storage |
| CloudFront | CDN |
| Route 53 | DNS |
| IAM | Identity management |
| CloudTrail | Audit logs |
| CloudWatch | Monitoring |
| NAT Gateway | Internet for private subnet |
| ACM | SSL Certificates |

---

# Important Ports

| Service | Port |
|---|---|
| HTTP | 80 |
| HTTPS | 443 |
| SSH | 22 |
| MongoDB | 27017 |
| MySQL | 3306 |
| PostgreSQL | 5432 |
| Node.js | 3000 |

---

# High Availability Checklist

- Multi-AZ
- Load Balancer
- Auto Scaling
- Health Checks
- Backups
- Monitoring
- Logging

---

# Security Checklist

- Least privilege IAM
- MFA enabled
- HTTPS enabled
- Private subnets
- Bastion host
- WAF enabled
- CloudTrail enabled
- GuardDuty enabled

---

# Final Summary

This architecture provides:

- High Availability
- Scalability
- Security
- Cost Optimization
- Multi-AZ Redundancy
- Infrastructure as Code
- Production Ready Deployment
- Microservices Architecture
- Automated Recovery
- Monitoring & Logging
- Enterprise Level Networking

---

# End of Notes

