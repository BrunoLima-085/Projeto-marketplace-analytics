SET search_path TO marketplace;

-- =============================================
-- VIEW: PERFORMANCE CONSOLIDADA DE VENDEDORES
-- =============================================
-- Consolida métricas de vendas por vendedor:
-- pedidos, faturamento bruto (GMV),
-- receita da plataforma e ticket médio.

CREATE OR REPLACE VIEW marketplace.view_performance_consolidada AS

-- CTE: cálculo do valor financeiro de cada item vendido
WITH vendas AS (
    SELECT
        pr.id_vendedor,
        pe.id_pedido,
        ip.quantidade * ip.preco_unitario AS valor_item
    FROM marketplace.itens_pedido ip
    JOIN marketplace.produtos pr
        ON ip.id_produto = pr.id_produto
    JOIN marketplace.pedidos pe
        ON ip.id_pedido = pe.id_pedido
),

-- CTE: agregação das métricas por vendedor
metricas_vendedor AS (
    SELECT
        v.id_vendedor,
        v.nome_vendedor,
        v.comissao_percentual AS taxa_comissao,

        COUNT(DISTINCT vendas.id_pedido) AS total_pedidos,

        ROUND(SUM(vendas.valor_item), 2) AS faturamento_bruto,

        ROUND(
            SUM(vendas.valor_item * (v.comissao_percentual / 100)),
            2
        ) AS receita_marketplace,

        ROUND(
            SUM(vendas.valor_item * (1 - (v.comissao_percentual / 100))),
            2
        ) AS repasse_vendedor,

        ROUND(
            SUM(vendas.valor_item) /
            NULLIF(COUNT(DISTINCT vendas.id_pedido), 0),
            2
        ) AS ticket_medio_vendedor

    FROM marketplace.vendedores v
    LEFT JOIN vendas
        ON v.id_vendedor = vendas.id_vendedor

    GROUP BY
        v.id_vendedor,
        v.nome_vendedor,
        v.comissao_percentual
)

-- Resultado final com ranking
SELECT
    *,

    RANK() OVER (
        ORDER BY faturamento_bruto DESC
    ) AS ranking_vendedor

FROM metricas_vendedor;