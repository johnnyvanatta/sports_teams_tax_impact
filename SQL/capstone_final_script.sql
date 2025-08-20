-- NSS CAPSTONE PROJECT: DO NORTH AMERICAN SPORTS TEAMS HAVE A GREATER ADVANTAGE OF WINNING IF THEY ARE LOCATED IN STATES WITH NO INCOME TAX VS TEAMS IN STATES THAT DO?

-- ONLY USING LEAGUES WHO HAVE A STRICT SALARY CAP. MLB AND NBA ARE TAKEN OUT OF CONSIDERATION DUE TO LEAGUE WIDE FLEXIBILITY ON SPENDING SO IM ONLY LOOKING AT NFL AND NHL

-- 4 Main yables brought in

SELECT *
FROM teams

SELECT *
FROM locations

SELECT *
FROM taxes

SELECT *
FROM salary_caps

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Combined base table to look at
SELECT league, season, team_id, team_name, team_state, team_country, w, l, otl, pct, net_pts, season_rank, playoffs, 
conf_champs, league_champs, tax_result, federal_tax, state_tax, combined_tax, salary_cap, 
(combined_tax * salary_cap) AS total_taxed,  (salary_cap - (combined_tax * salary_cap)) AS adjusted_cap
FROM locations
	INNER JOIN taxes USING(team_state, team_country)
	INNER JOIN teams USING(league, season, team_id, team_name)
	INNER JOIN salary_caps USING(league, season)
WHERE league = 'NFL' OR league = 'NHL'
ORDER BY season ASC, league ASC







--- ANALYSIS TABLE ---
SELECT league, season, team_id, team_name, team_state, team_country, w, l, otl, pct, net_pts, season_rank, playoffs, conf_champs, league_champs, tax_result, federal_tax, state_tax, combined_tax, salary_cap, 
(combined_tax * salary_cap) AS total_taxed,  (salary_cap - (combined_tax * salary_cap)) AS adjusted_cap, MIN(salary_cap - (combined_tax * salary_cap)) OVER (PARTITION BY league, season) AS true_cap,
 ((salary_cap - (combined_tax * salary_cap)) - MIN(salary_cap - (combined_tax * salary_cap)) OVER (PARTITION BY league, season)) AS cap_diff,
ROUND((((salary_cap - (combined_tax * salary_cap))  - MIN(salary_cap - (combined_tax * salary_cap)) OVER (PARTITION BY league, season)) / MIN(salary_cap - (combined_tax * salary_cap)) OVER (PARTITION BY league, season))::numeric, 3) AS pct_diff
FROM locations
	INNER JOIN taxes USING(team_state, team_country)
	INNER JOIN teams USING(league, season, team_id, team_name)
	INNER JOIN salary_caps USING(league, season)
WHERE league IN('NFL', 'NHL')
ORDER BY season ASC, league ASC





















-- EDA Questions

--Q1. Which teams are located in states with no income tax? 
-- 14 total teams in the NFL or NHL are located in non income tax states
-- 52 total teams (NBA, NHL, NFL) are located in income tax states

SELECT DISTINCT(team_name), team_state
FROM locations
	INNER JOIN taxes USING(team_state)
	INNER JOIN teams USING(league, season, team_id, team_name)
WHERE tax_result = 'N' 
AND (league = 'NHL' OR league = 'NFL')
ORDER BY team_name ASC



SELECT DISTINCT(team_name), team_state
FROM locations
	INNER JOIN taxes USING(team_state)
	INNER JOIN teams USING(league, season, team_id, team_name)
WHERE tax_result = 'Y' 
AND (league = 'NHL' OR league = 'NFL')
ORDER BY team_name ASC




-- Q2. Which state/province has the highest combined tax rate each year
SELECT table1.season, table1.team_state, table1.team_country, table1.combined_tax
FROM taxes table1
WHERE table1.combined_tax = (
	SELECT MAX(table2.combined_tax)
	FROM taxes table2
	WHERE table2.season = table1.season
)
ORDER BY table1.season






-- Q3. What is the average win percentage of teams grouped by state? 
-- Mass has the highest with 65% (Boston Bruins and New England Patriots)
SELECT team_state, COUNT(DISTINCT team_name) AS num_of_teams, ROUND(AVG(pct), 2) AS avg_win_pct
FROM teams
	INNER JOIN locations USING(league, team_id, team_name)
