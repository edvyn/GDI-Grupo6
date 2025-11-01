/* CHECKLIST
        CREATE TABLE --OK
        INSERT INTO  --OK
        CLÁUSULA CONSTRAINT EM CREATE TABLE --OK
        CREATE SEQUENCE --OK
        CLÁUSULA CHECK EM CREATE TABLE --ok
 */



-- tabelas independentes


-- Cep_endereco
CREATE TABLE Cep_endereco (
    cep CHAR(8) PRIMARY KEY,
    rua VARCHAR2(100) NOT NULL,
    cidade VARCHAR2(50) NOT NULL,
    estado CHAR(2) NOT NULL,
    CONSTRAINT chk_cep_estado CHECK (estado IN ('AC','AL','AP','AM','BA','CE','DF','ES','GO','MA',
                                                'MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN','RS',
                                                'RO','RR','SC','SP','SE','TO'))
);

-- Fornecedor
CREATE TABLE Fornecedor (
    cnpj CHAR(14) PRIMARY KEY,
    nome_fornecedor VARCHAR2(100) NOT NULL,
    CONSTRAINT uq_fornecedor_nome UNIQUE (nome_fornecedor)
);

-- Produto
CREATE TABLE Produto (
    cod_produto NUMBER PRIMARY KEY,
    nome_produto VARCHAR2(100) NOT NULL,
    descricao_produto VARCHAR2(4000),
    preco_produto NUMBER(10,2) NOT NULL,
    qtd_estoque NUMBER NOT NULL,
    CONSTRAINT chk_preco_produto CHECK (preco_produto >= 0),
    CONSTRAINT chk_qtd_estoque CHECK (qtd_estoque >= 0)
);

-- Cliente
CREATE TABLE Cliente (
    cpf CHAR(11) PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    data_adesao DATE NOT NULL,
    ultimo_login DATE,
    cpf_indicador CHAR(11),
    CONSTRAINT fk_cliente_indicador FOREIGN KEY (cpf_indicador)
        REFERENCES Cliente(cpf),
    CONSTRAINT chk_cpf_cliente CHECK (LENGTH(cpf) = 11),
    CONSTRAINT chk_email_cliente CHECK (email LIKE '%_@_%._%'),
    CONSTRAINT uq_cliente_email UNIQUE (email)
);

-- Endereco_cliente
CREATE TABLE Endereco_cliente (
    cpf_cliente CHAR(11),
    cep CHAR(8),
    numero NUMBER,
    PRIMARY KEY (cpf_cliente, cep, numero),
    CONSTRAINT fk_endereco_cliente FOREIGN KEY (cpf_cliente)
        REFERENCES Cliente(cpf),
    CONSTRAINT fk_endereco_cep FOREIGN KEY (cep)
        REFERENCES Cep_endereco(cep),
    CONSTRAINT chk_numero_endereco CHECK (numero > 0)
);


-- telefone_cliente
CREATE TABLE telefone_cliente (
    cpf_cliente CHAR(11),
    numero VARCHAR2(20),
    PRIMARY KEY (cpf_cliente, numero),
    CONSTRAINT fk_telefone_cliente FOREIGN KEY (cpf_cliente)
        REFERENCES Cliente(cpf),
    CONSTRAINT chk_numero_telefone CHECK (LENGTH(numero) >= 8)
);

-- Biblioteca_Virtual
CREATE TABLE Biblioteca_Virtual (
    cpf_cliente CHAR(11) PRIMARY KEY,
    ultima_modificacao DATE,
    CONSTRAINT fk_biblioteca_cliente FOREIGN KEY (cpf_cliente)
        REFERENCES Cliente(cpf)
);

-- Livro
CREATE TABLE Livro (
    cod_produto NUMBER PRIMARY KEY,
    titulo VARCHAR2(200) NOT NULL,
    formato VARCHAR2(50),
    editora VARCHAR2(100),
    ano_publicacao NUMBER(4),
    CONSTRAINT fk_livro_produto FOREIGN KEY (cod_produto)
        REFERENCES Produto(cod_produto),
    CONSTRAINT uq_livro_titulo_editora UNIQUE (titulo, editora)
);

-- autores_livro
CREATE TABLE autores_livro (
    cod_produto NUMBER,
    autor VARCHAR2(100),
    PRIMARY KEY (cod_produto, autor),
    CONSTRAINT fk_autor_livro FOREIGN KEY (cod_produto)
        REFERENCES Livro(cod_produto),
    CONSTRAINT chk_autor_nome CHECK (LENGTH(autor) > 0)
);

