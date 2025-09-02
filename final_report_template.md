# Final Project Report — BookMyShow Scalability POC (Template)

## 1. Executive Summary
- Objective: Simulate ticketing high-traffic scenario and propose GCP-based scalable solution.
- Short summary of interventions and results.

## 2. Project Scope & Assumptions
- POC on a new GCP test project.
- Synthetic/dummy event data.

## 3. Architecture Diagram
- Insert `diagrams/architecture.png`

## 4. Implementation Details
- Infra provisioned with Terraform. List of components (Cloud Run, MIG+LB, Cloud SQL, Redis, Artifact Registry, Cloud Build, Cloud Storage, Cloud CDN, Cloud Armor)
- Include `terraform` folder structure and important files.

## 5. Load Testing Methodology
- Tool used: Locust
- Test scenarios (concurrent users, ramp-up, test duration)
- Baseline vs optimized runs

## 6. Results & Analysis
- Request latency charts
- Instance scale events
- DB load & replica lag
- Cache hit ratio

## 7. Resilience Tests
- Chaos test steps, observations, failover time.

## 8. Cost Analysis
- Approx costs during tests
- Recommendations to reduce costs (Cloud Run for spiky, preemptible for workers, committed discounts)

## 9. Monitoring & Maintenance
- Alerts configured and ownership
- Periodic audit cadence

## 10. Conclusion & Future Work
- Suggest Cloud Spanner for multi-region at scale, GKE auto-scaling, etc.

## Appendix
- Commands used, TF outputs, screenshot list
