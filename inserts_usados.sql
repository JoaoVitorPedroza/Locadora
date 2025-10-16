--! BLOCO DE INSERTS CORRIGIDO (DML) - ORDEM DE DEPENDÊNCIA (BASE -> DEPENDENTE)

-- =========================================================================
-- 1. ENTIDADES BASE (Não dependem de ninguém)
-- =========================================================================

-- 1. NACAO
INSERT INTO Nacao (nome_nacao) VALUES
('Brasil'), -- ID 1
('Estados Unidos'); -- ID 2

-- 2. CATEGORIA
INSERT INTO Categoria (nome) VALUES
('Ação'), -- ID 1
('Ficção Científica'), -- ID 2
('Comédia'), -- ID 3
('Drama'); -- ID 4

-- =========================================================================
-- 2. HIERARQUIA GEOGRÁFICA (Dependem de Nacao)
-- =========================================================================

-- 1. ESTADO (Depende de Nacao)
INSERT INTO Estado (nome_estado, sigla_estado, id_nacao) VALUES
('São Paulo', 'SP', 1), -- ID 1 (FK Brasil)
('Rio de Janeiro', 'RJ', 1), -- ID 2 (FK Brasil)
('Califórnia', 'CA', 2); -- ID 3 (FK Estados Unidos)

-- 2. CIDADE (Depende de Estado)
INSERT INTO Cidade (nome_cidade, id_estado) VALUES
('São Paulo', 1), -- ID 1 (FK SP)
('Campinas', 1), -- ID 2 (FK SP)
('Los Angeles', 3); -- ID 3 (FK CA)

-- 3 ENDERECO (Depende de Cidade)
INSERT INTO Endereco (logradouro, numero, complemento, bairro, cep, id_cidade) VALUES
('Rua da Saudade', '123', 'Apto 10', 'Centro', '01000000', 1), -- ID 1 (FK São Paulo)
('Av. Paulista', '2000', NULL, 'Bela Vista', '01311900', 1), -- ID 2 (FK São Paulo)
('Hollywood Blvd', '6801', NULL, 'Hollywood', '90028', 3); -- ID 3 (FK Los Angeles)

-- =========================================================================
-- 3. ENTIDADES PRINCIPAIS (Dependem de Categoria e Nacao)
-- =========================================================================

-- 1. ATOR (Depende de Nacao)
INSERT INTO Ator (nome_completo, data_nascimento, id_nacao) VALUES
('Wagner Moura', '1976-06-27', 1), -- ID 1 (FK Brasil)
('Tom Hanks', '1956-07-09', 2), -- ID 2 (FK EUA)
('Vin Diesel', '1967-07-18', 2); -- NOVO: ID 3 (Para corrigir a FK do Filme_Ator)

-- 2. FILME (Depende de Categoria)
INSERT INTO Filme (titulo, duracao_minutos, id_categoria) VALUES
('Star wars', 125, 2), -- ID 1 (FK Ficção Científica)
('Gente grande', 90, 3), -- ID 2 (FK Comédia)
('Velozes e Furiosos', 140, 1); -- ID 3 (FK Ação)

-- 3. CLIENTE (Depende de Endereco)
INSERT INTO Cliente (nome_completo, cpf, id_endereco, id_telefone_principal) VALUES
('João Silva', '12345678901', 1, NULL), -- ID 1 (FK Endereço 1)
('Maria Souza', '98765432109', 2, NULL); -- ID 2 (FK Endereço 2)

-- =========================================================================
-- 4. ENTIDADES DEPENDENTES (Telefone, Locação, Relacionamentos)
-- =========================================================================

-- 1. TELEFONE (Depende de Cliente)
INSERT INTO Telefone (id_cliente, numero) VALUES
(1, '5511988887777'), -- ID 1 (FK Cliente 1)
(1, '551133334444'),  -- ID 2 (FK Cliente 1)
(2, '5521999990000'); -- ID 3 (FK Cliente 2)

-- 2. DISCO (Depende de Filme)
INSERT INTO Disco (id_filme, num_registro, cod_barras, disponivel) VALUES
(1, 'FS001A', '9876543210123', TRUE), -- ID 1 (FK Filme 1)
(1, 'FS001B', '9876543210124', TRUE), -- ID 2 (FK Filme 1)
(2, 'RG002A', '9876543210125', TRUE), -- ID 3 (FK Filme 2)
(3, 'DF003A', '9876543210126', FALSE); -- ID 4 (FK Filme 3)

-- 3. LOCACAO (Depende de Cliente)
INSERT INTO Locacao (id_cliente, data_locacao, data_devolucao_prevista, valor_total) VALUES
(1, NOW(), CURRENT_DATE + INTERVAL '5 days', 25.00); -- ID 1 (FK Cliente 1)

-- 4. FILME_ATOR (Depende de Filme e Ator)
INSERT INTO Filme_Ator (id_filme, id_ator) VALUES
(1, 1), -- Star Wars (1) com Wagner Moura (1)
(2, 2), -- Gente Grande (2) com Tom Hanks (2)
(3, 1), -- Velozes (3) com Wagner Moura (1) -- Se for intencional
(3, 3); -- Velozes (3) com Vin Diesel (3) (Correção: Ator 3 existe agora)

-- 5. ITEM_LOCACAO (Depende de Locacao e Disco)
INSERT INTO Item_Locacao (id_locacao, id_disco, valor_aluguel_unitario) VALUES
(1, 1, 15.00), -- Locação 1, Disco 1
(1, 3, 10.00); -- Locação 1, Disco 3

-- =========================================================================
-- 5. AJUSTES FINAIS (Resolve a Regra de Negócio do Telefone Principal)
-- =========================================================================

-- RESOLVENDO O PROBLEMA DO TELEFONE PRINCIPAL
UPDATE Cliente SET id_telefone_principal = 1 WHERE id_cliente = 1; -- João (ID 1) usa o Telefone 1
UPDATE Cliente SET id_telefone_principal = 3 WHERE id_cliente = 2; -- Maria (ID 2) usa o Telefone 3