-- Artigo_Papelaria
CREATE TABLE Artigo_Papelaria (
    cod_produto NUMBER PRIMARY KEY,
    marca VARCHAR2(50),
    categoria VARCHAR2(50),
    CONSTRAINT fk_artigo_produto FOREIGN KEY (cod_produto)
        REFERENCES Produto(cod_produto),
    CONSTRAINT chk_categoria_artigo CHECK (categoria IS NOT NULL AND LENGTH(categoria) > 0),
    CONSTRAINT uq_artigo_marca_categoria UNIQUE (marca, categoria)
);

-- Pedido
CREATE TABLE Pedido (
    cod_pedido NUMBER PRIMARY KEY,
    cpf_cliente CHAR(11),
    data_pedido DATE NOT NULL,
    forma_pagamento VARCHAR2(50),
    status VARCHAR2(20),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (cpf_cliente)
        REFERENCES Cliente(cpf),
    CONSTRAINT chk_status_pedido CHECK (status IN ('Pendente','Pago','Cancelado')),
    CONSTRAINT chk_forma_pagamento CHECK (forma_pagamento IN ('Cartão','Boleto','Pix'))
);

-- Entrega
CREATE TABLE Entrega (
    cod_rastreamento NUMBER PRIMARY KEY,
    data_envio DATE,
    data_recebimento DATE,
    cod_pedido NUMBER,
    CONSTRAINT fk_entrega_pedido FOREIGN KEY (cod_pedido)
        REFERENCES Pedido(cod_pedido),
    CONSTRAINT chk_datas_entrega CHECK (data_envio IS NOT NULL AND (data_recebimento IS NULL OR data_recebimento >= data_envio))
);

-- Endereco_entrega
CREATE TABLE Endereco_entrega (
    cod_rastreamento NUMBER,
    cep CHAR(8),
    numero NUMBER,
    PRIMARY KEY (cod_rastreamento),
    CONSTRAINT fk_endereco_entrega FOREIGN KEY (cod_rastreamento)
        REFERENCES Entrega(cod_rastreamento),
    CONSTRAINT fk_ee_cep FOREIGN KEY (cep)
        REFERENCES Cep_endereco(cep),
    CONSTRAINT chk_numero_entrega CHECK (numero > 0)
);

-- Contem
CREATE TABLE Contem (
    cod_pedido NUMBER,
    cod_produto NUMBER,
    quantidade_produto NUMBER NOT NULL,
    PRIMARY KEY (cod_pedido, cod_produto),
    CONSTRAINT fk_contem_pedido FOREIGN KEY (cod_pedido)
        REFERENCES Pedido(cod_pedido),
    CONSTRAINT fk_contem_produto FOREIGN KEY (cod_produto)
        REFERENCES Produto(cod_produto),
    CONSTRAINT chk_quantidade_produto CHECK (quantidade_produto > 0)
);

-- Fornece
CREATE TABLE Fornece (
    cnpj_fornecedor CHAR(14),
    cod_produto NUMBER,
    PRIMARY KEY (cnpj_fornecedor, cod_produto),
    CONSTRAINT fk_fornece_fornecedor FOREIGN KEY (cnpj_fornecedor)
        REFERENCES Fornecedor(cnpj),
    CONSTRAINT fk_fornece_produto FOREIGN KEY (cod_produto)
        REFERENCES Produto(cod_produto)
);

-- Armazena
CREATE TABLE Armazena (
    id_biblioteca CHAR(11),
    id_livro NUMBER,
    data_adicao DATE,
    PRIMARY KEY (id_biblioteca, id_livro),
    CONSTRAINT fk_armazena_biblioteca FOREIGN KEY (id_biblioteca)
        REFERENCES Biblioteca_Virtual(cpf_cliente),
    CONSTRAINT fk_armazena_livro FOREIGN KEY (id_livro)
        REFERENCES Livro(cod_produto)
);

-- Cliente_Avalia_Produto
CREATE TABLE Cliente_Avalia_Produto (
    cpf_cliente CHAR(11),
    cod_pedido NUMBER,
    cod_produto NUMBER,
    nota NUMBER(1),
    comentario VARCHAR2(4000),
    data_avaliacao DATE,
    PRIMARY KEY (cpf_cliente, cod_pedido, cod_produto),
    CONSTRAINT fk_avalia_cliente FOREIGN KEY (cpf_cliente)
        REFERENCES Cliente(cpf),
    CONSTRAINT fk_avalia_pedido FOREIGN KEY (cod_pedido)
        REFERENCES Pedido(cod_pedido),
    CONSTRAINT fk_avalia_produto FOREIGN KEY (cod_produto)
        REFERENCES Produto(cod_produto),
    CONSTRAINT chk_nota CHECK (nota BETWEEN 0 AND 5)
);

-- sequências para gerar chaves primárias automáticas
CREATE SEQUENCE seq_pedido
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_produto
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_entrega
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

