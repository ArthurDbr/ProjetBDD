SET SERVEROUTPUT ON;
DROP SEQUENCE employer_sequence;
DROP SEQUENCE parcours_sequence;
DROP TABLE attribution;
DROP TABLE parcours  cascade constraints;
DROP TABLE employe cascade constraints;
DROP TABLE parc cascade constraints;


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
    PRIMARY KEY (id_parcours)
);

CREATE TABLE attribution
(
    id_employe INT NOT NULL,
    id_parcours INT NOT NULL,
    nom_parc VARCHAR(255) NOT NULL,
    CONSTRAINT fk_idemploye_attribution FOREIGN KEY (id_employe) REFERENCES employe(id_employe),
    CONSTRAINT fk_idparcours_attribution FOREIGN KEY (id_parcours) REFERENCES parcours(id_parcours),
	CONSTRAINT fk_nomparc_attribution FOREIGN KEY (nom_parc) REFERENCES parc(nom_parc)
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

INSERT INTO parcours VALUES( parcours_sequence.nextval , 'Green Forest', 1, 'Vert');
INSERT INTO parcours VALUES( parcours_sequence.nextval , 'Les 3 pics', 0, 'Rouge');
INSERT INTO parcours VALUES( parcours_sequence.nextval , '50 nuances de chêne', 1, 'Noir');
INSERT INTO parcours VALUES( parcours_sequence.nextval , 'Le tempestueux', 1, 'Rouge');
INSERT INTO parcours VALUES( parcours_sequence.nextval , 'Oasis good', 1, 'Bleu');

INSERT INTO attribution VALUES( 1 , 4, 'Funny Forest');
INSERT INTO attribution VALUES( 2 , 2, 'Funny Forest');
INSERT INTO attribution VALUES( 3 , 3, 'Chemin Magic');
INSERT INTO attribution VALUES( 4 , 1, 'Faune and Co');
INSERT INTO attribution VALUES( 5 , 5, 'Accro Tropico');

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

show errors;
