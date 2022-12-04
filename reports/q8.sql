-- 8.What are the defensive and offensive styles of 50 teams with highest international prestige.
SELECT t.team_name, t.international_prestige, tt.offensive_style, tt.defensive_style  
FROM team t 
INNER JOIN team_tactics tt ON tt.team_id = t.team_id 
ORDER BY t.international_prestige  DESC
LIMIT 50
	