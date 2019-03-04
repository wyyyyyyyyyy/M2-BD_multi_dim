-- -----------------------------------------------------------------------------
--             Génération d'une base de données pour
--                      Oracle Version 10g
-- -----------------------------------------------------------------------------
--      Nom de la base : ED
--      Projet : DIA
-- -----------------------------------------------------------------------------
DROP TABLE DIFFUSERPU CASCADE CONSTRAINTS;

DROP TABLE COUTARTICLE CASCADE CONSTRAINTS;

DROP TABLE LIVRER CASCADE CONSTRAINTS;

DROP TABLE ABONNER CASCADE CONSTRAINTS;

DROP TABLE PAYER CASCADE CONSTRAINTS;

DROP TABLE ECRIREARTICLE CASCADE CONSTRAINTS;

DROP TABLE INSTITUTFORMATION CASCADE CONSTRAINTS;

DROP TABLE PAYS CASCADE CONSTRAINTS;

DROP TABLE TYPEJOUR CASCADE CONSTRAINTS;

DROP TABLE CENTREDISTRIBUTEUR CASCADE CONSTRAINTS;

DROP TABLE VILLE CASCADE CONSTRAINTS;

DROP TABLE RUBRIQUE CASCADE CONSTRAINTS;

DROP TABLE CLIENT CASCADE CONSTRAINTS;

DROP TABLE JOURNALISTE CASCADE CONSTRAINTS;

DROP TABLE NUMERO CASCADE CONSTRAINTS;

DROP TABLE DIPLOME CASCADE CONSTRAINTS;

DROP TABLE TYPEPU CASCADE CONSTRAINTS;

DROP TABLE PUBLICATION CASCADE CONSTRAINTS;

-- -----------------------------------------------------------------------------
--       CREATION DE LA BASE 
-- -----------------------------------------------------------------------------

--CREATE DATABASE ED;

-- -----------------------------------------------------------------------------
--       TABLE : INSTITUTFORMATION
-- -----------------------------------------------------------------------------

CREATE TABLE INSTITUTFORMATION
   (
    CODEIF NUMBER(4)  NOT NULL,
    NOMIF VARCHAR2(100)  NULL
,   CONSTRAINT PK_INSTITUTFORMATION PRIMARY KEY (CODEIF)  
   ) ;

-- -----------------------------------------------------------------------------
--       TABLE : PAYS
-- -----------------------------------------------------------------------------

CREATE TABLE PAYS
   (
    CODEP NUMBER(5)  NOT NULL,
    NOMP VARVARCHAR22(75)  NULL
,   CONSTRAINT PK_PAYS PRIMARY KEY (CODEP)  
   ) ;

-- -----------------------------------------------------------------------------
--       TABLE : TYPEJOUR
-- -----------------------------------------------------------------------------

CREATE TABLE TYPEJOUR
   (
    CODETYJ NUMBER(4)  NOT NULL,
    NOMTYJ VARCHAR2(75)  NULL,
    PRIXCAR NUMBER  NULL CHECK(PRIXCAR >0)
,   CONSTRAINT PK_TYPEJOUR PRIMARY KEY (CODETYJ)  
   ) ;

-- -----------------------------------------------------------------------------
--       TABLE : CENTREDISTRIBUTEUR
-- -----------------------------------------------------------------------------

CREATE TABLE CENTREDISTRIBUTEUR
   (
    CODECD NUMBER(4)  NOT NULL,
    CODEP NUMBER(5)  NOT NULL,
    NOMCD VARCHAR2(50)  NULL,
    VILLECD VARCHAR2(50)  NULL
,   CONSTRAINT PK_CENTREDISTRIBUTEUR PRIMARY KEY (CODECD)  
   ) ;

-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE CENTREDISTRIBUTEUR
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_CENTREDISTRIBUTEUR_PAYS
     ON CENTREDISTRIBUTEUR (CODEP ASC)
    ;

-- -----------------------------------------------------------------------------
--       TABLE : VILLE
-- -----------------------------------------------------------------------------

