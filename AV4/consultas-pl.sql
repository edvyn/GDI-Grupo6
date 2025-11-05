/*
1. USO DE RECORD --ok
2. USO DE ESTRUTURA DE DADOS DO TIPO TABLE --ok
3. BLOCO ANÔNIMO --ok
4. CREATE PROCEDURE --ok
5. CREATE FUNCTION --ok
6. %TYPE --ok
7. %ROWTYPE --ok
8. IF ELSIF --ok
9. CASE WHEN --ok
10. LOOP EXIT WHEN --ok
11. WHILE LOOP --ok
12. FOR IN LOOP --ok
13. SELECT … INTO --ok
14. CURSOR (OPEN, FETCH e CLOSE)
15. EXCEPTION WHEN --ok
16. USO DE PARÂMETROS (IN, OUT ou IN OUT)
17. CREATE OR REPLACE PACKAGE
18. CREATE OR REPLACE PACKAGE BODY
19. CREATE OR REPLACE TRIGGER (COMANDO)
20. CREATE OR REPLACE TRIGGER (LINHA)
*/

-- 1, 7, 13, 15
-- RECORD com dados de um cliente específico
DECLARE
    -- Cria um record com a estrutura da tabela Cliente
    v_cliente Cliente%ROWTYPE;
BEGIN
    -- Busca um cliente específico
    SELECT *
    INTO v_cliente
    FROM Cliente
    WHERE cpf = '12345678901';

    DBMS_OUTPUT.PUT_LINE('Nome: ' || v_cliente.nome);
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_cliente.email);
    DBMS_OUTPUT.PUT_LINE('Data de adesão: ' || TO_CHAR(v_cliente.data_adesao, 'DD/MM/YYYY'));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Cliente não encontrado.');
END;
/

-- 2, 6, 12
-- Armazenar nomes de produtos em uma TABLE e percorrê-los
DECLARE
    TYPE t_lista_produtos IS TABLE OF Produto.nome_produto%TYPE INDEX BY PLS_INTEGER;
    v_produtos t_lista_produtos;
    i PLS_INTEGER := 0;
BEGIN
    -- Preenche a tabela com produtos existentes
    FOR r IN (SELECT nome_produto FROM Produto WHERE ROWNUM <= 5) LOOP
        i := i + 1;
        v_produtos(i) := r.nome_produto;
    END LOOP;

    -- Exibe os produtos armazenados
    FOR j IN 1..v_produtos.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Produto ' || j || ': ' || v_produtos(j));
    END LOOP;
END;
/

-- 3
-- Calcular valor total de pedido
DECLARE
    v_cod_pedido Pedido.cod_pedido%TYPE := 1;
    v_total NUMBER := 0;
BEGIN
    SELECT SUM(c.quantidade_produto * p.preco_produto)
    INTO v_total
    FROM Contem c
    JOIN Produto p ON c.cod_produto = p.cod_produto
    WHERE c.cod_pedido = v_cod_pedido;

    DBMS_OUTPUT.PUT_LINE('Valor total do pedido ' || v_cod_pedido || ': R$' || v_total);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Pedido não encontrado.');
END;
/

-- 4
-- Registrar novo cliente
CREATE OR REPLACE PROCEDURE inserir_cliente (
    p_cpf Cliente.cpf%TYPE,
    p_nome Cliente.nome%TYPE,
    p_email Cliente.email%TYPE,
    p_data_adesao DATE
) AS
BEGIN
    INSERT INTO Cliente (cpf, nome, email, data_adesao)
    VALUES (p_cpf, p_nome, p_email, p_data_adesao);

    DBMS_OUTPUT.PUT_LINE('Cliente ' || p_nome || ' inserido com sucesso.');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: CPF ou e-mail já cadastrado.');
END;
/
DECLARE
    v_nome_antigo   Cliente.nome%TYPE;
    v_data_antiga   Cliente.data_adesao%TYPE;
    v_nome_novo     Cliente.nome%TYPE;
    v_data_nova     Cliente.data_adesao%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Antes do INSERT');

    BEGIN
        SELECT nome, data_adesao
        INTO v_nome_antigo, v_data_antiga
        FROM Cliente
        WHERE data_adesao = (SELECT MAX(data_adesao) FROM Cliente);

        DBMS_OUTPUT.PUT_LINE('Cliente mais recente: ' || v_nome_antigo ||
                             ' (' || TO_CHAR(v_data_antiga, 'DD/MM/YYYY') || ')');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nenhum cliente encontrado.');
    END;

    -- Inserir novo cliente
    inserir_cliente('88899900011', 'Carla Mendes', 'carla.mendes@exemplo.com', SYSDATE);

    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Depois do INSERT');

    -- Verifica novamente o cliente mais recente
    BEGIN
        SELECT nome, data_adesao
        INTO v_nome_novo, v_data_nova
        FROM Cliente
        WHERE data_adesao = (SELECT MAX(data_adesao) FROM Cliente);

        DBMS_OUTPUT.PUT_LINE('Cliente mais recente: ' || v_nome_novo ||
                             ' (' || TO_CHAR(v_data_nova, 'DD/MM/YYYY') || ')');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nenhum cliente encontrado após o insert.');
    END;
END;
/

-- 5
-- Total dos pedidos
CREATE OR REPLACE FUNCTION calcular_total_pedido (
    p_cod_pedido Pedido.cod_pedido%TYPE
) RETURN NUMBER
AS
    v_total NUMBER := 0;
