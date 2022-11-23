-- Which players are from the millenial generation?

SELECT player_name, birthday
FROM players p
WHERE p.birthday
	BETWEEN '1981-01-01' AND '1996-12-31'