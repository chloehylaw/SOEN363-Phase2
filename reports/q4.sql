-- Which players are from the GEN X generation?

SELECT player_name, birthday
FROM players p
WHERE p.birthday
	BETWEEN '1965-01-01' AND '1980-12-31'