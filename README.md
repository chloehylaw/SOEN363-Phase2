# SOEN363-Phase2

## 3 Analyzing Big Data Using SQL and RDBMS Systems

[Phase 2 Document](https://docs.google.com/document/d/1r7qiobK0oea6Uw9c8CQVzc_eg6D77Rn0BOWBvHZBb3g/edit?usp=sharing)

### (a) Chosen dataset
[FIFA 2021 Team and Player Dataset](https://www.kaggle.com/datasets/batuhandemirci/fifa-2021-team-and-player-dataset?resource=download&select=players.csv) from [Kaggle](https://www.kaggle.com/)

There are a total of 17 .csv files but 13 relevant files were chosen:

- tbl_player.csv
- tbl_player_attacking.csv
- tbl_player_defending.csv
- tbl_player_goalkeeping.csv
- tbl_player_mentality.csv
- tbl_player_movement.csv
- tbl_player_power.csv
- tbl_player_profile.csv
- tbl_player_skill.csv
- tbl_player_specialities.csv
- tbl_player_traits.csv
- tbl_team.csv
- tbl_team_tactics.csv

### (b) Create database
Database PostgreSQL v14.6

**Entity Relation Diagram (ERD)**
![Entity Relation Diagram (ERD)](https://github.com/chloehylaw/SOEN363-Phase2/blob/main/entity_relation_diagram_(ERD).png)

**Data Definition (DDL)**
``` sql
-- Team
CREATE TABLE team(
	team_id INTEGER NOT NULL,
	team_name VARCHAR(50),
	league VARCHAR(50),
	overall INTEGER,
	attack INTEGER,
	midfield INTEGER,
	defence INTEGER,
	international_prestige INTEGER,
	domestic_prestige INTEGER,
	transfer_budget INTEGER,
	PRIMARY KEY (team_id)
);

-- Team Tactics
CREATE TABLE team_tactics(
	tactic_id INTEGER NOT NULL,
	team_id INTEGER NOT NULL,
	defensive_style VARCHAR(50),
	team_width INTEGER,
	pitch_depth INTEGER,
	offensive_style VARCHAR(50),
	width INTEGER,
	players_in_box INTEGER,
	corners INTEGER,
	freekicks INTEGER,
	PRIMARY KEY (tactic_id),
	FOREIGN KEY (team_id) REFERENCES team(team_id)
);

-- Players
CREATE TABLE players(
	player_id INTEGER NOT NULL,	
	player_name VARCHAR(50),	
	positions VARCHAR(50),	
	birthday DATE,	
	height INTEGER,
	weight INTEGER,
	overall_rating INTEGER,
	potential_rating INTEGER,
	best_position VARCHAR(50),
	best_overall_rating INTEGER,
	player_value INTEGER,
	wage INTEGER,
	player_image_url VARCHAR(100),
	team_id INTEGER NOT NULL,
	nationality VARCHAR(50),
	PRIMARY KEY (player_id),
	FOREIGN KEY (team_id) REFERENCES team(team_id)
);

-- Player Attacking
CREATE TABLE player_attacking(
	attacking_id INTEGER NOT NULL,
	player_id INTEGER NOT NULL,
	crossing INTEGER,
	finishing INTEGER,
	heading_accuracy INTEGER,
	short_passing INTEGER,
	volleys INTEGER,
	PRIMARY KEY (attacking_id),
	FOREIGN KEY (player_id) REFERENCES players(player_id)
);

-- Player Defending
CREATE TABLE player_defending(
	defending_id INTEGER NOT NULL,
	player_id INTEGER NOT NULL,
	defensive_awareness INTEGER,
	standing_tackle INTEGER,
	sliding_tackle INTEGER,
	PRIMARY KEY (defending_id),
	FOREIGN KEY (player_id) REFERENCES players(player_id)
);

-- Player Goalkeeping
CREATE TABLE player_goalkeeping(
	goalkeeping_id INTEGER NOT NULL,
	player_id INTEGER NOT NULL,
	diving INTEGER,
	handling INTEGER,
	kicking INTEGER,
	positioning INTEGER,
	reflexes INTEGER,
	PRIMARY KEY (goalkeeping_id),
	FOREIGN KEY (player_id) REFERENCES players(player_id)
);

-- Player Mentality
CREATE TABLE player_mentality(
	mentality_id INTEGER NOT NULL,
	player_id INTEGER NOT NULL,
	aggression INTEGER,
	interceptions INTEGER,
	positioning INTEGER,
	vision INTEGER,
	penalties INTEGER,
	composure INTEGER,
	PRIMARY KEY (mentality_id),
	FOREIGN KEY (player_id) REFERENCES players(player_id)
);

-- Player Movement
CREATE TABLE player_movement(
	movement_id INTEGER NOT NULL,
	player_id INTEGER NOT NULL,
	acceleration INTEGER,
	sprspeed INTEGER,
	agility INTEGER,
	reactions INTEGER,
	balance INTEGER,
	PRIMARY KEY (movement_id),
	FOREIGN KEY (player_id) REFERENCES players(player_id)
);

-- Player Power
CREATE TABLE player_power(
	power_id INTEGER NOT NULL,
	player_id INTEGER NOT NULL,
	shot_power INTEGER,
	jumping INTEGER,
	stamina INTEGER,
	strength INTEGER,
	long_shots INTEGER,
	PRIMARY KEY (power_id),
	FOREIGN KEY (player_id) REFERENCES players(player_id)
);

-- Player Profile
CREATE TABLE player_profile(
	profile_id INTEGER NOT NULL,
	player_id INTEGER NOT NULL,
	preferred_foot VARCHAR(50),
	weak_foot INTEGER,
	skill_moves INTEGER,
	international_reputations INTEGER,
	work_rate VARCHAR(50),
	body_type VARCHAR(50),
	PRIMARY KEY (profile_id),
	FOREIGN KEY (player_id) REFERENCES players(player_id)
);

-- Player Skill
CREATE TABLE player_skill(
	skill_id INTEGER NOT NULL,
	player_id INTEGER NOT NULL,
	dribbling INTEGER,
	curve INTEGER,
	fk_accuracy INTEGER,
	long_passing INTEGER,
	ball_control INTEGER,
	PRIMARY KEY (skill_id),
	FOREIGN KEY (player_id) REFERENCES players(player_id)
);

-- Player Specialities
CREATE TABLE player_specialities(
	speciality_id INTEGER NOT NULL,
	player_id INTEGER NOT NULL,
	player_speciality VARCHAR(50),
	PRIMARY KEY (speciality_id),
	FOREIGN KEY (player_id) REFERENCES players(player_id)
);

-- Player Traits
CREATE TABLE player_traits(
	player_id INTEGER NOT NULL,
	trait VARCHAR(50),
	trait_id INTEGER NOT NULL,
	PRIMARY KEY (trait_id),
	FOREIGN KEY (player_id) REFERENCES players(player_id)
);
```

### (c) Loading Data
[Import CSV files to pgAdmin 4](https://learnsql.com/blog/how-to-import-csv-to-postgresql/)

### (d) Reports
1. Which left preferred foot player has the highest dribbling and ball control rating?

``` sql
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
```

2. Find the top five players with the the highest wage 

``` sql
SELECT player_name, wage
FROM players
ORDER BY wage DESC
LIMIT 5
```

3. Which players are from the millenial generation?

``` sql
SELECT player_name, birthday
FROM players p
WHERE p.birthday
	BETWEEN '1981-01-01' AND '1996-12-31'
```

4. Which players are from the GEN X generation?

``` sql
SELECT player_name, birthday
FROM players p
WHERE p.birthday
	BETWEEN '1965-01-01' AND '1980-12-31'
```

5. Find the top ten players with the lowest agression and composure ratings

``` sql
SELECT player_name, 
	MIN(aggression) AS aggression_rating, 
	MIN(composure) AS composure_rating
FROM players p
	INNER JOIN player_mentality pm ON p.player_id = pm.player_id
GROUP BY player_name
ORDER BY aggression_rating ASC, composure_rating ASC
LIMIT 10
```

6. Top 20 teams with the highest number of players with agression above 80.
``` sql
SELECT team_name, count(player_name) as number_of_players_agression_above_80 
FROM players p 
	INNER JOIN player_mentality pm ON p.player_id = pm.player_id 
	INNER JOIN team t ON p.team_id = t.team_id
WHERE pm.aggression >=80
GROUP BY team_name
ORDER BY count(player_name) DESC
LIMIT 20
```

7. What are the specialties of the top 50 rated players.
``` sql
SELECT tempo.PN, tempo.R, ps.player_speciality 
FROM(SELECT p.player_id AS PID, p.player_name AS PN, p.overall_rating AS R 
	FROM players p
	ORDER BY p.overall_rating DESC
	LIMIT 50) AS tempo
	INNER JOIN player_specialities ps ON tempo.PID = ps.player_id
```

8. What are the defensive and offensive styles of 50 teams with highest international prestige.
``` sql
SELECT t.team_name, t.international_prestige, tt.offensive_style, tt.defensive_style  
FROM team t 
INNER JOIN team_tactics tt ON tt.team_id = t.team_id 
ORDER BY t.international_prestige  DESC
LIMIT 50
```

9. Find the overal_rating, name and nationality of the goalkeeper that has the highest stamina.
``` sql
SELECT p.player_name, p.overall_rating, p.nationality, pp.stamina    
FROM players p 
	INNER JOIN player_power pp ON pp.player_id  = p.player_id
	INNER JOIN player_goalkeeping pg ON pg.player_id  = p.player_id 
WHERE pp.stamina = (SELECT MAX(pp2.stamina)
				   FROM player_power pp2)
```

10.Rank the Nationalities by the number of players that display a leadership trait.
``` sql
SELECT nationality, Count(pt.trait)
FROM player_traits pt
	INNER JOIN players p ON pt.player_id = p.player_id 
WHERE pt.trait = 'Leadership'
GROUP BY nationality	 
ORDER BY Count(pt.trait) DESC
```

### (e) Indexing

#### e-1. Using the Explain Analyze tool in pgAdmin, we notice that the cost is due to the Sequential Scan operations executed on the players, player_profile and player_skill tables. 

Given that the cost associated with player_skill and players are due to join operations :
player_profile Seq Scan filtering for preferred_foot cost 445.52
player_skill join cost 330.02
players join 572.02

	Indexing player_profile is the only viable way of reducing the cost:
		CREATE INDEX PPPF_INDEX 
		ON player_profile(preferred_foot); 

	This indexing resulted in:
player_profile Index Scan filtering for preferred_foot cost 320.06 (reduction of ~125) 
player_skill join cost 330.02
players join 572.02
	With total cost before ~1739.34 and after ~1613.88 



#### e-2. This query contains  one sequential scan and one sort operation that can benefit from indexing

	





With a total cost of  ~887.64.


	By indexing:
		CREATE INDEX Pwg_INDEX 
		ON players(wage); 
	The query operations are simplified:

	And the cost is now ~0.29
	
 


 #### e-3.  This query is straightforward and does not necessitate profound analyzing therefore, a simple EXPLAIN SELECT is sufficient to determine the cost:

Unlike the previous query, this one does not have a sort operation and can not be improved by indexing. 

#### e-4. his query is of the same type as the previous one and can not be improved by indexing

#### e-5. This query consist of two sequential Scans and one Join operation followed by and Aggregation and a Sort operation


The cost is 

It may seem that this cost can be improved by indexing but here, the Sort operation reads through all the entries to find the min. This can not be improved by indexing 

#### e-6.
Indexing aggression column in player_mentality table
CREATE INDEX PMA_INDEX 
ON player_mentality(aggression);


Before this indexing the cost reported by EXPLAIN SELECT is:


And after the indexing, the cost has been reduced by 18%:


#### e-7.
Using the Explain Analyze tool in pgAdmin, we notice that the majority of the cost is due to the operations executed on the players table. 

Sequential Scan of players with cost of 572.02
Sorting of players with cost (inclusive) 1203.25


	By creating an index on that table we stand to gain the most:
		CREATE INDEX POR_INDEX 
		ON players(overall_rating);
	
After indexing we have  eliminated the sorting step and reduced the cost of the scan
	

In fact, we reduced from a total cost of 1204.5 to a total cost of 3.4.
This is a reduction of more than 99% 

#### e-8. his query, just like in 5. does perform a Sort operation that needs to read through all the rows therefore, it can not benefit from indexing.


Compared to previous queries the cost is already respectable.

#### e-9.This is a more complex query than seen previously. It contains nested loop, aggregate, joins and it already uses a index:
	
	

To improve the cost, indexing the player_power table will be best as it is used  in both sequential scans (one is part of the nested loop and used in the aggregate)
On top of improving the non nested sequential scan, this indexing should eliminate that aggregation operation.
		CREATE INDEX PPs_INDEX 
		ON player_power(stamina);

The outcome of the indexing is as expected:


The original total cost is ~758 and after indexing this cost is ~157.
Furthermore, the aggregation is replaced by a single operation with cost of ~0.32, a significant improvement from  ~377.

##### e-10.This is a query that has one sequential scan of player_traits table to be improved by an index. 
The other sequential scan (of table players) needs to read the whole table and can not be improved through indexing.
 

The cost of the player_traits scan is ~284.27 and the total cost is ~1105.98
By indexing:
		CREATE INDEX PTt 
		ON player_traits(trait);




 The cost of the player_traits scan is now ~8.64 and the total cost is 937.75.


``` sql
```
