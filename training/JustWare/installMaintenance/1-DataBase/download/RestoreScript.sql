--Backup file needs to be placed in \\Zombie\SQL14Bkp before running this script. 

USE SysInfo
GO
 
EXEC spRestoreDatabase
       @DatabaseName = 'RD_Test_18_00',
       @BackupFile = 'RD_Test_18_00.bak'
GO 
