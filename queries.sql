-- ============================================================
-- Análisis: Gasto en Educación y Resultados Educativos
-- Base de datos: educacion.db (tabla educacion_largo)
-- Fuente: World Bank Education Statistics, 2000-2024
-- ============================================================

-- Query 1: Evolución del gasto en educación de Argentina (% PBI) en el tiempo
SELECT anio, valor
FROM educacion_largo
WHERE pais = 'Argentina'
  AND indicador = 'gasto_educacion_pib'
ORDER BY anio;


-- Query 2: Ranking de países por gasto promedio en educación (% PBI), 2000-2024
SELECT pais, ROUND(AVG(valor), 2) AS gasto_promedio_pib
FROM educacion_largo
WHERE indicador = 'gasto_educacion_pib'
GROUP BY pais
ORDER BY gasto_promedio_pib DESC;


-- Query 3: Gasto promedio vs. tasa de finalización de secundaria, por país
-- Usa CASE WHEN para "pivotear" dos indicadores distintos en la misma fila
SELECT 
    pais,
    ROUND(AVG(CASE WHEN indicador = 'gasto_educacion_pib' THEN valor END), 2) AS gasto_promedio_pib,
    ROUND(AVG(CASE WHEN indicador = 'tasa_finalizacion_secundaria' THEN valor END), 2) AS finalizacion_secundaria_promedio
FROM educacion_largo
GROUP BY pais
ORDER BY finalizacion_secundaria_promedio DESC;


-- Query 4: Brecha entre finalización de primaria y secundaria, por país
-- Cuanto mayor la brecha, más estudiantes "se pierden" entre un nivel y otro
SELECT 
    pais,
    ROUND(AVG(CASE WHEN indicador = 'tasa_finalizacion_primaria' THEN valor END), 2) AS finalizacion_primaria,
    ROUND(AVG(CASE WHEN indicador = 'tasa_finalizacion_secundaria' THEN valor END), 2) AS finalizacion_secundaria,
    ROUND(
        AVG(CASE WHEN indicador = 'tasa_finalizacion_primaria' THEN valor END) - 
        AVG(CASE WHEN indicador = 'tasa_finalizacion_secundaria' THEN valor END)
    , 2) AS brecha_primaria_secundaria
FROM educacion_largo
GROUP BY pais
ORDER BY brecha_primaria_secundaria DESC;
