from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import logging, random

def pull_data():
    logging.info("Pulling data from external API simulation...")
    record = {"id": 1, "value": random.randint(10, 100), "timestamp": "2025-08-19"}
    logging.info(f"Pulled record: {record}")
    return record

with DAG(
    dag_id="pull_dag",
    start_date=datetime(2025, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["audit", "pull"],
) as dag:

    pull_data_task = PythonOperator(
        task_id="pull_data",
        python_callable=pull_data,
    )
