CREATE FUNCTION $$Compania$$.NUMEROaLETRAS (@Numero NUMERIC(28,8))
RETURNS VARCHAR(4000)
AS
BEGIN
	--SET NOCOUNT ON
	DECLARE @lnEntero INT,
	@lcRetorno VARCHAR(4000),
	@lnTerna INT,
	@lcMiles VARCHAR(512),
	@lcCadena VARCHAR(512),
	@lnUnidades INT,
	@lnDecenas INT,
	@lnCentenas INT,
	@lnFraccion INT
	SELECT @lnEntero = CAST(@Numero AS INT),
	@lnFraccion = (@Numero - @lnEntero) * 100,
	@lcRetorno = '',
	@lnTerna = 1
	WHILE @lnEntero > 0
		BEGIN /* WHILE */
		-- Recorro terna por terna
		SELECT @lcCadena = ''
		SELECT @lnUnidades = @lnEntero % 10
		SELECT @lnEntero = CAST(@lnEntero/10 AS INT)
		SELECT @lnDecenas = @lnEntero % 10
		SELECT @lnEntero = CAST(@lnEntero/10 AS INT)
		SELECT @lnCentenas = @lnEntero % 10
		SELECT @lnEntero = CAST(@lnEntero/10 AS INT)
		-- Analizo las unidades
		SELECT @lcCadena =
		CASE /* UNIDADES */
			WHEN @lnUnidades = 1 AND @lnTerna = 1 THEN 'UNO ' + @lcCadena
			WHEN @lnUnidades = 1 AND @lnTerna <> 1 THEN 'UN ' + @lcCadena
			WHEN @lnUnidades = 2 THEN 'DOS ' + @lcCadena
			WHEN @lnUnidades = 3 THEN 'TRES ' + @lcCadena
			WHEN @lnUnidades = 4 THEN 'CUATRO ' + @lcCadena
			WHEN @lnUnidades = 5 THEN 'CINCO ' + @lcCadena
			WHEN @lnUnidades = 6 THEN 'SEIS ' + @lcCadena
			WHEN @lnUnidades = 7 THEN 'SIETE ' + @lcCadena
			WHEN @lnUnidades = 8 THEN 'OCHO ' + @lcCadena
			WHEN @lnUnidades = 9 THEN 'NUEVE ' + @lcCadena
		ELSE @lcCadena
		END /* UNIDADES */
	-- Analizo las decenas
		SELECT @lcCadena =
		CASE /* DECENAS */
			WHEN @lnDecenas = 1 THEN
				CASE @lnUnidades
					WHEN 0 THEN 'DIEZ '
					WHEN 1 THEN 'ONCE '
					WHEN 2 THEN 'DOCE '
					WHEN 3 THEN 'TRECE '
					WHEN 4 THEN 'CATORCE '
					WHEN 5 THEN 'QUINCE '
				ELSE 'DIECI' + @lcCadena
				END
			WHEN @lnDecenas = 2 AND @lnUnidades = 0 THEN 'VEINTE ' + @lcCadena
			WHEN @lnDecenas = 2 AND @lnUnidades <> 0 THEN 'VEINTI' + @lcCadena
			WHEN @lnDecenas = 3 AND @lnUnidades = 0 THEN 'TREINTA ' + @lcCadena
			WHEN @lnDecenas = 3 AND @lnUnidades <> 0 THEN 'TREINTA Y ' + @lcCadena
			WHEN @lnDecenas = 4 AND @lnUnidades = 0 THEN 'CUARENTA ' + @lcCadena
			WHEN @lnDecenas = 4 AND @lnUnidades <> 0 THEN 'CUARENTA Y ' + @lcCadena
			WHEN @lnDecenas = 5 AND @lnUnidades = 0 THEN 'CINCUENTA ' + @lcCadena
			WHEN @lnDecenas = 5 AND @lnUnidades <> 0 THEN 'CINCUENTA Y ' + @lcCadena
			WHEN @lnDecenas = 6 AND @lnUnidades = 0 THEN 'SESENTA ' + @lcCadena
			WHEN @lnDecenas = 6 AND @lnUnidades <> 0 THEN 'SESENTA Y ' + @lcCadena
			WHEN @lnDecenas = 7 AND @lnUnidades = 0 THEN 'SETENTA ' + @lcCadena
			WHEN @lnDecenas = 7 AND @lnUnidades <> 0 THEN 'SETENTA Y ' + @lcCadena
			WHEN @lnDecenas = 8 AND @lnUnidades = 0 THEN 'OCHENTA ' + @lcCadena
			WHEN @lnDecenas = 8 AND @lnUnidades <> 0 THEN 'OCHENTA Y ' + @lcCadena
			WHEN @lnDecenas = 9 AND @lnUnidades = 0 THEN 'NOVENTA ' + @lcCadena
			WHEN @lnDecenas = 9 AND @lnUnidades <> 0 THEN 'NOVENTA Y ' + @lcCadena
			ELSE @lcCadena
			END /* DECENAS */

	-- Analizo las centenas
		SELECT @lcCadena =
		CASE /* CENTENAS */
			WHEN @lnCentenas = 1 AND @lnUnidades = 0 AND @lnDecenas = 0 THEN 'CIEN ' + @lcCadena
			WHEN @lnCentenas = 1 AND NOT(@lnUnidades = 0 AND @lnDecenas = 0) THEN 'CIENTO ' + @lcCadena
			WHEN @lnCentenas = 2 THEN 'DOSCIENTOS ' + @lcCadena
			WHEN @lnCentenas = 3 THEN 'TRESCIENTOS ' + @lcCadena
			WHEN @lnCentenas = 4 THEN 'CUATROCIENTOS ' + @lcCadena
			WHEN @lnCentenas = 5 THEN 'QUINIENTOS ' + @lcCadena
			WHEN @lnCentenas = 6 THEN 'SEISCIENTOS ' + @lcCadena
			WHEN @lnCentenas = 7 THEN 'SETECIENTOS ' + @lcCadena
			WHEN @lnCentenas = 8 THEN 'OCHOCIENTOS ' + @lcCadena
			WHEN @lnCentenas = 9 THEN 'NOVECIENTOS ' + @lcCadena
		ELSE @lcCadena
		END /* CENTENAS */
	-- Analizo la terna
	SELECT @lcCadena =
		CASE /* TERNA */
			WHEN @lnTerna = 1 THEN @lcCadena
			WHEN @lnTerna = 2 AND (@lnUnidades + @lnDecenas + @lnCentenas <> 0) THEN @lcCadena + ' MIL '
			WHEN @lnTerna = 3 AND (@lnUnidades + @lnDecenas + @lnCentenas <> 0) AND
			@lnUnidades = 1 AND @lnDecenas = 0 AND @lnCentenas = 0 THEN @lcCadena + ' MILLON '
			WHEN @lnTerna = 3 AND (@lnUnidades + @lnDecenas + @lnCentenas <> 0) AND
			NOT (@lnUnidades = 1 AND @lnDecenas = 0 AND @lnCentenas = 0) THEN @lcCadena + ' MILLONES '
			WHEN @lnTerna = 4 AND (@lnUnidades + @lnDecenas + @lnCentenas <> 0) THEN @lcCadena + ' MIL MILLONES '
		ELSE ''
		END /* TERNA */
	-- Armo el retorno terna a terna
	SELECT @lcRetorno = @lcCadena + @lcRetorno
	SELECT @lnTerna = @lnTerna + 1
	END /* WHILE */
	IF @lnTerna = 1
		SELECT @lcRetorno = 'CERO'
	SELECT @lcRetorno = RTRIM(@lcRetorno) + ' CON ' + LTRIM(STR(@lnFraccion,2)) + '/100'
RETURN (@lcRetorno)
END;

create trigger $$COMPANIA$$.tD_CLIENTE on $$COMPANIA$$.CLIENTE for DELETE as
/* ERwin Builtin Tue Mar 21 11:09:46 2000 */
/* DELETE trigger on CLIENTE */
begin
  declare  @errno   int,
           @errmsg  VARCHAR(255)
           
    /* Tabla:CLIENTE */
    /* ERwin Builtin Tue Mar 21 11:09:46 2000 */
    /* CLIENTE CLIENTECLICORPASOC CLIENTE ON PARENT DELETE CASCADE */
    delete CLIENTE
      from $$COMPANIA$$.CLIENTE,deleted
      where
        /*  %JoinFKPK(CLIENTE,deleted," = "," and") */
        $$COMPANIA$$.CLIENTE.CLI_CORPORAC_ASOC = deleted.CLIENTE

    /* ERwin Builtin Tue Mar 21 11:09:46 2000 */
    return
error:
    raiserror (@errno, @errmsg, 0)
    rollback transaction
end;



CREATE  FUNCTION $$COMPANIA$$.CantidadPorDespacharArticulo ( 
	@Calcular		AS VARCHAR(1),
	@TipoDeFecha		AS VARCHAR(1),
	@FechaReconstuye	AS DATETIME,
	@HorasAUtilizar		AS VARCHAR(1),
	@FechaActual		AS DATETIME,
	@CodigoArticulo		AS VARCHAR(20),
	@CodigoBodega		AS VARCHAR(4)
)
RETURNS DECIMAL(28,8) AS BEGIN
	DECLARE @CantidadPorDespachar	DECIMAL(28,8)

	IF (ISNULL(@CodigoArticulo,'ND') = 'ND' OR ISNULL(@CodigoBodega,'ND') = 'ND' OR @Calcular = 'N' ) BEGIN RETURN 0 END

	SET @TipoDeFecha = UPPER( @TipoDeFecha )
	IF ( ISNULL(@TipoDeFecha,'') <> 'D' ) BEGIN SET @TipoDeFecha = 'A' END

	IF (@FechaReconstuye IS NULL) BEGIN SET @FechaReconstuye = @FechaActual END

	SET @HorasAUtilizar = UPPER( @HorasAUtilizar )
	IF ( @HorasAUtilizar = 'F') BEGIN SET @FechaReconstuye = CAST(SUBSTRING(CAST(@FechaReconstuye AS CHAR),1,11) + ' 23:59:59.998' AS DATETIME) END
	IF ( @HorasAUtilizar = 'I') BEGIN SET @FechaReconstuye = CAST(SUBSTRING(CAST(@FechaReconstuye AS CHAR),1,11) + ' 00:00:00.000' AS DATETIME) END

	IF ( @TipoDeFecha = 'D' ) BEGIN
		SELECT	@CantidadPorDespachar = SUM (
			CASE POR_DESPACHAR_BODEGA.tipo_documento 
			WHEN 'F' THEN POR_DESPACHAR_BODEGA.cantidad
			WHEN 'D' THEN -POR_DESPACHAR_BODEGA.cantidad 
			WHEN 'E' THEN -POR_DESPACHAR_BODEGA.cantidad 
			END )
		FROM (
			SELECT	SUM ( cantidad ) cantidad, 
				'F' tipo_documento
			FROM	$$COMPANIA$$.factura fac (NOLOCK),
				$$COMPANIA$$.factura_linea fln (NOLOCK)
			WHERE	fac.usa_despachos = 'S' 
				AND fac.tipo_documento IN ( 'F','B' )
				AND fac.factura = fln.factura
				AND fac.tipo_documento = fln.tipo_documento 
				AND fln.articulo = @CodigoArticulo
				AND fln.bodega = @CodigoBodega
				AND fac.fecha <= @FechaReconstuye
				AND ( fac.anulada = 'N' OR ( fac.anulada = 'S' AND fac.fecha_hora_anula > @FechaReconstuye ) ) 
			UNION
			SELECT	SUM ( dpd.cantidad ), 
				'E' tipo_documento
			FROM	$$COMPANIA$$.despacho dsp (NOLOCK), 
				$$COMPANIA$$.despacho_detalle dpd (NOLOCK)
				, $$COMPANIA$$.FACTURA_LINEA fl (NOLOCK)
			WHERE	dsp.despacho = dpd.despacho 
				AND fl.FACTURA = dpd.DOCUM_ORIG
				AND fl.TIPO_DOCUMENTO = dpd.TIPO_DOCUM_ORIG
				AND fl.LINEA = dpd.LINEA_DOCUM_ORIG
				AND fl.BODEGA = @CodigoBodega
				AND dpd.articulo = @CodigoArticulo
				AND dsp.estado = 'D' 
				AND dsp.fecha <= @FechaReconstuye
			UNION
			SELECT	SUM ( cantidad ), 
				'D' tipo_documento
			FROM	$$COMPANIA$$.factura fac (NOLOCK),
				$$COMPANIA$$.factura_linea fln (NOLOCK)
			WHERE	fac.usa_despachos = 'S' 
				AND fac.tipo_documento = 'D'
				AND fac.factura = fln.factura
				AND fac.tipo_documento = fln.tipo_documento 
				AND fln.articulo = @CodigoArticulo
				AND fln.bodega = @CodigoBodega
				AND fac.fecha <= @FechaReconstuye
			UNION
			SELECT	SUM ( dpd.cantidad ), 
				'E' tipo_documento
			FROM	$$COMPANIA$$.despacho dsp (NOLOCK), 
				$$COMPANIA$$.despacho_detalle dpd (NOLOCK)
				, $$COMPANIA$$.FACTURA_LINEA fl (NOLOCK)
			WHERE	dsp.despacho = dpd.despacho 
				AND fl.FACTURA = dpd.DOCUM_ORIG
				AND fl.TIPO_DOCUMENTO = dpd.TIPO_DOCUM_ORIG
				AND fl.LINEA = dpd.LINEA_DOCUM_ORIG
				AND fl.BODEGA = @CodigoBodega
				AND dpd.articulo = @CodigoArticulo
				AND dsp.estado = 'A' 
				AND dsp.fecha <= @FechaReconstuye
				AND dsp.fch_hora_anulacion > @FechaReconstuye
			) POR_DESPACHAR_BODEGA
	END

	IF ( @TipoDeFecha = 'A' ) BEGIN
		SELECT	@CantidadPorDespachar = SUM (
			CASE POR_DESPACHAR_BODEGA.tipo_documento 
			WHEN 'F' THEN POR_DESPACHAR_BODEGA.cantidad
			WHEN 'D' THEN -POR_DESPACHAR_BODEGA.cantidad 
			WHEN 'E' THEN -POR_DESPACHAR_BODEGA.cantidad 
			END )
		FROM (
			SELECT	SUM ( cantidad ) cantidad, 
				'F' tipo_documento
			FROM	$$COMPANIA$$.factura fac (NOLOCK),
				$$COMPANIA$$.factura_linea fln (NOLOCK)
			WHERE	fac.usa_despachos = 'S' 
				AND fac.tipo_documento IN ( 'F','B' )
				AND fac.factura = fln.factura
				AND fac.tipo_documento = fln.tipo_documento 
				AND fln.articulo = @CodigoArticulo
				AND fln.bodega = @CodigoBodega
				AND fac.fecha_hora <= @FechaReconstuye
				AND ( fac.anulada = 'N' OR ( fac.anulada = 'S' AND fac.fecha_hora_anula > @FechaReconstuye ) ) 
			UNION
			SELECT	SUM ( dpd.cantidad ), 
				'E' tipo_documento
			FROM	$$COMPANIA$$.despacho dsp (NOLOCK), 
				$$COMPANIA$$.despacho_detalle dpd (NOLOCK)
				, $$COMPANIA$$.FACTURA_LINEA fl (NOLOCK)
			WHERE	dsp.despacho = dpd.despacho 
				AND fl.FACTURA = dpd.DOCUM_ORIG
				AND fl.TIPO_DOCUMENTO = dpd.TIPO_DOCUM_ORIG
				AND fl.LINEA = dpd.LINEA_DOCUM_ORIG
				AND fl.BODEGA = @CodigoBodega
				AND dpd.articulo = @CodigoArticulo
				AND dsp.estado = 'D' 
				AND dsp.fch_hora_aplicacion <= @FechaReconstuye
			UNION
			SELECT	SUM ( cantidad ), 
				'D' tipo_documento
			FROM	$$COMPANIA$$.factura fac (NOLOCK),
				$$COMPANIA$$.factura_linea fln (NOLOCK)
			WHERE	fac.usa_despachos = 'S' 
				AND fac.tipo_documento = 'D'
				AND fac.factura = fln.factura
				AND fac.tipo_documento = fln.tipo_documento 
				AND fln.articulo = @CodigoArticulo
				AND fln.bodega = @CodigoBodega
				AND fac.fecha_hora <= @FechaReconstuye
			UNION
			SELECT	SUM ( dpd.cantidad ), 
				'E' tipo_documento
			FROM	$$COMPANIA$$.despacho dsp (NOLOCK), 
				$$COMPANIA$$.despacho_detalle dpd (NOLOCK)
				, $$COMPANIA$$.FACTURA_LINEA fl (NOLOCK)
			WHERE	dsp.despacho = dpd.despacho 
				AND fl.FACTURA = dpd.DOCUM_ORIG
				AND fl.TIPO_DOCUMENTO = dpd.TIPO_DOCUM_ORIG
				AND fl.LINEA = dpd.LINEA_DOCUM_ORIG
				AND fl.BODEGA = @CodigoBodega
				AND dpd.articulo = @CodigoArticulo
				AND dsp.estado = 'A' 
				AND dsp.fch_hora_aplicacion <= @FechaReconstuye
				AND dsp.fch_hora_anulacion > @FechaReconstuye
			) POR_DESPACHAR_BODEGA
	END
	RETURN ISNULL( @CantidadPorDespachar, 0 )
END;




CREATE FUNCTION $$COMPANIA$$.FA_COSTO_ARTICULO
(
      @ARTICULO VARCHAR(20),
	  @MONEDA VARCHAR(1)
)
RETURNS DECIMAL(28,8)
AS
BEGIN
      DECLARE @COSTO DECIMAL(28,8)
	  
	  IF @MONEDA = 'L'
	  BEGIN
		  DECLARE COSTO_CURSOR CURSOR FOR 
				SELECT 
				CASE ART.COSTO_FISCAL 
				WHEN 'P' THEN ART.COSTO_PROM_LOC 
				WHEN 'L' THEN ART.COSTO_ULT_LOC 
				WHEN 'S' THEN ART.COSTO_STD_LOC 
				WHEN 'U' THEN ( SELECT UP.COSTO_LOCAL FROM $$COMPANIA$$.COSTO_UEPS_PEPS UP
				WHERE UP.ARTICULO = ART.ARTICULO AND UP.SECUENCIA = (SELECT MAX(UP1.SECUENCIA) FROM $$COMPANIA$$.COSTO_UEPS_PEPS UP1 WHERE UP1.ARTICULO = ART.ARTICULO AND UP1.CANTIDAD_RESTANTE != 0)) 
				WHEN 'E' THEN ( SELECT UP.COSTO_LOCAL FROM $$COMPANIA$$.COSTO_UEPS_PEPS UP 
				WHERE UP.ARTICULO = ART.ARTICULO AND UP.SECUENCIA = (SELECT MIN(UP1.SECUENCIA) FROM $$COMPANIA$$.COSTO_UEPS_PEPS UP1 WHERE UP1.ARTICULO = ART.ARTICULO AND UP1.CANTIDAD_RESTANTE != 0)) 
				ELSE 0 END AS CostoLocal
				FROM
				$$COMPANIA$$.ARTICULO ART 
				WHERE ART.ARTICULO = @ARTICULO
	   END
	   
	   IF @MONEDA = 'D'
	   BEGIN
		   DECLARE COSTO_CURSOR CURSOR FOR 
            SELECT 
			CASE ART.COSTO_FISCAL 
			WHEN 'P' THEN ART.COSTO_PROM_DOL 
			WHEN 'L' THEN ART.COSTO_ULT_DOL 
			WHEN 'S' THEN ART.COSTO_STD_LOC 
			WHEN 'U' THEN ( SELECT UP.COSTO_DOLAR FROM $$COMPANIA$$.COSTO_UEPS_PEPS UP
			WHERE UP.ARTICULO = ART.ARTICULO AND UP.SECUENCIA = (SELECT MAX(UP1.SECUENCIA) FROM $$COMPANIA$$.COSTO_UEPS_PEPS UP1 WHERE UP1.ARTICULO = ART.ARTICULO AND UP1.CANTIDAD_RESTANTE != 0)) 
			WHEN 'E' THEN ( SELECT UP.COSTO_DOLAR FROM $$COMPANIA$$.COSTO_UEPS_PEPS UP 
			WHERE UP.ARTICULO = ART.ARTICULO AND UP.SECUENCIA = (SELECT MIN(UP1.SECUENCIA) FROM $$COMPANIA$$.COSTO_UEPS_PEPS UP1 WHERE UP1.ARTICULO = ART.ARTICULO AND UP1.CANTIDAD_RESTANTE != 0)) 
			ELSE 0  END AS CostoDolar
			FROM
			$$COMPANIA$$.ARTICULO ART 
			WHERE ART.ARTICULO = @ARTICULO	
	   END

      OPEN COSTO_CURSOR
      FETCH NEXT FROM COSTO_CURSOR INTO @COSTO

	  CLOSE COSTO_CURSOR
      DEALLOCATE COSTO_CURSOR
 
      RETURN @COSTO
END;


CREATE TRIGGER $$Compania$$.TID_FACTURA
   ON  $$Compania$$.FACTURA
   FOR INSERT
AS 
BEGIN
      DECLARE @NOMB_CLIENTE VARCHAR(80)
      DECLARE @FACTURA_ACT VARCHAR(20)
      DECLARE @TIPO_DOC_ACT VARCHAR(1)

      DECLARE C_INSERTED CURSOR LOCAL FOR
            SELECT FACTURA, TIPO_DOCUMENTO, NOMBRE_CLIENTE
            FROM INSERTED
      
      OPEN C_INSERTED
      FETCH NEXT FROM C_INSERTED INTO 
            @FACTURA_ACT, @TIPO_DOC_ACT, @NOMB_CLIENTE
            
      WHILE @@FETCH_STATUS = 0
      BEGIN

            IF @NOMB_CLIENTE IS NULL
            BEGIN
                  UPDATE $$Compania$$.FACTURA
                  SET NOMBRE_CLIENTE = CLI.NOMBRE
                  FROM $$Compania$$.FACTURA FAC, $$Compania$$.CLIENTE CLI
                  WHERE FAC.CLIENTE = CLI.CLIENTE
                  AND FACTURA = @FACTURA_ACT
                  AND TIPO_DOCUMENTO = @TIPO_DOC_ACT
            END

            FETCH NEXT FROM C_INSERTED INTO 
            @FACTURA_ACT, @TIPO_DOC_ACT, @NOMB_CLIENTE
      END
      CLOSE C_INSERTED
      DEALLOCATE C_INSERTED
END;




CREATE TRIGGER $$Compania$$.TID_PEDIDO
   ON  $$Compania$$.PEDIDO
   FOR INSERT
AS 
BEGIN
      DECLARE @NOMB_CLIENTE VARCHAR(80)
      DECLARE @PEDIDO_ACT VARCHAR(20)
      DECLARE C_INSERTED CURSOR LOCAL FOR
            SELECT PEDIDO, NOMBRE_CLIENTE
            FROM INSERTED
      
      OPEN C_INSERTED
      FETCH NEXT FROM C_INSERTED INTO 
            @PEDIDO_ACT, @NOMB_CLIENTE
            
      WHILE @@FETCH_STATUS = 0
      BEGIN
            IF @NOMB_CLIENTE IS NULL
            BEGIN
                  UPDATE $$Compania$$.PEDIDO
                  SET NOMBRE_CLIENTE = CLI.NOMBRE
                  FROM $$Compania$$.PEDIDO PED, $$Compania$$.CLIENTE CLI
                  WHERE PED.CLIENTE = CLI.CLIENTE
                  AND PEDIDO = @PEDIDO_ACT
            END
            FETCH NEXT FROM C_INSERTED INTO 
            @PEDIDO_ACT, @NOMB_CLIENTE
      END
      CLOSE C_INSERTED
      DEALLOCATE C_INSERTED
END;


CREATE VIEW $$COMPANIA$$.SoftlandBI_FA_FacturaLinea
AS
	SELECT	ARTICULO.articulo AS ArticuloCodigo
		, ARTICULO.descripcion AS ArticuloDescripcion
		, ARTICULO.clasificacion_1 AS ArticuloClasificacion1
		, ARTICULO.clasificacion_2 AS ArticuloClasificacion2
		, ARTICULO.clasificacion_3 AS ArticuloClasificacion3
		, ARTICULO.clasificacion_4 AS ArticuloClasificacion4
		, ARTICULO.clasificacion_5 AS ArticuloClasificacion5
		, ARTICULO.clasificacion_6 AS ArticuloClasificacion6
		, ARTICULO.clase_abc AS ArticuloClaseABC
		, PAIS.nombre AS Pais
		, ZONA.nombre AS Zona
		, RUTA.descripcion AS Ruta
		, BODEGA.nombre AS Bodega
		, CATEGORIA.descripcion AS CategoriaCliente
		, CLIENTE.nombre AS Cliente
		, CASE WHEN CLIENTE.rubro1_cli IS NULL THEN 'No Definido' ELSE CLIENTE.rubro1_cli END AS ClienteRubro1
		, CASE WHEN CLIENTE.rubro2_cli IS NULL THEN 'No Definido' ELSE CLIENTE.rubro2_cli END AS ClienteRubro2
		, CASE WHEN CLIENTE.rubro3_cli IS NULL THEN 'No Definido' ELSE CLIENTE.rubro3_cli END AS ClienteRubro3
		, CASE WHEN CLIENTE.rubro4_cli IS NULL THEN 'No Definido' ELSE CLIENTE.rubro4_cli END AS ClienteRubro4
		, CASE WHEN CLIENTE.rubro5_cli IS NULL THEN 'No Definido' ELSE CLIENTE.rubro5_cli END AS ClienteRubro5
		, VENDEDOR.nombre AS Vendedor
		, COBRADOR.nombre AS Cobrador
		, (CASE FACTURA.moneda WHEN 'L' THEN 'Local' WHEN 'D' THEN 'Dólar' END) AS MonedaFactura
		, LINEA.tipo_documento AS TipoFactura
		, LINEA.factura AS Factura
		, LINEA.pedido AS Pedido
		, LINEA.anulada AS Anulada
		, LINEA.fecha_factura AS FechaFactura
		, DATEPART(WEEK, LINEA.fecha_factura) AS SemanaFactura
		, DATEPART(MONTH, LINEA.fecha_factura) AS MesFactura
		, DATEPART(QUARTER, LINEA.fecha_factura) AS TrimestreFactura
		, DATEPART(YEAR, LINEA.fecha_factura) AS AnoFactura
		, (LINEA.cantidad * LINEA.multiplicador_ev) AS Cantidad
		, (LINEA.total_impuesto1 * (CASE FACTURA.moneda_factura WHEN 'D' THEN FACTURA.tipo_cambio ELSE 1 END)) * LINEA.multiplicador_ev AS Impuesto1Local
		, (LINEA.total_impuesto1 / (CASE FACTURA.moneda_factura WHEN 'L' THEN FACTURA.tipo_cambio ELSE 1 END)) * LINEA.multiplicador_ev AS Impuesto1Dolar
		, (LINEA.total_impuesto2 * (CASE FACTURA.moneda_factura WHEN 'D' THEN FACTURA.tipo_cambio ELSE 1 END)) * LINEA.multiplicador_ev AS Impuesto2Local
		, (LINEA.total_impuesto2 / (CASE FACTURA.moneda_factura WHEN 'L' THEN FACTURA.tipo_cambio ELSE 1 END)) * LINEA.multiplicador_ev AS Impuesto2Dolar
		, ((LINEA.total_impuesto1 + LINEA.total_impuesto2) * (CASE FACTURA.moneda_factura WHEN 'D' THEN FACTURA.tipo_cambio ELSE 1 END)) * LINEA.multiplicador_ev AS TotalImpuestoLocal
		, ((LINEA.total_impuesto1 + LINEA.total_impuesto2) / (CASE FACTURA.moneda_factura WHEN 'L' THEN FACTURA.tipo_cambio ELSE 1 END)) * LINEA.multiplicador_ev AS TotalImpuestoDolar
		, (LINEA.desc_tot_linea * (CASE FACTURA.moneda_factura WHEN 'D' THEN FACTURA.tipo_cambio ELSE 1 END)) * LINEA.multiplicador_ev AS DescuentoLineaLocal
		, (LINEA.desc_tot_linea / (CASE FACTURA.moneda_factura WHEN 'L' THEN FACTURA.tipo_cambio ELSE 1 END)) * LINEA.multiplicador_ev AS DescuentoLineaDolar
		, (LINEA.desc_tot_general * (CASE FACTURA.moneda_factura WHEN 'D' THEN FACTURA.tipo_cambio ELSE 1 END)) * LINEA.multiplicador_ev AS DescuentoGeneralLocal
		, (LINEA.desc_tot_general / (CASE FACTURA.moneda_factura WHEN 'L' THEN FACTURA.tipo_cambio ELSE 1 END)) * LINEA.multiplicador_ev AS DescuentoGeneralDolar
		, ((LINEA.desc_tot_linea + LINEA.desc_tot_general) * (CASE FACTURA.moneda_factura WHEN 'D' THEN FACTURA.tipo_cambio ELSE 1 END)) * LINEA.multiplicador_ev AS DescuentoTotalLocal
		, ((LINEA.desc_tot_linea + LINEA.desc_tot_general) / (CASE FACTURA.moneda_factura WHEN 'L' THEN FACTURA.tipo_cambio ELSE 1 END)) * LINEA.multiplicador_ev AS DescuentoTotalDolar
		, (LINEA.descuento_volumen * (CASE FACTURA.moneda_factura WHEN 'D' THEN FACTURA.tipo_cambio ELSE 1 END)) * LINEA.multiplicador_ev AS DescuentoVolumenLocal
		, (LINEA.descuento_volumen / (CASE FACTURA.moneda_factura WHEN 'L' THEN FACTURA.tipo_cambio ELSE 1 END)) * LINEA.multiplicador_ev AS DescuentoVolumenDolar
		, (LINEA.precio_total * (CASE FACTURA.moneda_factura WHEN 'D' THEN FACTURA.tipo_cambio ELSE 1 END)) * LINEA.multiplicador_ev AS PrecioTotalLocal
		, (LINEA.precio_total / (CASE FACTURA.moneda_factura WHEN 'L' THEN FACTURA.tipo_cambio ELSE 1 END)) * LINEA.multiplicador_ev AS PrecioTotalDolar
		, ((LINEA.precio_total - LINEA.desc_tot_general) * (CASE FACTURA.moneda_factura WHEN 'D' THEN FACTURA.tipo_cambio ELSE 1 END)) * LINEA.multiplicador_ev AS VentaNetaLocal
		, ((LINEA.precio_total - LINEA.desc_tot_general)/ (CASE FACTURA.moneda_factura WHEN 'L' THEN FACTURA.tipo_cambio ELSE 1 END)) * LINEA.multiplicador_ev AS VentaNetaDolar
		, (ISNULL(LINEA.costo_total_local,0)) * LINEA.multiplicador_ev AS CostoTotalLocal
		, (ISNULL(LINEA.costo_total_dolar,0)) * LINEA.multiplicador_ev AS CostoTotalDolar
		, ((LINEA.precio_total - LINEA.costo_total) * (CASE FACTURA.moneda_factura WHEN 'D' THEN FACTURA.tipo_cambio ELSE 1 END)) * LINEA.multiplicador_ev AS UtilidadLocal
		, ((LINEA.precio_total - costo_total) / (CASE FACTURA.moneda_factura WHEN 'L' THEN FACTURA.tipo_cambio ELSE 1 END)) * LINEA.multiplicador_ev AS UtilidadDolar
		, CASE LINEA.tipo_documento WHEN 'D' THEN LINEA.cantidad ELSE 0 END AS CantidadDevuelta
		, CASE LINEA.tipo_documento WHEN 'D' THEN (LINEA.precio_total * (CASE FACTURA.moneda_factura WHEN 'D' THEN FACTURA.tipo_cambio ELSE 1 END)) ELSE 0 END AS PrecioTotalLocalDevuelto
		, CASE LINEA.tipo_documento WHEN 'D' THEN (LINEA.precio_total / (CASE FACTURA.moneda_factura WHEN 'L' THEN FACTURA.tipo_cambio ELSE 1 END)) ELSE 0 END AS PrecioTotalDolarDevuelto
		, CASE LINEA.tipo_documento WHEN 'F' THEN LINEA.cantidad ELSE 0 END AS CantidadBruta
		, CASE LINEA.tipo_documento WHEN 'F' THEN (LINEA.precio_total * (CASE FACTURA.moneda_factura WHEN 'D' THEN FACTURA.tipo_cambio ELSE 1 END)) ELSE 0 END AS PrecioTotalLocalBruto
		, CASE LINEA.tipo_documento WHEN 'F' THEN (LINEA.precio_total / (CASE FACTURA.moneda_factura WHEN 'L' THEN FACTURA.tipo_cambio ELSE 1 END)) ELSE 0 END AS PrecioTotalDolarBruto
		, factura.TIPO_CAMBIO
	FROM	$$COMPANIA$$.factura_linea LINEA (NOLOCK)
		INNER JOIN $$COMPANIA$$.factura FACTURA (NOLOCK)
			ON LINEA.factura = FACTURA.factura
			   AND LINEA.tipo_documento = FACTURA.tipo_documento
		INNER JOIN $$COMPANIA$$.articulo ARTICULO (NOLOCK)
			ON LINEA.articulo = ARTICULO.articulo
		INNER JOIN $$COMPANIA$$.bodega BODEGA (NOLOCK)
			ON LINEA.bodega = BODEGA.bodega
		INNER JOIN $$COMPANIA$$.pais PAIS (NOLOCK)
			ON FACTURA.pais = PAIS.pais
		INNER JOIN $$COMPANIA$$.zona ZONA (NOLOCK)
			ON FACTURA.zona = ZONA.zona
		INNER JOIN $$COMPANIA$$.ruta RUTA (NOLOCK)
			ON FACTURA.ruta = RUTA.ruta
		INNER JOIN $$COMPANIA$$.cliente CLIENTE (NOLOCK)
			ON FACTURA.cliente = CLIENTE.cliente
		INNER JOIN $$COMPANIA$$.categoria_cliente CATEGORIA (NOLOCK)
			ON CLIENTE.categoria_cliente = CATEGORIA.categoria_cliente
		INNER JOIN $$COMPANIA$$.vendedor VENDEDOR (NOLOCK)
			ON FACTURA.vendedor = VENDEDOR.vendedor
		INNER JOIN $$COMPANIA$$.cobrador COBRADOR (NOLOCK)
			ON FACTURA.cobrador = COBRADOR.cobrador
	WHERE	LINEA.anulada = 'N'
