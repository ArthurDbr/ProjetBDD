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
    nom_parc VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_employe),
    FOREIGN KEY (nom_parc) REFERENCES parc(nom_parc)
);

CREATE TABLE parcours
(
    id_parcours INT NOT NULL,
    nom_parcours VARCHAR(255) ,
    status_parcours VARCHAR(100) ,
    difficulte_parcours VARCHAR(100),
    id_employe INT NOT NULL,
    PRIMARY KEY (id_parcours),
    FOREIGN KEY (id_employe) REFERENCES employe(id_employe)
);

CREATE TABLE attribution
(
    id_employe INT NOT NULL,
    id_parcours INT NOT NULL,
    nom_parc VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_employe) REFERENCES employe(id_employe),
    FOREIGN KEY (id_parcours) REFERENCES parcours(id_parcours),
    FOREIGN KEY (nom_parc) REFERENCES parc(nom_parc)
);

