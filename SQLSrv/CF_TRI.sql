CREATE FUNCTION $$COMPANIA$$.GETTIPOCAMBIOFECHA(@MONEDA VARCHAR(4), @FECHA DATETIME)
RETURNS DECIMAL(28,8)
AS
BEGIN
  -- SE DECLARAN LAS VARIABLES
  DECLARE @MONTO DECIMAL(28,8) 
  
  -- SE OBTIENE EL MONTO SEGÚN LA MONEDA Y LA FECHA MÁS PROXIMA
  SELECT @MONTO = MONTO
  FROM $$COMPANIA$$.MONEDA_HIST AS A
  WHERE MONEDA = @MONEDA
    AND FECHA = (SELECT MAX(FECHA)
                 FROM $$COMPANIA$$.MONEDA_HIST AS B 
                 WHERE A.MONEDA = B.MONEDA
                   AND B.FECHA <= ISNULL(@FECHA, ERPADMIN.SF_GETDATE()))

  -- SI EL MONTO ES NULO COLOCAR UN 1    
  RETURN ISNULL(@MONTO,1)
END;





CREATE FUNCTION $$COMPANIA$$.GETTIPOCAMBIOLOCALFECHA(@FECHA DATETIME)
RETURNS DECIMAL(28,8)
AS
BEGIN
  DECLARE
    @MONTO DECIMAL(28,8),@MONEDALOCAL VARCHAR(4)
    
  -- SE OBTIENE EL CÓDIGO DE LA MONEDA LOCAL
	SELECT @MONEDALOCAL = MONEDA_LOCAL FROM $$COMPANIA$$.GLOBALES_AS	
	
  -- SE OBTIENE EL MONTO LOCAL SEGUN LA FECHA MÁS PROXIMA
  SELECT @MONTO = MONTO
  FROM $$COMPANIA$$.MONEDA_HIST AS A
  WHERE MONEDA = @MONEDALOCAL
    AND FECHA = (SELECT MAX(FECHA)
                 FROM $$COMPANIA$$.MONEDA_HIST AS B 
                 WHERE A.MONEDA = B.MONEDA
                   AND B.FECHA <= ISNULL(@FECHA, ERPADMIN.SF_GETDATE()))                   

  -- SI EL MONTO ES NULO COLOCAR UN 1
  RETURN ISNULL(@MONTO,1)
END;





CREATE FUNCTION $$COMPANIA$$.GETMONEDA(@LOCAL VARCHAR(1))
RETURNS VARCHAR(4)
AS
BEGIN
	DECLARE @MONEDA VARCHAR(4)
	
	-- SI @LOCAL ES L ENTONCES ES LA MONEDA LOCAL
	IF @LOCAL = 'L'
		SELECT @MONEDA = MONEDA_LOCAL FROM $$COMPANIA$$.GLOBALES_AS
	-- SI @LOCAL ES D ENTONCES ES LA MONEDA LOCAL
	ELSE IF @LOCAL = 'D'
		SELECT @MONEDA = MONEDA_DOLAR FROM $$COMPANIA$$.GLOBALES_AS
	-- SINO ES ND
	ELSE
		SET @MONEDA = 'ND'	
	
	RETURN @MONEDA
END;





CREATE FUNCTION $$COMPANIA$$.GETTIPOCAMBIODOLARFECHA(@FECHA DATETIME)
RETURNS DECIMAL(28,8)
AS
BEGIN
  DECLARE
    @MONTO DECIMAL(28,8), @MONEDADOLAR VARCHAR(4)
  
  -- SE OBTIENE EL CÓDIGO DE LA MONEDA DÓLAR
	SELECT @MONEDADOLAR = MONEDA_DOLAR FROM $$COMPANIA$$.GLOBALES_AS
	
  -- S OBTIENE EL MONTO DE LA MONEDA DOLAR A LA FECHA MÁS PRÓXIMA
  SELECT @MONTO = MONTO
  FROM $$COMPANIA$$.MONEDA_HIST AS A
  WHERE MONEDA = @MONEDADOLAR
    AND FECHA = (SELECT MAX(FECHA)
                 FROM $$COMPANIA$$.MONEDA_HIST AS B 
                 WHERE A.MONEDA = B.MONEDA
                   AND B.FECHA <= ISNULL(@FECHA, ERPADMIN.SF_GETDATE()))                   
    
  -- SI EL MONTO ES NULO ENTONCES COLOCARLE UN 1                                
  RETURN ISNULL(@MONTO,1)
END;





CREATE FUNCTION $$COMPANIA$$.GETMONTOLOCAL(@MONEDA AS VARCHAR(4), @MONTOMONEDA AS DECIMAL(28,8), @FECHA AS DATETIME)
RETURNS DECIMAL(28,8)
AS
BEGIN

	-- SE DECLARAN LAS VARIABLES A UTILIZAR
	DECLARE @MONTO DECIMAL(28,8), @MONEDALOCAL VARCHAR(4), @MONTOTIPOCAMBIOMONEDA  DECIMAL(28,8)
	
	-- SE PASA EL MONTO DEL DOCUMENTO A LA VARIABLE MONTO
	SET @MONTO = @MONTOMONEDA
	
	-- SE OBTIENE EL CÓDIGO DE LA MONEDA LOCAL
	SELECT @MONEDALOCAL = MONEDA_LOCAL FROM $$COMPANIA$$.GLOBALES_AS	

	-- SI EL CÓDIGO DE LA MONEDA LOCAL ES DIFERENTE AL CÓDIGO DE LA MONEDA LOCAL ENTONCES CONVERTIR EL MONTO A MONEDA LOCAL
	IF @MONEDA <> @MONEDALOCAL	
	BEGIN
		-- SE OBTIENE EL MONTO DEL TIPO DE CAMBIO A LA FECHA RESPECTIVA
		SELECT @MONTOTIPOCAMBIOMONEDA = $$COMPANIA$$.GETTIPOCAMBIOFECHA(@MONEDA, @FECHA)	
		-- SE CONVIERTE EL MONTO DE LA MONEDA AL MONTO LOCAL
		SET @MONTO = ROUND(@MONTOMONEDA * @MONTOTIPOCAMBIOMONEDA, 2)
	END
	-- SE RETORNA EL MONTO EN MONEDA LOCAL
	RETURN @MONTO
