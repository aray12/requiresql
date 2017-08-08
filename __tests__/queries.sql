--@ selectAll
SELECT * FROM my_table;

--@ complexSelect
SELECT
  g.group_id,
  g.group_type_code,
  g.group_name,
  g.is_inactive,
  COALESCE(g_count.invited_count, 0) AS invited_count,
  COALESCE(g_count.following_count, 0) AS following_count,
  m.message_body,
  CASE WHEN g.sponsor_percent is NULL THEN 0 ELSE g.sponsor_percent END AS sponsor_percent,
  CASE WHEN g.sponsor_monthly_limit is NULL THEN 0 ELSE g.sponsor_monthly_limit END AS sponsor_monthly_limit,
  CASE WHEN g.brand_percent is NULL THEN 0 ELSE g.brand_percent END AS brand_percent,
  a.currency_base AS currency_group
FROM "group" AS g
LEFT OUTER JOIN account AS a ON g.account_id = a.account_id
LEFT OUTER JOIN message AS m ON g.message_id = m.message_id
LEFT OUTER JOIN (
  SELECT
    group_id,
    sum(CASE WHEN ga_count.is_following = TRUE AND ga_count.is_invited = TRUE THEN 1 END) AS following_count,
    sum(CASE WHEN ga_count.is_invited = TRUE THEN 1 END) AS invited_count
  FROM group_account AS ga_count
  GROUP BY ga_count.group_id
) AS g_count ON (g_count.group_id = g.group_id)
WHERE g.account_id = ?
ORDER BY g.group_name ASC;

--@ dropTable
DROP TABLE testing CASCADE;
