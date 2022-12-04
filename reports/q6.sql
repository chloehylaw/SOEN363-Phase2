-- 6.Top 20 teams with the highest number of players with agression above 80.
SELECT team_name, count(player_name) as number_of_players_agression_above_80 
FROM players p 
	INNER JOIN player_mentality pm ON p.player_id = pm.player_id 
	INNER JOIN team t ON p.team_id = t.team_id
WHERE pm.aggression >=80
GROUP BY team_name
ORDER BY count(player_name) DESC
LIMIT 20

	