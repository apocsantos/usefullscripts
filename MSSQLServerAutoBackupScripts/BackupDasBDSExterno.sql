--Script de Backuup de bases de dados
--Dino

DECLARE @name VARCHAR(50) -- nome da bd
DECLARE @path VARCHAR(256) -- path para os ficheirosd e backup
DECLARE @fileName VARCHAR(256) -- nome dos ficherios de backup  
DECLARE @fileDate VARCHAR(20) -- usado para o nome do ficheiro

 
-- directorio para o backup
--trocar o nome do directorio
SET @path = 'E:\DINOSAUROSREX\'  


-- formato do nome do ficheiro
SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) + REPLACE(CONVERT(VARCHAR(20),GETDATE(),108),':','')

 
DECLARE db_cursor CURSOR FOR  
SELECT name 
FROM master.dbo.sysdatabases 
WHERE name NOT IN ('master','model','msdb','tempdb')  -- exclui as bd's de sistema

 
OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @name   

 
WHILE @@FETCH_STATUS = 0   
BEGIN   
       SET @fileName = @path + @name + '_' + @fileDate + '.BAK'  
       BACKUP DATABASE @name TO DISK = @fileName  

 
       FETCH NEXT FROM db_cursor INTO @name   
END   

 
CLOSE db_cursor   
DEALLOCATE db_cursor