END;






CREATE FUNCTION $$COMPANIA$$.GETMONTODOLAR(@MONEDA AS VARCHAR(4), @MONTOMONEDA AS DECIMAL(28,8), @FECHA AS DATETIME)
RETURNS DECIMAL(28,8)
AS
BEGIN

	/* SE DECLARAN LAS VARIABLES A UTILIZAR*/
	DECLARE @MONTO DECIMAL(28,8), @MONTOLOCAL DECIMAL(28,8), @MONEDALOCAL VARCHAR(4), @MONEDADOLAR VARCHAR(4),
	@MONTOTIPOCAMBIOLOCAL  DECIMAL(28,8), @MONTOTIPOCAMBIODOLAR  DECIMAL(28,8), @MONTOTIPOCAMBIOMONEDA  DECIMAL(28,8)
	
	/* SE PASA EL MONTO DEL DOCUMENTO A LA VARIABLE MONTO*/
	SET @MONTO = @MONTOMONEDA
	
	/* SE OBTIENE EL CÓDIGO DE LA MONEDA DÓLAR
	SELECT @MONEDADOLAR = MONEDA_DOLAR FROM $$COMPANIA$$.GLOBALES_AS
	
	/* SI EL CÓDIGO DE LA MONEDA LOCAL ES DIFERENTE AL CÓDIGO DE LA MONEDA LOCAL ENTONCES CONVERTIR EL MONTO A MONEDA DÓLAR*/
	IF @MONEDA <> @MONEDADOLAR
	BEGIN
		/* SE PASA EL MONTO A MONEDA LOCAL
		SELECT @MONTOLOCAL = $$COMPANIA$$.GETMONTOLOCAL(@MONEDA, @MONTOMONEDA, @FECHA)
		
		/* SE OBTIENE EL TIPO DE CAMBIO DE LA MONEDA DÓLAR SEGÚN LA FECHA*/
		SELECT @MONTOTIPOCAMBIODOLAR = $$COMPANIA$$.GETTIPOCAMBIOFECHA(@MONEDADOLAR, @FECHA)
		
		/* SE CONVIERTE EL MONTO DE LA MONEDA AL MONTO DÓLAR*/
		SET @MONTO = ROUND(@MONTOLOCAL / @MONTOTIPOCAMBIODOLAR, 2)
	END

	/* SE RETORNA EL MONTO EN MONEDA DÓLAR*/
	RETURN @MONTO
END;






CREATE PROCEDURE $$COMPANIA$$.Sp_cf_saldo_inicial_flujo_caja 
	@FLUJOCAJAIN   VARCHAR (20), 
	@SALDOLOCALOUT DECIMAL (28, 8) out, 
	@SALDODOLAROUT DECIMAL (28, 8) out 
