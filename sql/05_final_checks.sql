-- Проверки итогового датасета на корректность данных

-- 1. Количество строк
SELECT 'players' AS source, COUNT(*) FROM raw.players p 
UNION ALL
SELECT 'dota2_dataset', COUNT(*) FROM analytics.dota2_dataset dd;

-- 2. Дубликаты идентификаторов строк
SELECT 
	dd.match_id,
	dd.steam_id,
	COUNT(*)
FROM analytics.dota2_dataset dd 
GROUP BY dd.match_id, dd.steam_id
HAVING COUNT(*) > 1;

-- 3. Проверка наличия null-значений
SELECT
    COUNT(*) FILTER (WHERE dd.match_id IS NULL) AS missing_match_id,
    COUNT(*) FILTER (WHERE dd.steam_id IS NULL) AS missing_steam_id,
    COUNT(*) FILTER (WHERE dd.hero_id IS NULL) AS missing_hero_id
FROM analytics.dota2_dataset dd;

-- 4. Проверка корректности типов данных
SELECT
    c.column_name,
    c.data_type
FROM information_schema."columns" c
WHERE table_schema = 'analytics'
  AND table_name = 'dota2_dataset';