CREATE TABLE VILLE
   (
    CODEV NUMBER(7)  NOT NULL,
    CODECD NUMBER(4)  NOT NULL,
    NOMV VARCHAR2(50)  NULL
,   CONSTRAINT PK_VILLE PRIMARY KEY (CODEV)  
   ) ;

-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE VILLE
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_VILLE_CENTREDISTRIBUTEUR
     ON VILLE (CODECD ASC)
    ;

-- -----------------------------------------------------------------------------
--       TABLE : CLIENT
-- -----------------------------------------------------------------------------

CREATE TABLE CLIENT
   (
    CODEC NUMBER(4)  NOT NULL,
    CODEV NUMBER(7)  NOT NULL,
    NOMC VARCHAR2(50)  NULL,
    PRENOMC VARCHAR2(50)  NULL
,   CONSTRAINT PK_CLIENT PRIMARY KEY (CODEC)  
   ) ;

-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE CLIENT
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_CLIENT_VILLE
     ON CLIENT (CODEV ASC)
    ;

-- -----------------------------------------------------------------------------
--       TABLE : JOURNALISTE
-- -----------------------------------------------------------------------------

CREATE TABLE JOURNALISTE
   (
    CODEJ NUMBER(4)  NOT NULL,
    CODEDI NUMBER(4)  NULL,
    CODETYJ NUMBER(4)  NOT NULL,
    NOMJ VARCHAR2(50)  NULL,
    PRENOMJ VARCHAR2(50)  NULL,
    DATEOBT DATE  NULL
,   CONSTRAINT PK_JOURNALISTE PRIMARY KEY (CODEJ)  
   ) ;

-- -----------------------------------------------------------------------------
--       TABLE : DIPLOME
-- -----------------------------------------------------------------------------

CREATE TABLE DIPLOME
   (
    CODEDI NUMBER(4)  NOT NULL,
    CODEIF NUMBER(4)  NOT NULL,
    NOMDI VARCHAR2(80)  NULL
,   CONSTRAINT PK_DIPLOME PRIMARY KEY (CODEDI)  
   ) ;

-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE DIPLOME
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_DIPLOME_INSTITUTFORMATION
     ON DIPLOME (CODEIF ASC)
    ;

-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE JOURNALISTE
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_JOURNALISTE_DIPLOME
     ON JOURNALISTE (CODEDI ASC)
    ;

CREATE  INDEX I_FK_JOURNALISTE_TYPEJOUR
     ON JOURNALISTE (CODETYJ ASC)
    ;

-- -----------------------------------------------------------------------------
--       TABLE : TYPEPU
-- -----------------------------------------------------------------------------

CREATE TABLE TYPEPU
   (
    CODETY NUMBER(4)  NOT NULL,
    NOMTY VARCHAR2(75)  NULL
,   CONSTRAINT PK_TYPEPU PRIMARY KEY (CODETY)  
   ) ;

-- -----------------------------------------------------------------------------
--       TABLE : PUBLICATION
-- -----------------------------------------------------------------------------

CREATE TABLE PUBLICATION
   (
    CODEPU NUMBER(4)  NOT NULL CHECK (CODEPU > 0),
    CODEJ NUMBER(4)  NOT NULL,
    CODETY NUMBER(4)  NOT NULL,
    NOMPU VARCHAR2(75)  NULL,
    DATECREATPU DATE  NULL,
    DATEFINPU DATE  NULL,
    PERIODICITE VARCHAR2(30)  NULL,
    GROUPEPRESSE VARCHAR2(100)  NULL
,   CONSTRAINT PK_PUBLICATION PRIMARY KEY (CODEPU)  
   ) ;

-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE PUBLICATION
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_PUBLICATION_JOURNALISTE
     ON PUBLICATION (CODEJ ASC)
    ;

CREATE  INDEX I_FK_PUBLICATION_TYPEPU
     ON PUBLICATION (CODETY ASC)
    ;

-- -----------------------------------------------------------------------------
--       TABLE : RUBRIQUE
-- -----------------------------------------------------------------------------