AS 
  BEGIN 
      DECLARE @SALDOLOCAL         DECIMAL(28, 8) = 0, 
              @DMONTOLOCAL        DECIMAL(28, 8) = 0, 
              @CMONTOLOCAL        DECIMAL(28, 8) = 0, 
              @SALDOCAJALOCAL     DECIMAL(28, 8) = 0, 
              @SALDOCAJALOCALDP   DECIMAL(28, 8) = 0, 
              @SALDOCAJALOCALHIST DECIMAL(28, 8) = 0, 
              @EXISTE             INT = 0, 
              @USACB              VARCHAR(1) = 'N', 
              @FechaInicial       DATETIME 

      SELECT @EXISTE = Count(CB.cuenta_banco) 
      FROM   $$COMPANIA$$.cuenta_bancaria CB 
             INNER JOIN $$COMPANIA$$.flujo_caja_cuenta_banco FCCB 
                     ON CB.cuenta_banco = FCCB.cuenta_banco 
      WHERE  fccb.flujo_caja = @FLUJOCAJAIN 
             AND CB.participa_flujocaja = 'S' 
             AND CB.activa = 'S' 
             AND FCCB.activo = 'S' 

      SELECT @FechaInicial = fecha_inicial 
      FROM   $$COMPANIA$$.flujo_caja 
      WHERE  flujo_caja = @FLUJOCAJAIN 

      IF @EXISTE > 0 
        BEGIN 
            SELECT @DMONTOLOCAL = Isnull(Sum($$COMPANIA$$.Getmontolocal(cb.moneda, monto, fc.fecha_inicial)), 0) 
            FROM   $$COMPANIA$$.cuenta_bancaria CB 
                   INNER JOIN $$COMPANIA$$.flujo_caja_cuenta_banco FCCB 
                           ON CB.cuenta_banco = FCCB.cuenta_banco 
                   INNER JOIN $$COMPANIA$$.mov_bancos mb 
                           ON cb.cuenta_banco = mb.cuenta_banco 
                   INNER JOIN $$COMPANIA$$.flujo_caja fc 
                           ON fc.flujo_caja = FCCB.flujo_caja 
            WHERE  fccb.flujo_caja = @FLUJOCAJAIN 
                   AND CB.participa_flujocaja = 'S' 
                   AND CB.activa = 'S' 
                   AND FCCB.activo = 'S' 
                   AND mb.fecha < fc.fecha_inicial 
                   AND mb.tipo_documento IN ( 'DEP', 'N/C', 'O/C', 'T/C' ) 

            SELECT @CMONTOLOCAL = Isnull(Sum($$COMPANIA$$.Getmontolocal(cb.moneda, monto, fc.fecha_inicial)), 0) 
            FROM   $$COMPANIA$$.cuenta_bancaria CB 
                   INNER JOIN $$COMPANIA$$.flujo_caja_cuenta_banco FCCB 
                           ON CB.cuenta_banco = FCCB.cuenta_banco 
                   INNER JOIN $$COMPANIA$$.mov_bancos mb 
                           ON cb.cuenta_banco = mb.cuenta_banco 
                   INNER JOIN $$COMPANIA$$.flujo_caja fc 
                           ON fc.flujo_caja = FCCB.flujo_caja 
            WHERE  fccb.flujo_caja = @FLUJOCAJAIN 
                   AND CB.participa_flujocaja = 'S' 
                   AND CB.activa = 'S' 
                   AND FCCB.activo = 'S' 
                   AND mb.fecha < fc.fecha_inicial 
                   AND mb.tipo_documento IN ( 'CHQ', 'N/D', 'O/D', 'T/D' ) 

            SET @SALDOLOCAL = @DMONTOLOCAL - @CMONTOLOCAL 
        END 

      SELECT @EXISTE = Count(0) 
      FROM   erpadmin.modulo_instalado 
      WHERE  accion = 2592 
             AND conjunto = '$$COMPANIA$$' 

      IF @EXISTE > 0 
        BEGIN 
            SELECT @EXISTE = Count(caja_chica) 
            FROM   $$COMPANIA$$.caja_chica 
            WHERE  participa_flujocaja = 'S' 
                   AND saldo <> 0 

            IF @EXISTE > 0 
              BEGIN 
                  SELECT @USACB = integracion_cb 
                  FROM   $$COMPANIA$$.globales_ch 

                  IF @USACB = 'S' 
                    BEGIN 
                        SELECT @SALDOCAJALOCAL = Sum($$COMPANIA$$.Getmontolocal(ch.moneda, ch.monto_caja, fc.fecha_inicial)) 
                        FROM   $$COMPANIA$$.caja_chica CH 
                               INNER JOIN $$COMPANIA$$.caja_banco cb 
                                       ON cb.caja_chica = ch.caja_chica 
                               INNER JOIN $$COMPANIA$$.cuenta_bancaria cbr 
                                       ON cbr.cuenta_banco = cb.cuenta_banco 
                               INNER JOIN $$COMPANIA$$.flujo_caja_cuenta_banco fccb 
                                       ON fccb.cuenta_banco = cbr.cuenta_banco 
                               INNER JOIN $$COMPANIA$$.flujo_caja fc 
                                       ON fc.flujo_caja = fccb.flujo_caja 
                        WHERE  fc.flujo_caja = @FLUJOCAJAIN 
                               AND CH.participa_flujocaja = 'S' 
                               AND CBR.participa_flujocaja = 'S' 
                               AND CBR.activa = 'S' 
                               AND FCCB.activo = 'S' 

                        SELECT @SALDOCAJALOCALDP = Isnull( Sum($$COMPANIA$$.Getmontolocal (ch.moneda, V.monto_caja, fc.fecha_inicial)), 0) 
						FROM   $$COMPANIA$$.caja_chica CH 
								INNER JOIN $$COMPANIA$$.vale V 
									ON CH.caja_chica = V.caja_chica 
								INNER JOIN $$COMPANIA$$.caja_banco cb 
									ON cb.caja_chica = ch.caja_chica 
								INNER JOIN $$COMPANIA$$.cuenta_bancaria cbr 
									ON cbr.cuenta_banco = cb.cuenta_banco 
								INNER JOIN $$COMPANIA$$.flujo_caja_cuenta_banco fccb 
									ON fccb.cuenta_banco = cbr.cuenta_banco 
								INNER JOIN $$COMPANIA$$.flujo_caja fc 
									ON fc.flujo_caja = fccb.flujo_caja 
						WHERE	fc.flujo_caja = @FLUJOCAJAIN 
								AND CH.participa_flujocaja = 'S' 
								AND V.estado IN ( 'P', 'D' ) 
								AND CBR.participa_flujocaja = 'S' 
								AND CBR.activa = 'S' 
								AND FCCB.activo = 'S' 
								AND v.fecha_emision < fc.fecha_inicial 

						SELECT @SALDOCAJALOCALHIST = Isnull(Sum($$COMPANIA$$.Getmontolocal 
						(ch.moneda, 
						V.monto_caja, 
						fc.fecha_inicial)), 0) 
						FROM   $$COMPANIA$$.caja_chica CH 
								INNER JOIN $$COMPANIA$$.vale V 
									ON CH.caja_chica = V.caja_chica 
								INNER JOIN $$COMPANIA$$.caja_banco cb 
									ON cb.caja_chica = ch.caja_chica 
								INNER JOIN $$COMPANIA$$.cuenta_bancaria cbr 
									ON cbr.cuenta_banco = cb.cuenta_banco 
								INNER JOIN $$COMPANIA$$.flujo_caja_cuenta_banco fccb 
									ON fccb.cuenta_banco = cbr.cuenta_banco 
								INNER JOIN $$COMPANIA$$.flujo_caja fc 
									ON fc.flujo_caja = fccb.flujo_caja 
						WHERE	fc.flujo_caja = @FLUJOCAJAIN 
								AND CH.participa_flujocaja = 'S' 
								AND V.estado = 'H' 
								AND CBR.participa_flujocaja = 'S' 
								AND CBR.activa = 'S' 
								AND FCCB.activo = 'S' 
								AND v.fecha_liquidacion < fc.fecha_inicial 

						SET @SALDOCAJALOCAL = @SALDOCAJALOCAL - ( @SALDOCAJALOCALHIST + @SALDOCAJALOCALDP ) 
					END 
				ELSE 
					BEGIN 
						SELECT @SALDOCAJALOCAL = Sum($$COMPANIA$$.Getmontolocal (ch.moneda, CH.monto_caja, @FechaInicial)) 
						FROM   $$COMPANIA$$.caja_chica CH 
						WHERE  CH.participa_flujocaja = 'S' 

						SELECT @SALDOCAJALOCALDP = Isnull(Sum($$COMPANIA$$.Getmontolocal (ch.moneda, V.monto_caja, @FechaInicial)), 0) 
						FROM   $$COMPANIA$$.caja_chica CH 
						INNER JOIN $$COMPANIA$$.vale V 
						ON CH.caja_chica = V.caja_chica 
						WHERE  CH.participa_flujocaja = 'S' 
						AND V.estado IN ( 'P', 'D' ) 
						AND v.fecha_emision < @FechaInicial 

						SELECT @SALDOCAJALOCALHIST = Isnull(Sum($$COMPANIA$$.Getmontolocal (ch.moneda, V.monto_caja, @FechaInicial)), 0) 
						FROM   $$COMPANIA$$.caja_chica CH 
						INNER JOIN $$COMPANIA$$.vale V 
						ON CH.caja_chica = V.caja_chica 
						WHERE  CH.participa_flujocaja = 'S' 
						AND V.estado = 'H' 
						AND v.fecha_liquidacion < @FechaInicial 

						SET @SALDOCAJALOCAL = @SALDOCAJALOCAL - ( @SALDOCAJALOCALHIST + 
						@SALDOCAJALOCALDP ) 
					END 
			END 
        END 

      SELECT @SALDOLOCALOUT = ( @SALDOLOCAL + @SALDOCAJALOCAL ), @SALDODOLAROUT = $$COMPANIA$$.Getmontodolar($$COMPANIA$$.Getmoneda('L'), @SALDOLOCAL + @SALDOCAJALOCAL, @FechaInicial) 
  END;





