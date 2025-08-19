from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

with DAG(
    dag_id="load_dag",
    start_date=datetime(2025, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["etl", "load"],
) as dag:

    load_task = BashOperator(
        task_id="load_task",
        bash_command="echo 'Step 3: Loading data into system... Data: APPLE, BANANA, CHERRY'",
    )
