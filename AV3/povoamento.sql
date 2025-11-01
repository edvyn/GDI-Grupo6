-- Cep_endereco
INSERT INTO Cep_endereco (cep, rua, cidade, estado) VALUES ('30140071', 'Rua dos Timbiras', 'Belo Horizonte', 'MG');
INSERT INTO Cep_endereco (cep, rua, cidade, estado) VALUES ('20040002', 'Rua do Ouvidor', 'Rio de Janeiro', 'RJ');
INSERT INTO Cep_endereco (cep, rua, cidade, estado) VALUES ('01001000', 'Praça da Sé', 'São Paulo', 'SP');
INSERT INTO Cep_endereco (cep, rua, cidade, estado) VALUES ('30140072', 'Av. Afonso Pena', 'Belo Horizonte', 'MG');
INSERT INTO Cep_endereco (cep, rua, cidade, estado) VALUES ('20040003', 'Rua das Laranjeiras', 'Rio de Janeiro', 'RJ');

-- Fornecedores
INSERT INTO Fornecedor (cnpj, nome_fornecedor) VALUES ('12345678000199', 'Editora Nova');
INSERT INTO Fornecedor (cnpj, nome_fornecedor) VALUES ('98765432000155', 'Papelaria Brasil');
INSERT INTO Fornecedor (cnpj, nome_fornecedor) VALUES ('11122233000144', 'Editora Alfa');

-- Clientes
INSERT INTO Cliente (cpf, nome, email, data_adesao, ultimo_login, cpf_indicador)
VALUES ('12345678901', 'João Silva', 'joao.silva@gmail.com', 
        TO_DATE('2023-01-10 09:30:00','YYYY-MM-DD HH24:MI:SS'), 
        TO_DATE('2025-10-01 15:45:00','YYYY-MM-DD HH24:MI:SS'), 
        NULL);

INSERT INTO Cliente (cpf, nome, email, data_adesao, ultimo_login, cpf_indicador)
VALUES ('10987654321', 'Maria Souza', 'maria.souza@gmail.com', 
        TO_DATE('2024-03-15 10:00:00','YYYY-MM-DD HH24:MI:SS'), 
        NULL, 
        '12345678901');

INSERT INTO Cliente (cpf, nome, email, data_adesao, ultimo_login, cpf_indicador)
VALUES ('11122233344', 'Pedro Lima', 'pedro.lima@outlook.com', 
        TO_DATE('2024-06-10 08:15:00','YYYY-MM-DD HH24:MI:SS'), 
        NULL, 
        NULL);

INSERT INTO Cliente (cpf, nome, email, data_adesao, ultimo_login, cpf_indicador)
VALUES ('55566677788', 'Ana Costa', 'ana.costa@gmail.com', 
        TO_DATE('2024-07-12 11:45:00','YYYY-MM-DD HH24:MI:SS'), 
        TO_DATE('2025-09-20 14:30:00','YYYY-MM-DD HH24:MI:SS'), 
        '12345678901');

INSERT INTO Cliente (cpf, nome, email, data_adesao, ultimo_login, cpf_indicador)
VALUES ('99988877766', 'Lucas Fernandes', 'lucas.fernandes@yahoo.com', 
        TO_DATE('2025-01-05 12:00:00','YYYY-MM-DD HH24:MI:SS'), 
        NULL, 
        NULL);

-- Livros
INSERT INTO Produto (cod_produto, nome_produto, descricao_produto, preco_produto, qtd_estoque)
VALUES (seq_produto.NEXTVAL, 'Livro: Java Básico', 'Livro de introdução à programação Java', 120.00, 50);

INSERT INTO Produto (cod_produto, nome_produto, descricao_produto, preco_produto, qtd_estoque)
VALUES (seq_produto.NEXTVAL, 'Livro: Python Avançado', 'Livro para desenvolvedores avançados', 150.00, 30);

INSERT INTO Produto (cod_produto, nome_produto, descricao_produto, preco_produto, qtd_estoque)
VALUES (seq_produto.NEXTVAL, 'Livro: Banco de Dados', 'Conceitos e prática SQL', 130.00, 40);

-- Artigos de papelaria
INSERT INTO Produto (cod_produto, nome_produto, descricao_produto, preco_produto, qtd_estoque)
VALUES (seq_produto.NEXTVAL, 'Caderno Universitário', 'Caderno 100 folhas', 15.50, 200);

INSERT INTO Produto (cod_produto, nome_produto, descricao_produto, preco_produto, qtd_estoque)
VALUES (seq_produto.NEXTVAL, 'Caneta Esferográfica', 'Caneta azul 0.7mm', 3.50, 500);

