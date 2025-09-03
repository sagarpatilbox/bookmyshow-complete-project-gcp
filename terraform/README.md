# BookMyShow GCP Terraform Project

This project provisions BookMyShow infra on GCP with Terraform.

## Steps

### Task 1 – Enable APIs
```
gcloud services enable compute.googleapis.com run.googleapis.com artifactregistry.googleapis.com redis.googleapis.com sqladmin.googleapis.com vpcaccess.googleapis.com iam.googleapis.com
```

### Task 2 – Clone Repo & Init Terraform
```
git clone <repo-url>
cd bookmyshow-gcp
gcloud iam service-accounts create terraform-sa --display-name="Terraform Service Account"
gcloud projects add-iam-policy-binding bookmyshow-gcp --member="serviceAccount:terraform-sa@bookmyshow-gcp.iam.gserviceaccount.com" --role="roles/editor"
gcloud projects add-iam-policy-binding bookmyshow-gcp --member="serviceAccount:terraform-sa@bookmyshow-gcp.iam.gserviceaccount.com" --role="roles/storage.admin"
gcloud iam service-accounts keys create key.json --iam-account=terraform-sa@bookmyshow-gcp.iam.gserviceaccount.com
export GOOGLE_APPLICATION_CREDENTIALS="./key.json"
gsutil mb -p bookmyshow-gcp -c STANDARD -l asia-south1 -b on gs://bookmyshow-terraform-state/
terraform init
```

### Task 3 – Networking
Provisions VPC + Subnet (`network.tf`)
```
terraform apply -auto-approve
```

### Task 4 – Core Infra
Provisions Artifact Registry, GCS Bucket, Cloud SQL, Redis, VPC Connector, Cloud Run
```
terraform apply -auto-approve
```

### Task 5 – VM Scaling (MIG + LB)
Provisions MIG, Autoscaler, Health Check, HTTPS Load Balancer
```
terraform apply -auto-approve
```

### Task 6 – Outputs & DNS
```
terraform output
```
Map Load Balancer IP to your domain in Cloud DNS or registrar.
