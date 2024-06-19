WITH transac AS (
    SELECT
        customer_id,
        "MDM" AS transaction_origine,
        SUM(eur_ht_amount) AS eur_ht_amount,
        SUM(uvc_qty) AS uvc_qty,
        COUNT(DISTINCT transaction_id) AS nb_tck
    FROM b_transform_orders.transaction
    INNER JOIN b_transform_products.last_products USING(product_id)
    WHERE transaction_creation_date BETWEEN '2024-01-01' AND '2024-03-31'
    AND activity IN ("mlp", "deco", "meuble")
    GROUP BY customer_id, transaction_origine

    UNION ALL

    SELECT
        customer_id,
        "MKP" AS transaction_origine,
        SUM(eur_ht_amount) AS eur_ht_amount,
        SUM(uvc_qty) AS uvc_qty,
        COUNT(DISTINCT transaction_id) AS nb_tck
    FROM `mdm-data-prod.b_transform_orders.transaction_marketplace`
    INNER JOIN b_transform_products.last_products USING(product_id)
    WHERE transaction_creation_date BETWEEN '2024-01-01' AND '2024-03-31'
    AND activity IN ("mlp", "deco", "meuble")
    GROUP BY customer_id, transaction_origine
),
client AS (
    SELECT *,
        CASE 
            WHEN achat_mdm = 1 AND achat_mkp = 1 THEN 1 
            ELSE 0 
        END AS achat_mixte
    FROM (
        SELECT
            customer_id,
            SUM(CASE WHEN transaction_origine = 'MDM' THEN eur_ht_amount ELSE 0 END) AS VA_MDM,
            SUM(CASE WHEN transaction_origine = 'MKP' THEN eur_ht_amount ELSE 0 END) AS VA_MKP,
            SUM(CASE WHEN transaction_origine = 'MDM' THEN nb_tck ELSE 0 END) AS nb_tck_MDM,
            SUM(CASE WHEN transaction_origine = 'MKP' THEN nb_tck ELSE 0 END) AS nb_tck_MKP,
            SUM(CASE WHEN transaction_origine = 'MDM' THEN uvc_qty ELSE 0 END) AS qte_MDM,
            SUM(CASE WHEN transaction_origine = 'MKP' THEN uvc_qty ELSE 0 END) AS qte_MKP,
            MAX(CASE WHEN transaction_origine = 'MDM' THEN 1 ELSE 0 END) AS achat_mdm,
            MAX(CASE WHEN transaction_origine = 'MKP' THEN 1 ELSE 0 END) AS achat_mkp
        FROM transac
        GROUP BY customer_id
    )
)
SELECT 
    achat_mixte,
    achat_mdm,
    achat_mkp,
    SUM(VA_MDM) AS VA_MDM,
    SUM(VA_MKP) AS VA_MKP,
    SUM(nb_tck_MDM) AS nb_tck_MDM,
    SUM(nb_tck_MKP) AS nb_tck_MKP,
    SUM(qte_MDM) AS qte_MDM,
    SUM(qte_MKP) AS qte_MKP,
    COUNT(DISTINCT customer_id) AS nb_clts
FROM client
GROUP BY achat_mixte, achat_mdm, achat_mkp;
