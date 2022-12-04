--e-7.When creating an index on overall_rating in table players, there is a massive improvement. In fact the Hash JOIN cost drops from 1204 to 3, this is a 99% improvement.  
		CREATE INDEX POR_INDEX 
		ON players(overall_rating); 