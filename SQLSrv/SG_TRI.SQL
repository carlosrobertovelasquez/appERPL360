create trigger tD_USUARIO on ERPADMIN.USUARIO for DELETE as
begin
  declare  @errno   int,
           @errmsg  VARCHAR(255)

    delete MEMBRESIA
      from ERPADMIN.MEMBRESIA,deleted
      where
        MEMBRESIA.USUARIO = deleted.USUARIO
    return
error:
    raiserror (@errno, @errmsg, 0)
    rollback transaction
end;
 

create trigger tD_ACCION on ERPADMIN.ACCION for DELETE as
begin
  declare  @errno   int,
           @errmsg  VARCHAR(255)
   
    delete OPCION_CONFIG
      from ERPADMIN.OPCION_CONFIG,deleted
      where        
        ERPADMIN.OPCION_CONFIG.ACCION = deleted.ACCION

    delete PARENTESCO
      from ERPADMIN.PARENTESCO,deleted
      where        
        ERPADMIN.PARENTESCO.PADRE = deleted.ACCION

    delete OPCION_CONFIG
      from ERPADMIN.OPCION_CONFIG,deleted
      where      
        ERPADMIN.OPCION_CONFIG.MANTENIMIENTO = deleted.ACCION

    return
error:
    raiserror (@errno, @errmsg, 0)
    rollback transaction
end;



CREATE FUNCTION ERPADMIN.SPLIT( @STRING VARCHAR (8000), @DELIMITER NVARCHAR (10) )
RETURNS @VALUETABLE TABLE ([VALUE] VARCHAR(8000))
BEGIN
 DECLARE @NEXTSTRING VARCHAR(8000)
 DECLARE @POS INT
 DECLARE @NEXTPOS INT
 DECLARE @COMMACHECK NVARCHAR(1)
 
 SET @NEXTSTRING = ''
 SET @COMMACHECK = RIGHT(@STRING,1) 
 
 SET @STRING = @STRING + @DELIMITER
 
 SET @POS = CHARINDEX(@DELIMITER,@STRING)
 SET @NEXTPOS = 1
 
 WHILE (@POS <>  0)  
 BEGIN
  SET @NEXTSTRING = SUBSTRING(@STRING,1,@POS - 1)
 
  INSERT INTO @VALUETABLE ( [VALUE]) VALUES (@NEXTSTRING)
 
  SET @STRING = SUBSTRING(@STRING,@POS +1,LEN(@STRING))
  
  SET @NEXTPOS = @POS
  SET @POS  = CHARINDEX(@DELIMITER,@STRING)
 END
 
 RETURN
END;





CREATE view ERPADMIN.V_Modulo (
	Modulo,
	NombreModulo,
	EsEstandar,
    RecordDate,
    RowPointer) as
SELECT	replace(nombreconstante, '_MAIN','') as Modulo,
	nombreaccion as nombremodulo,
	EsEstandar,
	RecordDate,
    RowPointer
FROM 	ERPADMIN.accion a
WHERE  a.EsModulo = 'S';






CREATE FUNCTION ERPADMIN.GETVALORPORNIVEL(
@psValor nvarchar(1000), @pnNivel int)
returns nvarchar(1000)
as
begin
declare @sValor nvarchar(1000),
		@sCaracter varchar(1),
		@sValorFinal nvarchar(1000),
		@sValorNivel nvarchar(1000),
		@nNivel int,
		@nTamanio int,
		@nContador int,
		@nIndice int
				

Set @sValor = @psValor
Set @sCaracter = ' '
SEt @nNivel = @pnNivel
set @sValorNivel = ''

SET @nContador = 0
SET @nIndice = 1
SET @nTamanio = len(@sValor)


WHILE @sCaracter = ' ' and @nIndice <= @nTamanio
BEGIN
    IF   (SUBSTRING(@sValor, @nIndice, 1) = '-' or 
    SUBSTRING(@sValor, @nIndice, 1) = '.'or 
    SUBSTRING(@sValor, @nIndice, 1) = ','or 
    SUBSTRING(@sValor, @nIndice, 1) = ':')
		Set @sCaracter = SUBSTRING(@sValor, @nIndice, 1)
	SET @nIndice = @nIndice + 1    
END

if @sCaracter = ' '
	return @psValor
else if @pnNivel <= 0
	return '0'

