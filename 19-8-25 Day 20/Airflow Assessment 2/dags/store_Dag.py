from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import logging, json

def store_result():
    result = {"status": "PASS", "details": {"id": 1, "value": 75}}
    with open("/tmp/audit_result.json", "w") as f:
        json.dump(result, f)
    logging.info("Stored result in /tmp/audit_result.json")

with DAG(
    dag_id="store_dag",
    start_date=datetime(2025, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["audit", "store"],
) as dag:

    store_task = PythonOperator(
        task_id="store_result",
        python_callable=store_result,
    )