CREATE PROCEDURE $$COMPANIA$$.SP_CF_REPORTE_FLUJO_CAJA
  @MONEDA   VARCHAR(20),
  @MONEDAEJECUTADO VARCHAR(25),
  @PARFLUJOCAJA VARCHAR(20),
  @VERSION  INT,
  @NATINGRESO VARCHAR(3),
  @NATEGRESO VARCHAR(3),
  @SELECTV VARCHAR(MAX) OUTPUT
 AS
 BEGIN
  
  DECLARE @CONSECUTIVO INT,
    @PERIODO VARCHAR(1),
    @FLUJOCAJA  VARCHAR(20),
    @FECHAINICIAL DATETIME,
    @FECHAFINAL DATETIME,
    @SELECTCMD VARCHAR(MAX),
    @FROMCMD VARCHAR(MAX),
    @COLUMNA VARCHAR(150),
    @COLUMNAEJECUTADO VARCHAR(150)
  
  SELECT @NATINGRESO = CHAR(39)  +  @NATINGRESO  + CHAR(39)
  SELECT @NATEGRESO = CHAR(39)  +  @NATEGRESO + CHAR(39)
  
  DECLARE PERFLUJO CURSOR
  FOR 
   SELECT CONSECUTIVO,
     FLUJO_CAJA,
     TIPO_PERIODO,
     FECHA_INICIAL,
     FECHA_FINAL
   FROM 
     $$COMPANIA$$.PERIODOS_FLUJO_CAJA
   WHERE FLUJO_CAJA = @PARFLUJOCAJA

  OPEN PERFLUJO
  
  FETCH PERFLUJO INTO @CONSECUTIVO,
       @FLUJOCAJA,
       @PERIODO,
       @FECHAINICIAL,
       @FECHAFINAL
       
  SELECT @SELECTCMD = 'SELECT 
        rp.RUBRO_HIJO as CODIGO,' +
        CHAR(39) + ' ' + CHAR(39) + ' DOCUMENTO,' +
        'rf.NOMBRE as ' + CHAR(39) + 'DESCRIPCION' + CHAR(39) + ',' +
        'rp.RUBRO_PADRE as Padre,' +
        'rp.NATURALEZA as ' + CHAR(39) + 'Naturaleza' + CHAR(39)
               
  SELECT @FROMCMD = ' FROM 
        $$COMPANIA$$.CALCULO_FLUJO_CAJA rp
       INNER JOIN
        $$COMPANIA$$.RUBRO_FLUJO_CAJA rf
       ON  
         rp.RUBRO_HIJO = rf.RUBRO_HIJO AND
         rp.RUBRO_PADRE = rf.RUBRO_PADRE AND
         rp.NATURALEZA = rf.NATURALEZA AND
         rp.FLUJO_CAJA = rf.FLUJO_CAJA
       INNER JOIN
        $$COMPANIA$$.VERSION_FLUJO_CAJA vfc
       ON
        vfc.FLUJO_CAJA = rp.FLUJO_CAJA AND
        rp.VERSION = vfc.VERSION
       WHERE rp.FLUJO_CAJA = '+ CHAR(39) + @PARFLUJOCAJA + CHAR(39) +
       ' AND (rp.NATURALEZA = '+@NATINGRESO + ' OR rp.NATURALEZA= ' + @NATEGRESO + ')        
       AND rp.VERSION = '+ CONVERT(VARCHAR(2),@VERSION) + '
       GROUP BY
        rp.FLUJO_CAJA, 
        rp.NATURALEZA, 
        rp.RUBRO_PADRE, 
        rp.RUBRO_HIJO, 
        rf.NOMBRE'
    
  WHILE(@@FETCH_STATUS = 0)
  BEGIN
  
   SELECT @COLUMNA = $$COMPANIA$$.CF_GETNAMECOLUMN ( @FLUJOCAJA,@FECHAINICIAL,@FECHAFINAL,@MONEDA)
   SELECT @COLUMNAEJECUTADO = $$COMPANIA$$.CF_GETNAMECOLUMN ( @FLUJOCAJA,@FECHAINICIAL,@FECHAFINAL,@MONEDAEJECUTADO)
   
   SELECT @SELECTCMD = @SELECTCMD +
        ','  +  @COLUMNA  + ' = ' + 
        ' 
         ISNULL(SUM(
          CASE 
          WHEN rp.CONSECUTIVO_PERIODO = '+ CONVERT(VARCHAR,@CONSECUTIVO) +'
          THEN ISNULL(rp.'+@MONEDA+',0)
          END
         ),0)
        '
   SELECT @SELECTCMD = @SELECTCMD +
        ','  +  @COLUMNAEJECUTADO + ' = ' + 
        ' 
         ISNULL(SUM(
          CASE 
          WHEN rp.CONSECUTIVO_PERIODO = '+ CONVERT(VARCHAR,@CONSECUTIVO) +'
          THEN ISNULL(rp.'+@MONEDAEJECUTADO+',0)
          END
         ),0)
        '
   FETCH PERFLUJO INTO @CONSECUTIVO,
        @FLUJOCAJA,
        @PERIODO,
        @FECHAINICIAL,
        @FECHAFINAL
  END   
  CLOSE PERFLUJO
  DEALLOCATE PERFLUJO
  
  SELECT @SELECTV = @SELECTCMD + @FROMCMD
 END;







