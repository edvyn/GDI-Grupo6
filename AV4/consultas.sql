/*
1. ALTER TABLE --ok
2. CREATE INDEX --ok
3. INSERT INTO --ok
4. UPDATE --ok
5. DELETE --ok
6. SELECT-FROM-WHERE --ok
7. BETWEEN --ok
8. IN --ok
9. LIKE --ok
10. IS NULL ou IS NOT NULL --ok
11. INNER JOIN --ok
12. MAX --ok
13. MIN --ok
14. AVG --ok
15. COUNT --ok
16. LEFT ou RIGHT ou FULL OUTER JOIN  --ok
17. SUBCONSULTA COM OPERADOR RELACIONAL --ok
18. SUBCONSULTA COM IN --ok
19. SUBCONSULTA COM ANY --ok
20. SUBCONSULTA COM ALL --ok
21. ORDER BY --ok
22. GROUP BY --ok
23. HAVING --ok
24. UNION ou INTERSECT ou MINUS --ok
25. CREATE VIEW --ok
26. GRANT / REVOKE --ok
*/


-- 6, 8, 9, 11, 21
-- Lista clientes que fizeram pedidos em outubro e moram em São Paulo ou noRio de Janeiro, e seu email não é do Gmail.

SELECT
    c.nome AS "Nome do Cliente",
    c.email AS "Email",
    ce.cidade AS "Cidade de Residência",
    p.data_pedido AS "Data do Pedido"
FROM
    Cliente c
    INNER JOIN Endereco_cliente ec ON c.cpf = ec.cpf_cliente
    INNER JOIN Cep_endereco ce ON ec.cep = ce.cep
    INNER JOIN Pedido p ON c.cpf = p.cpf_cliente
WHERE
    ce.cidade IN ('São Paulo', 'Rio de Janeiro')      -- Clientes em SP ou RJ
    AND c.email NOT LIKE '%@gmail.com'                -- Email n é gmail
    AND p.data_pedido >= DATE '2025-10-01'            -- filtro p data
    AND p.data_pedido <  DATE '2025-11-01'
ORDER BY
    p.data_pedido DESC;


-- 15, 22
-- ranking de clientes por número de pedidos feitos, ordenado do que mais fez p o que menos fez.

SELECT
    c.nome AS nome_cliente,
    COUNT(p.cod_pedido) AS total_pedidos
FROM
    Cliente c
JOIN
    Pedido p ON c.cpf = p.cpf_cliente
GROUP BY
    c.nome
ORDER BY
    total_pedidos DESC;



--1 -- Adiciona uma restrição para garantir que o valor total do pedido maior que zero
ALTER TABLE Pedido
ADD CONSTRAINT chk_valor_total CHECK (valor_total >= 0);

--2 -- Cria um índice para acelerar consultas que filtram por cod_pedido e data_envio na tabela Entrega
CREATE INDEX idx_entrega_pedido_data
ON Entrega (cod_pedido, data_envio);

--4 -- Atualiza o preço do produto com código 4 aumentando em 10% o valor atual
UPDATE Produto SET preco_produto = preco_produto * 1.10 WHERE cod_produto = 4;

--5 -- Remove o telefone '11999994444' do cliente com CPF '99988877766'
DELETE FROM telefone_cliente WHERE cpf_cliente = '99988877766' AND numero = '11999994444';

--3 -- Insere um novo endereço na tabela Cep_endereco
INSERT INTO Cep_endereco (cep, rua, cidade, estado) VALUES ('5030429', 'Rua Luis Augusto', 'Recife', 'PE');


--7,10,12,13,14,23

-- Relatório de avaliações de produtos na última semana, mostrando média, máxima e mínima das notas, apenas para produtos com nota média >= 4
SELECT
    p.nome_produto AS "Produto",
    AVG(cap.nota) AS "Nota Média",
    MAX(cap.nota) AS "Nota Máxima",
    MIN(cap.nota) AS "Nota Mínima",
    COUNT(cap.nota) AS "Qtd Avaliações" 
FROM
    Produto p
JOIN
    Cliente_Avalia_Produto cap ON p.cod_produto = cap.cod_produto
