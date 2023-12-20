# Preparando o modelo de dados

CREATE SCHEMA cap10;

CREATE TABLE cap10.TB_CLIENTE ( 
	sk_cliente           int  NOT NULL  AUTO_INCREMENT  PRIMARY KEY,
	nk_id_cliente        varchar(20),
	nm_cliente           varchar(100),
	nm_cidade_cliente    varchar(50),
	by_aceita_campanha   char(1),
	desc_cep             varchar(8)      
 );

CREATE TABLE cap10.TB_LOCALIDADE ( 
	sk_localidade        int  NOT NULL  AUTO_INCREMENT  PRIMARY KEY,
	nk_id_localidade     varchar(20),
	nm_localidade        varchar(50),
	nm_cidade_localidade varchar(50),
	nm_regiao_localidade varchar(50)      
 );

CREATE TABLE cap10.TB_PRODUTO ( 
	sk_produto           int  NOT NULL  AUTO_INCREMENT  PRIMARY KEY,
	nk_id_produto        varchar(20),
	desc_sku             varchar(50),
	nm_produto           varchar(50),
	nm_categoria_produto varchar(30),
	nm_marca_produto     varchar(30)      
 );

CREATE TABLE cap10.TB_TEMPO ( 
	sk_data              int  NOT NULL PRIMARY KEY,
	data                 date,
	nr_ano               int,
	nr_mes               int,
	nr_dia               int,
	nr_trimestre         int,
	nr_semana            int,
	nm_dia_semana        varchar(10) NOT NULL,
	nm_mes               VARCHAR(10) NOT NULL,
	flag_feriado         CHAR(1) DEFAULT 'f',
	flag_fim_de_semana   CHAR(1) DEFAULT 'f'    
 );

CREATE TABLE cap10.TB_VENDA ( 
	sk_cliente           int  NOT NULL,
	sk_produto           int  NOT NULL,
	sk_localidade        int  NOT NULL,
	sk_data              int  NOT NULL,
	valor_venda          decimal(5,2),
	quantidade_venda     int      ,
	CONSTRAINT pk_TB_VENDA PRIMARY KEY ( sk_cliente, sk_produto, sk_localidade, sk_data )
 );
