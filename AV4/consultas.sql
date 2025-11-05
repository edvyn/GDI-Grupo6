/*
1. ALTER TABLE
2. CREATE INDEX
3. INSERT INTO
4. UPDATE
5. DELETE
6. SELECT-FROM-WHERE --ok
7. BETWEEN
8. IN --ok
9. LIKE --ok
10. IS NULL ou IS NOT NULL 
11. INNER JOIN --ok
12. MAX
13. MIN
14. AVG
15. COUNT --ok
16. LEFT ou RIGHT ou FULL OUTER JOIN
17. SUBCONSULTA COM OPERADOR RELACIONAL
18. SUBCONSULTA COM IN
19. SUBCONSULTA COM ANY
20. SUBCONSULTA COM ALL
21. ORDER BY --ok
22. GROUP BY --ok
23. HAVING
24. UNION ou INTERSECT ou MINUS
25. CREATE VIEW
26. GRANT / REVOKE
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