;



CREATE VIEW $$COMPANIA$$.SoftlandBI_FA_FacturaCliente
AS
	SELECT	FACTURA.factura AS Factura
		, FACTURA.cliente AS Cliente
		, CLIENTE.contribuyente AS Contribuyente
		, CLIENTE.nombre AS NombreCliente
		, CATEGORIA.descripcion AS CategoriaCliente
		, FACTURA.tipo_documento AS TipoDocumento
		, CASE WHEN FACTURA.pedido IS NULL THEN 'No Definido' ELSE FACTURA.pedido END AS Pedido
		, (CASE WHEN FACTURA.tipo_documento = 'D' THEN -1 ELSE 1 END) * FACTURA.total_factura * (CASE FACTURA.moneda_factura WHEN 'D' THEN FACTURA.tipo_cambio ELSE 1 END) AS TotalFacturaLocal
		, (CASE WHEN FACTURA.tipo_documento = 'D' THEN -1 ELSE 1 END) * FACTURA.total_factura / (CASE FACTURA.moneda_factura WHEN 'D' THEN 1 ELSE FACTURA.tipo_cambio END) AS TotalFacturaDolar
		, (CASE WHEN FACTURA.tipo_documento = 'D' THEN -1 ELSE 1 END) * FACTURA.descuento_volumen * (CASE FACTURA.moneda_factura WHEN 'D' THEN FACTURA.tipo_cambio ELSE 1 END) AS DescuentoVolumenLocal
		, (CASE WHEN FACTURA.tipo_documento = 'D' THEN -1 ELSE 1 END) * FACTURA.descuento_volumen / (CASE FACTURA.moneda_factura WHEN 'D' THEN 1 ELSE FACTURA.tipo_cambio END) AS DescuentoVolumenDolar
		, (CASE WHEN FACTURA.tipo_documento = 'D' THEN -1 ELSE 1 END) * FACTURA.total_mercaderia * (CASE FACTURA.moneda_factura WHEN 'D' THEN FACTURA.tipo_cambio ELSE 1 END) AS TotalMercaderiaLocal
		, (CASE WHEN FACTURA.tipo_documento = 'D' THEN -1 ELSE 1 END) * FACTURA.total_mercaderia / (CASE FACTURA.moneda_factura WHEN 'D' THEN 1 ELSE FACTURA.tipo_cambio END) AS TotalMercaderiaDolar
		, (CASE WHEN FACTURA.tipo_documento = 'D' THEN -1 ELSE 1 END) * FACTURA.total_impuesto1 * (CASE FACTURA.moneda_factura WHEN 'D' THEN FACTURA.tipo_cambio ELSE 1 END) AS TotalImpuesto1Local
		, (CASE WHEN FACTURA.tipo_documento = 'D' THEN -1 ELSE 1 END) * FACTURA.total_impuesto1 / (CASE FACTURA.moneda_factura WHEN 'D' THEN 1 ELSE FACTURA.tipo_cambio END) AS TotalImpuesto1Dolar
		, (CASE WHEN FACTURA.tipo_documento = 'D' THEN -1 ELSE 1 END) * FACTURA.total_impuesto2 * (CASE FACTURA.moneda_factura WHEN 'D' THEN FACTURA.tipo_cambio ELSE 1 END) AS TotalImpuesto2Local
		, (CASE WHEN FACTURA.tipo_documento = 'D' THEN -1 ELSE 1 END) * FACTURA.total_impuesto2 / (CASE FACTURA.moneda_factura WHEN 'D' THEN 1 ELSE FACTURA.tipo_cambio END) AS TotalImpuesto2Dolar
		, DATEPART(YEAR, FACTURA.fecha) AS AnoFecha
		, DATEPART(QUARTER, FACTURA.fecha) AS TrimestreFecha
		, DATEPART(MONTH, FACTURA.fecha) AS MesFecha
		, CAST(FACTURA.fecha AS SMALLDATETIME) AS Fecha
		, FACTURA.doc_credito_cxc AS DocumentoCXC
		, FACTURA.tipo_doc_cxc AS TipoDocumentoCC
		, FACTURA.condicion_pago AS CondicionPago 
		, CASE WHEN FACTURA.asiento_documento IS NULL THEN 'No Definido' ELSE FACTURA.asiento_documento END AS Asiento
		, FACTURA.audit_trans_inv AS Transaccion
		, FACTURA.vendedor AS Vendedor
		, CLIENTE.clase_abc AS ClaseABC
		, VENDEDOR.NOMBRE AS NombreVendedor
		, CASE WHEN CLIENTE.rubro1_cli IS NULL THEN 'No Definido' ELSE CLIENTE.rubro1_cli END AS ClienteRubro1
		, CASE WHEN CLIENTE.rubro2_cli IS NULL THEN 'No Definido' ELSE CLIENTE.rubro2_cli END AS ClienteRubro2
		, CASE WHEN CLIENTE.rubro3_cli IS NULL THEN 'No Definido' ELSE CLIENTE.rubro3_cli END AS ClienteRubro3
		, CASE WHEN CLIENTE.rubro4_cli IS NULL THEN 'No Definido' ELSE CLIENTE.rubro4_cli END AS ClienteRubro4
		, CASE WHEN CLIENTE.rubro5_cli IS NULL THEN 'No Definido' ELSE CLIENTE.rubro5_cli END AS ClienteRubro5
	FROM	$$COMPANIA$$.factura FACTURA (NOLOCK)
		INNER JOIN $$COMPANIA$$.cliente CLIENTE (NOLOCK)
			ON FACTURA.cliente = CLIENTE.cliente
		INNER JOIN $$COMPANIA$$.categoria_cliente CATEGORIA (NOLOCK)
			ON CLIENTE.categoria_cliente = CATEGORIA.categoria_cliente
		INNER JOIN $$COMPANIA$$.vendedor VENDEDOR (NOLOCK)
			ON FACTURA.vendedor = VENDEDOR.vendedor
	WHERE	FACTURA.anulada = 'N';





/* Pertenece FE */

CREATE FUNCTION $$COMPANIA$$.INFO_CLIENTE_XML (@FACTURA VARCHAR(50), @TIPO VARCHAR(2))
   RETURNS TABLE
   AS
   RETURN (
    SELECT
   C.CLIENTE,
   C.NOMBRE,
   C.DETALLE_DIRECCION,
   C.ALIAS,
   C.CONTACTO,
   C.CARGO,
   C.DIRECCION,
   C.DIR_EMB_DEFAULT,
   C.TELEFONO1,
   C.TELEFONO2,
   C.FAX,
   C.CONTRIBUYENTE,
   C.FECHA_INGRESO,
   C.MULTIMONEDA,
   C.MONEDA,
   C.SALDO,
   C.SALDO_LOCAL,
   C.SALDO_DOLAR,
   C.SALDO_CREDITO,
   C.SALDO_NOCARGOS,
   C.LIMITE_CREDITO,
   C.EXCEDER_LIMITE,
   C.TASA_INTERES,
   C.TASA_INTERES_MORA,
   C.FECHA_ULT_MORA,
   C.FECHA_ULT_MOV,
   C.CONDICION_PAGO,
   C.NIVEL_PRECIO,
   C.DESCUENTO,
   C.MONEDA_NIVEL,
   C.ACEPTA_BACKORDER,
   C.PAIS,
   C.ZONA,
   C.RUTA,
   C.VENDEDOR,
   C.COBRADOR,
   C.ACEPTA_FRACCIONES,
   C.ACTIVO,
   C.EXENTO_IMPUESTOS,
   C.EXENCION_IMP1,
   C.EXENCION_IMP2,
   C.COBRO_JUDICIAL,
   C.CATEGORIA_CLIENTE,
   C.CLASE_ABC,
   C.DIAS_ABASTECIMIEN,
   C.USA_TARJETA,
   C.TARJETA_CREDITO,
   C.TIPO_TARJETA,
   C.FECHA_VENCE_TARJ,
   C.E_MAIL,
   C.REQUIERE_OC,
   C.ES_CORPORACION,
   C.CLI_CORPORAC_ASOC,
   C.REGISTRARDOCSACORP,
   C.USAR_DIREMB_CORP,
   C.APLICAC_ABIERTAS,
   C.VERIF_LIMCRED_CORP,
   C.USAR_DESC_CORP,
   C.DOC_A_GENERAR,
   C.TIENE_CONVENIO,
   C.NOTAS,
   C.DIAS_PROMED_ATRASO,
   C.ASOCOBLIGCONTFACT,
   C.USAR_PRECIOS_CORP,
   C.USAR_EXENCIMP_CORP,
   C.DIAS_DE_COBRO,
   C.AJUSTE_FECHA_COBRO,
   C.GLN,
   C.UBICACION,
   C.CLASE_DOCUMENTO,
   C.LOCAL,
   C.TIPO_CONTRIBUYENTE,
   C.MODELO_RETENCION,
   C.ACEPTA_DOC_ELECTRONICO,
   C.CONFIRMA_DOC_ELECTRONICO,
   C.EMAIL_DOC_ELECTRONICO,
   C.EMAIL_PED_EDI,
   C.ACEPTA_DOC_EDI,
   C.NOTIFICAR_ERROR_EDI,
   C.EMAIL_ERROR_PED_EDI,
   C.CODIGO_IMPUESTO,
   C.DIVISION_GEOGRAFICA1,
   C.DIVISION_GEOGRAFICA2,
   C.REGIMEN_TRIB,
   C.MOROSO,
   C.MODIF_NOMB_EN_FAC,
   C.SALDO_TRANS_LOCAL,
   C.SALDO_TRANS_DOLAR,
   C.PERMITE_DOC_GP,
   C.PARTICIPA_FLUJOCAJA,
   C.CURP,
   I.IMPUESTO1,
   I.IMPUESTO2,
   C.DETALLAR_KITS,
   C.RUBRO1_CLI,
   C.RUBRO2_CLI,
   C.RUBRO3_CLI,
   C.RUBRO4_CLI,
   C.RUBRO5_CLI,
   C.RUBRO1_CLIENTE,
   C.RUBRO2_CLIENTE,
   C.RUBRO3_CLIENTE,
   C.RUBRO4_CLIENTE,
   C.RUBRO5_CLIENTE,
   C.RUBRO6_CLIENTE,
   C.RUBRO7_CLIENTE,
   C.RUBRO8_CLIENTE,
   C.RUBRO9_CLIENTE,
   C.RUBRO10_CLIENTE,
   C.RUBRO11_CLIENTE,
   C.RUBRO12_CLIENTE,
   C.RUBRO13_CLIENTE,
   C.RUBRO14_CLIENTE,
   C.RUBRO15_CLIENTE,
   C.RUBRO16_CLIENTE,
   C.RUBRO17_CLIENTE,
   C.RUBRO18_CLIENTE,
   C.RUBRO19_CLIENTE,
   C.RUBRO20_CLIENTE
   FROM $$COMPANIA$$.FACTURA F
   INNER JOIN $$COMPANIA$$.CLIENTE C ON F.CLIENTE = C.CLIENTE
   LEFT JOIN $$COMPANIA$$.IMPUESTO I ON C.CODIGO_IMPUESTO = I.IMPUESTO 
   WHERE F.FACTURA = @FACTURA
   AND F.TIPO_DOCUMENTO = @TIPO
   UNION ALL
   SELECT
   DCC.CLIENTE,
   C.NOMBRE,
   C.DETALLE_DIRECCION,
   C.ALIAS,
   C.CONTACTO,
   C.CARGO,
   C.DIRECCION,
   C.DIR_EMB_DEFAULT,
   C.TELEFONO1,
   C.TELEFONO2,
   C.FAX,
   C.CONTRIBUYENTE,
   C.FECHA_INGRESO,
   C.MULTIMONEDA,
   C.MONEDA,
   C.SALDO,
   C.SALDO_LOCAL,
   C.SALDO_DOLAR,
   C.SALDO_CREDITO,
   C.SALDO_NOCARGOS,
   C.LIMITE_CREDITO,
   C.EXCEDER_LIMITE,
   C.TASA_INTERES,
   C.TASA_INTERES_MORA,
   C.FECHA_ULT_MORA,
   C.FECHA_ULT_MOV,
   C.CONDICION_PAGO,
   C.NIVEL_PRECIO,
   C.DESCUENTO,
   C.MONEDA_NIVEL,
   C.ACEPTA_BACKORDER,
   C.PAIS,
   C.ZONA,
   C.RUTA,
   C.VENDEDOR,
   C.COBRADOR,
   C.ACEPTA_FRACCIONES,
   C.ACTIVO,
   C.EXENTO_IMPUESTOS,
   C.EXENCION_IMP1,
   C.EXENCION_IMP2,
   C.COBRO_JUDICIAL,
   C.CATEGORIA_CLIENTE,
   C.CLASE_ABC,
   C.DIAS_ABASTECIMIEN,
   C.USA_TARJETA,
   C.TARJETA_CREDITO,
   C.TIPO_TARJETA,
   C.FECHA_VENCE_TARJ,
   C.E_MAIL,
   C.REQUIERE_OC,
   C.ES_CORPORACION,
   C.CLI_CORPORAC_ASOC,
   C.REGISTRARDOCSACORP,
   C.USAR_DIREMB_CORP,
   C.APLICAC_ABIERTAS,
   C.VERIF_LIMCRED_CORP,
   C.USAR_DESC_CORP,
   C.DOC_A_GENERAR,
   C.TIENE_CONVENIO,
   C.NOTAS,
   C.DIAS_PROMED_ATRASO,
   C.ASOCOBLIGCONTFACT,
   C.USAR_PRECIOS_CORP,
   C.USAR_EXENCIMP_CORP,
   C.DIAS_DE_COBRO,
   C.AJUSTE_FECHA_COBRO,
   C.GLN,
   C.UBICACION,
   C.CLASE_DOCUMENTO,
   C.LOCAL,
   C.TIPO_CONTRIBUYENTE,
   C.MODELO_RETENCION,
   C.ACEPTA_DOC_ELECTRONICO,
   C.CONFIRMA_DOC_ELECTRONICO,
   C.EMAIL_DOC_ELECTRONICO,
   C.EMAIL_PED_EDI,
   C.ACEPTA_DOC_EDI,
   C.NOTIFICAR_ERROR_EDI,
   C.EMAIL_ERROR_PED_EDI,
   C.CODIGO_IMPUESTO,
   C.DIVISION_GEOGRAFICA1,
   C.DIVISION_GEOGRAFICA2,
   C.REGIMEN_TRIB,
   C.MOROSO,
   C.MODIF_NOMB_EN_FAC,
   C.SALDO_TRANS_LOCAL,
   C.SALDO_TRANS_DOLAR,
   C.PERMITE_DOC_GP,
   C.PARTICIPA_FLUJOCAJA,
   C.CURP,
   I.IMPUESTO1,
   I.IMPUESTO2,
   C.DETALLAR_KITS,
   C.RUBRO1_CLI,
   C.RUBRO2_CLI,
   C.RUBRO3_CLI,
   C.RUBRO4_CLI,
   C.RUBRO5_CLI,
   C.RUBRO1_CLIENTE,
   C.RUBRO2_CLIENTE,
   C.RUBRO3_CLIENTE,
   C.RUBRO4_CLIENTE,
   C.RUBRO5_CLIENTE,
   C.RUBRO6_CLIENTE,
   C.RUBRO7_CLIENTE,
   C.RUBRO8_CLIENTE,
   C.RUBRO9_CLIENTE,
   C.RUBRO10_CLIENTE,
   C.RUBRO11_CLIENTE,
   C.RUBRO12_CLIENTE,
   C.RUBRO13_CLIENTE,
   C.RUBRO14_CLIENTE,
   C.RUBRO15_CLIENTE,
   C.RUBRO16_CLIENTE,
   C.RUBRO17_CLIENTE,
   C.RUBRO18_CLIENTE,
   C.RUBRO19_CLIENTE,
   C.RUBRO20_CLIENTE
   FROM $$COMPANIA$$.DOCUMENTOS_CC DCC
   INNER JOIN $$COMPANIA$$.CLIENTE C ON DCC.CLIENTE = C.CLIENTE 
   LEFT JOIN $$COMPANIA$$.IMPUESTO I ON C.CODIGO_IMPUESTO = I.IMPUESTO 
   WHERE 0 = ( SELECT COUNT(*) FROM $$COMPANIA$$.FACTURA FAC
   WHERE FAC.FACTURA = @FACTURA
   AND FAC.TIPO_DOCUMENTO = @TIPO)
   AND DCC.DOCUMENTO = @FACTURA AND @TIPO = (CASE DCC.TIPO WHEN 'FAC' THEN 'F' WHEN 'N/C' THEN 'D' WHEN 'N/D' THEN 'ND' END));
  
  
  
/* Pertenece FE */
  
  CREATE FUNCTION $$COMPANIA$$.INFO_DIRECCION_CLIENTE_XML (@FACTURA VARCHAR(50), @TIPO VARCHAR(2))
	 RETURNS TABLE
	 AS
	 RETURN (
	  SELECT
  ISNULL(DD.CAMPO_1, 'CAMPO EN BLANCO') AS DIREC_CAMPO_1,
  ISNULL(DD.CAMPO_2, 'CAMPO EN BLANCO') AS DIREC_CAMPO_2,
  ISNULL(DD.CAMPO_3, 'CAMPO EN BLANCO') AS DIREC_CAMPO_3,
  ISNULL(DD.CAMPO_4, 'CAMPO EN BLANCO') AS DIREC_CAMPO_4,
  ISNULL(DD.CAMPO_5, 'CAMPO EN BLANCO') AS DIREC_CAMPO_5,
  ISNULL(DD.CAMPO_6, 'CAMPO EN BLANCO') AS DIREC_CAMPO_6,
  ISNULL(DD.CAMPO_7, 'CAMPO EN BLANCO') AS DIREC_CAMPO_7,
  ISNULL(DD.CAMPO_8, 'CAMPO EN BLANCO') AS DIREC_CAMPO_8,
  ISNULL(DD.CAMPO_9, 'CAMPO EN BLANCO') AS DIREC_CAMPO_9,
  ISNULL(DD.CAMPO_10, 'CAMPO EN BLANCO') AS DIREC_CAMPO_10,
  ISNULL(DE.FAX, 'CAMPO EN BLANCO') AS DD_FAX,
  ISNULL(DE.DIRECCION, 'CAMPO EN BLANCO') AS DD_DIRECCION
  FROM $$COMPANIA$$.FACTURA F
  INNER JOIN $$COMPANIA$$.CLIENTE C ON F.CLIENTE = C.CLIENTE
  INNER JOIN $$COMPANIA$$.DETALLE_DIRECCION DD ON C.DETALLE_DIRECCION = DD.DETALLE_DIRECCION
  LEFT JOIN $$COMPANIA$$.DIRECC_EMBARQUE DE ON DD.DETALLE_DIRECCION = DE.DETALLE_DIRECCION
  WHERE F.FACTURA = @FACTURA
  AND F.TIPO_DOCUMENTO = @TIPO
  UNION ALL
  SELECT
  ISNULL(DD.CAMPO_1, 'CAMPO EN BLANCO') AS DIREC_CAMPO_1,
  ISNULL(DD.CAMPO_2, 'CAMPO EN BLANCO') AS DIREC_CAMPO_2,
  ISNULL(DD.CAMPO_3, 'CAMPO EN BLANCO') AS DIREC_CAMPO_3,
  ISNULL(DD.CAMPO_4, 'CAMPO EN BLANCO') AS DIREC_CAMPO_4,
  ISNULL(DD.CAMPO_5, 'CAMPO EN BLANCO') AS DIREC_CAMPO_5,
  ISNULL(DD.CAMPO_6, 'CAMPO EN BLANCO') AS DIREC_CAMPO_6,
  ISNULL(DD.CAMPO_7, 'CAMPO EN BLANCO') AS DIREC_CAMPO_7,
  ISNULL(DD.CAMPO_8, 'CAMPO EN BLANCO') AS DIREC_CAMPO_8,
  ISNULL(DD.CAMPO_9, 'CAMPO EN BLANCO') AS DIREC_CAMPO_9,
  ISNULL(DD.CAMPO_10, 'CAMPO EN BLANCO') AS DIREC_CAMPO_10,
  ISNULL(DE.FAX, 'CAMPO EN BLANCO') AS DD_FAX,
  ISNULL(DE.DIRECCION, 'CAMPO EN BLANCO') AS DD_DIRECCION
  FROM $$COMPANIA$$.DOCUMENTOS_CC DCC
  INNER JOIN $$COMPANIA$$.CLIENTE C ON DCC.CLIENTE = C.CLIENTE
  INNER JOIN $$COMPANIA$$.DETALLE_DIRECCION DD ON C.DETALLE_DIRECCION = DD.DETALLE_DIRECCION
  LEFT JOIN $$COMPANIA$$.DIRECC_EMBARQUE DE ON DD.DETALLE_DIRECCION = DE.DETALLE_DIRECCION
  WHERE 0 = ( SELECT COUNT(*) FROM $$COMPANIA$$.FACTURA   FAC
  WHERE FAC.FACTURA = @FACTURA
  AND FAC.TIPO_DOCUMENTO = @TIPO)
  AND DCC.DOCUMENTO = @FACTURA AND @TIPO =(CASE DCC.TIPO WHEN 'FAC' THEN 'F' WHEN 'N/C' THEN 'D' WHEN 'N/D' THEN 'ND' END));
    
    
  
REMARK 
\
 ------------------------------------------------------------------
 MODIFICAMOS LA FUNCION INFO_DIRECCION_EMBARQUE_XML. /* Pertenece FE */
 ------------------------------------------------------------------
/

