-- 9.Find the overal_rating, name and nationality of the goalkeeper that has the highest stamina
SELECT p.player_name, p.overall_rating, p.nationality, pp.stamina    
FROM players p 
	INNER JOIN player_power pp ON pp.player_id  = p.player_id
	INNER JOIN player_goalkeeping pg ON pg.player_id  = p.player_id 
WHERE pp.stamina = (SELECT MAX(pp2.stamina)
				   FROM player_power pp2)