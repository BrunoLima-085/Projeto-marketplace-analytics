"""
Módulo de ETL (Extração, Transformação e Carga) - Projeto Marketplace Analytics
Objetivo: Extrair dados do PostgreSQL, realizar tratamentos de tipos e cálculos financeiros, 
e exportar os resultados monitorando via logs.
Autor: Bruno Lima
"""
import pandas as pd
from sqlalchemy import create_engine
import logging

#Configuração do Logging

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
    "database": "marketplace_db"
}

def get_engine():
    """Cria e retorna um engine de conexão com o banco PostgreSQL."""
    url = (
        f"postgresql://{DB_CONFIG['user']}:{DB_CONFIG['password']}"
        f"@{DB_CONFIG['host']}:{DB_CONFIG['port']}/{DB_CONFIG['database']}"
    )
    return create_engine(url)

def extract_from_db(query):
    """Extrai dados do banco e retorna DataFrame"""

    engine = get_engine()
    logging.info("Iniciando extração de dados")

    try:
        with engine.connect() as connection:
            df = pd.read_sql(query, connection)
        
        logging.info(f"Extração concluída. Registros carregados: {len(df)}")
        return df
    
    except Exception as e:
        logging.error(f"Erro na extração: {e}")
        return pd.DataFrame()

def transform_data(df):
    """Aplica tratamentos simples nos dados antes da exportação"""

    logging.info("Iniciando transformação dos dados")

    # Converter a coluna de data para formato datetime (caso exista no DataFrame)
    if "data_pedido" in df.columns:
        df["data_pedido"] = pd.to_datetime(df["data_pedido"])

    # Calcular a comissão com base no faturamento bruto e na taxa de comissão
    if "faturamento_bruto" in df.columns and "taxa_comissao" in df.columns:
        df["comissao_calculada"] = df["faturamento_bruto"] * (df["taxa_comissao"] / 100)

    # Definir colunas que representam valores monetários
    colunas_monetarias = [
        "faturamento_bruto",
        "receita_marketplace",
        "repasse_vendedor",
        "ticket_medio_vendedor",
        "comissao_calculada"
    ]

    # Padronizar valores monetários para duas casas decimais
    for col in colunas_monetarias:
        if col in df.columns:
            df[col] = df[col].round(2)

    # Registrar no log a conclusão da etapa de transformação
    logging.info("Transformação concluída")
    return df

if __name__ == "__main__":
    logging.info("Pipeline de dados iniciado")
    query = "SELECT * FROM view_performance_consolidada;"
    df = extract_from_db(query)

    if not df.empty:
        # Aplicando transformação
        df = transform_data(df)
        print("\nPreview dos dados:")
        print(df.head())
        df.to_csv("dados_performance_vendedores.csv", index=False)
        logging.info("Dados salvos em CSV")
    else:
        logging.warning("Nenhum dado retornado")
    logging.info("Pipeline finalizado")    