-- Endereços de clientes (ajustado)
INSERT INTO Endereco_cliente (cpf_cliente, cep, numero) VALUES ('12345678901', '30140071', 100);
INSERT INTO Endereco_cliente (cpf_cliente, cep, numero) VALUES ('10987654321', '20040002', 200);
INSERT INTO Endereco_cliente (cpf_cliente, cep, numero) VALUES ('11122233344', '30140072', 300);
INSERT INTO Endereco_cliente (cpf_cliente, cep, numero) VALUES ('55566677788', '20040003', 400);
INSERT INTO Endereco_cliente (cpf_cliente, cep, numero) VALUES ('99988877766', '01001000', 500);

-- Telefones de clientes
INSERT INTO telefone_cliente (cpf_cliente, numero) VALUES ('12345678901', '31988887777');
INSERT INTO telefone_cliente (cpf_cliente, numero) VALUES ('10987654321', '21999998888');
INSERT INTO telefone_cliente (cpf_cliente, numero) VALUES ('11122233344', '31977776666');
INSERT INTO telefone_cliente (cpf_cliente, numero) VALUES ('55566677788', '21988885555');
INSERT INTO telefone_cliente (cpf_cliente, numero) VALUES ('99988877766', '11999994444');

-- Biblioteca virtual
INSERT INTO Biblioteca_Virtual (cpf_cliente, ultima_modificacao) VALUES ('12345678901', SYSDATE);
INSERT INTO Biblioteca_Virtual (cpf_cliente, ultima_modificacao) VALUES ('10987654321', SYSDATE);
INSERT INTO Biblioteca_Virtual (cpf_cliente, ultima_modificacao) VALUES ('11122233344', SYSDATE);
INSERT INTO Biblioteca_Virtual (cpf_cliente, ultima_modificacao) VALUES ('55566677788', SYSDATE);
INSERT INTO Biblioteca_Virtual (cpf_cliente, ultima_modificacao) VALUES ('99988877766', SYSDATE);

-- Livros
INSERT INTO Livro (cod_produto, titulo, formato, editora, ano_publicacao)
VALUES (1, 'Java Básico', 'Impresso', 'Editora Nova', 2022);

INSERT INTO Livro (cod_produto, titulo, formato, editora, ano_publicacao)
VALUES (2, 'Python Avançado', 'Impresso', 'Editora Alfa', 2023);

INSERT INTO Livro (cod_produto, titulo, formato, editora, ano_publicacao)
VALUES (3, 'Banco de Dados', 'Impresso', 'Editora Nova', 2021);

-- Autores livro
INSERT INTO autores_livro (cod_produto, autor) VALUES (1, 'Carlos Oliveira');
INSERT INTO autores_livro (cod_produto, autor) VALUES (2, 'Luciana Martins');
INSERT INTO autores_livro (cod_produto, autor) VALUES (3, 'Fernando Silva');

-- Artigos papelaria
INSERT INTO Artigo_Papelaria (cod_produto, marca, categoria) VALUES (4, 'Tilibra', 'Caderno');
INSERT INTO Artigo_Papelaria (cod_produto, marca, categoria) VALUES (5, 'Bic', 'Caneta');

-- Fornece
INSERT INTO Fornece (cnpj_fornecedor, cod_produto) VALUES ('12345678000199', 1);
INSERT INTO Fornece (cnpj_fornecedor, cod_produto) VALUES ('11122233000144', 2);
INSERT INTO Fornece (cnpj_fornecedor, cod_produto) VALUES ('12345678000199', 3);
INSERT INTO Fornece (cnpj_fornecedor, cod_produto) VALUES ('98765432000155', 4);
INSERT INTO Fornece (cnpj_fornecedor, cod_produto) VALUES ('98765432000155', 5);

-- Armazena
INSERT INTO Armazena (id_biblioteca, id_livro, data_adicao) VALUES ('12345678901', 1, SYSDATE);
INSERT INTO Armazena (id_biblioteca, id_livro, data_adicao) VALUES ('10987654321', 2, SYSDATE);
INSERT INTO Armazena (id_biblioteca, id_livro, data_adicao) VALUES ('11122233344', 3, SYSDATE);
INSERT INTO Armazena (id_biblioteca, id_livro, data_adicao) VALUES ('55566677788', 1, SYSDATE);
INSERT INTO Armazena (id_biblioteca, id_livro, data_adicao) VALUES ('99988877766', 2, SYSDATE);

-- Pedidos
INSERT INTO Pedido (cod_pedido, cpf_cliente, data_pedido, forma_pagamento, status)
VALUES (seq_pedido.NEXTVAL, '12345678901', TO_DATE('2025-10-15','YYYY-MM-DD'), 'Pix', 'Pago');

INSERT INTO Pedido (cod_pedido, cpf_cliente, data_pedido, forma_pagamento, status)
VALUES (seq_pedido.NEXTVAL, '10987654321', TO_DATE('2025-10-20','YYYY-MM-DD'), 'Cartão', 'Pendente');