CREATE TABLE RUBRIQUE
   (
    CODERU NUMBER(4)  NOT NULL,
    CODEPU NUMBER(4)  NOT NULL,
    CODEJ NUMBER(4)  NOT NULL,
    NOMRU VARVARCHAR22(50)  NULL
,   CONSTRAINT PK_RUBRIQUE PRIMARY KEY (CODERU)  
   ) ;

-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE RUBRIQUE
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_RUBRIQUE_PUBLICATION
     ON RUBRIQUE (CODEPU ASC)
    ;

CREATE  INDEX I_FK_RUBRIQUE_JOURNALISTE
     ON RUBRIQUE (CODEJ ASC)
    ;

-- -----------------------------------------------------------------------------
--       TABLE : NUMERO
-- -----------------------------------------------------------------------------

CREATE TABLE NUMERO
   (
    CODENO NUMBER(5)  NOT NULL,
    CODEPU NUMBER(4)  NOT NULL,
    DATENO DATE  NULL
,   CONSTRAINT PK_NUMERO PRIMARY KEY (CODENO)  
   ) ;

-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE NUMERO
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_NUMERO_PUBLICATION
     ON NUMERO (CODEPU ASC)
    ;

-- -----------------------------------------------------------------------------
--       TABLE : DIFFUSERPU
-- -----------------------------------------------------------------------------

CREATE TABLE DIFFUSERPU
   (
    CODEPU NUMBER(4)  NOT NULL,
    ANNEE NUMBER(4)  NOT NULL,
    NBDIFFUSIONS NUMBER(9)  NULL CHECK( NBDIFFUSIONS >0)
,   CONSTRAINT PK_DIFFUSERPU PRIMARY KEY (CODEPU, ANNEE)  
   ) ;

-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE DIFFUSERPU
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_DIFFUSERPU_PUBLICATION
     ON DIFFUSERPU (CODEPU ASC)
    ;

-- -----------------------------------------------------------------------------
--       TABLE : COUTARTICLE
-- -----------------------------------------------------------------------------

CREATE TABLE COUTARTICLE
   (
    CODEJ NUMBER(4)  NOT NULL,
    CODERU NUMBER(4)  NOT NULL,
    FORFAITART NUMBER  NULL CHECK(FORFAITART >0)
,   CONSTRAINT PK_COUTARTICLE PRIMARY KEY (CODEJ, CODERU)  
   ) ;

-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE COUTARTICLE
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_COUTARTICLE_JOURNALISTE
     ON COUTARTICLE (CODEJ ASC)
    ;

CREATE  INDEX I_FK_COUTARTICLE_RUBRIQUE
     ON COUTARTICLE (CODERU ASC)
    ;

-- -----------------------------------------------------------------------------
--       TABLE : LIVRER
-- -----------------------------------------------------------------------------

CREATE TABLE LIVRER
   (
    CODENO NUMBER(5)  NOT NULL,
    CODEC NUMBER(4)  NOT NULL
,   CONSTRAINT PK_LIVRER PRIMARY KEY (CODENO, CODEC)  
   ) ;

-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE LIVRER
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_LIVRER_NUMERO
     ON LIVRER (CODENO ASC)
    ;

CREATE  INDEX I_FK_LIVRER_CLIENT
     ON LIVRER (CODEC ASC)
    ;

-- -----------------------------------------------------------------------------
--       TABLE : ABONNER
-- -----------------------------------------------------------------------------

CREATE TABLE ABONNER
   (
    CODEC NUMBER(4)  NOT NULL,
    CODEPU NUMBER(4)  NOT NULL,
    DATEDEB DATE  NOT NULL,
    PRIXNUMAB NUMBER  NULL CHECK(PRIXNUMAB >0),
    NBNUM NUMBER(4)  NULL CHECK(NBNUM >0)
,   CONSTRAINT PK_ABONNER PRIMARY KEY (CODEC, CODEPU, DATEDEB)  
   ) ;

-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE ABONNER
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_ABONNER_CLIENT
     ON ABONNER (CODEC ASC)
    ;

CREATE  INDEX I_FK_ABONNER_PUBLICATION
     ON ABONNER (CODEPU ASC)
    ;

-- -----------------------------------------------------------------------------
--       TABLE : PAYER
-- -----------------------------------------------------------------------------

