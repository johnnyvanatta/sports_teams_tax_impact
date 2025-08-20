# sports_teams_tax_impact
Looking into whether the major sports leagues in North America have a greater advantage of being competative if the teams are located in states that do not have a state income tax vs. teams that do have a state income tax 

## Table of Contents








## Power BI Dashboard
link here

## Motivation
Having worked in the sports operations for the last 7 years, I wanted to combine my previous knowledge with a topic that is relevant to today that will stretch my mind and understanding. I dicided to look at the major 4 sports leagues (MLB, NBA, NFL and NFL) but only focused on the NFL and NHL due to the MLB and NBA having greater salary cap flexibility (MLB uncapped and NBA teams can go over set cap but must pay a certain "penalty amount"). This makes financial parierty more reliable to look at in the NHL and NFL.

## Questions
1. Highest Combined Tax Percentages: Which states/provinces have the highest combined tax percentages
2. State Performance Rankings: Which states produce the most successful teams based on wins, playoff appearances, and championships?
3. Tax vs Performance: Do teams in states with no income tax have higher win percentages or more championships than teams in taxed states?
4. Effective Salary Caps: What is the effective (tax-adjusted) salary cap for each team per season, and how does it compare across seasons?
5. Cap Disparity vs Highest-Taxed Teams: How does each team's effective salary cap compare to the team facing the highest combined state and federal taxes in the same season?


## Data Tables Created
1. Teams
2. Locations
3. Salary Caps
4. Taxes


## Data Dictionary
1. Teams
league - name of league
season - season of play running from fall - spring 
team_id - the id tied to the franchise due to teams rebranding or relocating. All team_ids should have 20 years worth of data except for expansion franchises in the last 20 years which are the Vegas Golden Knights and Seattle Kraken
team_name - name of the teams
w - wins
l - losses
otl - overtime losses
t - ties
pct - win percentage
pf - points for
pa - points against
net_pts - difference of points for minus points against
playoffs - indicates whether a team made the playoffs (Y/N) in a given season
conf_champ - indicates whether a team won their conference championship (Y/N) in a given season
league_champ - indicates whether a team won their league championship (Y/N) in a given season
season_rank - the final overall leauge ranking a team finished with based on pct

2. Locations
league - name of league
team_id - the id tied to the franchise due to teams rebranding or relocating. All team_ids should have 20 years worth of data except for expansion franchises in the last 20 years which are the Vegas Golden Knights and Seattle Kraken
team_name - name of the teams
team_stadium - name of the stadium or arena the team plays in
team_address - address tied to the stadium name
team_city - each team's city location
team_state - each team's state location
team_zip - each team's zipcode
team_country - each team's country location

3. Salary Caps
league - name of league
season - season of play running from fall - spring 
salary_cap - the league's salary cap ceiling for the given season
notes - any additional notes needed to be added in like "covid" or "lockout shortened season"

4. Taxes
team_state - name of states and provinces
state_abbrev - abbreviation of states and provinces
team_country - name of the country
season - given for the year of tax season
federal_tax - amount of the countrys overall federal tax for the given year
state_tax - amount of each state/province's tax for the given year
combined_tax - total amount of federal+state tax
tax_result - indicated whether each state/province has a state income tax or not (Y/N) There are 9 total states in the US (0 in Canada) that do not have state income tax (i.e Tennessee or Texas) 


5. Added Columns when tables merged
total_taxed - The total amount of money that a team in taxed (salary_cap * combined tax)
adjusted_cap - calculated by (salary_cap - total_taxed)
effective_cap - calculated by refrenceing the team with the lowest adjusted_cap in a given season and assigning it at the "effective_cap" for all the teams in the league that season
eff_cap_diff - calculated by subtracting each teams adjusted cap from the effective cap. Teams that have the lowest effecitve cap should have a $0.00 difference as they are the baseline
pct_diff - calculated by (eff_cap diff / effective_cap) to find the percentage difference, to show the spread some teams have on their ability to spend more





## Normalizing the data
- Only looked at NFL & NHL teams (detailed reasoning above in motivation)
- As part of the 2005-2006 NHL CBA, a salary cap was introduced. The NFL already had league-wide salary cap in place. Therefore, my dataset includes NFL and NHL team data from the 2005-2006 season through the 2024-2025 season - exactly 20 years of data. 
- Dataset includes teams from US and Canada, so all amounts are USD
- Only factored in federal and state income taxes. Other taxes like jock tax, capital gains taxes, city tax and taxes on investments and dividends to name a few were excluded. 
- Many states and provinces have graduated tax brackets. My assumption is that even the lowest paid NFL and NHL players still fall within the largest tax brackets. Instead of trying to calculate every states tax brackets at certain slaary amounts, I skipped right to the highest tax bracket to keep it simple. Therefore states had an amount for federal_tax, state_tax, and combined_tax (federal + state) 


## Problems and Hurdles
- Some teams rebranded or relocated over the 20 year period. Team rebranded were given their most recent name. All teams were given a unique team_id so if they relocated, they still have the same team_id. Example would be Atlanta Thrashers relocating to Winnipeg as the Winnipeg Jets. Their team_id over the 20 years were WPJE

- ## Technologies Used
1. Excel - Data was scattered across the internet and had to be cleaned through excel in order to get accurate numbers and find like minded keys to match on later one when using SQL
2. SQL - For merging all 4 of my data tables, exploration and EDA questions
3. Tableau - Used for creating maps in my presentation
4. Power BI - Main source of dashboard presentation to visualize my dataset
5. Canva - Presentation program
6. Git - Used for version control

## Data Sources
1. Teams Data Table (had to use the link to then take me to each season table for the last 20 years)
NFL - https://www.nfl.com/standings/

NHL - https://www.espn.com/nhl/standings

2. Locations Table
NFL - https://waxpackhero.com/nfl-team-addresses

NHL - https://waxpackhero.com/nhl-team-addresses


3. Salary Caps Table
NFL - https://operations.nfl.com/inside-football-ops/nfl-operations/2025-nfl-free-agency/nfl-salary-cap/

NHL - https://puckpedia.com/salary-cap/1-what-salary-cap#:~:text=Since%20its%20reintroduction%20in%20the,2025%2D2026:%20$95.5%20million

4. Taxes Data Table (Like th)
US Pre 2014 - https://files.taxfoundation.org/20190311152905/state_individualincome_rates-2000-2012-20130219.pdf?_gl=1*1q4l7rw*_gcl_au*MTE1Nzg0ODQ4NS4xNzU1MTAxMTg2

US Post 2014 -  https://taxfoundation.org/datamaps/state-individual-income-tax-rates-and-brackets/

Canada - https://www.taxtips.ca/tax-rates.htm


## Conclusion
From the 20 years of data provided, there is no clear indication that teams located in non-income tax states have won more. However, the data does suggest that teams in non-income tax states do have more financial flexability which, in turn, could lead to the team being more competive if they spend that "extra" money on the right players