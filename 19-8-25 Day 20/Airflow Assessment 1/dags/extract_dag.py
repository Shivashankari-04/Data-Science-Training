from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import logging

def extract():
    logging.info("Step 1: Extracting data...")
    data = ["apple", "banana", "cherry"]
    logging.info(f"Extracted data: {data}")
    return data

with DAG(
    dag_id="extract_dag",
    start_date=datetime(2025, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["etl", "extract"],
) as dag:

    extract_task = PythonOperator(
        task_id="extract_task",
        python_callable=extract,
    )
