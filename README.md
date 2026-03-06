# Marketplace SQL Analytics Project

Simulação de um ambiente de **Data Analytics para um marketplace**, utilizando PostgreSQL e SQL para modelagem de dados, análises de negócio e criação de métricas estratégicas.

O projeto demonstra práticas utilizadas por **analistas de dados**, incluindo modelagem relacional, cálculos de métricas de negócio, uso de Window Functions e criação de views analíticas para uso em dashboards de Business Intelligence.

---

# 📌 Contexto de Negócio

Este projeto simula um **ecossistema de marketplace**, onde múltiplos vendedores comercializam produtos para clientes dentro de uma mesma plataforma.

Um dos principais desafios resolvidos na modelagem é a **integridade financeira do histórico de vendas**.

O preço de cada produto é registrado na tabela `itens_pedido` no momento da venda. Isso garante que:

* alterações futuras no preço do produto **não afetem vendas passadas**
* o histórico financeiro do marketplace permaneça **consistente**
* os relatórios financeiros sejam **auditáveis**

Esse padrão é utilizado em grandes plataformas como:

* Amazon
* Mercado Livre
* Shopee
* iFood

---

# 🧱 Modelo de Dados

O banco de dados segue um modelo relacional típico de plataformas de e-commerce.

Principais entidades:

* **clientes**
* **vendedores**
* **produtos**
* **pedidos**
* **itens_pedido**

---

# 📊 Entity Relationship Diagram (ERD)

```text
clientes
--------
id_cliente (PK)
nome
email
cidade
      │
      │ 1:N
      ▼
pedidos
--------
id_pedido (PK)
id_cliente (FK)
data_pedido
      │
      │ 1:N
      ▼
itens_pedido
------------
id_item (PK)
id_pedido (FK)
id_produto (FK)
quantidade
preco_unitario
      │
      │ N:1
      ▼
produtos
--------
id_produto (PK)
nome_produto
id_vendedor (FK)
      │
      │ N:1
      ▼
vendedores
----------
id_vendedor (PK)
nome_vendedor
comissao_percentual
```

Esse modelo permite analisar:

* vendas por vendedor
* produtos mais vendidos
* comportamento de compra de clientes
* receita da plataforma

---

# 🛠️ Tecnologias Utilizadas

* **Banco de Dados:** PostgreSQL
* **Linguagem:** SQL
* **Ferramenta:** pgAdmin

Conceitos aplicados no projeto:

* DDL (Data Definition Language)
* DML (Data Manipulation Language)
* DQL (Data Query Language)
* JOINs
* GROUP BY
* Window Functions
* CTEs (Common Table Expressions)
* Views analíticas
* Constraints de integridade

---

# 📂 Estrutura do Projeto

```text
marketplace-analytics-sql
│
├── sql
│   ├── 01_schema.sql
│   ├── 02_seed_data.sql
│   ├── 03_analytical_queries.sql
│   └── 04_views.sql
│
└── README.md
```

---

### 01_schema.sql

Criação da estrutura do banco de dados:

* schema
* tabelas
* primary keys
* foreign keys
* regras de integridade
* constraints

---

### 02_seed_data.sql

População do banco com dados simulados de marketplace:

* clientes
* vendedores
* produtos
* pedidos
* itens vendidos

Esses dados permitem executar análises realistas.

---

### 03_analytical_queries.sql

Consultas SQL utilizadas para responder perguntas de negócio.

Exemplos de análises implementadas:

* Receita total do marketplace
* Receita por vendedor
* Ranking de vendedores
* Produtos mais vendidos
* Clientes que mais gastaram
* Ticket médio por pedido
* Receita diária do marketplace

---

### 04_views.sql

Criação de **views analíticas** que consolidam métricas importantes para análise e dashboards.

Exemplo de métricas calculadas:

* GMV (Gross Merchandise Volume)
* Receita da plataforma (comissão)
* Repasse para vendedores
* Ticket médio por vendedor
* Ranking de vendedores por faturamento

Essas views simulam uma **camada semântica de dados utilizada por ferramentas de BI**.

---

# 📊 Exemplo de Análise

### Receita por vendedor

```sql
SELECT
    v.nome_vendedor,
    SUM(ip.quantidade * ip.preco_unitario) AS receita_vendedor
FROM vendedores v
JOIN produtos p
    ON v.id_vendedor = p.id_vendedor
JOIN itens_pedido ip
    ON p.id_produto = ip.id_produto
GROUP BY
    v.nome_vendedor
ORDER BY receita_vendedor DESC;
```

---

# 📊 Métrica de Negócio: Ticket Médio

```sql
SELECT
    ROUND(
        SUM(quantidade * preco_unitario) /
        NULLIF(COUNT(DISTINCT id_pedido), 0),
        2
    ) AS ticket_medio
FROM itens_pedido;
```

---

# 📊 Possível Dashboard (Futuro)

Esse banco pode alimentar dashboards de Business Intelligence.

Principais KPIs possíveis:

* Receita total do marketplace
* Ticket médio
* Top vendedores
* Produtos mais vendidos
* Receita diária

Ferramentas possíveis:

* Power BI
* Tableau
* Metabase

---

# 🚀 Roadmap do Projeto

Possíveis evoluções do projeto:

* [ ] Integração com **Python**
* [ ] Análise exploratória com **Pandas**
* [ ] Pipeline de **ETL**
* [ ] Dashboard em **Power BI**
* [ ] Análise de comportamento de clientes

---

# 📊 Objetivo do Projeto

Demonstrar habilidades essenciais para **Analistas de Dados**, incluindo:

* modelagem de banco de dados
* análise exploratória em SQL
* criação de métricas de negócio
* uso de Window Functions
* construção de camada analítica para BI

---

# 👨‍💻 Autor

Projeto desenvolvido por Bruno Lima como parte de um **portfólio de Data Analytics**.
