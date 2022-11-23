-- Find the top ten players with the lowest agression and composure ratings

SELECT player_name, 
	MIN(aggression) AS aggression_rating, 
	MIN(composure) AS composure_rating
FROM players p
	INNER JOIN player_mentality pm ON p.player_id = pm.player_id
GROUP BY player_name
ORDER BY aggression_rating ASC, composure_rating ASC
LIMIT 10