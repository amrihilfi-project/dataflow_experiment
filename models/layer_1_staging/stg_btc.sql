{{
    config(
        materialized='incremental',
        incremental_strategy="merge",
        unique_key="HASH_KEY"
    )
}}

SELECT *
FROM {{ source('src_btc', 'btc') }}
WHERE true
{% if is_incremental() %}

AND block_timestamp >= (SELECT MAX(block_timestamp) FROM {{ this }} )

{% endif %}