CREATE FUNCTION $$COMPANIA$$.INFO_DIRECCION_EMBARQUE_XML (@FACTURA VARCHAR(50), @TIPO VARCHAR(2))
  RETURNS TABLE
  AS
  RETURN (
    SELECT
ISNULL(DE.DIRECCION, 'CAMPO EN BLANCO') AS DIRECCION,
ISNULL(DE.CONTACTO, 'CAMPO EN BLANCO') AS CONTACTO,
ISNULL(DE.CARGO, 'CAMPO EN BLANCO') AS CARGO,
ISNULL(DE.TELEFONO1, 'CAMPO EN BLANCO') AS TELEFONO1,
ISNULL(DE.TELEFONO2, 'CAMPO EN BLANCO') AS TELEFONO2,
ISNULL(DE.FAX, 'CAMPO EN BLANCO') AS FAX,
ISNULL(DE.EMAIL, 'CAMPO EN BLANCO') AS EMAIL,
ISNULL(DD.CAMPO_1, 'CAMPO EN BLANCO') AS DIREC_CAMPO_1,
ISNULL(DD.CAMPO_2, 'CAMPO EN BLANCO') AS DIREC_CAMPO_2,
ISNULL(DD.CAMPO_3, 'CAMPO EN BLANCO') AS DIREC_CAMPO_3,
ISNULL(DD.CAMPO_4, 'CAMPO EN BLANCO') AS DIREC_CAMPO_4,
ISNULL(DD.CAMPO_5, 'CAMPO EN BLANCO') AS DIREC_CAMPO_5,
ISNULL(DD.CAMPO_6, 'CAMPO EN BLANCO') AS DIREC_CAMPO_6,
ISNULL(DD.CAMPO_7, 'CAMPO EN BLANCO') AS DIREC_CAMPO_7,
ISNULL(DD.CAMPO_8, 'CAMPO EN BLANCO') AS DIREC_CAMPO_8,
ISNULL(DD.CAMPO_9, 'CAMPO EN BLANCO') AS DIREC_CAMPO_9,
ISNULL(DD.CAMPO_10, 'CAMPO EN BLANCO') AS DIREC_CAMPO_10
FROM $$COMPANIA$$.FACTURA F
INNER JOIN $$COMPANIA$$.CLIENTE C ON F.CLIENTE = C.CLIENTE
LEFT JOIN $$COMPANIA$$.DIRECC_EMBARQUE DE ON C.CLIENTE = DE.CLIENTE AND F.DIREC_EMBARQUE = DE.DIRECCION
LEFT JOIN $$COMPANIA$$.DETALLE_DIRECCION DD ON DE.DETALLE_DIRECCION = DD.DETALLE_DIRECCION
WHERE F.FACTURA = @FACTURA
AND F.TIPO_DOCUMENTO = @TIPO
UNION ALL
SELECT
ISNULL(DE.DIRECCION, 'CAMPO EN BLANCO') AS DIRECCION,
ISNULL(DE.CONTACTO, 'CAMPO EN BLANCO') AS CONTACTO,
ISNULL(DE.CARGO, 'CAMPO EN BLANCO') AS CARGO,
ISNULL(DE.TELEFONO1, 'CAMPO EN BLANCO') AS TELEFONO1,
ISNULL(DE.TELEFONO2, 'CAMPO EN BLANCO') AS TELEFONO2,
ISNULL(DE.FAX, 'CAMPO EN BLANCO') AS FAX,
ISNULL(DE.EMAIL, 'CAMPO EN BLANCO') AS EMAIL,
ISNULL(DD.CAMPO_1, 'CAMPO EN BLANCO') AS DIREC_CAMPO_1,
ISNULL(DD.CAMPO_2, 'CAMPO EN BLANCO') AS DIREC_CAMPO_2,
ISNULL(DD.CAMPO_3, 'CAMPO EN BLANCO') AS DIREC_CAMPO_3,
ISNULL(DD.CAMPO_4, 'CAMPO EN BLANCO') AS DIREC_CAMPO_4,
ISNULL(DD.CAMPO_5, 'CAMPO EN BLANCO') AS DIREC_CAMPO_5,
ISNULL(DD.CAMPO_6, 'CAMPO EN BLANCO') AS DIREC_CAMPO_6,
ISNULL(DD.CAMPO_7, 'CAMPO EN BLANCO') AS DIREC_CAMPO_7,
ISNULL(DD.CAMPO_8, 'CAMPO EN BLANCO') AS DIREC_CAMPO_8,
ISNULL(DD.CAMPO_9, 'CAMPO EN BLANCO') AS DIREC_CAMPO_9,
ISNULL(DD.CAMPO_10, 'CAMPO EN BLANCO') AS DIREC_CAMPO_10
FROM $$COMPANIA$$.DOCUMENTOS_CC DCC
INNER JOIN $$COMPANIA$$.CLIENTE C ON DCC.CLIENTE = C.CLIENTE
LEFT JOIN $$COMPANIA$$.DIRECC_EMBARQUE DE ON C.CLIENTE = DE.CLIENTE AND C.DIR_EMB_DEFAULT = DE.DIRECCION
LEFT JOIN $$COMPANIA$$.DETALLE_DIRECCION DD ON DE.DETALLE_DIRECCION = DD.DETALLE_DIRECCION
WHERE 0 = ( SELECT COUNT(*) FROM $$COMPANIA$$.FACTURA   FAC
WHERE FAC.FACTURA = @FACTURA
AND FAC.TIPO_DOCUMENTO = @TIPO)
AND DCC.DOCUMENTO = @FACTURA AND @TIPO =(CASE DCC.TIPO WHEN 'FAC' THEN 'F' WHEN 'N/C' THEN 'D' WHEN 'N/D' THEN 'ND' END));
  
  
  
  
REMARK 
\
------------------------------------------------------------------
MODIFICAMOS LA FUNCION INFO_FACTURA_XML. /* Pertenece FE */
------------------------------------------------------------------
/

CREATE FUNCTION $$COMPANIA$$.INFO_FACTURA_XML (@FACTURA VARCHAR(50), @TIPO VARCHAR(2))
RETURNS TABLE
AS
RETURN (
   SELECT
   F.FACTURA DOCUMENTO,
   ISNULL(F.DOC_FISCAL, 'CAMPO EN BLANCO') AS DOC_FISCAL,
   F.CONDICION_PAGO,
   CP.U_METODO_PAGO U_METODO_PAGO,
   ISNULL(F.FORMA_PAGO, CP.U_FORMA_PAGO) U_FORMA_PAGO,
   F.DIREC_EMBARQUE,
   F.CONSECUTIVO,
   DE.CONTACTO,
   DE.CARGO,
   DE.TELEFONO1,
   DE.TELEFONO2,
   DE.FAX,
   DE.EMAIL,
   'FA' MODULO,
   DD.CAMPO_1 DIREC_CAMPO_1,
   DD.CAMPO_2 DIREC_CAMPO_2,
   DD.CAMPO_3 DIREC_CAMPO_3,
   DD.CAMPO_4 DIREC_CAMPO_4,
   DD.CAMPO_5 DIREC_CAMPO_5,
   DD.CAMPO_6 DIREC_CAMPO_6,
   DD.CAMPO_7 DIREC_CAMPO_7,
   DD.CAMPO_8 DIREC_CAMPO_8,
   DD.CAMPO_9 DIREC_CAMPO_9,
   DD.CAMPO_10 DIREC_CAMPO_10,
   F.FECHA,
   F.FECHA AS FECHA_HORA, 
   F.FECHA_ORDEN,
   F.MONEDA_FACTURA,
   CAST (F.MONTO_ANTICIPO AS DECIMAL(28,6)) AS MONTO_ANTICIPO,
   CAST (F.MONTO_COBRADO AS DECIMAL(28,6)) AS MONTO_COBRADO,
   CAST (F.MONTO_DESCUENTO1 AS DECIMAL(28,6)) AS MONTO_DESCUENTO1,
   CAST (F.MONTO_DESCUENTO2 AS DECIMAL(28,6)) AS MONTO_DESCUENTO2,
   CAST (F.MONTO_DOCUMENTACIO AS DECIMAL(28,6)) AS MONTO_DOCUMENTACIO,
   CAST (F.MONTO_FLETE AS DECIMAL(28,6)) AS MONTO_FLETE,
   CAST (F.MONTO_SEGURO AS DECIMAL(28,6)) AS MONTO_SEGURO,
   F.ORDEN_COMPRA,
   CAST (F.PORC_DESCUENTO1 AS DECIMAL(28,6)) AS PORC_DESCUENTO1,
   CAST (F.PORC_DESCUENTO2 AS DECIMAL(28,6)) AS PORC_DESCUENTO2,
   F.RUBRO1,
   F.RUBRO2,
   F.RUBRO3,
   F.RUBRO4,
   F.RUBRO5,
   F.COMENTARIO_CXC,
   (CASE F.MONEDA_FACTURA WHEN 'L' THEN '1' WHEN 'D' THEN F.TIPO_CAMBIO END) AS TIPO_CAMBIO,
   F.TIPO_DOCUMENTO,
   CAST (F.TOTAL_FACTURA AS DECIMAL(28,6)) AS TOTAL_FACTURA,
   $$COMPANIA$$.NUMEROALETRAS(F.TOTAL_FACTURA) AS TOTAL_FACTURA_LETRAS,
   CAST (F.TOTAL_FACTURA - ISNULL(FR.MONTO,0) AS DECIMAL(28,6)) AS TOTAL_FACTURA_SIN_RETENCION,
   $$COMPANIA$$.NUMEROALETRAS(F.TOTAL_FACTURA - ISNULL(FR.MONTO,0)) AS TOT_FAC_SIN_RETENCION_LETRAS,
   CAST (F.TOTAL_MERCADERIA AS DECIMAL(28,6)) AS SUBTOTAL_FACTURA,
   $$COMPANIA$$.NUMEROALETRAS(F.TOTAL_MERCADERIA) AS SUBTOTAL_FACTURA_LETRAS,
   CAST (F.TOTAL_UNIDADES AS DECIMAL(28,6)) AS TOTAL_UNIDADES,
   CAST (F.TOTAL_IMPUESTO1 AS DECIMAL(28,6)) AS TOTAL_IMPUESTO1,
     CAST (F.TOTAL_IMPUESTO2 AS DECIMAL(28,6)) AS TOTAL_IMPUESTO2,
   F.VENDEDOR,
   F.OBSERVACIONES,
   CAST (ISNULL(RT.PORCENTAJE,0) AS DECIMAL(28,6)) AS RETENCION_PORCENTAJE,      
   CAST (ISNULL(FR.MONTO,0) AS DECIMAL(28,6)) AS RETENCION_MONTO,
   F.ANULADA,
   ISNULL(F.PEDIDO, 'CAMPO EN BLANCO') AS PEDIDO,
   ISNULL(F.FACTURA_ORIGINAL, 'CAMPO EN BLANCO') AS FACTURA_ORIGINAL,
   ISNULL(P.BODEGA, 'CAMPO EN BLANCO') AS PEDIDO_BODEGA,
   R.FECHA AS FECHA_ORIGINAL,
   DATEADD(S,DATEPART(S,R.CREATEDATE),DATEADD(MI,DATEPART(MI,R.CREATEDATE),DATEADD(HH,DATEPART(HH,R.CREATEDATE),R.FECHA))) FECHA_HORA_ORIGINAL,
   DC.FECHA_VENCE,
   P.FECHA_PROMETIDA,
   CAST ((F.MONTO_DESCUENTO1 + F.MONTO_DESCUENTO2 + F.DESCUENTO_VOLUMEN) AS DECIMAL(28,6)) AS TOTAL_DESCUENTOS,
   (SELECT CAST(SUM(DESC_TOT_LINEA) AS DECIMAL(28,8)) FROM $$COMPANIA$$.FACTURA_LINEA LINEA WHERE LINEA.FACTURA = @FACTURA AND LINEA.TIPO_DOCUMENTO = @TIPO) AS DESC_TOT_LINEA,
   F.USO_CFDI,
   '03' U_TIPO_RELACION
   FROM $$COMPANIA$$.FACTURA F
   LEFT JOIN $$COMPANIA$$.FACTURA_RETENCION FR 
   ON F.FACTURA =  FR.FACTURA AND F.TIPO_DOCUMENTO = FR.TIPO_DOCUMENTO
   LEFT JOIN $$COMPANIA$$.RETENCIONES RT
   ON FR.CODIGO_RETENCION = RT.CODIGO_RETENCION
   LEFT JOIN $$COMPANIA$$.PEDIDO P
   ON P.PEDIDO = F.PEDIDO
   LEFT JOIN $$COMPANIA$$.FACTURA R
   ON R.FACTURA = F.FACTURA_ORIGINAL AND R.TIPO_DOCUMENTO = F.TIPO_ORIGINAL
   LEFT JOIN $$COMPANIA$$.DOCUMENTOS_CC DC
   ON DC.DOCUMENTO = F.FACTURA AND (CASE DC.TIPO WHEN 'FAC' THEN 'F' WHEN 'N/C' THEN 'D' END) = F.TIPO_DOCUMENTO
   LEFT JOIN $$COMPANIA$$.DIRECC_EMBARQUE DE
   ON F.CLIENTE = DE.CLIENTE AND F.DIREC_EMBARQUE = DE.DIRECCION
   LEFT JOIN $$COMPANIA$$.DETALLE_DIRECCION DD
   ON DE.DETALLE_DIRECCION = DD.DETALLE_DIRECCION
   LEFT JOIN $$COMPANIA$$.CONDICION_PAGO CP
   ON CP.CONDICION_PAGO = F.CONDICION_PAGO
   WHERE F.FACTURA = @FACTURA
   AND F.TIPO_DOCUMENTO = @TIPO)
   
   UNION ALL
   
   SELECT 
   DCC.DOCUMENTO,
   ISNULL(DCC.DOCUMENTO_FISCAL,'CAMPO EN BLANCO') DOCUMENTO_FISCAL,
   DCC.CONDICION_PAGO, 
   CP.U_METODO_PAGO U_METODO_PAGO,
   ISNULL( DCC.FORMA_PAGO, CP.U_FORMA_PAGO ) U_FORMA_PAGO,
   DE.DIRECCION,
   'CONSEC_CC' CONSECUTIVO,
   DE.CONTACTO,
   DE.CARGO,
   DE.TELEFONO1,
   DE.TELEFONO2,
   DE.FAX,
   DE.EMAIL,
   'CC' MODULO,
   DD.CAMPO_1 DIREC_CAMPO_1,
   DD.CAMPO_2 DIREC_CAMPO_2,
   DD.CAMPO_3 DIREC_CAMPO_3,
   DD.CAMPO_4 DIREC_CAMPO_4,
   DD.CAMPO_5 DIREC_CAMPO_5,
   DD.CAMPO_6 DIREC_CAMPO_6,
   DD.CAMPO_7 DIREC_CAMPO_7,
   DD.CAMPO_8 DIREC_CAMPO_8,
   DD.CAMPO_9 DIREC_CAMPO_9,
   DD.CAMPO_10 DIREC_CAMPO_10,
   DCC.FECHA,
   DATEADD(S,DATEPART(S,DCC.CREATEDATE),DATEADD(MI,DATEPART(MI,DCC.CREATEDATE),DATEADD(HH,DATEPART(HH,DCC.CREATEDATE),DCC.FECHA))) FECHA_HORA,
   DCC.FECHA_DOCUMENTO FECHA_ORDEN,
   DCC.MONEDA,
   '0.000000' ANTICIPO,
   '0.000000' COBRADO,
   '0.000000' DESCUENTO1,
   '0.000000' DESCUENTO2,
   '0.000000' DOCUMENTACIO,
   CAST (DCC.RUBRO1 AS DECIMAL(28,6)) AS MONTO_FLETE,
   CAST (DCC.RUBRO2 AS DECIMAL(28,6)) AS SEGURO,
   'N/D' ORDEN_COMPRA,
   '0.000000' PORC_DESCUENTO1,
   '0.000000' PORC_DESCUENTO2,
   NULL RUBRO1,
   NULL RUBRO2,
   NULL RUBRO3,
   NULL RUBRO4,
   NULL RUBRO5,
   NULL COMENTARIO_CXC,
   CAST (DCC.TIPO_CAMBIO_MONEDA AS DECIMAL(28,6)) AS TIPO_CAMBIO,
   (CASE DCC.TIPO WHEN 'FAC' THEN 'F' WHEN 'N/C' THEN 'D' WHEN 'N/D' THEN 'ND' END) AS TIPO_DOCUMENTO,
   CAST (DCC.MONTO AS DECIMAL(28,6)) AS TOTAL_FACTURA,
   $$COMPANIA$$.NUMEROALETRAS(DCC.MONTO) AS TOTAL_FACTURA_LETRAS,
   CAST (DCC.MONTO - ISNULL(DCC.MONTO_RETENCION,0) AS DECIMAL(28,6)) AS TOTAL_FACTURA_SIN_RETENCION,
   $$COMPANIA$$.NUMEROALETRAS(DCC.MONTO - ISNULL(DCC.MONTO_RETENCION,0)) AS TOT_FAC_SIN_RETENCION_LETRAS,
   CAST (DCC.SUBTOTAL AS DECIMAL(28,6)) AS SUBTOTAL_FACTURA,
   $$COMPANIA$$.NUMEROALETRAS(DCC.MONTO) AS SUBTOTAL_FACTURA_LETRAS,
   CAST ('1' AS DECIMAL(28,6)) AS TOTAL_UNIDADES,
   CAST (DCC.IMPUESTO1 AS DECIMAL(28,6)),
     CAST (DCC.IMPUESTO2 AS DECIMAL(28,6)),
   DCC.VENDEDOR,
   'SIN OBSERVACIONES' OBSERVACIONES,
   CAST (ISNULL(RT.PORCENTAJE,0) AS DECIMAL(28,6)) AS RETENCION_PORCENTAJE,      
   CAST (ISNULL(FR.MONTO,0) AS DECIMAL(28,6)) AS RETENCION_MONTO,
   DCC.ANULADO,
   'N/D' PEDIDO,
   ISNULL(DCC.DOCUMENTO, 'CAMPO EN BLANCO') AS FACTURA_ORIGINAL,
   'N/D' BODEGA,
   DCC.FECHA AS FECHA_ORIGINAL,
   DATEADD(S,DATEPART(S,DCC.CREATEDATE),DATEADD(MI,DATEPART(MI,DCC.CREATEDATE),DATEADD(HH,DATEPART(HH,DCC.CREATEDATE),DCC.FECHA))) FECHA_HORA_ORIGINAL,
   DCC.FECHA_VENCE,
   DCC.FECHA FECHA_PROMETIDA,
   CAST (DCC.DESCUENTO AS DECIMAL(28,6)) AS TOTAL_DESCUENTOS,
   '0.000000' AS DESC_TOT_LINEA,
   DCC.USO_CFDI,
   ISNULL( DCC.U_TIPO_RELACION, '01') U_TIPO_RELACION
     FROM $$COMPANIA$$.DOCUMENTOS_CC DCC
   LEFT JOIN $$COMPANIA$$.CONDICION_PAGO CP
   ON CP.CONDICION_PAGO = DCC.CONDICION_PAGO
   LEFT JOIN $$COMPANIA$$.DIRECC_EMBARQUE DE
   ON DCC.CLIENTE = DE.CLIENTE
   LEFT JOIN $$COMPANIA$$.DETALLE_DIRECCION DD
   ON DE.DETALLE_DIRECCION = DD.DETALLE_DIRECCION
   LEFT JOIN $$COMPANIA$$.RETENCIONES_DOC_CC FR 
   ON DCC.DOCUMENTO = FR.DOCUMENTO AND DCC.TIPO = FR.TIPO
   LEFT JOIN $$COMPANIA$$.RETENCIONES RT
   ON FR.CODIGO_RETENCION = RT.CODIGO_RETENCION
   WHERE 0 = ( SELECT COUNT(*) FROM $$COMPANIA$$.FACTURA FAC
   WHERE FAC.FACTURA = @FACTURA
   AND FAC.TIPO_DOCUMENTO = @TIPO)
   AND DCC.DOCUMENTO = @FACTURA AND @TIPO =(CASE DCC.TIPO WHEN 'FAC' THEN 'F' WHEN 'N/C' THEN 'D' WHEN 'N/D' THEN 'ND'

END);
 
/* Pertenece FE */ 
 
 CREATE FUNCTION $$COMPANIA$$.INFO_FACTURA_LINEA_XML (@FACTURA VARCHAR(50), @TIPO VARCHAR(2))
RETURNS TABLE
AS
RETURN (
   SELECT
   ART.ARTICULO,
   FL.LINEA,
   CAST (FL.CANTIDAD AS DECIMAL(28,6)) AS CANTIDAD,
   CAST (FL.PRECIO_UNITARIO AS DECIMAL(28,6)) AS PRECIO_UNITARIO,
   CAST (((FL.PRECIO_UNITARIO * FL.CANTIDAD) - FL.DESC_TOT_LINEA) / FL.CANTIDAD AS DECIMAL(28,6)) AS PRECIO_UNITARIO_DESCONTADO,
   CAST (((FL.PRECIO_UNITARIO * FL.CANTIDAD) - (FL.DESC_TOT_LINEA + FL.DESC_TOT_GENERAL)) / FL.CANTIDAD AS DECIMAL(28,6)) AS PRECIO_UNITARIO_DESC_TOTAL, 
   CAST (CASE 
   WHEN FL.DESCUENTO_VOLUMEN = 0 THEN (FL.DESC_TOT_LINEA / (CASE WHEN(FL.PRECIO_UNITARIO * FL.CANTIDAD)= 0 THEN 1 ELSE FL.PRECIO_UNITARIO END)) * 100  
  ELSE 100 
  END AS DECIMAL(28,6)) AS PORCENTAJE_DESC,
  CAST (CASE 
   WHEN FL.DESCUENTO_VOLUMEN = 0 THEN FL.DESC_TOT_LINEA
  ELSE FL.DESCUENTO_VOLUMEN 
  END AS DECIMAL(28,6)) AS DESC_TOT_LINEA, 
  (FL.DESC_TOT_GENERAL * 100 / (CASE WHEN(FL.PRECIO_TOTAL)= 0 THEN 1 END)) AS PORCENTAJE_DESC_GENERAL_TOTAL, 
   CAST (FL.DESC_TOT_GENERAL AS DECIMAL(28,6)) AS DESC_TOT_GENERAL,
   IMP.U_IMPUESTO1_SAT,
   IMP.U_IMPUESTO2_SAT,
   CASE WHEN C.EXENCION_IMP1 > 0 THEN 'Exento' 
		ELSE 'Tasa'
		END TASACUOTA1,
   CASE WHEN C.EXENCION_IMP2 > 0 THEN 'Exento' 
		WHEN FL.TOTAL_IMPUESTO2  > 0 AND IMP.USA_IMPUESTO2_CANTIDAD = 'S' THEN 'Cuota' 
		ELSE 'Tasa'
		END TASACUOTA2,
   ART.IMPUESTO,
   CAST (IMP.IMPUESTO1 AS DECIMAL(28,6)) AS IMPUESTO1,     
   CAST (FL.TOTAL_IMPUESTO1 AS DECIMAL(28,6)) AS TOTAL_IMPUESTO1,
   CAST (IMP.IMPUESTO2 AS DECIMAL(28,6)) AS IMPUESTO2,
   CAST (FL.TOTAL_IMPUESTO2 AS DECIMAL(28,6)) AS TOTAL_IMPUESTO2,
   FL.PRECIO_UNITARIO * FL.CANTIDAD AS PRECIO_TOTAL_BRUTO,
   CAST (FL.PRECIO_TOTAL AS DECIMAL(28,6)) AS PRECIO_TOTAL,
   ((FL.PRECIO_UNITARIO * FL.CANTIDAD) - (FL.DESC_TOT_LINEA + FL.DESC_TOT_GENERAL)) PRECIO_TOTAL_DESCONTADO,
   CASE 
    WHEN FL.DESCUENTO_VOLUMEN = 0 THEN 
    ((FL.PRECIO_UNITARIO * FL.CANTIDAD) - (FL.DESC_TOT_LINEA + FL.DESC_TOT_GENERAL) + (FL.TOTAL_IMPUESTO1 + FL.TOTAL_IMPUESTO2)) 
    ELSE 0 
   END AS PRECIO_TOTAL_NETO,
   CASE 
    WHEN FL.TOTAL_IMPUESTO1 > 0 THEN 
    ((FL.PRECIO_UNITARIO * FL.CANTIDAD) - (FL.DESC_TOT_LINEA + FL.DESC_TOT_GENERAL)) 
    ELSE 0 
   END AS PRECIO_TOTAL_NETO_GRABADO_IMP1,
   CAST (FL.DESCUENTO_VOLUMEN AS DECIMAL(28,6)) AS DESCUENTO_VOLUMEN,
   FL.SERIE_CADENA,
   FL.TIPO_LINEA AS TIPO_LINEA_KIT,
   P.PEDIMENTO,
   P.FECHA PEDIMENTO_FECHA,           
   A.DESCRIPCION ADUANA_DESCRIPCION,     
   FL.COMENTARIO,
   FL.DESCRIPCION AS DESCRIPCION_LINEA,
   FL.BODEGA,
   FL.LOCALIZACION,
   FL.LOTE,
   CAST (FL.BASE_IMPUESTO1 AS DECIMAL(28,6)) AS BASE_IMPUESTO1,
   CAST (FL.BASE_IMPUESTO2 AS DECIMAL(28,6)) AS BASE_IMPUESTO2,  
   CASE 
    WHEN FL.DESCRIPCION IS NULL OR DATALENGTH(FL.DESCRIPCION) = 0 THEN 
     SUBSTRING(ART.DESCRIPCION,0,69) 
    ELSE 
     SUBSTRING(FL.DESCRIPCION,0,69)  
   END AS DESCRIPCION_ARTICULO,    
   ISNULL(ART.CODIGO_BARRAS_INVT, '00000000000000') AS CODIGO_BARRAS_INVT,
   ISNULL(ART.CODIGO_BARRAS_VENT, '00000000000000') AS CODIGO_BARRAS_VENT,
   ART.FACTOR_EMPAQUE,
   ART.UNIDAD_ALMACEN,
   ART.UNIDAD_EMPAQUE,
   ART.UNIDAD_VENTA,
   ART.TIPO, 
   ART.ARTICULO_CUENTA,        
   CASE 
    WHEN (FL.TOTAL_IMPUESTO1 > 0) OR (FL.TOTAL_IMPUESTO2 > 0) THEN 'S'  
    ELSE 'N'
   END AS IMPUESTO_AGRUPABLE,
   CASE 
    WHEN (ART.TIPO = 'V') THEN 'S'  
    ELSE 'N'
   END AS TIPO_SERVICIO,
   'S' AS LINEA_AGRUPABLE ,
   ART.U_CLAVE_PROD_SERV,
   ART.U_CLAVE_UNIDAD
   FROM $$COMPANIA$$.FACTURA_LINEA FL
         LEFT JOIN $$COMPANIA$$.ARTICULO ART ON FL.ARTICULO = ART.ARTICULO
         LEFT JOIN $$COMPANIA$$.IMPUESTO IMP ON IMP.IMPUESTO = ART.IMPUESTO
         LEFT JOIN $$COMPANIA$$.PEDIMENTO_LOTE PL ON FL.LOTE = PL.LOTE AND PL.ARTICULO = ART.ARTICULO
         LEFT JOIN $$COMPANIA$$.PEDIMENTO P ON PL.PEDIMENTO = P.PEDIMENTO 
		 LEFT JOIN $$COMPANIA$$.ADUANA A ON P.ADUANA = A.ADUANA
		 LEFT JOIN $$COMPANIA$$.FACTURA F ON FL.TIPO_DOCUMENTO = F.TIPO_DOCUMENTO AND FL.FACTURA = F.FACTURA 
		 LEFT JOIN $$COMPANIA$$.CLIENTE C ON C.CLIENTE = F.CLIENTE_ORIGEN
   WHERE FL.FACTURA = @FACTURA
   AND FL.TIPO_DOCUMENTO = @TIPO
   UNION ALL
   SELECT
   '00001',
   '1',
   '1',
   DCC.SUBTOTAL,
   DCC.SUBTOTAL AS PRECIO_UNITARIO_DESCONTADO,
   DCC.SUBTOTAL AS PRECIO_UNITARIO_DESC_TOTAL,          
   '0.000000' AS PORCENTAJE_DESC,
   DCC.DESCUENTO AS DESC_TOT_LINEA, 
   '0.000000' AS PORCENTAJE_DESC_GENERAL_TOTAL, 
   DCC.DESCUENTO,
   IMP.U_IMPUESTO1_SAT,
   IMP.U_IMPUESTO2_SAT,
   CASE WHEN C.EXENCION_IMP1 > 0 THEN 'Exento' 
		ELSE 'Tasa'
		END TASACUOTA1,
   CASE WHEN C.EXENCION_IMP2 > 0 THEN 'Exento' 
		WHEN DCC.IMPUESTO2  > 0 AND IMP.USA_IMPUESTO2_CANTIDAD = 'S' THEN 'Cuota' 
		ELSE 'Tasa'
		END TASACUOTA2,
   IMP.IMPUESTO,     
   IMP.IMPUESTO1,
   DCC.IMPUESTO1,
   IMP.IMPUESTO2,
   DCC.IMPUESTO2,
   DCC.SUBTOTAL AS PRECIO_TOTAL_BRUTO,
   DCC.MONTO AS PRECIO_TOTAL,
   DCC.SUBTOTAL AS PRECIO_TOTAL_DESCONTADO,
   DCC.MONTO AS PRECIO_TOTAL_NETO,
   DCC.MONTO AS PRECIO_TOTAL_NETO_GRABADO_IMP1,
   '0.000000',
   '1',
   'N' AS TIPO_LINEA_KIT,
   '1',
   DCC.FECHA,           
   'NO DEFINIDO' ADUANA_DESCRIPCION,     
   'SIN COMENTARIOS',
   DCC.APLICACION AS DESCRIPCION_LINEA,
   'ND',
   'ND',
   'ND',
   DCC.BASE_IMPUESTO1,
   DCC.BASE_IMPUESTO2,
   DCC.APLICACION AS DESCRIPCION_ARTICULO,    
   '00000000000000' AS CODIGO_BARRAS_INVT,
   '00000000000000' AS CODIGO_BARRAS_VENT,
   '1.000000',
   'ND',
   'ND',
   'ND',
   'U', 
   'ND',        
   'S' IMPUESTO_AGRUPABLE,
   'S' AS TIPO_SERVICIO,
   'S' AS LINEA_AGRUPABLE,
   '84111506' ,
   'ACT'
   FROM $$COMPANIA$$.DOCUMENTOS_CC DCC
    LEFT JOIN $$COMPANIA$$.IMPUESTO IMP ON DCC.CODIGO_IMPUESTO = IMP.IMPUESTO
	 LEFT JOIN $$COMPANIA$$.CLIENTE C ON C.CLIENTE = DCC.CLIENTE_ORIGEN
   WHERE 0 = ( SELECT COUNT(*) FROM $$COMPANIA$$.FACTURA   FAC
   WHERE FAC.FACTURA = @FACTURA
   AND FAC.TIPO_DOCUMENTO = @TIPO)
   AND DCC.DOCUMENTO = @FACTURA AND @TIPO =(CASE DCC.TIPO WHEN 'FAC' THEN 'F' WHEN 'N/C' THEN 'D' WHEN 'N/D' THEN 'ND' END)
);


/* Proyecto: Cambio de Direcciones AS - FEMX*/ /* Pertenece FE */
CREATE FUNCTION $$COMPANIA$$.COMPANIA_XML (@compania VARCHAR(10))
RETURNS XML 
AS
BEGIN
 
