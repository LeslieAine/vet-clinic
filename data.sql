/* Populate database with sample data. */

INSERT INTO animals (id,name,date_of_birth,escape_attempts,neutered,weight_kg) VALUES 
(1,'Agumon','2020-02-03',0,true,10.23),
(2,'Gabumon','2018-11-18',2,true,8.0),
(3, 'Pikachu','2021-01-07',1,false,15.04),
(4,'Devimon','2017-05-12',5,true,11.0);

INSERT INTO animals (id,name,date_of_birth,escape_attempts,neutered,weight_kg) VALUES 
(5,'Charmander','2020-02-08',0,false,-11.0),
(6,'Plantmon','2021-11-15',2,true,-5.7),
(7,'Squirtle','1993-04-02',3,false,-12.13),
(8,'Angemon','2005-06-12',1,true,-45.0),
(9,'Boarmon','2005-06-07',7,true,20.4),
(10,'Blossom','1998-10-13',3,true,17.0),
(11,'Ditto','2022-05-14',4,true,22.0);

INSERT INTO owners (full_name, age) 
VALUES 
    ('Sam Smith', 34), 
    ('Jennifer Orwell', 19), 
    ('Bob', 45), 
    ('Melody Pond', 77), 
    ('Dean Winchester', 14), 
    ('Jodie Whittaker', 38);

INSERT INTO species (name) 
VALUES 
    ('Pokemon'), 
    ('Digimon');

UPDATE animals
SET species_id = 
    CASE 
        WHEN name LIKE '%mon' THEN (SELECT id FROM species WHERE name = 'Digimon')
        ELSE (SELECT id FROM species WHERE name = 'Pokemon')
    END;


CREATE TEMPORARY TABLE animal_owner_mapping (
    animal_name VARCHAR(255) PRIMARY KEY,
    owner_name VARCHAR(255)
);
INSERT INTO animal_owner_mapping (animal_name, owner_name)
VALUES 
    ('Agumon', 'Sam Smith'),
    ('Gabumon', 'Jennifer Orwell'),
    ('Pikachu', 'Jennifer Orwell'),
    ('Devimon', 'Bob'),
    ('Plantmon', 'Bob'),
    ('Charmander', 'Melody Pond'),
    ('Squirtle', 'Melody Pond'),
    ('Blossom', 'Melody Pond'),
    ('Angemon', 'Dean Winchester'),
    ('Boarmon', 'Dean Winchester');
UPDATE animals AS a
SET owner_id = o.id
FROM owners AS o
WHERE o.full_name = (SELECT owner_name FROM animal_owner_mapping WHERE animal_name = a.name);

INSERT INTO vets (name, age, date_of_graduation)
VALUES ('William Tatcher', 45, '2000-04-23'),
       ('Maisy Smith', 26, '2019-01-17'),
       ('Stephanie Mendez', 64, '1981-05-04'),
       ('Jack Harkness', 38, '2008-06-08');

INSERT INTO specializations (vet_id, species_id)
VALUES (1, 1),
       (3, 1),
       (3, 2),
       (4, 2);


INSERT INTO visits (animal_id, vet_id, date_of_visit)
VALUES 
    (1, 1, '2020-05-24'),
    (1, 3, '2020-07-22'),
    (2, 4, '2021-02-02'),
    (5, 2, '2020-01-05'),
    (5, 2, '2020-03-08'),
    (5, 2, '2020-05-14'),
    (3, 3, '2021-05-04'),
    (6, 4, '2021-02-24'),
    (9, 2, '2019-12-21'),
    (9, 1, '2020-08-10'),
    (9, 2, '2021-04-07'),
    (7, 3, '2019-09-29'),
    (10, 4, '2020-10-03'),
    (10, 4, '2020-11-04'),
    (4, 2, '2019-01-24'),
    (4, 2, '2019-05-15'),
    (4, 2, '2020-02-27'),
    (4, 2, '2020-08-03'),
    (8, 3, '2020-05-24'),
    (8, 1, '2021-01-11');