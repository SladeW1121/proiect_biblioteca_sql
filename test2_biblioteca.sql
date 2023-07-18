CREATE DATABASE test3;

USE test3;


CREATE TABLE autori (
    pk_autor INT NOT NULL,
    nume_autor VARCHAR(50) NOT NULL,
    PRIMARY KEY (pk_autor),
    UNIQUE (nume_autor)
);

CREATE TABLE cititori (
    pk_cititor INT NOT NULL,
    nume_cititor VARCHAR(50),
    varsta INT(2),
    sex VARCHAR(1),
    calificativ VARCHAR(50),
    PRIMARY KEY (pk_cititor)
);

CREATE TABLE carti (
    pk_carte INT NOT NULL,
    domeniu VARCHAR(50),
    titlu_carte VARCHAR(100) NOT NULL,
    pk_autor1 INT,
    pk_autor2 INT,
    pk_autor3 INT,
    PRIMARY KEY (pk_carte),
    CHECK (domeniu IN ('Beletristica', 'Stiinte', 'Divertisment')),
    UNIQUE (titlu_carte),
    FOREIGN KEY (pk_autor1) REFERENCES autori(pk_autor)
);

CREATE TABLE imprumuturi (
    pk_imprumut INT NOT NULL,
    pk_carte INT NOT NULL,
    pk_cititor INT NOT NULL,
    data_start DATE NOT NULL,
    data_end DATE NOT NULL,
    data_return DATE,
    observatii VARCHAR(50),
    PRIMARY KEY (pk_imprumut),
    FOREIGN KEY (pk_carte) REFERENCES carti(pk_carte),
    FOREIGN KEY (pk_cititor) REFERENCES cititori(pk_cititor)
);



INSERT INTO autori VALUES (1, 'Autor_1');
INSERT INTO autori VALUES (2, 'Autor_2');
INSERT INTO autori VALUES (3, 'Autor_3');
INSERT INTO autori VALUES (4, 'Autor_4');
INSERT INTO autori VALUES (5, 'Autor_5');
INSERT INTO autori VALUES (6, 'Autor_6');


INSERT INTO cititori VALUES (1, 'Cititor_1', 25, 'M', 'FB');
INSERT INTO cititori VALUES (2, 'Cititor_2', 20, 'F', 'B');
INSERT INTO cititori VALUES (3, 'Cititor_3', 21, 'M', 'S');
INSERT INTO cititori VALUES (4, 'Cititor_4', 19, 'F', 'NS');
INSERT INTO cititori VALUES (5, 'Cititor_5', 27, 'M', 'NS');


INSERT INTO carti VALUES (1, 'Beletristica', 'Titlu_1', 2, 5, NULL);
INSERT INTO carti VALUES (2, 'Beletristica', 'Titlu_2', 4, NULL, NULL);
INSERT INTO carti VALUES (3, 'Stiinte', 'Titlu_3', 1, 4, 5);
INSERT INTO carti VALUES (4, 'Stiinte', 'Titlu_4', 2, 3, 1);
INSERT INTO carti VALUES (5, 'Stiinte', 'Titlu_5', 1, NULL, NULL);
INSERT INTO carti VALUES (6, 'Stiinte', 'Titlu_6', 1, 3, NULL);
INSERT INTO carti VALUES (7, 'Divertisment', 'Titlu_7', 6, NULL, NULL);
INSERT INTO carti VALUES (8, 'Divertisment', 'Titlu_8', 6, 1, NULL);


INSERT INTO imprumuturi VALUES (1, 1, 2, CURDATE() - INTERVAL 5 DAY, CURDATE() + INTERVAL 5 DAY, NULL, NULL);
INSERT INTO imprumuturi VALUES (2, 2, 2, CURDATE() - INTERVAL 5 DAY, CURDATE() + INTERVAL 5 DAY, CURDATE() + INTERVAL 3 DAY, NULL);
INSERT INTO imprumuturi VALUES (3, 5, 2, CURDATE() - INTERVAL 5 DAY, CURDATE() + INTERVAL 5 DAY, CURDATE() + INTERVAL 2 DAY, 'a rupt coperta');
INSERT INTO imprumuturi VALUES (4, 5, 1, CURDATE() - INTERVAL 2 DAY, CURDATE() + INTERVAL 7 DAY, NULL, NULL);
INSERT INTO imprumuturi VALUES (5, 3, 1, CURDATE() - INTERVAL 2 DAY, CURDATE() + INTERVAL 7 DAY, CURDATE() + INTERVAL 4 DAY, NULL);
INSERT INTO imprumuturi VALUES (6, 3, 3, CURDATE() - INTERVAL 1 DAY, CURDATE() + INTERVAL 9 DAY, NULL, NULL);
INSERT INTO imprumuturi VALUES (7, 5, 3, CURDATE() - INTERVAL 1 DAY, CURDATE() + INTERVAL 9 DAY, CURDATE() + INTERVAL 8 DAY, NULL);
INSERT INTO imprumuturi VALUES (8, 2, 3, CURDATE() - INTERVAL 1 DAY, CURDATE() + INTERVAL 9 DAY, CURDATE() + INTERVAL 4 DAY, 'a rupt coperta');
INSERT INTO imprumuturi VALUES (9, 5, 4, CURDATE(), CURDATE() + INTERVAL 10 DAY, NULL, NULL);
INSERT INTO imprumuturi VALUES (10, 3, 4, CURDATE(), CURDATE() + INTERVAL 10 DAY, CURDATE() + INTERVAL 4 DAY, NULL);




-- 1
SELECT c.titlu_carte, CONCAT(a1.nume_autor, COALESCE(CONCAT(', ', a2.nume_autor), ''), COALESCE(CONCAT(', ', a3.nume_autor), '')) AS nume_autori
FROM carti c
LEFT JOIN autori a1 ON c.pk_autor1 = a1.pk_autor
LEFT JOIN autori a2 ON c.pk_autor2 = a2.pk_autor
LEFT JOIN autori a3 ON c.pk_autor3 = a3.pk_autor;

-- 2
SELECT c.titlu_carte, ci.nume_cititor, i.data_start, i.data_end, i.data_return
FROM imprumuturi i
JOIN carti c ON i.pk_carte = c.pk_carte
JOIN cititori ci ON i.pk_cititor = ci.pk_cititor;

-- 3
SELECT c.titlu_carte, ci.nume_cititor, i.data_start, i.data_end, i.data_return
FROM imprumuturi i
JOIN carti c ON i.pk_carte = c.pk_carte
JOIN cititori ci ON i.pk_cititor = ci.pk_cititor
WHERE i.data_return IS NULL OR i.data_return > CURDATE();

-- 4
SELECT c.titlu_carte, ci.nume_cititor, i.data_start, i.data_end, i.data_return
FROM imprumuturi i
JOIN carti c ON i.pk_carte = c.pk_carte
JOIN cititori ci ON i.pk_cititor = ci.pk_cititor
WHERE i.data_start < DATE_SUB(CURDATE(), INTERVAL 2 WEEK);

-- 5
SELECT DATE_FORMAT(i.data_end, '%Y-%m-%d') AS ziua, COUNT(*) AS numar_carti_returnate
FROM imprumuturi i
WHERE i.data_end > CURDATE() AND i.data_end <= DATE_ADD(CURDATE(), INTERVAL 1 WEEK)
GROUP BY DATE_FORMAT(i.data_end, '%Y-%m-%d');