DECLARE @XMLCOMPANIA XML
SET @XMLCOMPANIA = (
SELECT con.CONJUNTO, con.NIT, con.NOMBRE, con.UBICACION, con.DIREC1, con.DIREC2, con.DIREC3, con.COD_POSTAL, con.TELEFONO, con.EMAIL_DOC_ELECTRONICO, 
    con.PAIS, con.GLN, nit.RAZON_SOCIAL, nit.ALIAS, glo.IMPUESTO1_DESC, glo.IMPUESTO2_DESC, ISNULL(con.DIRECCION_PAG_WEB,'CAMPO EN BLANCO') DIRECCION_PAG_WEB,
    (SELECT ISNULL(SUBSTRING(valor,0,11),'0000-00-00') + 'T00:00:00' FROM $$COMPANIA$$.GLOBALES WHERE MODULO = 'AS' AND nombre = 'EDI_FRESOLUCION') FECHA_RESOLUCION_CR,
    (SELECT valor FROM $$COMPANIA$$.GLOBALES WHERE MODULO = 'AS' AND nombre = 'EDI_NRESOLUCION') NUMERO_RESOLUCION_CR,
    gf.COND_PAGO_CONTAD,
    gf.PRECIOS_DEC,
	con.REGIMEN_FISCAL REGIMEN_FISCAL ,
	glo.MONEDA_LOCAL   
FROM ERPADMIN.CONJUNTO con, $$COMPANIA$$.NIT nit, $$COMPANIA$$.GLOBALES_AS glo, $$COMPANIA$$.GLOBALES_FA gf
WHERE con.CONJUNTO = @compania AND nit.NIT = con.NIT
FOR XML RAW ('COMPANIA'), ELEMENTS)
RETURN @XMLCOMPANIA
END;




/* Pertenece FE */

CREATE FUNCTION $$COMPANIA$$.DIRECCION_CLIENTE_XML (@FACTURA VARCHAR(50), @TIPO VARCHAR(2))
 RETURNS XML
 AS
 BEGIN
 DECLARE @XMLDIRECCIONCLIENTE XML
 
 SET @XMLDIRECCIONCLIENTE = (  SELECT * FROM $$COMPANIA$$.INFO_DIRECCION_CLIENTE_XML(@FACTURA, @TIPO)
	FOR XML RAW ('DIRECCION_CLIENTE'), ELEMENTS)
 RETURN @XMLDIRECCIONCLIENTE
 END;


/* Pertenece FE */

CREATE FUNCTION $$COMPANIA$$.DIRECCION_EMBARQUE_XML (@FACTURA VARCHAR(50), @TIPO VARCHAR(2))
 RETURNS XML
 AS
 BEGIN
 DECLARE @XMLDIRECCIONEMBARQUE XML
 
 SET @XMLDIRECCIONEMBARQUE = (  SELECT * FROM $$COMPANIA$$.INFO_DIRECCION_EMBARQUE_XML(@FACTURA, @TIPO)
	FOR XML RAW ('DIRECCION_EMBARQUE'), ELEMENTS)
 RETURN @XMLDIRECCIONEMBARQUE
 END;


/* Pertenece FE */

CREATE FUNCTION $$COMPANIA$$.CLIENTE_XML (@FACTURA VARCHAR(50), @TIPO VARCHAR(2))
 RETURNS XML
 AS
 BEGIN
 DECLARE @XMLCLIENTE XML
 
 SET @XMLCLIENTE = (  SELECT * FROM $$COMPANIA$$.INFO_CLIENTE_XML(@FACTURA, @TIPO)
	FOR XML RAW ('CLIENTE'), ELEMENTS)
 RETURN @XMLCLIENTE
 END;






/* Pertenece FE */

 CREATE FUNCTION $$COMPANIA$$.RESOLUCION_DATA (@factura varchar(50), @tipo varchar(1))
 RETURNS TABLE
 AS
 RETURN (SELECT 
      ISNULL(RE.RESOLUCION, 'CAMPO EN BLANCO') AS RESOLUCION,
      ISNULL(RE.TIPO_ACTIVO, 'CAMPO EN BLANCO') AS TIPO_ACTIVO,
      ISNULL(RE.FECHA_RESOLUCION, ERPADMIN.SF_GETDATE()) AS FECHA_RESOLUCION,
      ISNULL(RE.NUMERO_AUTORIZACION, 'CAMPO EN BLANCO') AS NUMERO_AUTORIZACION,
      ISNULL(RE.INFORMACION_REGIMEN, 'CAMPO EN BLANCO') AS INFORMACION_REGIMEN,
      ISNULL(F.SERIE_RESOLUCION, 'CAMPO EN BLANCO') AS SERIE,
      ISNULL(RE.FOLIO_INICIAL, 0) AS FOLIO_INICIAL,
      ISNULL(RE.FOLIO_FINAL, 0) AS FOLIO_FINAL,
      ISNULL(F.CONSEC_RESOLUCION, 0) AS ULTIMO_FOLIO,
      ISNULL(RE.ESTADO, 'CAMPO EN BLANCO') AS ESTADO,
      ISNULL(RE.USUARIO_CREACION, 'CAMPO EN BLANCO') AS USUARIO_CREACION,
      ISNULL(RE.SUCURSAL, 'CAMPO EN BLANCO') AS SUCURSAL,
      ISNULL(RE.NOMBRE_SUCURSAL, 'CAMPO EN BLANCO') AS NOMBRE_SUCURSAL,
      ISNULL(RE.DISPOSITIVO_ELECTRONICO, 'CAMPO EN BLANCO') AS DISPOSITIVO_ELECTRONICO,
      ISNULL(RE.DIRECCION1, 'CAMPO EN BLANCO') AS DIRECCION1,
      ISNULL(RE.MUNICIPIO, 'CAMPO EN BLANCO') AS MUNICIPIO,
      ISNULL(RE.DEPARTAMENTO, 'CAMPO EN BLANCO') AS DEPARTAMENTO,
      ISNULL(RE.CODIGO_PAIS, 'CAMPO EN BLANCO') AS CODIGO_PAIS,
      SUBSTRING(ISNULL(RE.TIPO_ACTIVO,'TIPO NO ASIGNADO'),1,1) AS TIPO_CAEC,
      (CASE RE.TIPO_ACTIVO WHEN 'CFACE6' THEN 'S' WHEN 'FACE74' THEN 'S' ELSE 'N' END) AS FACTURA_ESPECIAL
      FROM $$COMPANIA$$.FACTURA F     
      LEFT JOIN $$COMPANIA$$.DOCUMENTOS_CC DC
      ON DC.DOCUMENTO = F.FACTURA AND (CASE DC.TIPO WHEN 'FAC' THEN 'F' WHEN 'N/C' THEN 'D' END) = F.TIPO_DOCUMENTO
      LEFT JOIN $$COMPANIA$$.CONSECUTIVO_FA CF 
      ON F.CONSECUTIVO = CF.CODIGO_CONSECUTIVO
      LEFT JOIN $$COMPANIA$$.RESOLUCION_DOC_ELECTRONICO RE 
      ON CF.RESOLUCION = RE.RESOLUCION
      WHERE F.FACTURA = @factura
      AND F.TIPO_DOCUMENTO = @tipo
      AND RE.RESOLUCION IS NOT NULL
   )
;

		
/* Pertenece FE */
CREATE FUNCTION $$COMPANIA$$.RESOLUCION_XML (@factura varchar(50), @tipo varchar(1))
RETURNS XML
AS
BEGIN
DECLARE @XMLRESOLUCION XML

SET @XMLRESOLUCION = (  SELECT * FROM $$COMPANIA$$.RESOLUCION_DATA(@factura, @tipo)
			FOR XML RAW ('RESOLUCION'), ELEMENTS)
RETURN @XMLRESOLUCION
END;
						
		
/* Pertenece FE */ 	
CREATE FUNCTION $$COMPANIA$$.FACTURA_XML (@FACTURA VARCHAR(50), @TIPO VARCHAR(2))
 RETURNS XML
 AS
 BEGIN
 DECLARE @XMLFACTURA XML
 
 SET @XMLFACTURA = (  SELECT * FROM $$COMPANIA$$.INFO_FACTURA_XML(@FACTURA, @TIPO)
	FOR XML RAW ('ENCABEZADO'), ELEMENTS)
 RETURN @XMLFACTURA
 END;

 
 
/* Pertenece FE */
CREATE FUNCTION $$COMPANIA$$.FACTURA_LINEA_XML (@FACTURA VARCHAR(50), @TIPO VARCHAR(2))
 RETURNS XML
 AS
 BEGIN
 DECLARE @XMLFACTURALINEA XML
 
 SET @XMLFACTURALINEA = (  SELECT * FROM $$COMPANIA$$.INFO_FACTURA_LINEA_XML(@FACTURA, @TIPO)
	FOR XML RAW ('LINEA'), ROOT('FACTURA_LINEA'), ELEMENTS)
 RETURN @XMLFACTURALINEA
 END;


REMARK 
\
 ------------------------------------------------------------------
 MODIFICAMOS LA VISTA PARA OBTENER PENDIENTES DE ENVIO.
 ------------------------------------------------------------------
/


CREATE VIEW $$COMPANIA$$.V_DOCUMENTO_ELECTRONICO
 AS 
 SELECT FAC.TIPO_DOCUMENTO AS TIPODOCUMENTO, 
 FAC.FACTURA AS FACTURA, 
 FAC.ANULADA AS ANULADA, 
 FAC.CLIENTE AS CLIENTE,
 DOCELECTPROC.ESTADO AS ESTADO, 
 FAC.TOTAL_FACTURA AS TOTALFACTURA,
 0 SALDO,
 ( SELECT SUM(MONTO) 
 FROM (
 SELECT TOTAL_FACTURA AS MONTO FROM $$COMPANIA$$.FACTURA WHERE FACTURA=FAC.FACTURA 
 AND TIPO_DOCUMENTO = FAC.TIPO_DOCUMENTO 
 UNION ALL
 SELECT - (MONTO) AS MONTO FROM $$COMPANIA$$.FACTURA_RETENCION WHERE FACTURA=FAC.FACTURA
 AND TIPO_DOCUMENTO = FAC.TIPO_DOCUMENTO
 ) AS T
 ) AS TOTALFACTURARETENCION,
 FAC.FECHA AS FECHA, 
 FAC.MONEDA_FACTURA AS MONEDAFACTURA, 
 CONVERT(CHAR(36),LOWER(FAC.ROWPOINTER)) AS ROWPOINTER,
 'FACTURA' AS TABLA,
 FAC.RECORDDATE,
 FAC.CREATEDBY,
 FAC.UPDATEDBY,
 FAC.CREATEDATE,
 DOCELECTPROC.FOLIO_SAT AS FOLIOSAT,
 ISNULL(DOCELECTPROC.ENVIADO,'N') AS ENVIADO,
 DOCELECTPROC.NIT_EMISOR AS NIT_EMISOR,
 DOCELECTPROC.NIT_RECEPTOR AS NIT_RECEPTOR,
 ISNULL(DOCELECTPROC.ACEPTADO,'N') AS ACEPTADO,
 DOCELECTPROC.ACEPTACION_RECHAZO AS ACEPTACION_RECHAZO,
 DOCELECTPROC.DOCUMENTO_ELECTRONICO AS DOCUMENTO_ELECTRONICO,
 DOCELECTPROC.NOMBRE_PDF AS NOMBRE_PDF,
 DOCELECTPROC.NOMBRE_XML AS NOMBRE_XML,
 DOCELECTPROC.ESTADO_CARTA_PORTE AS ESTADO_CARTA_PORTE,
 DOCELECTPROC.GENERA_CARTA_PORTE AS GENERA_CARTA_PORTE,
 DOCELECTPROC.ERROR_WS AS ERROR_WS,
 DOCELECTPROC.ERROR_SOFTLAND AS ERROR_SOFTLAND,
 FAC.DOC_FISCAL AS DOCUMENTO_FISCAL,
 DOCELECTPROC.FIRMA_DOCUMENTO AS FIRMA_GT,
 DOCELECTPROC.GUUID_GT AS GUUID_GT
 FROM $$COMPANIA$$.FACTURA FAC 
 LEFT OUTER JOIN $$COMPANIA$$.DOC_ELECTRONICO_PROCESADO DOCELECTPROC 
 ON DOCELECTPROC.TIPO_DOC = FAC.TIPO_DOCUMENTO
 AND DOCELECTPROC.NUMERO_DOC = FAC.FACTURA 
 WHERE ( FAC.TIPO_DOCUMENTO != 'R' AND FAC.GENERA_DOC_FE = 'S')
 UNION ALL
 SELECT (CASE D.TIPO WHEN 'FAC' THEN 'F' WHEN 'N/C' THEN 'D' WHEN 'N/D' THEN 'ND' END) AS TIPODOCUMENTO, 
 D.DOCUMENTO AS FACTURA, 
 D.ANULADO AS ANULADA,
 D.CLIENTE AS CLIENTE,
 DOCELECTPROC.ESTADO AS ESTADO, 
 D.MONTO AS TOTALFACTURA,
 D.SALDO,
 ( SELECT SUM(MONTO) 
 FROM ( 
 SELECT D.MONTO AS MONTO 
 FROM $$COMPANIA$$.DOCUMENTOS_CC 
 WHERE DOCUMENTO=D.DOCUMENTO 
 AND TIPO = D.TIPO
 UNION ALL
 SELECT - (MONTO) AS MONTO 
 FROM $$COMPANIA$$.RETENCIONES_DOC_CC 
 WHERE DOCUMENTO=D.DOCUMENTO
 AND TIPO = D.TIPO
 ) AS T
 ) AS TOTALFACTURARETENCION,
 D.FECHA AS FECHA, 
 'L' AS MONEDAFACTURA, 
 CONVERT(CHAR(36),LOWER(D.ROWPOINTER)) AS ROWPOINTER,
 'DOCUMENTOS_CC' AS TABLA,
 D.RECORDDATE,
 D.CREATEDBY,
 D.UPDATEDBY,
 D.CREATEDATE,
 DOCELECTPROC.FOLIO_SAT AS FOLIOSAT,
 ISNULL(DOCELECTPROC.ENVIADO,'N') AS ENVIADO,
 DOCELECTPROC.NIT_EMISOR AS NIT_EMISOR,
 DOCELECTPROC.NIT_RECEPTOR AS NIT_RECEPTOR,
 ISNULL(DOCELECTPROC.ACEPTADO,'N') AS ACEPTADO,
 DOCELECTPROC.ACEPTACION_RECHAZO AS ACEPTACION_RECHAZO,
 DOCELECTPROC.DOCUMENTO_ELECTRONICO AS DOCUMENTO_ELECTRONICO,
 DOCELECTPROC.NOMBRE_PDF AS NOMBRE_PDF,
 DOCELECTPROC.NOMBRE_XML AS NOMBRE_XML,
 DOCELECTPROC.ESTADO_CARTA_PORTE AS ESTADO_CARTA_PORTE,
 DOCELECTPROC.GENERA_CARTA_PORTE AS GENERA_CARTA_PORTE,
 DOCELECTPROC.ERROR_WS AS ERROR_WS,
 DOCELECTPROC.ERROR_SOFTLAND AS ERROR_SOFTLAND,
 D.DOCUMENTO_FISCAL AS DOCUMENTO_FISCAL,
 DOCELECTPROC.FIRMA_DOCUMENTO AS FIRMA_GT,
 DOCELECTPROC.GUUID_GT AS GUUID_GT
 FROM $$COMPANIA$$.DOCUMENTOS_CC D
 LEFT OUTER JOIN $$COMPANIA$$.DOC_ELECTRONICO_PROCESADO DOCELECTPROC 
 ON DOCELECTPROC.TIPO_DOC = (CASE D.TIPO WHEN 'FAC' THEN 'F' WHEN 'N/C' THEN 'D' WHEN 'N/D' THEN 'ND' END)
 AND DOCELECTPROC.NUMERO_DOC = D.DOCUMENTO 
 WHERE D.TIPO IN ('FAC','N/C','N/D') 
 AND D.GENERA_DOC_FE = 'S' 
 AND 0 = ( 
 SELECT COUNT(0) FROM 
 $$COMPANIA$$.FACTURA F 
 WHERE D.DOCUMENTO = F.FACTURA 
 AND D.TIPO = ( CASE F.TIPO_DOCUMENTO WHEN 'F' THEN 'FAC' WHEN 'D' THEN 'N/C' END));
 
 REMARK 
\
 ------------------------------------------------------------------
 MODIFICAMOS LA VISTA PARA OBTENER PENDIENTES DE ENVIO.
 ------------------------------------------------------------------
/


ALTER VIEW $$COMPANIA$$.V_DOCUMENTO_ELECTRONICO
 AS 
 SELECT FAC.TIPO_DOCUMENTO AS TIPODOCUMENTO, 
 FAC.FACTURA AS FACTURA, 
 FAC.ANULADA AS ANULADA, 
 FAC.CLIENTE AS CLIENTE,
 DOCELECTPROC.ESTADO AS ESTADO, 
 FAC.TOTAL_FACTURA AS TOTALFACTURA,
 0 SALDO,
 ( SELECT SUM(MONTO) 
 FROM (
 SELECT TOTAL_FACTURA AS MONTO FROM $$COMPANIA$$.FACTURA WHERE FACTURA=FAC.FACTURA 
 AND TIPO_DOCUMENTO = FAC.TIPO_DOCUMENTO 
 UNION ALL
 SELECT - (MONTO) AS MONTO FROM $$COMPANIA$$.FACTURA_RETENCION WHERE FACTURA=FAC.FACTURA
 AND TIPO_DOCUMENTO = FAC.TIPO_DOCUMENTO
 ) AS T
 ) AS TOTALFACTURARETENCION,
 FAC.FECHA AS FECHA, 
 FAC.MONEDA_FACTURA AS MONEDAFACTURA, 
 CONVERT(CHAR(36),LOWER(FAC.ROWPOINTER)) AS ROWPOINTER,
 'FACTURA' AS TABLA,
 FAC.RECORDDATE,
 FAC.CREATEDBY,
 FAC.UPDATEDBY,
 FAC.CREATEDATE,
 DOCELECTPROC.FOLIO_SAT AS FOLIOSAT,
 ISNULL(DOCELECTPROC.ENVIADO,'N') AS ENVIADO,
 DOCELECTPROC.NIT_EMISOR AS NIT_EMISOR,
 DOCELECTPROC.NIT_RECEPTOR AS NIT_RECEPTOR,
 ISNULL(DOCELECTPROC.ACEPTADO,'N') AS ACEPTADO,
 DOCELECTPROC.ACEPTACION_RECHAZO AS ACEPTACION_RECHAZO,
 DOCELECTPROC.DOCUMENTO_ELECTRONICO AS DOCUMENTO_ELECTRONICO,
 DOCELECTPROC.NOMBRE_PDF AS NOMBRE_PDF,
 DOCELECTPROC.NOMBRE_XML AS NOMBRE_XML,
 DOCELECTPROC.ESTADO_CARTA_PORTE AS ESTADO_CARTA_PORTE,
 DOCELECTPROC.GENERA_CARTA_PORTE AS GENERA_CARTA_PORTE,
 DOCELECTPROC.ERROR_WS AS ERROR_WS,
 DOCELECTPROC.ERROR_SOFTLAND AS ERROR_SOFTLAND,
 FAC.DOC_FISCAL AS DOCUMENTO_FISCAL,
 DOCELECTPROC.FIRMA_DOCUMENTO AS FIRMA_GT,
 DOCELECTPROC.GUUID_GT AS GUUID_GT
 FROM $$COMPANIA$$.FACTURA FAC 
 LEFT OUTER JOIN $$COMPANIA$$.DOC_ELECTRONICO_PROCESADO DOCELECTPROC 
 ON DOCELECTPROC.TIPO_DOC = FAC.TIPO_DOCUMENTO
 AND DOCELECTPROC.NUMERO_DOC = FAC.FACTURA 
 WHERE ( FAC.TIPO_DOCUMENTO != 'R' AND FAC.GENERA_DOC_FE = 'S')
 UNION ALL
 SELECT (CASE D.TIPO WHEN 'FAC' THEN 'F' WHEN 'N/C' THEN 'D' WHEN 'N/D' THEN 'ND' END) AS TIPODOCUMENTO, 
 D.DOCUMENTO AS FACTURA, 
 D.ANULADO AS ANULADA,
 D.CLIENTE AS CLIENTE,
 DOCELECTPROC.ESTADO AS ESTADO, 
 D.MONTO AS TOTALFACTURA,
 D.SALDO,
 ( SELECT SUM(MONTO) 
 FROM ( 
 SELECT D.MONTO AS MONTO 
 FROM $$COMPANIA$$.DOCUMENTOS_CC 
 WHERE DOCUMENTO=D.DOCUMENTO 
 AND TIPO = D.TIPO
 UNION ALL
 SELECT - (MONTO) AS MONTO 
 FROM $$COMPANIA$$.RETENCIONES_DOC_CC 
 WHERE DOCUMENTO=D.DOCUMENTO
 AND TIPO = D.TIPO
 ) AS T
 ) AS TOTALFACTURARETENCION,
 D.FECHA AS FECHA, 
 'L' AS MONEDAFACTURA, 
 CONVERT(CHAR(36),LOWER(D.ROWPOINTER)) AS ROWPOINTER,
 'DOCUMENTOS_CC' AS TABLA,
 D.RECORDDATE,
 D.CREATEDBY,
 D.UPDATEDBY,
 D.CREATEDATE,
 DOCELECTPROC.FOLIO_SAT AS FOLIOSAT,
 ISNULL(DOCELECTPROC.ENVIADO,'N') AS ENVIADO,
 DOCELECTPROC.NIT_EMISOR AS NIT_EMISOR,
 DOCELECTPROC.NIT_RECEPTOR AS NIT_RECEPTOR,
 ISNULL(DOCELECTPROC.ACEPTADO,'N') AS ACEPTADO,
 DOCELECTPROC.ACEPTACION_RECHAZO AS ACEPTACION_RECHAZO,
 DOCELECTPROC.DOCUMENTO_ELECTRONICO AS DOCUMENTO_ELECTRONICO,
 DOCELECTPROC.NOMBRE_PDF AS NOMBRE_PDF,
 DOCELECTPROC.NOMBRE_XML AS NOMBRE_XML,
 DOCELECTPROC.ESTADO_CARTA_PORTE AS ESTADO_CARTA_PORTE,
 DOCELECTPROC.GENERA_CARTA_PORTE AS GENERA_CARTA_PORTE,
 DOCELECTPROC.ERROR_WS AS ERROR_WS,
 DOCELECTPROC.ERROR_SOFTLAND AS ERROR_SOFTLAND,
 D.DOCUMENTO_FISCAL AS DOCUMENTO_FISCAL,
 DOCELECTPROC.FIRMA_DOCUMENTO AS FIRMA_GT,
 DOCELECTPROC.GUUID_GT AS GUUID_GT
 FROM $$COMPANIA$$.DOCUMENTOS_CC D
 LEFT OUTER JOIN $$COMPANIA$$.DOC_ELECTRONICO_PROCESADO DOCELECTPROC 
 ON DOCELECTPROC.TIPO_DOC = (CASE D.TIPO WHEN 'FAC' THEN 'F' WHEN 'N/C' THEN 'D' WHEN 'N/D' THEN 'ND' END)
 AND DOCELECTPROC.NUMERO_DOC = D.DOCUMENTO 
 WHERE D.TIPO IN ('FAC','N/C','N/D') 
 AND D.GENERA_DOC_FE = 'S' 
 AND 0 = ( 
 SELECT COUNT(0) FROM 
 $$COMPANIA$$.FACTURA F 
 WHERE D.DOCUMENTO = F.FACTURA 
 AND D.TIPO = ( CASE F.TIPO_DOCUMENTO WHEN 'F' THEN 'FAC' WHEN 'D' THEN 'N/C' END));

 
CREATE FUNCTION $$COMPANIA$$.INFO_DOC_RELACIONADO_CFDI_XML (@FACTURA VARCHAR(50), @TIPO VARCHAR(2))
RETURNS TABLE
AS
RETURN (
SELECT FOLIOSAT_DEBITO,DEBITO FROM $$COMPANIA$$.AUXILIAR_CC ACC 
WHERE (ACC.TIPO_CREDITO !='N/C' AND ACC.TIPO_DEBITO !='RED') 
AND ACC.CREDITO = @FACTURA  AND @TIPO=(CASE ACC.TIPO_CREDITO WHEN 'N/C' THEN 'D' END));
 
CREATE FUNCTION $$COMPANIA$$.DOCS_RELACIONADOS_CFDI_XML (@FACTURA VARCHAR(50), @TIPO VARCHAR(2))
  RETURNS XML
  AS
  BEGIN
  DECLARE @XMLDOCTOS_RELACIONADOS_CFDI_XML XML
  
  SET @XMLDOCTOS_RELACIONADOS_CFDI_XML = (SELECT * FROM $$COMPANIA$$.INFO_DOC_RELACIONADO_CFDI_XML(@FACTURA, @TIPO)
  FOR XML RAW ('CFDIRELACIONADO'), ROOT('CFDIRELACIONADOS'), ELEMENTS)
  RETURN @XMLDOCTOS_RELACIONADOS_CFDI_XML
  END;

CREATE FUNCTION $$COMPANIA$$.XML_DOCUMENTO(@compania varchar(10), @documento varchar(50), @tipo varchar(2))
 RETURNS XML
 AS
 BEGIN
 RETURN (
      SELECT   $$COMPANIA$$.COMPANIA_XML(@compania),
      $$COMPANIA$$.RESOLUCION_XML(@documento, @tipo), 
      $$COMPANIA$$.FACTURA_XML(@documento, @tipo), 
      $$COMPANIA$$.CLIENTE_XML(@documento, @tipo), 
      $$COMPANIA$$.DIRECCION_CLIENTE_XML(@documento, @tipo),
      $$COMPANIA$$.DIRECCION_EMBARQUE_XML(@documento, @tipo),
      $$COMPANIA$$.FACTURA_LINEA_XML(@documento, @tipo),
      $$COMPANIA$$.FACTURA_LINEA_RETENCION_XML(@documento, @tipo),
	 $$COMPANIA$$.DOCS_RELACIONADOS_CFDI_XML(@documento, @tipo)
  FOR XML RAW('DOCUMENTO'))
 END;

 
 /*Termina FE*/

CREATE VIEW $$COMPANIA$$.ConcecTransacFactFA_POS
AS	
			SELECT	fac.CONSECUTIVO AS CONCE
			FROM	$$COMPANIA$$.FACTURA fac
			GROUP BY fac.CONSECUTIVO;



CREATE VIEW $$COMPANIA$$.TotalFacturaXTipoPagoPOS_FA
AS
	SELECT fac.FACTURA, fac.TOTAL_FACTURA AS TOTALES, fac.CONSECUTIVO , '0001' AS FORMA_PAGO, 
		   'EFECTIVO' AS DESCRIPCION, FAC.TIPO_DOCUMENTO AS TIPO_DOCUMENTO
	FROM   $$COMPANIA$$.FACTURA fac;





CREATE VIEW $$COMPANIA$$.v_diarioConta
AS
SELECT DISTINCT fac.FACTURA, 
fac.FECHA, fac.ANULADA, 
fac.TIPO_DOCUMENTO, fac.NOMBREMAQUINA, ctf.CONCE,
	(SELECT        SUM(CASE WHEN FLD.TOTAL_IMPUESTO1 <> 0 OR
	FLD.TOTAL_IMPUESTO2 <> 0 THEN ((FLD.PRECIO_TOTAL - FLD.DESC_TOT_GENERAL) * fld.MULTIPLICADOR_EV) ELSE 0 END) AS Expr1
	FROM            $$COMPANIA$$.FACTURA_LINEA AS FLD
	WHERE        (FACTURA = fac.FACTURA)) AS GRAVADO,
	(SELECT        SUM(CASE WHEN FLD.TOTAL_IMPUESTO1 = 0 AND FLD.TOTAL_IMPUESTO2 = 0 THEN ((FLD.PRECIO_TOTAL - FLD.DESC_TOT_GENERAL) * FLD.MULTIPLICADOR_EV) ELSE 0 END) AS Expr1
	FROM            $$COMPANIA$$.FACTURA_LINEA AS FLD
	WHERE        (FACTURA = fac.FACTURA)) AS EXENTO
FROM            $$COMPANIA$$.FACTURA AS fac INNER JOIN
	$$COMPANIA$$.FACTURA_LINEA AS FLD ON fac.FACTURA = FLD.FACTURA INNER JOIN
	$$COMPANIA$$.SUBTIPO_DOC_CC AS sdc ON fac.TIPO_DOC_CXC = sdc.TIPO AND fac.SUBTIPO_DOC_CXC = sdc.SUBTIPO FULL OUTER JOIN
	$$COMPANIA$$.ConcecTransacFactFA_POS AS ctf ON fac.CONSECUTIVO = ctf.CONCE
WHERE        (fac.ANULADA = 'N') AND (fac.TIPO_DOCUMENTO = 'F' OR fac.TIPO_DOCUMENTO = 'D' );



CREATE VIEW $$Compania$$.SoftlandBI_FA_CotizacionPerdid
AS
		SELECT pedido COLLATE SQL_Latin1_General_CP1_CI_AS AS COTIZACION, 
			   cliente COLLATE SQL_Latin1_General_CP1_CI_AS AS CLIENTE, 
			   nombre_cliente COLLATE SQL_Latin1_General_CP1_CI_AS AS [NOMBRE CLIENTE], 
			   rubro1 COLLATE SQL_Latin1_General_CP1_CI_AS AS [RUBRO 1],
			   rubro2 COLLATE SQL_Latin1_General_CP1_CI_AS AS [RUBRO 2],
			   rubro3 COLLATE SQL_Latin1_General_CP1_CI_AS AS [RUBRO 3],
			   rubro4 COLLATE SQL_Latin1_General_CP1_CI_AS AS [RUBRO 4],
			   rubro5 COLLATE SQL_Latin1_General_CP1_CI_AS AS [RUBRO 5],
			   razon_cancela_coti COLLATE SQL_Latin1_General_CP1_CI_AS AS [RAZON CANCELACION], 
			   des_cancela_coti COLLATE SQL_Latin1_General_CP1_CI_AS AS [DESCRIPCION CANCELACION], 
			   CAST(SUBSTRING(CAST(fecha_ult_cancelac AS CHAR), 1, 11) AS DATETIME) AS [FECHA CANCELACION],
			   TOTAL_A_FACTURAR AS [TOTAL COTIZACION]
		FROM $$Compania$$.pedido
		WHERE estado = 'P'
		AND   tipo_documento = 'C';
		
		
		
		
		

