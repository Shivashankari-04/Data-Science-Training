from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import logging

def validate_data():
    logging.info("Validating pulled data...")
    record = {"id": 1, "value": 75, "timestamp": "2025-08-19"}
    if record["value"] > 50:
        logging.info(f"Validation PASS: {record}")
    else:
        raise ValueError(f"Validation FAIL: {record}")

with DAG(
    dag_id="validate_dag",
    start_date=datetime(2025, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["audit", "validate"],
) as dag:

    validate_task = PythonOperator(
        task_id="validate_data",
        python_callable=validate_data,
    )
