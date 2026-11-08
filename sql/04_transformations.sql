-- Создание таблиц, используемых для дашборда

-- Таблица с основными показателями игроков и их героев
-- (в CTE создается таблица с уникальными героями, чтобы избежать дублирования строк в итоговом датасете)
CREATE TABLE analytics.dota2_dataset AS 
WITH all_heroes AS (
	SELECT 
		h.id AS hero_id,
		h.localized_name,
		h.attack_type,
		h.roles
	FROM raw.heroes h 
	GROUP BY hero_id, h.localized_name, h.attack_type, h.roles
)
SELECT 
	p.match_id,
	p.steam_id,
	p.personaname,
	p.item_0,
	CASE 
		WHEN p."isRadiant" IS TRUE THEN 'Radiant'
		ELSE 'Dire'
	END AS fraction,
	CASE 
		WHEN p.win = 0 THEN 'Победа'
		ELSE 'Проигрыш'
	END AS match_result,
	ROUND(m.duration::NUMERIC / 60) AS duration_in_min,
	p.kills_per_min,
	p.xp_per_min,
	p.hero_damage_per_min,
	p.hero_healing_per_min,
	p.tower_damage_per_min,
	p.hero_id,
	h.localized_name,
	h.attack_type,
	(REPLACE(REPLACE(h.roles, '[', '{'), ']', '}')::VARCHAR[])[1] AS first_role
FROM raw.players p
LEFT JOIN all_heroes h USING(hero_id)
LEFT JOIN raw.matches m USING(match_id);