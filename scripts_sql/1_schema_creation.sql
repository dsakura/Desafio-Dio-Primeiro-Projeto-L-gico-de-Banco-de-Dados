SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema ecommerce
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ecommerce` DEFAULT CHARACTER SET utf8 ;
USE `ecommerce` ;

-- -----------------------------------------------------
-- Table `ecommerce`.`Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Cliente` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `Pnome` VARCHAR(15) NOT NULL,
  `Minit` CHAR(3) NULL,
  `Sobrenome` VARCHAR(45) NOT NULL,
  `CPF` CHAR(11) NULL,
  `CNPJ` CHAR(14) NULL,
  `Tipo_Cliente` ENUM('PF', 'PJ') NOT NULL DEFAULT 'PF',
  `Endereco` VARCHAR(100) NULL,
  `Data_Nascimento` DATE NULL,
  PRIMARY KEY (`idCliente`),
  UNIQUE INDEX `CPF_UNIQUE` (`CPF` ASC),
  UNIQUE INDEX `CNPJ_UNIQUE` (`CNPJ` ASC),
  CONSTRAINT `chk_cpf_cnpj` CHECK (
    (Tipo_Cliente = 'PF' AND CPF IS NOT NULL AND CNPJ IS NULL) OR
    (Tipo_Cliente = 'PJ' AND CNPJ IS NOT NULL AND CPF IS NULL)
  ))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `ecommerce`.`Produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Produto` (
  `idProduto` INT NOT NULL AUTO_INCREMENT,
  `Pname` VARCHAR(45) NOT NULL,
  `Categoria` ENUM('Eletrônico', 'Vestuário', 'Brinquedos', 'Alimentos', 'Móveis') NOT NULL,
  `Descricao` VARCHAR(255) NULL,
  `Valor` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `Avaliacao` FLOAT DEFAULT 0,
  PRIMARY KEY (`idProduto`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `ecommerce`.`Pagamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Pagamento` (
  `idPagamento` INT NOT NULL AUTO_INCREMENT,
  `idCliente` INT NOT NULL,
  `Tipo_Pagamento` ENUM('Boleto', 'Cartão', 'Dois Cartões', 'Pix') NOT NULL,
  `Limite_Disponivel` FLOAT,
  PRIMARY KEY (`idPagamento`, `idCliente`),
  CONSTRAINT `fk_pagamento_cliente`
    FOREIGN KEY (`idCliente`)
    REFERENCES `ecommerce`.`Cliente` (`idCliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `ecommerce`.`Pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Pedido` (
  `idPedido` INT NOT NULL AUTO_INCREMENT,
  `idCliente` INT NOT NULL,
  `Status_Pedido` ENUM('Cancelado', 'Confirmado', 'Em Processamento', 'Enviado', 'Entregue') DEFAULT 'Em Processamento',
  `Descricao` VARCHAR(255) NULL,
  `Frete` FLOAT DEFAULT 10.0,
  `idPagamento` INT NULL,
  PRIMARY KEY (`idPedido`),
  CONSTRAINT `fk_pedido_cliente`
    FOREIGN KEY (`idCliente`)
    REFERENCES `ecommerce`.`Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pedido_pagamento`
    FOREIGN KEY (`idPagamento`)
    REFERENCES `ecommerce`.`Pagamento` (`idPagamento`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `ecommerce`.`Entrega`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Entrega` (
  `idEntrega` INT NOT NULL AUTO_INCREMENT,
  `idPedido` INT NOT NULL,
  `Status_Entrega` ENUM('Em trânsito', 'Entregue', 'Problema na entrega') DEFAULT 'Em trânsito',
  `Codigo_Rastreio` VARCHAR(45) UNIQUE,
  `Data_Envio` DATE NULL,
  `Previsao_Entrega` DATE NULL,
  PRIMARY KEY (`idEntrega`),
  CONSTRAINT `fk_entrega_pedido`
    FOREIGN KEY (`idPedido`)
    REFERENCES `ecommerce`.`Pedido` (`idPedido`)
    ON DELETE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `ecommerce`.`Fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Fornecedor` (
  `idFornecedor` INT NOT NULL AUTO_INCREMENT,
  `Razao_Social` VARCHAR(45) NOT NULL,
  `CNPJ` CHAR(14) NOT NULL,
  `Contato` VARCHAR(11) NOT NULL,
  PRIMARY KEY (`idFornecedor`),
  UNIQUE INDEX `CNPJ_UNIQUE` (`CNPJ` ASC))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `ecommerce`.`Estoque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Estoque` (
  `idEstoque` INT NOT NULL AUTO_INCREMENT,
  `Local` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idEstoque`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `ecommerce`.`Vendedor_Terceiro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Vendedor_Terceiro` (
  `idVendedor` INT NOT NULL AUTO_INCREMENT,
  `Razao_Social` VARCHAR(45) NOT NULL,
  `Nome_Fantasia` VARCHAR(45) NULL,
  `CNPJ` CHAR(14) NULL,
  `CPF` CHAR(11) NULL,
  `Local` VARCHAR(45) NULL,
  `Contato` CHAR(11) NOT NULL,
  PRIMARY KEY (`idVendedor`),
  UNIQUE INDEX `CNPJ_UNIQUE` (`CNPJ` ASC),
  UNIQUE INDEX `CPF_UNIQUE` (`CPF` ASC))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `ecommerce`.`Produto_Pedido` (Pivot Order-Product)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Produto_Pedido` (
  `idPedido` INT NOT NULL,
  `idProduto` INT NOT NULL,
  `Quantidade` INT NOT NULL DEFAULT 1,
  `Status` ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
  PRIMARY KEY (`idPedido`, `idProduto`),
  CONSTRAINT `fk_produto_pedido_pedido`
    FOREIGN KEY (`idPedido`)
    REFERENCES `ecommerce`.`Pedido` (`idPedido`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_produto_pedido_produto`
    FOREIGN KEY (`idProduto`)
    REFERENCES `ecommerce`.`Produto` (`idProduto`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `ecommerce`.`Produto_Estoque` (Pivot Product-Storage)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Produto_Estoque` (
  `idProduto` INT NOT NULL,
  `idEstoque` INT NOT NULL,
  `Quantidade` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`idProduto`, `idEstoque`),
  CONSTRAINT `fk_produto_estoque_produto`
    FOREIGN KEY (`idProduto`)
    REFERENCES `ecommerce`.`Produto` (`idProduto`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_produto_estoque_estoque`
    FOREIGN KEY (`idEstoque`)
    REFERENCES `ecommerce`.`Estoque` (`idEstoque`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `ecommerce`.`Produto_Fornecedor` (Pivot Product-Supplier)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Produto_Fornecedor` (
  `idFornecedor` INT NOT NULL,
  `idProduto` INT NOT NULL,
  PRIMARY KEY (`idFornecedor`, `idProduto`),
  CONSTRAINT `fk_produto_fornecedor_fornecedor`
    FOREIGN KEY (`idFornecedor`)
    REFERENCES `ecommerce`.`Fornecedor` (`idFornecedor`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_produto_fornecedor_produto`
    FOREIGN KEY (`idProduto`)
    REFERENCES `ecommerce`.`Produto` (`idProduto`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `ecommerce`.`Produto_Vendedor` (Pivot Product-Seller)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Produto_Vendedor` (
  `idVendedor` INT NOT NULL,
  `idProduto` INT NOT NULL,
  `Quantidade` INT DEFAULT 1,
  PRIMARY KEY (`idVendedor`, `idProduto`),
  CONSTRAINT `fk_produto_vendedor_vendedor`
    FOREIGN KEY (`idVendedor`)
    REFERENCES `ecommerce`.`Vendedor_Terceiro` (`idVendedor`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_produto_vendedor_produto`
    FOREIGN KEY (`idProduto`)
    REFERENCES `ecommerce`.`Produto` (`idProduto`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
