/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT * FROM animals WHERE DATE_PART('year', date_of_birth) BETWEEN 2016 AND 2019;
SELECT name FROM animals WHERE neutered AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = TRUE;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT delete_birth;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO delete_birth;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;
SELECT * FROM animals;

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;

SELECT neutered, SUM(escape_attempts) as total_escapes
FROM animals
GROUP BY neutered
ORDER BY total_escapes DESC
LIMIT 1;

SELECT species, MIN(weight_kg) as min_weight, MAX(weight_kg) as max_weight
FROM animals
GROUP BY species;

SELECT species, AVG(escape_attempts) as avg_escapes
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

SELECT a.name
FROM animals AS a
JOIN owners AS o ON a.owner_id = o.id
WHERE o.full_name = 'Melody Pond';

SELECT a.name
FROM animals AS a
JOIN species AS s ON a.species_id = s.id
WHERE s.name = 'Pokemon';

SELECT o.full_name, a.name
FROM owners AS o
LEFT JOIN animals AS a ON o.id = a.owner_id;

SELECT s.name, COUNT(a.id) as num_animals
FROM species AS s
JOIN animals AS a ON s.id = a.species_id
GROUP BY s.name;

SELECT a.name
FROM animals AS a
JOIN species AS s ON a.species_id = s.id
JOIN owners AS o ON a.owner_id = o.id
WHERE s.name = 'Digimon' AND o.full_name = 'Jennifer Orwell';

SELECT a.name
FROM animals AS a
JOIN owners AS o ON a.owner_id = o.id
WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;

SELECT o.full_name, COUNT(a.id) as num_animals
FROM owners AS o
LEFT JOIN animals AS a ON o.id = a.owner_id
GROUP BY o.full_name
ORDER BY num_animals DESC
LIMIT 1;


-- who was the last animal visited by William Tatcher
SELECT animals.name, vets.name, visits.date_of_visit FROM visits
JOIN animals ON visits.animal_id = animals.id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'William Tatcher'
ORDER BY visits.date_of_visit DESC LIMIT 1;

-- how many different animals did Stephanie Mendez see
SELECT vets.name, COUNT(DISTINCT animals.name) as total_animals FROM visits
JOIN animals ON visits.animal_id = animals.id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez'
GROUP BY vets.name;

-- list all vets and their specialties, including vets with no specialties
SELECT vets.name, species.name FROM specializations
RIGHT JOIN vets ON specializations.vet_id = vets.id
LEFT JOIN species ON specializations.species_id = species.id
ORDER BY vets.name;

-- list all animals that visited Stephanie Mendez between April 1st and August 30th, 2020
SELECT animals.name, vets.name, visits.date_of_visit FROM visits
JOIN animals ON visits.animal_id = animals.id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez' AND visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

-- what animal has the most visits to vets
SELECT animals.name, COUNT(visits.animal_id) as total_visits FROM visits
JOIN animals ON visits.animal_id = animals.id
GROUP BY animals.name
ORDER BY total_visits DESC LIMIT 1;

-- who was Maisy Smith's first visit
SELECT vets.name, animals.name, visits.date_of_visit FROM visits
JOIN vets ON visits.vet_id = vets.id
JOIN animals ON visits.animal_id = animals.id
WHERE vets.name = 'Maisy Smith'
ORDER BY visits.date_of_visit LIMIT 1;

-- details for most recent visit: animal information, vet information, and date of visit
SELECT animals.name as animal_name,
       animals.date_of_birth, animals.escape_attempts,
       species.name as animal_species,
       vets.name as vet_name,
       vets.date_of_graduation,
       (SELECT name FROM species WHERE id = specializations.species_id) as vet_specialty,
       visits.date_of_visit
       FROM visits
JOIN animals ON visits.animal_id = animals.id
JOIN vets ON visits.vet_id = vets.id
JOIN species ON animals.species_id = species.id
JOIN specializations ON vets.id = specializations.vet_id
ORDER BY visits.date_of_visit DESC LIMIT 1;

-- how many visits were with a vet that did not specialize in that animal's species
SELECT COUNT(*) FROM visits
JOIN animals ON visits.animal_id = animals.id
JOIN vets ON visits.vet_id = vets.id
JOIN species ON animals.species_id = species.id
JOIN specializations ON vets.id = specializations.vet_id
WHERE species.id != specializations.species_id;

-- what specialty should Maisy Smith consider getting? Look for the species she gets the most
SELECT (SELECT name FROM species WHERE species.id = animals.species_id) AS animal_species,
       COUNT(animals.species_id) AS total_visits,
       vets.name AS vet_name FROM visits
JOIN animals ON visits.animal_id = animals.id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Maisy Smith'
GROUP BY animals.species_id, vets.name
ORDER BY total_visits DESC;

