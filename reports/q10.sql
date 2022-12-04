-- 10.Rank the Nationalities by the number of players that display a leadership trait 
SELECT nationality, Count(pt.trait)
FROM player_traits pt
	INNER JOIN players p ON pt.player_id = p.player_id 
WHERE pt.trait = 'Leadership'
GROUP BY nationality	 
ORDER BY Count(pt.trait) DESC