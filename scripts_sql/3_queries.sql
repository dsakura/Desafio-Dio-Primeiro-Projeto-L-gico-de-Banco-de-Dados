-- Queries for E-commerce Project
-- MySQL Script for Business Analysis

USE `ecommerce` ;

-- 1. Recuperações simples com SELECT *
-- Listar todos os clientes
SELECT * FROM Cliente;

-- Listar todos os produtos
SELECT * FROM Produto;

-- 2. Filtros com WHERE
-- Listar produtos da categoria 'Eletrônico' com valor acima de 1000
SELECT Pname, Categoria, Valor 
FROM Produto 
WHERE Categoria = 'Eletrônico' AND Valor > 1000;

-- Listar clientes do tipo Pessoa Jurídica (PJ)
SELECT Pnome, CNPJ, Endereco 
FROM Cliente 
WHERE Tipo_Cliente = 'PJ';

-- 3. Atributos derivados (Expressões)
-- Calcular o valor total de cada produto no pedido (Quantidade * Valor)
-- Incluindo o frete rateado ou total
SELECT 
    p.idPedido, 
    prod.Pname, 
    pp.Quantidade, 
    prod.Valor AS Preco_Unitario,
    (pp.Quantidade * prod.Valor) AS Subtotal_Produto,
    p.Frete,
    ((pp.Quantidade * prod.Valor) + p.Frete) AS Total_com_Frete
FROM Pedido p
JOIN Produto_Pedido pp ON p.idPedido = pp.idPedido
JOIN Produto prod ON pp.idProduto = prod.idProduto;

-- 4. Ordenação dos dados com ORDER BY
-- Listar produtos por avaliação (do maior para o menor) e depois por nome
SELECT Pname, Avaliacao, Valor 
FROM Produto 
ORDER BY Avaliacao DESC, Pname ASC;

-- 5. Junções entre tabelas (JOIN, INNER JOIN, LEFT JOIN)
-- Quantos pedidos foram feitos por cada cliente?
SELECT 
    c.idCliente, 
    CONCAT(c.Pnome, ' ', c.Sobrenome) AS Nome_Cliente, 
    COUNT(p.idPedido) AS Numero_de_Pedidos
FROM Cliente c
INNER JOIN Pedido p ON c.idCliente = p.idCliente
GROUP BY c.idCliente;

-- Listar clientes e seus respectivos pedidos, mesmo os que não fizeram pedidos (LEFT JOIN)
SELECT 
    CONCAT(c.Pnome, ' ', c.Sobrenome) AS Nome_Completo,
    p.idPedido,
    p.Status_Pedido
FROM Cliente c
LEFT JOIN Pedido p ON c.idCliente = p.idCliente;

-- Relação de Fornecedor e Produto (Qual fornecedor fornece qual produto?)
SELECT 
    f.Razao_Social AS Fornecedor,
    p.Pname AS Produto
FROM Fornecedor f
INNER JOIN Produto_Fornecedor pf ON f.idFornecedor = pf.idFornecedor
INNER JOIN Produto p ON pf.idProduto = p.idProduto;

-- Relação de Vendedor Terceiro, Produto e Quantidade em estoque do vendedor
SELECT 
    v.Nome_Fantasia AS Vendedor,
    p.Pname AS Produto,
    pv.Quantidade
FROM Vendedor_Terceiro v
INNER JOIN Produto_Vendedor pv ON v.idVendedor = pv.idVendedor
INNER JOIN Produto p ON pv.idProduto = p.idProduto;

-- 6. Filtros em grupos usando HAVING
-- Vendedores com catálogo amplo (Vendedores com mais de 1 produto associado)
SELECT 
    v.Razao_Social, 
    COUNT(pv.idProduto) AS qtd_produtos_ofertados
FROM 
    Vendedor_Terceiro v
INNER JOIN 
    Produto_Vendedor pv ON v.idVendedor = pv.idVendedor
GROUP BY 
    v.idVendedor
HAVING 
    qtd_produtos_ofertados >= 1
ORDER BY 
    qtd_produtos_ofertados DESC;

-- Relação de Produtos com alta demanda (Produtos que aparecem em mais de 1 pedido)
SELECT 
    p.Pname, 
    COUNT(pp.idPedido) AS vezes_pedido
FROM 
    Produto p
INNER JOIN 
    Produto_Pedido pp ON p.idProduto = pp.idProduto
GROUP BY 
    p.idProduto
HAVING 
    vezes_pedido >= 1
ORDER BY 
    vezes_pedido DESC;

-- Listar clientes que fizeram mais de 1 pedido
SELECT 
    c.idCliente, 
    CONCAT(c.Pnome, ' ', c.Sobrenome) AS Nome_Cliente, 
    COUNT(p.idPedido) AS Total_Pedidos
FROM Cliente c
JOIN Pedido p ON c.idCliente = p.idCliente
GROUP BY c.idCliente
HAVING Total_Pedidos >= 1;

-- 7. Atributos Derivados e Análise de Valor (Dica: Quantity * Valor)
-- Valor total por item em cada pedido, filtrando pedidos com valor total acima de 100
SELECT 
    p.idPedido,
    c.Pnome AS Cliente,
    prod.Pname AS Produto,
    pp.Quantidade,
    prod.Valor AS Valor_Unitario,
    (pp.Quantidade * prod.Valor) AS Valor_Total_Item
FROM Pedido p
JOIN Cliente c ON p.idCliente = c.idCliente
JOIN Produto_Pedido pp ON p.idPedido = pp.idPedido
JOIN Produto prod ON pp.idProduto = prod.idProduto
WHERE (pp.Quantidade * prod.Valor) > 100
ORDER BY Valor_Total_Item DESC;

-- 8. Consulta Complexa: Status de entrega por Cliente e Pedido
-- Fornece uma visão geral de onde está a mercadoria do cliente
SELECT 
    c.Pnome,
    p.idPedido,
    p.Status_Pedido,
    e.Status_Entrega,
    e.Codigo_Rastreio
FROM Cliente c
JOIN Pedido p ON c.idCliente = p.idCliente
LEFT JOIN Entrega e ON p.idPedido = e.idPedido
ORDER BY p.idPedido;
