{% macro drop_all_objects(database_name=target.database, schema_name=target.schema) %}

    {# Safety Guard: Check if the database name ends with _DEV #}
    {% if not database_name.upper().endswith('_DEV') %}
        {% set error_msg %}
            [SAFETY ERROR]: Macro 'drop_all_objects' is restricted to databases ending in '_DEV'. 
            You tried to run it against: '{{ database_name }}'.
        {% endset %}
        {{ exceptions.raise_database_error(error_msg) }}
    {% endif %}

    {% set find_objects_query %}
        SELECT 
            CASE 
                WHEN table_type = 'BASE TABLE' THEN 'TABLE'
                ELSE table_type 
            END as clean_type,
            table_catalog || '.' || table_schema || '.' || table_name as full_name
        FROM {{ database_name }}.INFORMATION_SCHEMA.TABLES 
        WHERE table_schema = '{{ schema_name | upper }}'
        AND table_type IN ('BASE TABLE', 'VIEW')
    {% endset %}

    {% set results = run_query(find_objects_query) %}

    {% if execute %}
        {% if results.rows | length > 0 %}
            {{ log("Safety check passed. Database '" ~ database_name ~ "' ends in _DEV.", info=True) }}
            {% for row in results.rows %}
                {% set drop_cmd = "DROP " ~ row[0] ~ " " ~ row[1] ~ ";" %}
                {{ log("Executing: " ~ drop_cmd, info=True) }}
                {% do run_query(drop_cmd) %}
            {% endfor %}
            {{ log("Successfully cleared " ~ database_name ~ "." ~ schema_name, info=True) }}
        {% else %}
            {{ log("Nothing found to drop in " ~ database_name ~ "." ~ schema_name, info=True) }}
        {% endif %}
    {% endif %}

{% endmacro %}