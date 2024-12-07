BEGIN;


-- 1. Llenar taxonomy_nombres
INSERT INTO taxonomy_names (scientific_name, common_name)
SELECT DISTINCT scientific_name, common_name
FROM public.reduccion_limpia;

-- 2. Llenar taxonomy
INSERT INTO taxonomy (taxonomy_names_id, taxon_id)
SELECT DISTINCT 
    tn.id AS taxonomy_names_id,
    rl.taxon_id
FROM public.reduccion_limpia rl
JOIN taxonomy_names tn ON rl.scientific_name = tn.scientific_name 
    AND COALESCE(rl.common_name, '') = COALESCE(tn.common_name, '');

-- 4. Llenar observations_ubicacion
INSERT INTO observations_ubicacion (latitude, longitude, timezone)
SELECT DISTINCT latitude, longitude, time_zone
FROM public.reduccion_limpia;

-- 5. Llenar observations
INSERT INTO observations (observations_ubicacion_id, observed_on, taxonomy_id)
SELECT 
    ou.id AS observations_ubicacion_id,
    rl.observed_on,
    t.id AS taxonomy_id
FROM public.reduccion_limpia rl
JOIN observations_ubicacion ou ON rl.latitude = ou.latitude 
    AND rl.longitude = ou.longitude 
    AND rl.time_zone = ou.timezone
JOIN taxonomy_names tn ON rl.scientific_name = tn.scientific_name 
    AND COALESCE(rl.common_name, '') = COALESCE(tn.common_name, '')
JOIN taxonomy t ON tn.id = t.taxonomy_names_id;

-- 6. Llenar privacy
INSERT INTO privacy (license, geoprivacy, taxon_geoprivacy, observations_id)
SELECT 
    rl.license,
    rl.geoprivacy,
    rl.taxon_geoprivacy,
    o.id AS observations_id
FROM public.reduccion_limpia rl
JOIN observations_ubicacion ou ON rl.latitude = ou.latitude 
    AND rl.longitude = ou.longitude 
    AND rl.time_zone = ou.timezone
JOIN observations o ON ou.id = o.observations_ubicacion_id
    AND rl.observed_on = o.observed_on;

-- 7. Llenar datos_ambientales
INSERT INTO datos_ambientales (temperatura_2m, precipitation, cloudcover, windspeed_10m, observations_id)
SELECT 
    rl.temperature_2m,
    rl.precipitation,
    rl.cloudcover,
    rl.windspeed_10m,
    o.id AS observations_id
FROM public.reduccion_limpia rl
JOIN observations_ubicacion ou ON rl.latitude = ou.latitude 
    AND rl.longitude = ou.longitude 
    AND rl.time_zone = ou.timezone
JOIN observations o ON ou.id = o.observations_ubicacion_id
    AND rl.observed_on = o.observed_on;


COMMIT;