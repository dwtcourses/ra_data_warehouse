{% if not var("enable_projects_warehouse") %}
{{
    config(
        enabled=false
    )
}}
{% else %}
{{
    config(
        unique_key='user_pk',
        alias='users_fact'
    )
}}
{% endif %}

WITH users AS
  (
  SELECT * from {{ ref('sde_users_ds') }}
)
select GENERATE_UUID() as user_pk,
       u.*
from users u
