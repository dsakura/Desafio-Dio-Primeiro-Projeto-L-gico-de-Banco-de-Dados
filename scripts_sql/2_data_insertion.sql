-- MySQL Script for DML

USE `ecommerce` ;

-- 1. Cliente (Pessoa Física e Jurídica)
INSERT INTO Cliente (Pnome, Minit, Sobrenome, CPF, CNPJ, Tipo_Cliente, Endereco, Data_Nascimento) VALUES
('Ricardo', 'A', 'Silva', '12345678901', NULL, 'PF', 'Rua das Flores, 123, São Paulo', '1985-05-20'),
('Empresa', 'S', 'Tecnologia', NULL, '12345678000199', 'PJ', 'Av. Paulista, 1000, São Paulo', NULL),
('Maria', 'B', 'Oliveira', '98765432100', NULL, 'PF', 'Rua Augusta, 45, São Paulo', '1992-11-10'),
('Loja', 'X', 'Varejo', NULL, '98765432000188', 'PJ', 'Rua da Consolação, 200, São Paulo', NULL),
('Carlos', 'D', 'Souza', '45678912344', NULL, 'PF', 'Rua Oscar Freire, 50, São Paulo', '1978-02-15');

-- 2. Produto
INSERT INTO Produto (Pname, Categoria, Descricao, Valor, Avaliacao) VALUES
('Smartphone S21', 'Eletrônico', 'Samsung Galaxy S21 128GB', 3500.00, 4.5),
('Notebook Dell', 'Eletrônico', 'Dell Inspiron 15 Intel i7', 4800.00, 4.8),
('Camiseta Algodão', 'Vestuário', 'Camiseta preta básica', 49.90, 4.0),
('Sofá 3 Lugares', 'Móveis', 'Sofá retrátil cinza', 1200.00, 4.2),
('Fone de Ouvido', 'Eletrônico', 'Sony Noise Cancelling', 899.00, 4.9);

-- 3. Pagamento
INSERT INTO Pagamento (idCliente, Tipo_Pagamento, Limite_Disponivel) VALUES
(1, 'Cartão', 5000.00),
(1, 'Boleto', NULL),
(2, 'Pix', NULL),
(3, 'Cartão', 3000.00),
(5, 'Boleto', NULL);

-- 4. Pedido
INSERT INTO Pedido (idCliente, Status_Pedido, Descricao, Frete, idPagamento) VALUES
(1, 'Confirmado', 'Pedido de eletrônicos', 25.00, 1),
(2, 'Em Processamento', 'Compra corporativa', 50.00, 3),
(3, 'Entregue', 'Vestuário variado', 15.00, 4),
(1, 'Enviado', 'Fone de ouvido reserva', 10.00, 1),
(5, 'Cancelado', 'Tentativa de compra', 0.00, 5);

-- 5. Fornecedor
INSERT INTO Fornecedor (Razao_Social, CNPJ, Contato) VALUES
('Tech Distribuidora', '11222333000144', '11999999999'),
('Moda Brasil LTDA', '44555666000177', '11888888888'),
('Móveis Design', '77888999000100', '11777777777');

-- 6. Estoque
INSERT INTO Estoque (Local) VALUES
('São Paulo - Lapa'),
('Rio de Janeiro - Centro'),
('Curitiba - Pinheirinho');

-- 7. Vendedor_Terceiro
INSERT INTO Vendedor_Terceiro (Razao_Social, Nome_Fantasia, CNPJ, CPF, Local, Contato) VALUES
('Joao Vendedor ME', 'João Tech', NULL, '11122233344', 'São Paulo', '11666666666'),
('Eletro Mais LTDA', 'Eletro+', '55666777000122', NULL, 'Campinas', '19555555555');

-- 8. Produto_Pedido
INSERT INTO Produto_Pedido (idPedido, idProduto, Quantidade, Status) VALUES
(1, 1, 1, 'Disponível'),
(1, 5, 2, 'Disponível'),
(2, 2, 5, 'Disponível'),
(3, 3, 3, 'Disponível'),
(4, 5, 1, 'Disponível');

-- 9. Produto_Estoque
INSERT INTO Produto_Estoque (idProduto, idEstoque, Quantidade) VALUES
(1, 1, 100),
(2, 1, 50),
(3, 2, 200),
(4, 3, 20),
(5, 1, 80);

-- 10. Produto_Fornecedor
INSERT INTO Produto_Fornecedor (idFornecedor, idProduto) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(1, 5);

-- 11. Produto_Vendedor
INSERT INTO Produto_Vendedor (idVendedor, idProduto, Quantidade) VALUES
(1, 1, 5),
(2, 2, 10),
(2, 5, 15);

-- 12. Entrega
INSERT INTO Entrega (idPedido, Status_Entrega, Codigo_Rastreio, Data_Envio, Previsao_Entrega) VALUES
(1, 'Em trânsito', 'BR123456789', '2026-02-18', '2026-02-25'),
(3, 'Entregue', 'BR987654321', '2026-02-10', '2026-02-15'),
(4, 'Em trânsito', 'BR000111222', '2026-02-20', '2026-02-28');
