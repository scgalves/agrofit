SET SQL DIALECT 3;

SET NAMES WIN1252;

SET CLIENTLIB 'C:\Projetos\Delphi\Viasoft\Agrofit\bin\fbclient.dll';

CREATE DATABASE '127.0.0.1/3053:C:\Projetos\Delphi\Viasoft\Agrofit\DB\AGROFIT.FDB'
USER 'SYSDBA' PASSWORD 'masterkey'
PAGE_SIZE 8192
DEFAULT CHARACTER SET WIN1252 COLLATION WIN_PTBR;

/******************************************************************************/

CREATE GENERATOR GEN_DEFENSIVO_AGRICOLA_ID;
SET GENERATOR GEN_DEFENSIVO_AGRICOLA_ID TO 0;

/******************************************************************************/

CREATE TABLE DEFENSIVO_AGRICOLA (
    ID                           INTEGER NOT NULL,
    NUMERO_REGISTRO              VARCHAR(20) NOT NULL,
    MARCA_COMERCIAL              VARCHAR(200),
    CLASSE_CATEGORIA_AGRONOMICA  VARCHAR(200),
    TITULAR_REGISTRO             VARCHAR(200),
    CLASSIFICACAO_TOXICOLOGICA   VARCHAR(200)
);

/******************************************************************************/

ALTER TABLE DEFENSIVO_AGRICOLA ADD CONSTRAINT UNQ_NUMERO_REGISTRO UNIQUE (NUMERO_REGISTRO);

/******************************************************************************/

ALTER TABLE DEFENSIVO_AGRICOLA ADD CONSTRAINT PK_DEFENSIVO_AGRICOLA PRIMARY KEY (ID);

/******************************************************************************/

SET TERM ^ ;

/******************************************************************************/

/* Trigger: TRG_DEFENSIVO_AGRICOLA_BI */
CREATE TRIGGER TRG_DEFENSIVO_AGRICOLA_BI FOR DEFENSIVO_AGRICOLA
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
  IF (NEW.ID IS NULL) THEN
    NEW.ID = GEN_ID(GEN_DEFENSIVO_AGRICOLA_ID, 1);
END^

SET TERM ; ^

/******************************************************************************/

DESCRIBE TABLE DEFENSIVO_AGRICOLA
'Tabela de defensivos agrícolas consultados da API Agrofit';

/******************************************************************************/

DESCRIBE FIELD ID TABLE DEFENSIVO_AGRICOLA
'Chave primária - autoincremento';

DESCRIBE FIELD NUMERO_REGISTRO TABLE DEFENSIVO_AGRICOLA
'Número de registro do defensivo';

DESCRIBE FIELD MARCA_COMERCIAL TABLE DEFENSIVO_AGRICOLA
'Marcas comerciais do produto (separadas por vírgula)';

DESCRIBE FIELD CLASSE_CATEGORIA_AGRONOMICA TABLE DEFENSIVO_AGRICOLA
'Classes/categorias agronômicas do produto (separadas por vírgula)';

DESCRIBE FIELD TITULAR_REGISTRO TABLE DEFENSIVO_AGRICOLA
'Empresa titular do registro';

DESCRIBE FIELD CLASSIFICACAO_TOXICOLOGICA TABLE DEFENSIVO_AGRICOLA
'Classificação toxicológica do produto';