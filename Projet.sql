SET SERVEROUTPUT ON;
DROP SEQUENCE employer_sequence;
DROP SEQUENCE parcours_sequence;
DROP TABLE attribution;
DROP TABLE parcours;
DROP TABLE employe;
DROP TABLE parc;


CREATE TABLE parc
(
    nom_parc VARCHAR(255) NOT NULL,
    departement VARCHAR(255),
    horaire_parc VARCHAR(100),
    nb_parcours INT,
    superficie FLOAT,
    nb_employe INT,
    materiels INT,
    accidents INT,
    PRIMARY KEY (nom_parc)
);

CREATE TABLE employe
(
    id_employe INT NOT NULL,
    nom_employe VARCHAR(255) ,
    prenom_employe VARCHAR(255) ,
    PRIMARY KEY (id_employe)
);

CREATE TABLE parcours
(
    id_parcours INT NOT NULL,
    nom_parcours VARCHAR(255) ,
    status_parcours int,
    difficulte_parcours VARCHAR(100),
    nom_parc VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_parcours),
	CONSTRAINT fk_nomparc_parcours FOREIGN KEY (nom_parc) REFERENCES parc(nom_parc)
);

CREATE TABLE attribution
(
    id_employe INT NOT NULL,
    id_parcours INT NOT NULL,
	PRIMARY KEY (id_employe, id_parcours),
    CONSTRAINT fk_idemploye_attribution FOREIGN KEY (id_employe) REFERENCES employe(id_employe),
    CONSTRAINT fk_idparcours_attribution FOREIGN KEY (id_parcours) REFERENCES parcours(id_parcours)
);

INSERT INTO parc VALUES ( 'Funny Forest', 'Loire Atlantique', '9:30-20:00',  10, 5.36, 15, 50, 0 );
INSERT INTO parc VALUES ('Chemin Magic', 'Maine et Loire', 	'10-20:30',  	15, 6.36, 25, 60, 0 );
INSERT INTO parc VALUES ('Faune and Co', 'Meurthe et Moselle', '9:30-20:00',  11, 5.20, 10, 40, 0 );
INSERT INTO parc VALUES ( 'Accro Tropico', 'Alpes Maritimes', '9:30-20:00',  12, 7.16, 24, 60, 0 );

CREATE SEQUENCE employer_sequence START WITH 0 INCREMENT BY 1 MINVALUE 0;

INSERT INTO employe VALUES (employer_sequence.nextval ,'Bernard', 'Jouillet');
INSERT INTO employe VALUES (employer_sequence.nextval ,'Habib', 'Clement');
INSERT INTO employe VALUES (employer_sequence.nextval ,'Debar', 'Arthur');
INSERT INTO employe VALUES (employer_sequence.nextval ,'Godet', 'Thibaut');
INSERT INTO employe VALUES (employer_sequence.nextval ,'Valenza', 'Pierre');

CREATE SEQUENCE parcours_sequence START WITH 0 INCREMENT BY 1 MINVALUE 0;

INSERT INTO parcours VALUES( parcours_sequence.nextval , 'Green Forest', 1, 'Vert', 'Funny Forest');
INSERT INTO parcours VALUES( parcours_sequence.nextval , 'Les 3 pics', 0, 'Rouge', 'Funny Forest');
INSERT INTO parcours VALUES( parcours_sequence.nextval , '50 nuances de chêne', 1, 'Noir', 'Chemin Magic');
INSERT INTO parcours VALUES( parcours_sequence.nextval , 'Le tempestueux', 1, 'Rouge', 'Faune and Co');
INSERT INTO parcours VALUES( parcours_sequence.nextval , 'Oasis good', 1, 'Bleu', 'Accro Tropico');

INSERT INTO attribution VALUES( 1 , 4);
INSERT INTO attribution VALUES( 2 , 2);
INSERT INTO attribution VALUES( 3 , 3);
INSERT INTO attribution VALUES( 4 , 1);
INSERT INTO attribution VALUES( 5 , 5);

create or replace
TRIGGER SupprEmploye
  before DELETE ON employe
  FOR EACH ROW
  BEGIN
    DELETE From attribution WHERE id_employe  = :old.id_employe;
  END;

CREATE OR REPLACE TRIGGER attributionParcoursEmploye
BEFORE INSERT or UPDATE ON attribution
FOR EACH ROW
DECLARE
	CURSOR curs IS SELECT parcours.nom_parc from attribution natural join parcours where :new.id_employe = id_employe;
	nom varchar(255);
	possible boolean := true;
	value varchar(255);
