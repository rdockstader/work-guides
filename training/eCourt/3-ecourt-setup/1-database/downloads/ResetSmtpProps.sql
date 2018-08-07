SELECT
	*
FROM
	ecourt.tSystemProperty
WHERE
	(keyColumn LIKE '%HOST%'	OR keyColumn LIKE '%SMTP%'	OR keyColumn LIKE '%MAIL%')


-- Uncomment to set all to XXXX
--UPDATE ecourt.tSystemProperty
--set value = 'XXXX'
--where id in (SELECT
--	id
--FROM
--	ecourt.tSystemProperty
--WHERE
--	(keyColumn LIKE '%HOST%'	OR keyColumn LIKE '%SMTP%'	OR keyColumn LIKE '%MAIL%'))