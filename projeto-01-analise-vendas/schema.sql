-- ==========================================
-- Esquema relacional: Análise de Vendas
-- ==========================================
CREATE TABLE clientes (
    id_cliente      SERIAL PRIMARY KEY,
    nome            VARCHAR(150) NOT NULL,
    regiao          VARCHAR(50) NOT NULL,
    data_cadastro   DATE NOT NULL
);

CREATE TABLE categorias (
    id_categoria    SERIAL PRIMARY KEY,
    nome_categoria  VARCHAR(100) NOT NULL
);

CREATE TABLE produtos (
    id_produto      SERIAL PRIMARY KEY,
    nome_produto    VARCHAR(150) NOT NULL,
    id_categoria    INT REFERENCES categorias(id_categoria),
    valor_unitario  NUMERIC(10,2) NOT NULL
);

CREATE TABLE vendedores (
    id_vendedor     SERIAL PRIMARY KEY,
    nome_vendedor   VARCHAR(150) NOT NULL,
    regiao          VARCHAR(50) NOT NULL
);

CREATE TABLE pedidos (
    id_pedido       SERIAL PRIMARY KEY,
    id_cliente      INT REFERENCES clientes(id_cliente),
    id_vendedor     INT REFERENCES vendedores(id_vendedor),
    data_pedido     DATE NOT NULL
);

CREATE TABLE itens_pedido (
    id_item         SERIAL PRIMARY KEY,
    id_pedido       INT REFERENCES pedidos(id_pedido),
    id_produto      INT REFERENCES produtos(id_produto),
    quantidade      INT NOT NULL,
    desconto        NUMERIC(5,2) DEFAULT 0
);

CREATE INDEX idx_pedidos_data ON pedidos(data_pedido);
CREATE INDEX idx_itens_pedido ON itens_pedido(id_pedido);
CREATE INDEX idx_itens_produto ON itens_pedido(id_produto);
