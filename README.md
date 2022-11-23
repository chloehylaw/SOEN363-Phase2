# SOEN363-Phase2

## 3 Analyzing Big Data Using SQL and RDBMS Systems

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
