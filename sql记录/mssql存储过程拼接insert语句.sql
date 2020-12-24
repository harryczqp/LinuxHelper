-- 目前存在的问题是
-- 1拼接出来的sql存在空格
-- 2null值无法处理

ALTER PROCEDURE [dbo].[BuildInsertSql]
--   @tableName AS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @sqlStr NVARCHAR(MAX)
	DECLARE @columnsStr NVARCHAR(MAX)
	SET @columnsStr=''
	DECLARE @columnsCount INT
	DECLARE @columnsStrTemp NVARCHAR(MAX)
	SET @columnsStrTemp=''
	
	SELECT @columnsCount = count(Name)-1 FROM SysColumns Where id=Object_Id('atest');
	
	
	
	DECLARE @start INT
	SET @start=0
	DECLARE @temp NVARCHAR(MAX)
	SET @temp=''
	DECLARE @datatype NVARCHAR(MAX)
	SET @datatype=''
	WHILE @start<@columnsCount 
	BEGIN -- 	while开始
	SET @start=@start+1
	
		IF @start = 1
		BEGIN
			SELECT TOP(1) @temp=NAME FROM SysColumns WHERE id=Object_Id('atest') order by id
			SET @columnsStr=@columnsStr +@temp
			
			SELECT @datatype=data_type from information_schema.columns where table_name = 'atest' AND column_name=@temp
			IF @datatype='int'
			BEGIN
			
			SET @columnsStrTemp=@columnsStrTemp +@temp
			
			END
			
			ELSE
			BEGIN
			
			SET @columnsStrTemp=@columnsStrTemp+''''''''',' +@temp+','''''''''
			
			END
			
		END
		
		IF @columnsCount>1
		BEGIN
		
			SET @columnsStr=@columnsStr +','
	SET @columnsStrTemp=@columnsStrTemp +',' +''''+','+''''
	SELECT TOP(1) @temp = NAME FROM SysColumns WHERE id=Object_Id('atest')  AND name NOT IN (SELECT TOP(@start) NAME FROM SysColumns WHERE id=Object_Id('atest') order by id) order by id;
	SET @columnsStr=@columnsStr +@temp
	
			SELECT @datatype=data_type from information_schema.columns where table_name = 'atest' AND column_name=@temp
			IF @datatype='int'
			BEGIN
			
			SET @columnsStrTemp=@columnsStrTemp +','+@temp
			
			END
			ELSE
			BEGIN
			
			SET @columnsStrTemp=@columnsStrTemp+','''''''',' +@temp+','''''''''
			
			END
		
		END
	
	END
	
			
	
	SET @sqlStr=' SELECT ''insert into atest ('+ @columnsStr +') VALUES ('''+','+@columnsStrTemp+','')'' FROM atest;'
  EXEC(@sqlStr)
-- PRINT(@columnsStrTemp)
-- PRINT(@sqlStr)

END