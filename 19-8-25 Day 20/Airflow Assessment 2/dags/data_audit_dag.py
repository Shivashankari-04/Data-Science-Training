from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from datetime import datetime
import logging, random, json

# Task 1: Pull
def pull_data():
    record = {"id": 1, "value": random.randint(10, 100), "timestamp": "2025-08-19"}
    logging.info(f"Pulled record: {record}")
    return record

# Task 2: Validate
def validate_data(**context):
    record = context['ti'].xcom_pull(task_ids='pull_data')
    if record["value"] > 50:
        logging.info(f"Validation PASS: {record}")
        return {"status": "PASS", "details": record}
    else:
        raise ValueError(f"Validation FAIL: {record}")

# Task 3: Store
def store_result(**context):
    result = context['ti'].xcom_pull(task_ids='validate_data')
    with open("/tmp/audit_result.json", "w") as f:
        json.dump(result, f)
    logging.info("Stored result at /tmp/audit_result.json")

with DAG(
    dag_id="data_audit_dag",
    start_date=datetime(2025, 1, 1),
    schedule_interval="@hourly",
    catchup=False,
    tags=["audit", "chained"],
) as dag:

    pull_task = PythonOperator(
        task_id="pull_data",
        python_callable=pull_data,
    )

    validate_task = PythonOperator(
        task_id="validate_data",
        python_callable=validate_data,
        provide_context=True,
    )

    store_task = PythonOperator(
        task_id="store_result",
        python_callable=store_result,
        provide_context=True,
    )

    final_task = BashOperator(
        task_id="final_status",
        bash_command="echo 'Audit flow completed ✅'",
    )

    pull_task >> validate_task >> store_task >> final_task
