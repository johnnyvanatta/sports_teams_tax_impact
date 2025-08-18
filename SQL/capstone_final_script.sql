--- NSS CAPSTONE PROJECT: DO NORTH AMERICAN SPORTS TEAMS HAVE A GREATER ADVANTAGE OF WINNING IF THEY ARE LOCATED IN STATES WITH NO INCOME TAX VS TEAMS IN STATES THAT DO?

SELECT *
FROM locations
	INNER JOIN taxes USING(team_state, team_country)
	INNER JOIN teams USING(league, season, team_id, team_name)
	INNER JOIN salary_caps USING(league, season)


-- EDA Questions
--Q1. Which teams are located in states with no income tax? 
-- 21 total teams (NBA, NHL, NFL) are located in non income tax states
-- 78 total teams (NBA, NHL, NFL) are located in income tax states

SELECT DISTINCT(team_name), team_state
FROM locations
	INNER JOIN taxes USING(team_state)
	INNER JOIN teams USING(league, season, team_id, team_name)
WHERE tax_result = 'N'


SELECT DISTINCT(team_name), team_state
FROM locations
	INNER JOIN taxes USING(team_state)
	INNER JOIN teams USING(league, season, team_id, team_name)
WHERE tax_result = 'Y'


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