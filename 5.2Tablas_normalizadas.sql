-- Tabla Taxonomy_names
DROP TABLE IF EXISTS taxonomy_names;
CREATE TABLE taxonomy_names (
    id BIGSERIAL PRIMARY KEY,
    scientific_name VARCHAR(100) NOT NULL UNIQUE,
    common_name VARCHAR(100)
);

-- Tabla Taxonomy
DROP TABLE IF EXISTS taxonomy;
CREATE TABLE taxonomy (
    id BIGSERIAL PRIMARY KEY,
    taxon_id BIGINT NOT NULL UNIQUE,
    taxonomy_nombres_id BIGINT NOT NULL REFERENCES taxonomy_names(id) -- FK
);

-- Tabla Locations
DROP TABLE IF EXISTS locations;
CREATE TABLE locations (
    id BIGSERIAL PRIMARY KEY,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    timezone VARCHAR(100) NOT NULL
);

-- Tabla Observations
DROP TABLE IF EXISTS observations;
CREATE TABLE observations (
    id BIGSERIAL PRIMARY KEY,
    observed_on DATE NOT NULL,
    locations_id BIGINT NOT NULL REFERENCES locations(id), -- FK a locations
    taxonomy_id BIGINT NOT NULL REFERENCES taxonomy(id) -- FK a taxonomy
);

-- Tabla Privacy
DROP TABLE IF EXISTS privacy;
CREATE TABLE privacy (
    id BIGSERIAL PRIMARY KEY,
    license VARCHAR(50) DEFAULT 'No license registered',
    geoprivacy VARCHAR(50) DEFAULT 'open',
    taxon_geoprivacy VARCHAR(50) DEFAULT 'private',
    observations_id BIGINT NOT NULL REFERENCES observations(id) -- FK a observations
);

-- Tabla Environmental_data
DROP TABLE IF EXISTS environmental_data;
CREATE TABLE environmental_data (
    id BIGSERIAL PRIMARY KEY,
    temperatura_2m DOUBLE PRECISION NOT NULL,
    precipitation DOUBLE PRECISION NOT NULL,
    cloudcover DOUBLE PRECISION NOT NULL,
    windspeed_10m DOUBLE PRECISION NOT NULL,
    observations_id BIGINT NOT NULL REFERENCES observations(id) -- FK a observations
);