SET @nIndice = 1


WHILE @nIndice <= @nTamanio
BEGIN    
    IF SUBSTRING(@sValor, @nIndice, 1) = @sCaracter
        begin
			SET @nContador = @nContador + 1
			if (len(@sValorNivel) > 0 and REPLACE(@sValorNivel, '0', '') = '') and @nContador = @nNivel
				begin
					Set @sValorFinal = '0'
					break
				end
			else				
				Set @sValorNivel = ''
        end
    else
		set @sValorNivel = @sValorNivel + SUBSTRING(@sValor, @nIndice, 1)
    
    if @nContador < @nNivel
		set @sValorFinal  = SUBSTRING ( @sValor, 1, @nIndice)
    else
		begin
			IF SUBSTRING(@sValor, @nIndice, 1) = @sCaracter
				set @sValorFinal = @sValorFinal + @sCaracter
			else
				set @sValorFinal = @sValorFinal + '0'
		end
    
    SET @nIndice = @nIndice + 1
    
END

if @nContador + 1 < @nNivel
	set @sValorFinal = '0'
else if (len(@sValorNivel) > 0 and REPLACE(@sValorNivel, '0', '') = '') and @nContador + 1 = @nNivel
	Set @sValorFinal = '0'

return isnull(@sValorFinal,'0')
end
;








CREATE FUNCTION ERPADMIN.GETVALORHASTANIVELSINCARACTER(
@psValor nvarchar(1000), @pnNivel int)
returns nvarchar(1000)
as
begin
declare @sValor nvarchar(1000),
		@sCaracter varchar(1),
		@sValorFinal nvarchar(1000),
		@sValorNivel nvarchar(1000),
		@nNivel int,
		@nTamanio int,
		@nContador int,
		@nIndice int
				

Set @sValor = @psValor
Set @sCaracter = ' '
SEt @nNivel = @pnNivel
set @sValorNivel = ''

SET @nContador = 0
SET @nIndice = 1
SET @nTamanio = len(@sValor)


WHILE @sCaracter = ' ' and @nIndice <= @nTamanio
BEGIN
    IF   (SUBSTRING(@sValor, @nIndice, 1) = '-' or 
    SUBSTRING(@sValor, @nIndice, 1) = '.'or 
    SUBSTRING(@sValor, @nIndice, 1) = ','or 
    SUBSTRING(@sValor, @nIndice, 1) = ':')
		Set @sCaracter = SUBSTRING(@sValor, @nIndice, 1)
	SET @nIndice = @nIndice + 1    
END

if @sCaracter = ' '
	return @psValor
else if @pnNivel <= 0
	return '0'

SET @nIndice = 1


WHILE @nIndice <= @nTamanio
BEGIN
    IF SUBSTRING(@sValor, @nIndice, 1) = @sCaracter
        begin
			SET @nContador = @nContador + 1			
			if (len(@sValorNivel) > 0 and REPLACE(@sValorNivel, '0', '') = '') and @nContador = @nNivel
				begin
					Set @sValorFinal = '0'
					break
				end
			else				
				Set @sValorNivel = ''
        end
    else
		set @sValorNivel = @sValorNivel + SUBSTRING(@sValor, @nIndice, 1)
        
    if @nContador < @nNivel
		set @sValorFinal  = SUBSTRING ( @sValor, 1, @nIndice)
    
    SET @nIndice = @nIndice + 1    
END

if @nContador + 1 < @nNivel
	set @sValorFinal = '0'
else if (len(@sValorNivel) > 0 and REPLACE(@sValorNivel, '0', '') = '') and @nContador + 1 = @nNivel
	Set @sValorFinal = '0'

return isnull(REPLACE (@sValorFinal, @sCaracter, ''), '0')
end
;

CREATE FUNCTION ERPADMIN.ObtenerValores (
	@Tabla VARCHAR(30)
	, @Columna VARCHAR(30)
)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE  valores CURSOR 
		FOR SELECT VALOR_CONSTR
	                   FROM ERPADMIN.DD_CARGA_CONSTR
	                        WHERE NOMBRE_TABLA = @Tabla
	                             AND NOMBRE_COLUM = @Columna
	DECLARE @valor VARCHAR(10)
	DECLARE @retorno VARCHAR (100)
	SET @retorno = ''
	DECLARE @primero INT
	SET @primero = 0
	OPEN 	valores
	     FETCH NEXT FROM valores INTO @valor
		 WHILE @@FETCH_STATUS = 0 BEGIN
			IF @primero > 0 BEGIN
			    SET @retorno = @retorno + ','
			END
		 SET @retorno = @retorno + @valor
		 SET @primero = 1
		 FETCH NEXT FROM valores INTO @valor
	     END
	CLOSE valores
	DEALLOCATE valores
	RETURN @retorno
