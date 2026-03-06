-- =============================================
-- Marketplace Analytics Project
-- Schema: marketplace
-- =============================================

CREATE SCHEMA IF NOT EXISTS marketplace;

SET search_path TO marketplace;

-- =============================================
-- Tabela: clientes
-- =============================================

CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    cidade VARCHAR(100)
);

-- =============================================
-- Tabela: vendedores
-- =============================================

CREATE TABLE vendedores (
    id_vendedor SERIAL PRIMARY KEY,
    nome_vendedor VARCHAR(100) NOT NULL,
    comissao_percentual DECIMAL(5,2) NOT NULL CHECK (comissao_percentual >= 0)
);

-- =============================================
-- Tabela: produtos
-- =============================================

CREATE TABLE produtos (
    id_produto SERIAL PRIMARY KEY,
    nome_produto VARCHAR(100) NOT NULL,
    id_vendedor INT NOT NULL,

	CONSTRAINT fk_produto_vendedor
		FOREIGN KEY (id_vendedor)
		REFERENCES vendedores(id_vendedor)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

-- =============================================
-- Tabela: pedidos
-- =============================================

CREATE TABLE pedidos (
	id_pedido SERIAL PRIMARY KEY,
	id_cliente INT NOT NULL,
	data_pedido DATE NOT NULL,

	CONSTRAINT fk_pedido_cliente
		FOREIGN KEY (id_cliente)
		REFERENCES clientes (id_cliente)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

-- =============================================
-- Tabela: itens_pedido
-- =============================================

CREATE TABLE itens_pedido (
	id_item SERIAL PRIMARY KEY,
	id_pedido INT NOT NULL,
	id_produto INT NOT NULL,
	quantidade INT NOT NULL CHECK (quantidade > 0),
	preco_unitario DECIMAL(10,2) NOT NULL,

	CONSTRAINT fk_item_pedido
		FOREIGN KEY (id_pedido)
		REFERENCES pedidos(id_pedido)
		ON DELETE CASCADE
		ON UPDATE CASCADE,

	CONSTRAINT fk_item_produto
		FOREIGN KEY (id_produto)
		REFERENCES produtos(id_produto)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);