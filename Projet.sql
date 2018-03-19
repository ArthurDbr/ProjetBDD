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


CREATE OR REPLACE PROCEDURE getEmployeParc
AS
  nom varchar(255) := "";
  BEGIN
   accept nom prompt "Entrez nom du parc : "
   SELECT employe.nom_employe into nom, employe.prenom_employe into prenom FROM employe inner join attribution on employe.id_employe = attribution.id_employe WHERE attribution.nom_parc = nom;
  END;
  /
  show errors;
