
Select * from athlete_events

1 . How many olympics games have been held?

	Select count(distinct Games) as Total_games_held
	From athlete_events
	
2 . a) List down all Olympics games held so far.

	Select Distinct games
			From athlete_events 
			order by Games

    b) list down all olympics in year-season-city format. (ex: 1960-summer-roma)
	
	Select DISTINCT concat(Year,'-',Season,'-',city) YEAR_SEASON_CITY
		From athlete_events

3 . Mention the total no of nations who participated in each olympics game?

	Select Distinct games, city, count(Distinct NOC) Num_participants
	from athlete_events
	group by Games, city
	order by Num_participants

	Select * From athlete_events

4 . Which year saw the highest and lowest no of countries participating in olympics?

	With
		Country_participants as
		( Select distinct games, city, count(Distinct NOC) num_of_participants
		from athlete_events
		group by games, city )

	Select Games, city, num_of_participants
	from Country_participants
	where num_of_participants in(
								(Select max(num_of_participants) from Country_participants),
								(Select min(num_of_participants) from Country_participants)
								)

5 . Which nation has participated in all of the olympic games?

	select Team, count(Games) as game_cnt
	from athlete_events
	group by Team
	having count(Games) = (select count(distinct Games) from athlete_events)


	Select * from athlete_events

6 . Identify the sport which was played in all summer olympics.

	select distinct Sport, Season
	from athlete_events
	where Season = 'summer'



7 . Which Sports were just played only once in the olympics?

	select  Sport, count(distinct Games) as count_in_games
	from athlete_events 
	group by  Sport
	having count( distinct Games) = 1



8 . Fetch the total no of sports played in each olympic games.

	With Count_of_sports as
							(Select Sport, COunt(Distinct(games)) Count_sports
							From athlete_events
							group by Sport
							having COunt(Distinct(games)) = 1)
	Select sum(Count_sports) as Count_ from count_of_sports

9 . Fetch details of the oldest athletes to win a gold medal.

				With Cte_old_age as(
				Select Id, name, sex, age,
						DENSE_RANK() over (order by age desc) as rnk
					from athlete_events
				Where Medal = 'gold' )
			Select id, name, sex, age
				from Cte_old_age where rnk = 1

	Select * from athlete_events


10 . Find the Ratio of male and female athletes participated in all olympic games. -------- issue----

		Select distinct count(sex) from athlete_events where sex = 'M'
		Select distinct count(sex) from athlete_events where sex = 'F'

		with cte_distinct_name as (
select distinct Name, Sex
from athlete_events)
select round(cast(sum(case when Sex = 'M' then 1 else 0 end) as float)/count(*),3) as male_ratio,
round(cast(sum(case when Sex = 'F' then 1 else 0 end )as float)/count(*),3) as female_ratio,
count(*) as to_cnt
from cte_distinct_name


11 . Fetch the top 5 athletes who have won the most gold medals.

	Select top 5 name, Team, count(medal) medal_count
			from athlete_events
				where medal = 'gold'
				group by name, Team
				order by count(medal) desc



12 . Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).

SELECT TOP 5 
       Name,
       Team,
       SUM(CASE WHEN Medal IN ('Gold', 'Silver', 'Bronze') THEN 1 ELSE 0 END) AS total_medals   
FROM   athlete_events
GROUP  BY Name, Team
ORDER  BY total_medals DESC


13 . Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.

Select top 5
		team as country,
		Sum(case when Medal in ('Gold', 'Silver','Bronze') Then 1 Else 0 End) Total_Medals
		From athlete_events
		Group by team
		Order by Total_Medals Desc


14 . List down total gold, silver and broze medals won by each country.

with 

cte_gold as (
             select  Games, Team,  count(Medal) as gold_medal_cnt
             from athlete_events where Medal = 'Gold'
             group by Games, Team   ),

cte_silver as (
               select Games, Team,  count(Medal) as silver_medal_cnt 
			   from athlete_events where Medal = 'Silver'
               group by Games, Team  ),

cte_bronze as (
              select Games, Team,  count(Medal) as bronze_medal_cnt from athlete_events
              where Medal = 'Bronze'
              group by Games, Team   )
select a.Games, a.Team,  a.gold_medal_cnt as gold_count, b.silver_medal_cnt as silver_cnt, c.bronze_medal_cnt as bronze_cnt
from cte_gold as a
inner join cte_silver as b
on a.Team = b.Team and a.Games = b.Games
join cte_bronze as c
on a.Team = c.Team and a.Games = c.Games
order by 1 asc , 3 desc


15. In which Sport/event, India has won highest medals?

select Top 1 Sport, count(Medal) as medal_cnt 
from athlete_events
where Team = 'India' and Medal != 'NA'
group by Sport order by 2 desc


16. Break down all Olympic games where India won medal for Hockey and how many medals in each olympic games

select team, Games, Sport, count(Medal) as medal_cnt 
from athlete_events
where team = 'India' and Medal != 'NA' and Sport = 'Hockey'
group by team, Games, Sport 
order by 4 desc
