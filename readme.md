# Socks Shop Microservices Application Deployment

 ## Table of Contents

### Overview
    - Project Structure
    - Prerequisites
    - Infrastructure Setup
        Provisioning the Kubernetes Cluster
        Deploying the Socks Shop Application
    - Monitoring and Alerts
        Prometheus Setup
        Grafana Setup
        Logging
    - Alertmanager Setup
    - Configure HTTPS with Lets Encrypt
    - Secure the Infrastructure
    - Cleaning Up

## Overview

This project aims to deploy the Socks Shop microservices application on a Kubernetes cluster using an Infrastructure as Code (IaaC) approach. The deployment emphasizes automation, monitoring, alerting, logging, and HTTPS security, ensuring a reproducible and maintainable setup.

### Project Structure

Capstone/
│
├── manifest/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
├── manifest-alert/
│   ├── alertmanager-configmap.yaml
│   ├── alertmanager-dep.yaml
│   └──alertmanager-svc.yaml
├── manifest-monitoring/
│   ├── prometheus.yaml
│   ├── grafana.yaml
│   ├── kube-state-metrics.yaml
│   ├── 00-monitoring-ns.yaml
│   ├── 01-prometheus-sa.yaml
│   ├── 02-prometheus-cr.yaml
│   ├── 03-prometheus-crb.yaml
│   ├── 04-prometheus-configmap.yaml
│   ├── 05-prometheus-alertrules.yaml
│   ├── 06-prometheus-dep.yaml
│   ├── 07-prometheus-svc.yaml
│   ├── 08-prometheus-exporter-disk-usage-ds.yaml
│   ├── 10-kube-state-sa.yaml
│   ├── 11-kube-state-cr.yaml
│   ├── 12-kube-state-crb.yaml
│   ├── 13-kube-state-dep.yaml
│   ├── 14-kube-state-svc.yaml
│   ├── 20-grafana-configmap.yaml
│   ├── 21-grafana-dep.yaml
│   ├── 22-grafana-svc.yaml
│   ├── 23-grafana-import-dash-batch.yaml
│   ├── 24-prometheus-node-exporter-sa.yaml
│   ├── 25-prometheus-node-exporter-daemonset.yaml
│   ├── 26-prometheus-node-exporter-svc.yaml
│   ├── alert-manager-ingress.yaml
│   ├── busybox.yaml
│   ├── clusterissuer.yaml
│   ├── grafana-ingress.yaml
│   ├── kube-state-metrics-sa.yaml
│   ├── prometheus-alertmanager-pvs.yaml
│   └──prometheus-ingress.yaml
├── sock-shop/
│   ├──Chart.yaml
│   ├──certificate.yaml
│   ├──clusterissuer.yaml
│   ├──ingress.yaml
│   ├──sock-shop-0.1.0.tgz
│   ├──values.yaml
│   ├──allow-http-and-db.yaml
│   ├──charts
│   ├──deployment.yaml
│   └── networkpolicy.yaml  templates
├── terraform/
│   ├── main.tf
│   └── backend.tf


### Prerequisites
#### - Helm: Installed for managing Kubernetes packages.
#### - Kubernetes Cluster: Ensure you have a Kubernetes cluster running. You can use a managed service like AWS EKS.
#### - Terraform: Ensure Terraform is installed and configured.
#### - AWS CLI: AWS CLI should be installed and configured with proper credentials.
#### -kubectl: The Kubernetes CLI tool should be installed.

# Infrastructure Setup
## Step-by-Step Deployment Guide

### 1. Initialize Terraform:
`cd Capstone/terraform`
`terraform init`

### 2. Apply the Terraform Configuration:
`terraform apply -auto-approve`

#### This will provision:
### - A VPC with public and private subnets.
### - An EKS cluster with managed node groups.

### 3. Update kubeconfig:
`aws eks --region eu-west-2 update-kubeconfig --name sock-shop`

# Deploying the Socks Shop Application
### 1. Navigate to the Manifest Directory:
`cd ../manifest`

### 2. Apply Kubernetes Manifests:
- `kubectl apply -f deployment.yaml`
- `kubectl apply -f service.yaml`

### 3. Set Up Ingress:
- `kubectl apply -f ingress.yaml`

### 4. Verify the Deployment:
- `kubectl get pods -n sock-shop`
- `kubectl get svc -n sock-shop`
- `kubectl get ingress -n sock-shop`


# Monitoring and Alerts
## Prometheus Setup

### 1. Navigate to the Monitoring Directory:
`cd ../manifest-monitoring`

### 2. Create the Monitoring Namespace:
`kubectl apply -f 00-monitoring-ns.yaml`

### 2. Deploy Prometheus:
- `kubectl apply -f 01-prometheus-sa.yaml`
- `kubectl apply -f 02-prometheus-cr.yaml`
- `kubectl apply -f 03-prometheus-crb.yaml`
- `kubectl apply -f 04-prometheus-configmap.yaml`
- `kubectl apply -f 06-prometheus-dep.yaml`
- `kubectl apply -f 07-prometheus-svc.yaml`

### 3. Verify Prometheus Deployment:

- `kubectl get pods -n monitoring`
- `kubectl get svc -n monitoring`


# Grafana Setup
### 1. Deploy Grafana:
- `kubectl apply -f 20-grafana-configmap.yaml`
- `kubectl apply -f 21-grafana-dep.yaml`
- `kubectl apply -f 22-grafana-svc.yaml`

### 2. Access Grafana:
#### Retrieve the Grafana service IP and access it via your browser.

# Logging

### 1. Set up Prometheus Logging:
#### Ensure Prometheus is configured to collect and store logs. Use the prometheus.yaml configuration file for setup.

### 2. View Logs:
#### Logs can be accessed through Prometheus or Grafana dashboards.

# Alertmanager Setup

### 1. Deploy Alertmanager:
- `kubectl apply -f ../manifest-alert/alertmanager-configmap.yaml`
- `kubectl apply -f ../manifest-alert/alertmanager-dep.yaml`
- `kubectl apply -f ../manifest-alert/alertmanager-svc.yaml`


### 2. Verify Alertmanager Deployment:
`kubectl get pods -n monitoring`


# Configure HTTPS with Lets Encrypt
#### Navigate to the Certificate Configuration Directory:
`cd ../sock-shop`

### 1. Install Cert-Manager:
`kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.8.0/cert-manager.yaml`

### 2. Deploy Let's Encrypt Certificate:
- `kubectl apply -f clusterissuer.yaml`
- `kubectl apply -f certificate.yaml`

### 3. Set Up Ingress for HTTPS:
`kubectl apply -f ingress.yaml`

#### Ensure the ingress manifest is configured for Let's Encrypt.

### 3.  Verify HTTPS:
#### Access the application through the HTTPS endpoint provided by Let's Encrypt.

# Secure the Infrastructure
#### Deploy Network Policies:
- `kubectl apply -f allow-http-and-db.yaml`
- `kubectl apply -f networkpolicy.yaml`

# Accessing the Application
- ### Grafana: Access via the Grafana Ingress URL (e.g., https://grafana.www.techniche.com.ng).
- ### Socks Shop: Access the Socks Shop application through the Ingress URL defined in your ingress.yaml.

# Cleaning Up
#### Destroy the Infrastructure:
- `cd ../terraform`
- `terraform destroy -auto-approve`

