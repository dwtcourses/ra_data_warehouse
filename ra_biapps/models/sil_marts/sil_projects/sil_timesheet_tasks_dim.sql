{% if not var("enable_harvest_projects") or (not var("enable_projects_warehouse")) %}
{{
    config(
        enabled=false
    )
}}
{% else %}
{{
    config(
        unique_key='timesheet_task_pk',
        alias='timesheet_tasks_dim'
    )
}}
{% endif %}

WITH tasks AS
  (
  SELECT *
  FROM   {{ ref('sde_timesheet_tasks_ds') }}
  )
SELECT
   GENERATE_UUID() as timesheet_task_pk,
   t.task_id,
   t.task_name,
   t.task_billable_by_default,
   t.task_default_hourly_rate,
   t.task_created_at,
   t.task_updated_at,
   t.task_is_active
FROM
   tasks t
