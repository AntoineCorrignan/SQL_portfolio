# exercicesSQL_cityperc

J'ai commencé mon apprentissage de SQL sur Datacamp.
Ci-dessous les consignes d'un exercice que j'ai réalisé dans ce cadre, afin de mettre en pratique mes nouvelles connaissances.


*Your task is to determine the top 10 capital cities in Europe and the Americas by city_perc, a metric you'll calculate. city_perc is a percentage that calculates the "proper" population in a city as a percentage of the total population in the wider metro area, as follows:*

*city_proper_pop / metroarea_pop * 100*

*Do not use table aliasing in this exercise.*

*Instructions*
*- From cities, select the city name, country code, proper population, and metro area population, as well as the field city_perc, which calculates the proper population as a percentage of metro area population for each city (using the formula provided).*
*- Filter city name with a subquery that selects capital cities from countries in 'Europe' or continents with 'America' at the end of their name.*
*- Exclude NULL values in metroarea_pop.*
*- Order by city_perc (descending) and return only the first 10 rows.*


## Comment j'ai résolu le problème ?

Pour arriver à l'objectif j'ai :
- sélectionné les champs nécessaires depuis la table gauche "cities"
- effectué une sous-requête WHERE pour filtrer les villes dont le champ "continent" contient le nom "Europe" ou "Amerique"
- nettoyé le résultat des valeurs nulles avec une clause AND
- trié les résultats par ordre décroissant basé sur le champ "city_perc" en utilisant ORDER BY[...]DESC
- limité le retour à 10 lignes avec le mot clé LIMIT

