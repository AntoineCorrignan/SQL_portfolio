# exercicesSQL_cityperc

Final challenge
You've made it to the final challenge problem! Get ready to tackle this step-by-step.

Your task is to determine the top 10 capital cities in Europe and the Americas by city_perc, a metric you'll calculate. city_perc is a percentage that calculates the "proper" population in a city as a percentage of the total population in the wider metro area, as follows:

city_proper_pop / metroarea_pop * 100

Do not use table aliasing in this exercise.

Instructions
- From cities, select the city name, country code, proper population, and metro area population, as well as the field city_perc, which calculates the proper population as a percentage of metro area population for each city (using the formula provided).
- Filter city name with a subquery that selects capital cities from countries in 'Europe' or continents with 'America' at the end of their name.
- Exclude NULL values in metroarea_pop.
- Order by city_perc (descending) and return only the first 10 rows.