WHERE league IN('NFL','NHL')
GROUP BY team_state
ORDER BY avg_win_pct DESC




-- Q4. Which states have produced the most playoff appearances, conference champions and league champions?
-- Penn has the most in every catergory 
SELECT table2.team_state, COUNT(DISTINCT team_name) AS team_num, 
	SUM(CASE WHEN table1.playoffs = 'Y' THEN 1 ELSE 0 END) AS playoff_apps,
	SUM(CASE WHEN table1.conf_champs = 'Y' THEN 1 ELSE 0 END) AS conf_champs,
	SUM(CASE WHEN table1.league_champs = 'Y' THEN 1 ELSE 0 END) AS league_champs
FROM teams AS table1 
	INNER JOIN locations AS table2 USING(league, team_id, team_name) 
WHERE league IN('NFL', 'NHL') 
GROUP BY table2.team_state 
ORDER BY league_champs DESC





-- Q5. Compare average win % of teams in 0% state tax states vs. taxed states.
SELECT tax_result, ROUND(AVG(pct), 2) AS win_pct
FROM locations
	INNER JOIN teams USING(league, team_id, team_name)
	INNER JOIN taxes USING(season, team_state, team_country)
WHERE league IN('NFL', 'NHL')
GROUP BY tax_result
ORDER BY win_pct DESC







-- Q6. Do tax-free states win more league championships?
SELECT tax_result,
	SUM(CASE WHEN league_champs = 'Y' THEN 1 ELSE 0 END) AS champions
FROM locations
	INNER JOIN teams USING(league, team_id, team_name)
	INNER JOIN taxes USING(season, team_state, team_country)
WHERE league IN('NFL', 'NHL')
GROUP BY tax_result
ORDER BY champions DESC






---------------------------------
-- NFL highest combined tax state by year
SELECT league, season, team_id, team_name, team_state, team_country, w, l, otl, pct, net_pts, playoffs, conf_champs, league_champs, season_rank, salary_cap, combined_tax, tax_result 
FROM locations
	INNER JOIN taxes USING(team_state, team_country)
	INNER JOIN teams USING(league, season, team_id, team_name)
	INNER JOIN salary_caps USING(league, season)
WHERE league = 'NFL'
ORDER BY season ASC, combined_tax DESC


-- NFL --
WITH team_caps AS (
	SELECT season, team_name, team_state, salary_cap, combined_tax, (salary_cap * combined_tax) AS total_taxed, (salary_cap - (salary_cap * combined_tax)) AS adjusted_cap
	FROM locations
		INNER JOIN taxes USING(team_state, team_country)
		INNER JOIN teams USING(league, season, team_id, team_name)
		INNER JOIN salary_caps USING(league, season)
	WHERE league = 'NFL'
)
, min_caps AS (
    SELECT season, MIN(adjusted_cap) AS min_adjusted_cap
    FROM team_caps
    GROUP BY season
)
SELECT 
    t.season,
    t.team_name,
    t.team_state,
    t.adjusted_cap,
    m.min_adjusted_cap,
    (t.adjusted_cap - m.min_adjusted_cap) AS adjusted_cap_difference
FROM team_caps t
JOIN min_caps m USING(season)
ORDER BY t.season ASC, adjusted_cap_difference DESC;









SELECT *, (salary_cap * combined_tax) AS total_taxed, (salary_cap - (salary_cap * combined_tax)) AS adjusted_cap
FROM locations
	INNER JOIN taxes USING(team_state, team_country)
	INNER JOIN teams USING(league, season, team_id, team_name)
	INNER JOIN salary_caps USING(league, season)
WHERE league = 'NFL' OR league = 'NHL'
ORDER BY season ASC, combined_tax DESC













-------------
SELECT league, season, team_id, team_name, team_state, team_country, w, l, otl, pct, net_pts, playoffs, conf_champs, league_champs, season_rank, combined_tax, tax_result, salary_cap, notes
FROM locations
	INNER JOIN taxes USING(team_state, team_country)
	INNER JOIN teams USING(league, season, team_id, team_name)
	INNER JOIN salary_caps USING(league, season)
WHERE tax_result = 'N' 
	AND league_champs = 'Y'