WHERE
    cap.data_avaliacao IS NOT NULL -- Apenas avaliações válidas
    AND cap.data_avaliacao BETWEEN (SYSDATE - 7) AND SYSDATE -- só conta avaliações d ultima semana
GROUP BY
    p.nome_produto
HAVING -- Filtra apenas produtos com boa nota média
    AVG(cap.nota) >= 4
ORDER BY
    "Nota Média" DESC;


--25
-- Cria uma view para analisar o desempenho de vendas dos produtos, incluindo total vendido e receita
CREATE VIEW vw_desempenho_produto AS
SELECT
    pr.cod_produto AS "ID Produto",
    pr.nome_produto AS "Nome do Produto",
    pr.preco_produto AS "Preço Unitário",
    f.nome_fornecedor AS "Fornecedor Principal",
    SUM(ct.quantidade_produto) AS "Total Vendido",
    SUM(ct.quantidade_produto * pr.preco_produto) AS "Receita Total Gerada"
FROM
    Produto pr
JOIN
    Contem ct ON pr.cod_produto = ct.cod_produto
LEFT JOIN -- Usamos LEFT JOIN para garantir que produtos sem fornecedor sejam listados
    Fornece fe ON pr.cod_produto = fe.cod_produto
LEFT JOIN
    Fornecedor f ON fe.cnpj_fornecedor = f.cnpj
GROUP BY
    pr.cod_produto,
    pr.nome_produto,
    pr.preco_produto,
    f.nome_fornecedor
ORDER BY
    "Receita Total Gerada" DESC;


-- 18 -- Mostra os nomes dos clientes que já avaliaram algum produto
SELECT
    nome
FROM
    Cliente
WHERE
    cpf IN (SELECT cpf_cliente FROM Cliente_Avalia_Produto);

--17 (>) -- Lista clientes que fizeram mais de 2 pedidos

SELECT
    c.nome AS "Nome do Cliente",
    (SELECT COUNT(*)
     FROM Pedido p
     WHERE p.cpf_cliente = c.cpf) AS "Quantidade de Pedidos"
FROM
    Cliente c
WHERE
    (SELECT COUNT(*)
     FROM Pedido p
     WHERE p.cpf_cliente = c.cpf) > 2;

--24 -- Lista nomes de todos os clientes e fornecedores, ordenados por tipo
SELECT
    nome AS "Nome",
    'Cliente' AS "Tipo"
FROM
    Cliente

UNION

SELECT
    nome_fornecedor AS "Nome",
    'Fornecedor' AS "Tipo"
FROM
    Fornecedor
ORDER BY
    "Tipo";

--16 -- Lista todos os clientes e indica se já fizeram login na biblioteca virtual

SELECT
    c.nome AS "Nome do Cliente",
    c.email AS "Email",
    CASE 
        WHEN c.ultimo_login IS NULL THEN 'Não'
        ELSE 'Sim'
    END AS "Já Logou?"
FROM
    Cliente c
LEFT OUTER JOIN
    Biblioteca_Virtual b ON c.cpf = b.cpf_cliente
ORDER BY
    "Já Logou?" DESC, c.nome;


--19 -- Lista fornecedores que fornecem produtos que receberam avaliação máxima (nota 5)
SELECT
    f.nome_fornecedor
FROM
    Fornecedor f
WHERE
    f.cnpj IN (
        SELECT
            fe.cnpj_fornecedor
        FROM
            Fornece fe
        WHERE
            fe.cod_produto = ANY (
                SELECT
                    cap.cod_produto
                FROM
                    Cliente_Avalia_Produto cap
                WHERE
                    cap.nota = 5 -- Filtra apenas avaliações com nota 5
            )
    )
ORDER BY
    f.nome_fornecedor;


--20 -- Lista clientes que tiveram todos os seus pedidos com status 'Pago'

SELECT
    c.nome AS "Nome do Cliente"
FROM
    Cliente c
WHERE
    'Pago' = ALL (
        SELECT p.status
        FROM Pedido p
        WHERE p.cpf_cliente = c.cpf
    );


--26 grant/revoke (n pega no livesql), mas basicamente GRANT concede permissões (select, insert, update, delete)
-- pra um certo usuário no bd e o REVOKE revoga as permissões.

