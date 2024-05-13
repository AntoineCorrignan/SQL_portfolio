-- Selection des champs nécessaires depuis la table cities
SELECT 
    name,
    country_code,
    city_proper_pop,
    metroarea_pop,
    (city_proper_pop / metroarea_pop * 100) AS city_perc
FROM cities
    
-- Utilisation d'une sous-requête pour filtrer sur les villes des continents contenant les mots "Europe" et "Amérique"
WHERE name IN (
    SELECT capital
    FROM countries
    WHERE continent LIKE '%Europe%'
        OR continent LIKE '%America%'
)
-- Ajout d'une condition pour nettoyer le champ metroarea_pop des données nulles
AND metroarea_pop IS NOT NULL
    
-- Tri des résultats par ordre décroissant, et limitation des résultats à 10 enregistrements
ORDER BY city_perc DESC
LIMIT 10;
