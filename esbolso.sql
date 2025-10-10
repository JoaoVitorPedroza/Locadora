--!SEGUE O CÓDIGO DO PROJETO SEPARADO POR TABELAS:
-- LOCADORA: ESBOLSO
-- 1. TABELA CATEGORIA
CREATE TABLE Categoria (
    id_categoria SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE
);

-- 2. TABELA ATOR
CREATE TABLE Ator (
    id_ator SERIAL PRIMARY KEY,
    nome_completo VARCHAR(200) NOT NULL,
    data_nascimento DATE NOT NULL,
    pais_origem VARCHAR(100) NOT NULL
);

-- 3. TABELA FILME (O Título)
CREATE TABLE Filme (
    id_filme SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    duracao_minutos INTEGER NOT NULL CHECK (duracao_minutos > 0),
    id_categoria INTEGER NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 4. TABELA FILME_ATOR (Relacionamento N:N: Elenco)
CREATE TABLE Filme_Ator (
    id_filme INTEGER NOT NULL,
    id_ator INTEGER NOT NULL,
    -- Chave Primária Composta
    PRIMARY KEY (id_filme, id_ator),
    FOREIGN KEY (id_filme) REFERENCES Filme(id_filme) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_ator) REFERENCES Ator(id_ator) ON UPDATE CASCADE ON DELETE CASCADE
);

-- 5. TABELA CLIENTE (Inclui todos os campos de endereço)
CREATE TABLE Cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome_completo VARCHAR(200) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    rua VARCHAR(255) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    cep CHAR(8) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    complemento VARCHAR(100)
);

-- 6. TABELA TELEFONE (Relacionamento 1:N com Cliente)
CREATE TABLE Telefone (
    id_telefone SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL, -- FK para Cliente.id_cliente
    numero VARCHAR(20) NOT NULL UNIQUE,
    is_principal BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON UPDATE CASCADE ON DELETE CASCADE
);

-- 7. TABELA DISCO (A Cópia física)
CREATE TABLE Disco (
    id_disco SERIAL PRIMARY KEY,
    id_filme INTEGER NOT NULL,
    num_registro VARCHAR(50) NOT NULL UNIQUE,
    cod_barras VARCHAR(50) NOT NULL UNIQUE,
    disponivel BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_filme) REFERENCES Filme(id_filme) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 8. TABELA LOCACAO (A Transação de aluguel)
CREATE TABLE Locacao (
    id_locacao SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL,
    data_locacao TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_devolucao_prevista DATE NOT NULL,
    valor_total NUMERIC(10, 2) NOT NULL CHECK (valor_total >= 0),
    data_devolucao_real TIMESTAMP WITH TIME ZONE,
    multa_paga NUMERIC(10, 2) DEFAULT 0.00,
    pesquisa_satisfacao_nota INTEGER CHECK (pesquisa_satisfacao_nota >= 0 AND pesquisa_satisfacao_nota <= 10),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 9. TABELA ITEM_LOCACAO (Relacionamento N:N: Quais discos na locação)
CREATE TABLE Item_Locacao (
    id_locacao INTEGER NOT NULL,
    id_disco INTEGER NOT NULL UNIQUE, -- UNIQUE garante que o disco só pode estar em uma locação por vez
    valor_aluguel_unitario NUMERIC(10, 2) NOT NULL CHECK (valor_aluguel_unitario > 0),
    -- Chave Primária Composta
    PRIMARY KEY (id_locacao, id_disco),
    FOREIGN KEY (id_locacao) REFERENCES Locacao(id_locacao) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_disco) REFERENCES Disco(id_disco) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Índices para otimização de consultas comuns
CREATE INDEX idx_cliente_cpf ON Cliente (cpf);
CREATE INDEX idx_disco_cod_barras ON Disco (cod_barras);
CREATE INDEX idx_locacao_cliente ON Locacao (id_cliente);