END;





CREATE FUNCTION ERPADMIN.PathAccionesModulos (	
	@pModulos AS VARCHAR(400)
) 
RETURNS @PathAccionesModulos TABLE (
	ACCION INT
    ,MODULO VARCHAR(250) NULL
    ,PADRE INT
    ,RUTA VARCHAR(1000) NULL	
) AS BEGIN 
	DECLARE @vACCION INT
	DECLARE @vMODULO VARCHAR(250)
	DECLARE @vPADRE INT
	DECLARE @vRUTA VARCHAR(1000)	

    DECLARE PathAcciones CURSOR FOR WITH abcd AS (               -- anchor             
                SELECT  t.ACCION, CAST((t.NOMBREACCION) AS VARCHAR(1000)) AS "Modulo", t.PADRE, 
                CAST((t.NOMBREACCION) AS VARCHAR(1000)) AS "Ruta" 
                FROM (select p.accion, a.nombreaccion, p.padre 
							from ERPADMIN.ACCION a, ERPADMIN.PARENTESCO p where a.ACCION = p.ACCION) as t
                 WHERE   t.ACCION IN(select * from ERPADMIN.split(@pModulos,',')) AND (t.PADRE IN (1) and t.PADRE <> t.ACCION)
                 UNION ALL               
                 --recursive member             
                 SELECT  t2.ACCION, 
                 case when patindex('%>%',a.Ruta) > 0 then
                 SUBSTRING(a.Ruta, 1, patindex('%>%',a.Ruta) - 1)
                 else a.Ruta end AS "Modulo", t2.PADRE,                 
                 CAST((a.Ruta + '>' + t2.NOMBREACCION ) AS VARCHAR(1000)) AS "Ruta"             
                 FROM    (select p.accion, a.nombreaccion, p.padre 
							from ERPADMIN.ACCION a, ERPADMIN.PARENTESCO p where a.ACCION = p.ACCION) AS t2                     
                 JOIN abcd AS a                       
                 ON t2.PADRE = a.accion
                 ) select * from abcd							 
	OPEN PathAcciones
	IF (ABS(@@CURSOR_ROWS)) > 0 BEGIN		
		FETCH NEXT FROM PathAcciones 
			INTO @vACCION, @vMODULO, @vPADRE, @vRUTA
		WHILE @@FETCH_STATUS >= 0 BEGIN					
			INSERT INTO @PathAccionesModulos ( ACCION, MODULO, PADRE, RUTA )
			VALUES ( @vACCION, @vMODULO, @vPADRE, @vRUTA )
			FETCH NEXT FROM PathAcciones 
			INTO @vACCION, @vMODULO, @vPADRE, @vRUTA
		END
	END
	CLOSE PathAcciones
	DEALLOCATE PathAcciones
RETURN
END;





