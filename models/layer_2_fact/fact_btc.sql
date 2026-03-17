{{
    config(
        materialized='incremental',
        incremental_strategy="append"
    )
}}

SELECT 
    sb.hash_key,
    sb.block_number,
    sb.block_timestamp,
    sb.is_coinbase,
    f.value:address::STRING AS address,
    f.value:value::FLOAT AS value
FROM {{ ref('stg_btc') }} AS sb,
    LATERAL FLATTEN(input => outputs) AS f
WHERE
    f.value:address IS NOT NULL
    {% if is_incremental() %}

        AND sb.block_timestamp >= (SELECT MAX(sb.block_timestamp) FROM {{ this }} )

    {% endif %}