CREATE PROCEDURE $$COMPANIA$$.SP_CALCULO_FLUJO_CAJA
  @PARFLUJOCAJA VARCHAR(20),
  @MONEDA   VARCHAR(20),
  @MONEDAEJECUTADO   VARCHAR(25),
  @VERSION  INT,
  @PARFECHAINICIAL DATETIME,
  @PARFECHAFINAL DATETIME,
  @SELECTV  VARCHAR(MAX) OUTPUT
 AS
 BEGIN
  
  DECLARE @CONSECUTIVO INT,
    @PERIODO VARCHAR(1),
    @FLUJOCAJA  VARCHAR(20),
    @FECHAINICIAL DATETIME,
    @FECHAFINAL DATETIME,
    @SELECTCMD VARCHAR(MAX),
    @FROMCMD VARCHAR(MAX),
    @COLUMNA VARCHAR(150),
    @COLUMNAEJECUTACO VARCHAR(150)
    
  DECLARE PERFLUJO CURSOR
  FOR 
   SELECT CONSECUTIVO,
     FLUJO_CAJA,
     TIPO_PERIODO,
     FECHA_INICIAL,
     FECHA_FINAL
   FROM 
     $$COMPANIA$$.PERIODOS_FLUJO_CAJA
   WHERE FLUJO_CAJA = @PARFLUJOCAJA
   AND (FECHA_INICIAL >= @PARFECHAINICIAL
   AND FECHA_FINAL <= @PARFECHAFINAL)
 
  OPEN PERFLUJO
 
  FETCH PERFLUJO INTO @CONSECUTIVO,
       @FLUJOCAJA,
       @PERIODO,
       @FECHAINICIAL,
       @FECHAFINAL
       
  SELECT @SELECTCMD = 'SELECT 
        rp.FLUJO_CAJA +' + CHAR(39) + '-' + CHAR(39) + ' + rp.NATURALEZA + ' + CHAR(39) + '-' + CHAR(39) + '+rp.RUBRO_HIJO as HIJO,' +
          'rp.FLUJO_CAJA +' + CHAR(39) + '-' + CHAR(39) + '+ rp.NATURALEZA + ' + CHAR(39) + '-' + CHAR(39) + '+rp.RUBRO_PADRE as PADRE,' +
          'rp.FLUJO_CAJA, 
        rp.NATURALEZA, 
        rp.RUBRO_PADRE, 
        rp.RUBRO_HIJO, 
        rfc.NOMBRE'
 
  SELECT @FROMCMD = ' FROM 
        $$COMPANIA$$.CALCULO_FLUJO_CAJA rp,
        $$COMPANIA$$.RUBRO_FLUJO_CAJA rfc,
        $$COMPANIA$$.VERSION_FLUJO_CAJA vfc
       WHERE RP.FLUJO_CAJA = '+ CHAR(39) +@PARFLUJOCAJA + CHAR(39) +'
       AND rp.FLUJO_CAJA = rfc.FLUJO_CAJA
       AND rp.RUBRO_HIJO = rfc.RUBRO_HIJO
       AND rp.VERSION = vfc.VERSION 
       AND rp.RUBRO_PADRE = rfc.RUBRO_PADRE
       AND rp.NATURALEZA = rfc.NATURALEZA 
       AND rp.FLUJO_CAJA = vfc.FLUJO_CAJA 
       AND rp.VERSION = '+ CONVERT(VARCHAR(2),@VERSION) + '
       GROUP BY
        rp.FLUJO_CAJA, 
        rp.NATURALEZA, 
        rp.RUBRO_PADRE, 
        rp.RUBRO_HIJO, 
        rfc.NOMBRE
       ORDER BY
        rp.NATURALEZA desc'
    
  WHILE(@@FETCH_STATUS = 0)
  BEGIN
  
   SELECT @COLUMNA = $$COMPANIA$$.CF_GETNAMECOLUMN ( @FLUJOCAJA,@FECHAINICIAL,@FECHAFINAL,@MONEDA)
   SELECT @COLUMNAEJECUTACO = $$COMPANIA$$.CF_GETNAMECOLUMN ( @FLUJOCAJA,@FECHAINICIAL,@FECHAFINAL,@MONEDAEJECUTADO)
   
   SELECT @SELECTCMD =  @SELECTCMD +
        ','  +  @COLUMNA  + ' = ' + 
        ' 
         ISNULL(SUM(
          CASE 
          WHEN rp.CONSECUTIVO_PERIODO = '+ CONVERT(VARCHAR,@CONSECUTIVO) +'
          THEN ISNULL(rp.'+@MONEDA+',0)
          END
         ),0)
        '
    SELECT @SELECTCMD =  @SELECTCMD +
        ','  +  @COLUMNAEJECUTACO  + ' = ' + 
        ' 
         ISNULL(SUM(
          CASE 
          WHEN rp.CONSECUTIVO_PERIODO = '+ CONVERT(VARCHAR,@CONSECUTIVO) +'
          THEN ISNULL(rp.'+@MONEDAEJECUTADO+',0)
          END
         ),0)
        '
         
   FETCH PERFLUJO INTO @CONSECUTIVO,
        @FLUJOCAJA,
        @PERIODO,
        @FECHAINICIAL,
        @FECHAFINAL
  END
  
  CLOSE PERFLUJO
  DEALLOCATE PERFLUJO
  SELECT @SELECTV = @SELECTCMD + @FROMCMD
 END;





