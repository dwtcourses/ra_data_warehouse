{% if not var("enable_hubspot_crm") %}
{{
    config(
        enabled=false
    )
}}
{% endif %}

with deal_pipelines as (

    select * from {{ source('hubspot_crm', 'deal_pipelines') }}

),

deal_stage_with_max as (

    select
      *,
      max(_sdc_batched_at) over (partition by pipelineid order by _sdc_batched_at range between unbounded preceding and unbounded following) as max_sdc_batched_at

    from deal_pipelines

),

latest_version as (

    select * from deal_stage_with_max
    where _sdc_batched_at = max_sdc_batched_at

),

new_deal as (

    select
      pipelineid,
      stageid,
      probability,
      closedwon,
      stages.label as stage_label,
      stages.displayorder as stage_displayorder,
      concat (cast( pipelineid as string), cast (stageid as string)) as pk


    from latest_version,
    unnest (stages) stages

)

select * from new_deal
