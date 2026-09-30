-- ==========================================
-- Dados de exemplo
-- ==========================================
INSERT INTO categorias (nome_categoria) VALUES
('Eletrônicos'), ('Móveis'), ('Vestuário'), ('Alimentos'), ('Informática');

INSERT INTO clientes (nome, regiao, data_cadastro) VALUES
('Alpha Comércio', 'Sudeste', '2022-01-15'),
('Beta Distribuidora', 'Sul', '2022-03-22'),
('Gamma Varejo', 'Nordeste', '2022-06-10'),
('Delta Atacado', 'Centro-Oeste', '2023-02-05'),
('Epsilon Ltda', 'Norte', '2023-05-18');

INSERT INTO vendedores (nome_vendedor, regiao) VALUES
('Ana Souza', 'Sudeste'),
('Bruno Lima', 'Sul'),
('Carla Mendes', 'Nordeste'),
('Diego Rocha', 'Centro-Oeste');

INSERT INTO produtos (nome_produto, id_categoria, valor_unitario) VALUES
('Notebook Pro', 5, 4500.00),
('Smartphone X', 1, 2800.00),
('Sofá 3 Lugares', 2, 1900.00),
('Camiseta Básica', 3, 49.90),
('Cesta Básica', 4, 320.00);

INSERT INTO pedidos (id_cliente, id_vendedor, data_pedido) VALUES
(1, 1, '2024-01-10'),
(2, 2, '2024-01-15'),
(3, 3, '2024-02-20'),
(1, 1, '2024-03-05'),
(4, 4, '2024-03-18'),
(5, 3, '2024-04-02');

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, desconto) VALUES
(1, 1, 2, 5.00),
(1, 4, 10, 0),
(2, 2, 3, 10.00),
(3, 3, 1, 0),
(4, 5, 20, 8.00),
(5, 2, 5, 12.00),
(6, 1, 1, 0);
