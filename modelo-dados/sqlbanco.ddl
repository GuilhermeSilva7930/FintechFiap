-- Gerado por Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   em:        2024-05-19 00:57:13 BRT
--   site:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE cartao (
    cd_cartao     INTEGER NOT NULL,
    cd_conta      INTEGER NOT NULL,
    nro_cartao    VARCHAR2(20),
    tipo          VARCHAR2(20),
    data_validade DATE,
    cd_seguranca  VARCHAR2(4)
);

ALTER TABLE cartao ADD CONSTRAINT cartao_pk PRIMARY KEY ( cd_cartao );

CREATE TABLE cliente (
    cd_cliente INTEGER NOT NULL,
    nome       VARCHAR2(100),
    cpf        VARCHAR2(11),
    email      VARCHAR2(100)
);

ALTER TABLE cliente ADD CONSTRAINT cliente_pk PRIMARY KEY ( cd_cliente );

CREATE TABLE clienteconta (
    cd_cliente          INTEGER NOT NULL,
    cd_conta            INTEGER NOT NULL,
    tipo_relacionamento VARCHAR2(20)
);

ALTER TABLE clienteconta ADD CONSTRAINT clienteconta_pk PRIMARY KEY ( cd_cliente,
                                                                      cd_conta );

CREATE TABLE conta (
    cd_conta     INTEGER NOT NULL,
    nro_conta    VARCHAR2(20),
    tipo_conta   CHAR(1),
    saldo        NUMBER(10, 2),
    data_criacao DATE
);

ALTER TABLE conta
    ADD CONSTRAINT herdam_lov CHECK ( tipo_conta IN ( 'C', 'P' ) );

ALTER TABLE conta ADD CONSTRAINT herdam_nn CHECK ( tipo_conta IS NOT NULL );

ALTER TABLE conta ADD CONSTRAINT conta_pk PRIMARY KEY ( cd_conta );

CREATE TABLE contacorrente (
    cd_conta       INTEGER NOT NULL,
    limite_credito NUMBER(10, 2),
    taxa_juros     NUMBER(5, 2)
);

ALTER TABLE contacorrente ADD CONSTRAINT contacorrente_pk PRIMARY KEY ( cd_conta );

CREATE TABLE contapoupanca (
    cd_conta        INTEGER NOT NULL,
    taxa_rendimento NUMBER(5, 2)
);

ALTER TABLE contapoupanca ADD CONSTRAINT contapoupanca_pk PRIMARY KEY ( cd_conta );

CREATE TABLE gasto (
    cd_gasto  INTEGER NOT NULL,
    cd_cartao INTEGER NOT NULL,
    data      DATE,
    valor     NUMBER(10, 2),
    categoria VARCHAR2(50),
    descricao VARCHAR2(255)
);

ALTER TABLE gasto ADD CONSTRAINT gasto_pk PRIMARY KEY ( cd_gasto );

CREATE TABLE transacao (
    cd_transacao INTEGER NOT NULL,
    cd_conta     INTEGER NOT NULL,
    data         DATE,
    tipo         VARCHAR2(20),
    valor        NUMBER(10, 2),
    descricao    VARCHAR2(255)
);

ALTER TABLE transacao ADD CONSTRAINT transacao_pk PRIMARY KEY ( cd_transacao );

ALTER TABLE cartao
    ADD CONSTRAINT cartao_conta_fk FOREIGN KEY ( cd_conta )
        REFERENCES conta ( cd_conta );

ALTER TABLE clienteconta
    ADD CONSTRAINT clienteconta_cliente_fk FOREIGN KEY ( cd_cliente )
        REFERENCES cliente ( cd_cliente );

ALTER TABLE clienteconta
    ADD CONSTRAINT clienteconta_conta_fk FOREIGN KEY ( cd_conta )
        REFERENCES conta ( cd_conta );

ALTER TABLE contacorrente
    ADD CONSTRAINT contacorrente_conta_fk FOREIGN KEY ( cd_conta )
        REFERENCES conta ( cd_conta );

ALTER TABLE contapoupanca
    ADD CONSTRAINT contapoupanca_conta_fk FOREIGN KEY ( cd_conta )
        REFERENCES conta ( cd_conta );

ALTER TABLE gasto
    ADD CONSTRAINT gasto_cartao_fk FOREIGN KEY ( cd_cartao )
        REFERENCES cartao ( cd_cartao );

ALTER TABLE transacao
    ADD CONSTRAINT transacao_conta_fk FOREIGN KEY ( cd_conta )
        REFERENCES conta ( cd_conta );

CREATE OR REPLACE TRIGGER fkntm_clienteconta BEFORE
    UPDATE OF cd_cliente ON clienteconta
BEGIN
    raise_application_error(-20225, 'Non Transferable FK constraint  on table CLIENTECONTA is violated');
END;
/

CREATE OR REPLACE TRIGGER arc_herdam_contacorrente BEFORE
    INSERT OR UPDATE OF cd_conta ON contacorrente
    FOR EACH ROW
DECLARE
    d CHAR(1);
BEGIN
    SELECT
        a.tipo_conta
    INTO d
    FROM
        conta a
    WHERE
        a.cd_conta = :new.cd_conta;

    IF ( d IS NULL OR d <> 'C' ) THEN
        raise_application_error(-20223, 'FK CONTACORRENTE_CONTA_FK in Table CONTACORRENTE violates Arc constraint on Table CONTA - discriminator column tipo_conta doesn''t have value ''C'''
        );
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/

CREATE OR REPLACE TRIGGER arc_herdam_contapoupanca BEFORE
    INSERT OR UPDATE OF cd_conta ON contapoupanca
    FOR EACH ROW
DECLARE
    d CHAR(1);
BEGIN
    SELECT
        a.tipo_conta
    INTO d
    FROM
        conta a
    WHERE
        a.cd_conta = :new.cd_conta;

    IF ( d IS NULL OR d <> 'P' ) THEN
        raise_application_error(-20223, 'FK CONTAPOUPANCA_CONTA_FK in Table CONTAPOUPANCA violates Arc constraint on Table CONTA - discriminator column tipo_conta doesn''t have value ''P'''
        );
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/



-- Relatório do Resumo do Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             8
-- CREATE INDEX                             0
-- ALTER TABLE                             17
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           3
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
