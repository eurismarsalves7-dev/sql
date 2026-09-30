-- ==========================================
-- Views reutilizáveis
-- ==========================================

CREATE OR REPLACE VIEW vw_faturamento_mensal AS
SELECT
    DATE_TRUNC('month', ped.data_pedido) AS mes,
    SUM(ip.quantidade * p.valor_unitario * (1 - ip.desconto/100.0)) AS faturamento
FROM pedidos ped
JOIN itens_pedido ip ON ip.id_pedido = ped.id_pedido
JOIN produtos p ON p.id_produto = ip.id_produto
GROUP BY mes
ORDER BY mes;

CREATE OR REPLACE VIEW vw_ranking_vendedores AS
SELECT
    v.nome_vendedor,
    v.regiao,
    SUM(ip.quantidade * p.valor_unitario * (1 - ip.desconto/100.0)) AS faturamento,
    RANK() OVER (
        ORDER BY SUM(ip.quantidade * p.valor_unitario * (1 - ip.desconto/100.0)) DESC
    ) AS ranking
FROM pedidos ped
JOIN vendedores v ON v.id_vendedor = ped.id_vendedor
JOIN itens_pedido ip ON ip.id_pedido = ped.id_pedido
JOIN produtos p ON p.id_produto = ip.id_produto
GROUP BY v.nome_vendedor, v.regiao;

CREATE OR REPLACE VIEW vw_performance_categoria AS
SELECT
    c.nome_categoria,
    SUM(ip.quantidade) AS unidades_vendidas,
    SUM(ip.quantidade * p.valor_unitario * (1 - ip.desconto/100.0)) AS receita
FROM itens_pedido ip
JOIN produtos p ON p.id_produto = ip.id_produto
JOIN categorias c ON c.id_categoria = p.id_categoria
GROUP BY c.nome_categoria
ORDER BY receita DESC;
