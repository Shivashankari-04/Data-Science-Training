from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

with DAG(
    dag_id="final_dag",
    start_date=datetime(2025, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["audit", "final"],
) as dag:

    final_task = BashOperator(
        task_id="final_status",
        bash_command="echo 'Audit completed. Check logs and /tmp/audit_result.json for details.'",
    )
