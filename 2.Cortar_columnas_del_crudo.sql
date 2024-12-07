--BORRAR TABLA SI EXISTE
DROP TABLE IF EXISTS raw.reduccion_borrador;



--CREAR TABLA REDUCIDA
CREATE TABLE public.reduccion_borrador (
    id BIGSERIAL PRIMARY KEY,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    observed_on DATE NOT NULL,
    time_zone VARCHAR(100),
    temperature_2m REAL,
    precipitation REAL,
    cloudcover REAL,
    windspeed_10m REAL,
    taxon_id BIGINT NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    common_name VARCHAR(100),
    license VARCHAR(50),
    geoprivacy VARCHAR(50),
    taxon_geoprivacy VARCHAR(50)
);

--INSERTAR VALORES EN LA TABLA (SE HARA UN NUEVO ID DEL 1-49842)
INSERT INTO public.reduccion_borrador (
    latitude,
    longitude,
    observed_on,
    time_zone,
    temperature_2m,
    precipitation,
    cloudcover,
    windspeed_10m,
    taxon_id,
    scientific_name,
    common_name,
    license,
    geoprivacy,
    taxon_geoprivacy
)
SELECT 
    latitude,
    longitude,
    observation_date AS observed_on, --uso observed_on_y porque este es DATE y el otro es TIME STAMP WITH TIME ZONE
    time_zone,
    temperature_2m,
    precipitation,
    cloudcover,
    windspeed_10m,
    taxon_id,
    scientific_name,
    common_name,
    license,
    geoprivacy,
    taxon_geoprivacy
FROM public.raw_data_limited;