CREATE TABLE PAYER
   (
    CODEP NUMBER(4)  NOT NULL,
    CODEPU NUMBER(4)  NOT NULL,
    PRIXNUMPUBLIC NUMBER  NULL CHECK(PRIXNUMPUBLIC >0)
,   CONSTRAINT PK_PAYER PRIMARY KEY (CODEP, CODEPU)  
   ) ;

-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE PAYER
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_PAYER_PAYS
     ON PAYER (CODEP ASC)
    ;

CREATE  INDEX I_FK_PAYER_PUBLICATION
     ON PAYER (CODEPU ASC)
    ;

-- -----------------------------------------------------------------------------
--       TABLE : ECRIREARTICLE
-- -----------------------------------------------------------------------------

CREATE TABLE ECRIREARTICLE
   (
    CODEJ NUMBER(4)  NOT NULL,
    CODENO NUMBER(5)  NOT NULL,
    CODERU NUMBER(4)  NOT NULL,
    NBCAR NUMBER(5)  NULL CHECK (NBCAR > 0),
    NBART NUMBER(2)  NULL CHECK (NBART > 0)
,   CONSTRAINT PK_ECRIREARTICLE PRIMARY KEY (CODEJ, CODENO, CODERU)  
   ) ;

-- -----------------------------------------------------------------------------
--       INDEX DE LA TABLE ECRIREARTICLE
-- -----------------------------------------------------------------------------

CREATE  INDEX I_FK_ECRIREARTICLE_JOURNALISTE
     ON ECRIREARTICLE (CODEJ ASC)
    ;

CREATE  INDEX I_FK_ECRIREARTICLE_NUMERO
     ON ECRIREARTICLE (CODENO ASC)
    ;

CREATE  INDEX I_FK_ECRIREARTICLE_RUBRIQUE
     ON ECRIREARTICLE (CODERU ASC)
    ;


-- -----------------------------------------------------------------------------
--       CREATION DES REFERENCES DE TABLE
-- -----------------------------------------------------------------------------


ALTER TABLE CENTREDISTRIBUTEUR ADD (
     CONSTRAINT FK_CENTREDISTRIBUTEUR_PAYS
          FOREIGN KEY (CODEP)
               REFERENCES PAYS (CODEP))   ;

ALTER TABLE VILLE ADD (
     CONSTRAINT FK_VILLE_CENTREDISTRIBUTEUR
          FOREIGN KEY (CODECD)
               REFERENCES CENTREDISTRIBUTEUR (CODECD))   ;

ALTER TABLE RUBRIQUE ADD (
     CONSTRAINT FK_RUBRIQUE_PUBLICATION
          FOREIGN KEY (CODEPU)
               REFERENCES PUBLICATION (CODEPU))   ;

ALTER TABLE RUBRIQUE ADD (
     CONSTRAINT FK_RUBRIQUE_JOURNALISTE
          FOREIGN KEY (CODEJ)
               REFERENCES JOURNALISTE (CODEJ))   ;

ALTER TABLE CLIENT ADD (
     CONSTRAINT FK_CLIENT_VILLE
          FOREIGN KEY (CODEV)
               REFERENCES VILLE (CODEV))   ;

ALTER TABLE JOURNALISTE ADD (
     CONSTRAINT FK_JOURNALISTE_DIPLOME
          FOREIGN KEY (CODEDI)
               REFERENCES DIPLOME (CODEDI))   ;

ALTER TABLE JOURNALISTE ADD (
     CONSTRAINT FK_JOURNALISTE_TYPEJOUR
          FOREIGN KEY (CODETYJ)
               REFERENCES TYPEJOUR (CODETYJ))   ;

ALTER TABLE NUMERO ADD (
     CONSTRAINT FK_NUMERO_PUBLICATION
          FOREIGN KEY (CODEPU)
               REFERENCES PUBLICATION (CODEPU))   ;

ALTER TABLE PUBLICATION ADD (
     CONSTRAINT FK_PUBLICATION_JOURNALISTE
          FOREIGN KEY (CODEJ)
               REFERENCES JOURNALISTE (CODEJ))   ;

