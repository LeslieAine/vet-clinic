/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id integer,
    name varchar(100),
    date_of_birth date,
    escape_attempts integer,
    neutered boolean,
    weight_kg decimal
);

ALTER TABLE animals ADD COLUMN species VARCHAR(100);

CREATE TABLE owners (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(100),
  age INTEGER
);

CREATE TABLE species (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

ALTER TABLE animals DROP COLUMN IF EXISTS id;
ALTER TABLE animals ADD COLUMN id SERIAL PRIMARY KEY;

ALTER TABLE animals DROP COLUMN IF EXISTS species;

ALTER TABLE animals ADD COLUMN species_id INTEGER REFERENCES species(id);

ALTER TABLE animals ADD COLUMN owner_id INTEGER REFERENCES owners(id);

CREATE TABLE vets (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    date_of_graduation DATE NOT NULL
);

CREATE TABLE specializations (
    vet_id INT NOT NULL,
    species_id INT NOT NULL,
    PRIMARY KEY (vet_id, species_id),
    CONSTRAINT fk_specializations_vets
        FOREIGN KEY (vet_id) REFERENCES vets (id),
    CONSTRAINT fk_specializations_species
        FOREIGN KEY (species_id) REFERENCES species (id)
);

CREATE TABLE visits (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    animal_id INT NOT NULL,
    vet_id INT NOT NULL,
    date_of_visit DATE NOT NULL,
    CONSTRAINT fk_visits_animals
        FOREIGN KEY (animal_id) REFERENCES animals (id),
    CONSTRAINT fk_visits_vets
        FOREIGN KEY (vet_id) REFERENCES vets (id)
);

