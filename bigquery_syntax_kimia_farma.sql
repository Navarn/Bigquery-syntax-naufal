CREATE OR REPLACE TABLE `bigquery-sandbox-479609.kf_analytics_project.kf_merged` AS
SELECT
  t.transaction_id,
  t.date,
  t.branch_id,

  c.branch_name,
  c.kota,
  c.provinsi,
  c.rating AS rating_cabang,

  t.customer_name,
  t.product_id,
  p.product_name,

  t.price AS actual_price,

  COALESCE(t.discount_percentage, 0) AS discount_percentage,

  CASE
    WHEN t.price <= 50000 THEN 10
    WHEN t.price > 50000 AND t.price <= 100000 THEN 15
    WHEN t.price > 100000 AND t.price <= 300000 THEN 20
    WHEN t.price > 300000 AND t.price <= 500000 THEN 25
    WHEN t.price > 500000 THEN 30
    ELSE 0
  END AS persentase_gross_laba,

  t.price * (1 - COALESCE(t.discount_percentage, 0) / 100) AS nett_sales,
  t.price * (1 - COALESCE(t.discount_percentage, 0) / 100) *
  (
    CASE
      WHEN t.price <= 50000 THEN 0.10
      WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
      WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
      WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
      WHEN t.price > 500000 THEN 0.30
      ELSE 0
    END
  ) AS nett_profit,

  t.rating AS rating_transaksi

FROM `bigquery-sandbox-479609.kf_analytics_project.kf_final_transaction` t
LEFT JOIN `bigquery-sandbox-479609.kf_analytics_project.kf_kantor_cabang` c
  ON t.branch_id = c.branch_id
LEFT JOIN `bigquery-sandbox-479609.kf_analytics_project.kf_product` p
  ON t.product_id = p.product_id;

add sql file
