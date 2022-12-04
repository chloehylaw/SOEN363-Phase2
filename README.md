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

## e-6. Indexing aggression column in player_mentality table
``` sql
CREATE INDEX PMA_INDEX 
ON player_mentality(aggression);
```
Before this indexing the cost reported by EXPLAIN SELECT is:
![6-COST-Top 20 teams with the highest number of players with agression above 80](https://user-images.githubusercontent.com/52761503/205473332-04be6b07-39e2-4983-a16a-39a75d1f2cf0.png)

And after the indexing, the cost has been reduced by 18%:
![6-COSTindex-player_mentality aggression-Top 20 teams with the highest number of players with agression above 80](https://user-images.githubusercontent.com/52761503/205473360-c462d8a8-7b2d-40ba-aa21-4566d36ba0a9.png)


## e-7. Given that player_specialities has 1787 rows, while tempo has 50 and originates from players table, let's try to index both, one after the other, and compare. 
Note: Droping indexes after each attempt.
``` sql
CREATE INDEX PSID_INDEX 
ON player_specialities(player_id);
	or 
CREATE INDEX PID_INDEX 
ON players(player_id );
```
There isn't any improvement in cost. This is due to the JOIN.

However when creating an index on overall_rating in table players, there is a massive improvement. 
``` sql
CREATE INDEX POR_INDEX 
ON players(overall_rating);
```
In fact the Hash JOIN cost drops from 1204 to 3, this is a 99% improvement:
![7-COST-What are the specialties of the top 50 rated players](https://user-images.githubusercontent.com/52761503/205473473-0a302788-832a-4f61-99b0-7f9506843238.png)

VS.
![7-COST-INDEX-ORDERBY-What are the specialties of the top 50 rated players](https://user-images.githubusercontent.com/52761503/205473484-ff66f7c3-93ca-4789-844e-9ee46ccd33a1.png)

 
``` sql
```
