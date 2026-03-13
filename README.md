# Dataflow Experiment: Modern Data Stack (MDS) Lab

A professional-grade implementation of a robust data engineering pipeline. This project demonstrates best practices in data modeling, code quality automation, and proactive data observability using a dbt-centric architecture.



## 🛠 Tech Stack
* **Data Warehouse:** [Snowflake](https://www.snowflake.com/)
* **Transformation:** [dbt (data build tool)](https://www.getdbt.com/)
* **Environment Management:** Pipenv (Python 3.11)
* **Linting & Formatting:** [SQLFluff](https://docs.sqlfluff.com/)
* **Data Observability:** [Elementary Data](https://www.elementary-data.com/)

## 🏗 Project Architecture
The environment is structured to isolate data transformations from operational metadata to ensure warehouse cleanliness:

* **DATAFLOW_DEV**: Primary development database for building and testing dbt models.
* **DBT_UTIL**: A dedicated utility database housing the `ELEMENTARY` schema. This stores all test results, anomaly detection logs, and dbt artifacts, keeping them separate from core data layers.

## 🚀 Getting Started

### 1. Environment Setup
Clone the repository and install the Python environment:
```bash
pipenv install
