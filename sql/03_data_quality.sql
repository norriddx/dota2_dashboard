-- Диагностика качества данных
-- В этом разделе углубленно изучаются поля, которые попадут в итоговую выборку

-- 1. Пропуски
SELECT 
	COUNT(*) AS total_count,
	COUNT(*) FILTER (WHERE m.match_id IS NULL) AS missing_match_id,
	COUNT(*) FILTER (WHERE m.duration IS NULL) AS missing_duration,
	COUNT(*) FILTER (WHERE m.radiant_win IS NULL) AS missing_radiant_win
FROM raw.matches m;

SELECT 
	COUNT(*) AS total_count,
	COUNT(*) FILTER (WHERE p.match_id IS NULL) AS missing_match_id,
	COUNT(*) FILTER (WHERE p.steam_id IS NULL) AS missing_steam_id,
	COUNT(*) FILTER (WHERE p.personaname IS NULL) AS missing_persona_name,
	COUNT(*) FILTER (WHERE p.hero_id IS NULL) AS missing_hero_id,
	COUNT(*) FILTER (WHERE p.item_0 IS NULL) AS missing_item_0,
	COUNT(*) FILTER (WHERE p."isRadiant" IS NULL) AS missing_is_radiant,
	COUNT(*) FILTER (WHERE p.win IS NULL) AS missing_win,
	COUNT(*) FILTER (WHERE p.kills_per_min IS NULL) AS missing_kills,
	COUNT(*) FILTER (WHERE p.xp_per_min IS NULL) AS missing_xp,
	COUNT(*) FILTER (WHERE p.hero_damage_per_min IS NULL) AS missing_hero_damage,
	COUNT(*) FILTER (WHERE p.hero_healing_per_min IS NULL) AS missing_hero_healing,
	COUNT(*) FILTER (WHERE p.tower_damage_per_min IS NULL) AS missing_tower_damage	
FROM raw.players p;

SELECT 
	COUNT(*) AS total_count,
	COUNT(*) FILTER (WHERE h.id IS NULL) AS missing_hero_id,
	COUNT(*) FILTER (WHERE h.localized_name IS NULL) AS missing_name,
	COUNT(*) FILTER (WHERE h.attack_type IS NULL) AS missing_attack_type,
	COUNT(*) FILTER (WHERE h.roles IS NULL) AS missing_roles
FROM raw.heroes h 

-- 2. Дубликаты идентификаторов
SELECT 
	m.match_id,
	COUNT(*) AS duplicates
FROM raw.matches m 
GROUP BY m.match_id 
HAVING COUNT(*) > 1;

SELECT 
	h.id,
	COUNT(*) AS duplicates
FROM raw.heroes h
GROUP BY h.id 
HAVING COUNT(*) > 1;

SELECT 
	p.match_id,
	p.steam_id,
	COUNT(*) AS duplicates
FROM raw.players p 
GROUP BY p.match_id, p.steam_id 
HAVING COUNT(*) > 1;

-- 3. Уникальные значения категориальных полей
-- heroes: тип атаки
SELECT h.attack_type
FROM raw.heroes h
GROUP BY h.attack_type;

-- players: предмет 1, победа в матче
SELECT p.item_0 
FROM raw.players p 
GROUP BY p.item_0
ORDER BY p.item_0;

SELECT p.win
FROM raw.players p 
GROUP BY p.win;

-- 4. Основные статистики (квартили, медиана, среднее и стандартное отклонение числовых полей)
-- показатели для длительности матчей (duration)
SELECT
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY m.duration)::NUMERIC, 2) AS q1,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY m.duration)::NUMERIC, 2) AS median,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY m.duration)::NUMERIC, 2) AS q3,
    ROUND(AVG(m.duration)::NUMERIC, 2) AS avg,
    ROUND(STDDEV(m.duration)::NUMERIC, 2) AS std
FROM raw.matches m;

-- показатели для количества убийств игроком в минуту (kills_per_min)
SELECT
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY p.kills_per_min)::NUMERIC, 2) AS q1,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY p.kills_per_min)::NUMERIC, 2) AS median,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY p.kills_per_min)::NUMERIC, 2) AS q3,
    ROUND(AVG(p.kills_per_min)::NUMERIC, 2) AS avg,
    ROUND(STDDEV(p.kills_per_min)::NUMERIC, 2) AS std
FROM raw.players p;

-- показатели для количества получаемого опыта игроком в минуту (xp_per_min)
SELECT
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY p.xp_per_min)::NUMERIC, 2) AS q1,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY p.xp_per_min)::NUMERIC, 2) AS median,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY p.xp_per_min)::NUMERIC, 2) AS q3,
    ROUND(AVG(p.xp_per_min)::NUMERIC, 2) AS avg,
    ROUND(STDDEV(p.xp_per_min)::NUMERIC, 2) AS std
FROM raw.players p;

-- показатели для урона, наносимого персонажем, в минуту (hero_damage_per_min)
SELECT
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY p.hero_damage_per_min)::NUMERIC, 2) AS q1,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY p.hero_damage_per_min)::NUMERIC, 2) AS median,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY p.hero_damage_per_min)::NUMERIC, 2) AS q3,
    ROUND(AVG(p.hero_damage_per_min)::NUMERIC, 2) AS avg,
    ROUND(STDDEV(p.hero_damage_per_min)::NUMERIC, 2) AS std
FROM raw.players p;

-- показатели для получаемого персонажем лечения в минуту (hero_healing_per_min)
SELECT
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY p.hero_healing_per_min)::NUMERIC, 2) AS q1,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY p.hero_healing_per_min)::NUMERIC, 2) AS median,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY p.hero_healing_per_min)::NUMERIC, 2) AS q3,
    ROUND(AVG(p.hero_healing_per_min)::NUMERIC, 2) AS avg,
    ROUND(STDDEV(p.hero_healing_per_min)::NUMERIC, 2) AS std
FROM raw.players p;

-- показатели для скорости персонажа в минуту (tower_damage_per_min)
SELECT
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY p.tower_damage_per_min)::NUMERIC, 2) AS q1,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY p.tower_damage_per_min)::NUMERIC, 2) AS median,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY p.tower_damage_per_min)::NUMERIC, 2) AS q3,
    ROUND(AVG(p.tower_damage_per_min)::NUMERIC, 2) AS avg,
    ROUND(STDDEV(p.tower_damage_per_min)::NUMERIC, 2) AS std
FROM raw.players p;