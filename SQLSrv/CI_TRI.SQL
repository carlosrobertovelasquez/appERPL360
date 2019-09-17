

DBCC DBREINDEX 	( '$$COMPANIA$$.TRANSACCION_INV', XIE1TINVARTNATFCHF  )
;
DBCC DBREINDEX ( '$$COMPANIA$$.TRANSACCION_INV', XIE1TINVARTNATFCHT  )
;
DBCC DBREINDEX ( '$$COMPANIA$$.TRANSACCION_INV', XIE1TINVARTNATFCH  )
;


CREATE FUNCTION $$COMPANIA$$.CostoUnitarioArticulo ( 
	@Calcular		AS VARCHAR(1),
	@TipoDeFecha		AS VARCHAR(1),
	@FechaReconstuye	AS DATETIME,
	@HorasAUtilizar		AS VARCHAR(1),
	@TipoCosto 		AS VARCHAR(1),
	@MonedaCalculo		AS VARCHAR(1),
	@FechaActual		AS DATETIME,
	@CodigoArticulo		AS VARCHAR(20),
	@CosteoFiscal		AS VARCHAR(1),
	@CosteoComparativo	AS VARCHAR(1),
	@CostoEstandarLocal	AS DECIMAL(28,8),
	@CostoEstandarDolar	AS DECIMAL(28,8),
	@CostoPromedioLocal	AS DECIMAL(28,8),
	@CostoPromedioDolar	AS DECIMAL(28,8),
	@CostoUltimoLocal	AS DECIMAL(28,8),
	@CostoUltimoDolar	AS DECIMAL(28,8)
)
RETURNS DECIMAL(28,8) AS BEGIN
	DECLARE @CostoUnitario		DECIMAL(28,8)
	DECLARE @DiferenciaValorLocal	DECIMAL(28,8)
	DECLARE @DiferenciaValorDolar	DECIMAL(28,8)
	DECLARE @ValorActualLocal	DECIMAL(28,8)
	DECLARE @ValorActualDolar	DECIMAL(28,8)
	DECLARE @DiferenciaExistencia	DECIMAL(28,8)
	DECLARE @ExistenciaActual	DECIMAL(28,8)
	DECLARE @TipoCosteoArticulo	VARCHAR(1)
	DECLARE @FechaDocumento		DATETIME
	DECLARE @FechaAuditoria		DATETIME
	DECLARE @AuditoriaTransac	INT
	DECLARE	@ConsecutivoTransac	INT

	IF (ISNULL(@CodigoArticulo,'ND') = 'ND' OR @Calcular = 'N' ) BEGIN RETURN 0 END

	SET @TipoDeFecha = UPPER( @TipoDeFecha )
	IF ( ISNULL(@TipoDeFecha,'') <> 'D' ) BEGIN SET @TipoDeFecha = 'A' END
	
	SET @TipoCosto = UPPER( @TipoCosto )
	IF ( ISNULL(@TipoCosto,'') <> 'P' AND ISNULL(@TipoCosto,'') <> 'L' ) BEGIN SET @TipoCosto = 'F' END

	SET @MonedaCalculo = UPPER( @MonedaCalculo )
	IF ( ISNULL(@MonedaCalculo,'') <> 'D' ) BEGIN SET @MonedaCalculo = 'L' END

	IF (@FechaReconstuye IS NULL) BEGIN SET @FechaReconstuye = @FechaActual END

	SET @HorasAUtilizar = UPPER( @HorasAUtilizar )
	IF ( @HorasAUtilizar = 'F') BEGIN SET @FechaReconstuye = CAST(SUBSTRING(CAST(@FechaReconstuye AS CHAR),1,11) + ' 23:59:59.998' AS DATETIME) END
	IF ( @HorasAUtilizar = 'I') BEGIN SET @FechaReconstuye = CAST(SUBSTRING(CAST(@FechaReconstuye AS CHAR),1,11) + ' 00:00:00.000' AS DATETIME) END

	SET @TipoCosteoArticulo = @CosteoFiscal
	IF ( @TipoCosto = 'P' ) BEGIN SET @TipoCosteoArticulo = @CosteoComparativo END
	IF ( @TipoCosto = 'L' ) BEGIN SET @TipoCosteoArticulo = @TipoCosto END

	IF (@TipoCosteoArticulo = 'S') BEGIN 
		SET @ValorActualLocal = @CostoEstandarLocal
		SET @ValorActualDolar = @CostoEstandarDolar

		IF ( @FechaReconstuye <= @FechaActual ) BEGIN
			SELECT @ValorActualLocal = SUM( COSTO_STD_DESGL.mat_corp_loc + COSTO_STD_DESGL.mat_terceros_loc + COSTO_STD_DESGL.costo_mo_loc + COSTO_STD_DESGL.costo_indir_loc ),
				@ValorActualDolar = SUM( COSTO_STD_DESGL.mat_corp_dol + COSTO_STD_DESGL.mat_terceros_dol + COSTO_STD_DESGL.costo_mo_dol + COSTO_STD_DESGL.costo_indir_dol )
			FROM	$$COMPANIA$$.costo_std_desgl COSTO_STD_DESGL (NOLOCK)
			WHERE 	COSTO_STD_DESGL.articulo = @CodigoArticulo 
				AND ( ( 0 < ( 
					SELECT	COUNT(0) 
					FROM	$$COMPANIA$$.costo_std_desgl COSTO_STD_DESGL3 (NOLOCK)
					WHERE	COSTO_STD_DESGL3.articulo = COSTO_STD_DESGL.articulo 
						AND COSTO_STD_DESGL3.fecha_hora <= @FechaReconstuye )
						AND COSTO_STD_DESGL.fecha_hora = ( 
							SELECT	MAX(COSTO_STD_DESGL2.fecha_hora)
							FROM	$$COMPANIA$$.costo_std_desgl COSTO_STD_DESGL2 (NOLOCK)
							WHERE	COSTO_STD_DESGL2.articulo = COSTO_STD_DESGL.articulo 
								AND COSTO_STD_DESGL2.fecha_hora <= @FechaReconstuye )
					) OR ( 0 = ( 
					SELECT	COUNT(0) 
					FROM	$$COMPANIA$$.costo_std_desgl COSTO_STD_DESGL3 (NOLOCK)
					WHERE	COSTO_STD_DESGL3.articulo = COSTO_STD_DESGL.articulo 
						AND COSTO_STD_DESGL3.fecha_hora <= @FechaReconstuye )
						AND COSTO_STD_DESGL.fecha_hora = ( 
							SELECT	MIN(COSTO_STD_DESGL2.fecha_hora)
							FROM	$$COMPANIA$$.costo_std_desgl COSTO_STD_DESGL2 (NOLOCK)
							WHERE	COSTO_STD_DESGL2.articulo = COSTO_STD_DESGL.articulo
								AND COSTO_STD_DESGL2.fecha_hora > @FechaReconstuye	)
					) )
		END
	END

	IF (@TipoCosteoArticulo = 'L' OR @TipoCosto = 'L' ) BEGIN 
		SET @ValorActualLocal = @CostoUltimoLocal
		SET @ValorActualDolar = @CostoUltimoDolar

		IF (@TipoCosteoArticulo = 'L'
			AND ( @TipoDeFecha = 'D' OR @FechaReconstuye <= @FechaActual ) ) BEGIN 
			IF ( @TipoDeFecha = 'D' ) BEGIN
				SELECT	@CostoUltimoLocal = ISNULL((
						CASE ISNULL(ABS(TRANSACCION_INV.cantidad),0)
							WHEN 0 THEN 0
							ELSE TRANSACCION_INV.costo_tot_fisc_loc / ABS(TRANSACCION_INV.cantidad)
							END),0),
					@CostoUltimoDolar = ISNULL((
						CASE ISNULL(ABS(TRANSACCION_INV.cantidad),0)
							WHEN 0 THEN 0
							ELSE TRANSACCION_INV.costo_tot_fisc_dol / ABS(TRANSACCION_INV.cantidad)
							END ),0),
					@FechaDocumento = TRANSACCION_INV.fecha,
					@FechaAuditoria = TRANSACCION_INV.fecha_hora_transac,
					@AuditoriaTransac = TRANSACCION_INV.audit_trans_inv,
					@ConsecutivoTransac = TRANSACCION_INV.consecutivo
				FROM	$$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
				WHERE	TRANSACCION_INV.articulo = @CodigoArticulo
					AND TRANSACCION_INV.naturaleza = 'E'
					AND TRANSACCION_INV.tipo IN ('C','V','O','P','F','M')
					AND TRANSACCION_INV.fecha <= @FechaReconstuye
					AND TRANSACCION_INV.fecha_hora_transac = (
						SELECT	MAX( TRANSACCION_INV2.fecha_hora_transac ) 
						FROM	$$COMPANIA$$.transaccion_inv TRANSACCION_INV2 (NOLOCK)
						WHERE	TRANSACCION_INV2.articulo = @CodigoArticulo
							AND TRANSACCION_INV2.naturaleza = 'E'
							AND TRANSACCION_INV2.tipo IN ('C','V','O','P','F','M')
							AND TRANSACCION_INV2.fecha <= @FechaReconstuye
					)
					AND TRANSACCION_INV.fecha >= (
						SELECT	MAX( TRANSACCION_INV3.fecha ) 
						FROM	$$COMPANIA$$.transaccion_inv TRANSACCION_INV3 (NOLOCK)
						WHERE	TRANSACCION_INV3.articulo = @CodigoArticulo
							AND TRANSACCION_INV3.naturaleza = 'E'
							AND TRANSACCION_INV3.tipo IN ('C','V','O','P','F','M')
							AND TRANSACCION_INV3.fecha <= @FechaReconstuye
					)
					AND TRANSACCION_INV.audit_trans_inv = (
						SELECT	MAX( TRANSACCION_INV4.audit_trans_inv ) 
						FROM	$$COMPANIA$$.transaccion_inv TRANSACCION_INV4 (NOLOCK)
						WHERE	TRANSACCION_INV4.articulo = @CodigoArticulo
							AND TRANSACCION_INV4.naturaleza = 'E'
							AND TRANSACCION_INV4.tipo IN ('C','V','O','P','F','M')
							AND TRANSACCION_INV4.fecha <= @FechaReconstuye
							and TRANSACCION_INV4.fecha_hora_transac = TRANSACCION_INV.fecha_hora_transac
					)
					AND TRANSACCION_INV.consecutivo = (
						SELECT	MAX( TRANSACCION_INV5.consecutivo ) 
						FROM	$$COMPANIA$$.transaccion_inv TRANSACCION_INV5 (NOLOCK)
						WHERE	TRANSACCION_INV5.articulo = @CodigoArticulo
							AND TRANSACCION_INV5.naturaleza = 'E'
							AND TRANSACCION_INV5.tipo IN ('C','V','O','P','F','M')
							AND TRANSACCION_INV5.fecha <= @FechaReconstuye
							and TRANSACCION_INV5.fecha_hora_transac = TRANSACCION_INV.fecha_hora_transac
							AND TRANSACCION_INV5.audit_trans_inv = TRANSACCION_INV.audit_trans_inv
					)
					
				
				IF ( @FechaDocumento IS NOT NULL 
					AND @FechaAuditoria IS NOT NULL
					AND (@CosteoFiscal = 'L' OR @CosteoComparativo = 'L' )  )
				BEGIN
					SELECT @DiferenciaValorLocal = ISNULL(SUM (
							CASE ISNULL(ABS(TRANSACCION_INV.cantidad),0)
							WHEN 0 THEN 0
							ELSE TRANSACCION_INV.costo_tot_fisc_loc / ABS(TRANSACCION_INV.cantidad)
							END ),0),
						@DiferenciaValorDolar = ISNULL ( SUM (
							CASE ISNULL(ABS(TRANSACCION_INV.CANTIDAD),0)
							WHEN 0 THEN 0
							ELSE TRANSACCION_INV.costo_tot_fisc_dol / ABS(TRANSACCION_INV.cantidad)
							END ), 0)
					FROM 	$$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
					WHERE	TRANSACCION_INV.articulo = @CodigoArticulo
						AND TRANSACCION_INV.naturaleza = 'C'
						AND TRANSACCION_INV.fecha <= @FechaReconstuye
						AND TRANSACCION_INV.fecha >= @FechaDocumento
						AND TRANSACCION_INV.fecha_hora_transac >= @FechaAuditoria
						AND TRANSACCION_INV.audit_trans_inv >= @AuditoriaTransac
						AND TRANSACCION_INV.consecutivo >= @ConsecutivoTransac
				END
			END
			IF ( @TipoDeFecha = 'A' ) 
			BEGIN
				SELECT	@CostoUltimoLocal = ISNULL((
						CASE ISNULL(ABS(TRANSACCION_INV.cantidad),0)
							WHEN 0 THEN 0
							ELSE TRANSACCION_INV.costo_tot_fisc_loc / ABS(TRANSACCION_INV.cantidad)
							END),0),
					@CostoUltimoDolar = ISNULL((
						CASE ISNULL(ABS(TRANSACCION_INV.cantidad),0)
							WHEN 0 THEN 0
							ELSE TRANSACCION_INV.costo_tot_fisc_dol / ABS(TRANSACCION_INV.cantidad)
							END ),0),
					@FechaAuditoria = TRANSACCION_INV.fecha_hora_transac,
					@AuditoriaTransac = TRANSACCION_INV.audit_trans_inv,
					@ConsecutivoTransac = TRANSACCION_INV.consecutivo
				FROM	$$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
				WHERE	TRANSACCION_INV.articulo = @CodigoArticulo
					AND TRANSACCION_INV.naturaleza = 'E'
					AND TRANSACCION_INV.tipo IN ('C','V','O','P','F','M')
					AND TRANSACCION_INV.fecha_hora_transac <= @FechaReconstuye
					AND TRANSACCION_INV.fecha_hora_transac = (
						SELECT	MAX( TRANSACCION_INV2.fecha_hora_transac ) 
						FROM	$$COMPANIA$$.transaccion_inv TRANSACCION_INV2 (NOLOCK)
						WHERE	TRANSACCION_INV2.articulo = @CodigoArticulo
							AND TRANSACCION_INV2.naturaleza = 'E'
							AND TRANSACCION_INV2.tipo IN ('C','V','O','P','F','M')
							AND TRANSACCION_INV2.fecha <= @FechaReconstuye
					)
					AND TRANSACCION_INV.AUDIT_TRANS_INV = (
						SELECT	MAX( TRANSACCION_INV3.audit_trans_inv ) 
						FROM	$$COMPANIA$$.transaccion_inv TRANSACCION_INV3 (NOLOCK)
						WHERE	TRANSACCION_INV3.articulo = @CodigoArticulo
							AND TRANSACCION_INV3.naturaleza = 'E'
							AND TRANSACCION_INV3.tipo IN ('C','V','O','P','F','M')
							AND TRANSACCION_INV3.fecha_hora_transac <= @FechaReconstuye
					)
					AND TRANSACCION_INV.CONSECUTIVO = (
						SELECT	MAX( TRANSACCION_INV4.CONSECUTIVO ) 
						FROM	$$COMPANIA$$.transaccion_inv TRANSACCION_INV4 (NOLOCK)
						WHERE	TRANSACCION_INV4.articulo = @CodigoArticulo
							AND TRANSACCION_INV4.naturaleza = 'E'
							AND TRANSACCION_INV4.tipo IN ('C','V','O','P','F','M')
							AND TRANSACCION_INV4.fecha_hora_transac <= @FechaReconstuye
							AND TRANSACCION_INV4.audit_trans_inv = TRANSACCION_INV.audit_trans_inv
					)
					
				IF ( @FechaAuditoria IS NOT NULL
					AND (@CosteoFiscal = 'L' OR @CosteoComparativo = 'L' )  )
				BEGIN
					SELECT @DiferenciaValorLocal = ISNULL(SUM (
							CASE ISNULL(ABS(TRANSACCION_INV.cantidad),0)
							WHEN 0 THEN 0
							ELSE TRANSACCION_INV.costo_tot_fisc_loc / ABS(TRANSACCION_INV.cantidad)
							END ),0),
						@DiferenciaValorDolar = ISNULL ( SUM (
							CASE ISNULL(ABS(TRANSACCION_INV.cantidad),0)
							WHEN 0 THEN 0
							ELSE TRANSACCION_INV.costo_tot_fisc_dol / ABS(TRANSACCION_INV.cantidad)
							END ), 0)
					FROM 	$$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
					WHERE	TRANSACCION_INV.articulo = @CodigoArticulo
						AND TRANSACCION_INV.naturaleza = 'C'
						AND TRANSACCION_INV.fecha_hora_transac <= @FechaReconstuye
						AND TRANSACCION_INV.fecha_hora_transac >= @FechaAuditoria
						AND TRANSACCION_INV.audit_trans_inv >= @AuditoriaTransac
						AND TRANSACCION_INV.consecutivo >= @ConsecutivoTransac
				END
			END
			SET @ValorActualLocal = ISNULL(@CostoUltimoLocal,0) + ISNULL(@DiferenciaValorLocal,0)
			SET @ValorActualDolar = ISNULL(@CostoUltimoDolar,0) + ISNULL(@DiferenciaValorDolar,0)
		END
	END

	IF (@TipoCosteoArticulo = 'P' OR @TipoCosteoArticulo = 'U' OR @TipoCosteoArticulo = 'E') BEGIN
		SET @ValorActualLocal = @CostoPromedioLocal
		SET @ValorActualDolar = @CostoPromedioDolar
		
		IF (@TipoCosteoArticulo = 'U' OR @TipoCosteoArticulo = 'E') BEGIN
			SELECT	@ValorActualLocal = SUM ( ISNULL(COSTO_UEPS_PEPS.cantidad_restante,0) * ISNULL(COSTO_UEPS_PEPS.costo_local,0) ),
				@ValorActualDolar = SUM ( ISNULL(COSTO_UEPS_PEPS.cantidad_restante,0) * ISNULL(COSTO_UEPS_PEPS.costo_dolar,0) ),
				@ExistenciaActual = SUM ( ISNULL(COSTO_UEPS_PEPS.cantidad_restante,0) )
			FROM	$$COMPANIA$$.costo_ueps_peps COSTO_UEPS_PEPS (NOLOCK)
			WHERE	COSTO_UEPS_PEPS.articulo = @CodigoArticulo
				AND COSTO_UEPS_PEPS.cantidad_restante > 0
		END

		IF ( @TipoDeFecha = 'D' OR ( @TipoDeFecha = 'A' AND @FechaReconstuye < @FechaActual ) ) BEGIN
			IF (@TipoCosteoArticulo = 'P') BEGIN
				SELECT	@ExistenciaActual = SUM(ISNULL(EXISTENCIA_BODEGA.cant_disponible,0) + ISNULL(EXISTENCIA_BODEGA.cant_reservada,0) + ISNULL(EXISTENCIA_BODEGA.cant_no_aprobada,0) + ISNULL(EXISTENCIA_BODEGA.cant_vencida,0) + ISNULL(EXISTENCIA_BODEGA.cant_remitida,0))
				FROM	$$COMPANIA$$.existencia_bodega EXISTENCIA_BODEGA (NOLOCK)
				WHERE	EXISTENCIA_BODEGA.ARTICULO = @CodigoArticulo

				SET @ValorActualLocal = ISNULL(@CostoPromedioLocal,0) * ISNULL(@ExistenciaActual,0)
				SET @ValorActualDolar = ISNULL(@CostoPromedioDolar,0) * ISNULL(@ExistenciaActual,0)
			END

			IF ( @TipoCosto = 'F' ) BEGIN
				IF ( @TipoDeFecha = 'A' ) BEGIN
					SELECT 	@DiferenciaExistencia = SUM ( 
						CASE 
						WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.cantidad ) 
						WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.cantidad ) 
						ELSE 0 END ),
						@DiferenciaValorLocal = SUM ( 
						CASE 
						WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_fisc_loc )
						WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_fisc_loc )
						WHEN TRANSACCION_INV.naturaleza = 'C' THEN -1*TRANSACCION_INV.costo_tot_fisc_loc
						ELSE 0 END ),
						@DiferenciaValorDolar = SUM ( 
						CASE 
						WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_fisc_dol )
						WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_fisc_dol )
						WHEN TRANSACCION_INV.naturaleza = 'C' THEN -1*TRANSACCION_INV.costo_tot_fisc_dol
						ELSE 0 END )
					FROM	$$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
					WHERE	TRANSACCION_INV.articulo = @CodigoArticulo
						AND TRANSACCION_INV.tipo IN ( 'V', 'C', 'O', 'P', 'E', 'F', 'M', 'S' )
						AND TRANSACCION_INV.fecha_hora_transac >= @FechaReconstuye
				END

				IF ( @TipoDeFecha = 'D' ) BEGIN
					SELECT 	@DiferenciaExistencia = SUM ( 
						CASE 
						WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.cantidad ) 
						WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.cantidad ) 
						ELSE 0 END ),
						@DiferenciaValorLocal = SUM ( 
						CASE 
						WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_fisc_loc )
						WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_fisc_loc )
						WHEN TRANSACCION_INV.naturaleza = 'C' THEN -1*TRANSACCION_INV.costo_tot_fisc_loc
						ELSE 0 END ),
						@DiferenciaValorDolar = SUM ( 
						CASE 
						WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_fisc_dol )
						WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_fisc_dol )
						WHEN TRANSACCION_INV.naturaleza = 'C' THEN -1*TRANSACCION_INV.costo_tot_fisc_dol
						ELSE 0 END )
					FROM	$$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
					WHERE	TRANSACCION_INV.articulo = @CodigoArticulo
						AND TRANSACCION_INV.tipo IN ( 'V', 'C', 'O', 'P', 'E', 'F', 'M', 'S' )
						AND TRANSACCION_INV.fecha >= @FechaReconstuye
				END
			END

			IF ( @TipoCosto = 'P' ) BEGIN
				IF ( @TipoDeFecha = 'A' ) BEGIN
					SELECT 	@DiferenciaExistencia = SUM ( 
						CASE 
						WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.cantidad ) 
						WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.cantidad ) 
						ELSE 0 END ),
						@DiferenciaValorLocal = SUM ( 
						CASE 
						WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_comp_loc )
						WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_comp_loc )
						WHEN TRANSACCION_INV.naturaleza = 'C' THEN -1*TRANSACCION_INV.costo_tot_comp_loc
						ELSE 0 END ),
						@DiferenciaValorDolar = SUM ( 
						CASE 
						WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_comp_dol )
						WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_comp_dol )
						WHEN TRANSACCION_INV.naturaleza = 'C' THEN -1*TRANSACCION_INV.costo_tot_comp_dol
						ELSE 0 END )
					FROM	$$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
					WHERE	TRANSACCION_INV.articulo = @CodigoArticulo
						AND TRANSACCION_INV.tipo IN ( 'V', 'C', 'O', 'P', 'E', 'F', 'M', 'S' )
						AND TRANSACCION_INV.fecha_hora_transac >= @FechaReconstuye
				END

				IF ( @TipoDeFecha = 'D' ) BEGIN
					SELECT 	@DiferenciaExistencia = SUM ( 
						CASE 
						WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.cantidad ) 
						WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.cantidad ) 
						ELSE 0 END ),
						@DiferenciaValorLocal = SUM ( 
						CASE 
						WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_comp_loc )
						WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_comp_loc )
						WHEN TRANSACCION_INV.naturaleza = 'C' THEN -1*TRANSACCION_INV.costo_tot_comp_loc
						ELSE 0 END ),
						@DiferenciaValorDolar = SUM ( 
						CASE 
						WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_comp_dol )
						WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_comp_dol )
						WHEN TRANSACCION_INV.naturaleza = 'C' THEN -1*TRANSACCION_INV.costo_tot_comp_dol
						ELSE 0 END )
					FROM	$$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
					WHERE	TRANSACCION_INV.articulo = @CodigoArticulo
						AND TRANSACCION_INV.tipo IN ( 'V', 'C', 'O', 'P', 'E', 'F', 'M', 'S' )
						AND TRANSACCION_INV.fecha >= @FechaReconstuye
				END
			END

			IF ((ISNULL(@ExistenciaActual,0) + ISNULL(@DiferenciaExistencia,0)) <> 0) BEGIN
				SET @ValorActualLocal = ((ISNULL(@ValorActualLocal,0) + ISNULL(@DiferenciaValorLocal,0))/(ISNULL(@ExistenciaActual,0) + ISNULL(@DiferenciaExistencia,0)))
				SET @ValorActualDolar = ((ISNULL(@ValorActualDolar,0) + ISNULL(@DiferenciaValorDolar,0))/(ISNULL(@ExistenciaActual,0) + ISNULL(@DiferenciaExistencia,0)))
			END

			IF ((ISNULL(@ExistenciaActual,0) + ISNULL(@DiferenciaExistencia,0)) = 0) BEGIN
				SET @ValorActualLocal = 0
				SET @ValorActualDolar = 0
			END
		END

		IF (  ( @TipoCosteoArticulo = 'U' OR @TipoCosteoArticulo = 'E' ) AND @TipoDeFecha = 'A' AND @FechaReconstuye >= @FechaActual ) BEGIN
			IF (ISNULL(@ExistenciaActual,0) <> 0) BEGIN
				SET @ValorActualLocal = ISNULL(@ValorActualLocal,0)/ISNULL(@ExistenciaActual,0)
				SET @ValorActualDolar = ISNULL(@ValorActualDolar,0)/ISNULL(@ExistenciaActual,0)
			END
			
			IF (ISNULL(@ExistenciaActual,0) = 0) BEGIN
				SET @ValorActualLocal = 0
				SET @ValorActualDolar = 0
			END
		END
	END

	IF (@MonedaCalculo = 'L') BEGIN SET @CostoUnitario = ISNULL(@ValorActualLocal,0) END
	IF (@MonedaCalculo = 'D') BEGIN SET @CostoUnitario = ISNULL(@ValorActualDolar,0) END

	RETURN @CostoUnitario
END;




CREATE FUNCTION $$COMPANIA$$.CantidadPorDespacharArticulo ( 
	@Calcular		AS VARCHAR(1),
	@TipoDeFecha		AS VARCHAR(1),
	@FechaReconstuye	AS DATETIME,
	@HorasAUtilizar		AS VARCHAR(1),
	@FechaActual		AS DATETIME,
	@CodigoArticulo		AS VARCHAR(20),
	@CodigoBodega		AS VARCHAR(4)
)
RETURNS DECIMAL(28,8) AS BEGIN
	RETURN 0
END
;

CREATE PROCEDURE $$COMPANIA$$.ReporteActividadVentas
	@TipoFecha VARCHAR(1),
	@ArticuloDesde VARCHAR(20),
	@ArticuloHasta VARCHAR(20),
	@BodegaDesde VARCHAR(4),
	@BodegaHasta VARCHAR(4),
	@FechaDesde DATETIME,
	@FechaHasta DATETIME,
	@Orden SMALLINT
AS
	SELECT	CASE ISNULL ( @Orden, 0 )
		WHEN 0 THEN ARTICULO.articulo
		WHEN 1 THEN ARTICULO.descripcion
		WHEN 2 THEN ARTICULO.clasificacion_1
		WHEN 3 THEN ARTICULO.clasificacion_2
		WHEN 4 THEN ARTICULO.clasificacion_3
		WHEN 5 THEN ARTICULO.clasificacion_4
		WHEN 6 THEN ARTICULO.clasificacion_5
		WHEN 7 THEN ARTICULO.clasificacion_6
		ELSE ARTICULO.articulo
		END AS Ordenamiento,
		ARTICULO.articulo, 
		ARTICULO.descripcion, 
		ARTICULO.tipo,
		ARTICULO.clasificacion_1,
		ARTICULO.clasificacion_2,
		ARTICULO.clasificacion_3,
		ARTICULO.clasificacion_4,
		ARTICULO.clasificacion_5,
		ARTICULO.clasificacion_6,
		ARTICULO.unidad_almacen,
		ARTICULO.factor_empaque,
		ARTICULO.unidad_empaque,
		ARTICULO.codigo_barras_invt,
		ARTICULO.codigo_barras_vent,
		ARTICULO.activo,
		ARTICULO.articulo_cuenta,
		ARTICULO.clase_abc,
		ARTICULO.proveedor,
		ARTICULO.tipo_cod_barra_alm,
		ARTICULO.tipo_cod_barra_det,
		ARTICULO.ultima_salida,
		ARTICULO.ultimo_ingreso,
		ARTICULO.ultimo_movimiento,
		ARTICULO.usa_lotes,
		ARTICULO.utilizado_manufact,
		ISNULL ( SUM ( CASE TRANSACCION_INV.naturaleza WHEN 'E' THEN 0 WHEN 'S' THEN TRANSACCION_INV.cantidad WHEN 'C' THEN 0 END ),0) AS CantidadSalidas,
		ISNULL ( SUM ( CASE TRANSACCION_INV.naturaleza WHEN 'E' THEN 0 WHEN 'S' THEN TRANSACCION_INV.costo_tot_comp_dol WHEN 'C' THEN 0 END ),0) AS CostoSalidasCompDol,
		ISNULL ( SUM ( CASE TRANSACCION_INV.naturaleza WHEN 'E' THEN 0 WHEN 'S' THEN TRANSACCION_INV.costo_tot_fisc_dol WHEN 'C' THEN 0 END ),0) AS CostoSalidasFiscDol,
		ISNULL ( SUM ( CASE TRANSACCION_INV.naturaleza WHEN 'E' THEN 0 WHEN 'S' THEN TRANSACCION_INV.costo_tot_comp_loc WHEN 'C' THEN 0 END ),0) AS CostoSalidasCompLoc,
		ISNULL ( SUM ( CASE TRANSACCION_INV.naturaleza WHEN 'E' THEN 0 WHEN 'S' THEN TRANSACCION_INV.costo_tot_fisc_loc WHEN 'C' THEN 0 END ),0) AS CostoSalidasFiscLoc,
		ISNULL ( SUM ( CASE TRANSACCION_INV.naturaleza WHEN 'E' THEN 0 WHEN 'S' THEN TRANSACCION_INV.precio_total_dolar WHEN 'C' THEN 0 END ),0) AS PrecioSalidasDol,
		ISNULL ( SUM ( CASE TRANSACCION_INV.naturaleza WHEN 'E' THEN 0 WHEN 'S' THEN TRANSACCION_INV.precio_total_local WHEN 'C' THEN 0 END ),0) AS PrecioSalidasLoc,
		ISNULL ( SUM ( CASE TRANSACCION_INV.naturaleza WHEN 'E' THEN TRANSACCION_INV.cantidad WHEN 'S' THEN 0 WHEN 'C' THEN 0 END ),0) AS CantidadEntradas,
		ISNULL ( SUM ( CASE TRANSACCION_INV.naturaleza WHEN 'E' THEN TRANSACCION_INV.costo_tot_comp_dol WHEN 'S' THEN 0 WHEN 'C' THEN 0 END ),0) AS CostoEntradasCompDol,
		ISNULL ( SUM ( CASE TRANSACCION_INV.naturaleza WHEN 'E' THEN TRANSACCION_INV.costo_tot_fisc_dol WHEN 'S' THEN 0 WHEN 'C' THEN 0 END ),0) AS CostoEntradasFiscDol,
		ISNULL ( SUM ( CASE TRANSACCION_INV.naturaleza WHEN 'E' THEN TRANSACCION_INV.costo_tot_comp_loc WHEN 'S' THEN 0 WHEN 'C' THEN 0 END ),0) AS CostoEntradasCompLoc,
		ISNULL ( SUM ( CASE TRANSACCION_INV.naturaleza WHEN 'E' THEN TRANSACCION_INV.costo_tot_fisc_loc WHEN 'S' THEN 0 WHEN 'C' THEN 0 END ),0) AS CostoEntradasFiscLoc,
		ISNULL ( SUM ( CASE TRANSACCION_INV.naturaleza WHEN 'E' THEN TRANSACCION_INV.precio_total_dolar WHEN 'S' THEN 0 WHEN 'C' THEN 0 END ),0) AS PrecioEntradasDol,
		ISNULL ( SUM ( CASE TRANSACCION_INV.naturaleza WHEN 'E' THEN TRANSACCION_INV.precio_total_local WHEN 'S' THEN 0 WHEN 'C' THEN 0 END ),0) AS PrecioEntradasLoc
	FROM	$$COMPANIA$$.TRANSACCION_INV TRANSACCION_INV (NOLOCK)
			RIGHT OUTER JOIN $$COMPANIA$$.ARTICULO ARTICULO (NOLOCK)
			ON	TRANSACCION_INV.articulo = ARTICULO.articulo
				AND TRANSACCION_INV.tipo = 'V'
				AND TRANSACCION_INV.bodega BETWEEN ISNULL(@BodegaDesde,'0') AND ISNULL(@BodegaHasta,'ZZZZ')
				AND ( 
					(	@TipoFecha = 'D' 
						AND TRANSACCION_INV.fecha BETWEEN ISNULL(@FechaDesde,CAST('1950-01-01' AS DATETIME)) AND ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME))
					)
					OR (	@TipoFecha = 'A' 
						AND TRANSACCION_INV.fecha_hora_transac BETWEEN ISNULL(@FechaDesde,CAST('1950-01-01' AS DATETIME)) AND ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) 
					)
				)
	WHERE	ARTICULO.articulo BETWEEN ISNULL(@ArticuloDesde,'0') AND ISNULL(@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
	GROUP BY CASE ISNULL ( @Orden, 0 )
		WHEN 0 THEN ARTICULO.articulo
		WHEN 1 THEN ARTICULO.descripcion
		WHEN 2 THEN ARTICULO.clasificacion_1
		WHEN 3 THEN ARTICULO.clasificacion_2
		WHEN 4 THEN ARTICULO.clasificacion_3
		WHEN 5 THEN ARTICULO.clasificacion_4
		WHEN 6 THEN ARTICULO.clasificacion_5
		WHEN 7 THEN ARTICULO.clasificacion_6
		ELSE ARTICULO.articulo
		END,
		ARTICULO.articulo,
		ARTICULO.descripcion,
		ARTICULO.tipo,
		ARTICULO.clasificacion_1,
		ARTICULO.clasificacion_2,
		ARTICULO.clasificacion_3,
		ARTICULO.clasificacion_4,
		ARTICULO.clasificacion_5,
		ARTICULO.clasificacion_6,
		ARTICULO.unidad_almacen,
		ARTICULO.factor_empaque,
		ARTICULO.unidad_empaque,
		ARTICULO.codigo_barras_invt,
		ARTICULO.codigo_barras_vent,
		ARTICULO.activo,
		ARTICULO.articulo_cuenta,
		ARTICULO.clase_abc,
		ARTICULO.proveedor,
		ARTICULO.tipo_cod_barra_alm,
		ARTICULO.tipo_cod_barra_det,
		ARTICULO.ultima_salida,
		ARTICULO.ultimo_ingreso,
		ARTICULO.ultimo_movimiento,
		ARTICULO.usa_lotes,
		ARTICULO.utilizado_manufact
	ORDER BY 1, 2;






CREATE PROCEDURE $$COMPANIA$$.ReporteExistenciasInventario
  @TipoFecha VARCHAR(1),
  @ArticuloDesde VARCHAR(20),
  @ArticuloHasta VARCHAR(20),
  @BodegaDesde VARCHAR(4),
  @BodegaHasta VARCHAR(4),
  @FechaFinal DATETIME,
  @Orden SMALLINT,
  @SoloConExistencia VARCHAR(1),
  @LocalizacionDesde     VARCHAR(8),
  @LocalizacionHasta     VARCHAR(8)
  AS
  /*La consulta es diferente si se ussan o no localizaciones.*/
  /*Si no se usan localizaciones*/
  if ((@LocalizacionDesde = '' AND @LocalizacionHasta = '' ) OR (@LocalizacionDesde IS NULL AND @LocalizacionHasta IS NULL )) 
  
   SELECT CASE ISNULL ( @Orden, 0 )
     WHEN 0 THEN ARTICULO.articulo
     WHEN 1 THEN ARTICULO.descripcion
     WHEN 2 THEN ARTICULO.clasificacion_1
     WHEN 3 THEN ARTICULO.clasificacion_2
     WHEN 4 THEN ARTICULO.clasificacion_3
     WHEN 5 THEN ARTICULO.clasificacion_4
     WHEN 6 THEN ARTICULO.clasificacion_5
     WHEN 7 THEN ARTICULO.clasificacion_6
     ELSE ARTICULO.articulo
     END AS ordenamiento,
     ARTICULO.articulo, 
     ARTICULO.descripcion, 
     ARTICULO.tipo,
     ARTICULO.clasificacion_1,
     ARTICULO.clasificacion_2,
     ARTICULO.clasificacion_3,
     ARTICULO.clasificacion_4,
     ARTICULO.clasificacion_5,
     ARTICULO.clasificacion_6,
     ARTICULO.unidad_almacen,
     ARTICULO.factor_empaque,
     ARTICULO.unidad_empaque,
     ARTICULO.codigo_barras_invt,
     ARTICULO.codigo_barras_vent,
     ARTICULO.activo,
     ARTICULO.articulo_cuenta,
     ARTICULO.clase_abc,
     ARTICULO.proveedor,
     ARTICULO.tipo_cod_barra_alm,
     ARTICULO.tipo_cod_barra_det,
     ARTICULO.ultima_salida,
     ARTICULO.ultimo_ingreso,
     ARTICULO.ultimo_movimiento,
     ARTICULO.usa_lotes,
     ARTICULO.utilizado_manufact,
     ARTICULO.existencia_minima AS articulo_exist_min,
     ARTICULO.existencia_maxima AS articulo_exist_max,
     ARTICULO.punto_de_reorden AS articulo_pto_reorden,
     EXISTENCIA_BODEGA.bodega,
     BODEGA.nombre AS bodega_descripcion,
     NULL AS Localizacion,
     EXISTENCIA_BODEGA.existencia_minima AS bodega_exist_min,
     EXISTENCIA_BODEGA.existencia_maxima AS bodega_exist_max,
     EXISTENCIA_BODEGA.punto_de_reorden AS bodega_pto_reorden,
     ISNULL(ISNULL ( CIERRE.CANT_DISPONIBLE, EXISTENCIA_BODEGA.cant_disponible),0) - ISNULL( EXISTENCIA.disponible,0) AS disponible, 
     ISNULL(ISNULL ( CIERRE.CANT_RESERVADA,EXISTENCIA_BODEGA.cant_reservada), 0) - ISNULL( EXISTENCIA.reservado,0) AS reservado,
     ISNULL(ISNULL ( CIERRE.CANT_VENCIDA, EXISTENCIA_BODEGA.cant_vencida), 0) - ISNULL( EXISTENCIA.vencido,0)  AS vencido,
     ISNULL(ISNULL ( CIERRE.CANT_NO_APROBADA, EXISTENCIA_BODEGA.cant_no_aprobada), 0) - ISNULL( EXISTENCIA.no_aprobada,0) AS no_aprobado,
     ISNULL(ISNULL ( CIERRE.CANT_REMITIDA,EXISTENCIA_BODEGA.cant_remitida), 0) - ISNULL( EXISTENCIA.remitida,0) AS remitido,
     ISNULL( EXISTENCIA_BODEGA.cant_transito, 0) AS transito
    FROM   $$COMPANIA$$.existencia_bodega EXISTENCIA_BODEGA (NOLOCK)
     LEFT JOIN (
      SELECT articulo,
     bodega , NULL AS Localizacion,
       SUM ( CASE
        WHEN TRANSACCION_INV.naturaleza = 'E' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'S' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        ELSE 0 END
       ) AS disponible,
       SUM ( CASE 
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        ELSE 0 END
       ) AS reservado,
       SUM ( CASE
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'N' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'N' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
        ELSE 0 END
       ) AS vencido,
       SUM ( CASE
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'A' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'A' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        ELSE 0 END
       ) AS no_aprobada,
       SUM ( CASE 
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        ELSE 0 END
       ) AS remitida
      FROM   $$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
      WHERE TRANSACCION_INV.tipo IN ( 'A', 'C', 'E', 'F', 'I', 'M', 'N', 'O', 'P', 'R', 'T', 'V' )
       AND TRANSACCION_INV.articulo BETWEEN ISNULL( @ArticuloDesde, '0') AND ISNULL( @ArticuloHasta, 'ZZZZZZZZZZZZZZZZZZZZ')
       AND TRANSACCION_INV.bodega BETWEEN ISNULL(@BodegaDesde,'0') AND ISNULL(@BodegaHasta,'ZZZZ')
       AND ( ( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > ISNULL(@FechaFinal,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
        OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > ISNULL(@FechaFinal,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
       )
       AND( ( @TipoFecha = 'D' AND    CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <=
                                           (SELECT     ISNULL(MAX(ec.fecha_cierre), CAST('2050-12-31 23:59:59.998' AS DATETIME))
                                           FROM    $$COMPANIA$$.existencia_cierre ec
                                           WHERE TRANSACCION_INV.ARTICULO = ec.ARTICULO
                                           AND ec.TIPO_FECHA = @TipoFecha 
                                           AND ec.FECHA_CIERRE >= @FechaFinal) )
        OR (  @TipoFecha = 'A' AND    CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha_hora_transac AS CHAR),1,11) AS DATETIME) <=
                                           (SELECT     ISNULL(MAX(ec.fecha_cierre), CAST('2050-12-31 23:59:59.998' AS DATETIME))
                                           FROM    $$COMPANIA$$.existencia_cierre ec
                                           WHERE TRANSACCION_INV.ARTICULO = ec.ARTICULO
                                           AND ec.TIPO_FECHA = @TipoFecha
                                           AND ec.FECHA_CIERRE >= @FechaFinal) )
       ) 
      GROUP BY articulo, bodega
     ) EXISTENCIA
      ON EXISTENCIA_BODEGA.articulo = EXISTENCIA.articulo 
      AND EXISTENCIA_BODEGA.bodega = EXISTENCIA.bodega
     INNER JOIN   $$COMPANIA$$.bodega BODEGA (NOLOCK)
      ON EXISTENCIA_BODEGA.bodega = BODEGA.bodega
     INNER JOIN   $$COMPANIA$$.articulo ARTICULO (NOLOCK)
      ON EXISTENCIA_BODEGA.articulo = ARTICULO.articulo
     LEFT JOIN (SELECT ARTICULO,BODEGA,CANT_DISPONIBLE,CANT_RESERVADA, CANT_NO_APROBADA,CANT_VENCIDA,CANT_REMITIDA,TIPO_COSTO,COSTO_FISC_UNT_LOC, COSTO_FISC_UNT_DOL,FECHA_CIERRE
                      FROM    $$COMPANIA$$.EXISTENCIA_CIERRE A
                      WHERE FECHA_CIERRE = ( SELECT MAX(fecha_cierre)
                                              FROM   $$COMPANIA$$.EXISTENCIA_CIERRE B
                                              WHERE A.ARTICULO = B.ARTICULO
                                              AND A.FECHA_CIERRE >= @FechaFinal ) 
                                              AND A.TIPO_FECHA = @TipoFecha) CIERRE
      ON EXISTENCIA_BODEGA.articulo = CIERRE.articulo 
         AND EXISTENCIA_BODEGA.bodega = CIERRE.bodega 
    WHERE ( @SoloConExistencia = 'N'
      OR ( @SoloConExistencia = 'S' 
      AND (   ( ISNULL( ISNULL(CIERRE.CANT_DISPONIBLE, EXISTENCIA_BODEGA.cant_disponible), 0) - ISNULL( EXISTENCIA.disponible, 0) )
       + ( ISNULL( ISNULL(CIERRE.CANT_RESERVADA, EXISTENCIA_BODEGA.cant_reservada), 0) - ISNULL( EXISTENCIA.reservado, 0) )
       + ( ISNULL( ISNULL(CIERRE.CANT_VENCIDA, EXISTENCIA_BODEGA.cant_vencida), 0) - ISNULL( EXISTENCIA.vencido, 0) )
       + ( ISNULL( ISNULL(CIERRE.CANT_NO_APROBADA, EXISTENCIA_BODEGA.cant_no_aprobada), 0) - ISNULL( EXISTENCIA.no_aprobada, 0) )
       + ( ISNULL( ISNULL(CIERRE.CANT_REMITIDA, EXISTENCIA_BODEGA.cant_remitida), 0) - ISNULL( EXISTENCIA.remitida, 0) ) ) <> 0
     ) )
     AND ARTICULO.tipo IN ('T','M','E','R','U','C','B','D','Q')
     AND ARTICULO.articulo BETWEEN ISNULL (@ArticuloDesde,'0') AND ISNULL (@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
     AND EXISTENCIA_BODEGA.bodega BETWEEN ISNULL(@BodegaDesde,'0') AND ISNULL(@BodegaHasta,'ZZZZ')
  ORDER BY 1, 2, 30
  
  /*La consulta es diferente si se ussan o no localizaciones.*/
  /*Si se usan localizaciones*/
else
SELECT CASE ISNULL ( @Orden, 0 )
  WHEN 0 THEN ARTICULO.articulo
  WHEN 1 THEN ARTICULO.descripcion
  WHEN 2 THEN ARTICULO.clasificacion_1
  WHEN 3 THEN ARTICULO.clasificacion_2
  WHEN 4 THEN ARTICULO.clasificacion_3
  WHEN 5 THEN ARTICULO.clasificacion_4
  WHEN 6 THEN ARTICULO.clasificacion_5
  WHEN 7 THEN ARTICULO.clasificacion_6
  ELSE ARTICULO.articulo
  END AS ordenamiento,
  ARTICULO.articulo, 
  ARTICULO.descripcion, 
  ARTICULO.tipo,
  ARTICULO.clasificacion_1,
  ARTICULO.clasificacion_2,
  ARTICULO.clasificacion_3,
  ARTICULO.clasificacion_4,
  ARTICULO.clasificacion_5,
  ARTICULO.clasificacion_6,
  ARTICULO.unidad_almacen,
  ARTICULO.factor_empaque,
  ARTICULO.unidad_empaque,
  ARTICULO.codigo_barras_invt,
  ARTICULO.codigo_barras_vent,
  ARTICULO.activo,
  ARTICULO.articulo_cuenta,
  ARTICULO.clase_abc,
  ARTICULO.proveedor,
  ARTICULO.tipo_cod_barra_alm,
  ARTICULO.tipo_cod_barra_det,
  ARTICULO.ultima_salida,
  ARTICULO.ultimo_ingreso,
  ARTICULO.ultimo_movimiento,
  ARTICULO.usa_lotes,
  ARTICULO.utilizado_manufact,
  ARTICULO.existencia_minima AS articulo_exist_min,
  ARTICULO.existencia_maxima AS articulo_exist_max,
  ARTICULO.punto_de_reorden AS articulo_pto_reorden,
  EXISTENCIA_BODEGA.bodega,
  BODEGA.nombre AS bodega_descripcion,
  existencia_lote_rec.localizacion AS localizacion,
  EXISTENCIA_BODEGA.existencia_minima AS bodega_exist_min,
  EXISTENCIA_BODEGA.existencia_maxima AS bodega_exist_max,
  EXISTENCIA_BODEGA.punto_de_reorden AS bodega_pto_reorden,
   ISNULL(ISNULL ( ISNULL ( CIERRE.CANT_DISPONIBLE, existencia_lote_rec.cant_disponible),EXISTENCIA_BODEGA.CANT_DISPONIBLE),0) - ISNULL( EXISTENCIA.disponible,0) AS disponible, 
   ISNULL(ISNULL ( ISNULL ( CIERRE.CANT_RESERVADA,existencia_lote_rec.cant_reservada), EXISTENCIA_BODEGA.cant_reservada),0) - ISNULL( EXISTENCIA.reservado,0) AS reservado,
   ISNULL(ISNULL ( ISNULL (CIERRE.CANT_VENCIDA, existencia_lote_rec.cant_vencida), EXISTENCIA_BODEGA.cant_vencida),0) - ISNULL( EXISTENCIA.vencido,0) AS vencido,
   ISNULL(ISNULL ( ISNULL ( CIERRE.CANT_NO_APROBADA, existencia_lote_rec.cant_no_aprobada), EXISTENCIA_BODEGA.cant_no_aprobada),0) - ISNULL( EXISTENCIA.no_aprobada,0) AS no_aprobado,
   ISNULL(ISNULL ( ISNULL ( CIERRE.CANT_REMITIDA,existencia_lote_rec.cant_remitida), EXISTENCIA_BODEGA.cant_remitida),0) - ISNULL( EXISTENCIA.remitida,0) AS remitido,
   ISNULL( EXISTENCIA_BODEGA.cant_transito, 0) AS transito
  FROM   $$COMPANIA$$.existencia_bodega EXISTENCIA_BODEGA (NOLOCK)
    left JOIN   (SELECT ARTICULO,BODEGA, LOCALIZACION,SUM(CANT_DISPONIBLE) CANT_DISPONIBLE , SUM(CANT_RESERVADA) CANT_RESERVADA,SUM(CANT_NO_APROBADA) CANT_NO_APROBADA,SUM(CANT_VENCIDA) CANT_VENCIDA,SUM(CANT_REMITIDA) CANT_REMITIDA
 from $$COMPANIA$$.existencia_lote (NOLOCK)
 Group by ARTICULO,BODEGA, LOCALIZACION) existencia_lote_rec
     ON  EXISTENCIA_BODEGA.bodega = existencia_lote_rec.bodega
     AND EXISTENCIA_BODEGA.articulo = existencia_lote_rec.articulo
 LEFT JOIN (
  SELECT articulo,
  bodega,
  localizacion,
  SUM ( CASE
  WHEN TRANSACCION_INV.naturaleza = 'E' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'S' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  ELSE 0 END
  ) AS disponible,
  SUM ( CASE 
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  ELSE 0 END
  ) AS reservado,
  SUM ( CASE
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'N' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'N' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
  ELSE 0 END
  ) AS vencido,
  SUM ( CASE
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'A' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'A' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  ELSE 0 END
  ) AS no_aprobada,
  SUM ( CASE 
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  ELSE 0 END
  ) AS remitida
  FROM   $$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
  WHERE TRANSACCION_INV.tipo IN ( 'A', 'C', 'E', 'F', 'I', 'M', 'N', 'O', 'P', 'R', 'T', 'V' )
  AND TRANSACCION_INV.articulo BETWEEN ISNULL( @ArticuloDesde, '0') AND ISNULL( @ArticuloHasta, 'ZZZZZZZZZZZZZZZZZZZZ')
  AND TRANSACCION_INV.bodega BETWEEN ISNULL(@BodegaDesde,'0') AND ISNULL(@BodegaHasta,'ZZZZ')
  AND  TRANSACCION_INV.LOCALIZACION BETWEEN   @LocalizacionDesde AND @LocalizacionHasta
  AND ( ( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > ISNULL(@FechaFinal,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > ISNULL(@FechaFinal,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
  )
  AND( ( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <=
  (SELECT ISNULL(MAX(ec.fecha_cierre), CAST('2050-12-31 23:59:59.998' AS DATETIME))
  FROM   $$COMPANIA$$.existencia_cierre ec
  WHERE TRANSACCION_INV.ARTICULO = ec.ARTICULO
  AND ec.TIPO_FECHA = @TipoFecha 
  AND ec.FECHA_CIERRE >= @FechaFinal) )
  OR ( @TipoFecha = 'A' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha_hora_transac AS CHAR),1,11) AS DATETIME) <=
  (SELECT ISNULL(MAX(ec.fecha_cierre), CAST('2050-12-31 23:59:59.998' AS DATETIME))
  FROM   $$COMPANIA$$.existencia_cierre ec
  WHERE TRANSACCION_INV.ARTICULO = ec.ARTICULO
  AND ec.TIPO_FECHA = @TipoFecha
  AND ec.FECHA_CIERRE >= @FechaFinal) )
  ) 
  GROUP BY articulo, bodega, localizacion
  ) EXISTENCIA
  ON  EXISTENCIA_BODEGA.articulo = EXISTENCIA.articulo 
  AND EXISTENCIA_BODEGA.bodega = EXISTENCIA.bodega
  and existencia_lote_rec.LOCALIZACION= EXISTENCIA.LOCALIZACION
INNER JOIN   $$COMPANIA$$.bodega BODEGA (NOLOCK)
  ON EXISTENCIA_BODEGA.bodega = BODEGA.bodega
  INNER JOIN   $$COMPANIA$$.articulo ARTICULO (NOLOCK)
  ON EXISTENCIA_BODEGA.articulo = ARTICULO.articulo
  LEFT JOIN (SELECT ARTICULO,BODEGA,CANT_DISPONIBLE,CANT_RESERVADA, CANT_NO_APROBADA,CANT_VENCIDA,CANT_REMITIDA,TIPO_COSTO,COSTO_FISC_UNT_LOC, COSTO_FISC_UNT_DOL,FECHA_CIERRE
  FROM   $$COMPANIA$$.EXISTENCIA_CIERRE A
  WHERE FECHA_CIERRE = ( SELECT MAX(fecha_cierre)
  FROM   $$COMPANIA$$.EXISTENCIA_CIERRE B
  WHERE A.ARTICULO = B.ARTICULO
  AND A.FECHA_CIERRE >= @FechaFinal ) 
  AND A.TIPO_FECHA = @TipoFecha) CIERRE
  ON EXISTENCIA_BODEGA.articulo = CIERRE.articulo 
  AND EXISTENCIA_BODEGA.bodega = CIERRE.bodega 
  WHERE ( @SoloConExistencia = 'N'
  OR ( @SoloConExistencia = 'S' 
  AND ( ( ISNULL( ISNULL(CIERRE.CANT_DISPONIBLE, EXISTENCIA_BODEGA.cant_disponible), 0) - ISNULL( EXISTENCIA.disponible, 0) )
  + ( ISNULL( ISNULL(CIERRE.CANT_RESERVADA, EXISTENCIA_BODEGA.cant_reservada), 0) - ISNULL( EXISTENCIA.reservado, 0) )
  + ( ISNULL( ISNULL(CIERRE.CANT_VENCIDA, EXISTENCIA_BODEGA.cant_vencida), 0) - ISNULL( EXISTENCIA.vencido, 0) )
  + ( ISNULL( ISNULL(CIERRE.CANT_NO_APROBADA, EXISTENCIA_BODEGA.cant_no_aprobada), 0) - ISNULL( EXISTENCIA.no_aprobada, 0) )
  + ( ISNULL( ISNULL(CIERRE.CANT_REMITIDA, EXISTENCIA_BODEGA.cant_remitida), 0) - ISNULL( EXISTENCIA.remitida, 0) ) ) <> 0
  ) )
  AND ARTICULO.tipo IN ('T','M','E','R','U','C','B','D','Q')
  AND ARTICULO.articulo BETWEEN ISNULL (@ArticuloDesde,'0') AND ISNULL (@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
  AND EXISTENCIA_BODEGA.bodega BETWEEN ISNULL(@BodegaDesde,'0') AND ISNULL(@BodegaHasta,'ZZZZ')
   and existencia_lote_rec.LOCALIZACION BETWEEN   @LocalizacionDesde AND @LocalizacionHasta
ORDER BY 1, 2, 30;

  

CREATE PROCEDURE $$COMPANIA$$.ReporteValoracionInventario
 @TipoFecha VARCHAR(1),
 @ArticuloDesde VARCHAR(20),
 @ArticuloHasta VARCHAR(20),
 @BodegaDesde VARCHAR(4),
 @BodegaHasta VARCHAR(4),
 @FechaFinal DATETIME,
 @Orden SMALLINT,
 @CalcularCostos VARCHAR(1),
 @TipoCosto VARCHAR(1),
 @MonedaCalculo VARCHAR(1),
 @SoloConExistencia VARCHAR(1),
 @ConDisponible VARCHAR(1),
 @ConReservado VARCHAR(1),
 @ConNoAprobado VARCHAR(1),
 @ConVencido VARCHAR(1),
 @ConRemitido VARCHAR(1),
 @ConTransito VARCHAR(1),
 @ConPorDespachar VARCHAR(1),
 @LocalizacionDesde VARCHAR(8),
 @LocalizacionHasta VARCHAR(8)
 AS
  /*La consulta es diferente si se ussan o no localizaciones.*/
  /*Si no se usan localizaciones*/
IF ((@LocalizacionDesde = '' AND @LocalizacionHasta = '' ) OR (@LocalizacionDesde IS NULL AND @LocalizacionHasta IS NULL ))  
 
  SELECT CASE ISNULL ( @Orden, 0 )
   WHEN 0 THEN ARTICULO.articulo
   WHEN 1 THEN ARTICULO.descripcion
   WHEN 2 THEN ARTICULO.clasificacion_1
   WHEN 3 THEN ARTICULO.clasificacion_2
   WHEN 4 THEN ARTICULO.clasificacion_3
   WHEN 5 THEN ARTICULO.clasificacion_4
   WHEN 6 THEN ARTICULO.clasificacion_5
   WHEN 7 THEN ARTICULO.clasificacion_6
   ELSE ARTICULO.articulo
   END AS ordenamiento,
   ARTICULO.articulo, 
   ARTICULO.descripcion, 
   ARTICULO.tipo,
   ARTICULO.clasificacion_1,
   ARTICULO.clasificacion_2,
   ARTICULO.clasificacion_3,
   ARTICULO.clasificacion_4,
   ARTICULO.clasificacion_5,
   ARTICULO.clasificacion_6,
   ARTICULO.unidad_almacen,
   ARTICULO.factor_empaque,
   ARTICULO.unidad_empaque,
   ARTICULO.codigo_barras_invt,
   ARTICULO.codigo_barras_vent,
   ARTICULO.activo,
   ARTICULO.articulo_cuenta,
   ARTICULO.clase_abc,
   ARTICULO.proveedor,
   ARTICULO.tipo_cod_barra_alm,
   ARTICULO.tipo_cod_barra_det,
   ARTICULO.ultima_salida,
   ARTICULO.ultimo_ingreso,
   ARTICULO.ultimo_movimiento,
   ARTICULO.usa_lotes,
   ARTICULO.utilizado_manufact,
   ARTICULO.existencia_minima AS articulo_exist_min,
   EXISTENCIA_BODEGA.bodega,
   BODEGA.nombre AS bodega_descripcion,
   NULL AS Localizacion,
   EXISTENCIA_BODEGA.existencia_minima AS bodega_exist_min,
   (CASE WHEN @ConDisponible = 'S' THEN ISNULL (EXISTENCIA_BODEGA.cant_disponible,0) - ISNULL(EXISTENCIA.disponible,0) ELSE 0 END ) AS disponible, 
   (CASE WHEN @ConReservado = 'S' THEN ISNULL (EXISTENCIA_BODEGA.cant_reservada,0) - ISNULL(EXISTENCIA.reservado,0) ELSE 0 END ) AS reservado,
   (CASE WHEN @ConVencido = 'S' THEN ISNULL ( EXISTENCIA_BODEGA.cant_vencida,0) - ISNULL(EXISTENCIA.vencido,0) ELSE 0 END ) AS vencido,
   (CASE WHEN @ConNoAprobado = 'S' THEN ISNULL ( EXISTENCIA_BODEGA.cant_no_aprobada,0) - ISNULL(EXISTENCIA.no_aprobada,0) ELSE 0 END ) AS no_aprobado,
   (CASE WHEN @ConRemitido = 'S' THEN ISNULL ( EXISTENCIA_BODEGA.cant_remitida,0) - ISNULL(EXISTENCIA.remitida,0) ELSE 0 END ) AS remitido,
   (CASE WHEN @ConTransito = 'S' THEN ISNULL ( EXISTENCIA_BODEGA.cant_transito, 0 ) ELSE 0 END ) AS transito,
   (CASE WHEN @ConPorDespachar = 'S' THEN 
     $$COMPANIA$$.CantidadPorDespacharArticulo ( @ConPorDespachar, @TipoFecha, @FechaFinal, 'F', GETDATE(), ARTICULO.articulo, EXISTENCIA_BODEGA.bodega )
    ELSE 0 END ) AS por_despachar,
   (CASE WHEN @CalcularCostos = 'S' 
    AND (((CASE WHEN @ConDisponible = 'S' THEN ISNULL ( EXISTENCIA_BODEGA.cant_disponible - ISNULL(EXISTENCIA.disponible,0),0) ELSE 0 END )
     + (CASE WHEN @ConReservado = 'S' THEN ISNULL ( EXISTENCIA_BODEGA.cant_reservada - ISNULL(EXISTENCIA.reservado,0),0) ELSE 0 END )
     + (CASE WHEN @ConVencido = 'S' THEN ISNULL ( EXISTENCIA_BODEGA.cant_vencida - ISNULL(EXISTENCIA.vencido,0),0) ELSE 0 END )
     + (CASE WHEN @ConNoAprobado = 'S' THEN ISNULL ( EXISTENCIA_BODEGA.cant_no_aprobada - ISNULL(EXISTENCIA.no_aprobada,0),0) ELSE 0 END )
     + (CASE WHEN @ConRemitido = 'S' THEN ISNULL ( EXISTENCIA_BODEGA.cant_remitida - ISNULL(EXISTENCIA.remitida,0),0) ELSE 0 END ) ) <> 0)
   THEN  $$COMPANIA$$.CostoUnitarioArticuloBodega(
    @CalcularCostos,
    @TipoFecha,
    @FechaFinal,
    'F',
    @TipoCosto,
    @MonedaCalculo,
    GETDATE(),
    ARTICULO.articulo,
    ARTICULO.costo_fiscal,
    ARTICULO.costo_comparativo,
    ARTICULO.costo_std_loc,
    ARTICULO.costo_std_dol,
    ARTICULO.costo_prom_loc,
    ARTICULO.costo_prom_dol,
    ARTICULO.costo_ult_loc,
    ARTICULO.costo_ult_dol,
    EXISTENCIA_BODEGA.BODEGA ) 
   ELSE 0 END )AS costo_unitario
  FROM  $$COMPANIA$$.existencia_bodega EXISTENCIA_BODEGA (NOLOCK)
   LEFT JOIN (
    SELECT articulo,
   bodega, 
   NULL AS Localizacion,
     SUM ( CASE
      WHEN TRANSACCION_INV.naturaleza = 'E' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
      WHEN TRANSACCION_INV.naturaleza = 'S' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
      ELSE 0 END
     ) AS disponible,
     SUM ( CASE 
      WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
      WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
      WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
      WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
      ELSE 0 END
     ) AS reservado,
     SUM ( CASE
      WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'N' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
      WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
      WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'N' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
      WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
      ELSE 0 END
     ) AS vencido,
     SUM ( CASE
      WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'A' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
      WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
      WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'A' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
      WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
      ELSE 0 END
     ) AS no_aprobada,
     SUM ( CASE 
      WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
      WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
      WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
      WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
      ELSE 0 END
     ) AS remitida
    FROM  $$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
    WHERE TRANSACCION_INV.tipo IN ( 'A', 'C', 'E', 'F', 'I', 'M', 'N', 'O', 'P', 'R', 'T', 'V' )
     AND TRANSACCION_INV.articulo BETWEEN ISNULL (@ArticuloDesde,'0') AND ISNULL (@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
     AND TRANSACCION_INV.bodega BETWEEN ISNULL(@BodegaDesde,'0') AND ISNULL(@BodegaHasta,'ZZZZ')
     AND ( ( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > ISNULL(@FechaFinal,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
      OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > ISNULL(@FechaFinal,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
     )
    GROUP BY articulo, bodega
   ) EXISTENCIA
    ON EXISTENCIA_BODEGA.articulo = EXISTENCIA.articulo 
    AND EXISTENCIA_BODEGA.bodega = EXISTENCIA.bodega
   INNER JOIN  $$COMPANIA$$.bodega BODEGA (NOLOCK)
    ON EXISTENCIA_BODEGA.bodega = BODEGA.bodega
   INNER JOIN  $$COMPANIA$$.articulo ARTICULO (NOLOCK)
    ON EXISTENCIA_BODEGA.articulo = ARTICULO.articulo
   LEFT JOIN (SELECT ARTICULO,BODEGA,CANT_DISPONIBLE,CANT_RESERVADA, CANT_NO_APROBADA,CANT_VENCIDA,CANT_REMITIDA,TIPO_COSTO,COSTO_FISC_UNT_LOC, COSTO_FISC_UNT_DOL,FECHA_CIERRE
                    FROM   $$COMPANIA$$.EXISTENCIA_CIERRE A
                    WHERE FECHA_CIERRE = ( SELECT MAX(fecha_cierre)
                                            FROM  $$COMPANIA$$.EXISTENCIA_CIERRE B
                                            WHERE A.ARTICULO = B.ARTICULO
                                            AND A.FECHA_CIERRE >= @FechaFinal
                                            AND a.TIPO_FECHA = @TipoFecha ) )CIERRE
    ON EXISTENCIA_BODEGA.articulo = CIERRE.articulo 
       AND EXISTENCIA_BODEGA.bodega = CIERRE.bodega
  WHERE ( @SoloConExistencia = 'N'
    OR ( @SoloConExistencia = 'S' 
    AND (((CASE WHEN @ConDisponible = 'S' THEN ISNULL ( EXISTENCIA_BODEGA.cant_disponible,0) - ISNULL(EXISTENCIA.disponible,0) ELSE 0 END )
     + (CASE WHEN @ConReservado = 'S' THEN ISNULL ( EXISTENCIA_BODEGA.cant_reservada,0) - ISNULL(EXISTENCIA.reservado,0) ELSE 0 END )
     + (CASE WHEN @ConVencido = 'S' THEN ISNULL ( EXISTENCIA_BODEGA.cant_vencida,0) - ISNULL(EXISTENCIA.vencido,0) ELSE 0 END )
     + (CASE WHEN @ConNoAprobado = 'S' THEN ISNULL (EXISTENCIA_BODEGA.cant_no_aprobada,0) - ISNULL(EXISTENCIA.no_aprobada,0) ELSE 0 END )
     + (CASE WHEN @ConRemitido = 'S' THEN ISNULL ( EXISTENCIA_BODEGA.cant_remitida,0) - ISNULL(EXISTENCIA.remitida,0) ELSE 0 END ) ) <> 0
   ) ) )
   AND ARTICULO.tipo IN ('T','M','E','R','U','C','B','D','Q')
   AND ARTICULO.articulo BETWEEN ISNULL (@ArticuloDesde,'0') AND ISNULL (@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
   AND EXISTENCIA_BODEGA.bodega BETWEEN ISNULL(@BodegaDesde,'0') AND ISNULL(@BodegaHasta,'ZZZZ')
  ORDER BY 1, 2, 28
  
 ELSE
 /*La consulta es diferente si se ussan o no localizaciones.*/
 /*Si  se usan localizaciones*/
  SELECT CASE ISNULL ( @Orden, 0 )
 WHEN 0 THEN ARTICULO.articulo
 WHEN 1 THEN ARTICULO.descripcion
 WHEN 2 THEN ARTICULO.clasificacion_1
 WHEN 3 THEN ARTICULO.clasificacion_2
 WHEN 4 THEN ARTICULO.clasificacion_3
 WHEN 5 THEN ARTICULO.clasificacion_4
 WHEN 6 THEN ARTICULO.clasificacion_5
 WHEN 7 THEN ARTICULO.clasificacion_6
 ELSE ARTICULO.articulo
 END AS ordenamiento,
 ARTICULO.articulo, 
 ARTICULO.descripcion, 
 ARTICULO.tipo,
 ARTICULO.clasificacion_1,
 ARTICULO.clasificacion_2,
 ARTICULO.clasificacion_3,
 ARTICULO.clasificacion_4,
 ARTICULO.clasificacion_5,
 ARTICULO.clasificacion_6,
 ARTICULO.unidad_almacen,
 ARTICULO.factor_empaque,
 ARTICULO.unidad_empaque,
 ARTICULO.codigo_barras_invt,
 ARTICULO.codigo_barras_vent,
 ARTICULO.activo,
 ARTICULO.articulo_cuenta,
 ARTICULO.clase_abc,
 ARTICULO.proveedor,
 ARTICULO.tipo_cod_barra_alm,
 ARTICULO.tipo_cod_barra_det,
 ARTICULO.ultima_salida,
 ARTICULO.ultimo_ingreso,
 ARTICULO.ultimo_movimiento,
 ARTICULO.usa_lotes,
 ARTICULO.utilizado_manufact,
 ARTICULO.existencia_minima AS articulo_exist_min,
 EXISTENCIA_BODEGA.bodega,
 BODEGA.nombre AS bodega_descripcion,
 existencia_lote_rec.localizacion,
 EXISTENCIA_BODEGA.existencia_minima AS bodega_exist_min,
 (CASE WHEN @ConDisponible = 'S' THEN ISNULL (ISNULL (existencia_lote_rec.cant_disponible,EXISTENCIA_BODEGA.cant_disponible),0) - ISNULL(EXISTENCIA.disponible,0) ELSE 0 END ) AS disponible, 
 (CASE WHEN @ConReservado = 'S' THEN ISNULL (ISNULL (existencia_lote_rec.cant_reservada,EXISTENCIA_BODEGA.cant_reservada),0) - ISNULL(EXISTENCIA.reservado,0) ELSE 0 END ) AS reservado,
 (CASE WHEN @ConVencido = 'S' THEN ISNULL (ISNULL ( existencia_lote_rec.cant_vencida,EXISTENCIA_BODEGA.cant_vencida),0) - ISNULL(EXISTENCIA.vencido,0) ELSE 0 END ) AS vencido,
 (CASE WHEN @ConNoAprobado = 'S' THEN ISNULL (ISNULL ( existencia_lote_rec.cant_no_aprobada,EXISTENCIA_BODEGA.cant_no_aprobada),0) - ISNULL(EXISTENCIA.no_aprobada,0) ELSE 0 END ) AS no_aprobado,
 (CASE WHEN @ConRemitido = 'S' THEN ISNULL (ISNULL ( existencia_lote_rec.cant_remitida,EXISTENCIA_BODEGA.cant_remitida ),0) - ISNULL(EXISTENCIA.remitida,0) ELSE 0 END ) AS remitido,
 (CASE WHEN @ConTransito = 'S' THEN ISNULL ( EXISTENCIA_BODEGA.cant_transito, 0 ) ELSE 0 END ) AS transito,
 (CASE WHEN @ConPorDespachar = 'S' THEN 
  $$COMPANIA$$.CantidadPorDespacharArticulo ( @ConPorDespachar, @TipoFecha, @FechaFinal, 'F', GETDATE(), ARTICULO.articulo, EXISTENCIA_BODEGA.bodega )
 ELSE 0 END ) AS por_despachar,
 (CASE WHEN @CalcularCostos = 'S' 
 AND (((CASE WHEN @ConDisponible = 'S' THEN ISNULL ( ISNULL ( existencia_lote_rec.cant_disponible, EXISTENCIA_BODEGA.cant_disponible),0) - ISNULL(EXISTENCIA.disponible,0) ELSE 0 END )
 + (CASE WHEN @ConReservado = 'S' THEN ISNULL (ISNULL ( existencia_lote_rec.cant_reservada, EXISTENCIA_BODEGA.cant_reservada),0) - ISNULL(EXISTENCIA.reservado,0) ELSE 0 END )
 + (CASE WHEN @ConVencido = 'S' THEN ISNULL (ISNULL ( existencia_lote_rec.cant_vencida , EXISTENCIA_BODEGA.cant_vencida),0)- ISNULL(EXISTENCIA.vencido,0) ELSE 0 END )
 + (CASE WHEN @ConNoAprobado = 'S' THEN ISNULL (ISNULL ( existencia_lote_rec.cant_no_aprobada, EXISTENCIA_BODEGA.cant_no_aprobada),0) - ISNULL(EXISTENCIA.no_aprobada,0) ELSE 0 END )
 + (CASE WHEN @ConRemitido = 'S' THEN ISNULL (ISNULL ( existencia_lote_rec.cant_remitida , EXISTENCIA_BODEGA.cant_remitida),0)- ISNULL(EXISTENCIA.remitida,0) ELSE 0 END ) ) <> 0)
 THEN  $$COMPANIA$$.CostoUnitarioArticuloBodega(
 @CalcularCostos,
 @TipoFecha,
 @FechaFinal,
 'F',
 @TipoCosto,
 @MonedaCalculo,
 GETDATE(),
 ARTICULO.articulo,
 ARTICULO.costo_fiscal,
 ARTICULO.costo_comparativo,
 ARTICULO.costo_std_loc,
 ARTICULO.costo_std_dol,
 ARTICULO.costo_prom_loc,
 ARTICULO.costo_prom_dol,
 ARTICULO.costo_ult_loc,
 ARTICULO.costo_ult_dol,
 EXISTENCIA_BODEGA.BODEGA ) 
 ELSE 0 END )AS costo_unitario
 FROM  $$COMPANIA$$.existencia_bodega EXISTENCIA_BODEGA (NOLOCK)
 LEFT JOIN  (SELECT ARTICULO,BODEGA, LOCALIZACION,SUM(CANT_DISPONIBLE) CANT_DISPONIBLE , SUM(CANT_RESERVADA) CANT_RESERVADA,SUM(CANT_NO_APROBADA) CANT_NO_APROBADA,SUM(CANT_VENCIDA) CANT_VENCIDA,SUM(CANT_REMITIDA) CANT_REMITIDA
 from $$COMPANIA$$.existencia_lote (NOLOCK)
 Group by ARTICULO,BODEGA, LOCALIZACION) existencia_lote_rec
    ON EXISTENCIA_BODEGA.bodega = existencia_lote_rec.bodega
    and EXISTENCIA_BODEGA.articulo = existencia_lote_rec.articulo
    and  existencia_lote_rec.LOCALIZACION BETWEEN   @LocalizacionDesde AND @LocalizacionHasta
 LEFT JOIN (
 SELECT articulo,
 bodega,
 localizacion,
 SUM ( CASE
 WHEN TRANSACCION_INV.naturaleza = 'E' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
 WHEN TRANSACCION_INV.naturaleza = 'S' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
 ELSE 0 END
 ) AS disponible,
 SUM ( CASE 
 WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
 WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
 WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
 WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
 ELSE 0 END
 ) AS reservado,
 SUM ( CASE
 WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'N' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
 WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
 WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'N' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
 WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
 ELSE 0 END
 ) AS vencido,
 SUM ( CASE
 WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'A' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
 WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
 WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'A' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
 WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
 ELSE 0 END
 ) AS no_aprobada,
 SUM ( CASE 
 WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
 WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
 WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
 WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
 ELSE 0 END
 ) AS remitida
 FROM  $$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
 WHERE TRANSACCION_INV.tipo IN ( 'A', 'C', 'E', 'F', 'I', 'M', 'N', 'O', 'P', 'R', 'T', 'V' )
 AND TRANSACCION_INV.articulo BETWEEN ISNULL (@ArticuloDesde,'0') AND ISNULL (@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
 AND TRANSACCION_INV.bodega BETWEEN ISNULL(@BodegaDesde,'0') AND ISNULL(@BodegaHasta,'ZZZZ')
 and  TRANSACCION_INV.LOCALIZACION BETWEEN   @LocalizacionDesde AND @LocalizacionHasta
 AND ( ( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > ISNULL(@FechaFinal,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
 OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > ISNULL(@FechaFinal,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
 )
 GROUP BY articulo, bodega
 ,localizacion
 ) EXISTENCIA
 ON EXISTENCIA_BODEGA.articulo = EXISTENCIA.articulo 
 AND EXISTENCIA_BODEGA.bodega = EXISTENCIA.bodega
  AND existencia_lote_rec.LOCALIZACION = EXISTENCIA.localizacion
 LEFT JOIN  $$COMPANIA$$.localizacion LOCALIZACION (NOLOCK)
    ON existencia_lote_rec.bodega = LOCALIZACION.bodega
    and existencia_lote_rec.localizacion = LOCALIZACION.localizacion
     and existencia_lote_rec.LOCALIZACION BETWEEN   @LocalizacionDesde AND @LocalizacionHasta
INNER JOIN  $$COMPANIA$$.bodega BODEGA (NOLOCK)
 ON EXISTENCIA_BODEGA.bodega = BODEGA.bodega
 INNER JOIN  $$COMPANIA$$.articulo ARTICULO (NOLOCK)
 ON EXISTENCIA_BODEGA.articulo = ARTICULO.articulo
 LEFT JOIN (SELECT ARTICULO,BODEGA,CANT_DISPONIBLE,CANT_RESERVADA, CANT_NO_APROBADA,CANT_VENCIDA,CANT_REMITIDA,TIPO_COSTO,COSTO_FISC_UNT_LOC, COSTO_FISC_UNT_DOL,FECHA_CIERRE
 FROM  $$COMPANIA$$.EXISTENCIA_CIERRE A
 WHERE FECHA_CIERRE = ( SELECT MAX(fecha_cierre)
 FROM  $$COMPANIA$$.EXISTENCIA_CIERRE B
 WHERE A.ARTICULO = B.ARTICULO
 AND A.FECHA_CIERRE >= @FechaFinal
 AND a.TIPO_FECHA = @TipoFecha ) )CIERRE
 ON EXISTENCIA_BODEGA.articulo = CIERRE.articulo 
 AND EXISTENCIA_BODEGA.bodega = CIERRE.bodega
 WHERE ( @SoloConExistencia = 'N'
 OR ( @SoloConExistencia = 'S' 
 AND (((CASE WHEN @ConDisponible = 'S' THEN ISNULL (ISNULL ( existencia_lote_rec.cant_disponible,EXISTENCIA_BODEGA.cant_disponible),0) - ISNULL(EXISTENCIA.disponible,0) ELSE 0 END )
 + (CASE WHEN @ConReservado = 'S' THEN ISNULL (ISNULL ( existencia_lote_rec.cant_reservada,EXISTENCIA_BODEGA.cant_reservada),0) - ISNULL(EXISTENCIA.reservado,0) ELSE 0 END )
 + (CASE WHEN @ConVencido = 'S' THEN ISNULL (ISNULL ( existencia_lote_rec.cant_vencida,EXISTENCIA_BODEGA.cant_vencida),0) - ISNULL(EXISTENCIA.vencido,0) ELSE 0 END )
 + (CASE WHEN @ConNoAprobado = 'S' THEN ISNULL (ISNULL (EXISTENCIA_BODEGA.cant_no_aprobada,EXISTENCIA_BODEGA.cant_no_aprobada),0) - ISNULL(EXISTENCIA.no_aprobada,0) ELSE 0 END )
 + (CASE WHEN @ConRemitido = 'S' THEN ISNULL (ISNULL ( existencia_lote_rec.cant_remitida,EXISTENCIA_BODEGA.cant_remitida),0) - ISNULL(EXISTENCIA.remitida,0) ELSE 0 END ) ) <> 0
 ) ) )
 AND ARTICULO.tipo IN ('T','M','E','R','U','C','B','D','Q')
 AND ARTICULO.articulo BETWEEN ISNULL (@ArticuloDesde,'0') AND ISNULL (@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
 AND EXISTENCIA_BODEGA.bodega BETWEEN ISNULL(@BodegaDesde,'0') AND ISNULL(@BodegaHasta,'ZZZZ')
 and  existencia_lote_rec.LOCALIZACION BETWEEN  @LocalizacionDesde AND @LocalizacionHasta
 ORDER BY 1, 2, 28;  
 
 
CREATE FUNCTION $$COMPANIA$$.Rotacioninventario (@CalcularCostos     AS VARCHAR(1), 
                                            @ArticuloDesde      AS VARCHAR(20), 
                                            @ArticuloHasta      AS VARCHAR(20), 
                                            @BodegaDesde        AS VARCHAR(4), 
                                            @BodegaHasta        AS VARCHAR(4), 
                                            @FechaDesde         AS DATETIME, 
                                            @FechaHasta         AS DATETIME, 
                                            @TipoFecha          AS VARCHAR(1), 
                                            @SoloConMovimientos AS VARCHAR(1), 
                                            @FechaActual        AS DATETIME, 
                                            @MonedaCalculo      AS VARCHAR(1), 
                                            @TipoCosto          AS VARCHAR(1), 
                                            @TipoRotacion       AS VARCHAR(1), 
                                            @NumeroDiasPeriodo  AS DECIMAL(28, 8), 
                                            @NumeroDiasAnno     AS DECIMAL(28, 8), 
                                            @IncluyeVentas      AS VARCHAR(1), 
                                            @IncluyeConsumos    AS VARCHAR(1), 
                                            @ConDisponible      AS VARCHAR(1), 
                                            @ConReservado       AS VARCHAR(1), 
                                            @ConNoAprobado      AS VARCHAR(1), 
                                            @ConVencido         AS VARCHAR(1), 
                                            @ConRemitido        AS VARCHAR(1), 
                                            @ConTransito        AS VARCHAR(1), 
                                            @LocalizacionDesde  VARCHAR(8), 
                                            @LocalizacionHasta  VARCHAR(8)) 
returns @RotacionInventario TABLE ( 
  articulo             VARCHAR(20) NOT NULL, 
  cantidad_existencia  DECIMAL(28, 8) NULL, 
  costo_existencia     DECIMAL(28, 8) NULL, 
  cantidad_unidades    DECIMAL(28, 8) NULL, 
  costo_unidades       DECIMAL(28, 8) NULL, 
  cant_rot_periodo     DECIMAL(28, 8) NULL, 
  cant_rot_anualizada  DECIMAL(28, 8) NULL, 
  costo_rot_periodo    DECIMAL(28, 8) NULL, 
  costo_rot_anualizada DECIMAL(28, 8) NULL, 
  conteo_transacciones DECIMAL(28, 0) NULL ) 
AS 
  BEGIN 
      DECLARE @CodigoArticulo 			VARCHAR(20) 
      DECLARE @DifExistInicial 			DECIMAL(28, 8) 
      DECLARE @DifExistFinal 			DECIMAL(28, 8) 
      DECLARE @ExistenciaActual 		DECIMAL(28, 8) 
      DECLARE @UnidadesPeriodo 			DECIMAL(28, 8) 
      DECLARE @CostoUnitarioInicial 	DECIMAL(28, 8) 
      DECLARE @CostoUnitarioFinal 		DECIMAL(28, 8) 
      DECLARE @CostoUnidades 			DECIMAL(28, 8) 
      DECLARE @ConteoTransacciones 		DECIMAL(28, 0) 
      DECLARE @CantidadExistencia 		DECIMAL(28, 8) 
      DECLARE @CostoExistencia 			DECIMAL(28, 8) 
      DECLARE @CantidadRotPeriodo 		DECIMAL(28, 8) 
      DECLARE @CantidadRotAnualizada 	DECIMAL(28, 8) 
      DECLARE @CostoRotPeriodo 			DECIMAL(28, 8) 
      DECLARE @CostoRotAnualizada 		DECIMAL(28, 8) 
      DECLARE @FechaFinalAux 			DATETIME 
      DECLARE @FechaInicialAux 			DATETIME 
      DECLARE @CostoFinalAux 			DECIMAL(28, 8) 
      DECLARE @CostoInicialAux 			DECIMAL(28, 8) 
      DECLARE @ExistenciaFinalAux 		DECIMAL(28, 8) 
      DECLARE @ExistenciaInicialAux 	DECIMAL(28, 8) 
      DECLARE @DiferenciaExistencia 	DECIMAL(28, 8) 
      DECLARE @CantidadPeriodos 		DECIMAL(28, 0) 
      DECLARE @CantidadDiasRango 		DECIMAL(28, 0) 
      DECLARE @CostoUndIntermedio 		DECIMAL(28, 0) 
      DECLARE @TerminarCiclo 			VARCHAR(1) 
  /*La consulta es diferente si se ussan o no localizaciones*/
  /*Si no se usan localizaciones*/
IF ((@LocalizacionDesde = '' AND @LocalizacionHasta = '' ) OR (@LocalizacionDesde IS NULL AND @LocalizacionHasta IS NULL )) 
    BEGIN
    DECLARE Reconstruccion CURSOR FOR
    SELECT    ARTICULO.articulo,
        TRANSACCIONES.dif_existencia_ini,
        TRANSACCIONES.dif_existencia_fin,
        EXISTENCIA_ACTUAL.existencia_actual,
        TRANSACCIONES.unidades_periodo,
        CASE WHEN @CalcularCostos = 'S' AND @TipoRotacion <> 'F' THEN
              $$COMPANIA$$.CostoUnitarioArticulo(
                'S',
                @TipoFecha,
                @FechaDesde,
                'I',
                @TipoCosto,
                @MonedaCalculo,
                @FechaActual,
                ARTICULO.articulo,
                ARTICULO.costo_fiscal,
                ARTICULO.costo_comparativo,
                ARTICULO.costo_std_loc,
                ARTICULO.costo_std_dol,
                ARTICULO.costo_prom_loc,
                ARTICULO.costo_prom_dol,
                ARTICULO.costo_ult_loc,
                ARTICULO.costo_ult_dol 
            ) 
        ELSE 0 END
        AS costo_unitario_ini,
        CASE WHEN @CalcularCostos = 'S' AND @TipoRotacion <> 'I' THEN
              $$COMPANIA$$.CostoUnitarioArticulo(
                'S',
                @TipoFecha,
                @FechaHasta,
                'F',
                @TipoCosto,
                @MonedaCalculo,
                @FechaActual,
                ARTICULO.articulo,
                ARTICULO.costo_fiscal,
                ARTICULO.costo_comparativo,
                ARTICULO.costo_std_loc,
                ARTICULO.costo_std_dol,
                ARTICULO.costo_prom_loc,
                ARTICULO.costo_prom_dol,
                ARTICULO.costo_ult_loc,
                ARTICULO.costo_ult_dol )
        ELSE 0 END
        AS costo_unitario_fin,
        CASE    WHEN @MonedaCalculo = 'L' AND @TipoCosto = 'F' THEN TRANSACCIONES.costo_fisc_loc_unds
            WHEN @MonedaCalculo = 'L' AND @TipoCosto = 'C' THEN TRANSACCIONES.costo_comp_loc_unds
            WHEN @MonedaCalculo = 'D' AND @TipoCosto = 'F' THEN TRANSACCIONES.costo_fisc_dol_unds
            WHEN @MonedaCalculo = 'D' AND @TipoCosto = 'C' THEN TRANSACCIONES.costo_comp_dol_unds
            ELSE 0 END
        AS costo_unidades,
        TRANSACCIONES.conteo_movimientos
    FROM   $$COMPANIA$$.articulo ARTICULO (NOLOCK)
        LEFT JOIN
    /*Transacciones*/
    (    SELECT    TRANSACCION_INV.articulo AS articulo,
            ISNULL ( (
                SUM (    CASE WHEN @ConDisponible = 'S'
                    THEN    CASE
                        WHEN TRANSACCION_INV.naturaleza = 'E' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        WHEN TRANSACCION_INV.naturaleza = 'S' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        ELSE 0 END
                    ELSE 0 END 
                ) +
                SUM (    CASE WHEN @ConReservado = 'S'
                    THEN    CASE 
                        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
                        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        ELSE 0 END
                    ELSE 0 END 
                ) +
                SUM (    CASE WHEN @ConVencido = 'S' 
                    THEN    CASE
                        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'N' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
                        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'N' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
                        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
                        ELSE 0 END
                    ELSE 0 END 
                ) +
                SUM (    CASE WHEN @ConNoAprobado = 'S'
                    THEN    CASE
                        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'A' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'A' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
                        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        ELSE 0 END
                    ELSE 0 END 
                ) +
                SUM (    CASE WHEN @ConRemitido = 'S'
                    THEN    CASE 
                        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        ELSE 0 END
                    ELSE 0 END 
                )
            ), 0 ) AS dif_existencia_ini,
            ISNULL ( (
                SUM (    CASE WHEN @ConDisponible = 'S' AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
                     OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
                    ) 
                    THEN    CASE
                        WHEN TRANSACCION_INV.naturaleza = 'E' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        WHEN TRANSACCION_INV.naturaleza = 'S' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        ELSE 0 END
                    ELSE 0 END 
                ) +
                SUM (    CASE WHEN @ConReservado = 'S' AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
                     OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
                    ) 
                    THEN    CASE 
                        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
                        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        ELSE 0 END
                    ELSE 0 END 
                ) +
                SUM (    CASE WHEN @ConVencido = 'S' AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
                     OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
                    ) 
                    THEN    CASE
                        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'N' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
                        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'N' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
                        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
                        ELSE 0 END
                    ELSE 0 END 
                ) +
                SUM (    CASE WHEN @ConNoAprobado = 'S' AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
                     OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
                    ) 
                    THEN    CASE
                        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'A' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'A' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
                        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        ELSE 0 END
                    ELSE 0 END 
                ) +
                SUM (    CASE WHEN @ConRemitido = 'S' AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
                     OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
                    ) 
                    THEN    CASE 
                        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                        ELSE 0 END
                    ELSE 0 END 
                )
            ), 0 ) AS dif_existencia_fin,
            ISNULL ( (
                SUM (    CASE WHEN 
                    (( @IncluyeVentas = 'S' AND TRANSACCION_INV.tipo = 'V' ) OR ( @IncluyeConsumos = 'S' AND TRANSACCION_INV.tipo = 'C' ))
                    AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
                     OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
                    )
                    THEN    CASE WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.cantidad )
                        WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.cantidad )
                        ELSE 0 END
                    ELSE 0 END )
                )
            , 0 ) AS unidades_periodo,
            ISNULL ( (
                SUM (    CASE WHEN 
                    (( @IncluyeVentas = 'S' AND TRANSACCION_INV.tipo = 'V' ) OR ( @IncluyeConsumos = 'S' AND TRANSACCION_INV.tipo = 'C' ))
                    AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
                     OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
                    )
                    THEN    CASE WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_fisc_loc )
                        WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_fisc_loc )
                        ELSE 0 END
                    ELSE 0 END )
            ), 0 ) AS costo_fisc_loc_unds,
            ISNULL ( (
                SUM (    CASE WHEN 
                    (( @IncluyeVentas = 'S' AND TRANSACCION_INV.tipo = 'V' ) OR ( @IncluyeConsumos = 'S' AND TRANSACCION_INV.tipo = 'C' ))
                    AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
                     OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
                    )
                    THEN    CASE WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_fisc_dol )
                        WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_fisc_dol )
                        ELSE 0 END
                    ELSE 0 END )
            ), 0 ) AS costo_fisc_dol_unds,
            ISNULL ( (
                SUM (    CASE WHEN 
                    (( @IncluyeVentas = 'S' AND TRANSACCION_INV.tipo = 'V' ) OR ( @IncluyeConsumos = 'S' AND TRANSACCION_INV.tipo = 'C' ))
                    AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
                     OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
                    )
                    THEN    CASE WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_comp_loc )
                        WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_comp_loc )
                        ELSE 0 END
                    ELSE 0 END )
            ), 0 ) AS costo_comp_loc_unds,
            ISNULL ( (
                SUM (    CASE WHEN 
                    (( @IncluyeVentas = 'S' AND TRANSACCION_INV.tipo = 'V' ) OR ( @IncluyeConsumos = 'S' AND TRANSACCION_INV.tipo = 'C' ))
                    AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
                     OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
                    )
                    THEN    CASE WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_comp_dol )
                        WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_comp_dol )
                        ELSE 0 END
                    ELSE 0 END )
            ), 0 ) AS costo_comp_dol_unds,
            ISNULL ( (
                SUM (    CASE WHEN 
                    (( @IncluyeVentas = 'S' AND TRANSACCION_INV.tipo = 'V' ) OR ( @IncluyeConsumos = 'S' AND TRANSACCION_INV.tipo = 'C' ))
                    AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
                     OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
                    )
                    THEN 1 ELSE 0 END )
            ), 0 ) AS conteo_movimientos
        FROM      $$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
        WHERE    TRANSACCION_INV.tipo <> 'S'
            AND TRANSACCION_INV.articulo BETWEEN ISNULL (@ArticuloDesde,'0') AND ISNULL (@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
            AND TRANSACCION_INV.bodega BETWEEN ISNULL(@BodegaDesde,'0') AND ISNULL(@BodegaHasta,'ZZZZ')
            AND ( ( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) >= ISNULL(@FechaDesde,CAST('1980-01-01 00:00:00.000' AS DATETIME)) )
                OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac >= ISNULL(@FechaDesde,CAST('1980-01-01 00:00:00.000' AS DATETIME)) )
            )
        GROUP BY TRANSACCION_INV.articulo
        HAVING ( @SoloConMovimientos = 'N' OR ( @SoloConMovimientos = 'S' 
                AND ISNULL ( (
                SUM (    CASE WHEN 
                    (( @IncluyeVentas = 'S' AND TRANSACCION_INV.tipo = 'V' ) OR ( @IncluyeConsumos = 'S' AND TRANSACCION_INV.tipo = 'C' ))
                    AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
                     OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ) 
                    )
                    THEN 1 ELSE 0 END 
                )), 0 ) > 0 ) ) 
    ) TRANSACCIONES
        ON ARTICULO.articulo = TRANSACCIONES.articulo
   /*Existencias Actuales*/
        LEFT JOIN
    (    SELECT    EXISTENCIA_BODEGA.articulo AS articulo,
            SUM (
                CASE WHEN @ConDisponible = 'S' THEN EXISTENCIA_BODEGA.cant_disponible ELSE 0 END
                + CASE WHEN @ConReservado = 'S' THEN EXISTENCIA_BODEGA.cant_reservada ELSE 0 END
                + CASE WHEN @ConRemitido = 'S' THEN EXISTENCIA_BODEGA.cant_remitida ELSE 0 END
                + CASE WHEN @ConNoAprobado = 'S' THEN EXISTENCIA_BODEGA.cant_no_aprobada ELSE 0 END
                + CASE WHEN @ConVencido = 'S' THEN EXISTENCIA_BODEGA.cant_vencida ELSE 0 END
                + CASE WHEN @ConTransito = 'S' THEN EXISTENCIA_BODEGA.cant_transito ELSE 0 END
            )
            AS existencia_actual
        FROM      $$COMPANIA$$.existencia_bodega EXISTENCIA_BODEGA (NOLOCK)
        WHERE    EXISTENCIA_BODEGA.articulo BETWEEN ISNULL (@ArticuloDesde,'0') AND ISNULL (@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
            AND EXISTENCIA_BODEGA.bodega BETWEEN ISNULL(@BodegaDesde,'0') AND ISNULL(@BodegaHasta,'ZZZZ')
        GROUP BY EXISTENCIA_BODEGA.articulo
    ) EXISTENCIA_ACTUAL
        ON ARTICULO.articulo = EXISTENCIA_ACTUAL.articulo
    WHERE    ARTICULO.articulo BETWEEN ISNULL (@ArticuloDesde,'0') AND ISNULL (@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
        AND ( @SoloConMovimientos = 'N' OR ( @SoloConMovimientos = 'S' AND TRANSACCIONES.conteo_movimientos > 0 ) )

    OPEN Reconstruccion
    IF (ABS(@@CURSOR_ROWS)) > 0 BEGIN
        SET @CantidadDiasRango = ISNULL( DATEDIFF(DAY, @FechaDesde, @FechaHasta), 0 )
        FETCH NEXT FROM Reconstruccion 
            INTO @CodigoArticulo, @DifExistInicial, @DifExistFinal, @ExistenciaActual, @UnidadesPeriodo, @CostoUnitarioInicial, @CostoUnitarioFinal, @CostoUnidades, @ConteoTransacciones
        SET @ExistenciaInicialAux = 0
        SET @CostoFinalAux = 0
        SET @CostoExistencia = 0
        WHILE @@FETCH_STATUS >= 0 BEGIN
            IF ( @TipoRotacion = 'N' ) BEGIN
                IF ( ISNULL(@ConteoTransacciones,0) > 0 ) BEGIN
                    SET @FechaFinalAux = CAST(SUBSTRING(CAST(ISNULL(DATEADD( DAY, -1, @FechaDesde ),'1980-01-01') AS CHAR),1,11)+' 23:59:59.998' AS DATETIME)
                    SET @CostoFinalAux = ISNULL(@CostoUnitarioInicial,0)
                    SET @CantidadPeriodos = 0
                    SET @TerminarCiclo = 'N'
                    SET @ExistenciaFinalAux = ISNULL(@ExistenciaActual,0) - ISNULL(@DifExistInicial,0)
                    SET @CantidadExistencia = 0

                    WHILE @TerminarCiclo <> 'S' BEGIN
                        SET @ExistenciaInicialAux = @ExistenciaFinalAux
                        SET @CostoInicialAux = @CostoFinalAux
                        SET @FechaInicialAux = @FechaFinalAux
                        SET @FechaFinalAux = CAST(SUBSTRING(CAST(DATEADD( DAY, @NumeroDiasPeriodo, @FechaInicialAux ) AS CHAR),1,11)+' 23:59:59.998' AS DATETIME)

                        SET @CantidadPeriodos = @CantidadPeriodos+1

                        IF ( @FechaFinalAux >= @FechaHasta ) BEGIN
                            SET @TerminarCiclo = 'S'
                            SET @FechaFinalAux = @FechaHasta
                            SET @CostoFinalAux = @CostoUnitarioFinal
                            SET @ExistenciaFinalAux = ISNULL(@ExistenciaActual,0) - ISNULL(@DifExistFinal,0)
                        END
                        ELSE BEGIN
                            SET @DiferenciaExistencia = 0
                            SELECT    @CostoFinalAux = 
                                CASE WHEN @CalcularCostos = 'S' THEN
                                      $$COMPANIA$$.CostoUnitarioArticulo(
                                        'S',
                                        @TipoFecha,
                                        @FechaFinalAux,
                                        'F',
                                        @TipoCosto,
                                        @MonedaCalculo,
                                        @FechaActual,
                                        ARTICULO.articulo,
                                        ARTICULO.costo_fiscal,
                                        ARTICULO.costo_comparativo,
                                        ARTICULO.costo_std_loc,
                                        ARTICULO.costo_std_dol,
                                        ARTICULO.costo_prom_loc,
                                        ARTICULO.costo_prom_dol,
                                        ARTICULO.costo_ult_loc,
                                        ARTICULO.costo_ult_dol )
                                ELSE 0 END,
                                @DiferenciaExistencia = ISNULL( DIFERENCIA_EXISTENCIA.diferencia,0)
                            FROM      $$COMPANIA$$.articulo ARTICULO (NOLOCK)
                                LEFT JOIN
                                ( 
                                    SELECT    TRANSACCION_INV.articulo AS articulo,
                                        ISNULL ( (
                                            SUM (    CASE WHEN @ConDisponible = 'S'
                                                THEN    CASE
                                                    WHEN TRANSACCION_INV.naturaleza = 'E' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                                                    WHEN TRANSACCION_INV.naturaleza = 'S' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                                                    ELSE 0 END
                                                ELSE 0 END 
                                            ) +
                                            SUM (    CASE WHEN @ConReservado = 'S'
                                                THEN    CASE 
                                                    WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                                                    WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
                                                    WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                                                    WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                                                    ELSE 0 END
                                                ELSE 0 END 
                                            ) +
                                            SUM (    CASE WHEN @ConVencido = 'S' 
                                                THEN    CASE
                                                    WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'N' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                                                    WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
                                                    WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'N' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
                                                    WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
                                                    ELSE 0 END
                                                ELSE 0 END 
                                            ) +
                                            SUM (    CASE WHEN @ConNoAprobado = 'S'
                                                THEN    CASE
                                                    WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'A' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                                                    WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                                                    WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'A' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
                                                    WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                                                    ELSE 0 END
                                                ELSE 0 END 
                                            ) +
                                            SUM (    CASE WHEN @ConRemitido = 'S'
                                                THEN    CASE 
                                                    WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                                                    WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                                                    WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                                                    WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
                                                    ELSE 0 END
                                                ELSE 0 END 
                                            )
                                        ), 0 ) AS diferencia
                                    FROM      $$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
                                    WHERE    TRANSACCION_INV.tipo <> 'S'
                                        AND TRANSACCION_INV.articulo = @CodigoArticulo
                                        AND TRANSACCION_INV.bodega BETWEEN ISNULL(@BodegaDesde,'0') AND ISNULL(@BodegaHasta,'ZZZZ')
                                        AND ( ( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > @FechaInicialAux    AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= @FechaFinalAux )
                                            OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > @FechaInicialAux AND TRANSACCION_INV.fecha_hora_transac <= @FechaFinalAux )
                                        )
                                    GROUP BY TRANSACCION_INV.articulo
                                ) DIFERENCIA_EXISTENCIA
                                    ON ARTICULO.articulo = DIFERENCIA_EXISTENCIA.articulo
                            WHERE    ARTICULO.articulo = @CodigoArticulo
                                AND DIFERENCIA_EXISTENCIA.articulo = @CodigoArticulo


                            SET @CostoFinalAux = ISNULL(@CostoFinalAux,0)
                            SET @DiferenciaExistencia = ISNULL(@DiferenciaExistencia,0)
                            SET @ExistenciaFinalAux = ISNULL(@ExistenciaFinalAux + @DiferenciaExistencia, 0)
                        END

                        SET @CantidadExistencia = ISNULL(@CantidadExistencia,0) + ( ISNULL(@ExistenciaInicialAux,0) + ISNULL(@ExistenciaFinalAux,0) ) / 2
                        SET @CostoExistencia = ISNULL(@CostoExistencia,0) + ( ISNULL(@CostoUnitarioInicial,0)*ISNULL(@ExistenciaInicialAux,0) + ISNULL(@CostoUnitarioFinal,0)*ISNULL(@ExistenciaFinalAux,0) ) / 2
                    END

                    IF (@CantidadPeriodos > 0) BEGIN 
                        SET @CantidadExistencia = @CantidadExistencia/@CantidadPeriodos 
                        SET @CostoExistencia = @CostoExistencia/@CantidadPeriodos 
                    END
                    ELSE BEGIN 
                        SET @CantidadExistencia = 0 
                        SET @CostoExistencia = 0 
                    END
                END
                ELSE BEGIN 
                    SET @CantidadExistencia = 0 
                    SET @CostoExistencia = 0 
                END
            END
            ELSE BEGIN
                IF ( @TipoRotacion = 'I' ) BEGIN 
                    SET @CostoUnitarioFinal = @CostoUnitarioInicial
                    SET @DifExistFinal = @DifExistInicial
                END
                IF ( @TipoRotacion = 'F' ) BEGIN 
                    SET @CostoUnitarioInicial = @CostoUnitarioFinal 
                    SET @DifExistInicial = @DifExistFinal
                END

                SET @ExistenciaInicialAux = ISNULL (@ExistenciaActual,0) - ISNULL ( @DifExistInicial, 0)
                SET @ExistenciaFinalAux = ISNULL (@ExistenciaActual,0) - ISNULL ( @DifExistFinal, 0)

                SET @CantidadExistencia = ( ISNULL(@ExistenciaInicialAux,0) + ISNULL(@ExistenciaFinalAux,0) ) / 2
                SET @CostoExistencia = ( ISNULL(@CostoUnitarioInicial,0)*ISNULL(@ExistenciaInicialAux,0) + ISNULL(@CostoUnitarioFinal,0)*ISNULL(@ExistenciaFinalAux,0) ) / 2
            END

            SET @CantidadRotPeriodo = 0
            SET @CantidadRotAnualizada = 0
            SET @CostoRotPeriodo = 0
            SET @CostoRotAnualizada = 0

            IF ( @CantidadExistencia > 0 ) BEGIN 
                SET @CantidadRotPeriodo = ISNULL((@UnidadesPeriodo/@CantidadExistencia),0) 
            END

            IF ( @CantidadDiasRango > 0 ) BEGIN 
                SET @CantidadRotAnualizada = ISNULL(((@CantidadRotPeriodo*@NumeroDiasAnno)/@CantidadDiasRango),0) 
            END

            IF ( @CostoExistencia > 0 ) BEGIN 
                SET @CostoRotPeriodo = ISNULL((@CostoUnidades/@CostoExistencia),0) 
            END

            IF ( @CantidadDiasRango > 0 ) BEGIN 
                SET @CostoRotAnualizada = ISNULL(((@CostoRotPeriodo*@NumeroDiasAnno)/@CantidadDiasRango),0) 
            END

            INSERT INTO @RotacionInventario ( articulo, cantidad_existencia, costo_existencia, cantidad_unidades, costo_unidades, cant_rot_periodo, cant_rot_anualizada, costo_rot_periodo, costo_rot_anualizada, conteo_transacciones )
            VALUES ( @CodigoArticulo, @CantidadExistencia, @CostoExistencia, @UnidadesPeriodo, @CostoUnidades, @CantidadRotPeriodo, @CantidadRotAnualizada, @CostoRotPeriodo, @CostoRotAnualizada, @ConteoTransacciones )

            FETCH NEXT FROM Reconstruccion 
                INTO @CodigoArticulo, @DifExistInicial, @DifExistFinal, @ExistenciaActual, @UnidadesPeriodo, @CostoUnitarioInicial, @CostoUnitarioFinal, @CostoUnidades, @ConteoTransacciones
        END
    END
    CLOSE Reconstruccion
    DEALLOCATE Reconstruccion
    
    END
 /*La consulta es diferente si se ussan o no localizaciones*/
 /*Si  se usan localizaciones*/
     ELSE
     BEGIN
     DECLARE reconstruccion CURSOR FOR 
        SELECT articulo.articulo, 
               TRANSACCIONES.dif_existencia_ini, 
               TRANSACCIONES.dif_existencia_fin, 
               EXISTENCIA_ACTUAL.existencia_actual, 
               TRANSACCIONES.unidades_periodo, 
               CASE 
                 WHEN @CalcularCostos = 'S' 
                      AND @TipoRotacion <> 'F' THEN 
                   $$COMPANIA$$.Costounitarioarticulo('S', @TipoFecha, @FechaDesde, 'I', 
                 @TipoCosto, 
                 @MonedaCalculo, @FechaActual, articulo.articulo, 
                 articulo.costo_fiscal, 
                 articulo.costo_comparativo, articulo.costo_std_loc, 
                 articulo.costo_std_dol, 
                 articulo.costo_prom_loc, articulo.costo_prom_dol, 
                 articulo.costo_ult_loc, 
                 articulo.costo_ult_dol) 
                 ELSE 0 
               END AS costo_unitario_ini, 
               CASE 
                 WHEN @CalcularCostos = 'S' 
                      AND @TipoRotacion <> 'I' THEN 
                   $$COMPANIA$$.Costounitarioarticulo('S', @TipoFecha, @FechaHasta, 'F', 
                 @TipoCosto, 
                 @MonedaCalculo, @FechaActual, articulo.articulo, 
                 articulo.costo_fiscal, 
                 articulo.costo_comparativo, articulo.costo_std_loc, 
                 articulo.costo_std_dol, 
                 articulo.costo_prom_loc, articulo.costo_prom_dol, 
                 articulo.costo_ult_loc, 
                 articulo.costo_ult_dol) 
                 ELSE 0 
               END AS costo_unitario_fin, 
               CASE 
                 WHEN @MonedaCalculo = 'L' 
                      AND @TipoCosto = 'F' THEN 
                 TRANSACCIONES.costo_fisc_loc_unds 
                 WHEN @MonedaCalculo = 'L' 
                      AND @TipoCosto = 'C' THEN 
                 TRANSACCIONES.costo_comp_loc_unds 
                 WHEN @MonedaCalculo = 'D' 
                      AND @TipoCosto = 'F' THEN 
                 TRANSACCIONES.costo_fisc_dol_unds 
                 WHEN @MonedaCalculo = 'D' 
                      AND @TipoCosto = 'C' THEN 
                 TRANSACCIONES.costo_comp_dol_unds 
                 ELSE 0 
               END AS costo_unidades, 
               TRANSACCIONES.conteo_movimientos 
        FROM     $$COMPANIA$$.articulo ARTICULO(nolock) 
               LEFT JOIN (SELECT transaccion_inv.articulo AS articulo, 
                             Isnull((Sum( 
                                 CASE WHEN @ConDisponible = 'S' THEN 
                                 CASE WHEN transaccion_inv.naturaleza ='E' 
                                     AND ( transaccion_inv.tipo = 'R' 
                                     OR transaccion_inv.tipo ='A' 
                                     OR transaccion_inv.subtipo = 'D' ) THEN Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                    WHEN transaccion_inv.naturaleza = 'S' 
                                    AND ( transaccion_inv.tipo = 'R' 
                                    OR transaccion_inv.tipo = 'A' 
                                    OR transaccion_inv.subtipo = 'D' ) THEN 
                                    -Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                    ELSE 0 
                                 END ELSE 0 
                                 END ) 
                             + Sum( 
                                 CASE 
                                 WHEN @ConReservado = 'S'THEN 
                                     CASE 
                                         WHEN transaccion_inv.naturaleza = 'S' 
                                         AND transaccion_inv.tipo = 'R' THEN Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                        WHEN transaccion_inv.naturaleza = 'E' 
                                        AND transaccion_inv.tipo <> 'R' 
                                        AND  transaccion_inv.subtipo = 'R' THEN Abs(Isnull(transaccion_inv.cantidad,0)) 
                                        WHEN transaccion_inv.naturaleza = 'E' 
                                        AND transaccion_inv.tipo = 'R' THEN - Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                        WHEN  transaccion_inv.naturaleza = 'S' 
                                        AND transaccion_inv.tipo <> 'R' 
                                        AND transaccion_inv.subtipo = 'R' THEN  -Abs(Isnull(transaccion_inv.cantidad, 0))                                    ELSE 0 
                                    END 
                                 ELSE 0 
                                 END 
                      ) + Sum( 
                          CASE 
                              WHEN @ConVencido = 'S' THEN 
                             CASE 
                                WHEN transaccion_inv.naturaleza = 'S' 
                                AND transaccion_inv.tipo = 'N' THEN Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                WHEN  transaccion_inv.naturaleza = 'E' 
                                AND transaccion_inv.tipo <> 'N' 
                                AND transaccion_inv.subtipo = 'V' THEN Abs(Isnull(transaccion_inv.cantidad,0)) 
                                WHEN transaccion_inv.naturaleza = 'E' 
                                AND transaccion_inv.tipo ='N' THEN - Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                WHEN transaccion_inv.naturaleza = 'S' 
                                AND transaccion_inv.tipo <> 'N' 
                                AND transaccion_inv.subtipo = 'V' THEN -Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                ELSE 0 
                            END 
                         ELSE 0 
                      END 
                      ) + Sum( 
                          CASE 
                              WHEN @ConNoAprobado = 'S' THEN 
                             CASE 
                                WHEN transaccion_inv.naturaleza = 'S' 
                                AND transaccion_inv.tipo =  'A' THEN Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                WHEN transaccion_inv.naturaleza = 'E' 
                                AND transaccion_inv.tipo <> 'A' 
                                AND transaccion_inv.subtipo = 'C' THEN Abs(Isnull(transaccion_inv.cantidad,0)) 
                                WHEN transaccion_inv.naturaleza = 'E' 
                                AND transaccion_inv.tipo ='A' THEN - Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                WHEN transaccion_inv.naturaleza = 'S' 
                                AND transaccion_inv.tipo <> 'A' 
                                AND  transaccion_inv.subtipo = 'C' THEN  -Abs(Isnull(transaccion_inv.cantidad, 0)) ELSE 0 
                            END 
                        ELSE 0 
                          END 
                      ) + Sum( 
                          CASE 
                              WHEN @ConRemitido = 'S' THEN 
                             CASE 
                                WHEN transaccion_inv.naturaleza = 'S' 
                                AND transaccion_inv.tipo = 'I' THEN Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                WHEN transaccion_inv.naturaleza = 'E' 
                                AND transaccion_inv.tipo <> 'I' 
                                AND transaccion_inv.subtipo = 'I' THEN Abs(Isnull(transaccion_inv.cantidad,0)) 
                                WHEN transaccion_inv.naturaleza = 'E' 
                                AND transaccion_inv.tipo = 'I' THEN - Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                WHEN transaccion_inv.naturaleza = 'S' 
                                AND transaccion_inv.tipo <> 'I' 
                                AND transaccion_inv.subtipo = 'I' THEN -Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                ELSE 0 
                            END 
                            ELSE 0 
                          END 
                      )),0)AS dif_existencia_ini, 
                            
                Isnull(( 
                      Sum( 
                          CASE 
                              WHEN @ConDisponible = 'S' 
                              AND ((@TipoFecha = 'D' 
                              AND Cast( Substring (Cast(transaccion_inv.fecha AS CHAR), 1, 11)AS DATETIME ) > 
                      Isnull(@FechaHasta, Cast('2050-12-31 23:59:59.998' AS DATETIME) ) ) 
                      OR ( @TipoFecha = 'A' 
                      AND transaccion_inv.fecha_hora_transac> Isnull(@FechaHasta, Cast('2050-12-31 23:59:59.998' AS DATETIME)) ) )THEN 
                          CASE 
                          WHEN transaccion_inv.naturaleza = 'E' 
                          AND (transaccion_inv.tipo = 'R' OR transaccion_inv.tipo = 'A' OR transaccion_inv.subtipo = 'D' ) THEN  Abs(Isnull(transaccion_inv.cantidad, 0)) 
                          WHEN transaccion_inv.naturaleza = 'S' 
                          AND (transaccion_inv.tipo ='R' OR transaccion_inv.tipo = 'A' OR transaccion_inv.subtipo = 'D' ) THEN -Abs (Isnull(transaccion_inv.cantidad, 0)) 
                          ELSE 0 
                        END 
                        ELSE 0 
                      END ) 
                      +Sum( 
                        CASE 
                        WHEN @ConReservado = 'S' 
                        AND ( (@TipoFecha = 'D' AND Cast( Substring(Cast(transaccion_inv.fecha AS CHAR), 1, 11) AS DATETIME ) > Isnull(@FechaHasta, Cast( '2050-12-31 23:59:59.998' AS DATETIME))) 
                        OR (@TipoFecha = 'A' AND transaccion_inv.fecha_hora_transac > Isnull ( @FechaHasta, Cast('2050-12-31 23:59:59.998' AS DATETIME)) ) ) THEN 
                            CASE 
                                WHEN transaccion_inv.naturaleza = 'S' 
                                AND transaccion_inv.tipo ='R' THEN Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                WHEN  transaccion_inv.naturaleza = 'E' 
                                AND transaccion_inv.tipo <> 'R' 
                                AND  transaccion_inv.subtipo = 'R' THEN Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                WHEN transaccion_inv.naturaleza = 'E' 
                                AND transaccion_inv.tipo = 'R' THEN - Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                WHEN transaccion_inv.naturaleza = 'S' 
                                AND transaccion_inv.tipo <> 'R' 
                                AND  transaccion_inv.subtipo = 'R' THEN -Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                ELSE 0 
                            END 
                            ELSE 0 
                        END 
                      ) 
                      + Sum( 
                          CASE 
                              WHEN @ConVencido = 'S' 
                              AND ( ( @TipoFecha = 'D' AND Cast( Substring(Cast( transaccion_inv.fecha AS CHAR ), 1, 11) AS DATETIME ) > Isnull(@FechaHasta, Cast( '2050-12-31 23:59:59.998' AS DATETIME)) ) 
                                      OR ( @TipoFecha = 'A'  AND transaccion_inv.fecha_hora_transac > Isnull( @FechaHasta, Cast(  '2050-12-31 23:59:59.998' AS DATETIME)) ) ) THEN 
                              CASE 
                                WHEN transaccion_inv.naturaleza = 'S' 
                                AND transaccion_inv.tipo = 'N' THEN Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                WHEN transaccion_inv.naturaleza = 'E' 
                                AND transaccion_inv.tipo <> 'N' 
                                AND transaccion_inv.subtipo = 'V' THEN Abs(Isnull(transaccion_inv.cantidad,  0)) 
                                WHEN transaccion_inv.naturaleza = 'E' 
                                AND transaccion_inv.tipo = 'N' THEN - Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                WHEN transaccion_inv.naturaleza = 'S' 
                                AND transaccion_inv.tipo <> 'N' 
                                AND transaccion_inv.subtipo = 'V' THEN  -Abs(Isnull(transaccion_inv.cantidad, 0))
                                ELSE 0 
                              END 
                             ELSE 0 
                          END 
                      ) + 
                      Sum( CASE 
                            WHEN @ConNoAprobado = 'S' 
                            AND( ( @TipoFecha = 'D' AND Cast( Substring(Cast(transaccion_inv.fecha AS CHAR), 1, 11) AS DATETIME ) > Isnull(@FechaHasta, Cast('2050-12-31 23:59:59.998' AS DATETIME)) )
                            OR ( @TipoFecha = 'A' AND transaccion_inv.fecha_hora_transac > Isnull( @FechaHasta, Cast( '2050-12-31 23:59:59.998' AS DATETIME)) ) ) THEN 
                            CASE 
                                WHEN transaccion_inv.naturaleza = 'S' 
                                AND transaccion_inv.tipo = 'A' THEN Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                WHEN transaccion_inv.naturaleza = 'E' 
                                AND transaccion_inv.tipo <> 'A' 
                                AND transaccion_inv.subtipo = 'C' THEN Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                WHEN transaccion_inv.naturaleza = 'E' 
                                AND transaccion_inv.tipo = 'A' THEN - Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                WHEN transaccion_inv.naturaleza = 'S' 
                                AND transaccion_inv.tipo <> 'A' 
                                AND transaccion_inv.subtipo = 'C' THEN -Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                ELSE 0 
                            END 
                            ELSE 0
                        END 
                      ) + Sum( CASE 
                                WHEN @ConRemitido = 'S' 
                                AND ( ( @TipoFecha = 'D' AND Cast( Substring(Cast(transaccion_inv.fecha AS CHAR), 1, 11) AS DATETIME ) > Isnull(@FechaHasta, Cast( '2050-12-31 23:59:59.998' AS DATETIME)) ) 
                                OR ( @TipoFecha = 'A' AND transaccion_inv.fecha_hora_transac > Isnull( @FechaHasta, Cast( '2050-12-31 23:59:59.998' AS DATETIME)) ) ) THEN 
                                CASE 
                                    WHEN transaccion_inv.naturaleza = 'S' 
                                    AND transaccion_inv.tipo = 'I' THEN Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                    WHEN transaccion_inv.naturaleza = 'E' 
                                    AND transaccion_inv.tipo <> 'I' 
                                    AND transaccion_inv.subtipo = 'I' THEN Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                    WHEN transaccion_inv.naturaleza = 'E' 
                                    AND transaccion_inv.tipo = 'I' THEN - Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                    WHEN transaccion_inv.naturaleza = 'S' 
                                    AND transaccion_inv.tipo <> 'I' 
                                    AND transaccion_inv.subtipo = 'I' THEN -Abs(Isnull(transaccion_inv.cantidad, 0)) 
                                    ELSE 0 
                                END 
                                ELSE 0 
                               END 
                      ) ), 0)AS dif_existencia_fin, 
                         Isnull(( Sum(CASE 
                                         WHEN ( ( @IncluyeVentas = 'S' AND transaccion_inv.tipo = 'V') 
                                              OR ( @IncluyeConsumos ='S' AND transaccion_inv.tipo = 'C' ) ) 
                                              AND ( (@TipoFecha = 'D' AND Cast( Substring(Cast( transaccion_inv.fecha AS CHAR), 1, 11 ) AS DATETIME) <= Isnull( @FechaHasta , Cast( '2050-12-31 23:59:59.998' AS DATETIME)) ) 
                                              OR ( @TipoFecha = 'A' AND transaccion_inv.fecha_hora_transac <= Isnull(@FechaHasta, Cast( '2050-12-31 23:59:59.998' AS DATETIME)) ) ) THEN 
                                        CASE 
                                            WHEN transaccion_inv.naturaleza = 'S' THEN Abs( transaccion_inv.cantidad) 
                                            WHEN transaccion_inv.naturaleza = 'E' THEN -Abs( transaccion_inv.cantidad) 
                                            ELSE 0 
                                        END 
                                        ELSE 0 
                                    END) ), 0)  AS unidades_periodo, 
                        Isnull(( Sum(CASE 
                                        WHEN ( ( @IncluyeVentas = 'S' 
                                        AND transaccion_inv.tipo = 'V' ) 
                                        OR ( @IncluyeConsumos = 'S' 
                                        AND transaccion_inv.tipo = 'C' ) ) 
                                        AND ( ( @TipoFecha = 'D' 
                                        AND Cast(Substring(Cast( transaccion_inv.fecha AS CHAR), 1, 11 ) AS DATETIME)<= Isnull(@FechaHasta, Cast( '2050-12-31 23:59:59.998' AS DATETIME)) ) 
                                        OR ( @TipoFecha = 'A' AND transaccion_inv.fecha_hora_transac <= Isnull(@FechaHasta, Cast( '2050-12-31 23:59:59.998' AS DATETIME))) ) THEN 
                                        CASE 
                                            WHEN transaccion_inv.naturaleza = 'S' THEN Abs( transaccion_inv.costo_tot_fisc_loc) 
                                            WHEN transaccion_inv.naturaleza = 'E' THEN -Abs( transaccion_inv.costo_tot_fisc_loc) 
                                        ELSE 0 
                                        END 
                                    ELSE 0 
                                    END) ), 0)  AS costo_fisc_loc_unds, 
                        Isnull(( Sum(CASE 
                                        WHEN ( ( @IncluyeVentas = 'S' 
                                        AND transaccion_inv.tipo = 'V' ) 
                                        OR ( @IncluyeConsumos = 'S' 
                                        AND transaccion_inv.tipo = 'C' ) ) 
                                        AND ( ( @TipoFecha = 'D' 
                                        AND Cast(Substring(Cast( transaccion_inv.fecha AS CHAR), 1,11 ) AS DATETIME) <= Isnull(@FechaHasta, Cast( '2050-12-31 23:59:59.998' AS DATETIME)) ) 
                                        OR ( @TipoFecha = 'A' AND transaccion_inv.fecha_hora_transac <= Isnull(@FechaHasta, Cast( '2050-12-31 23:59:59.998' AS DATETIME)) ) ) THEN 
                                        CASE 
                                            WHEN transaccion_inv.naturaleza = 'S' THEN Abs( transaccion_inv.costo_tot_fisc_dol) 
                                            WHEN transaccion_inv.naturaleza = 'E' THEN -Abs( transaccion_inv.costo_tot_fisc_dol) 
                                            ELSE 0 
                                        END 
                                        ELSE 0 
                                    END) ), 0)  AS costo_fisc_dol_unds, 
                        Isnull(( Sum(CASE 
                                        WHEN ( ( @IncluyeVentas = 'S' 
                                        AND transaccion_inv.tipo = 'V' ) 
                                        OR ( @IncluyeConsumos = 'S' 
                                        AND transaccion_inv.tipo = 'C' ) ) 
                                        AND ( ( @TipoFecha = 'D' 
                                        AND Cast(Substring(Cast( transaccion_inv.fecha AS CHAR), 1, 11 ) AS DATETIME) <= Isnull(@FechaHasta, Cast( '2050-12-31 23:59:59.998' AS DATETIME)) ) 
                                        OR ( @TipoFecha = 'A' AND 
                                        transaccion_inv.fecha_hora_transac <= Isnull(@FechaHasta, Cast( '2050-12-31 23:59:59.998'AS DATETIME)) ) ) THEN 
                                        CASE 
                                            WHEN transaccion_inv.naturaleza = 'S' THEN Abs( transaccion_inv.costo_tot_comp_loc) 
                                            WHEN transaccion_inv.naturaleza = 'E' THEN -Abs(transaccion_inv.costo_tot_comp_loc) 
                                            ELSE 0 
                                        END 
                                        ELSE 0 
                                    END) ), 0)  AS costo_comp_loc_unds, 
                        Isnull(( Sum(CASE 
                                        WHEN ( ( @IncluyeVentas = 'S' 
                                        AND transaccion_inv.tipo = 'V' ) 
                                        OR ( @IncluyeConsumos = 'S' 
                                        AND transaccion_inv.tipo = 'C' ) ) 
                                        AND ( ( @TipoFecha = 'D' 
                                        AND Cast(Substring(Cast( transaccion_inv.fecha AS CHAR), 1,11 ) AS DATETIME) <=  Isnull(@FechaHasta, Cast( '2050-12-31 23:59:59.998' AS  DATETIME)) ) 
                                        OR ( @TipoFecha = 'A' 
                                        AND  transaccion_inv.fecha_hora_transac <= Isnull(@FechaHasta, Cast( '2050-12-31 23:59:59.998' AS DATETIME)) ) ) THEN 
                                        CASE 
                                            WHEN transaccion_inv.naturaleza = 'S' THEN  Abs( transaccion_inv.costo_tot_comp_dol) 
                                            WHEN transaccion_inv.naturaleza = 'E' THEN  -Abs(  transaccion_inv.costo_tot_comp_dol) 
                                            ELSE 0 
                                        END 
                                        ELSE 0 
                                    END) ), 0)  AS costo_comp_dol_unds, 
                        Isnull(( Sum(CASE 
                                        WHEN ( ( @IncluyeVentas = 'S' 
                                        AND transaccion_inv.tipo = 'V' ) 
                                        OR ( @IncluyeConsumos = 'S' 
                                        AND transaccion_inv.tipo = 'C' ) ) 
                                        AND ( ( @TipoFecha = 'D' 
                                        AND Cast(Substring(Cast(  transaccion_inv.fecha AS CHAR), 1, 11 ) AS DATETIME)<=  Isnull(@FechaHasta, Cast(  '2050-12-31 23:59:59.998' AS DATETIME)) ) 
                                        OR ( @TipoFecha = 'A' AND  transaccion_inv.fecha_hora_transac  <=  Isnull(@FechaHasta, Cast(  '2050-12-31 23:59:59.998'  AS  DATETIME)) ) ) THEN 1 
                                        ELSE 0 
                                    END
                            ) ), 0)  AS conteo_movimientos 
        FROM     $$COMPANIA$$.transaccion_inv TRANSACCION_INV(nolock) 
        WHERE  transaccion_inv.tipo <> 'S' 
            AND transaccion_inv.articulo BETWEEN 
            Isnull(@ArticuloDesde, '0') AND Isnull( @ArticuloHasta, 'ZZZZZZZZZZZZZZZZZZZZ') 
            AND transaccion_inv.bodega BETWEEN Isnull(@BodegaDesde, '0') AND Isnull(@BodegaHasta, 'ZZZZ') 
            AND transaccion_inv.localizacion BETWEEN @LocalizacionDesde AND @LocalizacionHasta 
            AND ( ( @TipoFecha = 'D' 
            AND Cast(Substring(Cast(transaccion_inv.fecha AS CHAR) , 1, 11) AS  DATETIME)>=  Isnull(@FechaDesde, Cast('1980-01-01 00:00:00.000' AS DATETIME)) ) 
            OR ( @TipoFecha = 'A' AND transaccion_inv.fecha_hora_transac >= Isnull(@FechaDesde, Cast( '1980-01-01 00:00:00.000' AS  DATETIME)) ) ) 
        GROUP  BY transaccion_inv.articulo 
        
        HAVING ( @SoloConMovimientos = 'N' 
            OR ( @SoloConMovimientos = 'S' 
            AND Isnull(( Sum(CASE 
                                 WHEN ( ( @IncluyeVentas = 'S'
                                        AND transaccion_inv.tipo =  'V' ) 
                                        OR ( @IncluyeConsumos = 'S' 
                                        AND transaccion_inv.tipo = 'C' )) 
                                        AND ( ( @TipoFecha = 'D' 
                                        AND Cast( Substring(Cast(  transaccion_inv.fecha AS  CHAR), 1, 11 ) AS DATETIME) <=  Isnull(@FechaHasta , Cast(  '2050-12-31 23:59:59.998' AS DATETIME)) ) 
                                        OR ( @TipoFecha = 'A' 
                                        AND  transaccion_inv.fecha_hora_transac <=  Isnull(@FechaHasta, Cast( '2050-12-31 23:59:59.998' AS DATETIME)) ) ) THEN 1 
                                ELSE 0 
                                END
                    ) ), 0) > 0 ) 
        )) TRANSACCIONES 
        ON articulo.articulo = TRANSACCIONES.articulo 
        LEFT JOIN (
                SELECT existencia_bodega.articulo, 
       existencia_bodega.cant_transito 
       + existencia_lote_rec.existencia_actual AS existencia_actual 
FROM   (SELECT existencia_bodega.articulo AS articulo, 
               Sum(CASE 
                     WHEN @ConTransito = 'S' THEN 
                     existencia_bodega.cant_transito 
                     ELSE 0 
                   END)                   AS cant_transito 
        FROM     $$COMPANIA$$.existencia_bodega EXISTENCIA_BODEGA(nolock) 
        WHERE  existencia_bodega.articulo BETWEEN 
                       Isnull(@ArticuloDesde, '0') AND Isnull( 
                       @ArticuloHasta, 'ZZZZZZZZZZZZZZZZZZZZ') 
               AND existencia_bodega.bodega BETWEEN 
                   Isnull(@BodegaDesde, '0') AND Isnull( 
                   @BodegaHasta, 'ZZZZ') 
        GROUP  BY existencia_bodega.articulo) existencia_bodega 
       INNER JOIN (SELECT existencia_bodega.articulo                      AS 
                          articulo, 
                          Sum(CASE WHEN @ConDisponible = 'S' THEN Isnull ( 
                              existencia_lote_rec.cant_disponible 
                              , 
                              existencia_bodega.cant_disponible) ELSE 0 END + 
                              CASE WHEN 
                              @ConReservado = 
                              'S' THEN Isnull ( existencia_lote_rec.cant_reservada, 
                              existencia_bodega.cant_reservada) ELSE 0 END + 
                              CASE WHEN 
                              @ConRemitido = 'S' 
                              THEN Isnull ( 
                              existencia_lote_rec.cant_remitida, 
                              existencia_bodega.cant_remitida) ELSE 
                              0 END + 
                              CASE WHEN @ConNoAprobado = 'S' THEN Isnull ( 
                              existencia_lote_rec.cant_no_aprobada, 
                              existencia_bodega.cant_no_aprobada) ELSE 0 
                              END + CASE WHEN 
                              @ConVencido = 'S' THEN Isnull ( 
                              existencia_lote_rec.cant_vencida, 
                              existencia_bodega.cant_vencida) ELSE 0 END) AS 
       existencia_actual 
                   FROM     $$COMPANIA$$.existencia_bodega EXISTENCIA_BODEGA 
                          LEFT JOIN   (SELECT ARTICULO,BODEGA, LOCALIZACION,SUM(CANT_DISPONIBLE) CANT_DISPONIBLE , SUM(CANT_RESERVADA) CANT_RESERVADA,SUM(CANT_NO_APROBADA) CANT_NO_APROBADA,SUM(CANT_VENCIDA) CANT_VENCIDA,SUM(CANT_REMITIDA) CANT_REMITIDA
 				from $$COMPANIA$$.existencia_lote (NOLOCK)
				 Group by ARTICULO,BODEGA, LOCALIZACION) existencia_lote_rec
                                 ON existencia_lote_rec.articulo = 
                                    existencia_bodega.articulo 
                                    AND existencia_lote_rec.bodega = 
                                        existencia_bodega.bodega 
                                    AND existencia_lote_rec.localizacion  BETWEEN  @LocalizacionDesde AND  @LocalizacionHasta
                   WHERE  existencia_bodega.articulo BETWEEN 
                                  Isnull (@ArticuloDesde, '0') AND Isnull ( 
                                  @ArticuloHasta, 'ZZZZZZZZZZZZZZZZZZZZ') 
                          AND existencia_bodega.bodega BETWEEN 
                              Isnull (@BodegaDesde, '0') AND Isnull( 
                              @BodegaHasta, 'ZZZZ') 
                   GROUP  BY existencia_bodega.articulo) existencia_lote_rec 
               ON existencia_bodega.articulo = existencia_lote_rec.articulo ) EXISTENCIA_ACTUAL 
        ON articulo.articulo = EXISTENCIA_ACTUAL.articulo 
      WHERE  articulo.articulo BETWEEN Isnull(@ArticuloDesde, '0') AND 
               Isnull(@ArticuloHasta, 'ZZZZZZZZZZZZZZZZZZZZ') 
               AND ( @SoloConMovimientos = 'N' 
                      OR ( @SoloConMovimientos = 'S' 
                           AND TRANSACCIONES.conteo_movimientos > 0 ) ) 

      OPEN reconstruccion 

      IF ( Abs(@@CURSOR_ROWS) ) > 0 
        BEGIN 
            SET @CantidadDiasRango = Isnull( 
            Datediff(day, @FechaDesde, @FechaHasta 
            ), 0 
                                     ) 

            FETCH next FROM reconstruccion INTO @CodigoArticulo, 
            @DifExistInicial, 
            @DifExistFinal, @ExistenciaActual, @UnidadesPeriodo, 
            @CostoUnitarioInicial 
            , 
            @CostoUnitarioFinal, @CostoUnidades, @ConteoTransacciones 

            SET @ExistenciaInicialAux = 0 
            SET @CostoFinalAux = 0 
            SET @CostoExistencia = 0 

            WHILE @@FETCH_STATUS >= 0 
              BEGIN 
                  IF ( @TipoRotacion = 'N' ) 
                    BEGIN 
                        IF ( Isnull(@ConteoTransacciones, 0) > 0 ) 
                          BEGIN 
                              SET @FechaFinalAux = Cast( 
                              Substring( Cast( Isnull(Dateadd( 
                              day, 
                              -1, 
                              @FechaDesde), '1980-01-01') AS 
                                                   CHAR ), 
                              1, 11 ) 
                              + ' 23:59:59.998' AS DATETIME) 
                              SET @CostoFinalAux = Isnull(@CostoUnitarioInicial, 
                                                   0 
                                                   ) 
                              SET @CantidadPeriodos = 0 
                              SET @TerminarCiclo = 'N' 
                              SET @ExistenciaFinalAux = 
                              Isnull(@ExistenciaActual, 
                              0) 
                              - Isnull( 
                              @DifExistInicial, 0) 
                              SET @CantidadExistencia = 0 

                              WHILE @TerminarCiclo <> 'S' 
                                BEGIN 
                                    SET @ExistenciaInicialAux = 
                                    @ExistenciaFinalAux 
                                    SET @CostoInicialAux = @CostoFinalAux 
                                    SET @FechaInicialAux = @FechaFinalAux 
                                    SET @FechaFinalAux = Cast( 
                                    Substring( Cast(Dateadd(day, 
                                    @NumeroDiasPeriodo, 
                                    @FechaInicialAux) AS CHAR) 
                                                         , 1, 
                                    11 ) 
                                    + ' 23:59:59.998' AS DATETIME) 
                                    SET @CantidadPeriodos = 
                                    @CantidadPeriodos + 1 

                                    IF ( @FechaFinalAux >= @FechaHasta ) 
                                      BEGIN 
                                          SET @TerminarCiclo = 'S' 
                                          SET @FechaFinalAux = @FechaHasta 
                                          SET @CostoFinalAux = 
                                          @CostoUnitarioFinal 
                                          SET @ExistenciaFinalAux = 
                                          Isnull(@ExistenciaActual, 
                                          0) 
                                          - Isnull( 
                                          @DifExistFinal, 0) 
                                      END 
                                    ELSE 
                                      BEGIN 
                                          SET @DiferenciaExistencia = 0 

                                          SELECT @CostoFinalAux = CASE 
                                                                    WHEN 
                                                 @CalcularCostos = 'S' 
                                                                  THEN 
                $$COMPANIA$$.Costounitarioarticulo('S' 
              , 
              @TipoFecha 
              , 
              @FechaFinalAux, 
              'F', @TipoCosto, 
              @MonedaCalculo, @FechaActual, 
              articulo.articulo, 
              articulo.costo_fiscal, 
              articulo.costo_comparativo, 
              articulo.costo_std_loc, 
              articulo.costo_std_dol, 
              articulo.costo_prom_loc, 
              articulo.costo_prom_dol, 
              articulo.costo_ult_loc, 
              articulo.costo_ult_dol) 
              ELSE 0 
              END, 
              @DiferenciaExistencia = 
              Isnull(DIFERENCIA_EXISTENCIA.diferencia, 0) 
              FROM     $$COMPANIA$$.articulo ARTICULO(nolock) 
              LEFT JOIN (SELECT transaccion_inv.articulo AS 
              articulo, 
              Isnull(( 
                  SUM( 
                CASE 
                WHEN @ConDisponible = 'S' THEN 
                  CASE 
                  WHEN transaccion_inv.naturaleza = 'E' 
                    AND ( transaccion_inv.tipo = 'R' OR transaccion_inv.tipo = 'A' OR transaccion_inv.subtipo = 'D' )THEN abs(isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'S'  AND  (transaccion_inv.tipo = 'R'  OR  transaccion_inv.tipo = 'A' OR transaccion_inv.subtipo = 'D') THEN -abs(isnull(transaccion_inv.cantidad, 0)) 
                    ELSE 0 
                  END 
                  ELSE 0 
                END ) + sum( 
                CASE 
                WHEN @ConReservado = 'S' THEN 
                  CASE 
                  WHEN transaccion_inv.naturaleza = 'S' 
                    AND  transaccion_inv.tipo = 'R' THEN  abs(isnull(transaccion_inv.cantidad, 0 )) 
                  WHEN transaccion_inv.naturaleza = 'E' AND transaccion_inv.tipo <> 'R' AND  transaccion_inv.subtipo = 'R' THEN  abs(isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' AND  transaccion_inv.tipo = 'R' THEN - abs(isnull(transaccion_inv.cantidad, 0 )) 
                  WHEN transaccion_inv.naturaleza = 'S' AND transaccion_inv.tipo <> 'R' AND transaccion_inv.subtipo = 'R' THEN - abs(isnull(transaccion_inv.cantidad, 0)) 
                    ELSE 0 
                  END 
                  ELSE 0 
                END ) + sum( 
                CASE 
                WHEN @ConVencido = 'S' THEN 
                  CASE 
                  WHEN transaccion_inv.naturaleza = 'S' AND  transaccion_inv.tipo = 'N' THEN abs(isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' AND transaccion_inv.tipo <> 'N' AND transaccion_inv.subtipo = 'V' THEN abs(isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' AND  transaccion_inv.tipo = 'N' THEN - abs(isnull(transaccion_inv.cantidad, 0 )) 
                  WHEN transaccion_inv.naturaleza = 'S' AND transaccion_inv.tipo <> 'N' AND transaccion_inv.subtipo = 'V' THEN  - abs(isnull(transaccion_inv.cantidad, 0)) 
                    ELSE 0 
                  END 
                  ELSE 0 
                END ) + sum( 
                CASE 
                WHEN @ConNoAprobado = 'S' THEN 
                  CASE 
                  WHEN transaccion_inv.naturaleza = 'S' AND  transaccion_inv.tipo = 'A' THEN abs(isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' AND transaccion_inv.tipo <> 'A' AND  transaccion_inv.subtipo = 'C' THEN abs(isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' AND transaccion_inv.tipo = 'A' THEN - abs(isnull(transaccion_inv.cantidad, 0 )) 
                  WHEN transaccion_inv.naturaleza = 'S' 
                    AND transaccion_inv.tipo <> 'A' AND  transaccion_inv.subtipo = 'C' THEN  - abs(isnull(transaccion_inv.cantidad, 0)) 
                ELSE 0 
                  END 
                  ELSE 0 
                END ) + sum( 
                CASE 
                WHEN @ConRemitido = 'S' THEN 
                  CASE 
                  WHEN transaccion_inv.naturaleza = 'S' AND transaccion_inv.tipo = 'I' THEN abs(isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' AND transaccion_inv.tipo <> 'I' AND transaccion_inv.subtipo = 'I' THEN abs(isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' AND  transaccion_inv.tipo = 'I' THEN - abs(isnull(transaccion_inv.cantidad, 0 )) 
                  WHEN transaccion_inv.naturaleza = 'S' AND transaccion_inv.tipo <> 'I' AND transaccion_inv.subtipo = 'I' THEN - abs(isnull(transaccion_inv.cantidad, 0)) 
                    ELSE 0 
                  END 
                  ELSE 0 
                END )
              
              ), 0)AS  diferencia
              
              FROM     $$COMPANIA$$.transaccion_inv TRANSACCION_INV( 
              nolock 
              ) 
              WHERE  transaccion_inv.tipo <> 'S' 
              AND transaccion_inv.articulo = 
              @CodigoArticulo 
              AND transaccion_inv.bodega BETWEEN Isnull(@BodegaDesde, '0') AND Isnull(@BodegaHasta, 'ZZZZ') 
              AND  transaccion_inv.localizacion BETWEEN  @LocalizacionDesde AND  @LocalizacionHasta 
              AND ( ( @TipoFecha = 'D'  AND Cast(Substring(CAST (  transaccion_inv.fecha AS CHAR) , 1, 11) AS DATETIME) > @FechaInicialAux AND Cast(Substring(CAST ( transaccion_inv.fecha  AS CHAR) , 1, 11) AS DATETIME)  <= @FechaFinalAux ) OR ( @TipoFecha = 'A'  AND transaccion_inv.fecha_hora_transac > @FechaInicialAux AND transaccion_inv.fecha_hora_transac <= @FechaFinalAux ) ) 
              GROUP  BY transaccion_inv.articulo) 
              DIFERENCIA_EXISTENCIA 
              ON articulo.articulo = DIFERENCIA_EXISTENCIA.articulo 
              WHERE  articulo.articulo = @CodigoArticulo 
              AND DIFERENCIA_EXISTENCIA.articulo = @CodigoArticulo 

              SET @CostoFinalAux = Isnull(@CostoFinalAux, 0) 
              SET @DiferenciaExistencia = Isnull(@DiferenciaExistencia, 0) 
              SET @ExistenciaFinalAux = Isnull( 
              @ExistenciaFinalAux + @DiferenciaExistencia, 0) 
              END 

              SET @CantidadExistencia = Isnull(@CantidadExistencia, 0) + 
              ( Isnull(@ExistenciaInicialAux, 0) 
              + Isnull(@ExistenciaFinalAux, 0) ) / 2 
              SET @CostoExistencia = Isnull(@CostoExistencia, 0) + ( 
              Isnull( @CostoUnitarioInicial, 0) * Isnull ( @ExistenciaInicialAux, 0) + Isnull ( @CostoUnitarioFinal, 0) * Isnull(@ExistenciaFinalAux, 0) ) / 2 
              END 

              IF ( @CantidadPeriodos > 0 ) 
              BEGIN 
              SET @CantidadExistencia = @CantidadExistencia / @CantidadPeriodos 
              SET @CostoExistencia = @CostoExistencia / @CantidadPeriodos 
              END 
              ELSE 
              BEGIN 
              SET @CantidadExistencia = 0 
              SET @CostoExistencia = 0 
              END 
              END 
              ELSE 
              BEGIN 
              SET @CantidadExistencia = 0 
              SET @CostoExistencia = 0 
              END 
              END 
              ELSE 
              BEGIN 
              IF ( @TipoRotacion = 'I' ) 
              BEGIN 
              SET @CostoUnitarioFinal = @CostoUnitarioInicial 
              SET @DifExistFinal = @DifExistInicial 
              END 

              IF ( @TipoRotacion = 'F' ) 
              BEGIN 
              SET @CostoUnitarioInicial = @CostoUnitarioFinal 
              SET @DifExistInicial = @DifExistFinal 
              END 

              SET @ExistenciaInicialAux = Isnull(@ExistenciaActual, 0) - Isnull( @DifExistInicial, 0) 
              SET @ExistenciaFinalAux = Isnull(@ExistenciaActual, 0) - Isnull( @DifExistFinal, 0) 
              SET @CantidadExistencia = ( Isnull(@ExistenciaInicialAux, 0) + Isnull(@ExistenciaFinalAux, 0) ) / 2 
              SET @CostoExistencia = ( Isnull(@CostoUnitarioInicial, 0) * Isnull( @ExistenciaInicialAux, 0) + Isnull( @CostoUnitarioFinal, 0) * Isnull(@ExistenciaFinalAux, 0  ) ) / 2 
              END 

                  SET @CantidadRotPeriodo = 0 
                  SET @CantidadRotAnualizada = 0 
                  SET @CostoRotPeriodo = 0 
                  SET @CostoRotAnualizada = 0 

                  IF ( @CantidadExistencia > 0 ) 
                    BEGIN 
                        SET @CantidadRotPeriodo = Isnull(( @UnidadesPeriodo / @CantidadExistencia ), 0) 
                    END 

                  IF ( @CantidadDiasRango > 0 ) 
                    BEGIN 
                        SET @CantidadRotAnualizada = Isnull(( ( @CantidadRotPeriodo * @NumeroDiasAnno ) / @CantidadDiasRango ), 0) 
                    END 

                  IF ( @CostoExistencia > 0 ) 
                    BEGIN 
                        SET @CostoRotPeriodo = Isnull(( @CostoUnidades / @CostoExistencia ), 0 ) 
                    END 

                  IF ( @CantidadDiasRango > 0 ) 
                    BEGIN 
                        SET @CostoRotAnualizada = Isnull(( ( @CostoRotPeriodo * @NumeroDiasAnno )/@CantidadDiasRango ), 0 ) 
                    END 

                  INSERT INTO @RotacionInventario 
                              (articulo, 
                               cantidad_existencia, 
                               costo_existencia, 
                               cantidad_unidades, 
                               costo_unidades, 
                               cant_rot_periodo, 
                               cant_rot_anualizada, 
                               costo_rot_periodo, 
                               costo_rot_anualizada, 
                               conteo_transacciones) 
                  VALUES      ( @CodigoArticulo, 
                                @CantidadExistencia, 
                                @CostoExistencia, 
                                @UnidadesPeriodo, 
                                @CostoUnidades, 
                                @CantidadRotPeriodo, 
                                @CantidadRotAnualizada, 
                                @CostoRotPeriodo, 
                                @CostoRotAnualizada, 
                                @ConteoTransacciones ) 

                  FETCH next FROM reconstruccion INTO @CodigoArticulo, 
                  @DifExistInicial, 
                  @DifExistFinal, @ExistenciaActual, @UnidadesPeriodo, 
                  @CostoUnitarioInicial 
                  , 
                  @CostoUnitarioFinal, @CostoUnidades, @ConteoTransacciones 
              END 
        END 

      CLOSE reconstruccion 

      DEALLOCATE reconstruccion 
     END

RETURN
      
END;


CREATE PROCEDURE $$COMPANIA$$.ReporteRotacionInventario
      @CalcularCostos		VARCHAR(1),
      @ArticuloDesde		VARCHAR(20),
      @ArticuloHasta		VARCHAR(20),
      @BodegaDesde	 		VARCHAR(4),
      @BodegaHasta	 		VARCHAR(4),
      @FechaDesde	 		DATETIME,
      @FechaHasta	 		DATETIME,
      @TipoFecha 			VARCHAR(1),
      @SoloConMovimientos 	VARCHAR(1),
      @Orden 				SMALLINT,
      @FechaActual 			DATETIME,
      @MonedaCalculo 		VARCHAR(1),
      @TipoCosto 			VARCHAR(1),
      @TipoRotacion 		VARCHAR(1),
      @NumeroDiasPeriodo 	DECIMAL(28, 8),
      @NumeroDiasAnno 		DECIMAL(28, 8),
      @IncluyeVentas 		VARCHAR(1),
      @IncluyeConsumos 		VARCHAR(1),
      @ConDisponible 		VARCHAR(1),
      @ConReservado 		VARCHAR(1),
      @ConNoAprobado 		VARCHAR(1),
      @ConVencido 			VARCHAR(1),
      @ConRemitido			VARCHAR(1),
      @ConTransito 			VARCHAR(1),
      @LocalizacionDesde 	VARCHAR(8),
      @LocalizacionHasta 	VARCHAR(8)
  AS
      SELECT CASE ISNULL(@Orden, 0)
                  WHEN 0 THEN ARTICULO.articulo
                  WHEN 1 THEN ARTICULO.descripcion
                  WHEN 2 THEN ARTICULO.clasificacion_1
                  WHEN 3 THEN ARTICULO.clasificacion_2
                  WHEN 4 THEN ARTICULO.clasificacion_3
                  WHEN 5 THEN ARTICULO.clasificacion_4
                  WHEN 6 THEN ARTICULO.clasificacion_5
                  WHEN 7 THEN ARTICULO.clasificacion_6
                  ELSE ARTICULO.articulo
        END   AS ordenamiento,
			             ARTICULO.articulo,
			             ARTICULO.descripcion,
			             ARTICULO.tipo,
			             ARTICULO.clasificacion_1,
			             ARTICULO.clasificacion_2,
			             ARTICULO.clasificacion_3,
			             ARTICULO.clasificacion_4,
			             ARTICULO.clasificacion_5,
			             ARTICULO.clasificacion_6,
			             ARTICULO.unidad_almacen,
			             ARTICULO.factor_empaque,
			             ARTICULO.unidad_empaque,
			             ARTICULO.codigo_barras_invt,
			             ARTICULO.codigo_barras_vent,
			             ARTICULO.activo,
			             ARTICULO.articulo_cuenta,
			             ARTICULO.clase_abc,
			             ARTICULO.proveedor,
			             ARTICULO.tipo_cod_barra_alm,
			             ARTICULO.tipo_cod_barra_det,
			             ARTICULO.ultima_salida,
			             ARTICULO.ultimo_ingreso,
			             ARTICULO.ultimo_movimiento,
			             ARTICULO.usa_lotes,
			             ARTICULO.utilizado_manufact,
			             ROTACION.cantidad_existencia,
			             ROTACION.costo_existencia,
			             ROTACION.cantidad_unidades,
			             ROTACION.costo_unidades,
			             ROTACION.cant_rot_periodo,
			             ROTACION.cant_rot_anualizada,
			             ROTACION.costo_rot_periodo,
			             ROTACION.costo_rot_anualizada
      FROM   $$COMPANIA$$.articulo     ARTICULO,
             $$COMPANIA$$.RotacionInventario (
                 @CalcularCostos,
                 @ArticuloDesde,
                 @ArticuloHasta,
                 @BodegaDesde,
                 @BodegaHasta,
                 @FechaDesde,
                 @FechaHasta,
                 @TipoFecha,
                 @SoloConMovimientos,
                 @FechaActual,
                 @MonedaCalculo,
                 @TipoCosto,
                 @TipoRotacion,
                 @NumeroDiasPeriodo,
                 @NumeroDiasAnno,
                 @IncluyeVentas,
                 @IncluyeConsumos,
                 @ConDisponible,
                 @ConReservado,
                 @ConNoAprobado,
                 @ConVencido,
                 @ConRemitido,
                 @ConTransito, 
                 @LocalizacionDesde,
                 @LocalizacionHasta
             )ROTACION
      WHERE  ARTICULO.articulo BETWEEN @ArticuloDesde AND @ArticuloHasta
             AND ARTICULO.articulo = ROTACION.articulo
             AND (@SoloConMovimientos = 'N'OR (@SoloConMovimientos = 'S'AND ROTACION.conteo_transacciones > 0))
    ORDER BY 1,2;
    







CREATE PROCEDURE $$Compania$$.ReporteSugReordenPuntos
  @CalcularCostos  VARCHAR(1),
  @ArticuloDesde  VARCHAR(20),
  @ArticuloHasta   VARCHAR(20),
  @BodegaDesde  VARCHAR(4),
  @BodegaHasta  VARCHAR(4),
  @TipoFecha  VARCHAR(1),
  @SoloConExistencias VARCHAR(1),
  @MonedaCalculo  VARCHAR(1),
  @TipoCosto   VARCHAR(1),
  @Orden   SMALLINT
 AS
  SELECT CASE ISNULL ( @Orden, 0 )
   WHEN 0 THEN ARTICULO.articulo
   WHEN 1 THEN ARTICULO.descripcion
   WHEN 2 THEN ARTICULO.clasificacion_1
   WHEN 3 THEN ARTICULO.clasificacion_2
   WHEN 4 THEN ARTICULO.clasificacion_3
   WHEN 5 THEN ARTICULO.clasificacion_4
   WHEN 6 THEN ARTICULO.clasificacion_5
   WHEN 7 THEN ARTICULO.clasificacion_6
   ELSE ARTICULO.articulo
   END AS ordenamiento,
   ARTICULO.articulo, 
   ARTICULO.descripcion, 
   ARTICULO.tipo,
   ARTICULO.clasificacion_1,
   ARTICULO.clasificacion_2,
   ARTICULO.clasificacion_3,
   ARTICULO.clasificacion_4,
   ARTICULO.clasificacion_5,
   ARTICULO.clasificacion_6,
   ARTICULO.unidad_almacen,
   ARTICULO.factor_empaque,
   ARTICULO.unidad_empaque,
   ARTICULO.codigo_barras_invt,
   ARTICULO.codigo_barras_vent,
   ARTICULO.activo,
   ARTICULO.articulo_cuenta,
   ARTICULO.clase_abc,
   ARTICULO.tipo_cod_barra_alm,
   ARTICULO.tipo_cod_barra_det,
   ARTICULO.ultima_salida,
   ARTICULO.ultimo_ingreso,
   ARTICULO.ultimo_movimiento,
   ARTICULO.usa_lotes,
   ARTICULO.utilizado_manufact,
   ARTICULO.proveedor,
   ARTICULO.articulo_del_prov,
   ARTICULO.orden_minima,
   ARTICULO.plazo_reabast,
   ARTICULO.lote_multiplo,
   ARTICULO.existencia_minima AS articulo_exist_min,
   ARTICULO.existencia_maxima AS articulo_exist_max,
   ARTICULO.punto_de_reorden AS articulo_punto_reord,
   EXISTENCIA_BODEGA.bodega,
   BODEGA.nombre AS descripcion_bodega,
   EXISTENCIA_BODEGA.existencia_minima AS bodega_exist_min,
   EXISTENCIA_BODEGA.existencia_maxima AS bodega_exist_max,
   EXISTENCIA_BODEGA.punto_de_reorden AS bodega_punto_reord,
   EXISTENCIA_BODEGA.cant_disponible AS disponible,
   EXISTENCIA_BODEGA.cant_reservada AS reservado,
   EXISTENCIA_BODEGA.cant_no_aprobada AS no_aprobado,
   EXISTENCIA_BODEGA.cant_vencida AS vencido,
   EXISTENCIA_BODEGA.cant_remitida AS remitido,
   EXISTENCIA_BODEGA.cant_transito AS transito,
   CASE WHEN @CalcularCostos = 'S' THEN
    $$Compania$$.CostoUnitarioArticuloBodega(
     'S',
     @TipoFecha,
     ERPADMIN.SF_GETDATE(),
     'F',
     @TipoCosto,
     @MonedaCalculo,
     ERPADMIN.SF_GETDATE(),
     ARTICULO.articulo,
     ARTICULO.costo_fiscal,
     ARTICULO.costo_comparativo,
     ARTICULO.costo_std_loc,
     ARTICULO.costo_std_dol,
     ARTICULO.costo_prom_loc,
     ARTICULO.costo_prom_dol,
     ARTICULO.costo_ult_loc,
     ARTICULO.costo_ult_dol, 
     EXISTENCIA_BODEGA.BODEGA) 
   ELSE 0 END AS costo_unitario
  FROM $$Compania$$.articulo ARTICULO (NOLOCK)
   LEFT JOIN $$Compania$$.existencia_bodega EXISTENCIA_BODEGA (NOLOCK)
    ON ARTICULO.articulo = EXISTENCIA_BODEGA.articulo
   INNER JOIN $$Compania$$.bodega BODEGA (NOLOCK)
    ON EXISTENCIA_BODEGA.bodega = BODEGA.bodega
  WHERE ARTICULO.articulo BETWEEN ISNULL( @ArticuloDesde, '0') AND ISNULL(@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
   AND EXISTENCIA_BODEGA.articulo BETWEEN ISNULL( @ArticuloDesde, '0') AND ISNULL(@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
   AND EXISTENCIA_BODEGA.bodega BETWEEN ISNULL( @BodegaDesde, '0') AND ISNULL(@BodegaHasta,'ZZZZ')
   AND ( @SoloConExistencias = 'N' OR ( @SoloConExistencias = 'S' 
     AND ( ISNULL(EXISTENCIA_BODEGA.cant_disponible,0) 
      + ISNULL(EXISTENCIA_BODEGA.cant_reservada,0)
      + ISNULL(EXISTENCIA_BODEGA.cant_no_aprobada,0)
      + ISNULL(EXISTENCIA_BODEGA.cant_vencida,0)
      + ISNULL(EXISTENCIA_BODEGA.cant_remitida,0) ) <> 0))
  ORDER BY 1,2,35;
 




CREATE PROCEDURE $$COMPANIA$$.ReporteSugReordenTransac
	@CalcularCostos		VARCHAR(1),
	@ArticuloDesde		VARCHAR(20),
	@ArticuloHasta 		VARCHAR(20),
	@BodegaDesde		VARCHAR(4),
	@BodegaHasta		VARCHAR(4),
	@TipoFecha		VARCHAR(1),
	@MonedaCalculo		VARCHAR(1),
	@TipoCosto 		VARCHAR(1),
	@SoloConMovimientos	VARCHAR(1),
	@SoloConExistencias	VARCHAR(1),
	@IncluyeVentas		VARCHAR(1),
	@IncluyeConsumos	VARCHAR(1),
	@FechaDesde		DATETIME,
	@FechaHasta		DATETIME,
	@FechaPeriodo00		DATETIME,
	@FechaPeriodo01		DATETIME,
	@FechaPeriodo02		DATETIME,
	@FechaPeriodo03		DATETIME,
	@FechaPeriodo04		DATETIME,
	@FechaPeriodo05		DATETIME,
	@FechaPeriodo06		DATETIME,
	@FechaPeriodo07		DATETIME,
	@FechaPeriodo08		DATETIME,
	@FechaPeriodo09		DATETIME,
	@FechaPeriodo10		DATETIME,
	@Orden			SMALLINT
AS
	SELECT	CASE ISNULL ( @Orden, 0 )
		WHEN 0 THEN ARTICULO.articulo
		WHEN 1 THEN ARTICULO.descripcion
		WHEN 2 THEN ARTICULO.clasificacion_1
		WHEN 3 THEN ARTICULO.clasificacion_2
		WHEN 4 THEN ARTICULO.clasificacion_3
		WHEN 5 THEN ARTICULO.clasificacion_4
		WHEN 6 THEN ARTICULO.clasificacion_5
		WHEN 7 THEN ARTICULO.clasificacion_6
		ELSE ARTICULO.articulo
		END AS ordenamiento,
		ARTICULO.articulo, 
		ARTICULO.descripcion, 
		ARTICULO.tipo,
		ARTICULO.clasificacion_1,
		ARTICULO.clasificacion_2,
		ARTICULO.clasificacion_3,
		ARTICULO.clasificacion_4,
		ARTICULO.clasificacion_5,
		ARTICULO.clasificacion_6,
		ARTICULO.unidad_almacen,
		ARTICULO.factor_empaque,
		ARTICULO.unidad_empaque,
		ARTICULO.codigo_barras_invt,
		ARTICULO.codigo_barras_vent,
		ARTICULO.activo,
		ARTICULO.articulo_cuenta,
		ARTICULO.clase_abc,
		ARTICULO.tipo_cod_barra_alm,
		ARTICULO.tipo_cod_barra_det,
		ARTICULO.ultima_salida,
		ARTICULO.ultimo_ingreso,
		ARTICULO.ultimo_movimiento,
		ARTICULO.usa_lotes,
		ARTICULO.utilizado_manufact,
		ARTICULO.proveedor,
		ARTICULO.articulo_del_prov,
		ARTICULO.orden_minima,
		ARTICULO.plazo_reabast,
		ARTICULO.lote_multiplo,
		ARTICULO.existencia_minima AS articulo_exist_min,
		ARTICULO.existencia_maxima AS articulo_exist_max,
		ARTICULO.punto_de_reorden AS articulo_punto_reord,
		CASE WHEN @CalcularCostos = 'S' THEN
			$$COMPANIA$$.CostoUnitarioArticulo(
				'S',
				@TipoFecha,
				ERPADMIN.SF_GETDATE(),
				'F',
				@TipoCosto,
				@MonedaCalculo,
				ERPADMIN.SF_GETDATE(),
				ARTICULO.articulo,
				ARTICULO.costo_fiscal,
				ARTICULO.costo_comparativo,
				ARTICULO.costo_std_loc,
				ARTICULO.costo_std_dol,
				ARTICULO.costo_prom_loc,
				ARTICULO.costo_prom_dol,
				ARTICULO.costo_ult_loc,
				ARTICULO.costo_ult_dol ) 
		ELSE 0 END AS costo_unitario,
		ISNULL( EXISTENCIA_ACTUAL.disponible, 0 ) AS disponible,
		ISNULL( EXISTENCIA_ACTUAL.reservado, 0 ) AS reservado,
		ISNULL( EXISTENCIA_ACTUAL.no_aprobado, 0 ) AS no_aprobado,
		ISNULL( EXISTENCIA_ACTUAL.vencido, 0 ) AS vencido,
		ISNULL( EXISTENCIA_ACTUAL.remitido, 0 ) AS remitido,
		ISNULL( EXISTENCIA_ACTUAL.transito, 0 ) AS transito,
		TRANSACCIONES.periodo_01,
		TRANSACCIONES.periodo_02,
		TRANSACCIONES.periodo_03,
		TRANSACCIONES.periodo_04,
		TRANSACCIONES.periodo_05,
		TRANSACCIONES.periodo_06,
		TRANSACCIONES.periodo_07,
		TRANSACCIONES.periodo_08,
		TRANSACCIONES.periodo_09,
		TRANSACCIONES.periodo_10
	FROM	$$COMPANIA$$.articulo ARTICULO (NOLOCK)
		LEFT JOIN (
			SELECT	EXISTENCIA_BODEGA.articulo AS articulo,
				SUM ( ISNULL(EXISTENCIA_BODEGA.cant_disponible,0) ) AS disponible,
				SUM ( ISNULL(EXISTENCIA_BODEGA.cant_reservada,0) ) AS reservado,
				SUM ( ISNULL(EXISTENCIA_BODEGA.cant_no_aprobada,0) ) AS no_aprobado,
				SUM ( ISNULL(EXISTENCIA_BODEGA.cant_vencida,0) ) AS vencido,
				SUM ( ISNULL(EXISTENCIA_BODEGA.cant_remitida,0) ) AS remitido,
				SUM ( ISNULL(EXISTENCIA_BODEGA.cant_transito,0) ) AS transito
			FROM	$$COMPANIA$$.existencia_bodega EXISTENCIA_BODEGA (NOLOCK)
			WHERE	EXISTENCIA_BODEGA.articulo BETWEEN ISNULL( @ArticuloDesde, '0') 
				AND ISNULL(@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
				AND EXISTENCIA_BODEGA.bodega BETWEEN ISNULL( @BodegaDesde, '0') AND ISNULL(@BodegaHasta,'ZZZZ')
				AND ( @SoloConExistencias = 'N' OR ( @SoloConExistencias = 'S' 
					AND (	ISNULL(EXISTENCIA_BODEGA.cant_disponible,0) 
						+ ISNULL(EXISTENCIA_BODEGA.cant_reservada,0)
						+ ISNULL(EXISTENCIA_BODEGA.cant_no_aprobada,0)
						+ ISNULL(EXISTENCIA_BODEGA.cant_vencida,0)
						+ ISNULL(EXISTENCIA_BODEGA.cant_remitida,0) ) <> 0))
			GROUP BY EXISTENCIA_BODEGA.articulo 
		) EXISTENCIA_ACTUAL
			ON ARTICULO.articulo = EXISTENCIA_ACTUAL.articulo
		LEFT JOIN (
			SELECT	TRANSACCION_INV.articulo AS articulo,
				SUM ( ISNULL ( 
					CASE WHEN @FechaPeriodo00 IS NOT NULL AND @FechaPeriodo01 IS NOT NULL 
						AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > @FechaPeriodo00 AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= @FechaPeriodo01)
							OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > @FechaPeriodo00 AND TRANSACCION_INV.fecha_hora_transac <= @FechaPeriodo01)
						)
					THEN	CASE WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS(TRANSACCION_INV.cantidad) WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS(TRANSACCION_INV.cantidad) ELSE 0 END
					ELSE 0 END
				,0 ) ) AS periodo_01,
				SUM ( ISNULL ( 
					CASE WHEN @FechaPeriodo01 IS NOT NULL AND @FechaPeriodo02 IS NOT NULL 
						AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > @FechaPeriodo01 AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= @FechaPeriodo02)
							OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > @FechaPeriodo01 AND TRANSACCION_INV.fecha_hora_transac <= @FechaPeriodo02)
						)
					THEN	CASE WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS(TRANSACCION_INV.cantidad) WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS(TRANSACCION_INV.cantidad) ELSE 0 END
					ELSE 0 END
				,0 ) ) AS periodo_02,
				SUM ( ISNULL ( 
					CASE WHEN @FechaPeriodo02 IS NOT NULL AND @FechaPeriodo03 IS NOT NULL 
						AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > @FechaPeriodo02 AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= @FechaPeriodo03)
							OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > @FechaPeriodo02 AND TRANSACCION_INV.fecha_hora_transac <= @FechaPeriodo03)
						)
					THEN	CASE WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS(TRANSACCION_INV.cantidad) WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS(TRANSACCION_INV.cantidad) ELSE 0 END
					ELSE 0 END
				,0 ) ) AS periodo_03,
				SUM ( ISNULL ( 
					CASE WHEN @FechaPeriodo03 IS NOT NULL AND @FechaPeriodo04 IS NOT NULL 
						AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > @FechaPeriodo03 AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= @FechaPeriodo04)
							OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac >= @FechaPeriodo03 AND TRANSACCION_INV.fecha_hora_transac <= @FechaPeriodo04)
						)
					THEN	CASE WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS(TRANSACCION_INV.cantidad) WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS(TRANSACCION_INV.cantidad) ELSE 0 END
					ELSE 0 END
				,0 ) ) AS periodo_04,
				SUM ( ISNULL ( 
					CASE WHEN @FechaPeriodo04 IS NOT NULL AND @FechaPeriodo05 IS NOT NULL 
						AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > @FechaPeriodo04 AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= @FechaPeriodo05)
							OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > @FechaPeriodo04 AND TRANSACCION_INV.fecha_hora_transac <= @FechaPeriodo05)
						)
					THEN	CASE WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS(TRANSACCION_INV.cantidad) WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS(TRANSACCION_INV.cantidad) ELSE 0 END
					ELSE 0 END
				,0 ) ) AS periodo_05,
				SUM ( ISNULL ( 
					CASE WHEN @FechaPeriodo05 IS NOT NULL AND @FechaPeriodo06 IS NOT NULL 
						AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > @FechaPeriodo05 AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= @FechaPeriodo06)
							OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > @FechaPeriodo05 AND TRANSACCION_INV.fecha_hora_transac <= @FechaPeriodo06)
						)
					THEN	CASE WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS(TRANSACCION_INV.cantidad) WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS(TRANSACCION_INV.cantidad) ELSE 0 END
					ELSE 0 END
				,0 ) ) AS periodo_06,
				SUM ( ISNULL ( 
					CASE WHEN @FechaPeriodo06 IS NOT NULL AND @FechaPeriodo07 IS NOT NULL 
						AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > @FechaPeriodo06 AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= @FechaPeriodo07)
							OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > @FechaPeriodo06 AND TRANSACCION_INV.fecha_hora_transac <= @FechaPeriodo07)
						)
					THEN	CASE WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS(TRANSACCION_INV.cantidad) WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS(TRANSACCION_INV.cantidad) ELSE 0 END
					ELSE 0 END
				,0 ) ) AS periodo_07,
				SUM ( ISNULL ( 
					CASE WHEN @FechaPeriodo07 IS NOT NULL AND @FechaPeriodo08 IS NOT NULL 
						AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > @FechaPeriodo07 AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= @FechaPeriodo08)
							OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > @FechaPeriodo07 AND TRANSACCION_INV.fecha_hora_transac <= @FechaPeriodo08)
						)
					THEN	CASE WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS(TRANSACCION_INV.cantidad) WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS(TRANSACCION_INV.cantidad) ELSE 0 END
					ELSE 0 END
				,0 ) ) AS periodo_08,
				SUM ( ISNULL ( 
					CASE WHEN @FechaPeriodo08 IS NOT NULL AND @FechaPeriodo09 IS NOT NULL 
						AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > @FechaPeriodo08 AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= @FechaPeriodo09)
							OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > @FechaPeriodo08 AND TRANSACCION_INV.fecha_hora_transac <= @FechaPeriodo09)
						)
					THEN	CASE WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS(TRANSACCION_INV.cantidad) WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS(TRANSACCION_INV.cantidad) ELSE 0 END
					ELSE 0 END
				,0 ) ) AS periodo_09,
				SUM ( ISNULL ( 
					CASE WHEN @FechaPeriodo09 IS NOT NULL AND @FechaPeriodo10 IS NOT NULL 
						AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > @FechaPeriodo09 AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= @FechaPeriodo10)
							OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > @FechaPeriodo09 AND TRANSACCION_INV.fecha_hora_transac <= @FechaPeriodo10 )
						)
					THEN	CASE WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS(TRANSACCION_INV.cantidad) WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS(TRANSACCION_INV.cantidad) ELSE 0 END
					ELSE 0 END
				,0 ) ) AS periodo_10,
				COUNT (0) AS conteo_transacciones
			FROM	$$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
			WHERE	TRANSACCION_INV.articulo BETWEEN ISNULL( @ArticuloDesde, '0') 
				AND ISNULL(@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
				AND TRANSACCION_INV.bodega BETWEEN ISNULL( @BodegaDesde, '0') AND ISNULL(@BodegaHasta,'ZZZZ')
				AND (( @IncluyeVentas = 'S' AND TRANSACCION_INV.tipo = 'V' ) OR ( @IncluyeConsumos = 'S' AND TRANSACCION_INV.tipo = 'C' ))
				AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) >= ISNULL(@FechaDesde,CAST('1980-01-01 00:00:00.000' AS DATETIME)) AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
					OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac >= ISNULL(@FechaDesde,CAST('1980-01-01 00:00:00.000' AS DATETIME)) AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
				)
			GROUP BY TRANSACCION_INV.articulo
			HAVING ( @SoloConMovimientos = 'N' OR ( @SoloConMovimientos = 'S' AND ( ISNULL( COUNT(0),0) > 0))
			)
		) TRANSACCIONES
			ON ARTICULO.articulo = TRANSACCIONES.articulo
	WHERE	ARTICULO.articulo BETWEEN ISNULL( @ArticuloDesde, '0') AND ISNULL(@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
		AND ( @SoloConMovimientos = 'N' OR ( @SoloConMovimientos = 'S' AND ( ISNULL( TRANSACCIONES.conteo_transacciones ,0) > 0)))
		AND ( @SoloConExistencias = 'N' OR ( @SoloConExistencias = 'S' 
				AND (	ISNULL( EXISTENCIA_ACTUAL.disponible, 0 ) 
					+ ISNULL( EXISTENCIA_ACTUAL.reservado, 0 )
					+ ISNULL( EXISTENCIA_ACTUAL.no_aprobado, 0 )
					+ ISNULL( EXISTENCIA_ACTUAL.vencido, 0 )
					+ ISNULL( EXISTENCIA_ACTUAL.remitido, 0 ) ) <> 0 ))
	ORDER BY 1,2
;

CREATE FUNCTION $$COMPANIA$$.RepLibroInvDescGrupo ( 
	@Grupo		AS SMALLINT,
	@CodigoGrupo	AS VARCHAR(254)
)
RETURNS VARCHAR(254) AS BEGIN
	DECLARE @DescripcionGrupo VARCHAR(254)
	SET @DescripcionGrupo = NULL

	IF (ISNULL(@CodigoGrupo, 'ND') <> 'ND' ) BEGIN
		IF (ISNULL(@Grupo,8) > 7 ) BEGIN SET @Grupo = 0 END

		-- Tomar la descripci�n del art�culo
		IF ( @Grupo = 0 ) BEGIN SELECT @DescripcionGrupo = ARTICULO.descripcion FROM $$COMPANIA$$.articulo ARTICULO WHERE ARTICULO.articulo = @CodigoGrupo END

		-- Como es la descripci�n del art�culo se retorna la misma descripci�n
		IF ( @Grupo = 1 ) BEGIN SET @DescripcionGrupo = @CodigoGrupo END

		-- Cualquiera de los otros �ndices posibles es una clasificaci�n
		IF ( @Grupo >= 2 AND @Grupo <= 7 ) BEGIN SELECT @DescripcionGrupo = CLASIFICACION.descripcion FROM $$COMPANIA$$.clasificacion CLASIFICACION WHERE CLASIFICACION.clasificacion = @CodigoGrupo END
	END 

	IF ( @DescripcionGrupo IS NULL ) BEGIN SET @DescripcionGrupo = 'No Definido' END

	RETURN @DescripcionGrupo
END;






CREATE PROCEDURE $$COMPANIA$$.ReporteLibroInventario
  @TipoFecha VARCHAR(1),
  @ArticuloDesde VARCHAR(20),
  @ArticuloHasta VARCHAR(20),
  @BodegaDesde VARCHAR(4),
  @BodegaHasta VARCHAR(4),
  @FechaDesde DATETIME,
  @FechaHasta DATETIME,
  @Grupo SMALLINT,
  @CalcularCostos VARCHAR(1),
  @TipoCosto VARCHAR(1),
  @MonedaCalculo VARCHAR(1),
  @Clasificacion1Desde VARCHAR(12),
  @Clasificacion1Hasta VARCHAR(12),
  @Clasificacion2Desde VARCHAR(12),
  @Clasificacion2Hasta VARCHAR(12),
  @Clasificacion3Desde VARCHAR(12),
  @Clasificacion3Hasta VARCHAR(12),
  @Clasificacion4Desde VARCHAR(12),
  @Clasificacion4Hasta VARCHAR(12),
  @Clasificacion5Desde VARCHAR(12),
  @Clasificacion5Hasta VARCHAR(12),
  @Clasificacion6Desde VARCHAR(12),
  @Clasificacion6Hasta VARCHAR(12),
 @LocalizacionDesde VARCHAR(8),
 @LocalizacionHasta VARCHAR(8)
  AS
    /*La consulta es diferente si se ussan o no localizaciones.*/
  /*Si no se usan localizaciones*/
IF ((@LocalizacionDesde = '' AND @LocalizacionHasta = '' ) OR (@LocalizacionDesde IS NULL AND @LocalizacionHasta IS NULL )) 
SELECT AGRUPADOS.bodega AS bodega,
   BODEGA.nombre AS bodega_descripcion,
   NULL AS Localizacion,
   AGRUPADOS.grupo AS grupo,
     $$COMPANIA$$.RepLibroInvDescGrupo( @Grupo, AGRUPADOS.grupo ) AS grupo_descripcion,
   AGRUPADOS.inventario_ini_unds AS inventario_ini_unds,
   AGRUPADOS.inventario_ini_cost AS inventario_ini_cost,
   AGRUPADOS.compras_unds AS compras_unds,
   AGRUPADOS.compras_cost AS compras_cost,
   AGRUPADOS.compras_dev_unds AS compras_dev_unds,
   AGRUPADOS.compras_dev_cost AS compras_dev_cost,
   AGRUPADOS.traspasos_pos_unds AS traspasos_pos_unds,
   AGRUPADOS.traspasos_pos_cost AS traspasos_pos_cost,
   AGRUPADOS.ajustes_pos_unds AS ajustes_pos_unds,
   CASE 
    WHEN AGRUPADOS.diferencia_por_ajustes > 0
    THEN AGRUPADOS.ajustes_pos_cost + ABS( AGRUPADOS.diferencia_por_ajustes )
    ELSE AGRUPADOS.ajustes_pos_cost END
   AS ajustes_pos_cost,
   AGRUPADOS.ventas_unds AS ventas_unds,
   AGRUPADOS.ventas_cost AS ventas_cost,
   AGRUPADOS.ventas_dev_unds AS ventas_dev_unds,
   AGRUPADOS.ventas_dev_cost AS ventas_dev_cost,
   AGRUPADOS.traspasos_neg_unds AS traspasos_neg_unds,
   AGRUPADOS.traspasos_neg_cost AS traspasos_neg_cost,
   AGRUPADOS.ajustes_neg_unds AS ajustes_neg_unds,
   CASE 
    WHEN AGRUPADOS.diferencia_por_ajustes < 0
    THEN AGRUPADOS.ajustes_neg_cost + ABS( AGRUPADOS.diferencia_por_ajustes )
    ELSE AGRUPADOS.ajustes_neg_cost END
   AS ajustes_neg_cost,
   AGRUPADOS.inventario_fin_unds AS inventario_fin_unds,
   AGRUPADOS.inventario_fin_cost AS inventario_fin_cost
  FROM   $$COMPANIA$$.bodega BODEGA (NOLOCK)
   INNER JOIN (
    SELECT
     ARTICULO_BODEGA.bodega AS bodega,
     NULL AS Localizacion,
     ARTICULO_BODEGA.grupo AS grupo,
     SUM ( ISNULL( ARTICULO_BODEGA.existencia_actual, 0 ) - ISNULL( TRANSACCIONES.dif_existencia_ini, 0 ) )
     AS inventario_ini_unds,
     SUM ( ISNULL( ARTICULO_BODEGA.costo_unitario_ini, 0 ) * ABS(ISNULL( ARTICULO_BODEGA.existencia_actual, 0 ) - ISNULL( TRANSACCIONES.dif_existencia_ini, 0 ) ) )
     AS inventario_ini_cost,
     SUM ( ISNULL( TRANSACCIONES.compras_unds, 0 ) ) AS compras_unds,
     SUM ( ISNULL( TRANSACCIONES.compras_cost, 0 ) ) AS compras_cost,
     SUM ( ISNULL( TRANSACCIONES.compras_dev_unds, 0 ) ) AS compras_dev_unds,
     SUM ( ISNULL( TRANSACCIONES.compras_dev_cost, 0 ) ) AS compras_dev_cost,
     SUM ( ISNULL( TRANSACCIONES.traspasos_pos_unds, 0 ) ) AS traspasos_pos_unds,
     SUM ( ISNULL( TRANSACCIONES.traspasos_pos_cost, 0 ) ) AS traspasos_pos_cost,
     SUM ( ISNULL( TRANSACCIONES.ajustes_pos_unds, 0 ) ) AS ajustes_pos_unds,
     SUM ( ISNULL( TRANSACCIONES.ajustes_pos_cost, 0 ) ) AS ajustes_pos_cost,
     SUM ( ISNULL( TRANSACCIONES.ventas_unds, 0 ) ) AS ventas_unds,
     SUM ( ISNULL( TRANSACCIONES.ventas_cost, 0 ) ) AS ventas_cost,
     SUM ( ISNULL( TRANSACCIONES.ventas_dev_unds, 0 ) ) AS ventas_dev_unds,
     SUM ( ISNULL( TRANSACCIONES.ventas_dev_cost, 0 ) ) AS ventas_dev_cost,
     SUM ( ISNULL( TRANSACCIONES.traspasos_neg_unds, 0 ) ) AS traspasos_neg_unds,
     SUM ( ISNULL( TRANSACCIONES.traspasos_neg_cost, 0 ) ) AS traspasos_neg_cost,
     SUM ( ISNULL( TRANSACCIONES.ajustes_neg_unds, 0 ) ) AS ajustes_neg_unds,
     SUM ( ISNULL( TRANSACCIONES.ajustes_neg_cost, 0 ) ) AS ajustes_neg_cost,
     SUM ( ISNULL( ARTICULO_BODEGA.existencia_actual, 0 ) - ISNULL(TRANSACCIONES.dif_existencia_fin, 0 ) )
     AS inventario_fin_unds,
     SUM ( ISNULL( ARTICULO_BODEGA.costo_unitario_fin, 0 ) * ABS(ISNULL( ARTICULO_BODEGA.existencia_actual, 0 ) - ISNULL( TRANSACCIONES.dif_existencia_fin, 0 ) ) )
     AS inventario_fin_cost,
     SUM ( 
      ( ISNULL( ARTICULO_BODEGA.costo_unitario_fin, 0 ) * ABS(ISNULL( ARTICULO_BODEGA.existencia_actual, 0 ) - ISNULL( TRANSACCIONES.dif_existencia_fin, 0 ) ) ) 
      -
      (
       ( ISNULL( ARTICULO_BODEGA.costo_unitario_ini, 0 ) 
        * ABS( ISNULL(ARTICULO_BODEGA.existencia_actual, 0 ) - ISNULL(TRANSACCIONES.dif_existencia_ini, 0 ) ) )
       + ISNULL( TRANSACCIONES.compras_cost, 0 )
       - ISNULL( TRANSACCIONES.compras_dev_cost, 0 )
       + ISNULL( TRANSACCIONES.traspasos_pos_cost, 0 )
       + ISNULL( TRANSACCIONES.ajustes_pos_cost, 0 )
       - ISNULL( TRANSACCIONES.ventas_cost, 0 )
       + ISNULL( TRANSACCIONES.ventas_dev_cost, 0 )
       - ISNULL( TRANSACCIONES.traspasos_neg_cost, 0 )
       - ISNULL( TRANSACCIONES.ajustes_neg_cost, 0 )
      )
     ) AS diferencia_por_ajustes
    FROM
     (
      SELECT
       EXISTENCIA.bodega AS bodega,
       NULL AS Localizacion,
       DATOS_ARTICULO.articulo AS articulo,
       DATOS_ARTICULO.grupo AS grupo,
       ISNULL( EXISTENCIA.cant_disponible, 0 )
       + ISNULL( EXISTENCIA.cant_reservada, 0 )
       + ISNULL( EXISTENCIA.cant_remitida, 0 )
       + ISNULL( EXISTENCIA.cant_vencida, 0 )
       + ISNULL( EXISTENCIA.cant_no_aprobada, 0 )
       AS existencia_actual,
         $$COMPANIA$$.CostoUnitarioArticuloBodega(
          @CalcularCostos,
          @TipoFecha,
          @FechaDesde,
          'I',
          @TipoCosto,
          @MonedaCalculo,
          GETDATE(),
          DATOS_ARTICULO.articulo,
          DATOS_ARTICULO.costo_fiscal,
          DATOS_ARTICULO.costo_comparativo,
          DATOS_ARTICULO.costo_std_loc,
          DATOS_ARTICULO.costo_std_dol,
          DATOS_ARTICULO.costo_prom_loc,
          DATOS_ARTICULO.costo_prom_dol,
          DATOS_ARTICULO.costo_ult_loc,
          DATOS_ARTICULO.costo_ult_dol, 
          EXISTENCIA.bodega) AS costo_unitario_ini,
          $$COMPANIA$$.CostoUnitarioArticuloBodega(
          @CalcularCostos,
          @TipoFecha,
          @FechaHasta,
          'F',
          @TipoCosto,
          @MonedaCalculo,
          GETDATE(),
          DATOS_ARTICULO.articulo,
          DATOS_ARTICULO.costo_fiscal,
          DATOS_ARTICULO.costo_comparativo,
          DATOS_ARTICULO.costo_std_loc,
          DATOS_ARTICULO.costo_std_dol,
          DATOS_ARTICULO.costo_prom_loc,
          DATOS_ARTICULO.costo_prom_dol,
          DATOS_ARTICULO.costo_ult_loc,
          DATOS_ARTICULO.costo_ult_dol, 
          EXISTENCIA.bodega) AS costo_unitario_fin
      FROM   $$COMPANIA$$.existencia_bodega EXISTENCIA (NOLOCK)
       INNER JOIN (
        SELECT 
         ARTICULO.articulo AS articulo,
         ARTICULO.costo_fiscal,
         ARTICULO.costo_comparativo,
         ARTICULO.costo_std_loc,
         ARTICULO.costo_std_dol,
         ARTICULO.costo_prom_loc,
         ARTICULO.costo_prom_dol,
         ARTICULO.costo_ult_loc,
         ARTICULO.costo_ult_dol, 
         CASE ISNULL ( @Grupo, 0 )
          WHEN 0 THEN ARTICULO.articulo
          WHEN 1 THEN ARTICULO.descripcion
          WHEN 2 THEN ARTICULO.clasificacion_1
          WHEN 3 THEN ARTICULO.clasificacion_2
          WHEN 4 THEN ARTICULO.clasificacion_3
          WHEN 5 THEN ARTICULO.clasificacion_4
          WHEN 6 THEN ARTICULO.clasificacion_5
          WHEN 7 THEN ARTICULO.clasificacion_6
          ELSE ARTICULO.articulo
         END AS grupo
        FROM   $$COMPANIA$$.articulo ARTICULO (NOLOCK)
        WHERE ARTICULO.tipo IN ('T','M','E','R','U','C','B','D','Q')
         AND ARTICULO.articulo BETWEEN ISNULL (@ArticuloDesde,'0') AND ISNULL (@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
         AND ( @Clasificacion1Desde = 'ND' OR ( @Clasificacion1Desde <> 'ND' AND ARTICULO.clasificacion_1 >= @Clasificacion1Desde ) )
         AND ( @Clasificacion1Hasta = 'ND' OR ( @Clasificacion1Hasta <> 'ND' AND ARTICULO.clasificacion_1 <= @Clasificacion1Hasta ) )
         AND ( @Clasificacion2Desde = 'ND' OR ( @Clasificacion2Desde <> 'ND' AND ARTICULO.clasificacion_2 >= @Clasificacion2Desde ) )
         AND ( @Clasificacion2Hasta = 'ND' OR ( @Clasificacion2Hasta <> 'ND' AND ARTICULO.clasificacion_2 <= @Clasificacion2Hasta ) )
         AND ( @Clasificacion3Desde = 'ND' OR ( @Clasificacion3Desde <> 'ND' AND ARTICULO.clasificacion_3 >= @Clasificacion3Desde ) )
         AND ( @Clasificacion3Hasta = 'ND' OR ( @Clasificacion3Hasta <> 'ND' AND ARTICULO.clasificacion_3 <= @Clasificacion3Hasta ) )
         AND ( @Clasificacion4Desde = 'ND' OR ( @Clasificacion4Desde <> 'ND' AND ARTICULO.clasificacion_4 >= @Clasificacion4Desde ) )
         AND ( @Clasificacion4Hasta = 'ND' OR ( @Clasificacion4Hasta <> 'ND' AND ARTICULO.clasificacion_4 <= @Clasificacion4Hasta ) )
         AND ( @Clasificacion5Desde = 'ND' OR ( @Clasificacion5Desde <> 'ND' AND ARTICULO.clasificacion_5 >= @Clasificacion5Desde ) )
         AND ( @Clasificacion5Hasta = 'ND' OR ( @Clasificacion5Hasta <> 'ND' AND ARTICULO.clasificacion_5 <= @Clasificacion5Hasta ) )
         AND ( @Clasificacion6Desde = 'ND' OR ( @Clasificacion6Desde <> 'ND' AND ARTICULO.clasificacion_6 >= @Clasificacion6Desde ) )
         AND ( @Clasificacion6Hasta = 'ND' OR ( @Clasificacion6Hasta <> 'ND' AND ARTICULO.clasificacion_6 <= @Clasificacion6Hasta ) )
       ) DATOS_ARTICULO
        ON EXISTENCIA.articulo = DATOS_ARTICULO.articulo
      WHERE
       EXISTENCIA.bodega BETWEEN @BodegaDesde AND @BodegaHasta
     ) ARTICULO_BODEGA 
     LEFT JOIN (
      SELECT
       TRANSACCION_INV.articulo AS articulo,
       TRANSACCION_INV.bodega AS bodega,
       NULL AS Localizacion,
       SUM ( CASE 
        WHEN TRANSACCION_INV.naturaleza = 'E' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'S' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        ELSE 0 END ) 
       + SUM ( CASE 
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        ELSE 0 END ) 
       + SUM ( CASE 
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        ELSE 0 END )
       + SUM ( CASE 
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'N' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'N' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
        ELSE 0 END ) 
       + SUM ( CASE 
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'A' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'A' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        ELSE 0 END )
       AS dif_existencia_ini,
       SUM ( CASE 
        WHEN (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
         OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )) 
        THEN CASE
         WHEN TRANSACCION_INV.naturaleza = 'E' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
         WHEN TRANSACCION_INV.naturaleza = 'S' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
         ELSE 0 END
        ELSE 0 END )
       + SUM ( CASE 
        WHEN (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
         OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )) 
        THEN CASE 
         WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
         WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
         WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
         WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
         ELSE 0 END
        ELSE 0 END )
       + SUM ( CASE 
        WHEN (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
         OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
        ) 
        THEN CASE 
         WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
         WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
         WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
         WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
         ELSE 0 END
        ELSE 0 END )
       + SUM ( CASE 
        WHEN (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
         OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )) 
        THEN CASE
         WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'N' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
         WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
         WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'N' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
         WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
         ELSE 0 END
        ELSE 0 END )
       + SUM ( CASE 
        WHEN (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
         OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )) 
        THEN CASE
         WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'A' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
         WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
         WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'A' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
         WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
         ELSE 0 END
        ELSE 0 END ) 
       AS dif_existencia_fin,
       SUM ( CASE 
        WHEN TRANSACCION_INV.tipo = 'O' 
         AND TRANSACCION_INV.naturaleza = 'E'
         AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
           OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
        THEN ABS( TRANSACCION_INV.cantidad )
        ELSE 0 END )
       AS compras_unds,
       SUM ( CASE 
        WHEN TRANSACCION_INV.tipo = 'O' 
         AND TRANSACCION_INV.naturaleza = 'E'
         AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
           OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
        THEN CASE
         WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_fisc_loc
         WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_fisc_dol
         WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_comp_loc
         WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_comp_dol
         ELSE 0 END 
        ELSE 0 END )
       AS compras_cost,
       SUM ( CASE 
        WHEN TRANSACCION_INV.tipo = 'O' 
         AND TRANSACCION_INV.naturaleza = 'S'
         AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
           OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
        THEN ABS( TRANSACCION_INV.cantidad )
        ELSE 0 END )
       AS compras_dev_unds,
       SUM ( CASE 
        WHEN TRANSACCION_INV.tipo = 'O' 
         AND TRANSACCION_INV.naturaleza = 'S'
         AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
           OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
        THEN CASE
         WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_fisc_loc
         WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_fisc_dol
         WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_comp_loc
         WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_comp_dol
         ELSE 0 END 
        ELSE 0 END )
       AS compras_dev_cost,
       SUM ( CASE 
        WHEN TRANSACCION_INV.tipo = 'T' 
         AND TRANSACCION_INV.naturaleza = 'E'
         AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
           OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
        THEN ABS( TRANSACCION_INV.cantidad )
        ELSE 0 END )
       AS traspasos_pos_unds,
       SUM ( CASE 
        WHEN TRANSACCION_INV.tipo = 'T' 
         AND TRANSACCION_INV.naturaleza = 'E'
         AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
           OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
        THEN CASE
         WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_fisc_loc
         WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_fisc_dol
         WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_comp_loc
         WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_comp_dol
         ELSE 0 END 
        ELSE 0 END )
       AS traspasos_pos_cost,
       SUM ( CASE 
        WHEN TRANSACCION_INV.naturaleza = 'E' 
         AND TRANSACCION_INV.tipo <> 'O' 
         AND TRANSACCION_INV.tipo <> 'V' 
         AND TRANSACCION_INV.tipo <> 'T' 
         AND TRANSACCION_INV.tipo <> 'N' 
         AND TRANSACCION_INV.tipo <> 'A' 
         AND TRANSACCION_INV.tipo <> 'I' 
         AND TRANSACCION_INV.tipo <> 'R' 
         AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
           OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
        THEN ABS( TRANSACCION_INV.cantidad )
        ELSE 0 END )
       AS ajustes_pos_unds,
       SUM ( CASE 
        WHEN TRANSACCION_INV.naturaleza = 'E' 
         AND TRANSACCION_INV.tipo <> 'O' 
         AND TRANSACCION_INV.tipo <> 'V' 
         AND TRANSACCION_INV.tipo <> 'T' 
         AND TRANSACCION_INV.tipo <> 'N' 
         AND TRANSACCION_INV.tipo <> 'A' 
         AND TRANSACCION_INV.tipo <> 'I' 
         AND TRANSACCION_INV.tipo <> 'R' 
         AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
           OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
        THEN CASE
         WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_fisc_loc
         WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_fisc_dol
         WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_comp_loc
         WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_comp_dol
         ELSE 0 END
        ELSE 0 END )
       AS ajustes_pos_cost,
       SUM ( CASE 
        WHEN TRANSACCION_INV.tipo = 'V' 
         AND TRANSACCION_INV.naturaleza = 'S'
         AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
           OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
        THEN ABS( TRANSACCION_INV.cantidad )
        ELSE 0 END )
       AS ventas_unds,
       SUM ( CASE 
        WHEN TRANSACCION_INV.tipo = 'V' 
         AND TRANSACCION_INV.naturaleza = 'S'
         AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
           OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
        THEN CASE
         WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_fisc_loc
         WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_fisc_dol
         WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_comp_loc
         WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_comp_dol
         ELSE 0 END 
        ELSE 0 END )
       AS ventas_cost,
       SUM ( CASE 
        WHEN TRANSACCION_INV.tipo = 'V' 
         AND TRANSACCION_INV.naturaleza = 'E'
         AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
           OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
        THEN ABS( TRANSACCION_INV.cantidad )
        ELSE 0 END )
       AS ventas_dev_unds,
       SUM ( CASE 
        WHEN TRANSACCION_INV.tipo = 'V' 
         AND TRANSACCION_INV.naturaleza = 'E'
         AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
           OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
        THEN CASE
         WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_fisc_loc
         WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_fisc_dol
         WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_comp_loc
         WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_comp_dol
         ELSE 0 END 
        ELSE 0 END )
       AS ventas_dev_cost,
       SUM ( CASE 
        WHEN TRANSACCION_INV.tipo = 'T' 
         AND TRANSACCION_INV.naturaleza = 'S'
         AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
           OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
        THEN ABS( TRANSACCION_INV.cantidad )
        ELSE 0 END )
       AS traspasos_neg_unds,
       SUM ( CASE 
        WHEN TRANSACCION_INV.tipo = 'T' 
         AND TRANSACCION_INV.naturaleza = 'S'
         AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
           OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
        THEN CASE
         WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_fisc_loc
         WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_fisc_dol
         WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_comp_loc
         WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_comp_dol
         ELSE 0 END 
        ELSE 0 END )
       AS traspasos_neg_cost,
       SUM ( CASE 
        WHEN TRANSACCION_INV.naturaleza = 'S' 
         AND TRANSACCION_INV.tipo <> 'O' 
         AND TRANSACCION_INV.tipo <> 'V' 
         AND TRANSACCION_INV.tipo <> 'T' 
         AND TRANSACCION_INV.tipo <> 'N' 
         AND TRANSACCION_INV.tipo <> 'A' 
         AND TRANSACCION_INV.tipo <> 'I' 
         AND TRANSACCION_INV.tipo <> 'R' 
         AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
           OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
        THEN ABS( TRANSACCION_INV.cantidad )
        ELSE 0 END )
       AS ajustes_neg_unds,
       SUM ( CASE 
        WHEN TRANSACCION_INV.naturaleza = 'S' 
         AND TRANSACCION_INV.tipo <> 'O' 
         AND TRANSACCION_INV.tipo <> 'V' 
         AND TRANSACCION_INV.tipo <> 'T' 
         AND TRANSACCION_INV.tipo <> 'N' 
         AND TRANSACCION_INV.tipo <> 'A' 
         AND TRANSACCION_INV.tipo <> 'I' 
         AND TRANSACCION_INV.tipo <> 'R' 
         AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
           OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
        THEN CASE
         WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_fisc_loc
         WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_fisc_dol
         WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_comp_loc
         WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_comp_dol
         ELSE 0 END
        ELSE 0 END )
       AS ajustes_neg_cost
      FROM
         $$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
      WHERE TRANSACCION_INV.tipo <> 'S'
       AND TRANSACCION_INV.articulo BETWEEN ISNULL (@ArticuloDesde,'0') AND ISNULL (@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
       AND TRANSACCION_INV.bodega BETWEEN ISNULL(@BodegaDesde,'0') AND ISNULL(@BodegaHasta,'ZZZZ')
       AND ( ( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) >= ISNULL(@FechaDesde,CAST('1980-01-01 00:00:00.000' AS DATETIME)) )
        OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac >= ISNULL(@FechaDesde,CAST('1980-01-01 00:00:00.000' AS DATETIME)) ))
      GROUP BY articulo, bodega
     ) TRANSACCIONES
     ON ARTICULO_BODEGA.articulo = TRANSACCIONES.articulo
      AND ARTICULO_BODEGA.bodega = TRANSACCIONES.bodega
    GROUP BY ARTICULO_BODEGA.bodega, ARTICULO_BODEGA.grupo
   ) AGRUPADOS 
   ON AGRUPADOS.bodega = BODEGA.bodega
  ORDER BY 1, 3
 ELSE
 /*La consulta es diferente si se ussan o no localizaciones*/
 /*Si  se usan localizaciones*/
  SELECT AGRUPADOS.bodega AS bodega,
  BODEGA.nombre AS bodega_descripcion,
  AGRUPADOS.localizacion,
  AGRUPADOS.grupo AS grupo,
    $$COMPANIA$$.RepLibroInvDescGrupo( @Grupo, AGRUPADOS.grupo ) AS grupo_descripcion,
  AGRUPADOS.inventario_ini_unds AS inventario_ini_unds,
  AGRUPADOS.inventario_ini_cost AS inventario_ini_cost,
  AGRUPADOS.compras_unds AS compras_unds,
  AGRUPADOS.compras_cost AS compras_cost,
  AGRUPADOS.compras_dev_unds AS compras_dev_unds,
  AGRUPADOS.compras_dev_cost AS compras_dev_cost,
  AGRUPADOS.traspasos_pos_unds AS traspasos_pos_unds,
  AGRUPADOS.traspasos_pos_cost AS traspasos_pos_cost,
  AGRUPADOS.ajustes_pos_unds AS ajustes_pos_unds,
  CASE 
  WHEN AGRUPADOS.diferencia_por_ajustes > 0
  THEN AGRUPADOS.ajustes_pos_cost + ABS( AGRUPADOS.diferencia_por_ajustes )
  ELSE AGRUPADOS.ajustes_pos_cost END
  AS ajustes_pos_cost,
  AGRUPADOS.ventas_unds AS ventas_unds,
  AGRUPADOS.ventas_cost AS ventas_cost,
  AGRUPADOS.ventas_dev_unds AS ventas_dev_unds,
  AGRUPADOS.ventas_dev_cost AS ventas_dev_cost,
  AGRUPADOS.traspasos_neg_unds AS traspasos_neg_unds,
  AGRUPADOS.traspasos_neg_cost AS traspasos_neg_cost,
  AGRUPADOS.ajustes_neg_unds AS ajustes_neg_unds,
  CASE 
  WHEN AGRUPADOS.diferencia_por_ajustes < 0
  THEN AGRUPADOS.ajustes_neg_cost + ABS( AGRUPADOS.diferencia_por_ajustes )
  ELSE AGRUPADOS.ajustes_neg_cost END
  AS ajustes_neg_cost,
  AGRUPADOS.inventario_fin_unds AS inventario_fin_unds,
  AGRUPADOS.inventario_fin_cost AS inventario_fin_cost
  FROM   $$COMPANIA$$.bodega BODEGA (NOLOCK)
  INNER JOIN (
  SELECT
  ARTICULO_BODEGA.bodega AS bodega,
  ARTICULO_BODEGA.localizacion as localizacion,
  ARTICULO_BODEGA.grupo AS grupo,
  SUM ( ISNULL( ARTICULO_BODEGA.existencia_actual, 0 ) - ISNULL( TRANSACCIONES.dif_existencia_ini, 0 ) )
  AS inventario_ini_unds,
  SUM ( ISNULL( ARTICULO_BODEGA.costo_unitario_ini, 0 ) * ABS(ISNULL( ARTICULO_BODEGA.existencia_actual, 0 ) - ISNULL( TRANSACCIONES.dif_existencia_ini, 0 ) ) )
  AS inventario_ini_cost,
  SUM ( ISNULL( TRANSACCIONES.compras_unds, 0 ) ) AS compras_unds,
  SUM ( ISNULL( TRANSACCIONES.compras_cost, 0 ) ) AS compras_cost,
  SUM ( ISNULL( TRANSACCIONES.compras_dev_unds, 0 ) ) AS compras_dev_unds,
  SUM ( ISNULL( TRANSACCIONES.compras_dev_cost, 0 ) ) AS compras_dev_cost,
  SUM ( ISNULL( TRANSACCIONES.traspasos_pos_unds, 0 ) ) AS traspasos_pos_unds,
  SUM ( ISNULL( TRANSACCIONES.traspasos_pos_cost, 0 ) ) AS traspasos_pos_cost,
  SUM ( ISNULL( TRANSACCIONES.ajustes_pos_unds, 0 ) ) AS ajustes_pos_unds,
  SUM ( ISNULL( TRANSACCIONES.ajustes_pos_cost, 0 ) ) AS ajustes_pos_cost,
  SUM ( ISNULL( TRANSACCIONES.ventas_unds, 0 ) ) AS ventas_unds,
  SUM ( ISNULL( TRANSACCIONES.ventas_cost, 0 ) ) AS ventas_cost,
  SUM ( ISNULL( TRANSACCIONES.ventas_dev_unds, 0 ) ) AS ventas_dev_unds,
  SUM ( ISNULL( TRANSACCIONES.ventas_dev_cost, 0 ) ) AS ventas_dev_cost,
  SUM ( ISNULL( TRANSACCIONES.traspasos_neg_unds, 0 ) ) AS traspasos_neg_unds,
  SUM ( ISNULL( TRANSACCIONES.traspasos_neg_cost, 0 ) ) AS traspasos_neg_cost,
  SUM ( ISNULL( TRANSACCIONES.ajustes_neg_unds, 0 ) ) AS ajustes_neg_unds,
  SUM ( ISNULL( TRANSACCIONES.ajustes_neg_cost, 0 ) ) AS ajustes_neg_cost,
  SUM ( ISNULL( ARTICULO_BODEGA.existencia_actual, 0 ) - ISNULL(TRANSACCIONES.dif_existencia_fin, 0 ) )
  AS inventario_fin_unds,
  SUM ( ISNULL( ARTICULO_BODEGA.costo_unitario_fin, 0 ) * ABS(ISNULL( ARTICULO_BODEGA.existencia_actual, 0 ) - ISNULL( TRANSACCIONES.dif_existencia_fin, 0 ) ) )
  AS inventario_fin_cost,
  SUM ( 
  ( ISNULL( ARTICULO_BODEGA.costo_unitario_fin, 0 ) * ABS(ISNULL( ARTICULO_BODEGA.existencia_actual, 0 ) - ISNULL( TRANSACCIONES.dif_existencia_fin, 0 ) ) ) 
  -
  (
  ( ISNULL( ARTICULO_BODEGA.costo_unitario_ini, 0 ) 
  * ABS( ISNULL(ARTICULO_BODEGA.existencia_actual, 0 ) - ISNULL(TRANSACCIONES.dif_existencia_ini, 0 ) ) )
  + ISNULL( TRANSACCIONES.compras_cost, 0 )
  - ISNULL( TRANSACCIONES.compras_dev_cost, 0 )
  + ISNULL( TRANSACCIONES.traspasos_pos_cost, 0 )
  + ISNULL( TRANSACCIONES.ajustes_pos_cost, 0 )
  - ISNULL( TRANSACCIONES.ventas_cost, 0 )
  + ISNULL( TRANSACCIONES.ventas_dev_cost, 0 )
  - ISNULL( TRANSACCIONES.traspasos_neg_cost, 0 )
  - ISNULL( TRANSACCIONES.ajustes_neg_cost, 0 )
  )
  ) AS diferencia_por_ajustes
  FROM
  (
  SELECT
  EXISTENCIA.bodega AS bodega,
  existencia_lote_rec.LOCALIZACION as localizacion,
  DATOS_ARTICULO.articulo AS articulo,
  DATOS_ARTICULO.grupo AS grupo, 
   ISNULL(ISNULL( existencia_lote_rec.cant_disponible, EXISTENCIA.cant_disponible), 0 )
  + ISNULL(ISNULL( existencia_lote_rec.cant_reservada,  EXISTENCIA.cant_reservada), 0 )
  + ISNULL(ISNULL( existencia_lote_rec.cant_remitida,  EXISTENCIA.cant_remitida), 0 )
  + ISNULL(ISNULL( existencia_lote_rec.cant_vencida,  EXISTENCIA.cant_vencida), 0 )
  + ISNULL(ISNULL( existencia_lote_rec.cant_no_aprobada,  EXISTENCIA.cant_no_aprobada), 0 )
  AS existencia_actual,
  
    $$COMPANIA$$.CostoUnitarioArticuloBodega(
  @CalcularCostos,
  @TipoFecha,
  @FechaDesde,
  'I',
  @TipoCosto,
  @MonedaCalculo,
  GETDATE(),
  DATOS_ARTICULO.articulo,
  DATOS_ARTICULO.costo_fiscal,
  DATOS_ARTICULO.costo_comparativo,
  DATOS_ARTICULO.costo_std_loc,
  DATOS_ARTICULO.costo_std_dol,
  DATOS_ARTICULO.costo_prom_loc,
  DATOS_ARTICULO.costo_prom_dol,
  DATOS_ARTICULO.costo_ult_loc,
  DATOS_ARTICULO.costo_ult_dol, 
  EXISTENCIA.bodega) AS costo_unitario_ini,
    $$COMPANIA$$.CostoUnitarioArticuloBodega(
  @CalcularCostos,
  @TipoFecha,
  @FechaHasta,
  'F',
  @TipoCosto,
  @MonedaCalculo,
  GETDATE(),
  DATOS_ARTICULO.articulo,
  DATOS_ARTICULO.costo_fiscal,
  DATOS_ARTICULO.costo_comparativo,
  DATOS_ARTICULO.costo_std_loc,
  DATOS_ARTICULO.costo_std_dol,
  DATOS_ARTICULO.costo_prom_loc,
  DATOS_ARTICULO.costo_prom_dol,
  DATOS_ARTICULO.costo_ult_loc,
  DATOS_ARTICULO.costo_ult_dol, 
  EXISTENCIA.bodega) AS costo_unitario_fin
  FROM   $$COMPANIA$$.existencia_bodega EXISTENCIA (NOLOCK)
 LEFT JOIN   (SELECT ARTICULO,BODEGA, LOCALIZACION,SUM(CANT_DISPONIBLE) CANT_DISPONIBLE , SUM(CANT_RESERVADA) CANT_RESERVADA,SUM(CANT_NO_APROBADA) CANT_NO_APROBADA,SUM(CANT_VENCIDA) CANT_VENCIDA,SUM(CANT_REMITIDA) CANT_REMITIDA
 from $$COMPANIA$$.existencia_lote (NOLOCK)
 Group by ARTICULO,BODEGA, LOCALIZACION) existencia_lote_rec
 ON EXISTENCIA.bodega = existencia_lote_rec.bodega
 and EXISTENCIA.articulo = existencia_lote_rec.articulo
  INNER JOIN (
  SELECT 
  ARTICULO.articulo AS articulo,
  ARTICULO.costo_fiscal,
  ARTICULO.costo_comparativo,
  ARTICULO.costo_std_loc,
  ARTICULO.costo_std_dol,
  ARTICULO.costo_prom_loc,
  ARTICULO.costo_prom_dol,
  ARTICULO.costo_ult_loc,
  ARTICULO.costo_ult_dol, 
  CASE ISNULL ( @Grupo, 0 )
  WHEN 0 THEN ARTICULO.articulo
  WHEN 1 THEN ARTICULO.descripcion
  WHEN 2 THEN ARTICULO.clasificacion_1
  WHEN 3 THEN ARTICULO.clasificacion_2
  WHEN 4 THEN ARTICULO.clasificacion_3
  WHEN 5 THEN ARTICULO.clasificacion_4
  WHEN 6 THEN ARTICULO.clasificacion_5
  WHEN 7 THEN ARTICULO.clasificacion_6
  ELSE ARTICULO.articulo
  END AS grupo
  FROM   $$COMPANIA$$.articulo ARTICULO (NOLOCK)
  WHERE ARTICULO.tipo IN ('T','M','E','R','U','C','B','D','Q')
  AND ARTICULO.articulo BETWEEN ISNULL (@ArticuloDesde,'0') AND ISNULL (@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
  AND ( @Clasificacion1Desde = 'ND' OR ( @Clasificacion1Desde <> 'ND' AND ARTICULO.clasificacion_1 >= @Clasificacion1Desde ) )
  AND ( @Clasificacion1Hasta = 'ND' OR ( @Clasificacion1Hasta <> 'ND' AND ARTICULO.clasificacion_1 <= @Clasificacion1Hasta ) )
  AND ( @Clasificacion2Desde = 'ND' OR ( @Clasificacion2Desde <> 'ND' AND ARTICULO.clasificacion_2 >= @Clasificacion2Desde ) )
  AND ( @Clasificacion2Hasta = 'ND' OR ( @Clasificacion2Hasta <> 'ND' AND ARTICULO.clasificacion_2 <= @Clasificacion2Hasta ) )
  AND ( @Clasificacion3Desde = 'ND' OR ( @Clasificacion3Desde <> 'ND' AND ARTICULO.clasificacion_3 >= @Clasificacion3Desde ) )
  AND ( @Clasificacion3Hasta = 'ND' OR ( @Clasificacion3Hasta <> 'ND' AND ARTICULO.clasificacion_3 <= @Clasificacion3Hasta ) )
  AND ( @Clasificacion4Desde = 'ND' OR ( @Clasificacion4Desde <> 'ND' AND ARTICULO.clasificacion_4 >= @Clasificacion4Desde ) )
  AND ( @Clasificacion4Hasta = 'ND' OR ( @Clasificacion4Hasta <> 'ND' AND ARTICULO.clasificacion_4 <= @Clasificacion4Hasta ) )
  AND ( @Clasificacion5Desde = 'ND' OR ( @Clasificacion5Desde <> 'ND' AND ARTICULO.clasificacion_5 >= @Clasificacion5Desde ) )
  AND ( @Clasificacion5Hasta = 'ND' OR ( @Clasificacion5Hasta <> 'ND' AND ARTICULO.clasificacion_5 <= @Clasificacion5Hasta ) )
  AND ( @Clasificacion6Desde = 'ND' OR ( @Clasificacion6Desde <> 'ND' AND ARTICULO.clasificacion_6 >= @Clasificacion6Desde ) )
  AND ( @Clasificacion6Hasta = 'ND' OR ( @Clasificacion6Hasta <> 'ND' AND ARTICULO.clasificacion_6 <= @Clasificacion6Hasta ) )
  ) DATOS_ARTICULO
  ON EXISTENCIA.articulo = DATOS_ARTICULO.articulo
  WHERE
  EXISTENCIA.bodega BETWEEN @BodegaDesde AND @BodegaHasta
  and existencia_lote_rec.LOCALIZACION BETWEEN   @LocalizacionDesde AND @LocalizacionHasta
 
  ) ARTICULO_BODEGA 
  LEFT JOIN (
  SELECT
  TRANSACCION_INV.articulo AS articulo,
  TRANSACCION_INV.bodega AS bodega,
  TRANSACCION_INV.localizacion as localizacion,
  SUM ( CASE 
  WHEN TRANSACCION_INV.naturaleza = 'E' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'S' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  ELSE 0 END ) 
  + SUM ( CASE 
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  ELSE 0 END ) 
  + SUM ( CASE 
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  ELSE 0 END )
  + SUM ( CASE 
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'N' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'N' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
  ELSE 0 END ) 
  + SUM ( CASE 
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'A' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'A' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  ELSE 0 END )
  AS dif_existencia_ini,
  SUM ( CASE 
  WHEN (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )) 
  THEN CASE
  WHEN TRANSACCION_INV.naturaleza = 'E' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'S' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  ELSE 0 END
  ELSE 0 END )
  + SUM ( CASE 
  WHEN (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )) 
  THEN CASE 
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  ELSE 0 END
  ELSE 0 END )
  + SUM ( CASE 
  WHEN (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
  ) 
  THEN CASE 
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  ELSE 0 END
  ELSE 0 END )
  + SUM ( CASE 
  WHEN (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )) 
  THEN CASE
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'N' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'N' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
  ELSE 0 END
  ELSE 0 END )
  + SUM ( CASE 
  WHEN (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )) 
  THEN CASE
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'A' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'A' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
  WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
  ELSE 0 END
  ELSE 0 END ) 
  AS dif_existencia_fin,
  SUM ( CASE 
  WHEN TRANSACCION_INV.tipo = 'O' 
  AND TRANSACCION_INV.naturaleza = 'E'
  AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
  THEN ABS( TRANSACCION_INV.cantidad )
  ELSE 0 END )
  AS compras_unds,
  SUM ( CASE 
  WHEN TRANSACCION_INV.tipo = 'O' 
  AND TRANSACCION_INV.naturaleza = 'E'
  AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
  THEN CASE
  WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_fisc_loc
  WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_fisc_dol
  WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_comp_loc
  WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_comp_dol
  ELSE 0 END 
  ELSE 0 END )
  AS compras_cost,
  SUM ( CASE 
  WHEN TRANSACCION_INV.tipo = 'O' 
  AND TRANSACCION_INV.naturaleza = 'S'
  AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
  THEN ABS( TRANSACCION_INV.cantidad )
  ELSE 0 END )
  AS compras_dev_unds,
  SUM ( CASE 
  WHEN TRANSACCION_INV.tipo = 'O' 
  AND TRANSACCION_INV.naturaleza = 'S'
  AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
  THEN CASE
  WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_fisc_loc
  WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_fisc_dol
  WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_comp_loc
  WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_comp_dol
  ELSE 0 END 
  ELSE 0 END )
  AS compras_dev_cost,
  SUM ( CASE 
  WHEN TRANSACCION_INV.tipo = 'T' 
  AND TRANSACCION_INV.naturaleza = 'E'
  AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
  THEN ABS( TRANSACCION_INV.cantidad )
  ELSE 0 END )
  AS traspasos_pos_unds,
  SUM ( CASE 
  WHEN TRANSACCION_INV.tipo = 'T' 
  AND TRANSACCION_INV.naturaleza = 'E'
  AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
  THEN CASE
  WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_fisc_loc
  WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_fisc_dol
  WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_comp_loc
  WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_comp_dol
  ELSE 0 END 
  ELSE 0 END )
  AS traspasos_pos_cost,
  SUM ( CASE 
  WHEN TRANSACCION_INV.naturaleza = 'E' 
  AND TRANSACCION_INV.tipo <> 'O' 
  AND TRANSACCION_INV.tipo <> 'V' 
  AND TRANSACCION_INV.tipo <> 'T' 
  AND TRANSACCION_INV.tipo <> 'N' 
  AND TRANSACCION_INV.tipo <> 'A' 
  AND TRANSACCION_INV.tipo <> 'I' 
  AND TRANSACCION_INV.tipo <> 'R' 
  AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
  THEN ABS( TRANSACCION_INV.cantidad )
  ELSE 0 END )
  AS ajustes_pos_unds,
  SUM ( CASE 
  WHEN TRANSACCION_INV.naturaleza = 'E' 
  AND TRANSACCION_INV.tipo <> 'O' 
  AND TRANSACCION_INV.tipo <> 'V' 
  AND TRANSACCION_INV.tipo <> 'T' 
  AND TRANSACCION_INV.tipo <> 'N' 
  AND TRANSACCION_INV.tipo <> 'A' 
  AND TRANSACCION_INV.tipo <> 'I' 
  AND TRANSACCION_INV.tipo <> 'R' 
  AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
  THEN CASE
  WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_fisc_loc
  WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_fisc_dol
  WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_comp_loc
  WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_comp_dol
  ELSE 0 END
  ELSE 0 END )
  AS ajustes_pos_cost,
  SUM ( CASE 
  WHEN TRANSACCION_INV.tipo = 'V' 
  AND TRANSACCION_INV.naturaleza = 'S'
  AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
  THEN ABS( TRANSACCION_INV.cantidad )
  ELSE 0 END )
  AS ventas_unds,
  SUM ( CASE 
  WHEN TRANSACCION_INV.tipo = 'V' 
  AND TRANSACCION_INV.naturaleza = 'S'
  AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
  THEN CASE
  WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_fisc_loc
  WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_fisc_dol
  WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_comp_loc
  WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_comp_dol
  ELSE 0 END 
  ELSE 0 END )
  AS ventas_cost,
  SUM ( CASE 
  WHEN TRANSACCION_INV.tipo = 'V' 
  AND TRANSACCION_INV.naturaleza = 'E'
  AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
  THEN ABS( TRANSACCION_INV.cantidad )
  ELSE 0 END )
  AS ventas_dev_unds,
  SUM ( CASE 
  WHEN TRANSACCION_INV.tipo = 'V' 
  AND TRANSACCION_INV.naturaleza = 'E'
  AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
  THEN CASE
  WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_fisc_loc
  WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_fisc_dol
  WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_comp_loc
  WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_comp_dol
  ELSE 0 END 
  ELSE 0 END )
  AS ventas_dev_cost,
  SUM ( CASE 
  WHEN TRANSACCION_INV.tipo = 'T' 
  AND TRANSACCION_INV.naturaleza = 'S'
  AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
  THEN ABS( TRANSACCION_INV.cantidad )
  ELSE 0 END )
  AS traspasos_neg_unds,
  SUM ( CASE 
  WHEN TRANSACCION_INV.tipo = 'T' 
  AND TRANSACCION_INV.naturaleza = 'S'
  AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
  THEN CASE
  WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_fisc_loc
  WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_fisc_dol
  WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_comp_loc
  WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_comp_dol
  ELSE 0 END 
  ELSE 0 END )
  AS traspasos_neg_cost,
  SUM ( CASE 
  WHEN TRANSACCION_INV.naturaleza = 'S' 
  AND TRANSACCION_INV.tipo <> 'O' 
  AND TRANSACCION_INV.tipo <> 'V' 
  AND TRANSACCION_INV.tipo <> 'T' 
  AND TRANSACCION_INV.tipo <> 'N' 
  AND TRANSACCION_INV.tipo <> 'A' 
  AND TRANSACCION_INV.tipo <> 'I' 
  AND TRANSACCION_INV.tipo <> 'R' 
  AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
  THEN ABS( TRANSACCION_INV.cantidad )
  ELSE 0 END )
  AS ajustes_neg_unds,
  SUM ( CASE 
  WHEN TRANSACCION_INV.naturaleza = 'S' 
  AND TRANSACCION_INV.tipo <> 'O' 
  AND TRANSACCION_INV.tipo <> 'V' 
  AND TRANSACCION_INV.tipo <> 'T' 
  AND TRANSACCION_INV.tipo <> 'N' 
  AND TRANSACCION_INV.tipo <> 'A' 
  AND TRANSACCION_INV.tipo <> 'I' 
  AND TRANSACCION_INV.tipo <> 'R' 
  AND (( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)))
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac <= ISNULL(@FechaHasta,CAST('2050-12-31 23:59:59.998' AS DATETIME)) ))
  THEN CASE
  WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_fisc_loc
  WHEN @TipoCosto = 'F' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_fisc_dol
  WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'L' THEN TRANSACCION_INV.costo_tot_comp_loc
  WHEN @TipoCosto = 'P' AND @MonedaCalculo = 'D' THEN TRANSACCION_INV.costo_tot_comp_dol
  ELSE 0 END
  ELSE 0 END )
  AS ajustes_neg_cost
  FROM
    $$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
  WHERE TRANSACCION_INV.tipo <> 'S'
  AND TRANSACCION_INV.articulo BETWEEN ISNULL (@ArticuloDesde,'0') AND ISNULL (@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
  AND TRANSACCION_INV.bodega BETWEEN ISNULL(@BodegaDesde,'0') AND ISNULL(@BodegaHasta,'ZZZZ')
  AND ( ( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) >= ISNULL(@FechaDesde,CAST('1980-01-01 00:00:00.000' AS DATETIME)) )
  OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac >= ISNULL(@FechaDesde,CAST('1980-01-01 00:00:00.000' AS DATETIME)) ))
  GROUP BY articulo, bodega,localizacion) TRANSACCIONES
  ON ARTICULO_BODEGA.articulo = TRANSACCIONES.articulo
  AND ARTICULO_BODEGA.bodega = TRANSACCIONES.bodega
  AND ARTICULO_BODEGA.localizacion = TRANSACCIONES.localizacion
  GROUP BY ARTICULO_BODEGA.bodega, ARTICULO_BODEGA.grupo, ARTICULO_BODEGA.localizacion) AGRUPADOS 
  ON AGRUPADOS.bodega = BODEGA.bodega
 ORDER BY 1, 3;
 
  

CREATE PROCEDURE $$Compania$$.RepValoracionInvResumenCtas
  @TipoFecha  VARCHAR(1),
  @ArticuloDesde  VARCHAR(20),
  @ArticuloHasta  VARCHAR(20),
  @BodegaDesde  VARCHAR(4),
  @BodegaHasta  VARCHAR(4),
  @FechaFinal  DATETIME,
  @CalcularCostos  VARCHAR(1),
  @TipoCosto  VARCHAR(1),
  @MonedaCalculo  VARCHAR(1),
  @SoloConExistencia VARCHAR(1),
  @ConDisponible  VARCHAR(1),
  @ConReservado  VARCHAR(1),
  @ConNoAprobado  VARCHAR(1),
  @ConVencido  VARCHAR(1),
  @ConRemitido  VARCHAR(1),
  @ConTransito  VARCHAR(1),
  @ConPorDespachar VARCHAR(1)
 AS
  SELECT 
  ARTCTA.CTR_INVENTARIO as centro_costo,
  ARTCTA.CTA_INVENTARIO as cuenta_contable,
  ARTICULO.articulo, 
  ARTICULO.descripcion, 
  ARTICULO.tipo,
  ARTICULO.clasificacion_1,
  ARTICULO.clasificacion_2,
  ARTICULO.clasificacion_3,
  ARTICULO.clasificacion_4,
  ARTICULO.clasificacion_5,
  ARTICULO.clasificacion_6,
  ARTICULO.unidad_almacen,
  ARTICULO.factor_empaque,
  ARTICULO.unidad_empaque,
  ARTICULO.codigo_barras_invt,
  ARTICULO.codigo_barras_vent,
  ARTICULO.activo,
  ARTICULO.articulo_cuenta,
  ARTICULO.clase_abc,
  ARTICULO.proveedor,
  ARTICULO.tipo_cod_barra_alm,
  ARTICULO.tipo_cod_barra_det,
  ARTICULO.ultima_salida,
  ARTICULO.ultimo_ingreso,
  ARTICULO.ultimo_movimiento,
  ARTICULO.usa_lotes,
  ARTICULO.utilizado_manufact,
  ARTICULO.existencia_minima AS articulo_exist_min,
  EXISTENCIA_BODEGA.bodega,
  BODEGA.nombre AS bodega_descripcion,
   EXISTENCIA_BODEGA.existencia_minima AS bodega_exist_min,
   (CASE WHEN @ConDisponible = 'S' THEN ISNULL (ISNULL(CIERRE.CANT_DISPONIBLE,EXISTENCIA_BODEGA.cant_disponible),0) - ISNULL(EXISTENCIA.disponible,0) ELSE 0 END ) AS disponible, 
   (CASE WHEN @ConReservado = 'S' THEN ISNULL (ISNULL(CIERRE.cant_reservada, EXISTENCIA_BODEGA.cant_reservada),0) - ISNULL(EXISTENCIA.reservado,0) ELSE 0 END ) AS reservado,
   (CASE WHEN @ConVencido = 'S' THEN ISNULL ( ISNULL(CIERRE.cant_vencida,EXISTENCIA_BODEGA.cant_vencida),0) - ISNULL(EXISTENCIA.vencido,0) ELSE 0 END ) AS vencido,
   (CASE WHEN @ConNoAprobado = 'S' THEN ISNULL (ISNULL(CIERRE.cant_no_aprobada, EXISTENCIA_BODEGA.cant_no_aprobada),0) - ISNULL(EXISTENCIA.no_aprobada,0) ELSE 0 END ) AS no_aprobado,
   (CASE WHEN @ConRemitido = 'S' THEN ISNULL (ISNULL(CIERRE.cant_remitida, EXISTENCIA_BODEGA.cant_remitida),0) - ISNULL(EXISTENCIA.remitida,0) ELSE 0 END ) AS remitido,
   (CASE WHEN @ConTransito = 'S' THEN ISNULL ( EXISTENCIA_BODEGA.cant_transito, 0 ) ELSE 0 END ) AS transito,
   (CASE WHEN @ConPorDespachar = 'S' THEN 
    $$Compania$$.CantidadPorDespacharArticulo ( @ConPorDespachar, @TipoFecha, @FechaFinal, 'F', ERPADMIN.SF_GETDATE(), ARTICULO.articulo, EXISTENCIA_BODEGA.bodega )
    ELSE 0 END ) AS por_despachar,
   (CASE WHEN @CalcularCostos = 'S' 
    AND (((CASE WHEN @ConDisponible = 'S' THEN ISNULL ( ISNULL(CIERRE.CANT_DISPONIBLE,EXISTENCIA_BODEGA.cant_disponible) - ISNULL(EXISTENCIA.disponible,0),0) ELSE 0 END )
     + (CASE WHEN @ConReservado = 'S' THEN ISNULL ( ISNULL(CIERRE.cant_reservada,EXISTENCIA_BODEGA.cant_reservada )- ISNULL(EXISTENCIA.reservado,0),0) ELSE 0 END )
     + (CASE WHEN @ConVencido = 'S' THEN ISNULL ( ISNULL(CIERRE.cant_vencida,EXISTENCIA_BODEGA.cant_vencida) - ISNULL(EXISTENCIA.vencido,0),0) ELSE 0 END )
     + (CASE WHEN @ConNoAprobado = 'S' THEN ISNULL ( ISNULL(CIERRE.cant_no_aprobada,EXISTENCIA_BODEGA.cant_no_aprobada) - ISNULL(EXISTENCIA.no_aprobada,0),0) ELSE 0 END )
     + (CASE WHEN @ConRemitido = 'S' THEN ISNULL ( ISNULL(CIERRE.cant_remitida,EXISTENCIA_BODEGA.cant_remitida) - ISNULL(EXISTENCIA.remitida,0),0) ELSE 0 END ) ) <> 0)
   THEN $$Compania$$.CostoUnitarioArticuloBodega(
    @CalcularCostos,
    @TipoFecha,
    @FechaFinal,
    'F',
    @TipoCosto,
    @MonedaCalculo,
    ERPADMIN.SF_GETDATE(),
    ARTICULO.articulo,
    ARTICULO.costo_fiscal,
    ARTICULO.costo_comparativo,
    ARTICULO.costo_std_loc,
    ARTICULO.costo_std_dol,
    ARTICULO.costo_prom_loc,
    ARTICULO.costo_prom_dol,
    ARTICULO.costo_ult_loc,
    ARTICULO.costo_ult_dol,
    EXISTENCIA_BODEGA.BODEGA ) 
   ELSE 0 END )AS costo_unitario
 FROM $$Compania$$.existencia_bodega EXISTENCIA_BODEGA (NOLOCK)
  LEFT JOIN (
   SELECT articulo,
    bodega,
    SUM ( CASE
     WHEN TRANSACCION_INV.naturaleza = 'E' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
     WHEN TRANSACCION_INV.naturaleza = 'S' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
     ELSE 0 END
    ) AS disponible,
    SUM ( CASE 
     WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
     WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
     WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
     WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
     ELSE 0 END
    ) AS reservado,
    SUM ( CASE
     WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'N' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
     WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
     WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'N' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
     WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
     ELSE 0 END
    ) AS vencido,
    SUM ( CASE
     WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'A' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
     WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
     WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'A' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
     WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
     ELSE 0 END
    ) AS no_aprobada,
    SUM ( CASE 
     WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
     WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
     WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
     WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
     ELSE 0 END
    ) AS remitida
   FROM $$Compania$$.transaccion_inv TRANSACCION_INV (NOLOCK)
   WHERE TRANSACCION_INV.tipo IN ( 'A', 'C', 'E', 'F', 'I', 'M', 'N', 'O', 'P', 'R', 'T', 'V' )
    AND TRANSACCION_INV.articulo BETWEEN ISNULL (@ArticuloDesde,'0') AND ISNULL (@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
    AND TRANSACCION_INV.bodega BETWEEN ISNULL(@BodegaDesde,'0') AND ISNULL(@BodegaHasta,'ZZZZ')
    AND ( ( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > ISNULL(@FechaFinal,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
     OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > ISNULL(@FechaFinal,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
    )
   GROUP BY articulo, bodega
  ) EXISTENCIA
   ON EXISTENCIA_BODEGA.articulo = EXISTENCIA.articulo 
   AND EXISTENCIA_BODEGA.bodega = EXISTENCIA.bodega
  INNER JOIN $$Compania$$.bodega BODEGA (NOLOCK)
   ON EXISTENCIA_BODEGA.bodega = BODEGA.bodega
  INNER JOIN $$Compania$$.articulo ARTICULO (NOLOCK)
   ON EXISTENCIA_BODEGA.articulo = ARTICULO.articulo
  INNER JOIN $$Compania$$.articulo_cuenta ARTCTA (NOLOCK)
   ON ARTICULO.articulo_cuenta = ARTCTA.articulo_cuenta
   LEFT JOIN (SELECT ARTICULO,BODEGA,CANT_DISPONIBLE,CANT_RESERVADA, CANT_NO_APROBADA,CANT_VENCIDA,CANT_REMITIDA,TIPO_COSTO,COSTO_FISC_UNT_LOC, COSTO_FISC_UNT_DOL,FECHA_CIERRE
					FROM  $$Compania$$.EXISTENCIA_CIERRE A
					WHERE FECHA_CIERRE = ( SELECT MAX(fecha_cierre)
											FROM $$Compania$$.EXISTENCIA_CIERRE B
											WHERE A.ARTICULO = B.ARTICULO
											AND A.FECHA_CIERRE >= @FechaFinal
											AND a.TIPO_FECHA = @TipoFecha ) )CIERRE
	ON EXISTENCIA_BODEGA.articulo = CIERRE.articulo 
	   AND EXISTENCIA_BODEGA.bodega = CIERRE.bodega
 WHERE ( @SoloConExistencia = 'N'
   OR ( @SoloConExistencia = 'S' 
    AND (((CASE WHEN @ConDisponible = 'S' THEN ISNULL ( ISNULL(CIERRE.CANT_DISPONIBLE,EXISTENCIA_BODEGA.cant_disponible),0) - ISNULL(EXISTENCIA.disponible,0) ELSE 0 END )
     + (CASE WHEN @ConReservado = 'S' THEN ISNULL ( ISNULL(CIERRE.cant_reservada,EXISTENCIA_BODEGA.cant_reservada),0) - ISNULL(EXISTENCIA.reservado,0) ELSE 0 END )
     + (CASE WHEN @ConVencido = 'S' THEN ISNULL ( ISNULL(CIERRE.cant_vencida,EXISTENCIA_BODEGA.cant_vencida),0) - ISNULL(EXISTENCIA.vencido,0) ELSE 0 END )
     + (CASE WHEN @ConNoAprobado = 'S' THEN ISNULL (ISNULL(CIERRE.cant_no_aprobada, EXISTENCIA_BODEGA.cant_no_aprobada),0) - ISNULL(EXISTENCIA.no_aprobada,0) ELSE 0 END )
     + (CASE WHEN @ConRemitido = 'S' THEN ISNULL ( ISNULL(CIERRE.cant_remitida,EXISTENCIA_BODEGA.cant_remitida),0) - ISNULL(EXISTENCIA.remitida,0) ELSE 0 END ) ) <> 0
   ) ) )
  AND ARTICULO.tipo IN ('T','M','E','R','U','C','B','D','Q')
  AND ARTICULO.articulo BETWEEN ISNULL (@ArticuloDesde,'0') AND ISNULL (@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
  AND EXISTENCIA_BODEGA.bodega BETWEEN ISNULL(@BodegaDesde,'0') AND ISNULL(@BodegaHasta,'ZZZZ')
 ORDER BY 1, 2, 29, 3;
 
 


CREATE FUNCTION $$Compania$$.CostoUnitarioArtBod( 
  @Calcular  AS VARCHAR(1),
  @TipoDeFecha  AS VARCHAR(1),
  @FechaReconstuye AS DATETIME,
  @HorasAUtilizar  AS VARCHAR(1),
  @TipoCosto   AS VARCHAR(1),
  @MonedaCalculo  AS VARCHAR(1),
  @FechaActual  AS DATETIME,
  @CodigoArticulo  AS VARCHAR(20),
  @CosteoFiscal  AS VARCHAR(1),
  @CosteoComparativo AS VARCHAR(1),
  @CostoEstandarLocal AS DECIMAL(28,8),
  @CostoEstandarDolar AS DECIMAL(28,8),
  @CostoPromedioLocal AS DECIMAL(28,8),
  @CostoPromedioDolar AS DECIMAL(28,8),
  @CostoUltimoLocal AS DECIMAL(28,8),
  @CostoUltimoDolar AS DECIMAL(28,8),
  @Bodega AS VARCHAR(10)
 )
 RETURNS DECIMAL(28,8) AS BEGIN
  DECLARE @CostoUnitario  DECIMAL(28,8)
  DECLARE @DiferenciaValorLocal DECIMAL(28,8)
  DECLARE @DiferenciaValorDolar DECIMAL(28,8)
  DECLARE @ValorActualLocal DECIMAL(28,8)
  DECLARE @ValorActualDolar DECIMAL(28,8)
  DECLARE @DiferenciaExistencia DECIMAL(28,8)
  DECLARE @ExistenciaActual DECIMAL(28,8)
  DECLARE @TipoCosteoArticulo VARCHAR(1)
  DECLARE @FechaDocumento  DATETIME
  DECLARE @FechaAuditoria  DATETIME
  DECLARE @AuditoriaTransac INT
  DECLARE @ConsecutivoTransac INT
  DECLARE @FechaCierreAnterior AS DATETIME
  DECLARE @CosteoArticuloBodega AS Varchar(1)
  DECLARE @CostoFiscalLocalCierre AS DECIMAL(28,8)
  DECLARE @CostoFiscalDolarCierre AS DECIMAL(28,8)
  DECLARE @CostoCompLocalCierre AS DECIMAL(28,8)
  DECLARE @CostoCompDolarCierre AS DECIMAL(28,8)
  DECLARE @CostoPromedioLocBod AS DECIMAL(28,8)
  DECLARE @CostoPromedioDolBod AS DECIMAL(28,8)
 
  IF (ISNULL(@CodigoArticulo,'ND') = 'ND' OR @Calcular = 'N' ) BEGIN RETURN 0 END
 
  SET @TipoDeFecha = UPPER( @TipoDeFecha )
  IF ( ISNULL(@TipoDeFecha,'') <> 'D' ) BEGIN SET @TipoDeFecha = 'A' END
  
  SET @TipoCosto = UPPER( @TipoCosto )
  IF ( ISNULL(@TipoCosto,'') <> 'P' AND ISNULL(@TipoCosto,'') <> 'L' ) BEGIN SET @TipoCosto = 'F' END
 
  SET @MonedaCalculo = UPPER( @MonedaCalculo )
  IF ( ISNULL(@MonedaCalculo,'') <> 'D' ) BEGIN SET @MonedaCalculo = 'L' END
 
  IF (@FechaReconstuye IS NULL) BEGIN SET @FechaReconstuye = @FechaActual END
 
  SET @HorasAUtilizar = UPPER( @HorasAUtilizar )
  IF ( @HorasAUtilizar = 'F') BEGIN SET @FechaReconstuye = CAST(SUBSTRING(CAST(@FechaReconstuye AS CHAR),1,11) + ' 23:59:59.998' AS DATETIME) END
  IF ( @HorasAUtilizar = 'I') BEGIN SET @FechaReconstuye = CAST(SUBSTRING(CAST(@FechaReconstuye AS CHAR),1,11) + ' 00:00:00.000' AS DATETIME) END
 
  SET @TipoCosteoArticulo = @CosteoFiscal
  IF ( @TipoCosto = 'P' ) BEGIN SET @TipoCosteoArticulo = @CosteoComparativo END
  IF ( @TipoCosto = 'L' ) BEGIN SET @TipoCosteoArticulo = @TipoCosto END
  
  
  
    SELECT @FechaCierreAnterior =    CIERRE.FECHA_CIERRE,
  		 @CosteoArticuloBodega =   ISNULL(CIERRE.TIPO_COSTO,ARTICULO.TIPO_COSTO),
  	     @CostoFiscalLocalCierre = CIERRE.COSTO_FISC_UNT_LOC,
  	     @CostoFiscalDolarCierre = CIERRE.COSTO_FISC_UNT_DOL,
           @CostoCompLocalCierre =   CIERRE.COSTO_COMP_UNT_LOC,
  		 @CostoCompDolarCierre =   CIERRE.COSTO_COMP_UNT_DOL,
  		 @CostoPromedioLocBod =    EXISTENCIA.COSTO_UNT_PROMEDIO_LOC,
  		 @CostoPromedioDolBod =    EXISTENCIA.COSTO_UNT_PROMEDIO_DOL
     FROM  $$COMPANIA$$.ARTICULO ARTICULO 
  		JOIN $$COMPANIA$$.EXISTENCIA_BODEGA EXISTENCIA
  			on articulo.ARTICULO = EXISTENCIA.ARTICULO
  		LEFT JOIN ( SELECT * FROM $$COMPANIA$$.EXISTENCIA_CIERRE A
  					WHERE A.FECHA_CIERRE = ( SELECT MAX(fecha_cierre)
  								FROM $$COMPANIA$$.EXISTENCIA_CIERRE B
  								WHERE B.ARTICULO = B.ARTICULO
  								AND B.ARTICULO = @CodigoArticulo
  								AND B.BODEGA = @Bodega
  								AND B.FECHA_CIERRE >= @FechaReconstuye
  								AND A.TIPO_FECHA = @TipoDeFecha )) CIERRE
  		ON CIERRE.ARTICULO = EXISTENCIA.ARTICULO
  		AND CIERRE.BODEGA = EXISTENCIA.BODEGA
   WHERE ARTICULO.ARTICULO = @CodigoArticulo
   AND EXISTENCIA.BODEGA = @Bodega

  
 
  IF (@FechaCierreAnterior IS NULL) BEGIN
		IF (@CosteoArticuloBodega = 'A') BEGIN
			IF (@TipoCosteoArticulo = 'P') BEGIN
				SET @CostoPromedioLocal = @CostoPromedioLocal
				SET @CostoPromedioDolar = @CostoPromedioDolar
			END
			IF (@TipoCosteoArticulo = 'U' OR @TipoCosteoArticulo = 'E') BEGIN
				SET @CostoPromedioLocal = @CostoPromedioLocal
				SET @CostoPromedioDolar = @CostoPromedioDolar
			END
		END
		IF (@CosteoArticuloBodega = 'B') BEGIN
			IF (@TipoCosteoArticulo = 'P') BEGIN
				SET @CostoPromedioLocal = @CostoPromedioLocBod
				SET @CostoPromedioDolar = @CostoPromedioDolBod
			END
			IF (@TipoCosteoArticulo = 'U' OR @TipoCosteoArticulo = 'E') BEGIN
				SET @CostoPromedioLocal = @CostoPromedioLocBod
				SET @CostoPromedioDolar = @CostoPromedioDolBod
			END
		END
  END

  IF (@FechaCierreAnterior IS NOT NULL) BEGIN
		IF (@TipoCosteoArticulo = 'P' or  @TipoCosteoArticulo = 'U' OR @TipoCosteoArticulo = 'E') BEGIN
				SET @CostoPromedioLocal = @CostoFiscalLocalCierre
				SET @CostoPromedioDolar = @CostoFiscalDolarCierre
		END
  END
 
  IF (@TipoCosteoArticulo = 'S') BEGIN 
   SET @ValorActualLocal = @CostoEstandarLocal
   SET @ValorActualDolar = @CostoEstandarDolar
 
   IF ( @FechaReconstuye <= @FechaActual ) BEGIN
    SELECT @ValorActualLocal = SUM( COSTO_STD_DESGL.mat_corp_loc + COSTO_STD_DESGL.mat_terceros_loc + COSTO_STD_DESGL.costo_mo_loc + COSTO_STD_DESGL.costo_indir_loc ),
     @ValorActualDolar = SUM( COSTO_STD_DESGL.mat_corp_dol + COSTO_STD_DESGL.mat_terceros_dol + COSTO_STD_DESGL.costo_mo_dol + COSTO_STD_DESGL.costo_indir_dol )
    FROM $$Compania$$.costo_std_desgl COSTO_STD_DESGL (NOLOCK)
    WHERE  COSTO_STD_DESGL.articulo = @CodigoArticulo 
     AND ( ( 0 < ( 
      SELECT COUNT(0) 
      FROM $$Compania$$.costo_std_desgl COSTO_STD_DESGL3 (NOLOCK)
      WHERE COSTO_STD_DESGL3.articulo = COSTO_STD_DESGL.articulo 
       AND COSTO_STD_DESGL3.fecha_hora <= @FechaReconstuye )
       AND COSTO_STD_DESGL.fecha_hora = ( 
        SELECT MAX(COSTO_STD_DESGL2.fecha_hora)
        FROM $$Compania$$.costo_std_desgl COSTO_STD_DESGL2 (NOLOCK)
        WHERE COSTO_STD_DESGL2.articulo = COSTO_STD_DESGL.articulo 
         AND COSTO_STD_DESGL2.fecha_hora <= @FechaReconstuye )
      ) OR ( 0 = ( 
      SELECT COUNT(0) 
      FROM $$Compania$$.costo_std_desgl COSTO_STD_DESGL3 (NOLOCK)
      WHERE COSTO_STD_DESGL3.articulo = COSTO_STD_DESGL.articulo 
       AND COSTO_STD_DESGL3.fecha_hora <= @FechaReconstuye )
       AND COSTO_STD_DESGL.fecha_hora = ( 
        SELECT MIN(COSTO_STD_DESGL2.fecha_hora)
        FROM $$Compania$$.costo_std_desgl COSTO_STD_DESGL2 (NOLOCK)
        WHERE COSTO_STD_DESGL2.articulo = COSTO_STD_DESGL.articulo
         AND COSTO_STD_DESGL2.fecha_hora > @FechaReconstuye )
      ) )
   END
  END
 
  IF (@TipoCosteoArticulo = 'L' OR @TipoCosto = 'L' ) BEGIN 
   SET @ValorActualLocal = @CostoUltimoLocal
   SET @ValorActualDolar = @CostoUltimoDolar
 
   IF (@TipoCosteoArticulo = 'L'
    AND ( @TipoDeFecha = 'D' OR @FechaReconstuye <= @FechaActual ) ) BEGIN 
    IF ( @TipoDeFecha = 'D' ) BEGIN
     SELECT @CostoUltimoLocal = ISNULL((
       CASE ISNULL(ABS(TRANSACCION_INV.cantidad),0)
        WHEN 0 THEN 0
        ELSE TRANSACCION_INV.costo_tot_fisc_loc / ABS(TRANSACCION_INV.cantidad)
        END),0),
      @CostoUltimoDolar = ISNULL((
       CASE ISNULL(ABS(TRANSACCION_INV.cantidad),0)
        WHEN 0 THEN 0
        ELSE TRANSACCION_INV.costo_tot_fisc_dol / ABS(TRANSACCION_INV.cantidad)
        END ),0),
      @FechaDocumento = TRANSACCION_INV.fecha,
      @FechaAuditoria = TRANSACCION_INV.fecha_hora_transac,
      @AuditoriaTransac = TRANSACCION_INV.audit_trans_inv,
      @ConsecutivoTransac = TRANSACCION_INV.consecutivo
     FROM $$Compania$$.transaccion_inv TRANSACCION_INV (NOLOCK)
     WHERE TRANSACCION_INV.articulo = @CodigoArticulo
      AND TRANSACCION_INV.naturaleza = 'E'
      AND TRANSACCION_INV.tipo IN ('C','V','O','P','F','M')
      AND TRANSACCION_INV.fecha <= @FechaReconstuye
      AND TRANSACCION_INV.fecha_hora_transac = (
       SELECT MAX( TRANSACCION_INV2.fecha_hora_transac ) 
       FROM $$Compania$$.transaccion_inv TRANSACCION_INV2 (NOLOCK)
       WHERE TRANSACCION_INV2.articulo = @CodigoArticulo
        AND TRANSACCION_INV2.naturaleza = 'E'
        AND TRANSACCION_INV2.tipo IN ('C','V','O','P','F','M')
        AND TRANSACCION_INV2.fecha <= @FechaReconstuye
      )
      AND TRANSACCION_INV.fecha >= (
       SELECT MAX( TRANSACCION_INV3.fecha ) 
       FROM $$Compania$$.transaccion_inv TRANSACCION_INV3 (NOLOCK)
       WHERE TRANSACCION_INV3.articulo = @CodigoArticulo
        AND TRANSACCION_INV3.naturaleza = 'E'
        AND TRANSACCION_INV3.tipo IN ('C','V','O','P','F','M')
        AND TRANSACCION_INV3.fecha <= @FechaReconstuye
      )
      AND TRANSACCION_INV.audit_trans_inv = (
       SELECT MAX( TRANSACCION_INV4.audit_trans_inv ) 
       FROM $$Compania$$.transaccion_inv TRANSACCION_INV4 (NOLOCK)
       WHERE TRANSACCION_INV4.articulo = @CodigoArticulo
        AND TRANSACCION_INV4.naturaleza = 'E'
        AND TRANSACCION_INV4.tipo IN ('C','V','O','P','F','M')
        AND TRANSACCION_INV4.fecha <= @FechaReconstuye
        and TRANSACCION_INV4.fecha_hora_transac = TRANSACCION_INV.fecha_hora_transac
      )
      AND TRANSACCION_INV.consecutivo = (
       SELECT MAX( TRANSACCION_INV5.consecutivo ) 
       FROM $$Compania$$.transaccion_inv TRANSACCION_INV5 (NOLOCK)
       WHERE TRANSACCION_INV5.articulo = @CodigoArticulo
        AND TRANSACCION_INV5.naturaleza = 'E'
        AND TRANSACCION_INV5.tipo IN ('C','V','O','P','F','M')
        AND TRANSACCION_INV5.fecha <= @FechaReconstuye
        and TRANSACCION_INV5.fecha_hora_transac = TRANSACCION_INV.fecha_hora_transac
        AND TRANSACCION_INV5.audit_trans_inv = TRANSACCION_INV.audit_trans_inv
      )
      
     
     IF ( @FechaDocumento IS NOT NULL 
      AND @FechaAuditoria IS NOT NULL
      AND (@CosteoFiscal = 'L' OR @CosteoComparativo = 'L' )  )
     BEGIN
      SELECT @DiferenciaValorLocal = ISNULL(SUM (
        CASE ISNULL(ABS(TRANSACCION_INV.cantidad),0)
        WHEN 0 THEN 0
        ELSE TRANSACCION_INV.costo_tot_fisc_loc / ABS(TRANSACCION_INV.cantidad)
        END ),0),
       @DiferenciaValorDolar = ISNULL ( SUM (
        CASE ISNULL(ABS(TRANSACCION_INV.CANTIDAD),0)
        WHEN 0 THEN 0
        ELSE TRANSACCION_INV.costo_tot_fisc_dol / ABS(TRANSACCION_INV.cantidad)
        END ), 0)
      FROM  $$Compania$$.transaccion_inv TRANSACCION_INV (NOLOCK)
      WHERE TRANSACCION_INV.articulo = @CodigoArticulo
       AND TRANSACCION_INV.naturaleza = 'C'
       AND TRANSACCION_INV.fecha <= @FechaReconstuye
       AND TRANSACCION_INV.fecha >= @FechaDocumento
       AND TRANSACCION_INV.fecha_hora_transac >= @FechaAuditoria
       AND TRANSACCION_INV.audit_trans_inv >= @AuditoriaTransac
       AND TRANSACCION_INV.consecutivo >= @ConsecutivoTransac
     END
    END
    IF ( @TipoDeFecha = 'A' ) 
    BEGIN
     SELECT @CostoUltimoLocal = ISNULL((
       CASE ISNULL(ABS(TRANSACCION_INV.cantidad),0)
        WHEN 0 THEN 0
        ELSE TRANSACCION_INV.costo_tot_fisc_loc / ABS(TRANSACCION_INV.cantidad)
        END),0),
      @CostoUltimoDolar = ISNULL((
       CASE ISNULL(ABS(TRANSACCION_INV.cantidad),0)
        WHEN 0 THEN 0
        ELSE TRANSACCION_INV.costo_tot_fisc_dol / ABS(TRANSACCION_INV.cantidad)
        END ),0),
      @FechaAuditoria = TRANSACCION_INV.fecha_hora_transac,
      @AuditoriaTransac = TRANSACCION_INV.audit_trans_inv,
      @ConsecutivoTransac = TRANSACCION_INV.consecutivo
     FROM $$Compania$$.transaccion_inv TRANSACCION_INV (NOLOCK)
     WHERE TRANSACCION_INV.articulo = @CodigoArticulo
      AND TRANSACCION_INV.naturaleza = 'E'
      AND TRANSACCION_INV.tipo IN ('C','V','O','P','F','M')
      AND TRANSACCION_INV.fecha_hora_transac <= @FechaReconstuye
      AND TRANSACCION_INV.fecha_hora_transac = (
       SELECT MAX( TRANSACCION_INV2.fecha_hora_transac ) 
       FROM $$Compania$$.transaccion_inv TRANSACCION_INV2 (NOLOCK)
       WHERE TRANSACCION_INV2.articulo = @CodigoArticulo
        AND TRANSACCION_INV2.naturaleza = 'E'
        AND TRANSACCION_INV2.tipo IN ('C','V','O','P','F','M')
        AND TRANSACCION_INV2.fecha <= @FechaReconstuye
      )
      AND TRANSACCION_INV.AUDIT_TRANS_INV = (
       SELECT MAX( TRANSACCION_INV3.audit_trans_inv ) 
       FROM $$Compania$$.transaccion_inv TRANSACCION_INV3 (NOLOCK)
       WHERE TRANSACCION_INV3.articulo = @CodigoArticulo
        AND TRANSACCION_INV3.naturaleza = 'E'
        AND TRANSACCION_INV3.tipo IN ('C','V','O','P','F','M')
        AND TRANSACCION_INV3.fecha_hora_transac <= @FechaReconstuye
      )
      AND TRANSACCION_INV.CONSECUTIVO = (
       SELECT MAX( TRANSACCION_INV4.CONSECUTIVO ) 
       FROM $$Compania$$.transaccion_inv TRANSACCION_INV4 (NOLOCK)
       WHERE TRANSACCION_INV4.articulo = @CodigoArticulo
        AND TRANSACCION_INV4.naturaleza = 'E'
        AND TRANSACCION_INV4.tipo IN ('C','V','O','P','F','M')
        AND TRANSACCION_INV4.fecha_hora_transac <= @FechaReconstuye
        AND TRANSACCION_INV4.audit_trans_inv = TRANSACCION_INV.audit_trans_inv
      )
      
     IF ( @FechaAuditoria IS NOT NULL
      AND (@CosteoFiscal = 'L' OR @CosteoComparativo = 'L' )  )
     BEGIN
      SELECT @DiferenciaValorLocal = ISNULL(SUM (
        CASE ISNULL(ABS(TRANSACCION_INV.cantidad),0)
        WHEN 0 THEN 0
        ELSE TRANSACCION_INV.costo_tot_fisc_loc / ABS(TRANSACCION_INV.cantidad)
        END ),0),
       @DiferenciaValorDolar = ISNULL ( SUM (
        CASE ISNULL(ABS(TRANSACCION_INV.cantidad),0)
        WHEN 0 THEN 0
        ELSE TRANSACCION_INV.costo_tot_fisc_dol / ABS(TRANSACCION_INV.cantidad)
        END ), 0)
      FROM  $$Compania$$.transaccion_inv TRANSACCION_INV (NOLOCK)
      WHERE TRANSACCION_INV.articulo = @CodigoArticulo
       AND TRANSACCION_INV.naturaleza = 'C'
       AND TRANSACCION_INV.fecha_hora_transac <= @FechaReconstuye
       AND TRANSACCION_INV.fecha_hora_transac >= @FechaAuditoria
       AND TRANSACCION_INV.audit_trans_inv >= @AuditoriaTransac
       AND TRANSACCION_INV.consecutivo >= @ConsecutivoTransac
     END
    END
    SET @ValorActualLocal = ISNULL(@CostoUltimoLocal,0) + ISNULL(@DiferenciaValorLocal,0)
    SET @ValorActualDolar = ISNULL(@CostoUltimoDolar,0) + ISNULL(@DiferenciaValorDolar,0)
   END
  END
 
  IF (@TipoCosteoArticulo = 'P' OR @TipoCosteoArticulo = 'U' OR @TipoCosteoArticulo = 'E') BEGIN
   SET @ValorActualLocal = @CostoPromedioLocal
   SET @ValorActualDolar = @CostoPromedioDolar
   
   IF (@TipoCosteoArticulo = 'U' OR @TipoCosteoArticulo = 'E') BEGIN
		IF (@FechaCierreAnterior IS NULL) BEGIN  
			SELECT @ValorActualLocal = SUM ( ISNULL(COSTO_UEPS_PEPS.cantidad_restante,0) * ISNULL(COSTO_UEPS_PEPS.costo_local,0) ),
			 @ValorActualDolar = SUM ( ISNULL(COSTO_UEPS_PEPS.cantidad_restante,0) * ISNULL(COSTO_UEPS_PEPS.costo_dolar,0) ),
			 @ExistenciaActual = SUM ( ISNULL(COSTO_UEPS_PEPS.cantidad_restante,0) )
			FROM $$Compania$$.costo_ueps_peps COSTO_UEPS_PEPS (NOLOCK)
			WHERE COSTO_UEPS_PEPS.articulo = @CodigoArticulo
			 AND COSTO_UEPS_PEPS.cantidad_restante > 0
		END
     	If (@FechaCierreAnterior IS NOT NULL) BEGIN
		   	 SELECT @ExistenciaActual = SUM(ISNULL(EXISTENCIA_CIERRE.cant_disponible,0) + ISNULL(EXISTENCIA_CIERRE.cant_reservada,0) + 
		   									ISNULL(EXISTENCIA_CIERRE.cant_no_aprobada,0) + ISNULL(EXISTENCIA_CIERRE.cant_vencida,0) + 
		   									ISNULL(EXISTENCIA_CIERRE.cant_remitida,0))
			 FROM $$Compania$$.existencia_CIERRE EXISTENCIA_CIERRE (NOLOCK)
			 WHERE EXISTENCIA_CIERRE.ARTICULO = @CodigoArticulo
				AND EXISTENCIA_CIERRE.FECHA_CIERRE = @FechaCierreAnterior
				AND ((@CosteoArticuloBodega = 'B' AND EXISTENCIA_CIERRE.BODEGA = @Bodega )
				OR ((@CosteoArticuloBodega = 'A')))
			SET @ValorActualLocal =	ISNULL(@ExistenciaActual,0) * ISNULL(@CostoPromedioLocal,0)
			SET @ValorActualDolar = ISNULL(@ExistenciaActual,0) * ISNULL(@CostoPromedioLocal,0)
		END
   END
 
   IF ( @TipoDeFecha = 'D' OR ( @TipoDeFecha = 'A' AND @FechaReconstuye < @FechaActual ) ) BEGIN
    IF (@TipoCosteoArticulo = 'P') BEGIN
		IF (@FechaCierreAnterior IS NULL) BEGIN    
			 SELECT @ExistenciaActual = SUM(ISNULL(EXISTENCIA_BODEGA.cant_disponible,0) + ISNULL(EXISTENCIA_BODEGA.cant_reservada,0) + ISNULL(EXISTENCIA_BODEGA.cant_no_aprobada,0) + ISNULL(EXISTENCIA_BODEGA.cant_vencida,0) + ISNULL(EXISTENCIA_BODEGA.cant_remitida,0))
			 FROM $$Compania$$.existencia_bodega EXISTENCIA_BODEGA (NOLOCK)
			 WHERE EXISTENCIA_BODEGA.ARTICULO = @CodigoArticulo
				AND ((@CosteoArticuloBodega = 'B' AND EXISTENCIA_BODEGA.BODEGA = @Bodega)
				  OR ((@CosteoArticuloBodega = 'A')))
		end
		If (@FechaCierreAnterior IS NOT NULL) BEGIN
		   	 SELECT @ExistenciaActual = SUM(ISNULL(EXISTENCIA_CIERRE.cant_disponible,0) + ISNULL(EXISTENCIA_CIERRE.cant_reservada,0) + ISNULL(EXISTENCIA_CIERRE.cant_no_aprobada,0) + ISNULL(EXISTENCIA_CIERRE.cant_vencida,0) + ISNULL(EXISTENCIA_CIERRE.cant_remitida,0))
			 FROM $$Compania$$.existencia_CIERRE EXISTENCIA_CIERRE (NOLOCK)
			 WHERE EXISTENCIA_CIERRE.ARTICULO = @CodigoArticulo
				AND EXISTENCIA_CIERRE.FECHA_CIERRE = @FechaCierreAnterior
				AND ((@CosteoArticuloBodega = 'B' AND EXISTENCIA_CIERRE.BODEGA = @Bodega)
				OR ((@CosteoArticuloBodega = 'A')))
		END
	 SET @ValorActualLocal = ISNULL(@CostoPromedioLocal,0) * ISNULL(@ExistenciaActual,0)
    SET @ValorActualDolar = ISNULL(@CostoPromedioDolar,0) * ISNULL(@ExistenciaActual,0)

    END
 
    IF ( @TipoCosto = 'F' ) BEGIN
     IF ( @TipoDeFecha = 'A' ) BEGIN
      SELECT  @DiferenciaExistencia = SUM ( 
       CASE 
       WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.cantidad ) 
       WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.cantidad ) 
       ELSE 0 END ),
       @DiferenciaValorLocal = SUM ( 
       CASE 
       WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_fisc_loc )
       WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_fisc_loc )
       WHEN TRANSACCION_INV.naturaleza = 'C' THEN -1*TRANSACCION_INV.costo_tot_fisc_loc
       ELSE 0 END ),
       @DiferenciaValorDolar = SUM ( 
       CASE 
       WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_fisc_dol )
       WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_fisc_dol )
       WHEN TRANSACCION_INV.naturaleza = 'C' THEN -1*TRANSACCION_INV.costo_tot_fisc_dol
       ELSE 0 END )
      FROM $$Compania$$.transaccion_inv TRANSACCION_INV (NOLOCK)
      WHERE TRANSACCION_INV.articulo = @CodigoArticulo
       AND ((@CosteoArticuloBodega = 'B' AND TRANSACCION_INV.BODEGA = @Bodega)
		  OR ((@CosteoArticuloBodega = 'A')))
       AND TRANSACCION_INV.tipo IN ( 'V', 'C', 'O', 'P', 'E', 'F', 'M', 'S' )
       AND (( (@FechaCierreAnterior IS NOT NULL ) AND TRANSACCION_INV.fecha_hora_transac BETWEEN  @FechaReconstuye AND @FechaCierreAnterior )
			OR ((@FechaCierreAnterior IS  NULL )  AND TRANSACCION_INV.fecha_hora_transac >= @FechaReconstuye ))
     END
 
     IF ( @TipoDeFecha = 'D' ) BEGIN
      SELECT  @DiferenciaExistencia = SUM ( 
       CASE 
       WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.cantidad ) 
       WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.cantidad ) 
       ELSE 0 END ),
       @DiferenciaValorLocal = SUM ( 
       CASE 
       WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_fisc_loc )
       WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_fisc_loc )
       WHEN TRANSACCION_INV.naturaleza = 'C' THEN -1*TRANSACCION_INV.costo_tot_fisc_loc
       ELSE 0 END ),
       @DiferenciaValorDolar = SUM ( 
       CASE 
       WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_fisc_dol )
       WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_fisc_dol )
       WHEN TRANSACCION_INV.naturaleza = 'C' THEN -1*TRANSACCION_INV.costo_tot_fisc_dol
       ELSE 0 END )
      FROM $$Compania$$.transaccion_inv TRANSACCION_INV (NOLOCK)
      WHERE TRANSACCION_INV.articulo = @CodigoArticulo
        AND ((@CosteoArticuloBodega = 'B' AND TRANSACCION_INV.BODEGA = @Bodega)
		  OR ((@CosteoArticuloBodega = 'A')))
       AND TRANSACCION_INV.tipo IN ( 'V', 'C', 'O', 'P', 'E', 'F', 'M', 'S' )
       AND (( (@FechaCierreAnterior IS NOT NULL ) AND TRANSACCION_INV.fecha BETWEEN  @FechaReconstuye AND @FechaCierreAnterior )
			OR ((@FechaCierreAnterior IS  NULL )  AND TRANSACCION_INV.fecha >= @FechaReconstuye ))
     END
    END
 
    IF ( @TipoCosto = 'P' ) BEGIN
     IF ( @TipoDeFecha = 'A' ) BEGIN
      SELECT  @DiferenciaExistencia = SUM ( 
       CASE 
       WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.cantidad ) 
       WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.cantidad ) 
       ELSE 0 END ),
       @DiferenciaValorLocal = SUM ( 
       CASE 
       WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_comp_loc )
       WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_comp_loc )
       WHEN TRANSACCION_INV.naturaleza = 'C' THEN -1*TRANSACCION_INV.costo_tot_comp_loc
       ELSE 0 END ),
       @DiferenciaValorDolar = SUM ( 
       CASE 
       WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_comp_dol )
  WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_comp_dol )
       WHEN TRANSACCION_INV.naturaleza = 'C' THEN -1*TRANSACCION_INV.costo_tot_comp_dol
       ELSE 0 END )
      FROM $$Compania$$.transaccion_inv TRANSACCION_INV (NOLOCK)
      WHERE TRANSACCION_INV.articulo = @CodigoArticulo
      AND ((@CosteoArticuloBodega = 'B' AND TRANSACCION_INV.BODEGA = @Bodega)
		  OR ((@CosteoArticuloBodega = 'A')))
       AND TRANSACCION_INV.tipo IN ( 'V', 'C', 'O', 'P', 'E', 'F', 'M', 'S' )
       AND (( (@FechaCierreAnterior IS NOT NULL ) AND TRANSACCION_INV.fecha_hora_transac BETWEEN  @FechaReconstuye AND @FechaCierreAnterior )
			OR ((@FechaCierreAnterior IS  NULL )  AND TRANSACCION_INV.fecha_hora_transac >= @FechaReconstuye ))
     END
 
     IF ( @TipoDeFecha = 'D' ) BEGIN
      SELECT  @DiferenciaExistencia = SUM ( 
       CASE 
       WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.cantidad ) 
       WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.cantidad ) 
       ELSE 0 END ),
       @DiferenciaValorLocal = SUM ( 
       CASE 
       WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_comp_loc )
       WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_comp_loc )
       WHEN TRANSACCION_INV.naturaleza = 'C' THEN -1*TRANSACCION_INV.costo_tot_comp_loc
       ELSE 0 END ),
       @DiferenciaValorDolar = SUM ( 
       CASE 
       WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_comp_dol )
       WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_comp_dol )
       WHEN TRANSACCION_INV.naturaleza = 'C' THEN -1*TRANSACCION_INV.costo_tot_comp_dol
       ELSE 0 END )
      FROM $$Compania$$.transaccion_inv TRANSACCION_INV (NOLOCK)
      WHERE TRANSACCION_INV.articulo = @CodigoArticulo
      AND ((@CosteoArticuloBodega = 'B' AND TRANSACCION_INV.BODEGA = @Bodega)
		  OR ((@CosteoArticuloBodega = 'A')))

       AND TRANSACCION_INV.tipo IN ( 'V', 'C', 'O', 'P', 'E', 'F', 'M', 'S' )
       AND (( (@FechaCierreAnterior IS NOT NULL ) AND TRANSACCION_INV.fecha BETWEEN  @FechaReconstuye AND @FechaCierreAnterior )
			OR ((@FechaCierreAnterior IS  NULL )  AND TRANSACCION_INV.fecha >= @FechaReconstuye ))
     END
    END
 
    IF ((ISNULL(@ExistenciaActual,0) + ISNULL(@DiferenciaExistencia,0)) <> 0) BEGIN
     SET @ValorActualLocal = ((ISNULL(@ValorActualLocal,0) + ISNULL(@DiferenciaValorLocal,0))/(ISNULL(@ExistenciaActual,0) + ISNULL(@DiferenciaExistencia,0)))
     SET @ValorActualDolar = ((ISNULL(@ValorActualDolar,0) + ISNULL(@DiferenciaValorDolar,0))/(ISNULL(@ExistenciaActual,0) + ISNULL(@DiferenciaExistencia,0)))
    END
 
    IF ((ISNULL(@ExistenciaActual,0) + ISNULL(@DiferenciaExistencia,0)) = 0) BEGIN
     SET @ValorActualLocal = 0
     SET @ValorActualDolar = 0
    END
   END
 
   IF (  ( @TipoCosteoArticulo = 'U' OR @TipoCosteoArticulo = 'E' ) AND @TipoDeFecha = 'A' AND @FechaReconstuye >= @FechaActual ) BEGIN
    IF (ISNULL(@ExistenciaActual,0) <> 0) BEGIN
     SET @ValorActualLocal = ISNULL(@ValorActualLocal,0)/ISNULL(@ExistenciaActual,0)
     SET @ValorActualDolar = ISNULL(@ValorActualDolar,0)/ISNULL(@ExistenciaActual,0)
    END
    
    IF (ISNULL(@ExistenciaActual,0) = 0) BEGIN
     SET @ValorActualLocal = 0
     SET @ValorActualDolar = 0
    END
   END
  END
 
  IF (@MonedaCalculo = 'L') BEGIN SET @CostoUnitario = ISNULL(@ValorActualLocal,0) END
  IF (@MonedaCalculo = 'D') BEGIN SET @CostoUnitario = ISNULL(@ValorActualDolar,0) END
 
  RETURN @CostoUnitario
 END;



	

CREATE FUNCTION $$COMPANIA$$.CostoUnitarioArticuloBodega ( 
  @Calcular  AS VARCHAR(1),
     @TipoDeFecha  AS VARCHAR(1),
     @FechaReconstuye AS DATETIME,
     @HorasAUtilizar  AS VARCHAR(1),
     @TipoCosto   AS VARCHAR(1),
     @MonedaCalculo  AS VARCHAR(1),
     @FechaActual  AS DATETIME,
     @CodigoArticulo  AS VARCHAR(20),
     @CosteoFiscal  AS VARCHAR(1),
     @CosteoComparativo AS VARCHAR(1),
     @CostoEstandarLocal AS DECIMAL(28,8),
     @CostoEstandarDolar AS DECIMAL(28,8),
     @CostoPromedioLocal AS DECIMAL(28,8),
     @CostoPromedioDolar AS DECIMAL(28,8),
     @CostoUltimoLocal AS DECIMAL(28,8),
     @CostoUltimoDolar AS DECIMAL(28,8),
     @Bodega AS VARCHAR(10)
    )
    RETURNS DECIMAL(28,8) AS BEGIN
     DECLARE @CostoUnitario  DECIMAL(28,8)
     DECLARE @DiferenciaValorLocal DECIMAL(28,8)
     DECLARE @DiferenciaValorDolar DECIMAL(28,8)
     DECLARE @ValorActualLocal DECIMAL(28,8)
     DECLARE @ValorActualDolar DECIMAL(28,8)
     DECLARE @DiferenciaExistencia DECIMAL(28,8)
     DECLARE @ExistenciaActual DECIMAL(28,8)
     DECLARE @TipoCosteoArticulo VARCHAR(1)
     DECLARE @FechaDocumento  DATETIME
     DECLARE @FechaAuditoria  DATETIME
     DECLARE @AuditoriaTransac INT
     DECLARE @ConsecutivoTransac INT
     DECLARE @FechaCierreAnterior AS DATETIME
     DECLARE @CosteoArticuloBodega AS Varchar(1)
     DECLARE @CostoFiscalLocalCierre AS DECIMAL(28,8)
     DECLARE @CostoFiscalDolarCierre AS DECIMAL(28,8)
     DECLARE @CostoCompLocalCierre AS DECIMAL(28,8)
     DECLARE @CostoCompDolarCierre AS DECIMAL(28,8)
     DECLARE @CostoPromedioLocBod AS DECIMAL(28,8)
     DECLARE @CostoPromedioDolBod AS DECIMAL(28,8)
     /*Caso CR7-25997-N4RM ARS */  
     DECLARE @ExistenciaAlCierre AS DECIMAL(28,8)
     DECLARE @ExistenciaBodegaCierre AS DECIMAL(28,8)
     DECLARE @TipoCostoCierre AS VARCHAR(1)
     /* Caso CR7-25997-N4RM ARS*/ 
    
     IF (ISNULL(@CodigoArticulo,'ND') = 'ND' OR @Calcular = 'N' ) BEGIN RETURN 0 END
    
     SET @TipoDeFecha = UPPER( @TipoDeFecha )
     IF ( ISNULL(@TipoDeFecha,'') <> 'D' ) BEGIN SET @TipoDeFecha = 'A' END
     
     SET @TipoCosto = UPPER( @TipoCosto )
     IF ( ISNULL(@TipoCosto,'') <> 'P' AND ISNULL(@TipoCosto,'') <> 'L' ) BEGIN SET @TipoCosto = 'F' END
    
     SET @MonedaCalculo = UPPER( @MonedaCalculo )
     IF ( ISNULL(@MonedaCalculo,'') <> 'D' ) BEGIN SET @MonedaCalculo = 'L' END
    
     IF (@FechaReconstuye IS NULL) BEGIN SET @FechaReconstuye = @FechaActual END
    
     SET @HorasAUtilizar = UPPER( @HorasAUtilizar )
     IF ( @HorasAUtilizar = 'F') BEGIN SET @FechaReconstuye = CAST(SUBSTRING(CAST(@FechaReconstuye AS CHAR),1,11) + ' 23:59:59.998' AS DATETIME) END
     IF ( @HorasAUtilizar = 'I') BEGIN SET @FechaReconstuye = CAST(SUBSTRING(CAST(@FechaReconstuye AS CHAR),1,11) + ' 00:00:00.000' AS DATETIME) END
    
     SET @TipoCosteoArticulo = @CosteoFiscal
     IF ( @TipoCosto = 'P' ) BEGIN SET @TipoCosteoArticulo = @CosteoComparativo END
     IF ( @TipoCosto = 'L' ) BEGIN SET @TipoCosteoArticulo = @TipoCosto END
    
/*Caso CR7-25997-N4RM ARS */   

	/*Se obtiene el tipo de costo del cierre*/
	SELECT @TipoCostoCierre =   ISNULL(CIERRE.TIPO_COSTO,ARTICULO.TIPO_COSTO)
		FROM  $$COMPANIA$$.ARTICULO ARTICULO 
			 JOIN $$COMPANIA$$.EXISTENCIA_BODEGA EXISTENCIA
			  on articulo.ARTICULO = EXISTENCIA.ARTICULO
			 LEFT JOIN ( SELECT * FROM $$COMPANIA$$.EXISTENCIA_CIERRE A
				WHERE A.FECHA_CIERRE = ( SELECT MAX(fecha_cierre)
				   FROM $$COMPANIA$$.EXISTENCIA_CIERRE B
				   WHERE A.ARTICULO = B.ARTICULO
				   AND B.ARTICULO = @CodigoArticulo
				  AND B.BODEGA = @Bodega 
				   AND B.FECHA_CIERRE >= @FechaReconstuye
				   AND A.TIPO_FECHA = @TipoDeFecha )) CIERRE
			 ON CIERRE.ARTICULO = EXISTENCIA.ARTICULO
			 AND CIERRE.BODEGA = EXISTENCIA.BODEGA
			WHERE ARTICULO.ARTICULO = @CodigoArticulo
			AND EXISTENCIA.BODEGA = @Bodega 


	/*Se obtiene el total de existencias del cierre*/
	SELECT @ExistenciaAlCierre = SUM(ISNULL(CIERRE.cant_disponible,0) + ISNULL(CIERRE.cant_reservada,0) + ISNULL(CIERRE.cant_no_aprobada,0) + ISNULL(CIERRE.cant_vencida,0) + ISNULL(CIERRE.cant_remitida,0)),
	       @ExistenciaBodegaCierre = SUM(ISNULL(EXISTENCIA.cant_disponible,0) + ISNULL(EXISTENCIA.cant_reservada,0) + ISNULL(EXISTENCIA.cant_no_aprobada,0) + ISNULL(EXISTENCIA.cant_vencida,0) + ISNULL(EXISTENCIA.cant_remitida,0))
		FROM  $$COMPANIA$$.ARTICULO ARTICULO 
			 JOIN $$COMPANIA$$.EXISTENCIA_BODEGA EXISTENCIA
			  on articulo.ARTICULO = EXISTENCIA.ARTICULO
			 LEFT JOIN ( SELECT * FROM $$COMPANIA$$.EXISTENCIA_CIERRE A
				WHERE A.FECHA_CIERRE = ( SELECT MAX(fecha_cierre)
				   FROM $$COMPANIA$$.EXISTENCIA_CIERRE B
				   WHERE A.ARTICULO = B.ARTICULO
				   AND B.ARTICULO = @CodigoArticulo
				   AND ((@TipoCostoCierre = 'B' AND B.BODEGA = @Bodega )
			     	   OR ((@TipoCostoCierre = 'A')))
				   AND B.FECHA_CIERRE >= @FechaReconstuye
				   AND A.TIPO_FECHA = @TipoDeFecha )) CIERRE
			 ON CIERRE.ARTICULO = EXISTENCIA.ARTICULO
			 AND CIERRE.BODEGA = EXISTENCIA.BODEGA
			WHERE ARTICULO.ARTICULO = @CodigoArticulo
			AND ((@TipoCostoCierre = 'B' AND EXISTENCIA.BODEGA = @Bodega )
			OR ((@TipoCostoCierre = 'A')))

  /*Se obtienen los datos del cierre*/
     SELECT @FechaCierreAnterior =    CIERRE.FECHA_CIERRE,
      @CosteoArticuloBodega =   ISNULL(CIERRE.TIPO_COSTO,ARTICULO.TIPO_COSTO),
      @CostoFiscalLocalCierre =  SUM( CIERRE.COSTO_FISC_UNT_LOC * (ISNULL(CIERRE.cant_disponible,0) + ISNULL(CIERRE.cant_reservada,0) + ISNULL(CIERRE.cant_no_aprobada,0) + ISNULL(CIERRE.cant_vencida,0) + ISNULL(CIERRE.cant_remitida,0)))/ CASE WHEN @ExistenciaAlCierre = 0 THEN 1 ELSE @ExistenciaAlCierre END,
      @CostoFiscalDolarCierre =  SUM( CIERRE.COSTO_FISC_UNT_DOL * (ISNULL(CIERRE.cant_disponible,0) + ISNULL(CIERRE.cant_reservada,0) + ISNULL(CIERRE.cant_no_aprobada,0) + ISNULL(CIERRE.cant_vencida,0) + ISNULL(CIERRE.cant_remitida,0)))/ CASE WHEN @ExistenciaAlCierre = 0 THEN 1 ELSE @ExistenciaAlCierre END,
      @CostoCompLocalCierre =    SUM( CIERRE.COSTO_COMP_UNT_LOC * (ISNULL(CIERRE.cant_disponible,0) + ISNULL(CIERRE.cant_reservada,0) + ISNULL(CIERRE.cant_no_aprobada,0) + ISNULL(CIERRE.cant_vencida,0) + ISNULL(CIERRE.cant_remitida,0)))/ CASE WHEN @ExistenciaAlCierre = 0 THEN 1 ELSE @ExistenciaAlCierre END,
      @CostoCompDolarCierre =    SUM( CIERRE.COSTO_COMP_UNT_DOL * (ISNULL(CIERRE.cant_disponible,0) + ISNULL(CIERRE.cant_reservada,0) + ISNULL(CIERRE.cant_no_aprobada,0) + ISNULL(CIERRE.cant_vencida,0) + ISNULL(CIERRE.cant_remitida,0)))/ CASE WHEN @ExistenciaAlCierre = 0 THEN 1 ELSE @ExistenciaAlCierre END,
      @CostoPromedioLocBod =     SUM( EXISTENCIA.COSTO_UNT_PROMEDIO_LOC * (ISNULL(EXISTENCIA.cant_disponible,0) + ISNULL(EXISTENCIA.cant_reservada,0) + ISNULL(EXISTENCIA.cant_no_aprobada,0) + ISNULL(EXISTENCIA.cant_vencida,0) + ISNULL(EXISTENCIA.cant_remitida,0)))/ CASE WHEN @ExistenciaBodegaCierre = 0 THEN 1 ELSE @ExistenciaBodegaCierre END,
      @CostoPromedioDolBod =     SUM( EXISTENCIA.COSTO_UNT_PROMEDIO_DOL * (ISNULL(EXISTENCIA.cant_disponible,0) + ISNULL(EXISTENCIA.cant_reservada,0) + ISNULL(EXISTENCIA.cant_no_aprobada,0) + ISNULL(EXISTENCIA.cant_vencida,0) + ISNULL(EXISTENCIA.cant_remitida,0)))/ CASE WHEN @ExistenciaBodegaCierre = 0 THEN 1 ELSE @ExistenciaBodegaCierre END
      FROM  $$COMPANIA$$.ARTICULO ARTICULO 
     JOIN $$COMPANIA$$.EXISTENCIA_BODEGA EXISTENCIA
      on articulo.ARTICULO = EXISTENCIA.ARTICULO
     LEFT JOIN ( SELECT * FROM $$COMPANIA$$.EXISTENCIA_CIERRE A
        WHERE A.FECHA_CIERRE = ( SELECT MAX(fecha_cierre)
           FROM $$COMPANIA$$.EXISTENCIA_CIERRE B
           WHERE A.ARTICULO = B.ARTICULO
           AND B.ARTICULO = @CodigoArticulo
           AND ((@TipoCostoCierre = 'B' AND B.BODEGA = @Bodega )
	   OR ((@TipoCostoCierre = 'A')))
           AND B.FECHA_CIERRE >= @FechaReconstuye
           AND A.TIPO_FECHA = @TipoDeFecha )) CIERRE
     ON CIERRE.ARTICULO = EXISTENCIA.ARTICULO
     AND CIERRE.BODEGA = EXISTENCIA.BODEGA
    WHERE ARTICULO.ARTICULO = @CodigoArticulo
    AND ((@TipoCostoCierre = 'B' AND EXISTENCIA.BODEGA = @Bodega )
    OR ((@TipoCostoCierre = 'A')))
    GROUP BY  CIERRE.FECHA_CIERRE, ISNULL(CIERRE.TIPO_COSTO,ARTICULO.TIPO_COSTO)



  /* Caso CR7-25997-N4RM ARS*/  

   
     /*Proyecto Costos Duplicados ARS*/
    
    IF (@TipoCosto = 'P')
    BEGIN 
     
     IF (@CosteoFiscal = 'P' AND @CosteoComparativo = 'P') AND @CosteoArticuloBodega = 'A'
     BEGIN
     
     select @CostoPromedioLocal = COSTO_PROM_COMPARATIVO_LOC, 
      @CostoPromedioDolar = COSTO_PROM_COMPARATIVO_DOLAR
      FROM $$COMPANIA$$.ARTICULO
      WHERE ARTICULO = @CodigoArticulo
       
     END
     
     
     IF (@CosteoFiscal = 'P' AND @CosteoComparativo = 'P') AND @CosteoArticuloBodega = 'B'
     BEGIN
     
     select @CostoPromedioLocal = COSTO_PROM_COMPARATIVO_LOC, 
      @CostoPromedioDolar = COSTO_PROM_COMPARATIVO_DOLAR
      FROM $$COMPANIA$$.EXISTENCIA_BODEGA
      WHERE ARTICULO = @CodigoArticulo AND BODEGA = @Bodega
       
     END
     
     
     IF (@CosteoFiscal = 'U' AND @CosteoComparativo = 'U')
     BEGIN
     
     select @CostoUltimoLocal = COSTO_PROM_ULTIMO_LOC, 
      @CostoUltimoDolar = COSTO_PROM_ULTIMO_DOL
      FROM $$COMPANIA$$.ARTICULO
      WHERE ARTICULO = @CodigoArticulo
      
     END
     
    END
     
   
    /*Proyecto Costos Duplicados ARS*/
    
  
     IF (@FechaCierreAnterior IS NULL) BEGIN
     IF (@CosteoArticuloBodega = 'A') BEGIN
      IF (@TipoCosteoArticulo = 'P') BEGIN
       SET @CostoPromedioLocal = @CostoPromedioLocal
       SET @CostoPromedioDolar = @CostoPromedioDolar
      END
      IF (@TipoCosteoArticulo = 'U' OR @TipoCosteoArticulo = 'E') BEGIN
       SET @CostoPromedioLocal = @CostoPromedioLocal
       SET @CostoPromedioDolar = @CostoPromedioDolar
      END
     END
     IF (@CosteoArticuloBodega = 'B') BEGIN
      IF (@TipoCosteoArticulo = 'P') BEGIN
       SET @CostoPromedioLocal = @CostoPromedioLocBod
       SET @CostoPromedioDolar = @CostoPromedioDolBod
      END
      IF (@TipoCosteoArticulo = 'U' OR @TipoCosteoArticulo = 'E') BEGIN
       SET @CostoPromedioLocal = @CostoPromedioLocBod
       SET @CostoPromedioDolar = @CostoPromedioDolBod
      END
     END
     END
   
     IF (@FechaCierreAnterior IS NOT NULL) BEGIN
     IF (@TipoCosteoArticulo = 'P' or  @TipoCosteoArticulo = 'U' OR @TipoCosteoArticulo = 'E') BEGIN
       SET @CostoPromedioLocal = @CostoFiscalLocalCierre
       SET @CostoPromedioDolar = @CostoFiscalDolarCierre
     END
     END
    
     IF (@TipoCosteoArticulo = 'S') BEGIN 
      SET @ValorActualLocal = @CostoEstandarLocal
      SET @ValorActualDolar = @CostoEstandarDolar
    
      IF ( @FechaReconstuye <= @FechaActual ) BEGIN
       SELECT @ValorActualLocal = SUM( COSTO_STD_DESGL.mat_corp_loc + COSTO_STD_DESGL.mat_terceros_loc + COSTO_STD_DESGL.costo_mo_loc + COSTO_STD_DESGL.costo_indir_loc ),
        @ValorActualDolar = SUM( COSTO_STD_DESGL.mat_corp_dol + COSTO_STD_DESGL.mat_terceros_dol + COSTO_STD_DESGL.costo_mo_dol + COSTO_STD_DESGL.costo_indir_dol )
       FROM $$COMPANIA$$.costo_std_desgl COSTO_STD_DESGL (NOLOCK)
       WHERE  COSTO_STD_DESGL.articulo = @CodigoArticulo 
        AND ( ( 0 < ( 
         SELECT COUNT(0) 
         FROM $$COMPANIA$$.costo_std_desgl COSTO_STD_DESGL3 (NOLOCK)
         WHERE COSTO_STD_DESGL3.articulo = COSTO_STD_DESGL.articulo 
          AND COSTO_STD_DESGL3.fecha_hora <= @FechaReconstuye )
          AND COSTO_STD_DESGL.fecha_hora = ( 
           SELECT MAX(COSTO_STD_DESGL2.fecha_hora)
           FROM $$COMPANIA$$.costo_std_desgl COSTO_STD_DESGL2 (NOLOCK)
           WHERE COSTO_STD_DESGL2.articulo = COSTO_STD_DESGL.articulo 
            AND COSTO_STD_DESGL2.fecha_hora <= @FechaReconstuye )
         ) OR ( 0 = ( 
         SELECT COUNT(0) 
         FROM $$COMPANIA$$.costo_std_desgl COSTO_STD_DESGL3 (NOLOCK)
         WHERE COSTO_STD_DESGL3.articulo = COSTO_STD_DESGL.articulo 
          AND COSTO_STD_DESGL3.fecha_hora <= @FechaReconstuye )
          AND COSTO_STD_DESGL.fecha_hora = ( 
           SELECT MIN(COSTO_STD_DESGL2.fecha_hora)
           FROM $$COMPANIA$$.costo_std_desgl COSTO_STD_DESGL2 (NOLOCK)
           WHERE COSTO_STD_DESGL2.articulo = COSTO_STD_DESGL.articulo
            AND COSTO_STD_DESGL2.fecha_hora > @FechaReconstuye )
         ) )
      END
     END
    
     IF (@TipoCosteoArticulo = 'L' OR @TipoCosto = 'L' ) BEGIN 
      SET @ValorActualLocal = @CostoUltimoLocal
      SET @ValorActualDolar = @CostoUltimoDolar
    
      IF (@TipoCosteoArticulo = 'L'
       AND ( @TipoDeFecha = 'D' OR @FechaReconstuye <= @FechaActual ) ) BEGIN 
       IF ( @TipoDeFecha = 'D' ) BEGIN
        SELECT @CostoUltimoLocal = ISNULL((
          CASE ISNULL(ABS(TRANSACCION_INV.cantidad),0)
           WHEN 0 THEN 0
           ELSE TRANSACCION_INV.costo_tot_fisc_loc / ABS(TRANSACCION_INV.cantidad)
           END),0),
         @CostoUltimoDolar = ISNULL((
          CASE ISNULL(ABS(TRANSACCION_INV.cantidad),0)
           WHEN 0 THEN 0
           ELSE TRANSACCION_INV.costo_tot_fisc_dol / ABS(TRANSACCION_INV.cantidad)
           END ),0),
         @FechaDocumento = TRANSACCION_INV.fecha,
         @FechaAuditoria = TRANSACCION_INV.fecha_hora_transac,
         @AuditoriaTransac = TRANSACCION_INV.audit_trans_inv,
         @ConsecutivoTransac = TRANSACCION_INV.consecutivo
        FROM $$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
        WHERE TRANSACCION_INV.articulo = @CodigoArticulo
         AND TRANSACCION_INV.naturaleza = 'E'
         AND TRANSACCION_INV.tipo IN ('C','V','O','P','F','M')
         AND TRANSACCION_INV.fecha <= @FechaReconstuye
         AND TRANSACCION_INV.fecha = (
          SELECT MAX( TRANSACCION_INV3.fecha ) 
          FROM $$COMPANIA$$.transaccion_inv TRANSACCION_INV3 (NOLOCK)
          WHERE TRANSACCION_INV3.articulo = @CodigoArticulo
           AND TRANSACCION_INV3.naturaleza = 'E'
           AND TRANSACCION_INV3.tipo IN ('C','V','O','P','F','M')
           AND TRANSACCION_INV3.fecha <= @FechaReconstuye
         )
         AND TRANSACCION_INV.audit_trans_inv = (
          SELECT MAX( TRANSACCION_INV4.audit_trans_inv ) 
          FROM $$COMPANIA$$.transaccion_inv TRANSACCION_INV4 (NOLOCK)
          WHERE TRANSACCION_INV4.articulo = @CodigoArticulo
           AND TRANSACCION_INV4.naturaleza = 'E'
           AND TRANSACCION_INV4.tipo IN ('C','V','O','P','F','M')
           AND TRANSACCION_INV4.fecha <= @FechaReconstuye
         )
         AND TRANSACCION_INV.consecutivo = (
          SELECT MAX( TRANSACCION_INV5.consecutivo ) 
          FROM $$COMPANIA$$.transaccion_inv TRANSACCION_INV5 (NOLOCK)
          WHERE TRANSACCION_INV5.articulo = @CodigoArticulo
           AND TRANSACCION_INV5.naturaleza = 'E'
           AND TRANSACCION_INV5.tipo IN ('C','V','O','P','F','M')
           AND TRANSACCION_INV5.fecha <= @FechaReconstuye
           AND TRANSACCION_INV5.audit_trans_inv = TRANSACCION_INV.audit_trans_inv
         )
         
        
        IF ( @FechaDocumento IS NOT NULL 
         AND @FechaAuditoria IS NOT NULL
         AND (@CosteoFiscal = 'L' OR @CosteoComparativo = 'L' )  )
        BEGIN
         SELECT @DiferenciaValorLocal = ISNULL(SUM (
           CASE ISNULL(ABS(TRANSACCION_INV.cantidad),0)
           WHEN 0 THEN 0
           ELSE TRANSACCION_INV.costo_tot_fisc_loc / ABS(TRANSACCION_INV.cantidad)
           END ),0),
          @DiferenciaValorDolar = ISNULL ( SUM (
           CASE ISNULL(ABS(TRANSACCION_INV.CANTIDAD),0)
           WHEN 0 THEN 0
           ELSE TRANSACCION_INV.costo_tot_fisc_dol / ABS(TRANSACCION_INV.cantidad)
           END ), 0)
         FROM  $$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
         WHERE TRANSACCION_INV.articulo = @CodigoArticulo
          AND TRANSACCION_INV.naturaleza = 'C'
          AND TRANSACCION_INV.fecha <= @FechaReconstuye
          AND TRANSACCION_INV.fecha >= @FechaDocumento
          AND TRANSACCION_INV.fecha_hora_transac >= @FechaAuditoria
          AND ( TRANSACCION_INV.audit_trans_inv > @AuditoriaTransac OR
          (TRANSACCION_INV.audit_trans_inv = @AuditoriaTransac AND  TRANSACCION_INV.consecutivo >= @ConsecutivoTransac))
        END
       END
       IF ( @TipoDeFecha = 'A' ) 
       BEGIN
        SELECT @CostoUltimoLocal = ISNULL((
          CASE ISNULL(ABS(TRANSACCION_INV.cantidad),0)
           WHEN 0 THEN 0
           ELSE TRANSACCION_INV.costo_tot_fisc_loc / ABS(TRANSACCION_INV.cantidad)
           END),0),
         @CostoUltimoDolar = ISNULL((
          CASE ISNULL(ABS(TRANSACCION_INV.cantidad),0)
           WHEN 0 THEN 0
           ELSE TRANSACCION_INV.costo_tot_fisc_dol / ABS(TRANSACCION_INV.cantidad)
           END ),0),
         @FechaAuditoria = TRANSACCION_INV.fecha_hora_transac,
         @AuditoriaTransac = TRANSACCION_INV.audit_trans_inv,
         @ConsecutivoTransac = TRANSACCION_INV.consecutivo
        FROM $$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
        WHERE TRANSACCION_INV.articulo = @CodigoArticulo
         AND TRANSACCION_INV.naturaleza = 'E'
         AND TRANSACCION_INV.tipo IN ('C','V','O','P','F','M')
         AND TRANSACCION_INV.fecha_hora_transac <= @FechaReconstuye
         AND TRANSACCION_INV.fecha_hora_transac = (
          SELECT MAX( TRANSACCION_INV2.fecha_hora_transac ) 
          FROM $$COMPANIA$$.transaccion_inv TRANSACCION_INV2 (NOLOCK)
          WHERE TRANSACCION_INV2.articulo = @CodigoArticulo
           AND TRANSACCION_INV2.naturaleza = 'E'
           AND TRANSACCION_INV2.tipo IN ('C','V','O','P','F','M')
           AND TRANSACCION_INV2.fecha_hora_transac <= @FechaReconstuye
         )
         AND TRANSACCION_INV.AUDIT_TRANS_INV = (
          SELECT MAX( TRANSACCION_INV3.audit_trans_inv ) 
          FROM $$COMPANIA$$.transaccion_inv TRANSACCION_INV3 (NOLOCK)
          WHERE TRANSACCION_INV3.articulo = @CodigoArticulo
           AND TRANSACCION_INV3.naturaleza = 'E'
           AND TRANSACCION_INV3.tipo IN ('C','V','O','P','F','M')
           AND TRANSACCION_INV3.fecha_hora_transac <= @FechaReconstuye
         )
         AND TRANSACCION_INV.CONSECUTIVO = (
          SELECT MAX( TRANSACCION_INV4.CONSECUTIVO ) 
          FROM $$COMPANIA$$.transaccion_inv TRANSACCION_INV4 (NOLOCK)
          WHERE TRANSACCION_INV4.articulo = @CodigoArticulo
           AND TRANSACCION_INV4.naturaleza = 'E'
           AND TRANSACCION_INV4.tipo IN ('C','V','O','P','F','M')
           AND TRANSACCION_INV4.fecha_hora_transac <= @FechaReconstuye
           AND TRANSACCION_INV4.audit_trans_inv = TRANSACCION_INV.audit_trans_inv
         )
         
        IF ( @FechaAuditoria IS NOT NULL
         AND (@CosteoFiscal = 'L' OR @CosteoComparativo = 'L' )  )
        BEGIN
         SELECT @DiferenciaValorLocal = ISNULL(SUM (
           CASE ISNULL(ABS(TRANSACCION_INV.cantidad),0)
           WHEN 0 THEN 0
           ELSE TRANSACCION_INV.costo_tot_fisc_loc / ABS(TRANSACCION_INV.cantidad)
           END ),0),
          @DiferenciaValorDolar = ISNULL ( SUM (
           CASE ISNULL(ABS(TRANSACCION_INV.cantidad),0)
           WHEN 0 THEN 0
           ELSE TRANSACCION_INV.costo_tot_fisc_dol / ABS(TRANSACCION_INV.cantidad)
           END ), 0)
         FROM  $$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
         WHERE TRANSACCION_INV.articulo = @CodigoArticulo
          AND TRANSACCION_INV.naturaleza = 'C'
          AND TRANSACCION_INV.fecha_hora_transac <= @FechaReconstuye
          AND TRANSACCION_INV.fecha_hora_transac >= @FechaAuditoria
          AND ( TRANSACCION_INV.audit_trans_inv > @AuditoriaTransac OR
          (TRANSACCION_INV.audit_trans_inv = @AuditoriaTransac AND  TRANSACCION_INV.consecutivo >= @ConsecutivoTransac))
        END
       END
       SET @ValorActualLocal = ISNULL(@CostoUltimoLocal,0) + ISNULL(@DiferenciaValorLocal,0)
       SET @ValorActualDolar = ISNULL(@CostoUltimoDolar,0) + ISNULL(@DiferenciaValorDolar,0)
      END
     END
    
     IF (@TipoCosteoArticulo = 'P' OR @TipoCosteoArticulo = 'U' OR @TipoCosteoArticulo = 'E') BEGIN
      SET @ValorActualLocal = @CostoPromedioLocal
      SET @ValorActualDolar = @CostoPromedioDolar
      
      IF (@TipoCosteoArticulo = 'U' OR @TipoCosteoArticulo = 'E') BEGIN
     IF (@FechaCierreAnterior IS NULL) BEGIN  
      SELECT @ValorActualLocal = SUM ( ISNULL(COSTO_UEPS_PEPS.cantidad_restante,0) * ISNULL(COSTO_UEPS_PEPS.costo_local,0) ),
       @ValorActualDolar = SUM ( ISNULL(COSTO_UEPS_PEPS.cantidad_restante,0) * ISNULL(COSTO_UEPS_PEPS.costo_dolar,0) ),
       @ExistenciaActual = SUM ( ISNULL(COSTO_UEPS_PEPS.cantidad_restante,0) )
      FROM $$COMPANIA$$.costo_ueps_peps COSTO_UEPS_PEPS (NOLOCK)
      WHERE COSTO_UEPS_PEPS.articulo = @CodigoArticulo
       AND COSTO_UEPS_PEPS.cantidad_restante > 0
     END
         If (@FechaCierreAnterior IS NOT NULL) BEGIN
          SELECT @ExistenciaActual = SUM(ISNULL(EXISTENCIA_CIERRE.cant_disponible,0) + ISNULL(EXISTENCIA_CIERRE.cant_reservada,0) + 
                 ISNULL(EXISTENCIA_CIERRE.cant_no_aprobada,0) + ISNULL(EXISTENCIA_CIERRE.cant_vencida,0) + 
                 ISNULL(EXISTENCIA_CIERRE.cant_remitida,0))
       FROM $$COMPANIA$$.existencia_CIERRE EXISTENCIA_CIERRE (NOLOCK)
       WHERE EXISTENCIA_CIERRE.ARTICULO = @CodigoArticulo
       AND EXISTENCIA_CIERRE.FECHA_CIERRE = @FechaCierreAnterior
       AND ((@CosteoArticuloBodega = 'B' AND EXISTENCIA_CIERRE.BODEGA = @Bodega )
       OR ((@CosteoArticuloBodega = 'A')))
      SET @ValorActualLocal = ISNULL(@ExistenciaActual,0) * ISNULL(@CostoPromedioLocal,0)
      SET @ValorActualDolar = ISNULL(@ExistenciaActual,0) * ISNULL(@CostoPromedioLocal,0)
     END
      END
    
      IF ( @TipoDeFecha = 'D' OR ( @TipoDeFecha = 'A' AND @FechaReconstuye < @FechaActual ) ) BEGIN
       IF (@TipoCosteoArticulo = 'P') BEGIN
     IF (@FechaCierreAnterior IS NULL) BEGIN    
       SELECT @ExistenciaActual = SUM(ISNULL(EXISTENCIA_BODEGA.cant_disponible,0) + ISNULL(EXISTENCIA_BODEGA.cant_reservada,0) + ISNULL(EXISTENCIA_BODEGA.cant_no_aprobada,0) + ISNULL(EXISTENCIA_BODEGA.cant_vencida,0) + ISNULL(EXISTENCIA_BODEGA.cant_remitida,0))
       FROM $$COMPANIA$$.existencia_bodega EXISTENCIA_BODEGA (NOLOCK)
       WHERE EXISTENCIA_BODEGA.ARTICULO = @CodigoArticulo
       AND ((@CosteoArticuloBodega = 'B' AND EXISTENCIA_BODEGA.BODEGA = @Bodega)
         OR ((@CosteoArticuloBodega = 'A')))
     end
     If (@FechaCierreAnterior IS NOT NULL) BEGIN
          SELECT @ExistenciaActual = SUM(ISNULL(EXISTENCIA_CIERRE.cant_disponible,0) + ISNULL(EXISTENCIA_CIERRE.cant_reservada,0) + ISNULL(EXISTENCIA_CIERRE.cant_no_aprobada,0) + ISNULL(EXISTENCIA_CIERRE.cant_vencida,0) + ISNULL(EXISTENCIA_CIERRE.cant_remitida,0))
       FROM $$COMPANIA$$.existencia_CIERRE EXISTENCIA_CIERRE (NOLOCK)
       WHERE EXISTENCIA_CIERRE.ARTICULO = @CodigoArticulo
       AND EXISTENCIA_CIERRE.FECHA_CIERRE = @FechaCierreAnterior
       AND ((@CosteoArticuloBodega = 'B' AND EXISTENCIA_CIERRE.BODEGA = @Bodega)
       OR ((@CosteoArticuloBodega = 'A')))
     END
     SET @ValorActualLocal = ISNULL(@CostoPromedioLocal,0) * ISNULL(@ExistenciaActual,0)
       SET @ValorActualDolar = ISNULL(@CostoPromedioDolar,0) * ISNULL(@ExistenciaActual,0)
   
       END
    
       IF ( @TipoCosto = 'F' ) BEGIN
        IF ( @TipoDeFecha = 'A' ) BEGIN
         SELECT  @DiferenciaExistencia = SUM ( 
          CASE 
          WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.cantidad ) 
          WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.cantidad ) 
          ELSE 0 END ),
          @DiferenciaValorLocal = SUM ( 
          CASE 
          WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_fisc_loc )
          WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_fisc_loc )
          WHEN TRANSACCION_INV.naturaleza = 'C' AND TRANSACCION_INV.subtipo = 'F' THEN -1*TRANSACCION_INV.costo_tot_fisc_loc
          ELSE 0 END ),
          @DiferenciaValorDolar = SUM ( 
          CASE 
          WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_fisc_dol )
          WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_fisc_dol )
          WHEN TRANSACCION_INV.naturaleza = 'C' AND TRANSACCION_INV.subtipo = 'F' THEN -1*TRANSACCION_INV.costo_tot_fisc_dol
          ELSE 0 END )
         FROM $$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
         WHERE TRANSACCION_INV.articulo = @CodigoArticulo
          AND ((@CosteoArticuloBodega = 'B' AND TRANSACCION_INV.BODEGA = @Bodega)
       OR ((@CosteoArticuloBodega = 'A')))
          AND TRANSACCION_INV.tipo IN ( 'V', 'C', 'O', 'P', 'E', 'F', 'M', 'S', 'T' )
          AND (( (@FechaCierreAnterior IS NOT NULL ) AND TRANSACCION_INV.fecha_hora_transac BETWEEN  @FechaReconstuye AND @FechaCierreAnterior )
      OR ((@FechaCierreAnterior IS  NULL )  AND TRANSACCION_INV.fecha_hora_transac >= @FechaReconstuye ))
        END
    
        IF ( @TipoDeFecha = 'D' ) BEGIN
         SELECT  @DiferenciaExistencia = SUM ( 
          CASE 
          WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.cantidad ) 
          WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.cantidad ) 
          ELSE 0 END ),
          @DiferenciaValorLocal = SUM ( 
          CASE 
          WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_fisc_loc )
          WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_fisc_loc )
          WHEN TRANSACCION_INV.naturaleza = 'C' AND TRANSACCION_INV.subtipo = 'F' THEN -1*TRANSACCION_INV.costo_tot_fisc_loc
          ELSE 0 END ),
          @DiferenciaValorDolar = SUM ( 
          CASE 
          WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_fisc_dol )
          WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_fisc_dol )
          WHEN TRANSACCION_INV.naturaleza = 'C' AND TRANSACCION_INV.subtipo = 'F' THEN -1*TRANSACCION_INV.costo_tot_fisc_dol
          ELSE 0 END )
         FROM $$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
         WHERE TRANSACCION_INV.articulo = @CodigoArticulo
           AND ((@CosteoArticuloBodega = 'B' AND TRANSACCION_INV.BODEGA = @Bodega)
       OR ((@CosteoArticuloBodega = 'A')))
          AND TRANSACCION_INV.tipo IN ( 'V', 'C', 'O', 'P', 'E', 'F', 'M', 'S', 'T' )
          AND (( (@FechaCierreAnterior IS NOT NULL ) AND TRANSACCION_INV.fecha BETWEEN  @FechaReconstuye AND @FechaCierreAnterior )
      OR ((@FechaCierreAnterior IS  NULL )  AND TRANSACCION_INV.fecha >= @FechaReconstuye ))
        END
       END
    
       IF ( @TipoCosto = 'P' ) BEGIN
        IF ( @TipoDeFecha = 'A' ) BEGIN
         SELECT  @DiferenciaExistencia = SUM ( 
          CASE 
          WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.cantidad ) 
          WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.cantidad ) 
          ELSE 0 END ),
          @DiferenciaValorLocal = SUM ( 
          CASE 
          WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_comp_loc )
          WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_comp_loc )
          WHEN TRANSACCION_INV.naturaleza = 'C' AND TRANSACCION_INV.subtipo = 'P' THEN -1*TRANSACCION_INV.costo_tot_comp_loc
          ELSE 0 END ),
          @DiferenciaValorDolar = SUM ( 
          CASE 
          WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_comp_dol )
     WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_comp_dol )
          WHEN TRANSACCION_INV.naturaleza = 'C' AND TRANSACCION_INV.subtipo = 'P' THEN -1*TRANSACCION_INV.costo_tot_comp_dol
          ELSE 0 END )
         FROM $$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
         WHERE TRANSACCION_INV.articulo = @CodigoArticulo
         AND ((@CosteoArticuloBodega = 'B' AND TRANSACCION_INV.BODEGA = @Bodega)
       OR ((@CosteoArticuloBodega = 'A')))
          AND TRANSACCION_INV.tipo IN ( 'V', 'C', 'O', 'P', 'E', 'F', 'M', 'S', 'T' )
          AND (( (@FechaCierreAnterior IS NOT NULL ) AND TRANSACCION_INV.fecha_hora_transac BETWEEN  @FechaReconstuye AND @FechaCierreAnterior )
      OR ((@FechaCierreAnterior IS  NULL )  AND TRANSACCION_INV.fecha_hora_transac >= @FechaReconstuye ))
        END
    
        IF ( @TipoDeFecha = 'D' ) BEGIN
         SELECT  @DiferenciaExistencia = SUM ( 
          CASE 
          WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.cantidad ) 
          WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.cantidad ) 
          ELSE 0 END ),
          @DiferenciaValorLocal = SUM ( 
          CASE 
          WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_comp_loc )
          WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_comp_loc )
          WHEN TRANSACCION_INV.naturaleza = 'C' AND TRANSACCION_INV.subtipo = 'P' THEN -1*TRANSACCION_INV.costo_tot_comp_loc
          ELSE 0 END ),
          @DiferenciaValorDolar = SUM ( 
          CASE 
          WHEN TRANSACCION_INV.naturaleza = 'S' THEN ABS( TRANSACCION_INV.costo_tot_comp_dol )
          WHEN TRANSACCION_INV.naturaleza = 'E' THEN -ABS( TRANSACCION_INV.costo_tot_comp_dol )
          WHEN TRANSACCION_INV.naturaleza = 'C' AND TRANSACCION_INV.subtipo = 'P' THEN -1*TRANSACCION_INV.costo_tot_comp_dol
          ELSE 0 END )
         FROM $$COMPANIA$$.transaccion_inv TRANSACCION_INV (NOLOCK)
         WHERE TRANSACCION_INV.articulo = @CodigoArticulo
         AND ((@CosteoArticuloBodega = 'B' AND TRANSACCION_INV.BODEGA = @Bodega)
       OR ((@CosteoArticuloBodega = 'A')))
   
          AND TRANSACCION_INV.tipo IN ( 'V', 'C', 'O', 'P', 'E', 'F', 'M', 'S', 'T' )
          AND (( (@FechaCierreAnterior IS NOT NULL ) AND TRANSACCION_INV.fecha BETWEEN  @FechaReconstuye AND @FechaCierreAnterior )
      OR ((@FechaCierreAnterior IS  NULL )  AND TRANSACCION_INV.fecha >= @FechaReconstuye ))
        END
       END
    
       IF ((ISNULL(@ExistenciaActual,0) + ISNULL(@DiferenciaExistencia,0)) <> 0) BEGIN
        SET @ValorActualLocal = ((ISNULL(@ValorActualLocal,0) + ISNULL(@DiferenciaValorLocal,0))/(ISNULL(@ExistenciaActual,0) + ISNULL(@DiferenciaExistencia,0)))
        SET @ValorActualDolar = ((ISNULL(@ValorActualDolar,0) + ISNULL(@DiferenciaValorDolar,0))/(ISNULL(@ExistenciaActual,0) + ISNULL(@DiferenciaExistencia,0)))
       END
    
       IF ((ISNULL(@ExistenciaActual,0) + ISNULL(@DiferenciaExistencia,0)) = 0) BEGIN
        SET @ValorActualLocal = 0
        SET @ValorActualDolar = 0
       END
      END
    
      IF (  ( @TipoCosteoArticulo = 'U' OR @TipoCosteoArticulo = 'E' ) AND @TipoDeFecha = 'A' AND @FechaReconstuye >= @FechaActual ) BEGIN
       IF (ISNULL(@ExistenciaActual,0) <> 0) BEGIN
        SET @ValorActualLocal = ISNULL(@ValorActualLocal,0)/ISNULL(@ExistenciaActual,0)
        SET @ValorActualDolar = ISNULL(@ValorActualDolar,0)/ISNULL(@ExistenciaActual,0)
       END
       
       IF (ISNULL(@ExistenciaActual,0) = 0) BEGIN
        SET @ValorActualLocal = 0
        SET @ValorActualDolar = 0
       END
      END
     END
    
     IF (@MonedaCalculo = 'L') BEGIN SET @CostoUnitario = ISNULL(@ValorActualLocal,0) END
     IF (@MonedaCalculo = 'D') BEGIN SET @CostoUnitario = ISNULL(@ValorActualDolar,0) END
    
     RETURN @CostoUnitario
  END;

 CREATE FUNCTION $$Compania$$.ValoracionInventario( 
  @TipoFecha varchar(1),
  @ArticuloDesde varchar(20),
  @ArticuloHasta varchar(20),
  @BodegaDesde varchar(4),
  @BodegaHasta varchar(4),
  @FechaFinal DATETIME,
  @TipoCosto varchar(1),
  @SoloConExistencia varchar(1),
  @ConDisponible varchar(1),
  @ConReservado varchar(1),
  @ConNoAprobado varchar(1),
  @ConVencido varchar(1),
  @ConRemitido varchar(1) )
  RETURNS TABLE AS 
      RETURN   SELECT 
    @FechaFinal Fecha, ARTICULO.articulo, ARTICULO.TIPO_COSTO, @TipoFecha TipoFecha, EXISTENCIA_BODEGA.bodega,
     (CASE WHEN
       (((CASE WHEN @ConDisponible = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_disponible,0) - ISNULL(EXISTENCIA.disponible,0),0) ELSE 0 END )
       + (CASE WHEN @ConReservado = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_reservada,0 )- ISNULL(EXISTENCIA.reservado,0),0) ELSE 0 END )
       + (CASE WHEN @ConVencido = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_vencida,0) - ISNULL(EXISTENCIA.vencido,0),0) ELSE 0 END )
       + (CASE WHEN @ConNoAprobado = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_no_aprobada,0) - ISNULL(EXISTENCIA.no_aprobada,0),0) ELSE 0 END )
       + (CASE WHEN @ConRemitido = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_remitida,0) - ISNULL(EXISTENCIA.remitida,0),0) ELSE 0 END ) ) <> 0)
     THEN $$Compania$$.CostoUnitarioArticuloBodega(
      'S',
      @TipoFecha,
      @FechaFinal,
      'F',
      @TipoCosto,
      'L',
      ERPADMIN.SF_GETDATE(),
      ARTICULO.articulo,
      ARTICULO.costo_fiscal,
      ARTICULO.costo_comparativo,
      ARTICULO.costo_std_loc,
      ARTICULO.costo_std_dol,
      ARTICULO.costo_prom_loc,
      ARTICULO.costo_prom_dol,
      ARTICULO.costo_ult_loc,
      ARTICULO.costo_ult_dol,
      EXISTENCIA_BODEGA.BODEGA ) 
     ELSE 0 END 
     )AS costo_unitario_fisc_loc,
     (CASE WHEN
      (((CASE WHEN @ConDisponible = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_disponible,0) - ISNULL(EXISTENCIA.disponible,0),0) ELSE 0 END )
       + (CASE WHEN @ConReservado = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_reservada,0 )- ISNULL(EXISTENCIA.reservado,0),0) ELSE 0 END )
       + (CASE WHEN @ConVencido = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_vencida,0) - ISNULL(EXISTENCIA.vencido,0),0) ELSE 0 END )
       + (CASE WHEN @ConNoAprobado = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_no_aprobada,0) - ISNULL(EXISTENCIA.no_aprobada,0),0) ELSE 0 END )
       + (CASE WHEN @ConRemitido = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_remitida,0) - ISNULL(EXISTENCIA.remitida,0),0) ELSE 0 END ) ) <> 0)
     THEN $$Compania$$.CostoUnitarioArticuloBodega(
      'S',
      @TipoFecha,
      @FechaFinal,
      'F',
      @TipoCosto,
      'D',
      ERPADMIN.SF_GETDATE(),
      ARTICULO.articulo,
      ARTICULO.costo_fiscal,
      ARTICULO.costo_comparativo,
      ARTICULO.costo_std_loc,
      ARTICULO.costo_std_dol,
      ARTICULO.costo_prom_loc,
      ARTICULO.costo_prom_dol,
      ARTICULO.costo_ult_loc,
      ARTICULO.costo_ult_dol,
      EXISTENCIA_BODEGA.BODEGA ) 
     ELSE 0 END )AS costo_unitario_fisc_dol,   
     (CASE WHEN
      (((CASE WHEN @ConDisponible = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_disponible,0) - ISNULL(EXISTENCIA.disponible,0),0) ELSE 0 END )
       + (CASE WHEN @ConReservado = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_reservada,0 )- ISNULL(EXISTENCIA.reservado,0),0) ELSE 0 END )
       + (CASE WHEN @ConVencido = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_vencida,0) - ISNULL(EXISTENCIA.vencido,0),0) ELSE 0 END )
       + (CASE WHEN @ConNoAprobado = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_no_aprobada,0) - ISNULL(EXISTENCIA.no_aprobada,0),0) ELSE 0 END )
       + (CASE WHEN @ConRemitido = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_remitida,0) - ISNULL(EXISTENCIA.remitida,0),0) ELSE 0 END ) ) <> 0)
     THEN $$Compania$$.CostoUnitarioArticuloBodega(
      'S',
      @TipoFecha,
      @FechaFinal,
      'F',
      'P',
      'L',
      ERPADMIN.SF_GETDATE(),
      ARTICULO.articulo,
      ARTICULO.costo_fiscal,
      ARTICULO.costo_comparativo,
      ARTICULO.costo_std_loc,
      ARTICULO.costo_std_dol,
      ARTICULO.costo_prom_loc,
      ARTICULO.costo_prom_dol,
      ARTICULO.costo_ult_loc,
      ARTICULO.costo_ult_dol,
      EXISTENCIA_BODEGA.BODEGA ) 
     ELSE 0 END )AS costo_unitario_comp_loc,
     (CASE WHEN
      (((CASE WHEN @ConDisponible = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_disponible,0) - ISNULL(EXISTENCIA.disponible,0),0) ELSE 0 END )
       + (CASE WHEN @ConReservado = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_reservada,0 )- ISNULL(EXISTENCIA.reservado,0),0) ELSE 0 END )
       + (CASE WHEN @ConVencido = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_vencida,0) - ISNULL(EXISTENCIA.vencido,0),0) ELSE 0 END )
       + (CASE WHEN @ConNoAprobado = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_no_aprobada,0) - ISNULL(EXISTENCIA.no_aprobada,0),0) ELSE 0 END )
       + (CASE WHEN @ConRemitido = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_remitida,0) - ISNULL(EXISTENCIA.remitida,0),0) ELSE 0 END ) ) <> 0)
     THEN $$Compania$$.CostoUnitarioArticuloBodega(
      'S',
      @TipoFecha,
      @FechaFinal,
      'F',
      'P',
      'D',
      ERPADMIN.SF_GETDATE(),
      ARTICULO.articulo,
      ARTICULO.costo_fiscal,
      ARTICULO.costo_comparativo,
      ARTICULO.costo_std_loc,
      ARTICULO.costo_std_dol,
      ARTICULO.costo_prom_loc,
      ARTICULO.costo_prom_dol,
      ARTICULO.costo_ult_loc,
      ARTICULO.costo_ult_dol,
      EXISTENCIA_BODEGA.BODEGA ) 
     ELSE 0 END )AS costo_unitario_comp_dol,
     (CASE WHEN @ConDisponible = 'S' THEN ISNULL (ISNULL(EXISTENCIA_BODEGA.cant_disponible,0),0) - ISNULL(EXISTENCIA.disponible,0) ELSE 0 END ) AS disponible, 
     (CASE WHEN @ConReservado = 'S' THEN ISNULL (ISNULL(EXISTENCIA_BODEGA.cant_reservada,0),0) - ISNULL(EXISTENCIA.reservado,0) ELSE 0 END ) AS reservado,
     (CASE WHEN @ConNoAprobado = 'S' THEN ISNULL (ISNULL(EXISTENCIA_BODEGA.cant_no_aprobada,0),0) - ISNULL(EXISTENCIA.no_aprobada,0) ELSE 0 END ) AS no_aprobado,
     (CASE WHEN @ConVencido = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_vencida,0),0) - ISNULL(EXISTENCIA.vencido,0) ELSE 0 END ) AS vencido,
     (CASE WHEN @ConRemitido = 'S' THEN ISNULL (ISNULL(EXISTENCIA_BODEGA.cant_remitida,0),0) - ISNULL(EXISTENCIA.remitida,0) ELSE 0 END ) AS remitido
    FROM $$Compania$$.existencia_bodega EXISTENCIA_BODEGA (NOLOCK)
     LEFT JOIN (
      SELECT articulo,
       bodega,
       SUM ( CASE
        WHEN TRANSACCION_INV.naturaleza = 'E' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'S' AND ( TRANSACCION_INV.tipo = 'R' OR TRANSACCION_INV.tipo = 'A' OR TRANSACCION_INV.subtipo = 'D' ) THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        ELSE 0 END
       ) AS disponible,
       SUM ( CASE 
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'R' AND TRANSACCION_INV.subtipo = 'R' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        ELSE 0 END
       ) AS reservado,
       SUM ( CASE
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'N' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0))
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'N' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'N' AND TRANSACCION_INV.subtipo = 'V' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
        ELSE 0 END
       ) AS vencido,
       SUM ( CASE
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'A' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'A' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0))
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'A' AND TRANSACCION_INV.subtipo = 'C' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        ELSE 0 END
       ) AS no_aprobada,
       SUM ( CASE 
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'E' AND TRANSACCION_INV.tipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        WHEN TRANSACCION_INV.naturaleza = 'S' AND TRANSACCION_INV.tipo <> 'I' AND TRANSACCION_INV.subtipo = 'I' THEN -ABS(ISNULL(TRANSACCION_INV.cantidad,0)) 
        ELSE 0 END
       ) AS remitida
      FROM $$Compania$$.transaccion_inv TRANSACCION_INV (NOLOCK)
      WHERE TRANSACCION_INV.tipo IN ( 'A', 'C', 'E', 'F', 'I', 'M', 'N', 'O', 'P', 'R', 'T', 'V' )
       AND TRANSACCION_INV.articulo BETWEEN ISNULL (@ArticuloDesde,'0') AND ISNULL (@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
       AND TRANSACCION_INV.bodega BETWEEN ISNULL(@BodegaDesde,'0') AND ISNULL(@BodegaHasta,'ZZZZ')
       AND ( ( @TipoFecha = 'D' AND CAST(SUBSTRING(CAST(TRANSACCION_INV.fecha AS CHAR),1,11) AS DATETIME) > ISNULL(@FechaFinal,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
        OR ( @TipoFecha = 'A' AND TRANSACCION_INV.fecha_hora_transac > ISNULL(@FechaFinal,CAST('2050-12-31 23:59:59.998' AS DATETIME)) )
       )
      GROUP BY articulo, bodega
     ) EXISTENCIA
      ON EXISTENCIA_BODEGA.articulo = EXISTENCIA.articulo 
      AND EXISTENCIA_BODEGA.bodega = EXISTENCIA.bodega
     INNER JOIN $$Compania$$.bodega BODEGA (NOLOCK)
      ON EXISTENCIA_BODEGA.bodega = BODEGA.bodega
     INNER JOIN $$Compania$$.articulo ARTICULO (NOLOCK)
      ON EXISTENCIA_BODEGA.articulo = ARTICULO.articulo
    WHERE ( @SoloConExistencia = 'N'
      OR ( @SoloConExistencia = 'S' 
      AND (((CASE WHEN @ConDisponible = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_disponible,0),0) - ISNULL(EXISTENCIA.disponible,0) ELSE 0 END )
       + (CASE WHEN @ConReservado = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_reservada,0),0) - ISNULL(EXISTENCIA.reservado,0) ELSE 0 END )
       + (CASE WHEN @ConVencido = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_vencida,0),0) - ISNULL(EXISTENCIA.vencido,0) ELSE 0 END )
       + (CASE WHEN @ConNoAprobado = 'S' THEN ISNULL (ISNULL(EXISTENCIA_BODEGA.cant_no_aprobada,0),0) - ISNULL(EXISTENCIA.no_aprobada,0) ELSE 0 END )
       + (CASE WHEN @ConRemitido = 'S' THEN ISNULL ( ISNULL(EXISTENCIA_BODEGA.cant_remitida,0),0) - ISNULL(EXISTENCIA.remitida,0) ELSE 0 END ) ) <> 0
     ) ) )
     AND ARTICULO.tipo IN ('T','M','E','R','U','C','B','D','Q')
     AND ARTICULO.articulo BETWEEN ISNULL (@ArticuloDesde,'0') AND ISNULL (@ArticuloHasta,'ZZZZZZZZZZZZZZZZZZZZ')
    AND EXISTENCIA_BODEGA.bodega BETWEEN ISNULL(@BodegaDesde,'0') AND ISNULL(@BodegaHasta,'ZZZZ'); 
    
    
    
   
  
    
 CREATE PROCEDURE $$COMPANIA$$.CierreInventario
    @FechaFinal  DATETIME,
    @ArticuloInicial  VARCHAR(20),
    @ArticuloFinal  VARCHAR(20)  AS
  	DECLARE @TipoCosto varchar(1) 
  	DECLARE @MonedaCalculo varchar(1) 
  	DECLARE @SoloConExistencia varchar(1) 
  	DECLARE @ConDisponible varchar(1) 
  	DECLARE @ConReservado varchar(1) 
  	DECLARE @ConNoAprobado varchar(1) 
  	DECLARE @ConVencido varchar(1)
  	DECLARE @ConRemitido varchar(1) 
  	
  
  BEGIN TRAN
  
  Set @TipoCosto = 'F'
  Set @MonedaCalculo = 'L'
  Set @SoloConExistencia  = 'N'
  Set @ConDisponible = 'S'
  Set @ConReservado = 'S'
  Set @ConNoAprobado = 'S'
  Set @ConVencido = 'S'
  Set @ConRemitido = 'S'
  
  INSERT $$COMPANIA$$.EXISTENCIA_CIERRE(	FECHA_CIERRE, ARTICULO, TIPO_COSTO, TIPO_FECHA, BODEGA, 
  								COSTO_FISC_UNT_LOC, COSTO_FISC_UNT_DOL, COSTO_COMP_UNT_LOC, 
  								COSTO_COMP_UNT_DOL, CANT_DISPONIBLE, CANT_RESERVADA, 
  								CANT_NO_APROBADA, CANT_VENCIDA, CANT_REMITIDA)
  SELECT FECHA, ARTICULO, TIPO_COSTO, TIPOFECHA, BODEGA, COSTO_UNITARIO_FISC_LOC, 
  		COSTO_UNITARIO_FISC_DOL, COSTO_UNITARIO_COMP_LOC, COSTO_UNITARIO_COMP_DOL, 
  		DISPONIBLE, RESERVADO, NO_APROBADO, VENCIDO, REMITIDO 
  FROM $$COMPANIA$$.ValoracionInventario('D', @ArticuloInicial, @ArticuloFinal, NULL, NULL, 
  										@FechaFinal, @TipoCosto, @SoloConExistencia, 
  										@ConDisponible, @ConReservado, @ConNoAprobado, 
  										@ConVencido, @ConRemitido)
  
  INSERT $$COMPANIA$$.EXISTENCIA_CIERRE(FECHA_CIERRE, ARTICULO, TIPO_COSTO, TIPO_FECHA, BODEGA, COSTO_FISC_UNT_LOC, COSTO_FISC_UNT_DOL,
        COSTO_COMP_UNT_LOC, COSTO_COMP_UNT_DOL, CANT_DISPONIBLE, CANT_RESERVADA, CANT_NO_APROBADA, CANT_VENCIDA, CANT_REMITIDA)
  SELECT FECHA, ARTICULO, TIPO_COSTO, TIPOFECHA, BODEGA, COSTO_UNITARIO_FISC_LOC, 
  		COSTO_UNITARIO_FISC_DOL, COSTO_UNITARIO_COMP_LOC, COSTO_UNITARIO_COMP_DOL, 
  		DISPONIBLE, RESERVADO, NO_APROBADO, VENCIDO, REMITIDO 
  FROM $$COMPANIA$$.ValoracionInventario('F', @ArticuloInicial, @ArticuloFinal, NULL, NULL, 
  										@FechaFinal, @TipoCosto, @SoloConExistencia, 
  										@ConDisponible, @ConReservado, @ConNoAprobado, 
  										@ConVencido, @ConRemitido)
  
  IF @@ERROR <> 0
  BEGIN 
  	RAISERROR ('Se presentaron errores al tratar de realizar el cierre de inventarios.', 16, 1)
  	ROLLBACK 
  END
  ELSE
  BEGIN
  	COMMIT
 END;
 
CREATE TRIGGER $$COMPANIA$$.EXIST_SERIE_POS_SINC_DEL
			ON $$COMPANIA$$.EXISTENCIA_SERIE
FOR DELETE  
AS 
BEGIN   	
	DECLARE @ERROR				INT
	DECLARE @SENTENCIA   		VARCHAR(254)
	DECLARE @NOMBRETABLA		VARCHAR(254)
	DECLARE @USUARIO_ACTUAL		VARCHAR(30)

	DECLARE @BODEGA				VARCHAR(4)
	DECLARE @LOTE				VARCHAR(15)
	DECLARE @TIPO				VARCHAR(1)
	DECLARE @LOCALIZACION		VARCHAR(8)
	DECLARE @ARTICULO			VARCHAR(20)
	DECLARE @SERIE_INICIAL		VARCHAR(20)
	DECLARE @SERIE_FINAL		VARCHAR(20)
	
	SET @NOMBRETABLA = 'EXISTENCIA_SERIE'

	EXEC ERPADMIN.LeerUsuarioActual @USUARIO_ACTUAL OUTPUT

/*Aquí se hace la validación del usuario de conexión para evitar ping-pong*/
	IF NOT ('SoftlandSync' = @USUARIO_ACTUAL)
	BEGIN
		DECLARE C_DELETED CURSOR LOCAL FOR
		SELECT BODEGA, LOTE, TIPO, LOCALIZACION, ARTICULO, SERIE_INICIAL, SERIE_FINAL
		FROM DELETED d

		OPEN C_DELETED
		FETCH NEXT FROM C_DELETED INTO 
		@BODEGA, @LOTE, @TIPO, @LOCALIZACION, @ARTICULO, @SERIE_INICIAL, @SERIE_FINAL
		
		SET @ERROR = 0
		
		WHILE @@FETCH_STATUS = 0 AND @ERROR = 0
		BEGIN
			SET @SENTENCIA = 'DELETE FROM $$COMPANIA$$.' + @NOMBRETABLA + ' WHERE BODEGA = ''' + @BODEGA + ''' AND LOTE = ''' + @LOTE + ''' AND TIPO = ''' + @TIPO + ''' AND LOCALIZACION = ''' + @LOCALIZACION + ''' AND ARTICULO = ''' + @ARTICULO + ''' AND SERIE_INICIAL = ''' + @SERIE_INICIAL + ''' AND SERIE_FINAL = ''' + @SERIE_FINAL + ''''
			
			EXECUTE @ERROR = $$COMPANIA$$.POS_INSERTA_ELIMINACION @SENTENCIA, @NOMBRETABLA
			
			FETCH NEXT FROM C_DELETED INTO 
			@BODEGA, @LOTE, @TIPO, @LOCALIZACION, @ARTICULO, @SERIE_INICIAL, @SERIE_FINAL
		END

		CLOSE C_DELETED
		DEALLOCATE C_DELETED
	END
	
	IF (@@ERROR <> 0) 
	BEGIN
		RAISERROR( 'Error generando la sentencia de eliminación de la tabla EXISTENCIA_SERIE.',16,1 )
	END
END
;


CREATE TRIGGER $$COMPANIA$$.UNIDAD_DE_MED_POS_SINC_DEL
			ON $$COMPANIA$$.UNIDAD_DE_MEDIDA
FOR DELETE  
AS 
BEGIN   	
	DECLARE @ERROR 				INT
	DECLARE @SENTENCIA   		VARCHAR(254)
	DECLARE @NOMBRETABLA		VARCHAR(254)
	DECLARE @USUARIO_ACTUAL		VARCHAR(30)

	DECLARE @UNIDAD_MEDIDA VARCHAR(6)

	SET @NOMBRETABLA = 'UNIDAD_DE_MEDIDA'

	EXEC ERPADMIN.LeerUsuarioActual @USUARIO_ACTUAL OUTPUT

/*Aquí se hace la validación del usuario de conexión para evitar ping-pong*/
	IF NOT ('SoftlandSync' = @USUARIO_ACTUAL)
	BEGIN
		DECLARE C_DELETED CURSOR LOCAL FOR
			SELECT UNIDAD_MEDIDA
			FROM DELETED d

		OPEN C_DELETED
		FETCH NEXT FROM C_DELETED INTO 
		@UNIDAD_MEDIDA
		
		SET @ERROR = 0
		
		WHILE @@FETCH_STATUS = 0 AND @ERROR = 0
		BEGIN
			SET @SENTENCIA = 'DELETE FROM $$COMPANIA$$.' + @NOMBRETABLA + ' WHERE UNIDAD_MEDIDA = ''' + @UNIDAD_MEDIDA + ''''
			
			EXECUTE @ERROR = $$COMPANIA$$.POS_INSERTA_ELIMINACION @SENTENCIA, @NOMBRETABLA
			
			FETCH NEXT FROM C_DELETED INTO 
			@UNIDAD_MEDIDA
		END

		CLOSE C_DELETED
		DEALLOCATE C_DELETED
	END
	
	IF (@@ERROR <> 0) 
	BEGIN
		RAISERROR( 'Error generando la sentencia de eliminación de la tabla UNIDAD_DE_MEDIDA.',16,1 )
	END
END
;


CREATE TRIGGER $$COMPANIA$$.ARTICULO_ESPE_POS_SINC_DEL
			ON $$COMPANIA$$.ARTICULO_ESPE
FOR DELETE  
AS 
BEGIN   	
	DECLARE @ERROR INT
	DECLARE @SENTENCIA   		VARCHAR(254)
	DECLARE @NOMBRETABLA		VARCHAR(254)
	DECLARE @USUARIO_ACTUAL		VARCHAR(30)

	DECLARE @ATRIBUTO VARCHAR(20)
	DECLARE @ARTICULO VARCHAR(25)

	SET @NOMBRETABLA = 'ARTICULO_ESPE'

	EXEC ERPADMIN.LeerUsuarioActual @USUARIO_ACTUAL OUTPUT

/*Aquí se hace la validación del usuario de conexión para evitar ping-pong*/
	IF NOT ('SoftlandSync' = @USUARIO_ACTUAL)
	BEGIN
		DECLARE C_DELETED CURSOR LOCAL FOR
			SELECT ATRIBUTO, ARTICULO
			FROM DELETED d

		OPEN C_DELETED
		FETCH NEXT FROM C_DELETED INTO 
		@ATRIBUTO, @ARTICULO
		
		SET @ERROR = 0
		
		WHILE @@FETCH_STATUS = 0 AND @ERROR = 0
		BEGIN
			SET @SENTENCIA = 'DELETE FROM $$COMPANIA$$.' + @NOMBRETABLA + ' WHERE ATRIBUTO = ''' + @ATRIBUTO + ''' AND ARTICULO = ''' + @ARTICULO + ''''
			
			EXECUTE @ERROR = $$COMPANIA$$.POS_INSERTA_ELIMINACION @SENTENCIA, @NOMBRETABLA
			FETCH NEXT FROM C_DELETED INTO 
			@ATRIBUTO, @ARTICULO
		END

		CLOSE C_DELETED
		DEALLOCATE C_DELETED
	END
	
	IF (@@ERROR <> 0) 
	BEGIN
		RAISERROR( 'Error generando la sentencia de eliminación de la tabla ARTICULO_ESPE.',16,1 )
	END
END
;


CREATE TRIGGER $$COMPANIA$$.ALIAS_PRODUC_POS_SINC_DEL
			ON $$COMPANIA$$.ALIAS_PRODUCCION
FOR DELETE  
AS 
BEGIN   	
	DECLARE @ERROR INT
	DECLARE @SENTENCIA   		VARCHAR(254)
	DECLARE @NOMBRETABLA		VARCHAR(254)
	DECLARE @USUARIO_ACTUAL		VARCHAR(30)

	DECLARE @ALIAS_PRODUCCION VARCHAR(25)
	
	SET @NOMBRETABLA = 'ALIAS_PRODUCCION'

	EXEC ERPADMIN.LeerUsuarioActual @USUARIO_ACTUAL OUTPUT

/*Aquí se hace la validación del usuario de conexión para evitar ping-pong*/
	IF NOT ('SoftlandSync' = @USUARIO_ACTUAL)
	BEGIN
		DECLARE C_DELETED CURSOR LOCAL FOR
			SELECT ALIAS_PRODUCCION
			FROM DELETED d
			
		OPEN C_DELETED
		FETCH NEXT FROM C_DELETED INTO 
		@ALIAS_PRODUCCION
		
		SET @ERROR = 0
		
		WHILE @@FETCH_STATUS = 0 AND @ERROR = 0
		BEGIN
			SET @SENTENCIA = 'DELETE FROM $$COMPANIA$$.' + @NOMBRETABLA + ' WHERE ALIAS_PRODUCCION = ''' + @ALIAS_PRODUCCION + ''''
			
			EXECUTE @ERROR = $$COMPANIA$$.POS_INSERTA_ELIMINACION @SENTENCIA, @NOMBRETABLA
			
			FETCH NEXT FROM C_DELETED INTO 
			@ALIAS_PRODUCCION
		END

		CLOSE C_DELETED
		DEALLOCATE C_DELETED
	END
	
	IF (@@ERROR <> 0) 
	BEGIN
		RAISERROR( 'Error generando la sentencia de eliminación de la tabla ALIAS_PRODUCCION.',16,1 )
	END
END
;

CREATE TRIGGER $$COMPANIA$$.COSTO_UEPS_PEPS_POS_SINC_DEL
			ON $$COMPANIA$$.COSTO_UEPS_PEPS
FOR DELETE  
AS 
BEGIN   	
	DECLARE @ERROR INT
	DECLARE @SENTENCIA   		VARCHAR(254)
	DECLARE @NOMBRETABLA		VARCHAR(254)
	DECLARE @USUARIO_ACTUAL		VARCHAR(30)

	DECLARE @ARTICULO VARCHAR(20)
	DECLARE @SECUENCIA DATETIME

	SET @NOMBRETABLA = 'COSTO_UEPS_PEPS'

	EXEC ERPADMIN.LeerUsuarioActual @USUARIO_ACTUAL OUTPUT

/*Aquí se hace la validación del usuario de conexión para evitar ping-pong*/
	IF NOT ('SoftlandSync' = @USUARIO_ACTUAL)
	BEGIN
		DECLARE C_DELETED CURSOR LOCAL FOR
			SELECT ARTICULO, SECUENCIA
			FROM DELETED d

		OPEN C_DELETED
		FETCH NEXT FROM C_DELETED INTO 
		@ARTICULO, @SECUENCIA
		
		SET @ERROR = 0
		
		WHILE @@FETCH_STATUS = 0 AND @ERROR = 0
		BEGIN
			SET @SENTENCIA = 'DELETE FROM $$COMPANIA$$.' + @NOMBRETABLA + ' WHERE ARTICULO = ''' + @ARTICULO + ''' AND SECUENCIA = ''' + ERPADMIN.POS_FormatoFecha(@SECUENCIA) + ''''
			
			EXECUTE @ERROR = $$COMPANIA$$.POS_INSERTA_ELIMINACION @SENTENCIA, @NOMBRETABLA
			
			FETCH NEXT FROM C_DELETED INTO 
			@ARTICULO, @SECUENCIA
		END

		CLOSE C_DELETED
		DEALLOCATE C_DELETED
	END
	
	IF (@@ERROR <> 0) 
	BEGIN
		RAISERROR( 'Error generando la sentencia de eliminación de la tabla COSTO_UEPS_PEPS.',16,1 )
	END
END
;

CREATE FUNCTION $$COMPANIA$$.PORCEXENTOAUTORCOMPRA(@Clasi_1 varchar(12),@Clasi_2 varchar(12),@Clasi_3 varchar(12),@Clasi_4 varchar(12),@Clasi_5 varchar(12),@Clasi_6 varchar(12), @fechaDoc datetime)  
RETURNS decimal(28,8)   
AS   
BEGIN  
    DECLARE @porcentaje decimal(28,8)
	  
    IF (@Clasi_1 IS NOT NULL)
	SELECT @porcentaje =  MAX(ac.porcentaje) 
	FROM $$COMPANIA$$.AUTOR_COMPRA ac  inner join $$COMPANIA$$.CLASIFICACION_COMPRA cc ON ac.codigo = cc.codigo 
	AND cc.CODIGO_CLASIFICACION = @Clasi_1
	AND (ac.fecha_rige <= @fechaDoc
	AND ac.fecha_vence >= @fechaDoc ) 

	 IF (@porcentaje IS NULL)
		 IF (@Clasi_2 IS NOT NULL)   
			SELECT @porcentaje =   MAX(ac.porcentaje) 
			FROM $$COMPANIA$$.AUTOR_COMPRA ac  inner join $$COMPANIA$$.CLASIFICACION_COMPRA cc ON ac.codigo = cc.codigo 
			AND cc.CODIGO_CLASIFICACION = @Clasi_2
			AND (ac.fecha_rige <= @fechaDoc
			AND ac.fecha_vence >= @fechaDoc )

	IF (@porcentaje IS NULL)
		 IF (@Clasi_3 IS NOT NULL)   
			SELECT @porcentaje =   MAX(ac.porcentaje) 
			FROM $$COMPANIA$$.AUTOR_COMPRA ac  inner join $$COMPANIA$$.CLASIFICACION_COMPRA cc ON ac.codigo = cc.codigo 
			AND cc.CODIGO_CLASIFICACION = @Clasi_3
			AND (ac.fecha_rige <= @fechaDoc
			AND ac.fecha_vence >= @fechaDoc )

	IF (@porcentaje IS NULL)
		 IF (@Clasi_4 IS NOT NULL)   
			SELECT @porcentaje =   MAX(ac.porcentaje) 
			FROM $$COMPANIA$$.AUTOR_COMPRA ac  inner join $$COMPANIA$$.CLASIFICACION_COMPRA cc ON ac.codigo = cc.codigo 
			AND cc.CODIGO_CLASIFICACION = @Clasi_4
			AND (ac.fecha_rige <= @fechaDoc
			AND ac.fecha_vence >= @fechaDoc )

	IF (@porcentaje IS NULL)
		 IF (@Clasi_5 IS NOT NULL)   
			SELECT @porcentaje =   MAX(ac.porcentaje) 
			FROM $$COMPANIA$$.AUTOR_COMPRA ac  inner join $$COMPANIA$$.CLASIFICACION_COMPRA cc ON ac.codigo = cc.codigo 
			AND cc.CODIGO_CLASIFICACION = @Clasi_5
			AND (ac.fecha_rige <= @fechaDoc
			AND ac.fecha_vence >= @fechaDoc )

	IF (@porcentaje IS NULL)
		 IF (@Clasi_6 IS NOT NULL)   
			SELECT @porcentaje =   MAX(ac.porcentaje) 
			FROM $$COMPANIA$$.AUTOR_COMPRA ac  inner join $$COMPANIA$$.CLASIFICACION_COMPRA cc ON ac.codigo = cc.codigo 
			AND cc.CODIGO_CLASIFICACION = @Clasi_6
			AND (ac.fecha_rige <= @fechaDoc
			AND ac.fecha_vence >= @fechaDoc )

     IF (@porcentaje IS NULL)   
        SET @porcentaje = 0 
		 
	SET @porcentaje = @porcentaje/100 
		
    RETURN @porcentaje  
END;  	