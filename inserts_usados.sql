--!TODOS OS iserts usados
-- 1. CATEGORIA
INSERT INTO Categoria (nome) VALUES
('Ação'),
('Ficção Científica'),
('Comédia'),
('Drama');

-- 2. ATOR
INSERT INTO Ator (nome_completo, data_nascimento, pais_origem) VALUES
('Ana de Oliveira', '1985-11-20', 'Brasil'),
('João Silva', '1970-03-15', 'Portugal'),
('Mia Collins', '1995-07-01', 'Estados Unidos');

-- 3. CLIENTE com endereco
-- com CPF: 11122233344 (Cliente 1),e com n0 99988877766 (Cliente 2)
INSERT INTO Cliente (nome_completo, cpf, rua, numero, bairro, cep, cidade, estado, complemento) VALUES
('Mariana Souza', '11122233344', 'Rua das Flores', '15A', 'Centro', '01000000', 'Sao Paulo', 'SP', NULL),
('Carlos Rocha', '99988877766', 'Avenida Principal', '1200', 'Vila Nova', '50000000', 'Recife', 'PE', 'Apto 101');

-- 4. FILME
INSERT INTO Filme (titulo, duracao_minutos, id_categoria) VALUES
('Star wars', 125, 2),
('Gente grande', 90, 3),
('velozes e furiosos', 140, 1);

-- 5. TELEFONE
INSERT INTO Telefone (id_cliente, numero, is_principal) VALUES
(1, '11987654321', TRUE),  -- Telefone principal de Mariana
(1, '1133334444', FALSE),  -- Telefone secundário de Mariana
(2, '81911112222', TRUE);  -- Telefone principal de Carlos

-- 6. FILME_ATOR (Ligação N:N)
INSERT INTO Filme_Ator (id_filme, id_ator) VALUES
(1, 1),
(2, 2),
(3, 1),
(3, 3);

-- 7. DISCO (As cópias físicas)
INSERT INTO Disco (id_filme, num_registro, cod_barras, disponivel) VALUES
(1, 'FS001A', '9876543210123', TRUE),
(1, 'FS001B', '9876543210124', TRUE),
(2, 'RG002A', '9876543210125', TRUE),
(3, 'DF003A', '9876543210126', FALSE);

-- 8. LOCACAO
INSERT INTO Locacao (id_cliente, data_locacao, data_devolucao_prevista, valor_total) VALUES
(1, NOW(), CURRENT_DATE + INTERVAL '5 days', 25.00);

-- 9. ITEM_LOCACAO
INSERT INTO Item_Locacao (id_locacao, id_disco, valor_aluguel_unitario) VALUES
(1, 1, 15.00),
(1, 3, 10.00);