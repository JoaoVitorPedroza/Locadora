CREATE TABLE `locacao`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_clientes` BIGINT NOT NULL,
    `valor total` DECIMAL(8, 2) NOT NULL,
    `data_locacaodate` TIMESTAMP NOT NULL,
    `data_devolucao_prevista` TIMESTAMP NOT NULL,
    `data_devolucao_real` DATE NOT NULL,
    `multa_paga` DECIMAL(8, 2) NOT NULL,
    `pesquisa_satisfacao_nota` DECIMAL(8, 2) NOT NULL
);
ALTER TABLE
    `locacao` ADD INDEX `locacao_id_clientes_index`(`id_clientes`);
CREATE TABLE `clientes`(
    `id` BIGINT NOT NULL,
    `nome completo` TEXT NOT NULL,
    `cpf` VARCHAR(255) NOT NULL,
    `id_telefone_principal` BIGINT NOT NULL,
    PRIMARY KEY(`id`)
);
ALTER TABLE
    `clientes` ADD INDEX `clientes_nome_completo_index`(`nome completo`);
ALTER TABLE
    `clientes` ADD INDEX `clientes_cpf_index`(`cpf`);
ALTER TABLE
    `clientes` ADD INDEX `clientes_nome completo_index`(`nome completo`);
ALTER TABLE
    `clientes` ADD UNIQUE `clientes_cpf_unique`(`cpf`);
CREATE TABLE `Disco`(
    `id` BIGINT NOT NULL,
    `codigo de barra` BIGINT NOT NULL,
    `filme_id` BIGINT NOT NULL,
    `num_registro` BIGINT NOT NULL,
    PRIMARY KEY(`id`)
);
ALTER TABLE
    `Disco` ADD UNIQUE `disco_codigo de barra_unique`(`codigo de barra`);
ALTER TABLE
    `Disco` ADD UNIQUE `disco_num_registro_unique`(`num_registro`);
CREATE TABLE `telefones`(
    `id` BIGINT NOT NULL,
    `id_clientes` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `numero` BIGINT NOT NULL,
    PRIMARY KEY(`id`)
);
ALTER TABLE
    `telefones` ADD UNIQUE `telefones_numero_unique`(`numero`);
CREATE TABLE `ator`(
    `id_ator` BIGINT NOT NULL,
    `nome_ator` BIGINT NOT NULL,
    `id_nacao` BIGINT NOT NULL,
    PRIMARY KEY(`id_ator`)
);
CREATE TABLE `Item_Locacao`(
    `disco_id` BIGINT NOT NULL,
    `id_locacaodecimal` BIGINT NOT NULL,
    `valor_aluguel_unitario` DECIMAL(8, 2) NOT NULL,
    PRIMARY KEY(`disco_id`)
);
ALTER TABLE
    `Item_Locacao` ADD PRIMARY KEY(`id_locacaodecimal`);
CREATE TABLE `Filme`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `titulo` VARCHAR(255) NOT NULL,
    `duracao_minutos` BIGINT NOT NULL,
    `id_categoria` BIGINT NOT NULL
);
CREATE TABLE `Filme_Ator`(
    `id_filme` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_ator` BIGINT NOT NULL,
    PRIMARY KEY(`id_ator`)
);
CREATE TABLE `categorias`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nomes` BIGINT NOT NULL
);
ALTER TABLE
    `categorias` ADD UNIQUE `categorias_nomes_unique`(`nomes`);
CREATE TABLE `naçao`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nome_nacao` BIGINT NOT NULL
);
CREATE TABLE `estado`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_nacao` BIGINT NOT NULL
);
CREATE TABLE `cidade`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_estado` BIGINT NOT NULL
);
CREATE TABLE `endereco`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_cidade` BIGINT NOT NULL,
    `logradouro` BIGINT NOT NULL,
    `numero` BIGINT NOT NULL,
    `complemento` BIGINT NOT NULL,
    `cep` BIGINT NOT NULL
);
ALTER TABLE
    `Filme_Ator` ADD CONSTRAINT `filme_ator_id_ator_foreign` FOREIGN KEY(`id_ator`) REFERENCES `ator`(`id_ator`);
ALTER TABLE
    `Disco` ADD CONSTRAINT `disco_filme_id_foreign` FOREIGN KEY(`filme_id`) REFERENCES `Filme_Ator`(`id_filme`);
ALTER TABLE
    `Filme` ADD CONSTRAINT `filme_id_categoria_foreign` FOREIGN KEY(`id_categoria`) REFERENCES `categorias`(`id`);
ALTER TABLE
    `Disco` ADD CONSTRAINT `disco_id_foreign` FOREIGN KEY(`id`) REFERENCES `Item_Locacao`(`disco_id`);
ALTER TABLE
    `endereco` ADD CONSTRAINT `endereco_id_cidade_foreign` FOREIGN KEY(`id_cidade`) REFERENCES `cidade`(`id`);
ALTER TABLE
    `locacao` ADD CONSTRAINT `locacao_id_foreign` FOREIGN KEY(`id`) REFERENCES `Item_Locacao`(`id_locacaodecimal`);
ALTER TABLE
    `estado` ADD CONSTRAINT `estado_id_nacao_foreign` FOREIGN KEY(`id_nacao`) REFERENCES `naçao`(`id`);
ALTER TABLE
    `telefones` ADD CONSTRAINT `telefones_numero_foreign` FOREIGN KEY(`numero`) REFERENCES `clientes`(`id_telefone_principal`);
ALTER TABLE
    `telefones` ADD CONSTRAINT `telefones_id_clientes_foreign` FOREIGN KEY(`id_clientes`) REFERENCES `clientes`(`id`);
ALTER TABLE
    `cidade` ADD CONSTRAINT `cidade_id_estado_foreign` FOREIGN KEY(`id_estado`) REFERENCES `estado`(`id`);
ALTER TABLE
    `ator` ADD CONSTRAINT `ator_id_nacao_foreign` FOREIGN KEY(`id_nacao`) REFERENCES `naçao`(`id`);
ALTER TABLE
    `Disco` ADD CONSTRAINT `disco_filme_id_foreign` FOREIGN KEY(`filme_id`) REFERENCES `Filme`(`id`);
ALTER TABLE
    `locacao` ADD CONSTRAINT `locacao_id_clientes_foreign` FOREIGN KEY(`id_clientes`) REFERENCES `clientes`(`id`);