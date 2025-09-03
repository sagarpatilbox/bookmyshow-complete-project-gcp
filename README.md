# BookMyShow Scalability Project — Complete (GCP + Terraform + CI/CD) 

This repository is a complete, step-by-step project for simulating and solving scalability issues like those experienced during large ticket sales (e.g., BookMyShow / Coldplay ticket release).

**What's included**
- Minimal Node.js prototype (frontend + API)
- Dockerfile and Cloud Build config
- Locust load-testing scripts
- Complete Terraform infra for Cloud Run, Cloud SQL, Memorystore, Artifact Registry, MIG+LB, Cloud Armor, Cloud CDN, and CI/CD triggers
- Diagrams (architecture + CI/CD flow)
- `tasks.md` step-by-step task checklist with commands & Terraform snippets
- `final_report_template.md` for submission-ready report
**
---

## Quick start (short)

Prerequisites (local machine):
- gcloud CLI installed and authenticated (`gcloud auth login`)
- Terraform v1.3+ installed
- Docker installed (for local build tests)
- A Google Cloud project with billing enabled

1. Clone this repo locally
2. Update `terraform/terraform.tfvars.example` values and save as `terraform/terraform.tfvars`
3. Create a GCS bucket for Terraform state (Task 1 & 2)
4. Build & push the container via Cloud Build or locally
   - `gcloud builds submit --config=cloudbuild.yaml --substitutions=_IMAGE=REGION-docker.pkg.dev/PROJECT_ID/bookmyshow/app:latest,_REGION=REGION`
5. `cd terraform` → `terraform init` → `terraform apply -auto-approve`
6. Follow output: Cloud Run URL, Load Balancer IP, Cloud SQL connection

---
See `tasks.md` for the full, step-by-step instructions (each task expanded with code snippets and exact commands).