BEGIN
    SELECT SUM(c.quantidade_produto * p.preco_produto)
    INTO v_total
    FROM Contem c
    JOIN Produto p ON c.cod_produto = p.cod_produto
    WHERE c.cod_pedido = p_cod_pedido;

    RETURN NVL(v_total, 0);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/
DECLARE
    v_result NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Totais de todos os pedidos ===');

    FOR r IN (SELECT cod_pedido FROM Pedido ORDER BY cod_pedido) LOOP
        v_result := calcular_total_pedido(r.cod_pedido);
        DBMS_OUTPUT.PUT_LINE('Pedido ' || r.cod_pedido || ': R$' || TO_CHAR(v_result, '999G999G990D00'));
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('===================================');
END;
/

-- 8
-- Imprimir textos diferentes por status do pedido
DECLARE
    v_cod_pedido Pedido.cod_pedido%TYPE := 1;
    v_status Pedido.status%TYPE;
BEGIN
    SELECT status INTO v_status
    FROM Pedido
    WHERE cod_pedido = v_cod_pedido;

    IF v_status = 'Pendente' THEN
        DBMS_OUTPUT.PUT_LINE('O pedido ainda está pendente de pagamento.');
    ELSIF v_status = 'Pago' THEN
        DBMS_OUTPUT.PUT_LINE('O pedido já foi pago e está em processamento.');
    ELSIF v_status = 'Cancelado' THEN
        DBMS_OUTPUT.PUT_LINE('O pedido foi cancelado pelo cliente.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Status desconhecido.');
    END IF;
END;
/

-- 9
-- Agrupar produtos por faixa de preço
BEGIN
    DBMS_OUTPUT.PUT_LINE('Classificação de Produtos');

    FOR r IN (SELECT nome_produto, preco_produto FROM Produto WHERE ROWNUM <= 5) LOOP
        CASE
            WHEN r.preco_produto < 20 THEN
                DBMS_OUTPUT.PUT_LINE(r.nome_produto || ' > Produto barato');
            WHEN r.preco_produto BETWEEN 20 AND 100 THEN
                DBMS_OUTPUT.PUT_LINE(r.nome_produto || ' > Produto de preço médio');
            WHEN r.preco_produto > 100 THEN
                DBMS_OUTPUT.PUT_LINE(r.nome_produto || ' > Produto premium');
            ELSE
                DBMS_OUTPUT.PUT_LINE(r.nome_produto || ' > Categoria indefinida');
        END CASE;
    END LOOP;
END;
/

-- 10
-- Exibindo 5 primeiros pedidos da loja
DECLARE
    v_contador NUMBER := 0;
    v_total_pedidos NUMBER;
    v_cod Pedido.cod_pedido%TYPE;
    v_data Pedido.data_pedido%TYPE;
BEGIN
    SELECT COUNT(*) INTO v_total_pedidos FROM Pedido;

    DBMS_OUTPUT.PUT_LINE('Primeiros pedidos');

    FOR r IN (SELECT cod_pedido, data_pedido FROM Pedido ORDER BY data_pedido) LOOP
        v_contador := v_contador + 1;
        v_cod := r.cod_pedido;
        v_data := r.data_pedido;

        DBMS_OUTPUT.PUT_LINE('Código do pedido: ' || v_cod ||
                             ' (' || TO_CHAR(v_data, 'DD/MM/YYYY') || ')');

        EXIT WHEN v_contador >= 5;  -- Sai do loop após os 5 pedidos
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Loop encerrado após ' || v_contador || ' pedidos.');
END;
/

-- 11
-- Em que foram gastos os primeiros R$ 500
DECLARE
    v_total_acumulado NUMBER := 0;
    v_limite NUMBER := 500;
    v_gasto_item NUMBER;
    v_indice NUMBER := 1;

    v_cod_produto Produto.cod_produto%TYPE;
    v_nome_produto Produto.nome_produto%TYPE;
    v_preco NUMBER;
    v_qtd NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('===== Computando onde foram gastos os primeiros R$ ' || v_limite || ' =====');

    WHILE v_total_acumulado < v_limite LOOP
        -- Seleciona o próximo item de compra (produto + qtd + preço)
        SELECT cod_produto, nome_produto, preco_produto, quantidade_produto
        INTO v_cod_produto, v_nome_produto, v_preco, v_qtd
        FROM (
            SELECT p.cod_produto, p.nome_produto, p.preco_produto, c.quantidade_produto,
                   ROW_NUMBER() OVER (ORDER BY c.cod_pedido, p.cod_produto) AS rn
            FROM Contem c
            JOIN Produto p ON c.cod_produto = p.cod_produto
        )
        WHERE rn = v_indice;

        v_gasto_item := v_preco * v_qtd;

        v_total_acumulado := v_total_acumulado + v_gasto_item;

        DBMS_OUTPUT.PUT_LINE(
            'Produto: ' || v_nome_produto ||
            ' | Gasto neste item: R$' || TO_CHAR(v_gasto_item, '999G999G990D00') ||
            ' | Total acumulado: R$' || TO_CHAR(v_total_acumulado, '999G999G990D00')
        );

        -- Sai do loop se o limite for atingido
        EXIT WHEN v_total_acumulado >= v_limite;

        v_indice := v_indice + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('===== Fim: total de R$ ' || TO_CHAR(v_total_acumulado, '999G999G990D00') || ' atingido =====');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Fim da lista de produtos. Total gasto: R$' || v_total_acumulado);
END;
/

