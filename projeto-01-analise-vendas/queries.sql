-- ==========================================
-- 1. Top 10 produtos mais lucrativos
-- ==========================================
SELECT
    p.nome_produto,
    c.nome_categoria,
    SUM(ip.quantidade * p.valor_unitario * (1 - ip.desconto/100.0)) AS receita_total
FROM itens_pedido ip
JOIN produtos p ON p.id_produto = ip.id_produto
JOIN categorias c ON c.id_categoria = p.id_categoria
GROUP BY p.nome_produto, c.nome_categoria
ORDER BY receita_total DESC
LIMIT 10;

-- ==========================================
-- 2. Ranking de vendedores por faturamento
-- ==========================================
WITH faturamento_vendedor AS (
    SELECT
        v.id_vendedor,
        v.nome_vendedor,
        v.regiao,
        SUM(ip.quantidade * p.valor_unitario * (1 - ip.desconto/100.0)) AS faturamento
    FROM pedidos ped
    JOIN vendedores v ON v.id_vendedor = ped.id_vendedor
    JOIN itens_pedido ip ON ip.id_pedido = ped.id_pedido
    JOIN produtos p ON p.id_produto = ip.id_produto
    GROUP BY v.id_vendedor, v.nome_vendedor, v.regiao
)
SELECT
    *,
    RANK() OVER (ORDER BY faturamento DESC) AS ranking
FROM faturamento_vendedor
ORDER BY ranking;

-- ==========================================
-- 3. Evolução mensal do ticket médio
-- ==========================================
WITH pedidos_mensais AS (
    SELECT
        DATE_TRUNC('month', ped.data_pedido) AS mes,
        ped.id_pedido,
        SUM(ip.quantidade * p.valor_unitario * (1 - ip.desconto/100.0)) AS valor_pedido
    FROM pedidos ped
    JOIN itens_pedido ip ON ip.id_pedido = ped.id_pedido
    JOIN produtos p ON p.id_produto = ip.id_produto
    GROUP BY mes, ped.id_pedido
)
SELECT
    mes,
    COUNT(id_pedido) AS total_pedidos,
    ROUND(AVG(valor_pedido), 2) AS ticket_medio,
    ROUND(SUM(valor_pedido), 2) AS faturamento_mes,
    ROUND(SUM(valor_pedido) - LAG(SUM(valor_pedido)) OVER (ORDER BY mes), 2)
        AS variacao_vs_mes_anterior
FROM pedidos_mensais
GROUP BY mes
ORDER BY mes;

-- ==========================================
-- 4. Regra de Pareto
-- ==========================================
WITH faturamento_vendedor AS (
    SELECT
        v.id_vendedor,
        SUM(ip.quantidade * p.valor_unitario * (1 - ip.desconto/100.0)) AS faturamento
    FROM pedidos ped
    JOIN vendedores v ON v.id_vendedor = ped.id_vendedor
    JOIN itens_pedido ip ON ip.id_pedido = ped.id_pedido
    JOIN produtos p ON p.id_produto = ip.id_produto
    GROUP BY v.id_vendedor
),
ranked AS (
    SELECT
        id_vendedor,
        faturamento,
        SUM(faturamento) OVER (ORDER BY faturamento DESC) AS faturamento_acumulado,
        SUM(faturamento) OVER () AS faturamento_total,
        ROW_NUMBER() OVER (ORDER BY faturamento DESC) AS posicao,
        COUNT(*) OVER () AS total_vendedores
    FROM faturamento_vendedor
)
SELECT
    posicao,
    total_vendedores,
    ROUND(faturamento_acumulado / faturamento_total * 100, 1) AS pct_faturamento_acumulado
FROM ranked
ORDER BY posicao;

-- ==========================================
-- 5. Crescimento ano a ano por região
-- ==========================================
WITH faturamento_regiao_ano AS (
    SELECT
        c.regiao,
        EXTRACT(YEAR FROM ped.data_pedido) AS ano,
        SUM(ip.quantidade * p.valor_unitario * (1 - ip.desconto/100.0)) AS faturamento
    FROM pedidos ped
    JOIN clientes c ON c.id_cliente = ped.id_cliente
    JOIN itens_pedido ip ON ip.id_pedido = ped.id_pedido
    JOIN produtos p ON p.id_produto = ip.id_produto
    GROUP BY c.regiao, ano
)
SELECT
    regiao,
    ano,
    faturamento,
    ROUND(
        (faturamento - LAG(faturamento) OVER (PARTITION BY regiao ORDER BY ano))
        / LAG(faturamento) OVER (PARTITION BY regiao ORDER BY ano) * 100, 1
    ) AS crescimento_pct
FROM faturamento_regiao_ano
ORDER BY regiao, ano;

-- ==========================================
-- 6. Clientes com maior valor de vida (LTV)
-- ==========================================
SELECT
    c.nome,
    c.regiao,
    COUNT(DISTINCT ped.id_pedido) AS total_pedidos,
    ROUND(SUM(ip.quantidade * p.valor_unitario * (1 - ip.desconto/100.0)), 2) AS ltv,
    ROUND(AVG(ip.quantidade * p.valor_unitario * (1 - ip.desconto/100.0)), 2) AS ticket_medio
FROM clientes c
JOIN pedidos ped ON ped.id_cliente = c.id_cliente
JOIN itens_pedido ip ON ip.id_pedido = ped.id_pedido
JOIN produtos p ON p.id_produto = ip.id_produto
GROUP BY c.nome, c.regiao
ORDER BY ltv DESC;
