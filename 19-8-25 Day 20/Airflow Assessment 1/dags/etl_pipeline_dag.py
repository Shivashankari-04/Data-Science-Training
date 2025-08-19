from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from datetime import datetime
import logging

# Task 1: Extract
def extract():
    logging.info("Step 1: Extracting data...")
    data = ["apple", "banana", "cherry"]
    logging.info(f"Extracted data: {data}")
    return data

# Task 2: Transform
def transform():
    logging.info("Step 2: Transforming data...")
    data = ["apple", "banana", "cherry"]
    transformed = [item.upper() for item in data]
    logging.info(f"Transformed data: {transformed}")
    return transformed


with DAG(
    dag_id="etl_pipeline_dag",
    start_date=datetime(2025, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["etl", "chained"],
) as dag:

    extract_task = PythonOperator(
        task_id="extract_task",
        python_callable=extract,
    )

    transform_task = PythonOperator(
        task_id="transform_task",
        python_callable=transform,
    )

    load_task = BashOperator(
        task_id="load_task",
        bash_command="echo 'Step 3: Loading data into system... Data: APPLE, BANANA, CHERRY'",
    )

    # chaining
    extract_task >> transform_task >> load_task
