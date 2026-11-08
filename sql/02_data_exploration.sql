-- Первичное знакомство с данными

-- 1. matches (таблица с информацией о прошедших матчах)
-- кол-во строк
SELECT COUNT(*) AS total
FROM raw.matches m;

-- кол-во уникальных строк
SELECT COUNT(DISTINCT m.match_id) AS total_d
FROM raw.matches m;

-- типы данных
SELECT c.column_name, c.data_type 
FROM information_schema."columns" c 
WHERE c.table_schema = 'raw'
	AND c.table_name = 'matches';

-- структура данных
SELECT *
FROM raw.matches m 
LIMIT 10;

-- предельные значения некоторых полей (из тех, которые идут в дальнейший анализ)
SELECT 
	MIN(m.duration) AS min_duration,
	MAX(m.duration) AS max_duration
FROM raw.matches m 

-- 2. players (таблица с информацией об игроках)
-- кол-во строк
SELECT COUNT(*) AS total
FROM raw.players p;

-- кол-во игроков
SELECT COUNT(DISTINCT p.steam_id) AS total_players
FROM raw.players p;

-- типы данных
SELECT c.column_name, c.data_type 
FROM information_schema."columns" c 
WHERE c.table_schema = 'raw'
	AND c.table_name = 'players';

-- структура данных
SELECT *
FROM raw.players p 
LIMIT 10;

-- предельные значения некоторых полей (из тех, которые идут в дальнейший анализ)
SELECT 
	MIN(p.kills_per_min) AS min_kills,
	MAX(p.kills_per_min) AS max_kills,
	MIN(p.xp_per_min) AS min_xp,
	MAX(p.xp_per_min) AS max_xp,
	MIN(p.hero_damage_per_min) AS min_hero_dmg,
	MAX(p.hero_damage_per_min) AS max_hero_dmg,
	MIN(p.hero_healing_per_min) AS min_healing,
	MAX(p.hero_healing_per_min) AS max_healing,
	MIN(p.tower_damage_per_min) AS min_tower_dmg,
	MAX(p.tower_damage_per_min) AS max_tower_dmg
FROM raw.players p 

-- 3. heroes (таблица с информацией об игровых персонажах)
-- кол-во строк
SELECT COUNT(*) AS total
FROM raw.heroes h;

-- кол-во персонажей
SELECT COUNT(DISTINCT h.id) AS total_heroes
FROM raw.heroes h;

-- типы данных
SELECT c.column_name, c.data_type 
FROM information_schema."columns" c 
WHERE c.table_schema = 'raw'
	AND c.table_name = 'heroes';

-- структура данных
SELECT *
FROM raw.heroes h 
LIMIT 10;

-- типы атаки
SELECT DISTINCT h.attack_type
FROM raw.heroes h;