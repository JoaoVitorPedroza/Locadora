--! SEGUE O CÓDIGO DO PROJETO COM AS CORREÇÕES DE NORMALIZAÇÃO E REGRAS DE NEGÓCIO:

-- 1. TABELA CATEGORIA (Não tem dependências)
CREATE TABLE Categoria (
    id_categoria SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE
);

-- 2. TABELAS DE ENDEREÇO E PAÍS (Devem vir primeiro por serem entidades base)

-- 2A. TABELA NACAO (País de origem de atores/endereço)
CREATE TABLE Nacao (
    id_nacao SERIAL PRIMARY KEY,
    nome_nacao VARCHAR(100) NOT NULL UNIQUE
);

-- 2B. TABELA ESTADO (Depende de Nacao)
CREATE TABLE Estado (
    id_estado SERIAL PRIMARY KEY,
    nome_estado VARCHAR(100) NOT NULL,
    sigla_estado CHAR(2) NOT NULL,
    id_nacao INTEGER NOT NULL,
    FOREIGN KEY (id_nacao) REFERENCES Nacao(id_nacao) ON UPDATE CASCADE ON DELETE RESTRICT,
    UNIQUE (nome_estado, id_nacao)
);

-- 2C. TABELA CIDADE (Depende de Estado)
CREATE TABLE Cidade (
    id_cidade SERIAL PRIMARY KEY,
    nome_cidade VARCHAR(100) NOT NULL,
    id_estado INTEGER NOT NULL,
    FOREIGN KEY (id_estado) REFERENCES Estado(id_estado) ON UPDATE CASCADE ON DELETE RESTRICT,
    UNIQUE (nome_cidade, id_estado)
);

-- 2D. TABELA ENDERECO (Depende de Cidade)
CREATE TABLE Endereco (
    id_endereco SERIAL PRIMARY KEY,
    logradouro VARCHAR(255) NOT NULL,
    numero VARCHAR(10),
    complemento VARCHAR(100),
    bairro VARCHAR(100) NOT NULL,
    cep CHAR(8) NOT NULL,
    id_cidade INTEGER NOT NULL,
    FOREIGN KEY (id_cidade) REFERENCES Cidade(id_cidade) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 3. TABELA ATOR (CORRIGIDA - Agora depende de Nacao)
CREATE TABLE Ator (
    id_ator SERIAL PRIMARY KEY,
    nome_completo VARCHAR(200) NOT NULL,
    data_nascimento DATE NOT NULL,
    -- Substitui pais_origem
    id_nacao INTEGER NOT NULL,
    FOREIGN KEY (id_nacao) REFERENCES Nacao(id_nacao) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 4. TABELA CLIENTE (CORRIGIDA - Depende de Endereco)
CREATE TABLE Cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome_completo VARCHAR(200) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    -- Substitui todos os campos de endereço duplicados
    id_endereco INTEGER,
    -- Campo para futura FK de Telefone Principal (Problema 2 resolvido pela estrutura)
    id_telefone_principal INTEGER,
    FOREIGN KEY (id_endereco) REFERENCES Endereco(id_endereco) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 5. TABELA TELEFONE (CORRIGIDA - Não tem is_principal, mas é referenciada por Cliente)
CREATE TABLE Telefone (
    id_telefone SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL,
    numero VARCHAR(20) NOT NULL UNIQUE,
    -- Coluna 'is_principal' removida
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON UPDATE CASCADE ON DELETE CASCADE
);

-- 6. ADICIONANDO FK DE TELEFONE PRINCIPAL (Resolve problema de dependência circular)
-- O Cliente agora aponta para qual dos seus telefones é o principal.
ALTER TABLE Cliente
ADD CONSTRAINT fk_telefone_principal
FOREIGN KEY (id_telefone_principal)
REFERENCES Telefone(id_telefone) ON UPDATE CASCADE ON DELETE SET NULL;


-- 7. TABELAS DE RELACIONAMENTO E TRANSAÇÃO (O restante do seu modelo)

-- 7A. TABELA FILME (Depende de Categoria)
CREATE TABLE Filme (
    id_filme SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    duracao_minutos INTEGER NOT NULL CHECK (duracao_minutos > 0),
    id_categoria INTEGER NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 7B. TABELA FILME_ATOR (Depende de Filme e Ator)
CREATE TABLE Filme_Ator (
    id_filme INTEGER NOT NULL,
    id_ator INTEGER NOT NULL,
    PRIMARY KEY (id_filme, id_ator),
    FOREIGN KEY (id_filme) REFERENCES Filme(id_filme) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_ator) REFERENCES Ator(id_ator) ON UPDATE CASCADE ON DELETE CASCADE
);

-- 7C. TABELA DISCO (Depende de Filme)
CREATE TABLE Disco (
    id_disco SERIAL PRIMARY KEY,
    id_filme INTEGER NOT NULL,
    num_registro VARCHAR(50) NOT NULL UNIQUE,
    cod_barras VARCHAR(50) NOT NULL UNIQUE,
    disponivel BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_filme) REFERENCES Filme(id_filme) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 7D. TABELA LOCACAO (Depende de Cliente)
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

-- 7E. TABELA ITEM_LOCACAO (Depende de Locacao e Disco)
CREATE TABLE Item_Locacao (
    id_locacao INTEGER NOT NULL,
    id_disco INTEGER NOT NULL UNIQUE,
    valor_aluguel_unitario NUMERIC(10, 2) NOT NULL CHECK (valor_aluguel_unitario > 0),
    PRIMARY KEY (id_locacao, id_disco),
    FOREIGN KEY (id_locacao) REFERENCES Locacao(id_locacao) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_disco) REFERENCES Disco(id_disco) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ÍNDICES (Opcional, mas útil para performance)
CREATE INDEX idx_cliente_cpf ON Cliente (cpf);
CREATE INDEX idx_disco_cod_barras ON Disco (cod_barras);
CREATE INDEX idx_locacao_cliente ON Locacao (id_cliente);