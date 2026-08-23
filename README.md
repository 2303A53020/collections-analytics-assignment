# Enterprise Collections Analytics & Forensics Engine

## Overview
This repository contains the forensic audit, counterfactual evaluation, statistical bias analysis, and production pipeline architecture for the enterprise debt collection ecosystem.

## Key Executive Audit Findings
1. **Reported 11% Performance Lift is False:** Over the 7-month evaluation period (Jan–Jul 2026), actual clean recoveries contracted by **-1.27%**.
2. **Systemic Overreporting:** Gateway retries generated 2,530 duplicate payment references, inflating reported cash by **₹18.58 Cr (+16.8%)**.
3. **Strategic Capital Allocation Recommendation:** Deploy **₹10 Cr into Option 3 (AI Voice Automation)** targeting the 1–30 DPD cohort. Expected yield: **₹27.40 Cr incremental recovery (+174% Net ROI, 5.4-month payback)**.

## Repository Structure
* `executive_memo.md`: 2-Page C-Suite decision document.
* `data_quality_report.md`: Forensic audit & data cleaning specifications.
* `submission_repository.sql`: Production SQL models for staging, golden marts, and metric definitions.
* `analysis_notebook.py`: Python workflow covering data forensics, Difference-in-Differences (DiD), and propensity matching.
