--CREAR NUEVA TABLA LIMPIA esta sera la tabla limpia.
	DROP TABLE IF EXISTS public.reduccion_limpia;
	CREATE TABLE public.reduccion_limpia (
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
	    license VARCHAR(50) DEFAULT 'No license registered', 
	    geoprivacy VARCHAR(50) DEFAULT 'open', 
	    taxon_geoprivacy VARCHAR(50) DEFAULT 'open' 
	);
	
	
	
--INSERTAR VALORES EN LA TABLA public.reduccion_limpia
	INSERT INTO public.reduccion_limpia (
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
	FROM public.reduccion_borrador;



--CUANTAS FILAS HAY. -->49842
	SELECT COUNT(*)
	FROM public.reduccion_borrador;



--1.ID
	--El id es primary key
	SELECT COUNT(DISTINCT id)
	FROM public.reduccion_borrador;



--2.LATITUDE
	--Si existen valores nulos en latitude --> 0, no hay nulos. Double Precision
	SELECT COUNT(*)
	FROM public.reduccion_borrador
	WHERE latitude IS NULL OR longitude = 0;



--3.LONGITUDE
	--Si existen valores nulos en longitude --> 0, no hay nulos. Double Precisio 
	SELECT COUNT(*)
	FROM public.reduccion_borrador
	WHERE longitude IS NULL OR longitude = 0;



--4.OBSERVED_ON
	--Si existen valores nulos. --> 0, no hay nulos. Date
	SELECT COUNT(*)
	FROM public.reduccion_borrador
	WHERE observed_on IS NULL;



--5.TIME_ZONE
	--Si existen valores nulos. --> 0, no hay. Varchar
	SELECT COUNT(*)
	FROM public.reduccion_borrador
	WHERE time_zone IS NULL;



--6.TEMPERATURE_2M
	--Si tiene valores nulos. --> 0, no hay. Real
	SELECT COUNT(*)
	FROM public.reduccion_borrador
	WHERE temperature_2m IS NULL;



--7.PRECIPITATION
	--Si tiene valores nulos. --> 0, no hay. Real
	SELECT COUNT(*)
	FROM public.reduccion_borrador
	WHERE precipitation IS NULL;


--8.CLOUDCOVER
	--Si tiene valores nulos. --> 0, no hay. Real
	SELECT COUNT(*)
	FROM public.reduccion_borrador
	WHERE cloudcover IS NULL;


--9.WINDSPEED_10M
	--Si tiene valores nulos. --> 0, no hay. Real
	SELECT COUNT(*)
	FROM public.reduccion_borrador
	WHERE windspeed_10m IS NULL;


--10.TAXON_ID
	--Si tiene valores nulos. --> 0, no hay. Bigint
	SELECT COUNT(*)
	FROM public.reduccion_borrador
	WHERE taxon_id IS NULL;


--11.SCIENTIFIC_NAME
	--Si tiene valores nulos. --> 0, no hay. Varchar
	SELECT COUNT(*)
	FROM public.reduccion_borrador
	WHERE scientific_name IS NULL OR scientific_name = '';


--12.COMMON_NAME
	--Si tiene nulos. --> 118, si hay. Varchar
	SELECT COUNT(*)	
	FROM public.reduccion_borrador
	WHERE common_name IS NULL OR common_name = '';
	--Dejamos el common_name como null ya que queremos distinguir entre casos donde el nombre común no está registrado (falta de datos) y casos donde simplemente no existe un nombre común.
	--Ya que no sabemos si no se puso common_name porque no existe o porque no se especifico.


--13.LICENSE
	--Si tiene nulos, --> 12328, si hay. Varchar
	SELECT COUNT(*)
	FROM public.reduccion_borrador
	WHERE license IS NULL or license = '';
	
	--Hay 7 tipos de licencias diferntes.
	SELECT DISTINCT license
	FROM public.reduccion_borrador;
	
	--Establecer los nulls a 'No license registered' o dejarlos como nulls. 
	--Los nulls significan No se proporcionó una licencia: No se especificó una licencia al registrar el dato. Desconocido: No está claro si el dato tiene o no una licencia.
	BEGIN;
	UPDATE public.reduccion_limpia
	SET license = 'No license registered' --Dejarlos como nulls o no.
	WHERE license IS NULL;
	
	COMMIT;
	ROLLBACK;



--14.GEOPRIVACY
	--Si tiene nulos, --> 45989, si hay. Varchar
	SELECT COUNT(*)
	FROM public.reduccion_borrador
	WHERE geoprivacy IS NULL or geoprivacy = '';
	
	--Hay 3 tipos de datos: open, obscured y private.
	--Default Obscured: Quieres prevenir problemas futuros relacionados con datos sensibles.Planeas ajustar la visibilidad de las coordenadas en el futuro.
	--Default Open: Las coordenadas visibles son intencionales.No hay datos sensibles en tu base.
	BEGIN;
	UPDATE public.reduccion_limpia
	SET geoprivacy = 'open' --se deja open ya que la longitud y latitud de cada renglon estan dadas explicitamente.
	WHERE geoprivacy IS NULL;
	
	COMMIT;
	ROLLBACK;
	--En la tabla limpia poner Default.



--15.TAXON_GEOPRIVACY
	--Si tiene nulos, --> 2465, si hay. Varchar
	SELECT COUNT(*)
	FROM public.reduccion_borrador
	WHERE taxon_geoprivacy IS NULL or license = '';
	
	--Hay 3 tipos de datos: open, obscured y private.
	--Default Private: Tiene sentido si deseas garantizar la máxima protección para los taxones cuando no se proporciona un nivel explícito.
	--Default Open: Es más apropiado si la mayoría de los registros no requieren restricciones y la privacidad es una excepción.
	BEGIN;
	UPDATE public.reduccion_limpia
	SET taxon_geoprivacy = 'private' --Se dejo private ya que si no se especifico, preferimos proteger los datos del taxon/animal.
	WHERE taxon_geoprivacy IS NULL;
	
	COMMIT;
	ROLLBACK;
	--En la tabla limpia poner Default.



--ANALISIS DE COMMON_NAMES Y SCIENTIFIC_NAMES
	--Que cientific_names tienen common_name como null. --> cuales tienen nulls asociados
	SELECT scientific_name, COUNT(*) AS common_name_nulls
	FROM public.reduccion_borrador
	WHERE common_name IS NULL
	GROUP BY scientific_name;
	
	--Cuantos cientific_names distintos tienen null. --> 42
	SELECT COUNT(DISTINCT scientific_name) AS scientific_with_null
	FROM public.reduccion_borrador
	WHERE common_name IS NULL;
	
	--Cuantos common_names distintos hay. --> 1512
	SELECT COUNT(DISTINCT common_name)
	FROM public.reduccion_borrador;
	
	--Cuantos scientific_names distintos hay. --> 1560 por arriba entonces  1518 no tienen common_names nulls asociados.
	SELECT COUNT (DISTINCT scientific_name)
	FROM public.reduccion_borrador;
	
	--Consulta si algun scientific_name tiene asociado mas de 1 common_name. --> No regresa nada, diciendo que para cada scientific_name solo se asocia 1 common_name. 
	--Tambien diciendo que no hay variaciones como Lion y lion.
	SELECT scientific_name, COUNT( DISTINCT common_name) AS common_name_count
	FROM public.reduccion_borrador
	GROUP BY scientific_name
	HAVING COUNT( DISTINCT common_name) > 1;
	
	--Consulta si algun common_name tiene asociado mas de 1 scientific_name. -->Regresa 6 common_names cada uno con 2 scientific_names distintos asociados. (ESTO SE PUEDE LIMPIAR)
	SELECT common_name, COUNT( DISTINCT scientific_name) AS scientific_count
	FROM public.reduccion_borrador
	GROUP BY common_name
	HAVING COUNT( DISTINCT scientific_name) > 1;
	
	--Consulta que scientific_names estan asociados al common_name que tiene 2 scientific_names. Y tambien de los null.
	SELECT DISTINCT common_name, scientific_name
	FROM public.reduccion_borrador
	WHERE common_name IS NULL
	   OR common_name IN (
	       SELECT common_name
	       FROM public.reduccion_borrador
	       GROUP BY common_name
	       HAVING COUNT(DISTINCT scientific_name) > 1
	   )
	ORDER BY common_name, scientific_name;
	
	
	
	--TRANSACCION PARA ELMINIAR LOS REPETIDOS.
	--Lo que hace es checar que palabras tienen su ultima y penultima palabra igual, y las trimmea a solo la penultima.
	-- Actualizar los nombres científicos para eliminar la última palabra si se repite
		--BEGIN;
		--UPDATE public.reduccion_borrador
		--SET scientific_name = LEFT(scientific_name, LENGTH(scientific_name) - LENGTH(SPLIT_PART(scientific_name, ' ', -1)) - 1)
		--WHERE SPLIT_PART(scientific_name, ' ', -1) = SPLIT_PART(scientific_name, ' ', -2);
	
		--COMMIT;
	
		--ROLLBACK;
		
	--Decidimos al final no hacer esta transaccion ya que despues de investigar nombres cientificos como 'Tursiops truncatus' y 'Tursiops truncatus truncatus'
	--Son diferentes ya que unos se refieren a la especie y otros a la subespecie. Tampoco hicimos la transaccion porque cada uno tenia un taxon_id diferente
	--Si cambiaramos los nombres tendriamos que cambiar los taxon_id, pero esto seria "borrar" una especie.
	SELECT taxon_id --> 41482
	FROM public.reduccion_borrador
	WHERE scientific_name = 'Tursiops truncatus';
	
	SELECT taxon_id --> 705323
	FROM public.reduccion_borrador
	WHERE scientific_name = 'Tursiops truncatus truncatus';



--TAXON_ID y SCIENTIFIC_NAME 
	--tienen el mismo numero distinto de objetos. Es decir para cada scientific name hay exactamente 1 taxon_id --> 1560
	SELECT COUNT(DISTINCT taxon_id)
	FROM public.reduccion_borrador;
	
	SELECT COUNT(DISTINCT scientific_name)
	FROM public.reduccion_borrador;
	
	SELECT taxon_id, COUNT(DISTINCT scientific_name) AS count_scientific_name
	FROM public.reduccion_borrador
	GROUP BY taxon_id
	HAVING COUNT(DISTINCT scientific_name) > 1;
