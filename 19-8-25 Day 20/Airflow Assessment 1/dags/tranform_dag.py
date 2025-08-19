from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import logging

def transform():
    logging.info("Step 2: Transforming data...")
    data = ["apple", "banana", "cherry"]
    transformed = [item.upper() for item in data]
    logging.info(f"Transformed data: {transformed}")
    return transformed

with DAG(
    dag_id="transform_dag",
    start_date=datetime(2025, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["etl", "transform"],
) as dag:

    transform_task = PythonOperator(
        task_id="transform_task",
        python_callable=transform,
    )
