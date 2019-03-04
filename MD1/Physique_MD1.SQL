-------------------------------------------
-- Créer la dimension temporelle
-------------------------------------------
CREATE MATERIALIZED VIEW TEMPS_MD
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS SELECT distinct DateNO AS DATE_MD,
		  TO_CHAR(DateNO,'ww/yyyy') AS Semaine,
		  TO_CHAR(DateNO,'mm/yyyy') AS Mois,
		  TO_CHAR(DateNO,'YYYY') AS Annee
	FROM PJDIA_YV.Numero;
------
ALTER TABLE TEMPS_MD ADD CONSTRAINT pk_TEMPS_MD PRIMARY KEY(DATE_MD);
------
CREATE DIMENSION TEMPS_DIM
	LEVEL N_Date IS (TEMPS_MD.DATE_MD)
	LEVEL N_Semaine IS (TEMPS_MD.SEMAINE)
	LEVEL N_Mois IS (TEMPS_MD.MOIS)
	LEVEL N_Annee IS (TEMPS_MD.ANNEE)	
HIERARCHY H_s (N_Date 
	CHILD OF N_Semaine 
	CHILD OF N_Annee)
HIERARCHY H_m (N_Date 
	CHILD OF N_Mois 
	CHILD OF N_Annee)	;	   

-------------------------------------------
-- Créer la dimension de Journaliste
-------------------------------------------
CREATE MATERIALIZED VIEW Journaliste_MD
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS SELECT j.CodeJ,j.NomJ,j.PrenomJ,j.Dateobt AS DateObtenu,
		  t.CodeTYJ AS CodeTypeJ,t.nomtyj as NomTypeJ,t.PrixCar,
		  d.CodeDI AS CodeDip,d.nomdi as NomDip,
		  i.codeif as CodeInstitutFormation,i.nomif as NomInstitutFormation
	FROM PJDIA_YV.Journaliste j, PJDIA_YV.TypeJour t,PJDIA_YV.diplome d,PJDIA_YV.INSTITUTFORMATION i
    WHERE j.codetyj = t.codetyj and d.codedi = j.codedi and d.codeif = i.codeif;
  
CREATE DIMENSION Journaliste_DIM
	LEVEL N_Codej IS (Journaliste_MD.CodeJ)
	LEVEL N_Typej IS (Journaliste_MD.CodeTypeJ)
	LEVEL N_codedip IS (Journaliste_MD.CodeDip)
	LEVEL N_codeif IS (Journaliste_MD.CodeInstitutFormation)
-----
ALTER TABLE Journaliste_MD ADD CONSTRAINT pk_Journaliste_MD PRIMARY KEY(CodeJ);
-----	
HIERARCHY H_typeJ	(
	N_Codej CHILD OF N_Typej)
			 
HIERARCHY H_dip	(
	N_Codej CHILD OF N_codedip
		    CHILD OF N_codeif )			 

ATTRIBUTE N_Codej DETERMINES Journaliste_MD.NomJ
ATTRIBUTE N_Codej DETERMINES Journaliste_MD.PrenomJ
ATTRIBUTE N_Codej DETERMINES Journaliste_MD.DateObtenu
ATTRIBUTE N_Typej DETERMINES Journaliste_MD.NomTypeJ
ATTRIBUTE N_Typej DETERMINES Journaliste_MD.PrixCar
ATTRIBUTE N_codedip DETERMINES Journaliste_MD.NomDip
ATTRIBUTE N_codeif DETERMINES Journaliste_MD.NomInstitutFormation
; 

-------------------------------------------
-- Créer la dimension de Publication
-------------------------------------------
 CREATE MATERIALIZED VIEW Publication_MD
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS SELECT p.CodePU,p.NomPU,p.DateCreatPU AS DateCreat,p.DateFinPU AS DateFin,
		  p.Periodicite,p.GroupePresse,p.CodeTY AS CodeTypePU,t.NomTY AS NomTypePU,
		  j.CodeJ,j.NomJ,j.PrenomJ,j.Dateobt AS DateObtenu,
		  t.CodeTYJ AS CodeTypeJ,t.nomtyj as NomTypeJ,t.PrixCar,
		  d.CodeDI AS CodeDip,d.nomdi as NomDip,
		  i.codeif as CodeInstitutFormation,i.nomif as NomInstitutFormation
	FROM PJDIA_YV.Publication p,PJDIA_YV.TypePU t,PJDIA_YV.Journaliste j, 
		 PJDIA_YV.TypeJour t,PJDIA_YV.diplome d,PJDIA_YV.INSTITUTFORMATION i
	WHERE p.CodeTY = t.CodeTY and p.codej = j.codej
	  and j.codetyj = t.codetyj and d.codedi = j.codedi and d.codeif = i.codeif;
