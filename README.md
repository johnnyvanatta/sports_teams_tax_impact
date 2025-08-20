# sports_teams_tax_impact
Looking into whether the major sports leagues in North America have a greater advantage of being competative if the teams are located in states that do not have a state income tax vs. teams that do have a state income tax 

## Table of Contents








## Power BI Dashboard
link here

## Motivation
Having worked in the sports operations for the last 7 years, I wanted to combine my previous knowledge with a topic that is relevant to today that will stretch my mind and understanding. I dicided to look at the major 4 sports leagues (MLB, NBA, NFL and NFL) but only focused on the NFL and NHL due to the MLB and NBA having greater salary cap flexibility (MLB uncapped and NBA teams can go over set cap but must pay a certain "penalty amount"). This makes financial parierty more reliable to look at in the NHL and NFL.

## Questions
1. 
2.
3.
4.
5.


## Data Tables Created
1. Teams
2. Locations
3. Salary Caps
4. Taxes

## Normalizing the data
As part of the 2005-2006 NHL CBA, a salary cap was introduced. The NFL already had league-wide salary cap in place. Therefore, my dataset includes NFL and NHL team data from the 2005-2006 season through the 2024-2025 season - exactly 20 years of data. 


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
https://www.nfl.com/standings/
