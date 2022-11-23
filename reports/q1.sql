-- Which left preferred foot player has the highest dribbling and ball control rating?

SELECT player_name, 
	preferred_foot,
	MAX(dribbling) AS dribbling_rating, 
	MAX(ball_control) AS ball_control_rating
FROM players p
	INNER JOIN player_profile pp ON p.player_id = pp.player_id
	INNER JOIN player_skill ps ON p.player_id = ps.player_id
WHERE pp.preferred_foot = 'Left'
GROUP BY player_name, preferred_foot
LIMIT 1