CREATE FUNCTION ERPADMIN.ReportePrivilegios (
	@pCias AS VARCHAR(1000), 
	@pModulos AS VARCHAR(400), 
	@pUsuarioInicio AS VARCHAR(50), 
	@pUsuarioFin AS VARCHAR(50), 
	@pTipoPrivi AS VARCHAR(4), 
	@pTipoUsuario AS VARCHAR(4), 
	@pUsuarioActivo AS VARCHAR(4)	
) 
RETURNS @ReportePrivilegios TABLE (
	CONJUNTO VARCHAR(250) NULL,
	USUARIO VARCHAR(250) NULL,
	NOMBREUSUARIO VARCHAR(250) NULL,
	TIPOUSUARIO VARCHAR(50) NULL,
	USUARIOACTIVO VARCHAR(50) NULL,
	MODULO VARCHAR(250) NULL,
	DESCRIPCION VARCHAR(250) NULL
) AS BEGIN 
	DECLARE @vCONJUNTO VARCHAR(250)
	DECLARE @vUSUARIO VARCHAR(250)
	DECLARE @vNOMBREUSUARIO VARCHAR(250)
	DECLARE @vTIPOUSUARIO VARCHAR(50)
	DECLARE @vUSUARIOACTIVO VARCHAR(50)
	DECLARE @vMODULO VARCHAR(250)
	DECLARE @vDESCRIPCION VARCHAR(250)    

	DECLARE @tbl TABLE (         
	tAccion INT      
    ,tModulo VARCHAR(250)         
    ,tPadre INT
    ,tRuta VARCHAR(1000)
    )      INSERT INTO @tbl( tAccion,tModulo,tPadre,tRuta)     
    select * from ERPADMIN.PathAccionesModulos(@pModulos)

	DECLARE CursorUsuarios CURSOR FOR SELECT usuario, nombre,
		   				  case when Tipo = 'U' then 'Usuario' when Tipo = 'G' then 'Grupo' end TipoUsuario,
						  case when activo = 'S' then 'Activo' when activo = 'N' then 'Inactivo' end UsuarioActivo  
						  from ERPADMIN.usuario where usuario >= @pUsuarioInicio and usuario <= @pUsuarioFin
		   				  	 				and activo IN (select * from ERPADMIN.split(@pUsuarioActivo, ',')) 
											and tipo IN (select * from ERPADMIN.split(@pTipoUsuario, ','))
											
	DECLARE CursorCias CURSOR FOR SELECT conjunto from ERPADMIN.conjunto where conjunto in (select * from ERPADMIN.split(@pCias,','))
	
	DECLARE @CursorPropios CURSOR			 
    DECLARE @CursorHeredados CURSOR			 
	DECLARE @CursorTodos CURSOR
					 
	OPEN CursorUsuarios
	IF (ABS(@@CURSOR_ROWS)) > 0 BEGIN		
		FETCH NEXT FROM CursorUsuarios 
			INTO @vUSUARIO, @vNOMBREUSUARIO, @vTIPOUSUARIO, @vUSUARIOACTIVO
		WHILE @@FETCH_STATUS >= 0 BEGIN					
			OPEN CursorCias
			IF (ABS(@@CURSOR_ROWS)) > 0 BEGIN		
				FETCH NEXT FROM CursorCias 
					INTO @vCONJUNTO
				WHILE @@FETCH_STATUS >= 0 BEGIN						
					IF (@pTipoPrivi = 'P') BEGIN	
					    SET @CursorPropios = CURSOR FOR select t.tModulo, t.tRuta from @tbl t 
		   					 		   	 	 where t.tAccion in (select px.accion 
											 from ERPADMIN.privilegio_ex px where px.conjunto = @vCONJUNTO and px.usuario = @vUSUARIO and px.ACTIVO = 'S')
						OPEN @CursorPropios
						IF (ABS(@@CURSOR_ROWS)) > 0 BEGIN		
							FETCH NEXT FROM @CursorPropios 
								INTO @vMODULO, @vDESCRIPCION
							WHILE @@FETCH_STATUS >= 0 BEGIN
								INSERT INTO @ReportePrivilegios ( CONJUNTO, USUARIO, NOMBREUSUARIO, TIPOUSUARIO, USUARIOACTIVO, MODULO, DESCRIPCION )
								VALUES ( @vCONJUNTO, @vUSUARIO, @vNOMBREUSUARIO, @vTIPOUSUARIO, @vUSUARIOACTIVO, @vMODULO, @vDESCRIPCION )							
								FETCH NEXT FROM @CursorPropios 
								INTO @vMODULO, @vDESCRIPCION
							END
						END
						CLOSE @CursorPropios
						DEALLOCATE @CursorPropios																
					END
					IF (@pTipoPrivi = 'H') BEGIN
						SET @CursorHeredados = CURSOR FOR select t.tModulo, t.tRuta from @tbl t 
		   					 		   	 	 where t.tAccion in (select distinct(px.accion) from ERPADMIN.privilegio_ex px where px.ACTIVO = 'S' AND
											 px.conjunto = @vCONJUNTO AND px.usuario in (select grupo from ERPADMIN.membresia m where m.usuario = @vUSUARIO))
						OPEN @CursorHeredados
						IF (ABS(@@CURSOR_ROWS)) > 0 BEGIN		
							FETCH NEXT FROM @CursorHeredados 
								INTO @vMODULO, @vDESCRIPCION
							WHILE @@FETCH_STATUS >= 0 BEGIN
								INSERT INTO @ReportePrivilegios ( CONJUNTO, USUARIO, NOMBREUSUARIO, TIPOUSUARIO, USUARIOACTIVO, MODULO, DESCRIPCION )
								VALUES ( @vCONJUNTO, @vUSUARIO, @vNOMBREUSUARIO, @vTIPOUSUARIO, @vUSUARIOACTIVO, @vMODULO, @vDESCRIPCION )							
								FETCH NEXT FROM @CursorHeredados 
								INTO @vMODULO, @vDESCRIPCION
							END
						END
						CLOSE @CursorHeredados
						DEALLOCATE @CursorHeredados																		
					END
					IF (@pTipoPrivi = 'PH') BEGIN
						SET @CursorTodos = CURSOR FOR select t.tModulo, t.tRuta from @tbl t 
		   					 		   	 	 where t.tAccion in (select distinct(px.accion) from ERPADMIN.privilegio_ex px where px.conjunto = @vCONJUNTO AND 
											 px.ACTIVO = 'S' AND
											 (px.usuario = @vUSUARIO OR (px.usuario in (select grupo from ERPADMIN.membresia m where m.usuario = @vUSUARIO))))	
						OPEN @CursorTodos
						IF (ABS(@@CURSOR_ROWS)) > 0 BEGIN		
							FETCH NEXT FROM @CursorTodos 
								INTO @vMODULO, @vDESCRIPCION
							WHILE @@FETCH_STATUS >= 0 BEGIN
								INSERT INTO @ReportePrivilegios ( CONJUNTO, USUARIO, NOMBREUSUARIO, TIPOUSUARIO, USUARIOACTIVO, MODULO, DESCRIPCION )
								VALUES ( @vCONJUNTO, @vUSUARIO, @vNOMBREUSUARIO, @vTIPOUSUARIO, @vUSUARIOACTIVO, @vMODULO, @vDESCRIPCION )							
								FETCH NEXT FROM @CursorTodos 
								INTO @vMODULO, @vDESCRIPCION
							END
						END
						CLOSE @CursorTodos
						DEALLOCATE @CursorTodos															
					END															
					FETCH NEXT FROM CursorCias 
					INTO @vCONJUNTO
				END
			END
			CLOSE CursorCias									
			FETCH NEXT FROM CursorUsuarios 
			INTO @vUSUARIO, @vNOMBREUSUARIO, @vTIPOUSUARIO, @vUSUARIOACTIVO
		END
	END
	CLOSE CursorUsuarios
	DEALLOCATE CursorUsuarios
	DEALLOCATE CursorCias
