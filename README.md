# Desafio Dio: Primeiro Projeto Lógico de Banco de Dados
Neste desafio, você terá a oportunidade de criar seu primeiro projeto lógico de banco de dados utilizando o MySQL. O objetivo é replicar a modelagem de um banco de dados para um cenário de e-commerce. Prepare-se para aplicar seus conhecimentos em modelagem de banco de dados e traduzir os requisitos do cenário em uma estrutura lógica coerente usando o MySQL.

# Projeto Lógico de Banco de Dados - E-commerce

## Objetivo
O objetivo deste projeto foi transformar um modelo conceitual (diagrama EER) em um esquema lógico de banco de dados MySQL, aplicando regras de negócio complexas e refinando a estrutura para garantir integridade e performance.

## Modificações no Modelo Base
O modelo original foi significativamente aprimorado para atender aos requisitos de negócio modernos:

1.  **Distinção de Clientes (PF/PJ):**
    *   Implementada diferenciação entre Pessoa Física (CPF) e Pessoa Jurídica (CNPJ).
    *   Adicionada uma `CONSTRAINT` de verificação (`CHECK`) para garantir que um cliente seja exclusivamente PF ou PJ, evitando redundância e inconsistência de dados.
2.  **Gestão de Pagamentos:**
    *   Criação da tabela `Pagamento` para permitir que um cliente cadastre múltiplos métodos de pagamento (Cartão, Boleto, Pix).
    *   Relacionamento entre `Pedido` e `Pagamento` para registrar qual método foi utilizado em cada transação.
3.  **Módulo de Entregas:**
    *   Inclusão da tabela `Entrega` para rastreio detalhado.
    *   Campos como `Status_Entrega` (ENUM) e `Codigo_Rastreio` para maior controle logístico.
4.  **Refinamento de Constraints:**
    *   Uso extensivo de `AUTO_INCREMENT` para chaves primárias.
    *   Definição de valores `DEFAULT` para campos de status e frete.
    *   Uso de `ENUM` para padronização de categorias, status de pedidos e entregas.
5.  **Otimização de Relacionamentos N:N:**
    *   Todas as tabelas pivot (como `Produto_Pedido`, `Produto_Estoque`, `Produto_Vendedor`) possuem chaves primárias compostas e integridade referencial robusta (`ON DELETE CASCADE/SET NULL`).

## Estrutura do Projeto
- `modelo_conceitual/`: Contém o diagrama EER e o arquivo do MySQL Workbench.
- `scripts_sql/1_schema_creation.sql`: Script DDL para criação do banco de dados e tabelas.
- `scripts_sql/2_data_insertion.sql`: Script DML com dados fictícios para testes.
- `scripts_sql/3_queries.sql`: Consultas SQL para análise de dados e perguntas de negócio.

## Exemplos de Queries Realizadas
O projeto conta com queries que utilizam:
- Recuperações simples com `SELECT`.
- Filtros complexos com `WHERE`.
- **Atributos derivados e expressões matemáticas** (ex: cálculo de valor total por item).
- **Ordenação customizada** com `ORDER BY`.
- **Agrupamentos e filtros de grupo** (`GROUP BY` e `HAVING`).
- **Análises de Negócio Avançadas:**
    - Identificação de vendedores com maior variedade de produtos (catálogo amplo).
    - Mapeamento de produtos com alta demanda (presentes em múltiplos pedidos).
    - Status consolidado de entregas por cliente e pedido.
- Múltiplas junções (`JOIN`, `INNER JOIN`, `LEFT JOIN`) para consolidar informações de Clientes, Pedidos, Fornecedores e Vendedores.
