"""
Módulo de ETL (Extração, Transformação e Carga) - Projeto Marketplace Analytics
Objetivo: Extrair dados do PostgreSQL, realizar tratamentos de tipos e cálculos financeiros, 
e exportar os resultados monitorando via logs.
Autor: Bruno Lima
"""
import pandas as pd
import psycopg2
import logging
import sys

# Configuração do Logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    handlers=[
        logging.FileHandler("pipeline.log"),
        logging.StreamHandler()
    ]
)

DB_CONFIG = {
    "user": "postgres",
    "password": "sua_senha",
    "host": "localhost",
    "port": "5432",
    "dbname": "Projetos"
}

def extract_from_db(query):
    """Extrai dados do banco e retorna DataFrame"""
    logging.info("Iniciando extração de dados")

    try:
        conn = psycopg2.connect(
            **DB_CONFIG,
            options="-c search_path=marketplace"
        )

        cursor = conn.cursor()
        cursor.execute(query)
        colunas = [desc[0] for desc in cursor.description]
        rows = cursor.fetchall()
        conn.close()

        df = pd.DataFrame(rows, columns=colunas)

        logging.info(f"Extração concluída. Registros carregados: {len(df)}")
        return df

    except Exception as e:
        logging.error(f"Erro na extração: {e}")
        sys.exit(1)

def transform_data(df):
    """Aplica tratamentos simples nos dados antes da exportação"""
    logging.info("Iniciando transformação dos dados")

    if "data_pedido" in df.columns:
        df["data_pedido"] = pd.to_datetime(df["data_pedido"])

    if "faturamento_bruto" in df.columns and "taxa_comissao" in df.columns:
        df["comissao_calculada"] = df["faturamento_bruto"] * (df["taxa_comissao"] / 100)

    colunas_monetarias = [
        "faturamento_bruto",
        "receita_marketplace",
        "repasse_vendedor",
        "ticket_medio_vendedor",
        "comissao_calculada"
    ]

    for col in colunas_monetarias:
        if col in df.columns:
            df[col] = df[col].round(2)

    logging.info("Transformação concluída")
    return df

if __name__ == "__main__":
    logging.info("Pipeline de dados iniciado")
    query = "SELECT * FROM marketplace.view_performance_consolidada;"
    df = extract_from_db(query)

    if not df.empty:
        df = transform_data(df)
        print("\nPreview dos dados:")
        print(df.head())
        df.to_csv("dados_performance_vendedores.csv", index=False, encoding="utf-8-sig")
        logging.info("Dados salvos em CSV")
    else:
        logging.warning("Nenhum dado retornado")
        sys.exit(1)

    logging.info("Pipeline finalizado")