RETURN
END;


CREATE FUNCTION ERPADMIN.NoCerosIzquierda
(@psValor nvarchar(1000))
returns nvarchar(1000)
as
begin
	DECLARE @lstCadena varchar(700), @lnuPosComa int
	SET @lstCadena = @psValor
	-- Si el cero no esta en la posición 1 entonces no se debe continuar
	WHILE CHARINDEX('0', @lstCadena) = 1
	BEGIN 
		--Se busca donde está ubicado el 0
		SET @lnuPosComa = CHARINDEX('0', @lstCadena)
		-- Se pasa la cadena sin el cero inicial
		SET @lstCadena = SUBSTRING(@lstCadena, @lnuPosComa + 1, LEN(@lstCadena))
	
	END
	return @lstCadena
end;

CREATE FUNCTION ERPADMIN.SF_GETDATE
(
	/* Add the parameters for the function here*/
	
)
RETURNS DATETIME
AS
BEGIN
	DECLARE @start DATETIME
	DECLARE @diff INT
	DECLARE @end DATETIME
	SET @diff = 0
	DECLARE db_cursor CURSOR FOR  	
	SELECT DIFFMINUTES 
	FROM erpadmin.TIMEZONE 
	WHERE  ISDEFAULT = 'S'
	OPEN db_cursor   
	FETCH NEXT FROM db_cursor INTO @diff
	CLOSE db_cursor
	IF @diff != 0
	BEGIN
	SET @start = GETUTCDATE()
	SET @end = DATEADD(MINUTE,@diff, @start)
	RETURN @end
	END
	ELSE
	SET @end = GETDATE()
	RETURN @end
END;
