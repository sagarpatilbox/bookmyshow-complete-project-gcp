# Tasks (1–8) — Step-by-step implementation & code snippets

This file contains actionable steps for each Task in the project. Follow them in order.

---
## Task 1 — GCP Project Setup (create project, enable APIs, service account)

1. Create a project (example):
   ```bash
   gcloud projects create my-bms-project --set-as-default --name="BookMyShow-POC"
   gcloud config set project my-bms-project
   ```
2. Link billing (replace with your account ID):
   ```bash
   gcloud beta billing projects link my-bms-project --billing-account=YOUR_BILLING_ID
   ```
3. Enable required APIs:
   ```bash
   gcloud services enable compute.googleapis.com run.googleapis.com artifactregistry.googleapis.com \
     cloudbuild.googleapis.com sqladmin.googleapis.com redis.googleapis.com vpcaccess.googleapis.com \
     monitoring.googleapis.com logging.googleapis.com
   ```
4. Create a Terraform service account and grant roles (example: minimal recommended roles vary by infra):
   ```bash
   gcloud iam service-accounts create terraform-sa --display-name="Terraform SA"
   gcloud projects add-iam-policy-binding my-bms-project --member="serviceAccount:terraform-sa@my-bms-project.iam.gserviceaccount.com" --role="roles/editor"
   gcloud iam service-accounts keys create ~/terraform-sa-key.json --iam-account=terraform-sa@my-bms-project.iam.gserviceaccount.com
   export GOOGLE_APPLICATION_CREDENTIALS=~/terraform-sa-key.json
   ```

---
## Task 2 — Terraform backend & state
1. Create a GCS bucket for Terraform state (unique name):
   ```bash
   gsutil mb -l us-central1 gs://my-bms-terraform-state-<UNIQUE>/
   gsutil versioning set on gs://my-bms-terraform-state-<UNIQUE>/
   ```
2. Edit `terraform/versions.tf` and set backend `gcs` block (or follow the example in `terraform/`).
   3. Initialize Terraform and migrate state (if moving from local):
   ```bash
   cd terraform
   terraform init -migrate-state
   ```

---
## Task 3 — Core Infra (Artifact Registry, Cloud SQL, Redis, Cloud Run)
1. Edit `terraform/terraform.tfvars` (copy from .example) with your `project_id`, `region`, `app_image` and `db_password`.
2. Build & push container (via Cloud Build config in repo):
   ```bash
   gcloud builds submit --config=../cloudbuild.yaml --substitutions=_IMAGE=${REGION}-docker.pkg.dev/${PROJECT_ID}/bookmyshow/app:latest,_REGION=${REGION}
   ```
3. Apply Terraform resources (Cloud Run path):
   ```bash
   terraform apply -target=module.core -auto-approve
   ```
   (the repo is modular; or run `terraform apply` for all infra)

---
## Task 4 — Managed Instance Group (MIG) + Autoscaling
1. The MIG + LB comes as `terraform/mig-lb.tf`. Example CLI if you prefer manual steps:
   ```bash
   # instance template
   gcloud compute instance-templates create bms-template --image-family=cos-stable --image-project=cos-cloud --metadata=startup-script='docker run -d -p 8080:8080 IMAGE_URL'

   # create managed instance group
   gcloud compute instance-groups managed create bms-mig --base-instance-name=bms --size=2 --template=bms-template --zone=us-central1-a

   # set autoscaler
   gcloud compute instance-groups managed set-autoscaling bms-mig --zone=us-central1-a --min-num-replicas=2 --max-num-replicas=10 --target-cpu-utilization=0.6
   ```

---
## Task 5 — HTTPS Load Balancer + CDN + SSL + Cloud Armor
- Terraform files create a global HTTPS load balancer connected to the MIG backend and a backend bucket for static assets with CDN enabled, plus a Google-managed SSL cert and a Cloud Armor security policy.
- After apply, reserve DNS A/AAAA records pointing to the forwarding rule IP and validate SSL issuance.

---
## Task 6 — CI/CD (Cloud Build) and automated deploy
1. `cloudbuild.yaml` present at repo root builds, pushes, and deploys to Cloud Run. Cloud Build trigger defined in Terraform (`terraform/cicd.tf`).
2. Configure GitHub connection in Cloud Build and update `terraform/cicd.tf` variables for repo owner/name.

---
## Task 7 — Monitoring, Logging & Alerts
1. Terraform includes `google_monitoring_alert_policy` examples under `terraform/` — customize thresholds per test results.
2. Create dashboards in Cloud Console to show request latency, DB CPU, Redis metrics, MIG instance counts, and LB request counts.

---
## Task 8 — Testing & Validation (Load testing + Chaos)
1. Locust script included at `app/locust/locustfile.py`.
Run from a machine with enough resources (or use multiple GCE workers):
```bash
pip install locust
locust -f app/locust/locustfile.py --host=https://<CLOUD_RUN_URL_OR_LB_IP>
```
2. Gradually increase users and monitor Cloud Monitoring dashboards.
3. Simple chaos tests (manual): remove instances from MIG or temporarily set MIG size lower and observe failover.

---
## Screenshots & Submission checklist
Take screenshots of the following and include in final report:
- Artifact Registry repository with image
- Cloud Run service page showing revisions
- Managed Instance Group page (instances & autoscaler)
- Cloud SQL instance page (replicas & backups)
- Cloud Storage bucket with static assets
- Global Load Balancer frontend IP and SSL cert
- Cloud Build successful run logs
- Locust test result graphs (or CSV)
- Cloud Monitoring dashboard with key metrics

---
## Cleanup
When finished, run:
```bash
cd terraform
terraform destroy -auto-approve
```
And delete the GCP project if you wish to stop all billing:
```bash
gcloud projects delete my-bms-project
```
