-------------------------------------------
-- Création du Agg1
-------------------------------------------
CREATE MATERIALIZED VIEW Agg1
BUILD IMMEDIATE REFRESH COMPLETE ON DEMAND
AS SELECT  t.Annee,j.NomTypeJ as Type_Journaliste, SUM(a.Nombre_MD) AS NbArticile
	FROM Journaliste_MD j,Temps_MD t,ActiviteJournaliste_MD a
	WHERE j.CodeJ = a.CodeJ 
	  AND t.Date_MD = a.DATEACTIVITE
	GROUP BY j.NomTypeJ, t.Annee
	ORDER BY SUM(a.Nombre_MD) DESC;

-------------------------------------------
-- Création du Agg2
-------------------------------------------
CREATE MATERIALIZED VIEW Agg2
BUILD IMMEDIATE REFRESH COMPLETE ON DEMAND
AS SELECT p.NomPU as Nom_Publication, p.GroupePresse as Groupe_Presse,t.Mois,
		  SUM(a.Montant_MD) AS Montant_Mensuelle
	FROM Publication_MD p,Temps_MD t,ActiviteJournaliste_MD a
	WHERE p.CodePU = a.CodePU
	  AND t.Date_MD = a.DATEACTIVITE
	GROUP BY p.NomPU, p.GroupePresse,t.Mois;

-------------------------------------------
-- Création du Agg3
-------------------------------------------
CREATE MATERIALIZED VIEW Agg3
BUILD IMMEDIATE REFRESH COMPLETE ON DEMAND
AS SELECT p.NomPU as Nom_Publication, p.Periodicite,t.Annee,
          SUM(a.Montant_MD) AS Montant_Annuelle
   FROM Publication_MD p,Temps_MD t,ActiviteJournaliste_MD a
   WHERE p.CodePU = a.CodePU
	 AND t.Date_MD = a.DATEACTIVITE
   GROUP BY p.NomPU, p.Periodicite,t.Annee;