CREATE VIEW $$Compania$$.SoftlandBI_FA_CotizacionGanada
AS
		SELECT pedido COLLATE SQL_Latin1_General_CP1_CI_AS AS COTIZACION,
			   cliente COLLATE SQL_Latin1_General_CP1_CI_AS AS CLIENTE,
			   nombre_cliente COLLATE SQL_Latin1_General_CP1_CI_AS AS [NOMBRE CLIENTE], 
			   rubro1 COLLATE SQL_Latin1_General_CP1_CI_AS AS [RUBRO 1],
			   rubro2 COLLATE SQL_Latin1_General_CP1_CI_AS AS [RUBRO 2],
			   rubro3 COLLATE SQL_Latin1_General_CP1_CI_AS AS [RUBRO 3],
			   rubro4 COLLATE SQL_Latin1_General_CP1_CI_AS AS [RUBRO 4],
			   rubro5 COLLATE SQL_Latin1_General_CP1_CI_AS AS [RUBRO 5],
			   CAST(SUBSTRING(CAST(fecha_aprobacion AS CHAR), 1, 11) AS DATETIME) AS [FECHA APROBACION],
			   TOTAL_A_FACTURAR AS [TOTAL COTIZACION]
		FROM $$Compania$$.PEDIDO
		WHERE ESTADO = 'A'
		aND TIPO_DOCUMENTO = 'C';
		
		
		
		
CREATE VIEW $$Compania$$.SoftlandBI_FA_Cotizaciones
AS
		SELECT pedido COLLATE SQL_Latin1_General_CP1_CI_AS AS COTIZACION,
			   cliente COLLATE SQL_Latin1_General_CP1_CI_AS AS CLIENTE,
			   nombre_cliente COLLATE SQL_Latin1_General_CP1_CI_AS AS [NOMBRE CLIENTE],
			   rubro1 COLLATE SQL_Latin1_General_CP1_CI_AS AS [RUBRO 1],
			   rubro2 COLLATE SQL_Latin1_General_CP1_CI_AS AS [RUBRO 2],
			   rubro3 COLLATE SQL_Latin1_General_CP1_CI_AS AS [RUBRO 3],
			   rubro4 COLLATE SQL_Latin1_General_CP1_CI_AS AS [RUBRO 4],
			   rubro5 COLLATE SQL_Latin1_General_CP1_CI_AS AS [RUBRO 5],
			   CAST(SUBSTRING(CAST(fecha_pedido AS CHAR), 1, 11) AS DATETIME) AS [FECHA COTIZACION],
			   TOTAL_A_FACTURAR AS [TOTAL COTIZACION]
		FROM $$Compania$$.pedido
		WHERE TIPO_DOCUMENTO = 'C';
		
		
		
		
		
/*Retenciones de FE*/		
	
	 
CREATE VIEW $$COMPANIA$$.V_DOCUMENTO_ELECTRONICO_CP
AS
SELECT        (CASE DCP.TIPO WHEN 'RET' THEN 'R' END) AS TIPODOCUMENTO, DCP.DOCUMENTO AS FACTURA, DCP.ANULADO AS ANULADA, DCP.PROVEEDOR, DOCELECTPROC.ESTADO, DCP.MONTO, 
                         DCP.SALDO AS SALDORETENCION, DCP.FECHA, DCP.MONEDA, CONVERT(CHAR(36), LOWER(DCP.RowPointer)) AS ROWPOINTER, 'DOCUMENTOS_CP' AS TABLA, 
                         DCP.RecordDate, DCP.CreatedBy, DCP.UpdatedBy, DCP.CreateDate, DOCELECTPROC.FOLIO_SAT AS FOLIOSAT, ISNULL(DOCELECTPROC.ENVIADO, 'N') 
                         AS ENVIADO, DOCELECTPROC.NIT_EMISOR, DOCELECTPROC.NIT_RECEPTOR, ISNULL(DOCELECTPROC.ACEPTADO, 'N') AS ACEPTADO, 
                         DOCELECTPROC.ACEPTACION_RECHAZO, DOCELECTPROC.DOCUMENTO_ELECTRONICO, DOCELECTPROC.NOMBRE_PDF, DOCELECTPROC.NOMBRE_XML, 
                         DOCELECTPROC.ESTADO_CARTA_PORTE, DOCELECTPROC.GENERA_CARTA_PORTE, DOCELECTPROC.ERROR_WS, DOCELECTPROC.ERROR_SOFTLAND, 
                         DCP.DOCUMENTO_FISCAL, DOCELECTPROC.FIRMA_DOCUMENTO AS FIRMA_GT, DOCELECTPROC.GUUID_GT
FROM            $$COMPANIA$$.DOCUMENTOS_CP AS DCP LEFT OUTER JOIN
                         $$COMPANIA$$.DOC_ELECTRONICO_PROCESADO AS DOCELECTPROC ON DOCELECTPROC.TIPO_DOC = (CASE DCP.TIPO WHEN 'RET' THEN 'R' END) AND 
                         DOCELECTPROC.NUMERO_DOC = DCP.DOCUMENTO
WHERE        (DCP.TIPO = 'RET' ) AND (DCP.GENERA_DOC_FE = 'S');	 
	 

	 
CREATE FUNCTION $$COMPANIA$$.INFO_DIRECCION_PROVEEDOR_XML (@FACTURA VARCHAR(50), @TIPO VARCHAR(2))
   RETURNS TABLE
   AS
   RETURN (
   SELECT
   ISNULL(DD.CAMPO_1, 'CAMPO EN BLANCO') AS DIREC_CAMPO_1,
   ISNULL(DD.CAMPO_2, 'CAMPO EN BLANCO') AS DIREC_CAMPO_2,
   ISNULL(DD.CAMPO_3, 'CAMPO EN BLANCO') AS DIREC_CAMPO_3,
   ISNULL(DD.CAMPO_4, 'CAMPO EN BLANCO') AS DIREC_CAMPO_4,
   ISNULL(DD.CAMPO_5, 'CAMPO EN BLANCO') AS DIREC_CAMPO_5,
   ISNULL(DD.CAMPO_6, 'CAMPO EN BLANCO') AS DIREC_CAMPO_6,
   ISNULL(DD.CAMPO_7, 'CAMPO EN BLANCO') AS DIREC_CAMPO_7,
   ISNULL(DD.CAMPO_8, 'CAMPO EN BLANCO') AS DIREC_CAMPO_8,
   ISNULL(DD.CAMPO_9, 'CAMPO EN BLANCO') AS DIREC_CAMPO_9,
   ISNULL(DD.CAMPO_10, 'CAMPO EN BLANCO') AS DIREC_CAMPO_10
   FROM $$COMPANIA$$.DOCUMENTOS_CP DCP
   INNER JOIN $$COMPANIA$$.PROVEEDOR P ON DCP.PROVEEDOR = P.PROVEEDOR
   INNER JOIN $$COMPANIA$$.DETALLE_DIRECCION DD ON P.DETALLE_DIRECCION = DD.DETALLE_DIRECCION
   WHERE 0 = ( SELECT COUNT(*) FROM $$COMPANIA$$.DOCUMENTOS_CP DCP
   WHERE DCP.DOCUMENTO = @FACTURA
   AND DCP.TIPO = @TIPO )
   AND DCP.DOCUMENTO = @FACTURA AND @TIPO = (CASE DCP.TIPO WHEN 'FAC' THEN 'F' WHEN 'N/C' THEN 'D' WHEN 'N/D' THEN 'ND' WHEN 'RET' THEN 'R' END)
   );
	 
	 
CREATE FUNCTION $$COMPANIA$$.DIRECCION_PROVEEDOR_XML (@FACTURA VARCHAR(50), @TIPO VARCHAR(2))
  RETURNS XML
  AS
  BEGIN
  DECLARE @XMLDIRECCIONPROVEEDOR XML
  
  SET @XMLDIRECCIONPROVEEDOR = (  SELECT * FROM $$COMPANIA$$.INFO_DIRECCION_PROVEEDOR_XML(@FACTURA, @TIPO)
  FOR XML RAW ('DIRECCION_PROVEEDOR'), ELEMENTS)
  RETURN @XMLDIRECCIONPROVEEDOR
  END;	 
	 


CREATE FUNCTION $$COMPANIA$$.INFO_FACTURA_XML_RET (@FACTURA VARCHAR(50), @TIPO VARCHAR(2))
   RETURNS TABLE
   AS
   RETURN (
SELECT 
   DCP.DOCUMENTO,
   ISNULL(DCP.DOCUMENTO_FISCAL,'CAMPO EN BLANCO') DOCUMENTO_FISCAL,
   DCP.CONDICION_PAGO,
   CP.DESCRIPCION DESCRIPCION_CONDICION_PAGO, 
   DCP.FECHA,
   ToDateTimeOffset (DATEADD(S,DATEPART(S,DCP.CREATEDATE),DATEADD(MI,DATEPART(MI,DCP.CREATEDATE),DATEADD(HH,DATEPART(HH,DCP.CREATEDATE),DCP.FECHA))), DATEPART(TZOFFSET , SYSDATETIMEOFFSET()) )FECHA_HORA,
   DCP.FECHA_DOCUMENTO FECHA_ORDEN,
   DCP.MONEDA,
   CAST (DCP.RUBRO1 AS DECIMAL(28,6)) AS MONTO_FLETE,
   CAST (DCP.RUBRO2 AS DECIMAL(28,6)) AS SEGURO,
   CAST (DCP.TIPO_CAMBIO_MONEDA AS DECIMAL(28,6)) AS TIPO_CAMBIO,
   (CASE DCP.TIPO WHEN 'FAC' THEN 'F' WHEN 'RET' THEN 'R' END ) AS TIPO_DOCUMENTO,
   CAST (DCP.MONTO AS DECIMAL(28,6)) AS TOTAL_RETENCION,
   $$COMPANIA$$.NUMEROALETRAS(DCP.MONTO) AS TOTAL_RETENCION_LETRAS,
   CAST (DCP.SUBTOTAL AS DECIMAL(28,6)) AS SUBTOTAL_RETENCION,
   $$COMPANIA$$.NUMEROALETRAS(DCP.MONTO) AS SUBTOTAL_RETENCION_LETRAS,
   CAST ('1' AS DECIMAL(28,6)) AS TOTAL_UNIDADES,
   CAST (DCP.IMPUESTO1 AS DECIMAL(28,6)) IMPUESTO1,
    CAST (DCP.IMPUESTO2 AS DECIMAL(28,6))IMPUESTO2,   
   CAST (ISNULL(RT.PORCENTAJE,0) AS DECIMAL(28,6)) AS RETENCION_PORCENTAJE,      
   CAST (ISNULL(DR.MONTO,0) AS DECIMAL(28,6)) AS RETENCION_MONTO,
   RT.DESCRIPCION,
   DCP.ANULADO,
   ISNULL(DR.DOCUMENTO, 'CAMPO EN BLANCO') AS FACTURA_ORIGINAL,  
   DCP.FECHA AS FECHA_ORIGINAL,
   DATEADD(S,DATEPART(S,DCP.CREATEDATE),DATEADD(MI,DATEPART(MI,DCP.CREATEDATE),DATEADD(HH,DATEPART(HH,DCP.CREATEDATE),DCP.FECHA)))					    FECHA_HORA_ORIGINAL,
   DCP.FECHA_VENCE,
   DCP.FECHA FECHA_PROMETIDA 
   FROM $$COMPANIA$$.DOCUMENTOS_CP DCP
   LEFT JOIN $$COMPANIA$$.CONDICION_PAGO CP
   ON CP.CONDICION_PAGO = DCP.CONDICION_PAGO  
   LEFT JOIN $$COMPANIA$$.DETALLE_RETENCION DR 
   ON DCP.DOCUMENTO = DR.RETENCION  AND DCP.PROVEEDOR = DR.PROVEEDOR
   LEFT JOIN $$COMPANIA$$.RETENCIONES RT
   ON DR.CODIGO_RETENCION = RT.CODIGO_RETENCION
   WHERE  0 = ( SELECT COUNT(*) FROM $$COMPANIA$$.DOCUMENTOS_CP FAC
   WHERE FAC.DOCUMENTO = @FACTURA
   AND FAC.TIPO = @TIPO  ) 
    AND DCP.DOCUMENTO = @FACTURA AND @TIPO = (CASE DCP.TIPO WHEN 'FAC' THEN 'F' WHEN 'N/D' THEN 'D' WHEN 'N/D' THEN 'ND' WHEN 'RET' THEN 'R' END)
);


CREATE FUNCTION $$COMPANIA$$.FACTURA_RET_XML (@FACTURA VARCHAR(50), @TIPO VARCHAR(2))
  RETURNS XML
  AS
  BEGIN
  DECLARE @XMLFACTURARET XML
  
  SET @XMLFACTURARET = (  SELECT * FROM $$COMPANIA$$.INFO_FACTURA_XML_RET(@FACTURA, @TIPO)
  FOR XML RAW ('ENCABEZADO'), ELEMENTS)
  RETURN @XMLFACTURARET
  END;

	 
CREATE FUNCTION $$COMPANIA$$.INFO_PROVEEDOR_XML (@FACTURA VARCHAR(50), @TIPO VARCHAR(2))
   RETURNS TABLE
   AS
   RETURN (
   SELECT
   DCP.PROVEEDOR,
   P.NOMBRE,
   P.DETALLE_DIRECCION,
   P.ALIAS,
   P.CONTACTO,
   P.CARGO,
   P.DIRECCION,
   P.TELEFONO1,
   P.TELEFONO2,
   P.FAX,
   P.CONTRIBUYENTE,
   P.FECHA_INGRESO,
   P.MULTIMONEDA,
   P.MONEDA,
   P.SALDO,
   P.SALDO_LOCAL,
   P.SALDO_DOLAR,  
   P.TASA_INTERES_MORA,
   P.FECHA_ULT_MOV,
   P.CONDICION_PAGO,
   P.DESCUENTO,
   P.PAIS,
   P.ACTIVO,
   P.E_MAIL,
   P.NOTAS,
   P.GLN,
   P.UBICACION,
   P.LOCAL,
   P.TIPO_CONTRIBUYENTE,
   P.MODELO_RETENCION,
   P.ACEPTA_DOC_ELECTRONICO,
   P.EMAIL_DOC_ELECTRONICO,
   P.CODIGO_IMPUESTO,
   P.DIVISION_GEOGRAFICA1,
   P.DIVISION_GEOGRAFICA2,
   P.REGIMEN_TRIB,
   P.SALDO_TRANS_LOCAL,
   P.SALDO_TRANS_DOLAR,
   P.PERMITE_DOC_GP,
   P.PARTICIPA_FLUJOCAJA,
   P.CURP,
   I.IMPUESTO1,
   I.IMPUESTO2,
   P.RUBRO1_PROV,
   P.RUBRO2_PROV,
   P.RUBRO3_PROV,
   P.RUBRO4_PROV,
   P.RUBRO5_PROV,
   P.RUBRO1_PROVEEDOR,
   P.RUBRO2_PROVEEDOR,
   P.RUBRO3_PROVEEDOR,
   P.RUBRO4_PROVEEDOR,
   P.RUBRO5_PROVEEDOR,
   P.RUBRO6_PROVEEDOR,
   P.RUBRO7_PROVEEDOR,
   P.RUBRO8_PROVEEDOR,
   P.RUBRO9_PROVEEDOR,
   P.RUBRO10_PROVEEDOR
   FROM $$COMPANIA$$.DOCUMENTOS_CP DCP
   INNER JOIN $$COMPANIA$$.PROVEEDOR P ON DCP.PROVEEDOR = P.PROVEEDOR
   LEFT JOIN $$COMPANIA$$.IMPUESTO I ON P.CODIGO_IMPUESTO = I.IMPUESTO 
   WHERE  0 = ( SELECT COUNT(*) FROM $$COMPANIA$$.DOCUMENTOS_CP FAC
   WHERE FAC.DOCUMENTO = @FACTURA
   AND FAC.TIPO = @TIPO  )
   AND  DCP.DOCUMENTO = @FACTURA AND @TIPO = (CASE DCP.TIPO WHEN 'FAC' THEN 'F' WHEN 'N/D' THEN 'D' WHEN 'N/D' THEN 'ND' WHEN 'RET' THEN 'R' END)
   );
   
   
   
   CREATE FUNCTION $$COMPANIA$$.PROVEEDOR_XML (@FACTURA VARCHAR(50), @TIPO VARCHAR(2))
     RETURNS XML
     AS
     BEGIN
     DECLARE @XMLPROVEEDOR XML
     
     SET @XMLPROVEEDOR = (  SELECT * FROM $$COMPANIA$$.INFO_PROVEEDOR_XML(@FACTURA, @TIPO)
     FOR XML RAW ('PROVEEDOR'), ELEMENTS)
     RETURN @XMLPROVEEDOR
     END;

	 
CREATE FUNCTION $$COMPANIA$$.INFO_RETENCIONES_XML (@FACTURA VARCHAR(50), @TIPO VARCHAR(2))
   RETURNS TABLE
   AS
   RETURN (
   SELECT
  DR.RETENCION,
  DR.CODIGO_RETENCION,
  DR.MONTO MONTO_RET,
  DCP.MONTO MONTO_FACT,
  DCP.MONTO_RETENCION MONTO_TOTAL_RETENCIONES,
  DR.BASE,
  DR.ESTADO,
  DCP.IMPUESTO1 IMPUESTO_FAC1,
  DCP.IMPUESTO2 IMPUESTO_FAC2
   FROM $$COMPANIA$$.DOCUMENTOS_CP DCP 
   INNER JOIN 
	$$COMPANIA$$.DETALLE_RETENCION DR ON DCP.DOCUMENTO = DR.RETENCION AND DCP.PROVEEDOR = DR.PROVEEDOR
   WHERE 0 = ( SELECT COUNT(*) FROM $$COMPANIA$$.DOCUMENTOS_CP   FAC
   WHERE FAC.DOCUMENTO = @FACTURA
      AND FAC.TIPO = @TIPO)
  AND DCP.DOCUMENTO = @FACTURA AND @TIPO =(CASE DCP.TIPO WHEN 'FAC' THEN 'F' WHEN 'N/C' THEN 'D' WHEN 'N/D' THEN 'ND' WHEN 'RET' THEN 'R' END)
 );
 
 
 
CREATE FUNCTION $$COMPANIA$$.RETENCIONES_XML (@FACTURA VARCHAR(50), @TIPO VARCHAR(2))
  RETURNS XML
  AS
  BEGIN
  DECLARE @XMLRETENCIONES XML
  
  SET @XMLRETENCIONES = (  SELECT * FROM $$COMPANIA$$.INFO_RETENCIONES_XML(@FACTURA, @TIPO)
  FOR XML RAW ('LINEA'), ROOT('RETENCION_LINEA'), ELEMENTS)
  RETURN @XMLRETENCIONES
  END;
  
  
  CREATE FUNCTION $$COMPANIA$$.XML_DOCUMENTO_RET(@compania varchar(10), @documento varchar(50), @tipo varchar(2))
    RETURNS XML
    AS
    BEGIN
    RETURN (
        SELECT $$COMPANIA$$.COMPANIA_XML(@compania),
        $$COMPANIA$$.RESOLUCION_XML(@documento, @tipo), 
        $$COMPANIA$$.FACTURA_RET_XML(@documento, @tipo), 
        $$COMPANIA$$.PROVEEDOR_XML(@documento, @tipo), 
        $$COMPANIA$$.DIRECCION_PROVEEDOR_XML(@documento, @tipo),
        $$COMPANIA$$.RETENCIONES_XML(@documento, @tipo)
    FOR XML RAW('DOCUMENTO'))
  END;
 
 
