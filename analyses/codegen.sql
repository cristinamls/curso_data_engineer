{{
    codegen.generate_model_yaml(
        model_names=[
            "stg_sql_server_dbo__orders",
            "stg_sql_server_dbo__products",
            "stg_sql_server_dbo__promos",
        ]
    )
}}

{{
    codegen.generate_model_yaml(
        model_names=[
            "stg_google_sheets__budget",
        ]
    )
}}
