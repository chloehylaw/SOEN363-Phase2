-- 7.What are the specialties of the top 50 rated players.
SELECT tempo.PN, tempo.R, ps.player_speciality 
FROM(SELECT p.player_id AS PID, p.player_name AS PN, p.overall_rating AS R 
	FROM players p
	ORDER BY p.overall_rating DESC
	LIMIT 50) AS tempo
	INNER JOIN player_specialities ps ON tempo.PID = ps.player_id

	