/*Termina retenciones de FE */
CREATE TRIGGER $$COMPANIA$$.CLIENTE_VEND_POS_SINC_DEL
ON $$COMPANIA$$.CLIENTE_VENDEDOR
FOR DELETE  
AS 
BEGIN   	
	DECLARE @ERROR INT
	DECLARE @SENTENCIA   		VARCHAR(254)
	DECLARE @NOMBRETABLA		VARCHAR(254)
	DECLARE @USUARIO_ACTUAL		VARCHAR(30)

	DECLARE @CLIENTE VARCHAR(20)
	DECLARE @VENDEDOR VARCHAR(4)

	SET @NOMBRETABLA = 'CLIENTE_VENDEDOR'

	EXEC ERPADMIN.LeerUsuarioActual @USUARIO_ACTUAL OUTPUT

	/*Aquí se hace la validación del usuario de conexión para evitar ping-pong*/
	IF NOT ('SoftlandSync' = @USUARIO_ACTUAL)
	BEGIN
		DECLARE C_DELETED CURSOR LOCAL FOR
			SELECT CLIENTE, VENDEDOR
			FROM DELETED d
			
		OPEN C_DELETED
		FETCH NEXT FROM C_DELETED INTO 
		@CLIENTE, @VENDEDOR
		
		SET @ERROR = 0
		
		WHILE @@FETCH_STATUS = 0 AND @ERROR = 0
		BEGIN
			SET @SENTENCIA = 'DELETE FROM $$COMPANIA$$.' + @NOMBRETABLA + ' WHERE CLIENTE = ''' + @CLIENTE + ''' AND VENDEDOR = ''' + @VENDEDOR + ''''
			
			EXECUTE @ERROR = $$COMPANIA$$.POS_INSERTA_ELIMINACION @SENTENCIA, @NOMBRETABLA
			
			FETCH NEXT FROM C_DELETED INTO 
			@CLIENTE, @VENDEDOR
		END

		CLOSE C_DELETED
		DEALLOCATE C_DELETED
	END
	
	IF (@@ERROR <> 0) 
	BEGIN
		RAISERROR( 'Error generando la sentencia de eliminación de la tabla CLIENTE_VENDEDOR.',16,1 )
	END
END
;


CREATE TRIGGER $$COMPANIA$$.CLIENTE_RET_POS_SINC_DEL
ON $$COMPANIA$$.CLIENTE_RETENCION
FOR DELETE  
AS 
BEGIN   	
   	DECLARE @ERROR INT
	DECLARE @SENTENCIA   		VARCHAR(254)
	DECLARE @NOMBRETABLA		VARCHAR(254)
	DECLARE @USUARIO_ACTUAL		VARCHAR(30)

	DECLARE @CLIENTE VARCHAR(20)
	DECLARE @CODIGO_RETENCION VARCHAR(4)

	SET @NOMBRETABLA = 'CLIENTE_RETENCION'

	EXEC ERPADMIN.LeerUsuarioActual @USUARIO_ACTUAL OUTPUT

	/*Aquí se hace la validación del usuario de conexión para evitar ping-pong*/
	IF NOT ('SoftlandSync' = @USUARIO_ACTUAL)
	BEGIN
		DECLARE C_DELETED CURSOR LOCAL FOR
			SELECT CLIENTE, CODIGO_RETENCION
			FROM DELETED d
		
		OPEN C_DELETED
		FETCH NEXT FROM C_DELETED INTO 
		@CLIENTE, @CODIGO_RETENCION
		
		SET @ERROR = 0
		
		WHILE @@FETCH_STATUS = 0 AND @ERROR = 0
		BEGIN
			SET @SENTENCIA = 'DELETE FROM $$COMPANIA$$.' + @NOMBRETABLA + ' WHERE CLIENTE = ''' + @CLIENTE + ''' AND CODIGO_RETENCION = ''' + @CODIGO_RETENCION + ''''
			
			EXECUTE @ERROR = $$COMPANIA$$.POS_INSERTA_ELIMINACION @SENTENCIA, @NOMBRETABLA
			
			FETCH NEXT FROM C_DELETED INTO 
			@CLIENTE, @CODIGO_RETENCION
		END

		CLOSE C_DELETED
		DEALLOCATE C_DELETED
	END
	
	IF (@@ERROR <> 0) 
	BEGIN
		RAISERROR( 'Error generando la sentencia de eliminación de la tabla CLIENTE_RETENCION.',16,1 )
	END
END
;


CREATE TRIGGER $$COMPANIA$$.ESCALA_BONIF_POS_SINC_DEL
ON $$COMPANIA$$.ESCALA_BONIF
FOR DELETE  
AS 
BEGIN   	
	DECLARE @ERROR INT
	DECLARE @SENTENCIA   		VARCHAR(254)
	DECLARE @NOMBRETABLA		VARCHAR(254)
	DECLARE @USUARIO_ACTUAL		VARCHAR(30)

	DECLARE @NIVEL_PRECIO VARCHAR(12)
	DECLARE @MONEDA VARCHAR(1)
	DECLARE @VERSION INT
	DECLARE @ARTICULO VARCHAR(20)
	DECLARE @ESCALA_BONIF INT
	DECLARE @VERSION_BONIF INT

	SET @NOMBRETABLA = 'ESCALA_BONIF'

	EXEC ERPADMIN.LeerUsuarioActual @USUARIO_ACTUAL OUTPUT

	/*Aquí se hace la validación del usuario de conexión para evitar ping-pong*/
	IF NOT ('SoftlandSync' = @USUARIO_ACTUAL)
	BEGIN
		DECLARE C_DELETED CURSOR LOCAL FOR
			SELECT NIVEL_PRECIO, MONEDA, VERSION, ARTICULO, ESCALA_BONIF, VERSION_BONIF
			FROM DELETED d

		OPEN C_DELETED
		FETCH NEXT FROM C_DELETED INTO 
		@NIVEL_PRECIO, @MONEDA, @VERSION, @ARTICULO, @ESCALA_BONIF, @VERSION_BONIF
		
		SET @ERROR = 0
		
		WHILE @@FETCH_STATUS = 0 AND @ERROR = 0
		BEGIN
			SET @SENTENCIA = 'DELETE FROM $$COMPANIA$$.' + @NOMBRETABLA + ' WHERE NIVEL_PRECIO = ''' + @NIVEL_PRECIO + ''' AND MONEDA = ''' + @MONEDA + ''' AND VERSION = ''' + CONVERT(VARCHAR(36),@VERSION)  + ''' AND ARTICULO = ''' + @ARTICULO + ''' AND ESCALA_BONIF = ''' + CONVERT(VARCHAR(36),@ESCALA_BONIF)  + ''' AND VERSION_BONIF = ''' + CONVERT(VARCHAR(36), @VERSION_BONIF)  + ''''
			
			EXECUTE @ERROR = $$COMPANIA$$.POS_INSERTA_ELIMINACION @SENTENCIA, @NOMBRETABLA
			
			FETCH NEXT FROM C_DELETED INTO 
			@NIVEL_PRECIO, @MONEDA, @VERSION, @ARTICULO, @ESCALA_BONIF, @VERSION_BONIF
		END

		CLOSE C_DELETED
		DEALLOCATE C_DELETED
	END
	
	IF (@@ERROR <> 0) 
	BEGIN
		RAISERROR( 'Error generando la sentencia de eliminación de la tabla ESCALA_BONIF.',16,1 )
	END
END
;



CREATE TRIGGER $$COMPANIA$$.ESCALA_DCTO_POS_SINC_DEL
ON $$COMPANIA$$.ESCALA_DCTO
FOR DELETE  
AS 
BEGIN   	
    DECLARE @ERROR INT
	DECLARE @SENTENCIA   		VARCHAR(254)
	DECLARE @NOMBRETABLA		VARCHAR(254)
	DECLARE @USUARIO_ACTUAL		VARCHAR(30)

	DECLARE @NIVEL_PRECIO VARCHAR(12)
	DECLARE @MONEDA VARCHAR(1)
	DECLARE @VERSION INT
	DECLARE @ARTICULO VARCHAR(20)
	DECLARE @ESCALA_DCTO INT
	DECLARE @VERSION_DCTO INT

	SET @NOMBRETABLA = 'ESCALA_DCTO'

	EXEC ERPADMIN.LeerUsuarioActual @USUARIO_ACTUAL OUTPUT

	/*Aquí se hace la validación del usuario de conexión para evitar ping-pong*/
	IF NOT ('SoftlandSync' = @USUARIO_ACTUAL)
	BEGIN
		DECLARE C_DELETED CURSOR LOCAL FOR
			SELECT NIVEL_PRECIO, MONEDA, VERSION, ARTICULO, ESCALA_DCTO, VERSION_DCTO
			FROM DELETED d
			
		OPEN C_DELETED
		FETCH NEXT FROM C_DELETED INTO 
		@NIVEL_PRECIO, @MONEDA, @VERSION, @ARTICULO, @ESCALA_DCTO, @VERSION_DCTO
		
		SET @ERROR = 0
		
		WHILE @@FETCH_STATUS = 0 AND @ERROR = 0
		BEGIN
			SET @SENTENCIA = 'DELETE FROM $$COMPANIA$$.' + @NOMBRETABLA + ' WHERE NIVEL_PRECIO = ''' + @NIVEL_PRECIO + ''' AND MONEDA = ''' + @MONEDA + ''' AND VERSION = ''' + CONVERT(VARCHAR(36),@VERSION)  + ''' AND ARTICULO = ''' + @ARTICULO + ''' AND ESCALA_DCTO = ''' +  CONVERT(VARCHAR(36),@ESCALA_DCTO) + ''' AND VERSION_DCTO = ''' + CONVERT(VARCHAR(36),@VERSION_DCTO)  + ''''
			
			EXECUTE @ERROR = $$COMPANIA$$.POS_INSERTA_ELIMINACION @SENTENCIA, @NOMBRETABLA
			
			FETCH NEXT FROM C_DELETED INTO 
			@NIVEL_PRECIO, @MONEDA, @VERSION, @ARTICULO, @ESCALA_DCTO, @VERSION_DCTO
		END

		CLOSE C_DELETED
		DEALLOCATE C_DELETED
	END
	
	IF (@@ERROR <> 0) 
	BEGIN
		RAISERROR( 'Error generando la sentencia de eliminación de la tabla ESCALA_DCTO.',16,1 )
	END
END
;



CREATE TRIGGER $$COMPANIA$$.DES_BON_ESC_BON_POS_SINC_DEL
ON $$COMPANIA$$.DES_BON_ESCALA_BONIFICACION
FOR DELETE  
AS 
BEGIN   	
    DECLARE @ERROR INT
	DECLARE @SENTENCIA   		VARCHAR(254)
	DECLARE @NOMBRETABLA		VARCHAR(254)
	DECLARE @USUARIO_ACTUAL		VARCHAR(30)
	
	DECLARE @ESCALA INT
	DECLARE @REGLA VARCHAR(20)
	
	SET @NOMBRETABLA = 'DES_BON_ESCALA_BONIFICACION'

	EXEC ERPADMIN.LeerUsuarioActual @USUARIO_ACTUAL OUTPUT

	/*Aquí se hace la validación del usuario de conexión para evitar ping-pong*/
	IF NOT ('SoftlandSync' = @USUARIO_ACTUAL)
	BEGIN
		DECLARE C_DELETED CURSOR LOCAL FOR
			SELECT ESCALA, REGLA
			FROM DELETED d

		OPEN C_DELETED
		FETCH NEXT FROM C_DELETED INTO 
		@ESCALA, @REGLA
		
		SET @ERROR = 0
		
		WHILE @@FETCH_STATUS = 0 AND @ERROR = 0
		BEGIN
			SET @SENTENCIA = 'DELETE FROM $$COMPANIA$$.' + @NOMBRETABLA + ' WHERE ESCALA = ''' + CONVERT(VARCHAR(36),@ESCALA)  + ''' AND REGLA = ''' + @REGLA + ''''
			
			EXECUTE @ERROR = $$COMPANIA$$.POS_INSERTA_ELIMINACION @SENTENCIA, @NOMBRETABLA
			
			FETCH NEXT FROM C_DELETED INTO 
			@ESCALA, @REGLA
		END

		CLOSE C_DELETED
		DEALLOCATE C_DELETED
	END
	
	IF (@@ERROR <> 0) 
	BEGIN
		RAISERROR( 'Error generando la sentencia de eliminación de la tabla DES_BON_ESCALA_BONIFICACION.',16,1 )
	END
END
;



CREATE TRIGGER $$COMPANIA$$.DES_BON_PAQUETE_POS_SINC_DEL
ON $$COMPANIA$$.DES_BON_PAQUETE
FOR DELETE  
AS 
BEGIN   	
    DECLARE @ERROR INT
	DECLARE @SENTENCIA   		VARCHAR(254)
	DECLARE @NOMBRETABLA		VARCHAR(254)
	DECLARE @USUARIO_ACTUAL		VARCHAR(30)

	DECLARE @PAQUETE VARCHAR(20)
	
	SET @NOMBRETABLA = 'DES_BON_PAQUETE'

	EXEC ERPADMIN.LeerUsuarioActual @USUARIO_ACTUAL OUTPUT

	/*Aquí se hace la validación del usuario de conexión para evitar ping-pong*/
	IF NOT ('SoftlandSync' = @USUARIO_ACTUAL)
	BEGIN
		DECLARE C_DELETED CURSOR LOCAL FOR
			SELECT PAQUETE
			FROM DELETED d

		OPEN C_DELETED
		FETCH NEXT FROM C_DELETED INTO 
		@PAQUETE
		
		SET @ERROR = 0
		
		WHILE @@FETCH_STATUS = 0 AND @ERROR = 0
		BEGIN
			SET @SENTENCIA = 'DELETE FROM $$COMPANIA$$.' + @NOMBRETABLA + ' WHERE PAQUETE = ''' + @PAQUETE + ''''
			
			EXECUTE @ERROR = $$COMPANIA$$.POS_INSERTA_ELIMINACION @SENTENCIA, @NOMBRETABLA
			
			FETCH NEXT FROM C_DELETED INTO 
			@PAQUETE
		END

		CLOSE C_DELETED
		DEALLOCATE C_DELETED
	END
	
	IF (@@ERROR <> 0) 
	BEGIN
		RAISERROR( 'Error generando la sentencia de eliminación de la tabla DES_BON_PAQUETE.',16,1 )
	END
END
;


CREATE TRIGGER $$COMPANIA$$.DES_BON_PAQ_REGLA_POS_SINC_DEL
ON $$COMPANIA$$.DES_BON_PAQUETE_REGLA
FOR DELETE  
AS 
BEGIN   	
	DECLARE @ERROR INT
	DECLARE @SENTENCIA   		VARCHAR(254)
	DECLARE @NOMBRETABLA		VARCHAR(254)
	DECLARE @USUARIO_ACTUAL		VARCHAR(30)

	DECLARE @PAQUETE VARCHAR(20)
	DECLARE @REGLA VARCHAR(20)
	
	SET @NOMBRETABLA = 'DES_BON_PAQUETE_REGLA'

	EXEC ERPADMIN.LeerUsuarioActual @USUARIO_ACTUAL OUTPUT

	/*Aquí se hace la validación del usuario de conexión para evitar ping-pong*/
	IF NOT ('SoftlandSync' = @USUARIO_ACTUAL)
	BEGIN
		DECLARE C_DELETED CURSOR LOCAL FOR
			SELECT PAQUETE, REGLA
			FROM DELETED d

		OPEN C_DELETED
		FETCH NEXT FROM C_DELETED INTO 
		@PAQUETE, @REGLA
		
		SET @ERROR = 0
		
		WHILE @@FETCH_STATUS = 0 AND @ERROR = 0
		BEGIN
			SET @SENTENCIA = 'DELETE FROM $$COMPANIA$$.' + @NOMBRETABLA + ' WHERE PAQUETE = ''' + @PAQUETE + ''' AND REGLA = ''' + @REGLA + ''''
			
			EXECUTE @ERROR = $$COMPANIA$$.POS_INSERTA_ELIMINACION @SENTENCIA, @NOMBRETABLA
			
			FETCH NEXT FROM C_DELETED INTO 
			@PAQUETE, @REGLA
		END

		CLOSE C_DELETED
		DEALLOCATE C_DELETED
	END
	
	IF (@@ERROR <> 0) 
	BEGIN
		RAISERROR( 'Error generando la sentencia de eliminación de la tabla DES_BON_PAQUETE_REGLA.',16,1 )
	END
END
;


CREATE TRIGGER $$COMPANIA$$.DES_BON_PAQ_RUTA_POS_SINC_DEL
ON $$COMPANIA$$.DES_BON_PAQUETE_RUTA
FOR DELETE  
AS 
BEGIN   	
    DECLARE @ERROR INT
	DECLARE @SENTENCIA   		VARCHAR(254)
	DECLARE @NOMBRETABLA		VARCHAR(254)
	DECLARE @USUARIO_ACTUAL		VARCHAR(30)

	DECLARE @PAQUETE VARCHAR(20)
	DECLARE @RUTA VARCHAR(4)
	
	SET @NOMBRETABLA = 'DES_BON_PAQUETE_RUTA'

	EXEC ERPADMIN.LeerUsuarioActual @USUARIO_ACTUAL OUTPUT

	/*Aquí se hace la validación del usuario de conexión para evitar ping-pong*/
	IF NOT ('SoftlandSync' = @USUARIO_ACTUAL)
	BEGIN
		DECLARE C_DELETED CURSOR LOCAL FOR
			SELECT PAQUETE, RUTA
			FROM DELETED d
			
		OPEN C_DELETED
		FETCH NEXT FROM C_DELETED INTO 
		@PAQUETE, @RUTA
		
		SET @ERROR = 0
		
		WHILE @@FETCH_STATUS = 0 AND @ERROR = 0
		BEGIN
			SET @SENTENCIA = 'DELETE FROM $$COMPANIA$$.' + @NOMBRETABLA + ' WHERE PAQUETE = ''' + @PAQUETE + ''' AND RUTA = ''' + @RUTA + ''''
			
			EXECUTE @ERROR = $$COMPANIA$$.POS_INSERTA_ELIMINACION @SENTENCIA, @NOMBRETABLA
			
			FETCH NEXT FROM C_DELETED INTO 
			@PAQUETE, @RUTA
		END

		CLOSE C_DELETED
		DEALLOCATE C_DELETED
	END
	
	IF (@@ERROR <> 0) 
	BEGIN
		RAISERROR( 'Error generando la sentencia de eliminación de la tabla DES_BON_PAQUETE_RUTA.',16,1 )
	END
END
;

CREATE TRIGGER $$COMPANIA$$.DES_BON_PAQ_TI_POS_SINC_DEL
ON $$COMPANIA$$.DES_BON_PAQUETE_TIENDA
FOR DELETE  
AS 
BEGIN   	
	DECLARE @ERROR INT
	DECLARE @SENTENCIA   		VARCHAR(254)
	DECLARE @NOMBRETABLA		VARCHAR(254)
	DECLARE @USUARIO_ACTUAL		VARCHAR(30)

	DECLARE @PAQUETE VARCHAR(20)
	DECLARE @TIENDA VARCHAR(6)
	
	SET @NOMBRETABLA = 'DES_BON_PAQUETE_TIENDA'

	EXEC ERPADMIN.LeerUsuarioActual @USUARIO_ACTUAL OUTPUT

	/*Aquí se hace la validación del usuario de conexión para evitar ping-pong*/
	IF NOT ('SoftlandSync' = @USUARIO_ACTUAL)
	BEGIN
		DECLARE C_DELETED CURSOR LOCAL FOR
			SELECT PAQUETE, TIENDA
			FROM DELETED d

		OPEN C_DELETED
		FETCH NEXT FROM C_DELETED INTO 
		@PAQUETE, @TIENDA
		
		SET @ERROR = 0
		
		WHILE @@FETCH_STATUS = 0 AND @ERROR = 0
		BEGIN
			SET @SENTENCIA = 'DELETE FROM $$COMPANIA$$.' + @NOMBRETABLA + ' WHERE PAQUETE = ''' + @PAQUETE + ''' AND TIENDA = ''' + @TIENDA + ''''
			
			EXECUTE @ERROR = $$COMPANIA$$.POS_INSERTA_ELIMINACION @SENTENCIA, @NOMBRETABLA
			
			FETCH NEXT FROM C_DELETED INTO 
			@PAQUETE, @TIENDA
		END

		CLOSE C_DELETED
		DEALLOCATE C_DELETED
	END
	
	IF (@@ERROR <> 0) 
	BEGIN
		RAISERROR( 'Error generando la sentencia de eliminación de la tabla DES_BON_PAQUETE_TIENDA.',16,1 )
	END
END
;


CREATE TRIGGER $$COMPANIA$$.DES_BON_REGLA_POS_SINC_DEL
ON $$COMPANIA$$.DES_BON_REGLA
FOR DELETE  
AS 
BEGIN   	
   	DECLARE @ERROR INT
	DECLARE @SENTENCIA   		VARCHAR(254)
	DECLARE @NOMBRETABLA		VARCHAR(254)
	DECLARE @USUARIO_ACTUAL		VARCHAR(30)

	DECLARE @REGLA VARCHAR(20)
	
	SET @NOMBRETABLA = 'DES_BON_REGLA'

	EXEC ERPADMIN.LeerUsuarioActual @USUARIO_ACTUAL OUTPUT

	/*Aquí se hace la validación del usuario de conexión para evitar ping-pong*/
	IF NOT ('SoftlandSync' = @USUARIO_ACTUAL)
	BEGIN
		DECLARE C_DELETED CURSOR LOCAL FOR
			SELECT REGLA
			FROM DELETED d
			
		OPEN C_DELETED
		FETCH NEXT FROM C_DELETED INTO 
		@REGLA
		
		SET @ERROR = 0
		
		WHILE @@FETCH_STATUS = 0 AND @ERROR = 0
		BEGIN
			SET @SENTENCIA = 'DELETE FROM $$COMPANIA$$.' + @NOMBRETABLA + ' WHERE REGLA = ''' + @REGLA  + ''''
			
			EXECUTE @ERROR = $$COMPANIA$$.POS_INSERTA_ELIMINACION @SENTENCIA, @NOMBRETABLA
			
			FETCH NEXT FROM C_DELETED INTO 
			@REGLA
		END

		CLOSE C_DELETED
		DEALLOCATE C_DELETED
	END
	
	IF (@@ERROR <> 0) 
	BEGIN
		RAISERROR( 'Error generando la sentencia de eliminación de la tabla DES_BON_REGLA.',16,1 )
	END
END
;



CREATE TRIGGER $$COMPANIA$$.DES_BON_REG_LOTE_POS_SINC_DEL
ON $$COMPANIA$$.DES_BON_REGLA_LOTE
FOR DELETE  
AS 
BEGIN   	
	DECLARE @ERROR INT
	DECLARE @SENTENCIA   		VARCHAR(254)
	DECLARE @NOMBRETABLA		VARCHAR(254)
	DECLARE @USUARIO_ACTUAL		VARCHAR(30)

	DECLARE @REGLA VARCHAR(20)
	DECLARE @LINEA_REGLA INT
	
	SET @NOMBRETABLA = 'DES_BON_REGLA_LOTE'

	EXEC ERPADMIN.LeerUsuarioActual @USUARIO_ACTUAL OUTPUT

	/*Aquí se hace la validación del usuario de conexión para evitar ping-pong*/
	IF NOT ('SoftlandSync' = @USUARIO_ACTUAL)
	BEGIN
		DECLARE C_DELETED CURSOR LOCAL FOR
			SELECT REGLA, LINEA_REGLA
			FROM DELETED d

		OPEN C_DELETED
		FETCH NEXT FROM C_DELETED INTO 
		@REGLA, @LINEA_REGLA
		
		SET @ERROR = 0
		
		WHILE @@FETCH_STATUS = 0 AND @ERROR = 0
		BEGIN
			SET @SENTENCIA = 'DELETE FROM $$COMPANIA$$.' + @NOMBRETABLA + ' WHERE REGLA = ''' + @REGLA + ''' AND LINEA_REGLA = ''' + CONVERT(VARCHAR(36),@LINEA_REGLA)  + ''''
			
			EXECUTE @ERROR = $$COMPANIA$$.POS_INSERTA_ELIMINACION @SENTENCIA, @NOMBRETABLA
			
			FETCH NEXT FROM C_DELETED INTO 
			@REGLA, @LINEA_REGLA
		END

		CLOSE C_DELETED
		DEALLOCATE C_DELETED
	END
	
	IF (@@ERROR <> 0) 
	BEGIN
		RAISERROR( 'Error generando la sentencia de eliminación de la tabla DES_BON_REGLA_LOTE.',16,1 )
	END
END
;





CREATE TRIGGER $$COMPANIA$$.ARTICULO_ENS_POS_SINC_DEL
ON $$COMPANIA$$.ARTICULO_ENSAMBLE
FOR DELETE  
AS 
BEGIN   	
	DECLARE @ERROR INT
	DECLARE @SENTENCIA   		VARCHAR(254)
	DECLARE @NOMBRETABLA		VARCHAR(254)
	DECLARE @USUARIO_ACTUAL		VARCHAR(30)

	DECLARE @ARTICULO_PADRE VARCHAR(20)
	DECLARE @ARTICULO_HIJO VARCHAR(20)

	SET @NOMBRETABLA = 'ARTICULO_ENSAMBLE'

	EXEC ERPADMIN.LeerUsuarioActual @USUARIO_ACTUAL OUTPUT

	/*Aquí se hace la validación del usuario de conexión para evitar ping-pong*/
	IF NOT ('SoftlandSync' = @USUARIO_ACTUAL)
	BEGIN
		DECLARE C_DELETED CURSOR LOCAL FOR
			SELECT ARTICULO_PADRE, ARTICULO_HIJO
			FROM DELETED d

		OPEN C_DELETED
		FETCH NEXT FROM C_DELETED INTO 
		@ARTICULO_PADRE, @ARTICULO_HIJO
		
		SET @ERROR = 0
		
		WHILE @@FETCH_STATUS = 0 AND @ERROR = 0
		BEGIN
			SET @SENTENCIA = 'DELETE FROM $$COMPANIA$$.' + @NOMBRETABLA + ' WHERE ARTICULO_PADRE = ''' + @ARTICULO_PADRE + ''' AND ARTICULO_HIJO = ''' + @ARTICULO_HIJO + ''''
			
			EXECUTE @ERROR = $$COMPANIA$$.POS_INSERTA_ELIMINACION @SENTENCIA, @NOMBRETABLA
			
			FETCH NEXT FROM C_DELETED INTO 
			@ARTICULO_PADRE, @ARTICULO_HIJO
		END

		CLOSE C_DELETED
		DEALLOCATE C_DELETED
	END
	
	IF (@@ERROR <> 0) 
	BEGIN
		RAISERROR( 'Error generando la sentencia de eliminación de la tabla ARTICULO_ENSAMBLE.',16,1 )
	END
END;

CREATE FUNCTION  $$COMPANIA$$.INFO_DETALLE_RETENCION_CC(@DOCUMENTO VARCHAR(50), @TIPO VARCHAR(2))
RETURNS TABLE
AS 
RETURN
(
	SELECT	RET.CODIGO_RETENCION AS RETENCION,
			DOCUMENTO AS FACTURA,
			'1' AS FACTURA_LINEA,
			'00001' AS ARTICULO,
			BASE AS BASE_RETENCION,
			RET.PORCENTAJE AS PORC_RETENCION,
			MONTO AS MONTO_RETENCION,
			ISNULL(RET.U_IMPUESTO_SAT, '000') AS IMPUESTO,
			'Tasa' AS TIPO_FACTOR
	FROM	$$COMPANIA$$.RETENCIONES_DOC_CC RETCC
			INNER JOIN  $$COMPANIA$$.RETENCIONES RET
			ON RETCC.CODIGO_RETENCION = RET.CODIGO_RETENCION
	WHERE RETCC.DOCUMENTO = @DOCUMENTO
	AND @TIPO =(CASE RETCC.TIPO WHEN 'FAC' THEN 'F' WHEN 'N/C' THEN 'D' WHEN 'N/D' THEN 'ND' END)
	AND RETCC.ESTADO = 'A'
	AND RETCC.BASE > 0
	AND 0 = ( SELECT COUNT(*) FROM  $$COMPANIA$$.FACTURA FAC WHERE FAC.FACTURA = @DOCUMENTO AND FAC.TIPO_DOCUMENTO = @TIPO)
);

CREATE FUNCTION  $$COMPANIA$$.INFO_DETALLE_RETENCION_FA(@DOCUMENTO VARCHAR(50), @TIPO VARCHAR(2))
RETURNS @RETENCION TABLE( RETENCION VARCHAR(4),
						  FACTURA   VARCHAR(50),
						  FACTURA_LINEA INT,
						  ARTICULO  VARCHAR(20),
						  BASE_RETENCION DECIMAL(28,8),
						  PORC_RETENCION DECIMAL(28,8),
						  MONTO_RETENCION DECIMAL(28,8),
						  IMPUESTO	VARCHAR(3),
						  TIPO_FACTOR VARCHAR(6) ) 
AS BEGIN
	--VARIABLES
	DECLARE @RETENCION_EXIST INT,
			@LINEA_FL INT,
			@ARTICULO_FL VARCHAR(20),
			@IMPUESTO1_FL DECIMAL(28,8),
			@IMPUESTO2_FL DECIMAL(28,8),
			@COD_RETENCION_FR VARCHAR(4),
			@APLICA_RET_CLIENTE INT,
			@APLICA_RET_ARTICULO INT,
			@MONTO_BASE DECIMAL(28,8),
			@PORCENTAJE_R DECIMAL(28,8),
			@APLICA_MONTO_R VARCHAR(1), 
			@APLICA_SUBTOTAL_R VARCHAR(1),
			@APLICA_SUB_DESC_R VARCHAR(1),
			@APLICA_IMPUESTO1_R VARCHAR(1),
			@APLICA_IMPUESTO2_R VARCHAR(1),
			@APLICA_RUBRO1_R VARCHAR(1),
			@APLICA_RUBRO2_R VARCHAR(1),
			@MONTO_MINIMO_R DECIMAL(28,8),
			@IMPUESTO_R VARCHAR(3),
			@PRECIO_TOTAL_FL DECIMAL(28,8),
			@DESC_GENERAL1_F DECIMAL(28,8),
			@DESC_GENERAL2_F DECIMAL(28,8),
			@DESC_LINEA_FL DECIMAL(28,8),
			@DESC_VOLUMEN_F DECIMAL(28,8),
			@MONTO_RETENCION DECIMAL(28,8),
			@PAIS_CIA VARCHAR(20),
			@MONTO_FLETE_F DECIMAL(28,8),
			@MONTO_SEGURO_F DECIMAL(28,8),
			@MONTO_DOCUMENTACION_F DECIMAL(28,8),
			@CLIENTE_F VARCHAR(20),
			@EXEP_REGIMEN_EXIST INT,
			@EXEP_REGION_EXIST INT,
			@PAIS_F VARCHAR(4),
			@DIVI_GEO1_F VARCHAR(12),
			@DIVI_GEO2_F VARCHAR(12),
			@RET_CALCULADA INT

	SET		@RETENCION_EXIST = 0
	SET		@APLICA_RET_CLIENTE = 0
	SET		@APLICA_RET_ARTICULO = 0
	SET		@MONTO_BASE = 0
	SET		@PAIS_CIA = ''
	SET		@MONTO_FLETE_F= 0
	SET		@MONTO_SEGURO_F = 0
	SET		@MONTO_DOCUMENTACION_F = 0
	SET		@DESC_GENERAL1_F = 0
	SET		@DESC_GENERAL2_F = 0
	SET		@DESC_VOLUMEN_F = 0
	SET		@EXEP_REGIMEN_EXIST = 0
	SET		@EXEP_REGION_EXIST = 0
	SET		@RET_CALCULADA = 0

	--SE VALIDA SI EL DOCUMENTO TIENE RETENCION ASOCIADA
	SELECT @RETENCION_EXIST = COUNT(*) FROM  $$COMPANIA$$.FACTURA_RETENCION WHERE FACTURA = @DOCUMENTO AND TIPO_DOCUMENTO = @TIPO
	IF(@RETENCION_EXIST >= 1)
	BEGIN
		--SE LEE DATOS DE LA FACTURA
		SELECT	@MONTO_FLETE_F = MONTO_FLETE, @MONTO_SEGURO_F = MONTO_SEGURO, @MONTO_DOCUMENTACION_F = MONTO_DOCUMENTACIO, @DESC_GENERAL1_F = MONTO_DESCUENTO1,
				@DESC_GENERAL2_F = MONTO_DESCUENTO2, @DESC_VOLUMEN_F = DESCUENTO_VOLUMEN, @CLIENTE_F = CLIENTE, @PAIS_F = PAIS, @DIVI_GEO1_F = DIVISION_GEOGRAFICA1,
				@DIVI_GEO2_F = DIVISION_GEOGRAFICA2
		FROM  $$COMPANIA$$.FACTURA WHERE FACTURA = @DOCUMENTO AND TIPO_DOCUMENTO = @TIPO

		--SI EXISTE LA RETENCION SE PROCEDE A LEER LOS MONTOS CALCULADOS PARA LA FACTURA
		DECLARE CUR_FACRETENCION CURSOR FOR SELECT CODIGO_RETENCION FROM  $$COMPANIA$$.FACTURA_RETENCION WHERE FACTURA = @DOCUMENTO AND TIPO_DOCUMENTO = @TIPO
		OPEN CUR_FACRETENCION
		FETCH NEXT FROM CUR_FACRETENCION INTO @COD_RETENCION_FR
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--SE LEE LA CONFIGURACION DE LA RETENCION
			DECLARE CUR_RETENCION CURSOR FOR SELECT PORCENTAJE, APLICA_MONTO, APLICA_SUBTOTAL, APLICA_SUB_DESC, APLICA_IMPUESTO1, APLICA_IMPUESTO2, APLICA_RUBRO1, APLICA_RUBRO2, MONTO_MINIMO, U_IMPUESTO_SAT  
											 FROM    $$COMPANIA$$.RETENCIONES
											 WHERE  CODIGO_RETENCION = @COD_RETENCION_FR
			OPEN CUR_RETENCION 
			FETCH NEXT FROM CUR_RETENCION INTO @PORCENTAJE_R, @APLICA_MONTO_R, @APLICA_SUBTOTAL_R, @APLICA_SUB_DESC_R, @APLICA_IMPUESTO1_R, @APLICA_IMPUESTO2_R, @APLICA_RUBRO1_R, @APLICA_RUBRO2_R, @MONTO_MINIMO_R, @IMPUESTO_R
			IF(@@FETCH_STATUS = 0)
			BEGIN
				--SI SE LEYO LA CONFIGURACION DE LA RETENCION SE PROCEDE A CALCULAR PARA LAS LINEAS DE LA FACTURA
				--SE LEE EL CLIENTE DE LA FACTURA 
				SELECT @APLICA_RET_CLIENTE = COUNT(*) FROM  $$COMPANIA$$.CLIENTE_RETENCION WHERE CLIENTE = @CLIENTE_F AND CODIGO_RETENCION = @COD_RETENCION_FR
				
				SET @RET_CALCULADA = 0

				--SE LEE LAS LÍNEAS DE LA FACTURA
				DECLARE CUR_FACTURA_LINEA CURSOR FOR SELECT LINEA, ARTICULO, TOTAL_IMPUESTO1, TOTAL_IMPUESTO2, PRECIO_TOTAL, DESC_TOT_LINEA FROM  $$COMPANIA$$.FACTURA_LINEA WHERE FACTURA = @DOCUMENTO AND TIPO_DOCUMENTO = @TIPO
				OPEN CUR_FACTURA_LINEA
				FETCH NEXT FROM CUR_FACTURA_LINEA INTO @LINEA_FL, @ARTICULO_FL, @IMPUESTO1_FL, @IMPUESTO2_FL, @PRECIO_TOTAL_FL, @DESC_LINEA_FL
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @MONTO_BASE = 0
					--SE REALIZAN VALIDACIONES PARA DETERMINAR SI PARA LA LINEA SE DEBE CALCULAR EL MONTO DE LA RETENCION
					IF(@IMPUESTO1_FL > 0)
					BEGIN
						SELECT @APLICA_RET_ARTICULO = COUNT(*) FROM  $$COMPANIA$$.ARTICULO WHERE ARTICULO = @ARTICULO_FL AND RETENCION_VENTA = @COD_RETENCION_FR
						IF(@APLICA_RET_ARTICULO <= 0)
						BEGIN
							SELECT	@APLICA_RET_ARTICULO = COUNT(*)
							FROM	 $$COMPANIA$$.retenciones ret,  $$COMPANIA$$.articulo art,  $$COMPANIA$$.det_mod_retencion dmr,  $$COMPANIA$$.cliente cli,  $$COMPANIA$$.excep_regimen exr,  $$COMPANIA$$.regimenes reg
							WHERE 	art.articulo = @ARTICULO_FL AND ret.estado = 'A' AND ret.codigo_retencion = @COD_RETENCION_FR AND art.modelo_retencion = dmr.modelo_retencion
							AND		ret.codigo_retencion = dmr.codigo_retencion AND dmr.aplica IN (  'A',  'V' ) AND cli.cliente = @CLIENTE_F AND cli.regimen_trib = reg.regimen
							AND		exr.codigo = reg.regimen AND exr.codigo_retencion = ret.codigo_retencion
						END
						--SE VALIDA SI SE DEBE APLICAR LA RETENCION A LA LINEA
						IF(@APLICA_RET_ARTICULO > 0 OR @APLICA_RET_CLIENTE > 0)
						BEGIN					
							SET @RET_CALCULADA = 1
													
							--REVISAR SI EXISTEN EXEPCIONES POR REGIMEN O POR DIVISION GEOGRAFICA
							--POR REGIMEN
							SELECT @EXEP_REGIMEN_EXIST = COUNT(*) FROM  $$COMPANIA$$.EXCEP_REGIMEN WHERE CODIGO_RETENCION = @COD_RETENCION_FR AND CODIGO = (SELECT REGIMEN_TRIB FROM  $$COMPANIA$$.CLIENTE WHERE CLIENTE = @CLIENTE_F)
							--POR DIVISION GEOGRAFICA
							SELECT @EXEP_REGION_EXIST = COUNT(*) FROM  $$COMPANIA$$.EXCEP_CIUDAD WHERE PAIS = @PAIS_F AND DIVISION_GEOGRAFICA1 = @DIVI_GEO1_F AND DIVISION_GEOGRAFICA2 = @DIVI_GEO2_F
							IF(@EXEP_REGION_EXIST>=1)
							BEGIN
								SET @PORCENTAJE_R = (SELECT PORCENTAJE FROM  $$COMPANIA$$.EXCEP_CIUDAD WHERE PAIS = @PAIS_F AND DIVISION_GEOGRAFICA1 = @DIVI_GEO1_F AND DIVISION_GEOGRAFICA2 = @DIVI_GEO2_F)
							END
							IF(@EXEP_REGIMEN_EXIST>=1)
							BEGIN
								SET @PORCENTAJE_R = (SELECT PORCENTAJE FROM  $$COMPANIA$$.EXCEP_REGIMEN WHERE CODIGO_RETENCION = @COD_RETENCION_FR AND CODIGO = (SELECT REGIMEN_TRIB FROM  $$COMPANIA$$.CLIENTE WHERE CLIENTE = @CLIENTE_F))
							END

							IF(@APLICA_MONTO_R = 'S')
								SET @MONTO_BASE = @PRECIO_TOTAL_FL + @IMPUESTO1_FL + @IMPUESTO2_FL + @MONTO_FLETE_F + @MONTO_SEGURO_F + @MONTO_DOCUMENTACION_F
							IF(@APLICA_SUBTOTAL_R = 'S')
								SET @MONTO_BASE = @MONTO_BASE + @PRECIO_TOTAL_FL
							IF(@APLICA_SUB_DESC_R = 'S')
								SET @MONTO_BASE = @MONTO_BASE + @PRECIO_TOTAL_FL - @DESC_GENERAL1_F - @DESC_GENERAL2_F - @DESC_VOLUMEN_F
							IF(@APLICA_IMPUESTO1_R = 'S') 
								SET @MONTO_BASE = @MONTO_BASE + @IMPUESTO1_FL
							IF(@APLICA_IMPUESTO2_R = 'S')
								SET @MONTO_BASE = @MONTO_BASE + @IMPUESTO2_FL
							IF(@APLICA_RUBRO1_R = 'S')
								SET @MONTO_BASE = @MONTO_BASE + @MONTO_FLETE_F
							IF(@APLICA_RUBRO2_R = 'S')
								SET @MONTO_BASE = @MONTO_BASE + @MONTO_SEGURO_F + @MONTO_DOCUMENTACION_F

							SELECT @PAIS_CIA = PAIS FROM ERPADMIN.CONJUNTO WHERE CONJUNTO = ' $$COMPANIA$$'

							IF (@PAIS_CIA = 'COLOMBIA' AND @PORCENTAJE_R < 1)
							BEGIN
								SET @MONTO_RETENCION = ROUND(@MONTO_BASE * @PORCENTAJE_R, 2)
							END
							ELSE
							BEGIN
								SET @MONTO_RETENCION = ROUND(@MONTO_BASE * @PORCENTAJE_R / 100, 2)
							END

							SET @MONTO_BASE = ROUND(@MONTO_BASE, 2)
							INSERT INTO @RETENCION(RETENCION, FACTURA, FACTURA_LINEA, ARTICULO, BASE_RETENCION, PORC_RETENCION, MONTO_RETENCION, IMPUESTO, TIPO_FACTOR)
							VALUES(@COD_RETENCION_FR, @DOCUMENTO, @LINEA_FL, @ARTICULO_FL, @MONTO_BASE, @PORCENTAJE_R, @MONTO_RETENCION, @IMPUESTO_R, 'Tasa')
						END
					END

					FETCH NEXT FROM CUR_FACTURA_LINEA INTO @LINEA_FL, @ARTICULO_FL, @IMPUESTO1_FL, @IMPUESTO2_FL, @PRECIO_TOTAL_FL, @DESC_LINEA_FL
				END
				CLOSE CUR_FACTURA_LINEA
				DEALLOCATE CUR_FACTURA_LINEA
				IF(@RET_CALCULADA = 0)
				BEGIN
					--SI LA RETENCION NO FUE CALCULADA SE DISTRIBUYE EL MONTO ENTRE LAS LÍNEAS DE LA FACTURA
					DECLARE @CANT_LINEAS INT,
							@MONTO_X_LINEA DECIMAL(28,8)
							
					SET @CANT_LINEAS = 0
					SET	@MONTO_X_LINEA = 0
					
					SELECT @CANT_LINEAS = COUNT(*) FROM  $$COMPANIA$$.FACTURA_LINEA WHERE FACTURA = @DOCUMENTO AND TIPO_DOCUMENTO = @TIPO AND TOTAL_IMPUESTO1 > 0
					IF(@CANT_LINEAS > 0)
					BEGIN
						--SE DISTRIBUYE EL MONTO DE LA RETENCION
						SET @MONTO_X_LINEA = (SELECT MONTO FROM  $$COMPANIA$$.FACTURA_RETENCION WHERE FACTURA = @DOCUMENTO AND TIPO_DOCUMENTO = @TIPO AND CODIGO_RETENCION = @COD_RETENCION_FR)
						SET @MONTO_BASE = (SELECT BASE FROM  $$COMPANIA$$.FACTURA_RETENCION WHERE FACTURA = @DOCUMENTO AND TIPO_DOCUMENTO = @TIPO AND CODIGO_RETENCION = @COD_RETENCION_FR)
						SET @PORCENTAJE_R = @MONTO_X_LINEA / @MONTO_BASE
						SET @MONTO_X_LINEA = @MONTO_X_LINEA / @CANT_LINEAS
						SET @MONTO_BASE = @MONTO_BASE / @CANT_LINEAS

						IF(@MONTO_X_LINEA > 0)
						BEGIN
							--SE LEE LAS LÍNEAS DE LA FACTURA
							DECLARE CUR_FACTURA_LINEA CURSOR FOR SELECT LINEA, ARTICULO, TOTAL_IMPUESTO1, TOTAL_IMPUESTO2, PRECIO_TOTAL, DESC_TOT_LINEA FROM  $$COMPANIA$$.FACTURA_LINEA WHERE FACTURA = @DOCUMENTO AND TIPO_DOCUMENTO = @TIPO
							OPEN CUR_FACTURA_LINEA
							FETCH NEXT FROM CUR_FACTURA_LINEA INTO @LINEA_FL, @ARTICULO_FL, @IMPUESTO1_FL, @IMPUESTO2_FL, @PRECIO_TOTAL_FL, @DESC_LINEA_FL
							WHILE @@FETCH_STATUS = 0
							BEGIN
								SET @MONTO_BASE = ROUND(@MONTO_BASE, 2)
								SET @PORCENTAJE_R = ROUND(@PORCENTAJE_R, 2)
								SET @MONTO_X_LINEA = ROUND(@MONTO_X_LINEA, 2)

								SET @MONTO_BASE = ROUND(@MONTO_BASE, 2)
								INSERT INTO @RETENCION(RETENCION, FACTURA, FACTURA_LINEA, ARTICULO, BASE_RETENCION, PORC_RETENCION, MONTO_RETENCION, IMPUESTO, TIPO_FACTOR)
								VALUES(@COD_RETENCION_FR, @DOCUMENTO, @LINEA_FL, @ARTICULO_FL, @MONTO_BASE, @PORCENTAJE_R, @MONTO_X_LINEA, @IMPUESTO_R, 'Tasa')
								
								FETCH NEXT FROM CUR_FACTURA_LINEA INTO @LINEA_FL, @ARTICULO_FL, @IMPUESTO1_FL, @IMPUESTO2_FL, @PRECIO_TOTAL_FL, @DESC_LINEA_FL
							END
						CLOSE CUR_FACTURA_LINEA
						DEALLOCATE CUR_FACTURA_LINEA
						END
					END
				END
			END
			CLOSE CUR_RETENCION
			DEALLOCATE CUR_RETENCION
			--SE AVANZA EL CURSOR
			FETCH NEXT FROM CUR_FACRETENCION INTO @COD_RETENCION_FR
		END
		CLOSE CUR_FACRETENCION
		DEALLOCATE CUR_FACRETENCION
	END
	RETURN
END;

CREATE FUNCTION  $$COMPANIA$$.FACTURA_LINEA_RETENCION_XML(@FACTURA VARCHAR(50), @TIPO VARCHAR(2))
RETURNS XML
AS
BEGIN
	DECLARE @XMLRETENCIONLINEA XML
  
	SET @XMLRETENCIONLINEA = (  SELECT * FROM
								(
								SELECT RETENCION, FACTURA, FACTURA_LINEA, ARTICULO, BASE_RETENCION, PORC_RETENCION, MONTO_RETENCION, TIPO_FACTOR, IMPUESTO FROM  $$COMPANIA$$.INFO_DETALLE_RETENCION_FA(@FACTURA,@TIPO)
								UNION
								SELECT RETENCION, FACTURA, FACTURA_LINEA, ARTICULO, BASE_RETENCION, PORC_RETENCION, MONTO_RETENCION, TIPO_FACTOR, IMPUESTO FROM  $$COMPANIA$$.INFO_DETALLE_RETENCION_CC(@FACTURA,@TIPO)
								)RETENCION
	FOR XML RAW ('RETENCION_LINEA'), ROOT('RETENCIONES'), ELEMENTS)
	RETURN @XMLRETENCIONLINEA
END;


CREATE VIEW $$COMPANIA$$.V_DOCUMENTO_ELECTRONICO_PAGO
AS 
 SELECT	D.TIPO  AS TIPODOCUMENTO, 
		D.DOCUMENTO AS FACTURA, 
		D.ANULADO AS ANULADA,
		D.CLIENTE AS CLIENTE,
		DOCELECTPROC.ESTADO AS ESTADO, 
		D.MONTO AS TOTALFACTURA,
		D.SALDO,
		(	SELECT	SUM(MONTO) 
		FROM (	SELECT	D.MONTO AS MONTO 
				FROM	$$COMPANIA$$.DOCUMENTOS_CC 
				WHERE	DOCUMENTO=D.DOCUMENTO 
				AND		TIPO = D.TIPO
				UNION ALL
				SELECT	- (MONTO) AS MONTO 
				FROM	$$COMPANIA$$.RETENCIONES_DOC_CC 
				WHERE	DOCUMENTO=D.DOCUMENTO
				AND		TIPO = D.TIPO
			) AS T
		) AS TOTALFACTURARETENCION,
		D.FECHA AS FECHA, 
		'L' AS MONEDAFACTURA, 
		CONVERT(CHAR(36),LOWER(D.ROWPOINTER)) AS ROWPOINTER,
		'DOCUMENTOS_CC' AS TABLA,
		D.RECORDDATE,
		D.CREATEDBY,
		D.UPDATEDBY,
		D.CREATEDATE,
		DOCELECTPROC.FOLIO_SAT AS FOLIOSAT,
		ISNULL(DOCELECTPROC.ENVIADO,'N') AS ENVIADO,
		DOCELECTPROC.NIT_EMISOR AS NIT_EMISOR,
		DOCELECTPROC.NIT_RECEPTOR AS NIT_RECEPTOR,
		ISNULL(DOCELECTPROC.ACEPTADO,'N') AS ACEPTADO,
		DOCELECTPROC.ACEPTACION_RECHAZO AS ACEPTACION_RECHAZO,
		DOCELECTPROC.DOCUMENTO_ELECTRONICO AS DOCUMENTO_ELECTRONICO,
		DOCELECTPROC.NOMBRE_PDF AS NOMBRE_PDF,
		DOCELECTPROC.NOMBRE_XML AS NOMBRE_XML,
		DOCELECTPROC.ESTADO_CARTA_PORTE AS ESTADO_CARTA_PORTE,
		DOCELECTPROC.GENERA_CARTA_PORTE AS GENERA_CARTA_PORTE,
		DOCELECTPROC.ERROR_WS AS ERROR_WS,
		DOCELECTPROC.ERROR_SOFTLAND AS ERROR_SOFTLAND,
		D.DOCUMENTO_FISCAL AS DOCUMENTO_FISCAL,
		DOCELECTPROC.FIRMA_DOCUMENTO AS FIRMA_GT,
		DOCELECTPROC.GUUID_GT AS GUUID_GT
 FROM	$$COMPANIA$$.DOCUMENTOS_CC D
		LEFT JOIN $$COMPANIA$$.AUXILIAR_CC ACC ON D.DOCUMENTO = ACC.CREDITO AND D.TIPO = ACC.TIPO_CREDITO
		LEFT OUTER JOIN $$COMPANIA$$.DOC_ELECTRONICO_PROCESADO DOCELECTPROC 
		ON DOCELECTPROC.TIPO_DOC =  D.TIPO 
		AND DOCELECTPROC.NUMERO_DOC = D.DOCUMENTO 
 WHERE	D.TIPO IN ('REC','TEF','DEP') 
 AND	D.GENERA_DOC_FE = 'S'
 AND 1 <= ( SELECT COUNT(1) FROM $$COMPANIA$$.DOCUMENTOS_CC DCC 
INNER JOIN $$COMPANIA$$.CONDICION_PAGO CP ON DCC.CONDICION_PAGO = CP.CONDICION_PAGO
 WHERE DCC.DOCUMENTO = ACC.DEBITO AND DCC.TIPO = ACC.TIPO_DEBITO AND CP.U_METODO_PAGO != 'PUE' );



CREATE FUNCTION $$COMPANIA$$.INFO_DIRECCION_EMBARQUE_PAGO_XML (@DOCUMENTO VARCHAR(50), @TIPO VARCHAR(3))
RETURNS TABLE
AS
RETURN (
	 SELECT
	 ISNULL(DE.DIRECCION, 'CAMPO EN BLANCO') AS DIRECCION,
	 ISNULL(DE.CONTACTO,  'CAMPO EN BLANCO') AS CONTACTO,
	 ISNULL(DE.CARGO,	  'CAMPO EN BLANCO') AS CARGO,
	 ISNULL(DE.TELEFONO1, 'CAMPO EN BLANCO') AS TELEFONO1,
	 ISNULL(DE.TELEFONO2, 'CAMPO EN BLANCO') AS TELEFONO2,
	 ISNULL(DE.FAX,		  'CAMPO EN BLANCO') AS FAX,
	 ISNULL(DE.EMAIL,	  'CAMPO EN BLANCO') AS EMAIL,
	 ISNULL(DD.CAMPO_1,   'CAMPO EN BLANCO') AS DIREC_CAMPO_1,
	 ISNULL(DD.CAMPO_2,   'CAMPO EN BLANCO') AS DIREC_CAMPO_2,
	 ISNULL(DD.CAMPO_3,   'CAMPO EN BLANCO') AS DIREC_CAMPO_3,
	 ISNULL(DD.CAMPO_4,   'CAMPO EN BLANCO') AS DIREC_CAMPO_4,
	 ISNULL(DD.CAMPO_5,   'CAMPO EN BLANCO') AS DIREC_CAMPO_5,
	 ISNULL(DD.CAMPO_6,   'CAMPO EN BLANCO') AS DIREC_CAMPO_6,
	 ISNULL(DD.CAMPO_7,   'CAMPO EN BLANCO') AS DIREC_CAMPO_7,
	 ISNULL(DD.CAMPO_8,   'CAMPO EN BLANCO') AS DIREC_CAMPO_8,
	 ISNULL(DD.CAMPO_9,   'CAMPO EN BLANCO') AS DIREC_CAMPO_9,
	 ISNULL(DD.CAMPO_10,  'CAMPO EN BLANCO') AS DIREC_CAMPO_10
	 FROM $$COMPANIA$$.DOCUMENTOS_CC DCC
	 INNER JOIN $$COMPANIA$$.CLIENTE C ON DCC.CLIENTE = C.CLIENTE
	 LEFT JOIN $$COMPANIA$$.DIRECC_EMBARQUE DE ON C.CLIENTE = DE.CLIENTE AND C.DIR_EMB_DEFAULT = DE.DIRECCION
	 LEFT JOIN $$COMPANIA$$.DETALLE_DIRECCION DD ON DE.DETALLE_DIRECCION = DD.DETALLE_DIRECCION
	 WHERE DCC.DOCUMENTO = @DOCUMENTO 
	 AND @TIPO = DCC.TIPO 
);



CREATE FUNCTION $$COMPANIA$$.DIRECCION_EMBARQUE_PAGO_XML (@DOCUMENTO VARCHAR(50), @TIPO VARCHAR(3))
RETURNS XML
AS
BEGIN
	DECLARE @XMLDIRECCIONEMBARQUE XML
  
	SET @XMLDIRECCIONEMBARQUE = ( SELECT * FROM $$COMPANIA$$.INFO_DIRECCION_EMBARQUE_PAGO_XML(@DOCUMENTO, @TIPO )
	FOR XML RAW ('DIRECCION_EMBARQUE'), ELEMENTS)
	RETURN @XMLDIRECCIONEMBARQUE
END;



CREATE FUNCTION $$COMPANIA$$.INFO_DIRECCION_CLIENTE_PAGO_XML (@DOCUMENTO VARCHAR(50), @TIPO VARCHAR(3))
RETURNS TABLE
AS
RETURN (
	SELECT
	ISNULL(DD.CAMPO_1, 'CAMPO EN BLANCO') AS DIREC_CAMPO_1,
	ISNULL(DD.CAMPO_2, 'CAMPO EN BLANCO') AS DIREC_CAMPO_2,
	ISNULL(DD.CAMPO_3, 'CAMPO EN BLANCO') AS DIREC_CAMPO_3,
	ISNULL(DD.CAMPO_4, 'CAMPO EN BLANCO') AS DIREC_CAMPO_4,
	ISNULL(DD.CAMPO_5, 'CAMPO EN BLANCO') AS DIREC_CAMPO_5,
	ISNULL(DD.CAMPO_6, 'CAMPO EN BLANCO') AS DIREC_CAMPO_6,
	ISNULL(DD.CAMPO_7, 'CAMPO EN BLANCO') AS DIREC_CAMPO_7,
	ISNULL(DD.CAMPO_8, 'CAMPO EN BLANCO') AS DIREC_CAMPO_8,
	ISNULL(DD.CAMPO_9, 'CAMPO EN BLANCO') AS DIREC_CAMPO_9,
	ISNULL(DD.CAMPO_10,'CAMPO EN BLANCO') AS DIREC_CAMPO_10,
	ISNULL(DE.FAX,	   'CAMPO EN BLANCO') AS DD_FAX,
	ISNULL(DE.DIRECCION,'CAMPO EN BLANCO') AS DD_DIRECCION
	FROM $$COMPANIA$$.DOCUMENTOS_CC DCC
	INNER JOIN $$COMPANIA$$.CLIENTE C ON DCC.CLIENTE = C.CLIENTE
	INNER JOIN $$COMPANIA$$.DETALLE_DIRECCION DD ON C.DETALLE_DIRECCION = DD.DETALLE_DIRECCION
	LEFT JOIN $$COMPANIA$$.DIRECC_EMBARQUE DE ON DD.DETALLE_DIRECCION = DE.DETALLE_DIRECCION
	WHERE  DCC.DOCUMENTO = @DOCUMENTO 
	AND @TIPO = DCC.TIPO 
);



CREATE FUNCTION $$COMPANIA$$.DIRECCION_CLIENTE_PAGO_XML (@DOCUMENTO VARCHAR(50), @TIPO VARCHAR(3))
RETURNS XML
AS
BEGIN
	DECLARE @XMLDIRECCIONCLIENTE XML
  
	SET @XMLDIRECCIONCLIENTE = ( SELECT * FROM $$COMPANIA$$.INFO_DIRECCION_CLIENTE_PAGO_XML(@DOCUMENTO, @TIPO )
	FOR XML RAW ('DIRECCION_CLIENTE'), ELEMENTS)
	RETURN @XMLDIRECCIONCLIENTE
END;


CREATE FUNCTION $$COMPANIA$$.INFO_CLIENTE_PAGO_XML (@DOCUMENTO VARCHAR(50), @TIPO VARCHAR(3))
RETURNS TABLE
AS
RETURN (
	SELECT
	DCC.CLIENTE,
	C.NOMBRE,
	C.DETALLE_DIRECCION,
	C.ALIAS,
	C.CONTACTO,
	C.CARGO,
	C.DIRECCION,
	C.DIR_EMB_DEFAULT,
	C.TELEFONO1,
	C.TELEFONO2,
	C.FAX,
	C.CONTRIBUYENTE,
	C.FECHA_INGRESO,
	C.MULTIMONEDA,
	C.MONEDA,
	C.SALDO,
	C.SALDO_LOCAL,
	C.SALDO_DOLAR,
	C.SALDO_CREDITO,
	C.SALDO_NOCARGOS,
	C.LIMITE_CREDITO,
	C.EXCEDER_LIMITE,
	C.TASA_INTERES,
	C.TASA_INTERES_MORA,
	C.FECHA_ULT_MORA,
	C.FECHA_ULT_MOV,
	C.CONDICION_PAGO,
	C.NIVEL_PRECIO,
	C.DESCUENTO,
	C.MONEDA_NIVEL,
	C.ACEPTA_BACKORDER,
	C.PAIS,
	C.ZONA,
	C.RUTA,
	C.VENDEDOR,
	C.COBRADOR,
	C.ACEPTA_FRACCIONES,
	C.ACTIVO,
	C.EXENTO_IMPUESTOS,
	C.EXENCION_IMP1,
	C.EXENCION_IMP2,
	C.COBRO_JUDICIAL,
	C.CATEGORIA_CLIENTE,
	C.CLASE_ABC,
	C.DIAS_ABASTECIMIEN,
	C.USA_TARJETA,
	C.TARJETA_CREDITO,
	C.TIPO_TARJETA,
	C.FECHA_VENCE_TARJ,
	C.E_MAIL,
	C.REQUIERE_OC,
	C.ES_CORPORACION,
	C.CLI_CORPORAC_ASOC,
	C.REGISTRARDOCSACORP,
	C.USAR_DIREMB_CORP,
	C.APLICAC_ABIERTAS,
	C.VERIF_LIMCRED_CORP,
	C.USAR_DESC_CORP,
	C.DOC_A_GENERAR,
	C.TIENE_CONVENIO,
	C.NOTAS,
	C.DIAS_PROMED_ATRASO,
	C.ASOCOBLIGCONTFACT,
	C.USAR_PRECIOS_CORP,
	C.USAR_EXENCIMP_CORP,
	C.DIAS_DE_COBRO,
	C.AJUSTE_FECHA_COBRO,
	C.GLN,
	C.UBICACION,
	C.CLASE_DOCUMENTO,
	C.LOCAL,
	C.TIPO_CONTRIBUYENTE,
	C.MODELO_RETENCION,
	C.ACEPTA_DOC_ELECTRONICO,
	C.CONFIRMA_DOC_ELECTRONICO,
	C.EMAIL_DOC_ELECTRONICO,
	C.EMAIL_PED_EDI,
	C.ACEPTA_DOC_EDI,
	C.NOTIFICAR_ERROR_EDI,
	C.EMAIL_ERROR_PED_EDI,
	C.CODIGO_IMPUESTO,
	C.DIVISION_GEOGRAFICA1,
	C.DIVISION_GEOGRAFICA2,
	C.REGIMEN_TRIB,
	C.MOROSO,
	C.MODIF_NOMB_EN_FAC,
	C.SALDO_TRANS_LOCAL,
	C.SALDO_TRANS_DOLAR,
	C.PERMITE_DOC_GP,
	C.PARTICIPA_FLUJOCAJA,
	C.CURP,
	I.IMPUESTO1,
	I.IMPUESTO2,
	C.DETALLAR_KITS,
	C.RUBRO1_CLI,
	C.RUBRO2_CLI,
	C.RUBRO3_CLI,
	C.RUBRO4_CLI,
	C.RUBRO5_CLI,
	C.RUBRO1_CLIENTE,
	C.RUBRO2_CLIENTE,
	C.RUBRO3_CLIENTE,
	C.RUBRO4_CLIENTE,
	C.RUBRO5_CLIENTE,
	C.RUBRO6_CLIENTE,
	C.RUBRO7_CLIENTE,
	C.RUBRO8_CLIENTE,
	C.RUBRO9_CLIENTE,
	C.RUBRO10_CLIENTE,
	C.RUBRO11_CLIENTE,
	C.RUBRO12_CLIENTE,
	C.RUBRO13_CLIENTE,
	C.RUBRO14_CLIENTE,
	C.RUBRO15_CLIENTE,
	C.RUBRO16_CLIENTE,
	C.RUBRO17_CLIENTE,
	C.RUBRO18_CLIENTE,
	C.RUBRO19_CLIENTE,
	C.RUBRO20_CLIENTE
	FROM $$COMPANIA$$.DOCUMENTOS_CC DCC
	INNER JOIN $$COMPANIA$$.CLIENTE C ON DCC.CLIENTE = C.CLIENTE 
	LEFT JOIN $$COMPANIA$$.IMPUESTO I ON C.CODIGO_IMPUESTO = I.IMPUESTO 
	WHERE  DCC.DOCUMENTO = @DOCUMENTO 
	AND @TIPO = DCC.TIPO
);


CREATE FUNCTION $$COMPANIA$$.CLIENTE_PAGO_XML (@DOCUMENTO VARCHAR(50), @TIPO VARCHAR(3))
RETURNS XML
AS
BEGIN
	DECLARE @XMLCLIENTE XML
  
	SET @XMLCLIENTE = (  SELECT * FROM $$COMPANIA$$.INFO_CLIENTE_PAGO_XML(@DOCUMENTO, @TIPO)
	FOR XML RAW ('CLIENTE'), ELEMENTS)
	RETURN @XMLCLIENTE
END;


CREATE FUNCTION $$COMPANIA$$.INFO_PAGO_XML (@DOCUMENTO VARCHAR(50), @TIPO VARCHAR(3))
RETURNS TABLE
AS
RETURN (
	 SELECT 
 			 DCC.DOCUMENTO,
 			 ISNULL(DCC.DOCUMENTO_FISCAL,'CAMPO EN BLANCO') DOCUMENTO_FISCAL,
 			 DCC.CONDICION_PAGO,
 			 CP.DESCRIPCION DESCRIPCION_CONDICION_PAGO,
 			 DE.DIRECCION,
 			 'CONSEC_CC' CONSECUTIVO,
 			 DE.CONTACTO,
 			 DE.CARGO,
 			 DE.TELEFONO1,
 			 DE.TELEFONO2,
 			 DE.FAX,
 			 DE.EMAIL,
 			 DD.CAMPO_1 DIREC_CAMPO_1,
 			 DD.CAMPO_2 DIREC_CAMPO_2,
 			 DD.CAMPO_3 DIREC_CAMPO_3,
 			 DD.CAMPO_4 DIREC_CAMPO_4,
 			 DD.CAMPO_5 DIREC_CAMPO_5,
 			 DD.CAMPO_6 DIREC_CAMPO_6,
 			 DD.CAMPO_7 DIREC_CAMPO_7,
 			 DD.CAMPO_8 DIREC_CAMPO_8,
 			 DD.CAMPO_9 DIREC_CAMPO_9,
 			 DD.CAMPO_10 DIREC_CAMPO_10,
 			 DCC.FECHA,
 			 DATEADD(S,DATEPART(S,DCC.CREATEDATE),DATEADD(MI,DATEPART(MI,DCC.CREATEDATE),DATEADD(HH,DATEPART(HH,DCC.CREATEDATE),DCC.FECHA))) FECHA_HORA,
 			 DCC.FECHA_DOCUMENTO FECHA_ORDEN,
 			 DCC.MONEDA,
 			 '0.000000' ANTICIPO,
 			 '0.000000' COBRADO,
 			 '0.000000' DESCUENTO1,
 			 '0.000000' DESCUENTO2,
 			 '0.000000' DOCUMENTACIO,
 			 CAST (DCC.RUBRO1 AS DECIMAL(28,6)) AS MONTO_FLETE,
 			 CAST (DCC.RUBRO2 AS DECIMAL(28,6)) AS SEGURO,
 			 'N/D' ORDEN_COMPRA,
 			 '0.000000' PORC_DESCUENTO1,
 			 '0.000000' PORC_DESCUENTO2,
 			 NULL RUBRO1,
 			 NULL RUBRO2,
 			 NULL RUBRO3,
 			 NULL RUBRO4,
 			 NULL RUBRO5,
 			 NULL COMENTARIO_CXC,
 			 CAST (DCC.TIPO_CAMBIO_MONEDA AS DECIMAL(28,6)) AS TIPO_CAMBIO,
 			 DCC.TIPO  AS TIPO_DOCUMENTO,
 			 
			 (
			 SELECT   CASE WHEN ( MAX(DCC2.NUM_PARCIALIDADES) )   >= 1 
			 THEN SUM(CAST(pcc.MONTO_CREDITO AS DECIMAL(28,6)))
			 ELSE SUM(CAST(acc.MONTO_CREDITO AS DECIMAL(28,6)))	END 
			 FROM $$COMPANIA$$.DOCUMENTOS_CC DCC1 LEFT JOIN  $$COMPANIA$$.AUXILIAR_CC acc  
			 ON DCC1.DOCUMENTO = acc.CREDITO
			 AND DCC1.TIPO = acc.TIPO_CREDITO
			 INNER JOIN $$COMPANIA$$.DOCUMENTOS_CC DCC2 ON DCC2.DOCUMENTO = ACC.DEBITO AND DCC2.TIPO = ACC.TIPO_DEBITO 
			 INNER JOIN  $$COMPANIA$$.CONDICION_PAGO cp 
			 ON DCC1.CONDICION_PAGO = cp.CONDICION_PAGO
			 INNER JOIN  $$COMPANIA$$.CONDICION_PAGO cp1 
			 ON DCC2.CONDICION_PAGO = cp1.CONDICION_PAGO
			 LEFT JOIN  $$COMPANIA$$.AUXILIAR_PARC_CC pcc
			 ON acc.DEBITO = pcc.DEBITO
			 AND acc.TIPO_DEBITO= pcc.TIPO_DEBITO
			 AND acc.CREDITO = pcc.CREDITO
			 AND	acc.TIPO_CREDITO = pcc.TIPO_CREDITO
			 WHERE		 acc.CREDITO = @DOCUMENTO
			 AND	 @TIPO =  ACC.TIPO_CREDITO 
			 AND cp1.U_METODO_PAGO != 'PUE' 
			 ) AS TOTAL_FACTURA,

			 CAST (DCC.MONTO AS DECIMAL(28,6)) AS TOTAL_CREDITO,

 			 $$COMPANIA$$.NUMEROALETRAS(DCC.MONTO) AS TOTAL_FACTURA_LETRAS,
 			 CAST (DCC.MONTO - ISNULL(DCC.MONTO_RETENCION,0) AS DECIMAL(28,6)) AS TOTAL_FACTURA_SIN_RETENCION,
 			 $$COMPANIA$$.NUMEROALETRAS(DCC.MONTO - ISNULL(DCC.MONTO_RETENCION,0)) AS TOT_FAC_SIN_RETENCION_LETRAS,
 			 CAST (DCC.SUBTOTAL AS DECIMAL(28,6)) AS SUBTOTAL_FACTURA,
 			 $$COMPANIA$$.NUMEROALETRAS(DCC.MONTO) AS SUBTOTAL_FACTURA_LETRAS,
 			 CAST ('1' AS DECIMAL(28,6)) AS TOTAL_UNIDADES,
 			 CAST (DCC.IMPUESTO1 AS DECIMAL(28,6)) AS IMPUESTO1,
  			 CAST (DCC.IMPUESTO2 AS DECIMAL(28,6)) AS IMPUESTO2,
 			 DCC.VENDEDOR,
 			 'SIN OBSERVACIONES' OBSERVACIONES,
 			 DCC.ANULADO,
 			 'N/D' PEDIDO,
 			 ISNULL(DCC.DOCUMENTO, 'CAMPO EN BLANCO') AS FACTURA_ORIGINAL,
 			 'N/D' BODEGA,
 			 DCC.FECHA AS FECHA_ORIGINAL,
 			 DATEADD(S,DATEPART(S,DCC.CREATEDATE),DATEADD(MI,DATEPART(MI,DCC.CREATEDATE),DATEADD(HH,DATEPART(HH,DCC.CREATEDATE),DCC.FECHA))) FECHA_HORA_ORIGINAL,
 			 DCC.FECHA_VENCE,
 			 DCC.FECHA FECHA_PROMETIDA,
 			 CAST (DCC.DESCUENTO AS DECIMAL(28,6)) AS TOTAL_DESCUENTOS,
			 DCC.USO_CFDI,
			 CASE DCC.TIPO WHEN 'REC' THEN '01' 
						   WHEN 'TEF' THEN '03' 
						   WHEN 'DEP' THEN (CASE WHEN UPPER(SCC.DESCRIPCION) LIKE '%CHEQUE%' THEN '02'
												 ELSE '01'
											END)
			 END AS FORMA_PAGO,
			 EF.NIT AS NIT_EMISOR,
			 EF.DESCRIPCION AS NOMBRE_ENTIDAD,
			 DCC.CUENTA_ORIGEN AS CUENTA_ORIGEN,
			 (	SELECT	EF.NIT
				FROM	$$COMPANIA$$.CUENTA_BANCARIA CTA
						INNER JOIN $$COMPANIA$$.ENTIDAD_FINANCIERA EF
						ON CTA.ENTIDAD_FINANCIERA = EF.ENTIDAD_FINANCIERA 
				WHERE	CTA.CUENTA_BANCO = DCC.CTA_BANCARIA) AS NIT_CUENTA,
			 DCC.CTA_BANCARIA AS CUENTA_BANCARIA
 	 FROM	 $$COMPANIA$$.DOCUMENTOS_CC DCC
			 INNER JOIN $$COMPANIA$$.CLIENTE C
			 ON DCC.CLIENTE = C.CLIENTE
			 LEFT JOIN $$COMPANIA$$.SUBTIPO_DOC_CC SCC
			 ON DCC.SUBTIPO = SCC.SUBTIPO AND DCC.TIPO = SCC.TIPO
 		     LEFT JOIN $$COMPANIA$$.CONDICION_PAGO CP
 			 ON CP.CONDICION_PAGO = DCC.CONDICION_PAGO
 			 LEFT JOIN $$COMPANIA$$.DIRECC_EMBARQUE DE
 			 ON DCC.CLIENTE = DE.CLIENTE
			 AND C.DIR_EMB_DEFAULT = DE.DIRECCION
 			 LEFT JOIN $$COMPANIA$$.DETALLE_DIRECCION DD
 			 ON DE.DETALLE_DIRECCION = DD.DETALLE_DIRECCION
			 LEFT JOIN $$COMPANIA$$.ENTIDAD_FINANCIERA EF
			 ON DCC.ENTIDAD_FINANCIERA = EF.ENTIDAD_FINANCIERA
			

 	 WHERE		 DCC.DOCUMENTO = @DOCUMENTO 
	 AND	 @TIPO =  DCC.TIPO 
	 );



CREATE FUNCTION $$COMPANIA$$.PAGO_XML (@documento varchar(50), @tipo varchar(3))
RETURNS XML
AS
BEGIN
DECLARE @XMLPAGO XML
  
SET @XMLPAGO = (  SELECT * FROM $$COMPANIA$$.INFO_PAGO_XML(@documento, @tipo)
FOR XML RAW ('PAGO'), ELEMENTS)
RETURN @XMLPAGO
END;



CREATE FUNCTION $$COMPANIA$$.INFO_DETALLE_PAGO_XML (@DOCUMENTO VARCHAR(50), @TIPO VARCHAR(3))
RETURNS TABLE
AS
RETURN (
	SELECT	dcc.DOCUMENTO AS DOCUMENTO,
		dcc.TIPO AS TIPO,
		dcc1.DOCUMENTO_FISCAL AS DOCUMENTO_FISCAL,
		acc.DEBITO AS SERIE,
		acc.FOLIOSAT_DEBITO AS FOLIO,
		acc.MONEDA_DEBITO AS MONEDA,
		dcc1.TIPO_CAMBIO_MONEDA AS TIPO_CAMBIO,
		cp.U_METODO_PAGO AS METODO_PAGO,
		ISNULL( pcc.PARCIALIDAD, (SELECT COUNT(DEBITO) FROM $$COMPANIA$$.AUXILIAR_CC WHERE DEBITO= ACC.DEBITO AND TIPO_DEBITO = ACC.TIPO_DEBITO AND CREATEDATE<=ACC.CREATEDATE ))AS PARCIALIDAD,
		CAST(
			CASE WHEN (SELECT ISNULL(SUM(PARCIALIDAD),0) FROM  $$COMPANIA$$.AUXILIAR_PARC_CC WHERE CREDITO = pcc.CREDITO and dcc.TIPO = pcc.TIPO_CREDITO) <= 1 
				 THEN (DCC1.MONTO-(SELECT ISNULL(SUM(MONTO_DEBITO),0) FROM $$COMPANIA$$.AUXILIAR_CC WHERE DEBITO= ACC.DEBITO AND TIPO_DEBITO = ACC.TIPO_DEBITO AND CREATEDATE<ACC.CREATEDATE) ) 
				 ELSE ISNULL(DCC1.MONTO,0) - (SELECT ISNULL(SUM(MONTO_CREDITO),0) FROM  $$COMPANIA$$.AUXILIAR_PARC_CC WHERE debito = pcc.debito AND PARCIALIDAD < pcc.PARCIALIDAD and dcc.TIPO = pcc.TIPO_CREDITO)
			END 
		AS DECIMAL(28,6)) AS IMPSALDOANT,

		CASE WHEN (SELECT ISNULL(NUM_PARCIALIDADES,0) FROM  $$COMPANIA$$.DOCUMENTOS_CC WHERE DOCUMENTO = acc.DEBITO and TIPO = acc.TIPO_DEBITO) >= 1 
			 THEN CAST(ISNULL(pcc.MONTO_DEBITO,0) AS DECIMAL(28,6))
			 ELSE CAST(acc.MONTO_DEBITO AS DECIMAL(28,6))
		END AS IMPPAGADO,

		CAST((CASE WHEN (SELECT ISNULL(SUM(PARCIALIDAD),0) FROM  $$COMPANIA$$.AUXILIAR_PARC_CC WHERE CREDITO = pcc.CREDITO and dcc.TIPO = pcc.TIPO_CREDITO) <= 1
		  THEN (DCC1.MONTO-(SELECT ISNULL(SUM(MONTO_DEBITO),0) FROM $$COMPANIA$$.AUXILIAR_CC WHERE DEBITO= ACC.DEBITO AND TIPO_DEBITO = ACC.TIPO_DEBITO AND CREATEDATE<=ACC.CREATEDATE) )
					ELSE ISNULL(DCC1.MONTO,0) - (SELECT ISNULL(SUM(MONTO_CREDITO),0) FROM  $$COMPANIA$$.AUXILIAR_PARC_CC WHERE debito = pcc.debito AND PARCIALIDAD <= pcc.PARCIALIDAD and dcc.TIPO = pcc.TIPO_CREDITO)
				END)
				 AS DECIMAL(28,6)) AS IMPSALDOINSOLUTO,
		dcc1.condicion_pago AS CONDICION_PAGO,
		CASE 
			WHEN ((ACC.MONEDA_CREDITO = ACC.MONEDA_DEBITO)
			 OR (ACC.MONEDA_DEBITO = 'MXP' AND ACC.MONEDA_CREDITO = 'MXN' )
			 OR (ACC.MONEDA_DEBITO = 'MXN' AND ACC.MONEDA_CREDITO = 'MXP' ))
			THEN '0' 
			ELSE CASE 
					WHEN ACC.MONEDA_DEBITO = 'MXP' OR ACC.MONEDA_DEBITO = 'MXN' OR ACC.MONEDA_DEBITO = 'PESO' THEN '3' ELSE '1' END  
			END MOSTRAR_TC
FROM	$$COMPANIA$$.DOCUMENTOS_CC dcc
		INNER JOIN  $$COMPANIA$$.AUXILIAR_CC acc
		ON dcc.DOCUMENTO = acc.CREDITO
		AND dcc.TIPO = acc.TIPO_CREDITO
		LEFT JOIN  $$COMPANIA$$.AUXILIAR_PARC_CC pcc
		ON acc.DEBITO = pcc.DEBITO
		AND acc.TIPO_DEBITO = pcc.TIPO_DEBITO
		AND acc.CREDITO = pcc.CREDITO
		AND	acc.TIPO_CREDITO = pcc.TIPO_CREDITO
		INNER JOIN $$COMPANIA$$.DOCUMENTOS_CC dcc1
		ON dcc1.DOCUMENTO = acc.DEBITO 
		AND dcc1.TIPO = acc.TIPO_DEBITO
		INNER JOIN  $$COMPANIA$$.CONDICION_PAGO cp
		ON dcc1.CONDICION_PAGO = cp.CONDICION_PAGO
WHERE	DCC.DOCUMENTO = @DOCUMENTO 
AND		@TIPO =  DCC.TIPO
AND cp.U_METODO_PAGO != 'PUE'  );



CREATE FUNCTION $$COMPANIA$$.DETALLE_PAGO_XML (@documento varchar(50), @tipo varchar(3))
RETURNS XML
AS
BEGIN
	DECLARE @XMLDETALLEPAGO XML
  
	SET @XMLDETALLEPAGO = (  SELECT * FROM $$COMPANIA$$.INFO_DETALLE_PAGO_XML(@documento, @tipo)
	FOR XML RAW ('DETALLE'),ROOT('DETALLE_PAGO'), ELEMENTS)
	RETURN @XMLDETALLEPAGO
END;



CREATE FUNCTION $$COMPANIA$$.XML_DOCUMENTO_PAGO(@compania varchar(10), @documento varchar(50), @tipo varchar(3))
RETURNS XML
AS
BEGIN
RETURN (
    SELECT	$$COMPANIA$$.COMPANIA_XML(@compania),
			$$COMPANIA$$.PAGO_XML(@documento, @tipo),
			$$COMPANIA$$.CLIENTE_PAGO_XML(@documento, @tipo), 
			$$COMPANIA$$.DIRECCION_CLIENTE_PAGO_XML(@documento, @tipo),
			$$COMPANIA$$.DIRECCION_EMBARQUE_PAGO_XML(@documento, @tipo),
			$$COMPANIA$$.DETALLE_PAGO_XML(@documento, @tipo)
	FOR XML RAW('DOCUMENTO'))
END;

CREATE TRIGGER $$COMPANIA$$.DES_BON_ESP_GR_POS_SINC_DEL
ON $$COMPANIA$$.DES_BON_ESPECIFICACION_GRUPO
FOR DELETE  
AS 
BEGIN   	
   	DECLARE @ERROR INT
	DECLARE @SENTENCIA   		VARCHAR(254)
	DECLARE @NOMBRETABLA		VARCHAR(254)
	DECLARE @USUARIO_ACTUAL		VARCHAR(30)

	DECLARE @REGLA VARCHAR(20)
	DECLARE @ESCALA INT
	
	SET @NOMBRETABLA = 'DES_BON_ESPECIFICACION_GRUPO'

	EXEC ERPADMIN.LeerUsuarioActual @USUARIO_ACTUAL OUTPUT

	/*Aquí se hace la validación del usuario de conexión para evitar ping-pong*/
	IF NOT ('SoftlandSync' = @USUARIO_ACTUAL)
	BEGIN
		DECLARE C_DELETED CURSOR LOCAL FOR
			SELECT REGLA, ESCALA
			FROM DELETED d
			
		OPEN C_DELETED
		FETCH NEXT FROM C_DELETED INTO 
		@REGLA, @ESCALA
		
		SET @ERROR = 0
		
		WHILE @@FETCH_STATUS = 0 AND @ERROR = 0
		BEGIN
			SET @SENTENCIA = 'DELETE FROM $$COMPANIA$$.' + @NOMBRETABLA + ' WHERE REGLA = ''' + @REGLA  + ''' AND ESCALA = ''' + CONVERT(VARCHAR(36),@ESCALA)  + ''''
			
			EXECUTE @ERROR = $$COMPANIA$$.POS_INSERTA_ELIMINACION @SENTENCIA, @NOMBRETABLA
			
			FETCH NEXT FROM C_DELETED INTO 
			@REGLA, @ESCALA
		END

		CLOSE C_DELETED
		DEALLOCATE C_DELETED
	END
	
	IF (@@ERROR <> 0) 
	BEGIN
		RAISERROR( 'Error generando la sentencia de eliminación de la tabla DES_BON_ESPECIFICACION_GRUPO.',16,1 )
	END
END
;

/*--943-27FA---*/ 

CREATE FUNCTION $$COMPANIA$$.INFO_INV_XML (@AUDIT VARCHAR(50))
RETURNS TABLE
AS
RETURN (
   SELECT
   MAX(TI.AUDIT_TRANS_INV) DOCUMENTO,
   MAX(ISNULL(TI.DOC_FISCAL, 'CAMPO EN BLANCO') )AS DOC_FISCAL,
   MAX(TI.CONSECUTIVO) CONSECUTIVO,
   'CI' MODULO,
   MAX(TI.FECHA) FECHA, 
   FORMAT(MAX(TI.FECHA_HORA_TRANSAC),'yyyy-MM-ddTHH:mm:ss') AS FECHA_HORA,
   'MXN' MONEDA_FACTURA,
   'CP' TIPO_DOCUMENTO,
   0 TOTAL_FACTURA, 
   0 TOTAL_FACTURA_SIN_RETENCION,
   0 AS SUBTOTAL_FACTURA,
   0 SUBTOTAL_FACTURA_LETRAS, 
   ISNULL(MAX(TI.BODEGA), 'CAMPO EN BLANCO') AS PEDIDO_BODEGA,
   MAX(TI.FECHA ) AS FECHA_ORIGINAL,
   0 TOTAL_DESCUENTOS,
   0 DESC_TOT_LINEA, 
   '03' U_TIPO_RELACION
   FROM $$COMPANIA$$.TRANSACCION_INV TI
   WHERE TI.AUDIT_TRANS_INV = @AUDIT
   AND (TI.AJUSTE_CONFIG = '~LL~' OR ( TI.AJUSTE_CONFIG = '~TT~' AND TI.NATURALEZA = 'S' AND TI.SUBTIPO <> 'I' )) )
;

CREATE FUNCTION $$COMPANIA$$.INFO_INV_LINEA_XML (@AUDIT VARCHAR(50))
RETURNS TABLE
AS
RETURN (
   SELECT 
   ART.ARTICULO,
   TI.CONSECUTIVO LINEA,
   CAST (ABS(TI.CANTIDAD) AS DECIMAL(28,6)) AS CANTIDAD,  
   TI.BODEGA,
   TI.LOCALIZACION,
   TI.LOTE,
   ART.DESCRIPCION DESCRIPCION_ARTICULO,    
   ISNULL(ART.CODIGO_BARRAS_INVT, '00000000000000') AS CODIGO_BARRAS_INVT,
   ISNULL(ART.CODIGO_BARRAS_VENT, '00000000000000') AS CODIGO_BARRAS_VENT,
   ART.FACTOR_EMPAQUE,
   ART.UNIDAD_ALMACEN,
   ART.UNIDAD_EMPAQUE,
   ART.UNIDAD_VENTA,
   ART.TIPO, 
   ART.ARTICULO_CUENTA,
   ART.U_CLAVE_PROD_SERV,
   ART.U_CLAVE_UNIDAD
   FROM $$COMPANIA$$.TRANSACCION_INV TI
         LEFT JOIN $$COMPANIA$$.ARTICULO ART ON TI.ARTICULO = ART.ARTICULO
   WHERE TI.AUDIT_TRANS_INV = @AUDIT
   AND (TI.AJUSTE_CONFIG = '~LL~' OR ( TI.AJUSTE_CONFIG = '~TT~' AND TI.NATURALEZA = 'S' AND TI.SUBTIPO <> 'I' )) )
;

 CREATE FUNCTION $$COMPANIA$$.INV_LINEA_XML (@AUDIT VARCHAR(50))
  RETURNS XML
  AS
  BEGIN
  DECLARE @XMLFACTURALINEA XML
  
  SET @XMLFACTURALINEA = (  SELECT * FROM $$COMPANIA$$.INFO_INV_LINEA_XML(@AUDIT)
  FOR XML RAW ('LINEA'), ROOT('FACTURA_LINEA'), ELEMENTS)
  RETURN @XMLFACTURALINEA
  END ;

 CREATE FUNCTION $$COMPANIA$$.INV_XML (@AUDIT VARCHAR(50))
  RETURNS XML
  AS
  BEGIN
  DECLARE @XMLFACTURA XML
  
  SET @XMLFACTURA = (  SELECT * FROM $$COMPANIA$$.INFO_INV_XML(@AUDIT)
  FOR XML RAW ('ENCABEZADO'), ELEMENTS)
  RETURN @XMLFACTURA
  END ;

CREATE FUNCTION  $$COMPANIA$$.XML_DOCUMENTO_INV(@compania varchar(10), @AUDIT varchar(50))
 RETURNS XML
 AS
 BEGIN
 RETURN (
      SELECT   $$COMPANIA$$.COMPANIA_XML(@compania), 
      $$COMPANIA$$.INV_XML(@AUDIT),    
      $$COMPANIA$$.INV_LINEA_XML(@AUDIT) 
  FOR XML RAW('DOCUMENTO'))
 END;

 CREATE VIEW $$COMPANIA$$.V_REPORTE_TRASLADO
 AS
	 SELECT FACTURA.FACTURA, FACTURA_LINEA.ARTICULO, FACTURA.FECHA, ABS(FACTURA_LINEA.CANTIDAD) AS CANTIDAD, 0 AS PRECIO_UNITARIO, 0 AS PRECIO_TOTAL, 
			0 AS TOTAL_FACTURA, ARTICULO.DESCRIPCION, 0 AS TOTAL_IMPUESTO1, 0 AS TOTAL_MERCADERIA, CLIENTE.NOMBRE, FACTURA.TIPO_DOCUMENTO,
			CLIENTE.CONTRIBUYENTE, FACTURA.MONEDA_FACTURA, DOC_ELECTRONICO_PROCESADO.FOLIO_SAT, DOC_ELECTRONICO_PROCESADO.FECHATIMBRADO, 
			DOC_ELECTRONICO_PROCESADO.NOCERTIFICADO, DOC_ELECTRONICO_PROCESADO.NOCERTIFICADOSAT, DOC_ELECTRONICO_PROCESADO.NIT_EMISOR,
			DOC_ELECTRONICO_PROCESADO.NIT_RECEPTOR, 0 AS TOTALFACTURA, CLIENTE.DIRECCION, DOC_ELECTRONICO_PROCESADO.SELLOSAT,
			DOC_ELECTRONICO_PROCESADO.SELLOCDF, DOC_ELECTRONICO_PROCESADO.CADENA_ORIGINAL
	 FROM   (($$COMPANIA$$.FACTURA_LINEA FACTURA_LINEA LEFT JOIN ($$COMPANIA$$.V_DOCUMENTO_ELECTRONICO V_DOCUMENTO_ELECTRONICO 
            LEFT JOIN ($$COMPANIA$$.CLIENTE CLIENTE LEFT JOIN $$COMPANIA$$.FACTURA FACTURA ON CLIENTE.CLIENTE=FACTURA.CLIENTE) 
            ON ((((V_DOCUMENTO_ELECTRONICO.FACTURA=FACTURA.FACTURA) AND (V_DOCUMENTO_ELECTRONICO.TIPODOCUMENTO=FACTURA.TIPO_DOCUMENTO)))
            AND (V_DOCUMENTO_ELECTRONICO.CLIENTE=FACTURA.CLIENTE))) ON (FACTURA_LINEA.TIPO_DOCUMENTO=FACTURA.TIPO_DOCUMENTO) AND 
            (FACTURA_LINEA.FACTURA=FACTURA.FACTURA)) LEFT JOIN $$COMPANIA$$.ARTICULO ARTICULO ON FACTURA_LINEA.ARTICULO=ARTICULO.ARTICULO)
            LEFT JOIN $$COMPANIA$$.DOC_ELECTRONICO_PROCESADO DOC_ELECTRONICO_PROCESADO ON (FACTURA.TIPO_DOCUMENTO=DOC_ELECTRONICO_PROCESADO.TIPO_DOC) 
            AND (FACTURA.FACTURA=DOC_ELECTRONICO_PROCESADO.NUMERO_DOC) 
	 UNION ALL
	 SELECT DCC.DOCUMENTO AS FACTURA, '01010101', DCC.FECHA, 1 AS CANTIDAD, 0 AS PRECIO_UNITARIO, 0 AS PRECIO_TOTAL, 0 AS TOTAL_FACTURA, DCC.APLICACION, 
            0 AS TOTAL_IMPUESTO1, 0 AS TOTAL_MERCADERIA, CLI.NOMBRE, VDOC.TIPODOCUMENTO, CLI.CONTRIBUYENTE, DCC.MONEDA, DOCELEC.FOLIO_SAT, 
            DOCELEC.FECHATIMBRADO, DOCELEC.NOCERTIFICADO, DOCELEC.NOCERTIFICADOSAT, DOCELEC.NIT_EMISOR, DOCELEC.NIT_RECEPTOR, 0 AS TOTALFACTURA, 
            CLI.DIRECCION, DOCELEC.SELLOSAT, DOCELEC.SELLOCDF, DOCELEC.CADENA_ORIGINAL
     FROM   $$COMPANIA$$.DOCUMENTOS_CC DCC 
            LEFT JOIN $$COMPANIA$$.V_DOCUMENTO_ELECTRONICO VDOC ON VDOC.FACTURA = DCC.DOCUMENTO AND ( CASE VDOC.TIPODOCUMENTO WHEN 'F' THEN 'FAC' WHEN 'D' THEN 'N/C' WHEN 'ND' THEN 'N/D' END) = DCC.TIPO
            LEFT JOIN $$COMPANIA$$.CLIENTE CLI ON DCC.CLIENTE = CLI.CLIENTE 
            LEFT JOIN $$COMPANIA$$.DOC_ELECTRONICO_PROCESADO DOCELEC ON DOCELEC.NUMERO_DOC = VDOC.FACTURA AND DOCELEC.TIPO_DOC = VDOC.TIPODOCUMENTO
	 WHERE  0 = ( SELECT COUNT(0) FROM $$COMPANIA$$.FACTURA F WHERE DCC.DOCUMENTO = F.FACTURA AND DCC.TIPO = ( CASE F.TIPO_DOCUMENTO WHEN 'F' THEN 'FAC' WHEN 'D' THEN 'N/C' END))
	 UNION ALL
	 SELECT CAST(TI.AUDIT_TRANS_INV AS VARCHAR), A.ARTICULO,TI.FECHA_HORA_TRANSAC, ABS(TI.CANTIDAD) AS CANTIDAD, 0, 0,0, A.DESCRIPCION, 0, 0, C.NOMBRE, 'CP',TI.NIT, 'MXN', DOCELE.FOLIO_SAT,
			DOCELE.FECHATIMBRADO, DOCELE.NOCERTIFICADO, DOCELE.NOCERTIFICADOSAT, DOCELE.NIT_EMISOR, DOCELE.NIT_RECEPTOR,0, '',DOCELE.SELLOSAT,DOCELE.SELLOCDF,DOCELE.CADENA_ORIGINAL
	 FROM	$$COMPANIA$$.TRANSACCION_INV TI INNER JOIN $$COMPANIA$$.ARTICULO A ON TI.ARTICULO = A.ARTICULO
			INNER JOIN $$COMPANIA$$.DOC_ELECTRONICO_PROCESADO DOCELE ON CAST(TI.AUDIT_TRANS_INV AS varchar ) = DOCELE.NUMERO_DOC
			LEFT JOIN ERPADMIN.CONJUNTO C ON C.CONJUNTO = '$$COMPANIA$$' 
	 WHERE  (TI.AJUSTE_CONFIG = '~LL~' OR ( TI.AJUSTE_CONFIG = '~TT~' AND TI.NATURALEZA = 'S' AND TI.SUBTIPO <> 'I' ))
;

CREATE VIEW $$COMPANIA$$.V_DOCUMENTO_ELECTRONICO_CARTA
	AS 
	 SELECT 'CP' AS TIPODOCUMENTO, 
	 CONVERT(VARCHAR,AI.AUDIT_TRANS_INV ) AS FACTURA,   
	 DOCELECTPROC.ESTADO AS ESTADO, 
	 0 AS TOTALFACTURA,
	 0 SALDO,
	 0 TOTALFACTURARETENCION,
	 'MXN' AS MONEDAFACTURA, 
	 'CARTA_PORTE' AS TABLA,
	 DOCELECTPROC.FOLIO_SAT AS FOLIOSAT,
	 ISNULL(DOCELECTPROC.ENVIADO,'N') AS ENVIADO,
	 DOCELECTPROC.NIT_EMISOR AS NIT_EMISOR,
	 DOCELECTPROC.NIT_RECEPTOR AS NIT_RECEPTOR,
	 ISNULL(DOCELECTPROC.ACEPTADO,'N') AS ACEPTADO,
	 DOCELECTPROC.ACEPTACION_RECHAZO AS ACEPTACION_RECHAZO,
	 DOCELECTPROC.DOCUMENTO_ELECTRONICO AS DOCUMENTO_ELECTRONICO,
	 DOCELECTPROC.NOMBRE_PDF AS NOMBRE_PDF,
	 DOCELECTPROC.NOMBRE_XML AS NOMBRE_XML,
	 DOCELECTPROC.ESTADO_CARTA_PORTE AS ESTADO_CARTA_PORTE,
	 'S' AS GENERA_CARTA_PORTE,
	 DOCELECTPROC.ERROR_WS AS ERROR_WS,
	 DOCELECTPROC.ERROR_SOFTLAND AS ERROR_SOFTLAND,
	 DOCELECTPROC.FIRMA_DOCUMENTO AS FIRMA_GT,
	 DOCELECTPROC.GUUID_GT AS GUUID_GT,
	 CI.EMAIL_CFDI,
	  AI.FECHA_HORA AS FECHA,
	 DOCELECTPROC.FOLIO_SAT AS DOCUMENTO_FISCAL
	 FROM $$COMPANIA$$.AUDIT_TRANS_INV AI
	 LEFT OUTER JOIN $$COMPANIA$$.DOC_ELECTRONICO_PROCESADO DOCELECTPROC ON DOCELECTPROC.TIPO_DOC = 'CP' AND DOCELECTPROC.NUMERO_DOC = CONVERT(VARCHAR,AI.AUDIT_TRANS_INV )
	 LEFT OUTER JOIN $$COMPANIA$$.CONSECUTIVO_CI CI ON AI.CONSECUTIVO = CI.CONSECUTIVO
	 WHERE 
	 0 < (SELECT COUNT(1) FROM $$COMPANIA$$.TRANSACCION_INV TI 
	 WHERE (TI.AJUSTE_CONFIG = '~LL~' OR ( TI.AJUSTE_CONFIG = '~TT~' AND TI.NATURALEZA = 'S' AND TI.SUBTIPO <> 'I' ) ) 
	 AND TI.FECHA_HORA_TRANSAC >= '2018-01-01' AND AI.AUDIT_TRANS_INV = TI.AUDIT_TRANS_INV)
	 AND CI.USA_TRASLADO = 'S' 
;