CREATE FUNCTION $$COMPANIA$$.CF_GETNAMECOLUMN 
  (@FLUJOCAJA VARCHAR(20), @FECHAINICIO DATETIME, @FECHAFINAL DATETIME, @MONEDA VARCHAR(25))
  RETURNS VARCHAR(100)
  WITH EXECUTE AS CALLER
  AS
  BEGIN
  
   DECLARE @PERIODO VARCHAR(1),
     @COLUMNANOMBRE VARCHAR(100)
   SELECT 
    @PERIODO = TIPO_PERIODO 
   FROM 
    $$COMPANIA$$.FLUJO_CAJA
   WHERE 
    FLUJO_CAJA = @FLUJOCAJA
 
 SELECT @COLUMNANOMBRE = 
    CASE
     WHEN @PERIODO = 'M' 
     THEN
      char(39) + (CASE 
        WHEN CONVERT(VARCHAR,Month(@FECHAINICIO)) = '1' THEN 'Enero' 
        WHEN CONVERT(VARCHAR,Month(@FECHAINICIO)) = '2' THEN 'Febrero' 
        WHEN CONVERT(VARCHAR,Month(@FECHAINICIO)) = '3' THEN 'Marzo' 
        WHEN CONVERT(VARCHAR,Month(@FECHAINICIO)) = '4' THEN 'Abril' 
        WHEN CONVERT(VARCHAR,Month(@FECHAINICIO)) = '5' THEN 'Mayo' 
        WHEN CONVERT(VARCHAR,Month(@FECHAINICIO)) = '6' THEN 'Junio' 
        WHEN CONVERT(VARCHAR,Month(@FECHAINICIO)) = '7' THEN 'Julio' 
        WHEN CONVERT(VARCHAR,Month(@FECHAINICIO)) = '8' THEN 'Agosto' 
        WHEN CONVERT(VARCHAR,Month(@FECHAINICIO)) = '9' THEN 'Setiembre' 
        WHEN CONVERT(VARCHAR,Month(@FECHAINICIO)) = '10' THEN 'Octubre' 
        WHEN CONVERT(VARCHAR,Month(@FECHAINICIO)) = '11' THEN 'Noviembre' 
        WHEN CONVERT(VARCHAR,Month(@FECHAINICIO)) = '12' THEN 'Diciembre' 
        END) + ' ' + CONVERT(VARCHAR,YEAR(@FECHAINICIO)) 
     WHEN @PERIODO = 'A'
     THEN 
      char(39) + 'AÃ±o: ' + CONVERT(VARCHAR,YEAR(@FECHAINICIO))
     WHEN @PERIODO = 'S'
     THEN
      char(39) + 'Semana del: ' + CONVERT(VARCHAR,@FECHAINICIO,103) + 
            ' al ' +  CONVERT(VARCHAR,@FECHAFINAL,103) 
     WHEN @PERIODO = 'D'
     THEN	
		CHAR(39) +  CONVERT(VARCHAR,@FECHAINICIO,3)
     END
    
   SELECT  @COLUMNANOMBRE =
     CASE
      WHEN @MONEDA = 'MONTO_TOTAL_LOCAL'
      THEN
       @COLUMNANOMBRE +  ' (Local) Estimado' + char(39)
      WHEN @MONEDA = 'MONTO_TOTAL_DOLAR'
      THEN
       @COLUMNANOMBRE + ' (Dolar) Estimado' + char(39)
      WHEN @MONEDA = 'MONTO_TOTAL_LOCAL_EJE'
      THEN
       @COLUMNANOMBRE +  ' (Local) Ejecutado' + char(39)
      WHEN @MONEDA = 'MONTO_TOTAL_DOLAR_EJE'
      THEN
       @COLUMNANOMBRE + ' (Dolar) Ejecutado' + char(39)
      END
   RETURN (@COLUMNANOMBRE) 
 END;