ORDER BY season DESC



SELECT league, season, team_id, team_name, team_state, team_country, w, l, otl, pct, net_pts, playoffs, conf_champs, league_champs, season_rank, combined_tax, tax_result, salary_cap, notes
FROM locations
	INNER JOIN taxes USING(team_state, team_country)
	INNER JOIN teams USING(league, season, team_id, team_name)
	INNER JOIN salary_caps USING(league, season)
WHERE tax_result = 'Y' 
	AND league_champs = 'Y'
ORDER BY season DESC

SELECT team_state, ROUND(AVG(combined_tax), 3) AS avg_tax
FROM taxes
GROUP BY team_state
ORDER BY avg_tax DESC



SELECT season, ROUND(AVG(combined_tax), 3)
FROM taxes
GROUP BY season
ORDER BY season DESC



SELECT season, team_name, team_state, combined_tax, salary_cap
FROM locations
	INNER JOIN taxes USING(team_state, team_country)
	INNER JOIN teams USING(league, season, team_id, team_name)
	INNER JOIN salary_caps USING(league, season)
WHERE league = 'NHL'
ORDER BY combined_tax DESC




SELECT season, team_name, team_state, combined_tax, salary_cap
FROM locations
	INNER JOIN taxes USING(team_state, team_country)
	INNER JOIN teams USING(league, season, team_id, team_name)
	INNER JOIN salary_caps USING(league, season)
WHERE league = 'NHL' AND season = '2024-2025'
ORDER BY combined_tax ASC
LIMIT 1




SELECT season, team_name, playoffs, conf_champs, league_champs, tax_result
FROM locations
	INNER JOIN taxes USING(team_state, team_country)
	INNER JOIN teams USING(league, season, team_id, team_name)
	INNER JOIN salary_caps USING(league, season)
WHERE playoffs = 'Y'
AND tax_result = 'N'


SELECT season, team_name, playoffs, conf_champs, league_champs, tax_result
FROM locations
	INNER JOIN taxes USING(team_state, team_country)
	INNER JOIN teams USING(league, season, team_id, team_name)
	INNER JOIN salary_caps USING(league, season)
WHERE playoffs = 'Y'
AND tax_result = 'Y'




SELECT COUNT
FROM locations
	INNER JOIN taxes USING(team_state, team_country)
	INNER JOIN teams USING(league, season, team_id, team_name)
	INNER JOIN salary_caps USING(league, season)
WHERE tax_result = 'N'



SELECT COUNT(DISTINCT team_state)
FROM locations
	INNER JOIN taxes USING(team_state, team_country)
	INNER JOIN teams USING(league, season, team_id, team_name)
	INNER JOIN salary_caps USING(league, season)
WHERE tax_result = 'Y'




--- DOES STATE INCOME TAX LEAD TO MORE PLAYOFF APPEARANCES? BECUASE THERE'S MORE STATES WITH INCOME TAX, DIVIDE TOTAL PLAYOFF COUNT/STATES WITH TEAMS
SELECT tax_result, COUNT(*) FILTER (WHERE playoffs = 'Y') AS playoff_count, COUNT(DISTINCT team_state) AS team_count, ROUND((COUNT(*) FILTER (WHERE playoffs = 'Y')::numeric / COUNT(DISTINCT team_state)), 2) AS playoff_ratio
FROM locations
    INNER JOIN taxes USING(team_state, team_country)
    INNER JOIN teams USING(league, season, team_id, team_name)
    INNER JOIN salary_caps USING(league, season)
WHERE playoffs = 'Y'
    AND (league = 'NHL' OR league = 'NFL')
GROUP BY tax_result;




SELECT tax_result, COUNT(*) FILTER (WHERE playoffs = 'Y') AS playoff_count, COUNT(DISTINCT team_state) AS team_count, ROUND((COUNT(*) FILTER (WHERE playoffs = 'Y')::numeric / COUNT(DISTINCT team_state)), 2) AS playoff_ratio
FROM locations
    INNER JOIN taxes USING(team_state, team_country)
    INNER JOIN teams USING(league, season, team_id, team_name)
    INNER JOIN salary_caps USING(league, season)
WHERE playoffs = 'Y'
    AND league = 'NHL'
GROUP BY tax_result;