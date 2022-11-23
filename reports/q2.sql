-- Find the top five players with the the highest wage 

SELECT player_name, wage
FROM players
ORDER BY wage DESC
LIMIT 5