CREATE VIEW $$COMPANIA$$.V_SALDO_DOC_CFCC
AS
SELECT	'CC' ORIGEN,
	DCC.FECHA_DOCUMENTO,
	DCC.FECHA_PROYECTADA,
	DCC.ASIENTO,
	DCC.CLIENTE PROPIETARIO,
	C.NOMBRE,
	C.CONTRIBUYENTE NIT,
	C.LOCAL,
	C.CATEGORIA_CLIENTE CATEGORIA,
	DCC.DOCUMENTO,
	DCC.TIPO TIPO,
	DCC.SUBTIPO SUBTIPO,
	DCC.APROBADO ESTADO,
	(DCC.SALDO * ISNULL(dcc.PORC_RECUPERACION, 100) / 100) SALDO_MONEDA,
	(DCC.SALDO_LOCAL * ISNULL(dcc.PORC_RECUPERACION, 100) / 100) SALDO_LOCAL,
	(DCC.SALDO_DOLAR * ISNULL(dcc.PORC_RECUPERACION, 100) / 100) SALDO_DOLAR,
	(DCC.MONTO * ISNULL(dcc.PORC_RECUPERACION, 100) / 100) MONTO_MONEDA,
	(DCC.MONTO_LOCAL * ISNULL(dcc.PORC_RECUPERACION, 100) / 100) MONTO_LOCAL,
	(DCC.MONTO_DOLAR * ISNULL(dcc.PORC_RECUPERACION, 100) / 100) MONTO_DOLAR,
	(DCC.SUBTOTAL * ISNULL(dcc.PORC_RECUPERACION, 100) / 100) SUBTOTAL,
	DCC.DESCUENTO,
	DCC.IMPUESTO1,
	DCC.IMPUESTO2,
	DCC.RUBRO1,
	DCC.RUBRO2,
	DCC.MONEDA,
	DCC.TIPO_CAMB_ACT_LOC TIPO_CAMBIO_LOCAL,
	DCC.TIPO_CAMB_ACT_DOL TIPO_CAMBIO_DOLAR,
	C.NoteExistsFlag,
	C.RecordDate,
	C.RowPointer,
	C.CreatedBy,
	C.UpdatedBy,
	C.CreateDate
FROM	$$COMPANIA$$.DOCUMENTOS_CC DCC, $$COMPANIA$$.CLIENTE C
WHERE	DCC.SALDO > 0
AND		DCC.TIPO in ('FAC', 'I/C', 'RED', 'N/D', 'O/D', 'INT', 'L/C', 'B/V', 'RHP')
AND		C.PARTICIPA_FLUJOCAJA = 'S'
AND		C.CLIENTE = DCC.CLIENTE
AND		DCC.FECHA_PROYECTADA IS NOT NULL;





CREATE VIEW $$COMPANIA$$.V_SALDO_DOC_PARC_CFCC
AS
SELECT	'CC' ORIGEN,
	pcc.FECHA_PROYECTADA,
	DCC.ASIENTO,
	DCC.CLIENTE PROPIETARIO,
	C.NOMBRE,
	C.CONTRIBUYENTE NIT,
	C.LOCAL,
	C.CATEGORIA_CLIENTE CATEGORIA,
	DOCUMENTO_ORIGEN DOCUMENTO, 
	DCC.TIPO,
	DCC.SUBTIPO SUBTIPO,
	DCC.APROBADO ESTADO,
	(pcc.SALDO * ISNULL(dcc.PORC_RECUPERACION, 100) / 100) SALDO_MONEDA, 
	(pcc.SALDO_LOCAL * ISNULL(dcc.PORC_RECUPERACION, 100) / 100) SALDO_LOCAL, 
	(pcc.SALDO_DOLAR * ISNULL(dcc.PORC_RECUPERACION, 100) / 100) SALDO_DOLAR, 
	dcc.MONEDA,
	DCC.TIPO_CAMB_ACT_LOC TIPO_CAMBIO_LOCAL,
	DCC.TIPO_CAMB_ACT_DOL TIPO_CAMBIO_DOLAR,
	C.NoteExistsFlag,
	C.RecordDate,
	C.RowPointer,
	C.CreatedBy,
	C.UpdatedBy,
	C.CreateDate
FROM	$$COMPANIA$$.PARCIALIDADES_CC pcc, $$COMPANIA$$.DOCUMENTOS_CC DCC, $$COMPANIA$$.CLIENTE C 
WHERE	pcc.DOCUMENTO_ORIGEN = DCC.DOCUMENTO
AND		pcc.TIPO_DOC_ORIGEN = DCC.tipo
AND		DCC.TIPO in ('FAC', 'I/C', 'RED', 'N/D', 'O/D', 'INT', 'L/C', 'B/V', 'RHP')
AND		pcc.SALDO > 0
AND		C.PARTICIPA_FLUJOCAJA = 'S'
AND		C.CLIENTE = DCC.CLIENTE
AND		PCC.FECHA_PROYECTADA IS NOT NULL;






CREATE VIEW $$COMPANIA$$.V_SALDO_DOC_CFCP
AS
SELECT	'CP' ORIGEN,
	DCP.FECHA_DOCUMENTO,
	DCP.FECHA_PROYECTADA,
	DCP.ASIENTO,
	DCP.PROVEEDOR PROPIETARIO,
	P.NOMBRE,
	P.CONTRIBUYENTE NIT,
	P.LOCAL,
	P.CATEGORIA_PROVEED CATEGORIA,
	DCP.DOCUMENTO,
	DCP.TIPO, 
	dcp.SUBTIPO,
	DCP.APROBADO ESTADO,
	DCP.SALDO SALDO_MONEDA, 
	DCP.SALDO_LOCAL, 
	DCP.SALDO_DOLAR,
	DCP.MONTO MONTO_MONEDA,
	DCP.MONTO_LOCAL,
	DCP.MONTO_DOLAR,
	DCP.SUBTOTAL,
	DCP.DESCUENTO,
	DCP.IMPUESTO1,
	DCP.IMPUESTO2,
	DCP.RUBRO1,
	DCP.RUBRO2,
	DCP.MONEDA, 
	DCP.TIPO_CAMB_ACT_LOC TIPO_CAMBIO_LOCAL,
	DCP.TIPO_CAMB_ACT_DOL TIPO_CAMBIO_DOLAR,
	P.NoteExistsFlag,
	P.RecordDate,
	P.RowPointer,
	P.CreatedBy,
	P.UpdatedBy,
	P.CreateDate