BEGIN
	select nom_parc into nom from parcours where id_parcours = :new.id_parcours;
	OPEN curs;
		LOOP
	    FETCH curs INTO value;
		EXIT WHEN NOT curs%FOUND;
		    DBMS_OUTPUT.PUT_LINE(value)	;
			IF (nom != value) THEN
		        DBMS_OUTPUT.PUT_LINE('L employe ne peut pas se trouver dans 2 parcs differents '||value|| ' et '||nom);
				raise_application_error(-20000, 'ERREUR DE LOGIQUE');
				possible := false;
			END IF;
		END LOOP;
	CLOSE curs;
END;
/
show errors;


CREATE OR REPLACE PROCEDURE getListeEmployeParc (nom IN VARCHAR2)
AS
  BEGIN
   SELECT employe.id_employe int id_emp, employe.nom_employe into nom_emp, employe.prenom_employe into prenom_emp
            FROM employe inner join attribution on employe.id_employe = attribution.id_employe
            WHERE attribution.nom_parc = nom;
END;
/
show errors;

CREATE OR REPLACE PROCEDURE getNbrParcoursHard
AS
    nb number;
  BEGIN
    SELECT count(parcours.difficulte_parcours) into nb FROM parcours where difficulte_parcours = 'Noir';
END;
/

CREATE OR REPLACE PROCEDURE getPourcentageParcours (nom IN VARCHAR2)
AS
    nb_noir number;
    nb_rouge number;
    nb_bleu number;
    nb_vert number;
    nb_total number;
    pourcentage_noir number;
    pourcentage_rouge number;
    pourcentage_bleu number;
    pourcentage_vert number;
  BEGIN
    SELECT count(parcours.difficulte_parcours) into nb_noir FROM attribution, parcours
                where attribution.nom_parc = nom and attribution.id_parcours = parcours.id_parcours and parcours.difficulte_parcours = 'Noir';
    SELECT count(parcours.difficulte_parcours) into nb_rouge FROM attribution, parcours
                where attribution.nom_parc = nom and attribution.id_parcours = parcours.id_parcours and parcours.difficulte_parcours = 'Rouge';
    SELECT count(parcours.difficulte_parcours) into nb_bleu FROM attribution, parcours
                where attribution.nom_parc = nom and attribution.id_parcours = parcours.id_parcours and parcours.difficulte_parcours = 'Bleu';
    SELECT count(parcours.difficulte_parcours) into nb_vert FROM attribution, parcours
                where attribution.nom_parc = nom and attribution.id_parcours = parcours.id_parcours and parcours.difficulte_parcours = 'Vert';

    nb_total := nb_noir + nb_rouge + nb_bleu + nb_vert;
    pourcentage_noir := (nb_noir/nb_total)*100;
    pourcentage_rouge := (nb_rouge/nb_total)*100;
    pourcentage_bleu := (nb_bleu/nb_total)*100;
    pourcentage_vert := (nb_vert/nb_total)*100;

    DBMS_OUTPUT.PUT_LINE( 'Nombre de parcours du parc -> ' || nb_total) ;
    DBMS_OUTPUT.PUT_LINE( 'Pourcentage de parcours noirs -> ' || pourcentage_noir || '%' ) ;
    DBMS_OUTPUT.PUT_LINE( 'Pourcentage de parcours rouges -> ' || pourcentage_rouge || '%' ) ;
    DBMS_OUTPUT.PUT_LINE( 'Pourcentage de parcours bleus -> ' || pourcentage_bleu || '%' );
    DBMS_OUTPUT.PUT_LINE( 'Pourcentage de parcours verts -> ' || pourcentage_vert || '%' );
END;
/

CREATE OR REPLACE VIEW ParcParcours AS Select p.nom_parc,  p.departement, pa.nom_parcours, pa.status_parcours, pa.difficulte_parcours
FROM parc p INNER JOIN parcours pa ON p.nom_parc=pa.nom_parc;

CREATE OR REPLACE VIEW NbParcours AS SELECT e.id_employe, e.nom_employe, e.prenom_employe, (SELECT COUNT(*) FROM attribution a WHERE e.id_employe = a.id_employe) AS nb_parcours FROM employe e;



show errors;
