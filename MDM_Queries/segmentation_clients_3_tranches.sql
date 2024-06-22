
WITH 

transactions_mdm AS (
  SELECT
	  product_id
	  ,customer_id
	  ,transaction_creation_date
	  ,eur_ttc_amount
	  ,ecopart_amount
  FROM `table_transaction_mdm`
  INNER JOIN `table_referentiel_produits` USING (product_id)
  WHERE
	  type_de_produit IN ('deco','meuble','petits produits','frais de port')
	  AND transaction_creation_date BETWEEN "2023-01-01" AND "2023-12-31"
),

transactions_mkp AS (
  SELECT
	  product_id
	  ,customer_id
	  ,transaction_creation_date
	  ,eur_ttc_amount
	  ,ecopart_amount
  FROM `table_transaction_marketplace`
  INNER JOIN `table_referentiel_produits` USING (product_id)
  WHERE
	  (type_de_produit IN ('deco','meuble','petits produits','frais de port') OR type_de_produit IS NULL)
	  AND transaction_creation_date BETWEEN "2023-01-01" AND "2023-12-31"
),

transactions_all AS (
  SELECT *
  FROM transactions_mdm

  UNION ALL

  SELECT *
  FROM transactions_mkp
),

base_clients_actifs AS (
	SELECT DISTINCT
	   c.gcc_id AS id_client_gcc
	  ,SUM(t.eur_ttc_amount + t.ecopart_amount) AS va_ttc
	FROM `table_referentiel_clients` AS c
	INNER JOIN transactions_all t ON c.gcc_id = t.customer_id
	WHERE country = 'FR'
	GROUP BY gcc_id
),

base_clients_actifs_avec_tranches AS (
  SELECT DISTINCT
    id_client_gcc
    ,va_ttc
    ,CASE
      WHEN va_ttc > 0 AND va_ttc < 200 THEN "statut1__1_199" 
      WHEN va_ttc >= 200 AND va_ttc < 1000 THEN "statut2__200_999" 
      WHEN va_ttc >= 1000 THEN "statut3__1000" 
      ELSE "" END AS tranches_va_ttc
  FROM `base_clients_actifs`
  GROUP BY 
	id_client_gcc
    ,va_ttc
)

SELECT
  tranches_va_ttc AS tranches
  ,COUNT(DISTINCT CASE WHEN tranches_va_ttc <> "" THEN id_client_gcc END) AS clients_2023
FROM `base_clients_actifs_avec_tranches`
GROUP BY tranches
ORDER BY tranches 