FROM	$$COMPANIA$$.DOCUMENTOS_CP DCP, $$COMPANIA$$.PROVEEDOR P
WHERE	DCP.SALDO > 0
AND		DCP.TIPO in ('FAC', 'L/C', 'N/D', 'O/D', 'INT', 'B/V', 'RHP')
AND		P.PARTICIPA_FLUJOCAJA = 'S'
AND		P.PROVEEDOR = DCP.PROVEEDOR
AND		DCP.FECHA_PROYECTADA IS NOT NULL;






CREATE VIEW $$COMPANIA$$.V_SALDO_DOC_CFCO
AS
select 'CO' ORIGEN,
	OC.FECHA_REQUERIDA FECHA_PROYECTADA, 
	NULL ASIENTO,
	OC.PROVEEDOR PROPIETARIO,
	P.NOMBRE,
	P.CONTRIBUYENTE NIT,
	P.LOCAL,
	P.CATEGORIA_PROVEED CATEGORIA,
	OC.ORDEN_COMPRA DOCUMENTO,
	'O/C' TIPO,
	0 SUBTIPO,
	OC.ESTADO,
	oc.TOTAL_A_COMPRAR SALDO_MONEDA,
	$$COMPANIA$$.GetMontoLocal(OC.MONEDA, oc.TOTAL_A_COMPRAR, OC.FECHA_REQUERIDA) SALDO_LOCAL,
	$$COMPANIA$$.getMontoDolar(OC.MONEDA, oc.TOTAL_A_COMPRAR, OC.FECHA_REQUERIDA) SALDO_DOLAR,
	OC.MONEDA,
	$$COMPANIA$$.GetTipoCambioLocalFecha(oc.FECHA_REQUERIDA) TIPO_CAMBIO_LOCAL,
	$$COMPANIA$$.GetTipoCambioDolarFecha(oc.FECHA_REQUERIDA) TIPO_CAMBIO_DOLAR,
	P.NoteExistsFlag,
	P.RecordDate,
	P.RowPointer,
	P.CreatedBy,
	P.UpdatedBy,
	P.CreateDate
FROM	$$COMPANIA$$.ORDEN_COMPRA OC, $$COMPANIA$$.PROVEEDOR P
WHERE	P.PROVEEDOR = OC.PROVEEDOR
AND		P.PARTICIPA_FLUJOCAJA = 'S'
and		oc.CONFIRMADA = 'S'
AND		ESTADO in ('E','I')
AND		OC.FECHA_REQUERIDA IS NOT NULL;





CREATE VIEW $$COMPANIA$$.V_SALDO_DOC_CFFA
AS
select 'FA' ORIGEN, 
	p.FECHA_PEDIDO FECHA_DOCUMENTO,
	p.FECHA_PROYECTADA,  
	null ASIENTO,
	p.CLIENTE PROPIETARIO,
	C.NOMBRE,
	C.CONTRIBUYENTE NIT,
	C.LOCAL,
	C.CATEGORIA_CLIENTE CATEGORIA,
	p.PEDIDO DOCUMENTO,
	'PED' TIPO,
	0 SUBTIPO,
	P.ESTADO,
	p.TOTAL_MERCADERIA SALDO_MONEDA,
	$$COMPANIA$$.GetMontoLocal($$COMPANIA$$.getmoneda(p.moneda), p.TOTAL_MERCADERIA, p.FECHA_PROYECTADA) SALDO_LOCAL,
	$$COMPANIA$$.getMontoDolar($$COMPANIA$$.getmoneda(p.moneda), p.TOTAL_MERCADERIA, p.FECHA_PROYECTADA) SALDO_DOLAR,
	$$COMPANIA$$.getmoneda(p.moneda) MONEDA,
	$$COMPANIA$$.GetTipoCambioLocalFecha(p.FECHA_PROYECTADA) TIPO_CAMBIO_LOCAL,
	$$COMPANIA$$.GetTipoCambioDolarFecha(p.FECHA_PROYECTADA) TIPO_CAMBIO_DOLAR,
	p.TOTAL_IMPUESTO1 IMPUESTO1,
	p.TOTAL_IMPUESTO2 IMPUESTO2,
	C.NoteExistsFlag,
	C.RecordDate,
	C.RowPointer,
	C.CreatedBy,
	C.UpdatedBy,
	C.CreateDate
from $$COMPANIA$$.PEDIDO p, $$COMPANIA$$.CLIENTE C
WHERE P.CLIENTE = C.CLIENTE
AND		C.PARTICIPA_FLUJOCAJA = 'S'
and		ESTADO IN ('N', 'A', 'B')
AND		P.FECHA_PROYECTADA IS NOT NULL;





CREATE VIEW $$COMPANIA$$.V_CF_ULT_VERSION_FLUJO_CAJA AS
SELECT FC.FLUJO_CAJA, 
	FC.DESCRIPCION, 
	FC.TIPO_PERIODO, 
	FC.FECHA_INICIAL, 
	FC.FECHA_FINAL, 
	VFC.VERSION,
	VFC.ESTADO,	
	FC.NoteExistsFlag,
	FC.RecordDate,
	FC.RowPointer,
	FC.CreatedBy,
	FC.UpdatedBy,
	FC.CreateDate
FROM $$COMPANIA$$.FLUJO_CAJA FC,
	(SELECT ISNULL(MAX(VFC.VERSION),1) VERSION,
		VFC.FLUJO_CAJA,
		VFC.ESTADO
	 FROM $$COMPANIA$$.VERSION_FLUJO_CAJA VFC 
	 WHERE VFC.ESTADO <> 'H' 
	 GROUP BY VFC.FLUJO_CAJA, VFC.ESTADO) VFC
WHERE FC.FLUJO_CAJA = VFC.FLUJO_CAJA;