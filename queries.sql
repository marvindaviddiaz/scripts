-- mysql size data

SELECT table_name AS "Table",
ROUND(((data_length + index_length) / 1024 / 1024 / 1024), 2) AS "Size (GB)"
FROM information_schema.TABLES
WHERE table_schema = "fel"
ORDER BY (data_length + index_length) DESC;