ALTER TABLE PUBLICATION ADD (
     CONSTRAINT FK_PUBLICATION_TYPEPU
          FOREIGN KEY (CODETY)
               REFERENCES TYPEPU (CODETY))   ;

ALTER TABLE DIPLOME ADD (
     CONSTRAINT FK_DIPLOME_INSTITUTFORMATION
          FOREIGN KEY (CODEIF)
               REFERENCES INSTITUTFORMATION (CODEIF))   ;

ALTER TABLE DIFFUSERPU ADD (
     CONSTRAINT FK_DIFFUSERPU_PUBLICATION
          FOREIGN KEY (CODEPU)
               REFERENCES PUBLICATION (CODEPU))   ;

ALTER TABLE COUTARTICLE ADD (
     CONSTRAINT FK_COUTARTICLE_JOURNALISTE
          FOREIGN KEY (CODEJ)
               REFERENCES JOURNALISTE (CODEJ))   ;

ALTER TABLE COUTARTICLE ADD (
     CONSTRAINT FK_COUTARTICLE_RUBRIQUE
          FOREIGN KEY (CODERU)
               REFERENCES RUBRIQUE (CODERU))   ;

ALTER TABLE LIVRER ADD (
     CONSTRAINT FK_LIVRER_NUMERO
          FOREIGN KEY (CODENO)
               REFERENCES NUMERO (CODENO))   ;

ALTER TABLE LIVRER ADD (
     CONSTRAINT FK_LIVRER_CLIENT
          FOREIGN KEY (CODEC)
               REFERENCES CLIENT (CODEC))   ;

ALTER TABLE ABONNER ADD (
     CONSTRAINT FK_ABONNER_CLIENT
          FOREIGN KEY (CODEC)
               REFERENCES CLIENT (CODEC))   ;

ALTER TABLE ABONNER ADD (
     CONSTRAINT FK_ABONNER_PUBLICATION
          FOREIGN KEY (CODEPU)
               REFERENCES PUBLICATION (CODEPU))   ;

ALTER TABLE PAYER ADD (
     CONSTRAINT FK_PAYER_PAYS
          FOREIGN KEY (CODEP)
               REFERENCES PAYS (CODEP))   ;

ALTER TABLE PAYER ADD (
     CONSTRAINT FK_PAYER_PUBLICATION
          FOREIGN KEY (CODEPU)
               REFERENCES PUBLICATION (CODEPU))   ;

ALTER TABLE ECRIREARTICLE ADD (
     CONSTRAINT FK_ECRIREARTICLE_JOURNALISTE
          FOREIGN KEY (CODEJ)
               REFERENCES JOURNALISTE (CODEJ))   ;

ALTER TABLE ECRIREARTICLE ADD (
     CONSTRAINT FK_ECRIREARTICLE_NUMERO
          FOREIGN KEY (CODENO)
               REFERENCES NUMERO (CODENO))   ;

ALTER TABLE ECRIREARTICLE ADD (
     CONSTRAINT FK_ECRIREARTICLE_RUBRIQUE
          FOREIGN KEY (CODERU)
               REFERENCES RUBRIQUE (CODERU))   ;

-- -----------------------------------------------------------------------------
--                GENERATION DES CONTRAINTES
-- -----------------------------------------------------------------------------
ALTER TABLE PUBLICATION
ADD CONSTRAINT check_date
  CHECK (DATEFINPU > DATECREATPU);
  
ALTER TABLE PUBLICATION
ADD CONSTRAINT liste_GP
  CHECK (GROUPEPRESSE IN ('Hachette','Amaury','Marie-Claire'));
  
ALTER TABLE PUBLICATION
ADD CONSTRAINT liste_Periodicite
  CHECK (Periodicite IN ('Quotidienne','Bihebdomadaire','Hebdomadaire','Bimensuel','Mensuel',
  'Bimestriel','Trimestriel','Quadrimestre','Semestriel','Annuel','Biennal'));
-- -----------------------------------------------------------------------------
--                FIN DE GENERATION
-- -----------------------------------------------------------------------------