-----  
ALTER TABLE Publication_MD ADD CONSTRAINT pk_Publication_MD
PRIMARY KEY(CodePU);
-----
CREATE DIMENSION Publication_DIM
	LEVEL N_CodePU IS (PUBLICATION_MD.CodePU)
	LEVEL N_TypePU IS (PUBLICATION_MD.CodeTypePU)
	LEVEL N_Periodicite IS (PUBLICATION_MD.Periodicite)
	LEVEL N_GroupePresse IS (Publication_MD.GroupePresse)	
	LEVEL N_j IS (Publication_MD.CodeJ)	
	LEVEL N_dipj IS (Publication_MD.CodeDip)
	LEVEL N_ifj IS (Publication_MD.CodeInstitutFormation)
	LEVEL N_typejr IS (Publication_MD.CodeTypeJ)	
	
HIERARCHY H_typeP	(N_CodePU CHILD OF N_TypePU)
HIERARCHY H_Gp(N_CodePU CHILD OF N_GroupePresse)
HIERARCHY H_Pe(N_CodePU CHILD OF N_Periodicite)			 
HIERARCHY H_dipjPU(N_CodePU CHILD OF N_j
                            CHILD OF N_dipj
                            CHILD OF N_ifj)	
HIERARCHY H_typeJPU(N_CodePU CHILD OF N_j CHILD OF N_typejr)
			 
ATTRIBUTE N_CodePU DETERMINES Publication_MD.NomPU
ATTRIBUTE N_CodePU DETERMINES Publication_MD.DateCreat
ATTRIBUTE N_CodePU DETERMINES Publication_MD.DateFin
ATTRIBUTE N_TypePU DETERMINES Publication_MD.NomTypePU
ATTRIBUTE N_j DETERMINES Publication_MD.NomJ
ATTRIBUTE N_j DETERMINES Publication_MD.PrenomJ
ATTRIBUTE N_j DETERMINES Publication_MD.DateObtenu
ATTRIBUTE N_dipj DETERMINES Publication_MD.NomDip
ATTRIBUTE N_ifj DETERMINES Publication_MD.NomInstitutFormation
ATTRIBUTE N_typejr DETERMINES Publication_MD.NomTypeJ
ATTRIBUTE N_typejr DETERMINES Publication_MD.PrixCar
;

-------------------------------------------
-- Création du fait
-------------------------------------------
CREATE MATERIALIZED VIEW ActiviteJournaliste_MD
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS SELECT p.CodePU, j.CodeJ,n.DateNO AS DateActivite,
		  SUM(t.PrixCar*e.Nbcar+c.ForfaitArt * e.NbArt) AS Montant_MD,
		  SUM(e.NbArt) AS Nombre_MD
	FROM PJDIA_YV.Publication p, PJDIA_YV.Journaliste j,PJDIA_YV.Numero n,
       PJDIA_YV.EcrireArticle e,PJDIA_YV.CoutArticle c,PJDIA_YV.typejour t,PJDIA_YV.rubrique r
	WHERE r.codepu = p.codepu 
    and j.codetyj = j.codetyj
    and e.codej = j.codej
    and e.codeno = n.codeno
    and e.coderu = r.coderu
    and c.coderu = j.codej
	GROUP BY p.CodePU,j.CodeJ,n.DateNO;
-----
ALTER TABLE ActiviteJournaliste_MD ADD CONSTRAINT pk_ActiviteJournaliste_MD
PRIMARY KEY(CodePU, CodeJ, DateActivite);
-----
ALTER TABLE ActiviteJournaliste_MD ADD CONSTRAINT fk_ActiviteJ_publications
FOREIGN KEY(CodePU) REFERENCES Publication_MD(CodePU);
ALTER TABLE ActiviteJournaliste_MD ADD CONSTRAINT fk_ActiviteJ_journaliste
FOREIGN KEY(CodeJ) REFERENCES Journaliste_MD(CodeJ);
ALTER TABLE ActiviteJournaliste_MD ADD CONSTRAINT fk_ActiviteJ_temps
FOREIGN KEY(DateActivite) REFERENCES TEMPS_MD(DATE_MD);


	