INSERT INTO Pedido (cod_pedido, cpf_cliente, data_pedido, forma_pagamento, status)
VALUES (seq_pedido.NEXTVAL, '11122233344', TO_DATE('2025-10-22','YYYY-MM-DD'), 'Boleto', 'Pago');

INSERT INTO Pedido (cod_pedido, cpf_cliente, data_pedido, forma_pagamento, status)
VALUES (seq_pedido.NEXTVAL, '55566677788', TO_DATE('2025-10-23','YYYY-MM-DD'), 'Pix', 'Pendente');

INSERT INTO Pedido (cod_pedido, cpf_cliente, data_pedido, forma_pagamento, status)
VALUES (seq_pedido.NEXTVAL, '99988877766', TO_DATE('2025-10-25','YYYY-MM-DD'), 'Cartão', 'Pago');

-- Entregas
INSERT INTO Entrega (cod_rastreamento, data_envio, data_recebimento, cod_pedido)
VALUES (seq_entrega.NEXTVAL, TO_DATE('2025-10-16','YYYY-MM-DD'), TO_DATE('2025-10-18','YYYY-MM-DD'), 1);

INSERT INTO Entrega (cod_rastreamento, data_envio, data_recebimento, cod_pedido)
VALUES (seq_entrega.NEXTVAL, TO_DATE('2025-10-21','YYYY-MM-DD'), NULL, 2);

INSERT INTO Entrega (cod_rastreamento, data_envio, data_recebimento, cod_pedido)
VALUES (seq_entrega.NEXTVAL, TO_DATE('2025-10-23','YYYY-MM-DD'), TO_DATE('2025-10-25','YYYY-MM-DD'), 3);

INSERT INTO Entrega (cod_rastreamento, data_envio, data_recebimento, cod_pedido)
VALUES (seq_entrega.NEXTVAL, TO_DATE('2025-10-24','YYYY-MM-DD'), NULL, 4);

INSERT INTO Entrega (cod_rastreamento, data_envio, data_recebimento, cod_pedido)
VALUES (seq_entrega.NEXTVAL, TO_DATE('2025-10-26','YYYY-MM-DD'), TO_DATE('2025-10-27','YYYY-MM-DD'), 5);

-- Endereços de entrega
INSERT INTO Endereco_entrega (cod_rastreamento, cep, numero) VALUES (1, '30140071', 100);
INSERT INTO Endereco_entrega (cod_rastreamento, cep, numero) VALUES (2, '20040002', 200);
INSERT INTO Endereco_entrega (cod_rastreamento, cep, numero) VALUES (3, '30140072', 300);
INSERT INTO Endereco_entrega (cod_rastreamento, cep, numero) VALUES (4, '20040003', 400);
INSERT INTO Endereco_entrega (cod_rastreamento, cep, numero) VALUES (5, '01001000', 500);

-- Contem (itens dos pedidos)
INSERT INTO Contem (cod_pedido, cod_produto, quantidade_produto) VALUES (1, 1, 1);
INSERT INTO Contem (cod_pedido, cod_produto, quantidade_produto) VALUES (2, 4, 2);
INSERT INTO Contem (cod_pedido, cod_produto, quantidade_produto) VALUES (3, 2, 1);
INSERT INTO Contem (cod_pedido, cod_produto, quantidade_produto) VALUES (4, 5, 10);
INSERT INTO Contem (cod_pedido, cod_produto, quantidade_produto) VALUES (5, 3, 2);

-- Avaliações de clientes
INSERT INTO Cliente_Avalia_Produto (cpf_cliente, cod_pedido, cod_produto, nota, comentario, data_avaliacao)
VALUES ('12345678901', 1, 1, 5, 'Excelente livro para iniciantes', SYSDATE);

INSERT INTO Cliente_Avalia_Produto (cpf_cliente, cod_pedido, cod_produto, nota, comentario, data_avaliacao)
VALUES ('10987654321', 2, 4, 5, 'Caderno de ótima qualidade', SYSDATE);

INSERT INTO Cliente_Avalia_Produto (cpf_cliente, cod_pedido, cod_produto, nota, comentario, data_avaliacao)
VALUES ('11122233344', 3, 2, 4, 'Livro avançado, ótimo conteúdo', SYSDATE);

INSERT INTO Cliente_Avalia_Produto (cpf_cliente, cod_pedido, cod_produto, nota, comentario, data_avaliacao)
VALUES ('55566677788', 4, 5, 5, 'Caneta muito boa', SYSDATE);

INSERT INTO Cliente_Avalia_Produto (cpf_cliente, cod_pedido, cod_produto, nota, comentario, data_avaliacao)
VALUES ('99988877766', 5, 3, 5, 'Livro de banco de dados excelente', SYSDATE);
