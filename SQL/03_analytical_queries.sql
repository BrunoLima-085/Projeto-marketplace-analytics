SET search_path TO marketplace;

-- =============================================
-- KPI GERAL DO MARKETPLACE
-- =============================================

-- Receita total do marketplace

SELECT 
    SUM(quantidade * preco_unitario) AS receita_total
FROM itens_pedido;

-- =============================================
-- ANÁLISE DE VENDEDORES
-- =============================================

-- Receita por vendedor

SELECT
    v.id_vendedor,
    v.nome_vendedor,
    SUM(ip.quantidade * ip.preco_unitario) AS receita_vendedor
FROM vendedores v
JOIN produtos p
    ON v.id_vendedor = p.id_vendedor
JOIN itens_pedido ip
    ON p.id_produto = ip.id_produto
GROUP BY 
    v.id_vendedor,
    v.nome_vendedor
ORDER BY 
	receita_vendedor DESC;

-- Ranking de vendedores por receita

SELECT
	v.id_vendedor,
	v.nome_vendedor,
	SUM(ip.quantidade * ip.preco_unitario) AS receita_vendedor,
	RANK() OVER(
		ORDER BY
			SUM(ip.quantidade * ip.preco_unitario) DESC
	) AS ranking_vendedor
FROM vendedores v
JOIN produtos p
    ON v.id_vendedor = p.id_vendedor
JOIN itens_pedido ip
    ON p.id_produto = ip.id_produto
GROUP BY 
    v.id_vendedor,
    v.nome_vendedor
ORDER BY 
	ranking_vendedor;

-- =============================================
-- ANÁLISE DE PRODUTOS
-- =============================================

-- Produto mais vendido

SELECT
    p.id_produto,
    p.nome_produto,
    SUM(ip.quantidade) AS total_vendido
FROM produtos p
JOIN itens_pedido ip
    ON p.id_produto = ip.id_produto
GROUP BY
    p.id_produto,
    p.nome_produto
ORDER BY 
	total_vendido DESC;

-- Ranking de produtos mais vendidos

SELECT
	p.id_produto,
	p.nome_produto,
	SUM(ip.quantidade) AS total_vendido,
	RANK() OVER(
		ORDER BY 
			SUM(ip.quantidade) DESC
	) AS ranking_produto
FROM produtos p
JOIN itens_pedido ip
	ON p.id_produto = ip.id_produto
GROUP BY
    p.id_produto,
    p.nome_produto
ORDER BY 
	ranking_produto;

-- =============================================
-- ANÁLISE DE CLIENTES
-- =============================================

-- Cliente que mais gastou no marketplace

SELECT
    c.id_cliente,
    c.nome,
    SUM(ip.quantidade * ip.preco_unitario) AS total_gasto
FROM clientes c
JOIN pedidos pe
    ON c.id_cliente = pe.id_cliente
JOIN itens_pedido ip
    ON pe.id_pedido = ip.id_pedido
GROUP BY
    c.id_cliente,
    c.nome
ORDER BY 
	total_gasto DESC;

-- Quantidade de pedidos realizados por cliente

SELECT
	c.id_cliente,
	c.nome,
	COUNT(pe.id_pedido) AS total_pedidos
FROM clientes c
JOIN pedidos pe
	ON c.id_cliente = pe.id_cliente
GROUP BY
	c.id_cliente,
	c.nome
ORDER BY 
	total_pedidos DESC;

-- =============================================
-- MÉTRICAS GERAIS DE VENDAS
-- =============================================

-- Ticket médio por pedido

SELECT
	ROUND(
		SUM(quantidade * preco_unitario) / 
		NULLIF(COUNT(DISTINCT id_pedido), 0),
		2
	) AS ticket_medio
FROM itens_pedido;

-- =============================================
-- ANÁLISE TEMPORAL DE VENDAS
-- =============================================

-- Receita por data de pedido

SELECT
	pe.data_pedido,
	SUM(ip.quantidade * ip.preco_unitario) AS receita_dia
FROM pedidos pe
JOIN itens_pedido ip
	ON pe.id_pedido = ip.id_pedido
GROUP BY
	pe.data_pedido
ORDER BY 
    pe.data_pedido;