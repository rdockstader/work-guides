USE SysInfo
GO

DECLARE
	@SupportTechID int

SELECT TOP 1
	@SupportTechID = SupportTechID
FROM
	vSupportTechs
WHERE
	UserName = 'JTI\userName' -- USERNAME GOES HERE

EXEC dbo.spExpireActiveRole @SupportTechID
GO
