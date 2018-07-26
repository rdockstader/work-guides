IF EXISTS (SELECT 1 FROM sys.openkeys WHERE key_name = 'jweb_keyJusticeWebPassword')
BEGIN
	CLOSE SYMMETRIC KEY [jweb_keyJusticeWebPassword];
END

IF EXISTS (SELECT 1 FROM sys.symmetric_keys where name = 'jweb_keyJusticeWebPassword')
BEGIN
	DROP SYMMETRIC KEY [jweb_keyJusticeWebPassword];
END

IF EXISTS (SELECT 1 FROM sys.certificates WHERE name = 'jweb_certKeyEncrypt')
BEGIN
	DROP CERTIFICATE [jweb_certKeyEncrypt];
END

--This is used for the encryption of payment portal passwords in jweb_tblJusticeWebServer, and possibly user passords
-- Create the master key if it doesn't exist 
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE [name] LIKE '%DatabaseMasterKey%') 
BEGIN 
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'bdf$#&pw~MBsSADgfds^%$563#' 
END 
ELSE BEGIN 
BEGIN TRY 
-- update the master key to the current CPUID (iow, it uses DPAPI): 
OPEN MASTER KEY DECRYPTION BY PASSWORD = 'bdf$#&pw~MBsSADgfds^%$563#' 
ALTER MASTER KEY REGENERATE WITH ENCRYPTION BY PASSWORD = 'bdf$#&pw~MBsSADgfds^%$563#' 
CLOSE MASTER KEY 
END TRY 
BEGIN CATCH 
-- eat the error as we don't want to modify their custom master key should they have one (but we can still output a warning) 
RAISERROR('The MASTER KEY was already existing. If it was not created on the current database host it will need to be recreated or altered by service and the certificates that depend upon it will need to be recreated.', 1, 1) 
END CATCH 
END 
GO
-- Create the certificate to publish the encrcyption key 
IF NOT EXISTS (SELECT * FROM sys.certificates WHERE [name] = 'jweb_certKeyEncrypt') 
BEGIN 
CREATE CERTIFICATE jweb_certKeyEncrypt WITH SUBJECT = 'Publisher Key Certificate' 
END 
GO 
GRANT CONTROL ON CERTIFICATE :: jweb_certKeyEncrypt TO [jweb_CredentialsAccessor] 
-- Create the symmetric encrytion key. 
--if the aes algorithm isn;t supported, then we can use triple_des 
BEGIN TRY 
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE [name] = 'jweb_keyJusticeWebPassword') 
CREATE SYMMETRIC KEY jweb_keyJusticeWebPassword WITH ALGORITHM = AES_256 ENCRYPTION BY CERTIFICATE jweb_certKeyEncrypt; 
END TRY 
BEGIN CATCH 
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE [name] = 'jweb_keyJusticeWebPassword') 
CREATE SYMMETRIC KEY jweb_keyJusticeWebPassword WITH ALGORITHM = TRIPLE_DES ENCRYPTION BY CERTIFICATE jweb_certKeyEncrypt; 
END CATCH 
GO