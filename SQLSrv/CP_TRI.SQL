
create trigger $$COMPANIA$$.tD_DOCUMENTOS_CP on $$COMPANIA$$.DOCUMENTOS_CP for DELETE as
/* ERwin Builtin Tue Mar 21 11:11:06 2000 */
/* DELETE trigger on DOCUMENTOS_CP */
begin
  declare  @errno   int,
           @errmsg  VARCHAR(255)
           
    /* Tabla:AUXILIAR_CP */
    /* ERwin Builtin Tue Mar 21 11:11:06 2000 */
    /* DOCUMENTOS_CP AUXCPCRD AUXILIAR_CP ON PARENT DELETE CASCADE */
    delete AUXILIAR_CP
      from $$COMPANIA$$.AUXILIAR_CP,deleted
      where
        /*  %JoinFKPK(AUXILIAR_CP,deleted," = "," and") */
        $$COMPANIA$$.AUXILIAR_CP.PROVEEDOR = deleted.PROVEEDOR and
        $$COMPANIA$$.AUXILIAR_CP.CREDITO = deleted.DOCUMENTO and
        $$COMPANIA$$.AUXILIAR_CP.TIPO_CREDITO = deleted.TIPO
    
 
    /* ERwin Builtin Tue Mar 21 11:11:06 2000 */
    return
error:
    raiserror (@errno, @errmsg, 0)
    rollback transaction
end;



REMARK 
\
------------------------------------------------------------------ 
SE CREA LA FUNCION PARA ObtenerDeudaProveedores
------------------------------------------------------------------
/

CREATE FUNCTION $$COMPANIA$$.ObtenerDeudaProveedores(@pMesesAplicar int)
RETURNS @TempDeudaProveedor TABLE(
	IdDia int NOT NULL,	
	Proveedor varchar(40) NOT NULL,
	DiasVencidos int NOT NULL,
	Moneda varchar(14) NOT NULL,
	ConceptoCompra varchar(10) NOT NULL,
	Procedencia varchar(10) NOT NULL,
	CentroCosto varchar(25) NOT NULL,
	DebitoLocal decimal(28,8) null,
	CreditoLocal decimal(28,8) null,
	DebitoDolar decimal(28,8) null,
	CreditoDolar decimal(28,8) null,
	SaldoRealLocal decimal(28,8) null,
	SaldoRealDolar decimal(28,8) null)
AS
BEGIN

	declare @Fecha datetime,
		@FechaFinal datetime

	if @pMesesAplicar = 0 
		set @Fecha = '01-jan-2010'
	else
		SET @Fecha = DATEADD(MONTH, -@pMesesAplicar, ERPADMIN.SF_GETDATE())
	
	Set @FechaFinal = ERPADMIN.SF_GETDATE()

	SELECT @Fecha = MIN(FECHA_DOCUMENTO) from $$COMPANIA$$.DOCUMENTOS_CP where FECHA_DOCUMENTO >= @Fecha


	while @Fecha <= @FechaFinal	begin

		insert into @TempDeudaProveedor
		(IdDia, Proveedor, DiasVencidos, ConceptoCompra, Procedencia, Moneda, CentroCosto, 
		DebitoLocal, CreditoLocal, DebitoDolar, CreditoDolar,SaldoRealLocal,SaldoRealDolar)

		select	dc.IdDia,
				dc.Proveedor,
				dc.DiferenciaDias,
				dc.ConceptoCompra,
				dc.Procedencia,
				dc.Moneda,
				dc.CentroCosto,
				SUM(dc.DebitoLocal) DebitoLocal,
				SUM(dc.CreditoLocal) CreditoLocal,
				SUM(dc.DebitoDolar) DebitoDolar,
				SUM(dc.CreditoDolar) CreditoDolar,
				SUM(dc.SaldoRealLocal) SaldoRealLocal,
				SUM(dc.SaldoRealDolar) SaldoRealDolar		
		from(select	CAST(LTRIM(STR(YEAR(@Fecha)))+ RIGHT(REPLACE(STR(Month(@Fecha)),' ','0'),2)+ RIGHT(REPLACE(STR(Day(@Fecha)),' ','0'),2) AS INT) IdDia, 
				dcp.Proveedor Proveedor,  
				DATEDIFF(DAY, @Fecha, dcp.FECHA_VENCE)  DiferenciaDias,
				pro.LOCAL Procedencia,
				dcp.MONEDA Moneda, 
				dcp.TIPO + '-' + CAST(dcp.SUBTIPO AS VARCHAR) ConceptoCompra,	
				case when cp.CTR_CXP is null then erpadmin.GETVALORHASTANIVELSINCARACTER(p.CTR_CXP,1) else erpadmin.GETVALORHASTANIVELSINCARACTER(cp.CTR_CXP,1) end CentroCosto,
				case when dcp.TIPO = 'CHQ' or dcp.TIPO = 'TEF' Or dcp.TIPO = 'RET' or dcp.TIPO = 'N/C' or dcp.TIPO = 'O/C' then isnull(dcp.MONTO_LOCAL,0)
				ELSE 0 END DebitoLocal,
				case when dcp.TIPO = 'FAC' or dcp.TIPO = 'INT' Or dcp.TIPO = 'RED' or dcp.TIPO = 'N/D' or dcp.TIPO = 'O/D' OR dcp.TIPO = 'L/C' then isnull(dcp.monto_local,0)
				ELSE 0 END CreditoLocal,
				case when dcp.TIPO = 'CHQ' or dcp.TIPO = 'TEF' Or dcp.TIPO = 'RET' or dcp.TIPO = 'N/C' or dcp.TIPO = 'O/C' then isnull(dcp.monto_dolar,0)
				ELSE 0 END DebitoDolar,
				case when dcp.TIPO = 'FAC' or dcp.TIPO = 'INT' Or dcp.TIPO = 'RED' or dcp.TIPO = 'N/D' or dcp.TIPO = 'O/D' OR dcp.TIPO = 'L/C' then isnull(dcp.monto_dolar,0)
				ELSE 0 END CreditoDolar,
				case when dcp.TIPO = 'FAC' or dcp.TIPO = 'INT' Or dcp.TIPO = 'RED' or dcp.TIPO = 'N/D' or dcp.TIPO = 'O/D' OR dcp.TIPO = 'L/C' then isnull($$COMPANIA$$.CPGetSaldoDocLocal_BI(dcp.PROVEEDOR, dcp.DOCUMENTO, @Fecha), 0)
				else 0 END SaldoRealLocal,
				case when dcp.TIPO = 'FAC' or dcp.TIPO = 'INT' Or dcp.TIPO = 'RED' or dcp.TIPO = 'N/D' or dcp.TIPO = 'O/D' OR dcp.TIPO = 'L/C' then isnull($$COMPANIA$$.CPGetSaldoDocDolar_BI(dcp.PROVEEDOR, dcp.DOCUMENTO, @Fecha), 0)
				else 0 END SaldoRealDolar
		from $$COMPANIA$$.DOCUMENTOS_CP dcp
				inner join $$COMPANIA$$.Proveedor pro on dcp.Proveedor = pro.Proveedor
				inner join $$COMPANIA$$.CATEGORIA_PROVEED cp on pro.CATEGORIA_PROVEED = cp.CATEGORIA_PROVEED
				inner join $$COMPANIA$$.PAIS p on p.PAIS = pro.PAIS
		where dcp.FECHA_DOCUMENTO <= @Fecha AND ($$COMPANIA$$.CPGetSaldoDocLocal_BI(dcp.PROVEEDOR, dcp.DOCUMENTO, @Fecha) > 0 AND $$COMPANIA$$.CPGetSaldoDocDolar_BI(dcp.PROVEEDOR, dcp.DOCUMENTO, @Fecha) > 0) and dcp.TIPO not in ('CHQ','TEF','RET','N/C','O/C') ) dc
		group by dc.IdDia,
				dc.Proveedor,
				dc.DiferenciaDias,
				dc.Moneda,
				dc.Procedencia,
				dc.CentroCosto,
				dc.ConceptoCompra


		set @Fecha = DATEADD(day, 1, @Fecha)
	end	
RETURN
END;





REMARK 
\
------------------------------------------------------------------ 
-- Texto de Rango de Días entre dos fechas
------------------------------------------------------------------
/
CREATE FUNCTION $$COMPANIA$$.SoftlandBI_FN_RangoFechas(@FechaInicial DATETIME, @FechaFinal DATETIME)
RETURNS VARCHAR(10) AS
BEGIN
	DECLARE @Rango VARCHAR(10)
	DECLARE @Diferencia INT

	SET @Diferencia = DATEDIFF (Day, @FechaInicial, @FechaFinal)
	SET @Rango =
		CASE  
		WHEN @Diferencia <= 0  THEN 'Sin rango'
		WHEN @Diferencia <= 30 THEN '000-030'
		WHEN @Diferencia <= 60 THEN '031-060'
		WHEN @Diferencia <= 90 THEN '061-090'
		WHEN @Diferencia <= 120 THEN '091-120'
		WHEN @Diferencia <= 150 THEN '121-150'
		WHEN @Diferencia <= 180 THEN '151-180'
		WHEN @Diferencia >= 181 THEN 'Más de 181'
		END
	RETURN ISNULL(@Rango, 'No Definido')
END;


REMARK 
\
------------------------------------------------------------------ 
-- Convierte un monto a positivo o negativo dependiendo del tipo de documento de CP
------------------------------------------------------------------
/
CREATE FUNCTION $$COMPANIA$$.SoftlandBI_FN_MontoAfectaCP(@TipoDocumento VARCHAR(3), @Monto DECIMAL(28,8))
RETURNS DECIMAL(28,8) AS
BEGIN
	DECLARE @NuevoMonto DECIMAL(28,8)

	IF (@TipoDocumento = 'FAC' OR @TipoDocumento = 'O/D' OR @TipoDocumento = 'N/D' OR @TipoDocumento = 'L/C' OR @TipoDocumento = 'INT') BEGIN SET @NuevoMonto = @Monto END
	ELSE BEGIN SET @NuevoMonto = -@Monto END

	RETURN ISNULL(@NuevoMonto,0)
END;

REMARK 
\
------------------------------------------------------------------ 
-- Vista de Saldo de Proveedores para Softland Análisis
------------------------------------------------------------------
/
CREATE VIEW $$COMPANIA$$.SoftlandBI_CP_SaldoProveedores
AS
	SELECT	PROVEEDOR.proveedor AS Proveedor
		, PROVEEDOR.nombre AS Nombre
		, PROVEEDOR.categoria_proveed AS Categoria
		, CATEGORIA.descripcion AS NombreCategoria
		, CASE PROVEEDOR.local WHEN 'L' THEN 'Local' ELSE 'Extranjero' END AS Tipo
		, CASE PROVEEDOR.activo WHEN 'S' THEN 'Activo' ELSE 'Inactivo' END AS Activo
		, CASE PROVEEDOR.multimoneda WHEN 'S' THEN 'Sí' ELSE 'No' END AS Multimoneda
		, PROVEEDOR.pais AS Pais
		, PAIS.nombre AS NombrePais
		, PROVEEDOR.condicion_pago AS CondicionDePago
		, CONDICION.descripcion AS DescripcionCondicionDePago
		, PROVEEDOR.moneda AS Moneda
		, PROVEEDOR.saldo AS Saldo
		, PROVEEDOR.saldo_local AS SaldoLocal
		, PROVEEDOR.saldo_dolar AS SaldoDolar
		, PROVEEDOR.tasa_interes_mora AS TasaInteresMora
		, PROVEEDOR.fecha_ingreso AS FechaRegistro
		, YEAR(PROVEEDOR.fecha_ingreso) AS AnoFechaRegistro
		, DATEPART (QUARTER, PROVEEDOR.fecha_ingreso) AS TrimestreFechaRegistro
		, MONTH(PROVEEDOR.fecha_ingreso) AS MesFechaRegistro
	FROM	proveedor PROVEEDOR (NOLOCK)
		INNER JOIN $$COMPANIA$$.categoria_proveed CATEGORIA (NOLOCK)
			ON PROVEEDOR.categoria_proveed = CATEGORIA.categoria_proveed
		INNER JOIN $$COMPANIA$$.condicion_pago CONDICION (NOLOCK)
			ON PROVEEDOR.condicion_pago = CONDICION.condicion_pago
		INNER JOIN $$COMPANIA$$.pais PAIS (NOLOCK)
			ON PROVEEDOR.pais = PAIS.pais;

REMARK 
\
------------------------------------------------------------------ 
-- Vista de Movimientos de Proveedores para Softland Análisis
------------------------------------------------------------------
/
CREATE VIEW $$COMPANIA$$.SoftlandBI_CP_MovProveedores
AS
	SELECT	PROVEEDOR.proveedor AS Proveedor
		, PROVEEDOR.nombre AS NombreProveedor
		, PROVEEDOR.categoria_proveed AS CategoriaProveedor
		, CATEGORIA.descripcion AS NombreCategoriaProveedor
		, CASE PROVEEDOR.activo WHEN 'S' THEN 'Activo' ELSE 'Inactivo' END AS ProveedorActivo
		, CASE PROVEEDOR.local WHEN 'L' THEN 'Local' ELSE 'Extranjero' END AS Tipo
		, CASE PROVEEDOR.multimoneda WHEN 'S' THEN 'Sí' ELSE 'No' END AS Multimoneda
		, PROVEEDOR.pais AS PaisProveedor
		, PAIS.nombre AS NombrePaisProveedor
		, PROVEEDOR.condicion_pago AS CondicionDePagoProveedor
		, CONDICION.descripcion AS DescripcionCondicionDePago
		, DOCUMENTO.documento AS Documento
		, DOCUMENTO.tipo AS TipoDocumento
		, SUBTIPO.descripcion AS SubtipoDocumento
		, CASE DOCUMENTO.anulado WHEN 'S' THEN 'Sí' ELSE 'No' END AS DocumentoAnulado
		, CASE DOCUMENTO.aprobado WHEN 'S' THEN 'Sí' ELSE 'No' END AS DocumentoAprobado
		, DOCUMENTO.fecha_documento AS FechaDocumento
		, YEAR(DOCUMENTO.fecha_documento) AS AnoFechaDocumento
		, DATEPART(QUARTER,DOCUMENTO.fecha_documento) AS TrimestreFechaDocumento
		, MONTH(DOCUMENTO.fecha_documento) AS MesFechaDocumento
		, DATEDIFF(MONTH, DOCUMENTO.fecha_documento, ERPADMIN.SF_GETDATE()) AS MesesAntiguedad
		, DATEDIFF(DAY, DOCUMENTO.fecha_documento, ERPADMIN.SF_GETDATE()) AS DiasAntiguedad
		, $$COMPANIA$$.SoftlandBI_FN_RangoFechas(DOCUMENTO.fecha_documento,ERPADMIN.SF_GETDATE()) AS RangoAntiguedad
		, DOCUMENTO.fecha AS FechaRige
		, YEAR(DOCUMENTO.fecha) AS AnoFechaRige
		, DATEPART(QUARTER,DOCUMENTO.fecha) AS TrimestreFechaRige
		, MONTH(DOCUMENTO.fecha) AS MesFechaRige
		, DATEDIFF(MONTH, DOCUMENTO.fecha, ERPADMIN.SF_GETDATE()) AS MesesAntiguedadRige
		, DATEDIFF(DAY, DOCUMENTO.fecha, ERPADMIN.SF_GETDATE()) AS DiasAntiguedadRige
		, $$COMPANIA$$.SoftlandBI_FN_RangoFechas(DOCUMENTO.fecha,ERPADMIN.SF_GETDATE()) AS RangoAntiguedadRige
		, DOCUMENTO.fecha_vence AS FechaVence
		, YEAR(DOCUMENTO.fecha_vence) AS AnoFechaVence
		, DATEPART(QUARTER,DOCUMENTO.fecha_vence) AS TrimestreFechaVence
		, MONTH(DOCUMENTO.fecha_vence) AS MesFechaVence
		, DATEDIFF(MONTH, DOCUMENTO.fecha_vence, ERPADMIN.SF_GETDATE()) AS MesesVencimiento
		, DATEDIFF(DAY, DOCUMENTO.fecha_vence, ERPADMIN.SF_GETDATE()) AS DiasVencimiento
		, $$COMPANIA$$.SoftlandBI_FN_RangoFechas(DOCUMENTO.fecha_vence,ERPADMIN.SF_GETDATE()) AS RangoVencimiento
		, DOCUMENTO.moneda AS Moneda
		, DOCUMENTO.monto AS Monto
		, DOCUMENTO.saldo AS Saldo
		, DOCUMENTO.monto_local AS MontoLocal
		, DOCUMENTO.saldo_local AS SaldoLocal
		, DOCUMENTO.monto_dolar AS MontoDolar
		, DOCUMENTO.saldo_dolar AS SaldoDolar
		, DOCUMENTO.monto_retencion AS MontoRetencion
		, DOCUMENTO.saldo_retencion AS SaldoRetencion
		, $$COMPANIA$$.SoftlandBI_FN_MontoAfectaCP(DOCUMENTO.tipo, DOCUMENTO.monto_local) AS MontoAfectaLocal
		, $$COMPANIA$$.SoftlandBI_FN_MontoAfectaCP(DOCUMENTO.tipo,DOCUMENTO.saldo_local) AS SaldoAfectaLocal
		, $$COMPANIA$$.SoftlandBI_FN_MontoAfectaCP(DOCUMENTO.tipo,DOCUMENTO.monto_dolar) AS MontoAfectaDolar
		, $$COMPANIA$$.SoftlandBI_FN_MontoAfectaCP(DOCUMENTO.tipo,DOCUMENTO.saldo_dolar) AS SaldoAfectaDolar
	FROM	documentos_cp DOCUMENTO (NOLOCK)
		INNER JOIN $$COMPANIA$$.proveedor PROVEEDOR (NOLOCK)
			ON DOCUMENTO.proveedor = PROVEEDOR.proveedor
		INNER JOIN $$COMPANIA$$.categoria_proveed CATEGORIA (NOLOCK)
			ON PROVEEDOR.categoria_proveed = CATEGORIA.categoria_proveed
		INNER JOIN $$COMPANIA$$.condicion_pago CONDICION (NOLOCK)
			ON PROVEEDOR.condicion_pago = CONDICION.condicion_pago
		INNER JOIN $$COMPANIA$$.pais PAIS (NOLOCK)
			ON PROVEEDOR.pais = PAIS.pais
		INNER JOIN $$COMPANIA$$.subtipo_doc_cp SUBTIPO (NOLOCK)
			ON DOCUMENTO.tipo = SUBTIPO.tipo
			   AND DOCUMENTO.subtipo = SUBTIPO.subtipo;
			   
			   
			   
			   


Create view $$COMPANIA$$.TIPO_DOC_CP
AS 
	SELECT 	'CHQ' TIPO, 'Cheque' DESCRIPCION, 'D' TIPO_DC
	UNION ALL 
	SELECT 'TEF', 'TEF', 'D'
	UNION ALL 
	SELECT 'N/C', 'Nota Crédito', 'D'
	UNION ALL 
	SELECT 'O/C', 'Otro Crédito', 'D'
	UNION ALL 
	SELECT 'RET', 'Retenciones', 'D'
	UNION ALL 
	SELECT 'CNJ', 'Canje', 'D'
	UNION ALL 
	SELECT 'FAC', 'Factura', 'C'
	UNION ALL 
	SELECT 'L/C', 'Letra de Cambio', 'C'
	UNION ALL 
	SELECT 'N/D', 'Nota de Débito', 'C'
	UNION ALL 
	SELECT 'O/D', 'Otro de Débito', 'C'
	UNION ALL 
	SELECT 'INT', 'Intereses', 'C'
	UNION ALL 
	SELECT 'B/V', 'Boleta de Venta', 'C'
	UNION ALL 
	SELECT 'RHP', 'Recibo por Honorarios Profesionales', 'C'
	UNION ALL 
	SELECT 'RED', 'Retencion Debito', 'C';



CREATE VIEW $$COMPANIA$$.[V_ANEXO94] AS
select	nit.TIPO as Tipo,nit.nit as RUC, nit.DIGITO_VERIFICADOR as DV, nit.RAZON_SOCIAL as Razon_social,
dcp.DOCUMENTO as documento, dcp.TIPO as tipo_documento, sdcp.DESCRIPCION as concepto, dcp.FECHA as fecha, dcp.MONTO as monto
from	$$COMPANIA$$.NIT nit, $$COMPANIA$$.DOCUMENTOS_CP dcp, $$COMPANIA$$.PROVEEDOR pro , $$COMPANIA$$.SUBTIPO_DOC_CP sdcp
where	nit.NIT = pro.CONTRIBUYENTE and dcp.PROVEEDOR = pro.PROVEEDOR and sdcp.TIPO= dcp.TIPO and sdcp.SUBTIPO = dcp.SUBTIPO;



CREATE VIEW $$COMPANIA$$.V_AUXILIAR_CP 
AS
	SELECT acp.proveedor    AS PROVEEDOR, 
	       acp.tipo_debito  AS TIPO_DOC_DEB, 
	       acp.debito       AS NUM_DEB, 
	       acp.fecha        AS FECHA_PAGO, 
	       sdc.descripcion  AS SUBTIPO_FAC, 
	       acp.tipo_credito AS TIPO_FAC, 
	       acp.credito      AS NUM_CRED, 
	       ncf.ncf          AS NCF_FAC, 
	       acp.monto_local  AS MONTO_LOCAL, 
	       'CP'             AS MODULO 
	FROM   $$COMPANIA$$.auxiliar_cp acp, 
	       $$COMPANIA$$.documentos_cp dcp, 
	       $$COMPANIA$$.ncf_documento ncf, 
	       $$COMPANIA$$.subtipo_doc_cp sdc 
	WHERE  acp.tipo_credito = dcp.tipo 
	       AND acp.credito = dcp.documento 
	       AND acp.proveedor = dcp.proveedor 
	       AND dcp.rowpointer = ncf.doc_rowpointer 
	       AND dcp.subtipo = sdc.subtipo 
	       AND dcp.tipo = sdc.tipo;  




CREATE VIEW $$COMPANIA$$.V_COMPRAS_BIENES_SERVICIOS 
AS
	SELECT 'CP'                  AS CUENTABANCO, 
	       dcp.proveedor         AS PROVEEDOR, 
	       pro.contribuyente     AS RNC_CED, 
	       pro.rubro4_prov       AS TIPO_ID, 
	       dcp.tipo              AS TIPO_DOC, 
	       dcp.subtipo           AS SUBTIPO_DOC, 
	       dcp.documento         AS NUMERO_DOC, 
	       ncf.ncf               AS NCF, 
	       dcp.moneda            AS MONEDA, 
	       dcp.fecha_documento   AS FECHA_DOC, 
	       dcp.monto             AS MONTO_TOTAL, 
	       dcp.saldo             AS SALDO, 
	       dcp.tipo_cambio_dolar AS TASA, 
	       dcp.subtotal          AS SUBTOTAL, 
	       dcp.descuento         AS DESCUENTO, 
	       dcp.impuesto1         AS IMPUESTO1, 
	       dcp.impuesto2         AS IMPUESTO2, 
	       dcp.rubro1            AS RUBRO1, 
	       dcp.rubro2            AS RUBRO2, 
	       0                     AS RETENCION, 
	       0                     AS VALE_CH, 
	       0                     AS LINEA_VALE, 
	       dcp.fecha_documento   AS FECHA_ORIG, 
	       'CP'                  AS MODULO 
	FROM   $$COMPANIA$$.proveedor pro, 
	       $$COMPANIA$$.documentos_cp dcp, 
	       $$COMPANIA$$.ncf_documento ncf 
	WHERE  dcp.proveedor = pro.proveedor 
	       AND dcp.rowpointer = ncf.doc_rowpointer 
	       AND dcp.aplicacion <> '** ANULADO **' 
	UNION 
	SELECT mov.cuenta_banco      AS CUENTABANCO, 
	       'CB'                  AS PROVEEDOR, 
	       enf.nit               AS RNC_CED, 
	       '1'                   AS TIPO_ID, 
	       mov.tipo_documento    AS TIPO_DOC, 
	       mov.subtipo           AS SUBTIPO_DOC, 
	       Str(mov.numero)       AS NUMERO_DOC, 
	       ncf.ncf               AS NCF, 
	       ctb.moneda            AS MONEDA, 
	       mov.fecha             AS FECHA_DOC, 
	       mov.monto             AS MONTO_TOTAL, 
	       1                     AS SALDO, 
	       mov.tipo_cambio_dolar AS TASA, 
	       0                     AS SUBTOTAL, 
	       0                     AS DESCUENTO, 
	       0                     AS IMPUESTO1, 
	       0                     AS IMPUESTO2, 
	       0                     AS RUBRO1, 
	       0                     AS RUBRO2, 
	       0                     AS RETENCION, 
	       0                     AS VALE_CH, 
	       0                     AS LINEA_VALE, 
	       mov.fecha             AS FECHA_ORIG, 
	       'CB'                  AS MODULO 
	FROM   $$COMPANIA$$.entidad_financiera enf, 
	       $$COMPANIA$$.mov_bancos mov, 
	       $$COMPANIA$$.ncf_documento ncf, 
	       $$COMPANIA$$.cuenta_bancaria ctb 
	WHERE  ctb.entidad_financiera = enf.entidad_financiera 
	       AND mov.cuenta_banco = ctb.cuenta_banco 
	       AND mov.rowpointer = ncf.doc_rowpointer 
	       AND mov.anulado <> 'S' 
	UNION 
	SELECT 'CP'                  AS CUENTABANCO, 
	       vac.proveedor         AS PROVEEDOR, 
	       pro.contribuyente     AS RNC_CED, 
	       pro.rubro4_prov       AS TIPO_ID, 
	       vac.tipo_fac          AS TIPO_DOC, 
	       0                     AS SUBTIPO_DOC, 
	       vac.num_cred          AS NUMERO_DOC, 
	       vac.ncf_fac           AS NCF, 
	       dcp.moneda            AS MONEDA, 
	       vac.fecha_pago        AS FECHA_DOC, 
	       0                     AS MONTO_TOTAL, 
	       0                     AS SALDO, 
	       dcp.tipo_cambio_dolar AS TASA, 
	       0                     AS SUBTOTAL, 
	       0                     AS DESCUENTO, 
	       0                     AS IMPUESTO1, 
	       0                     AS IMPUESTO2, 
	       0                     AS RUBRO1, 
	       0                     AS RUBRO2, 
	       vac.monto_local       AS RETENCION, 
	       0                     AS VALE_CH, 
	       0                     AS LINEA_VALE, 
	       vac.fecha_pago        AS FECHA_ORIG, 
	       'RET'                 AS MODULO 
	FROM   $$COMPANIA$$.proveedor pro, 
	       $$COMPANIA$$.v_auxiliar_cp vac, 
	       $$COMPANIA$$.documentos_cp dcp, 
	       $$COMPANIA$$.retenciones ret 
	WHERE  vac.proveedor = pro.proveedor 
	       AND vac.proveedor = dcp.proveedor 
	       AND vac.tipo_doc_deb = dcp.tipo 
	       AND vac.num_deb = dcp.documento 
	       AND vac.tipo_doc_deb = 'RET'  
	       AND Substring(Substring(dcp.aplicacion, 11, Len(dcp.aplicacion)), 1, 
		       Len(ret.codigo_retencion) ) = 
		   ret.codigo_retencion  
	       AND Substring(ret.descripcion, 1, 3) = 'ITB' 
	UNION 
	SELECT 'CP'                  AS CUENTABANCO, 
	       vac.proveedor         AS PROVEEDOR, 
	       pro.contribuyente     AS RNC_CED, 
	       pro.rubro4_prov       AS TIPO_ID, 
	       vac.tipo_fac          AS TIPO_DOC, 
	       0                     AS SUBTIPO_DOC, 
	       vac.num_cred          AS NUMERO_DOC, 
	       vac.ncf_fac           AS NCF, 
	       dcp.moneda            AS MONEDA, 
	       vac.fecha_pago        AS FECHA_DOC, 
	       0                     AS MONTO_TOTAL, 
	       0                     AS SALDO, 
	       dcp.tipo_cambio_dolar AS TASA, 
	       0                     AS SUBTOTAL, 
	       0                     AS DESCUENTO, 
	       0                     AS IMPUESTO1, 
	       0                     AS IMPUESTO2, 
	       0                     AS RUBRO1, 
	       0                     AS RUBRO2, 
	       vac.monto_local       AS RETENCION, 
	       0                     AS VALE_CH, 
	       0                     AS LINEA_VALE, 
	       vac.fecha_pago        AS FECHA_ORIG, 
	       'ISR'                 AS MODULO 
	FROM   $$COMPANIA$$.proveedor pro, 
	       $$COMPANIA$$.v_auxiliar_cp vac, 
	       $$COMPANIA$$.documentos_cp dcp, 
	       $$COMPANIA$$.retenciones ret 
	WHERE  vac.proveedor = pro.proveedor 
	       AND vac.proveedor = dcp.proveedor 
	       AND vac.tipo_doc_deb = dcp.tipo 
	       AND vac.num_deb = dcp.documento 
	       AND vac.tipo_doc_deb = 'RET'   
	       AND Substring(Substring(dcp.aplicacion, 11, Len(dcp.aplicacion)), 1, 
		       Len(ret.codigo_retencion) ) =  
		   ret.codigo_retencion 
	       AND Substring(ret.descripcion, 1, 3) <> 'ITB' 
	UNION 
	SELECT 'CH'                AS CUENTABANCO, 
	       ''                  AS PROVEEDOR, 
	       dcs.nit             AS RNC_CED, 
	       NULL                AS TIPO_ID, 
	       dcs.tipo            AS TIPO_DOC, 
	       dcs.subtipo         AS SUBTIPO_DOC, 
	       dcs.doc_soporte     AS NUMERO_DOC, 
	       ncf.ncf             AS NCF, 
	       cch.moneda          AS MONEDA, 
	       dcs.fecha           AS FECHA_DOC, 
	       dcs.monto           AS MONTO_TOTAL, 
	       0                   AS SALDO, 
	       val.tipo_camb_dolar AS TASA, 
	       dcs.subtotal        AS SUBTOTAL, 
	       dcs.descuento       AS DESCUENTO, 
	       dcs.impuesto1       AS IMPUESTO1, 
	       dcs.impuesto2       AS IMPUESTO2, 
	       dcs.rubro1          AS RUBRO1, 
	       dcs.rubro2          AS RUBRO2, 
	       0                   AS RETENCION, 
	       dcs.vale            AS VALE_CH, 
	       dcs.linea           AS LINEA_VALE, 
	       dcs.fecha           AS FECHA_ORIG, 
	       'CH'                AS MODULO 
	FROM   $$COMPANIA$$.vale val, 
	       $$COMPANIA$$.docs_soporte dcs, 
	       $$COMPANIA$$.ncf_documento ncf, 
	       $$COMPANIA$$.caja_chica cch 
	WHERE  dcs.vale = val.consecutivo 
	       AND val.caja_chica = cch.caja_chica 
	       AND val.rowpointer = ncf.doc_rowpointer 
	UNION 
	SELECT 'CH'                AS CUENTABANCO, 
	       ''                  AS PROVEEDOR, 
	       dcs.nit             AS RNC_CED, 
	       NULL                AS TIPO_ID, 
	       dcs.tipo            AS TIPO_DOC, 
	       0                   AS SUBTIPO_DOC, 
	       dcs.doc_soporte     AS NUMERO_DOC, 
	       ncf.ncf             AS NCF, 
	       cch.moneda          AS MONEDA, 
	       dcs.fecha           AS FECHA_DOC, 
	       0                   AS MONTO_TOTAL, 
	       0                   AS SALDO, 
	       val.tipo_camb_dolar AS TASA, 
	       0                   AS SUBTOTAL, 
	       0                   AS DESCUENTO, 
	       0                   AS IMPUESTO1, 
	       0                   AS IMPUESTO2, 
	       0                   AS RUBRO1, 
	       0                   AS RUBRO2, 
	       drc.monto           AS RETENCION, 
	       dcs.vale            AS VALE_CH, 
	       dcs.linea           AS LINEA_VALE, 
	       dcs.fecha           AS FECHA_ORIG, 
	       'RET'               AS MODULO 
	FROM   $$COMPANIA$$.vale val, 
	       $$COMPANIA$$.docs_soporte dcs, 
	       $$COMPANIA$$.ncf_documento ncf, 
	       $$COMPANIA$$.caja_chica cch, 
	       $$COMPANIA$$.det_retencion_ch drc, 
	       $$COMPANIA$$.retenciones ret 
	WHERE  dcs.vale = val.consecutivo 
	       AND val.caja_chica = cch.caja_chica 
	       AND val.rowpointer = ncf.doc_rowpointer 
	       AND dcs.vale = drc.vale        
	       AND dcs.linea  = drc.linea 
	       AND drc.codigo_retencion = ret.codigo_retencion 
	       AND Substring(ret.descripcion, 1, 3) = 'ITB' 
	UNION 
	SELECT 'CH'                AS CUENTABANCO, 
	       ''                  AS PROVEEDOR, 
	       dcs.nit             AS RNC_CED, 
	       NULL                AS TIPO_ID, 
	       dcs.tipo            AS TIPO_DOC, 
	       0                   AS SUBTIPO_DOC, 
	       dcs.doc_soporte     AS NUMERO_DOC, 
	       ncf.ncf             AS NCF, 
	       cch.moneda          AS MONEDA, 
	       dcs.fecha           AS FECHA_DOC, 
	       0                   AS MONTO_TOTAL, 
	       0                   AS SALDO, 
	       val.tipo_camb_dolar AS TASA, 
	       0                   AS SUBTOTAL, 
	       0                   AS DESCUENTO, 
	       0                   AS IMPUESTO1, 
	       0                   AS IMPUESTO2, 
	       0                   AS RUBRO1, 
	       0                   AS RUBRO2, 
	       drc.monto           AS RETENCION, 
	       dcs.vale            AS VALE_CH, 
	       dcs.linea           AS LINEA_VALE, 
	       dcs.fecha           AS FECHA_ORIG, 
	       'ISR'               AS MODULO 
	FROM   $$COMPANIA$$.vale val, 
	       $$COMPANIA$$.docs_soporte dcs, 
	       $$COMPANIA$$.ncf_documento ncf, 
	       $$COMPANIA$$.caja_chica cch, 
	       $$COMPANIA$$.det_retencion_ch drc, 
	       $$COMPANIA$$.retenciones ret 
	WHERE  dcs.vale = val.consecutivo 
	       AND val.caja_chica = cch.caja_chica 
	       AND val.rowpointer = ncf.doc_rowpointer 
	       AND dcs.vale = drc.vale        
	       AND dcs.linea  = drc.linea 
	       AND drc.codigo_retencion = ret.codigo_retencion 
	       AND Substring(ret.descripcion, 1, 3) <> 'ITB' 
	UNION 
	SELECT 'CP'                AS CUENTABANCO, 
	       vac.proveedor         AS PROVEEDOR, 
	       pro.contribuyente     AS RNC_CED, 
	       pro.rubro4_prov       AS TIPO_ID, 
	       vac.tipo_fac          AS TIPO_DOC, 
	       0                   AS SUBTIPO_DOC, 
	       vac.num_cred          AS NUMERO_DOC, 
	       vac.ncf_fac           AS NCF, 
	       dcr.moneda            AS MONEDA, 
	       vac.fecha_pago        AS FECHA_DOC, 
	       dcr.monto             AS MONTO_TOTAL, 
	       dcr.saldo             AS SALDO, 
	       ddb.tipo_cambio_dolar AS TASA, 
	       dcr.subtotal          AS SUBTOTAL, 
	       dcr.descuento         AS DESCUENTO, 
	       dcr.impuesto1         AS IMPUESTO1, 
	       dcr.impuesto2         AS IMPUESTO2, 
	       dcr.rubro1            AS RUBRO1, 
	       dcr.rubro2            AS RUBRO2, 
	       0                   AS RETENCION, 
	       0                   AS VALE_CH, 
	       0                   AS LINEA_VALE, 
	       dcr.fecha_documento   AS FECHA_ORIG, 
	       'COPY'              AS MODULO 
	FROM   $$COMPANIA$$.proveedor pro, 
	       $$COMPANIA$$.v_auxiliar_cp vac, 
	       $$COMPANIA$$.documentos_cp ddb, 
	       $$COMPANIA$$.retenciones ret, 
	       $$COMPANIA$$.documentos_cp dcr 
	WHERE  vac.proveedor = pro.proveedor 
	       AND vac.proveedor = ddb.proveedor 
	       AND vac.tipo_doc_deb = ddb.tipo 
	       AND vac.num_deb = ddb.documento 
	       AND vac.tipo_doc_deb = 'RET' 
	       AND vac.tipo_fac = dcr.tipo 
	       AND vac.num_cred = dcr.documento 
	       AND vac.proveedor = dcr.proveedor   
	       AND Substring(Substring(ddb.aplicacion, 11, Len(ddb.aplicacion)), 1, 
		       Len(ret.codigo_retencion) ) = 
		   ret.codigo_retencion 
	       AND Substring(ret.descripcion, 1, 3) <> 'ITB' 
	       AND Month(vac.fecha_pago) <> Month(dcr.fecha_documento);
       
       
       
       
       
       
       
       
CREATE VIEW $$COMPANIA$$.V_FECHA_PAGO_CP 
AS
	SELECT acp.proveedor    AS PROVEEDOR, 
	       acp.tipo_credito AS TIPO_FAC, 
	       acp.credito      AS FACTURA, 
	       Max(acp.fecha)   AS FECHA_PAGO, 
	       'CP'           AS MODULO 
	FROM   $$COMPANIA$$.auxiliar_cp acp 
	WHERE  acp.tipo_debito = 'CHQ' 
	GROUP  BY acp.proveedor, 
		  acp.tipo_credito, 
		  acp.credito;
          
          
          
          
          
          
          
         
CREATE VIEW $$COMPANIA$$.V_RNC_CIA 
AS
	SELECT conjunto AS COMPANIA, 
	       nit      AS RNC_COMPANIA 
	FROM   erpadmin.conjunto 
	WHERE  conjunto = '$$COMPANIA$$';





 
CREATE VIEW $$COMPANIA$$.V_FECHA_RETENCION_CP 
AS
	SELECT acp.proveedor    AS PROVEEDOR, 
	       acp.tipo_credito AS TIPO_FAC, 
	       acp.credito      AS FACTURA, 
	       Max(acp.fecha)   AS FECHA_RETENCION, 
	       'CP'           AS MODULO 
	FROM   $$COMPANIA$$.auxiliar_cp acp 
	WHERE  acp.tipo_debito = 'RET' 
	GROUP  BY acp.proveedor, 
		  acp.tipo_credito, 
		  acp.credito;





CREATE FUNCTION $$COMPANIA$$.MinDate(@DateTime DateTime)
returns datetime
as
begin
    return dateadd(dd,0, datediff(dd,0,@DateTime))
end;





CREATE FUNCTION $$COMPANIA$$.MaxDate(@d DateTime)
returns datetime
as
begin
    return Dateadd(ms,998,Dateadd(s,59,Dateadd(mi,59,Dateadd(hh,23,$$COMPANIA$$.MinDate(@d)))))
end;








CREATE FUNCTION $$COMPANIA$$.CPGetMovsX
(
	@Proveedor varchar(20),
	@FechaInicial datetime,
	@FechaFinal datetime,
	@TipoDC varchar(1),
	@Aprobado varchar(1) = NULL
)
RETURNS DECIMAL(28,8)
AS
BEGIN
DECLARE 
	@Total as decimal(28,8)
	
	IF (@TipoDC = 'A')
	BEGIN
		SELECT 	@Total = ISNULL(SUM(CASE TIPO_DC WHEN 'D' THEN monto_prov ELSE -monto_prov END),0)
		FROM 	$$COMPANIA$$.documentos_cp d, $$COMPANIA$$.TIPO_DOC_CP t
		WHERE 	proveedor = @Proveedor
		AND		fecha >= $$COMPANIA$$.MinDate( @FechaInicial )
		AND     d.TIPO = t.TIPO
		AND 	((@FechaFinal IS NOT NULL AND fecha <= $$COMPANIA$$.MaxDate(@FechaFinal) OR @FechaFinal IS NULL ))
		AND		((APROBADO IS NOT NULL AND APROBADO = @Aprobado) OR @Aprobado IS NULL)
	END
	ELSE
	BEGIN
		SELECT 	@Total = ISNULL(SUM(monto_prov),0)
		FROM 	$$COMPANIA$$.documentos_cp d, $$COMPANIA$$.TIPO_DOC_CP t
		WHERE 	proveedor = @Proveedor
		AND		fecha >= $$COMPANIA$$.MinDate( @FechaInicial )
		AND 	((@FechaFinal IS NOT NULL AND fecha <= $$COMPANIA$$.MaxDate(@FechaFinal) OR @FechaFinal IS NULL ))
		AND 	d.TIPO = t.TIPO 
		AND		((APROBADO IS NOT NULL AND APROBADO = @Aprobado) OR @Aprobado IS NULL)
		AND     t.TIPO_DC = @TipoDC
	END

	RETURN ISNULL(@Total,0)
END;







CREATE FUNCTION $$COMPANIA$$.CPGetMovs
(
	@Proveedor varchar(20),
	@FechaInicial datetime,
	@FechaFinal datetime,
	@TipoDC varchar(1)
)
RETURNS DECIMAL(28,8)
AS
BEGIN
	RETURN $$COMPANIA$$.CPGetMovsX(@Proveedor, @FechaInicial, @FechaFinal, @TipoDC, DEFAULT)
END;






Create PROCEDURE $$COMPANIA$$.CPGetSaldosProveedor
(
	@Proveedor as varchar(20),
	@FechaInicial as DateTime,
	@FechaFinal as DateTime,
	@SaldoInicial as decimal(28,8) OUTPUT,
	@SaldoFinal as decimal(28,8) OUTPUT,
	@TotalCreditos as decimal(28,8)OUTPUT,
	@TotalDebitos as decimal(28,8) OUTPUT
) AS
BEGIN
	DECLARE
		@SaldoActual as decimal(28,8),
		@Movimientos as decimal(28,8)

	SELECT 	@SaldoActual = saldo
	FROM 	$$COMPANIA$$.proveedor
	WHERE 	proveedor = @Proveedor

	SELECT @Movimientos = $$COMPANIA$$.CPGetMovs( @Proveedor, DATEADD( d, 1, @FechaFinal), null, 'A')
   
	Set @SaldoFinal = @SaldoActual + @Movimientos

	Set @TotalCreditos = $$COMPANIA$$.CPGetMovs( @Proveedor, @FechaInicial, @FechaFinal, 'C' )
	set @TotalDebitos = $$COMPANIA$$.CPGetMovs( @Proveedor, @FechaInicial, @FechaFinal, 'D') 
	Set @SaldoInicial = @SaldoActual + @Movimientos - @TotalCreditos + @TotalDebitos
	
	RETURN 1
END;







CREATE FUNCTION $$COMPANIA$$.CPGetMovsXDol
(
	@Proveedor varchar(20),
	@FechaInicial datetime,
	@FechaFinal datetime,
	@TipoDC varchar(1),
	@Aprobado varchar(1) = NULL
)
RETURNS DECIMAL(28,8)
AS
BEGIN
DECLARE 
	@Total as decimal(28,8)
	
	IF (@TipoDC = 'A')
	BEGIN
		SELECT 	@Total = ISNULL(SUM(CASE TIPO_DC WHEN 'D' THEN monto_dolar ELSE -monto_dolar END),0)
		FROM 	$$COMPANIA$$.documentos_cp d, $$COMPANIA$$.TIPO_DOC_CP t
		WHERE 	proveedor = @Proveedor
		AND		fecha >= $$COMPANIA$$.MinDate( @FechaInicial )
		AND     d.TIPO = t.TIPO
		AND 	((@FechaFinal IS NOT NULL AND fecha <= $$COMPANIA$$.MaxDate(@FechaFinal) OR @FechaFinal IS NULL ))
		AND		((APROBADO IS NOT NULL AND APROBADO = @Aprobado) OR @Aprobado IS NULL)
	END
	ELSE
	BEGIN
		SELECT 	@Total = ISNULL(SUM(monto_dolar),0)
		FROM 	$$COMPANIA$$.documentos_cp d, $$COMPANIA$$.TIPO_DOC_CP t
		WHERE 	proveedor = @Proveedor
		AND		fecha >= $$COMPANIA$$.MinDate( @FechaInicial )
		AND 	((@FechaFinal IS NOT NULL AND fecha <= $$COMPANIA$$.MaxDate(@FechaFinal) OR @FechaFinal IS NULL ))
		AND 	d.TIPO = t.TIPO 
		AND		((APROBADO IS NOT NULL AND APROBADO = @Aprobado) OR @Aprobado IS NULL)
		AND     t.TIPO_DC = @TipoDC
	END

	RETURN ISNULL(@Total,0)
END;







CREATE FUNCTION $$COMPANIA$$.CPGetMovsDol
(
	@Proveedor varchar(20),
	@FechaInicial datetime,
	@FechaFinal datetime,
	@TipoDC varchar(1)
)
RETURNS DECIMAL(28,8)
AS
BEGIN
	RETURN $$COMPANIA$$.CPGetMovsXDol(@Proveedor, @FechaInicial, @FechaFinal, @TipoDC, DEFAULT)
END;







Create PROCEDURE $$COMPANIA$$.CPGetSaldosProvDol
(
	@Proveedor as varchar(20),
	@FechaInicial as DateTime,
	@FechaFinal as DateTime,
	@SaldoInicial as decimal(28,8) OUTPUT,
	@SaldoFinal as decimal(28,8) OUTPUT,
	@TotalCreditos as decimal(28,8)OUTPUT,
	@TotalDebitos as decimal(28,8) OUTPUT
) AS
BEGIN
	DECLARE
		@SaldoActual as decimal(28,8),
		@Movimientos as decimal(28,8)

	SELECT 	@SaldoActual = saldo_dolar
	FROM 	$$COMPANIA$$.proveedor
	WHERE 	proveedor = @Proveedor

	SELECT @Movimientos = $$COMPANIA$$.CPGetMovsDol( @Proveedor, DATEADD( d, 1, @FechaFinal), null, 'A')
   
	Set @SaldoFinal = @SaldoActual + @Movimientos

	Set @TotalCreditos = $$COMPANIA$$.CPGetMovsDol( @Proveedor, @FechaInicial, @FechaFinal, 'C' )
	set @TotalDebitos = $$COMPANIA$$.CPGetMovsDol( @Proveedor, @FechaInicial, @FechaFinal, 'D') 
	Set @SaldoInicial = @SaldoActual + @Movimientos - @TotalCreditos + @TotalDebitos
	
	RETURN 1
END;






CREATE FUNCTION $$COMPANIA$$.CPGetMovsXLoc
(
	@Proveedor varchar(20),
	@FechaInicial datetime,
	@FechaFinal datetime,
	@TipoDC varchar(1),
	@Aprobado varchar(1) = NULL
)
RETURNS DECIMAL(28,8)
AS
BEGIN
DECLARE 
	@Total as decimal(28,8)
	
	IF (@TipoDC = 'A')
	BEGIN
		SELECT 	@Total = ISNULL(SUM(CASE TIPO_DC WHEN 'D' THEN monto_local ELSE -monto_local END),0)
		FROM 	$$COMPANIA$$.documentos_cp d, $$COMPANIA$$.TIPO_DOC_CP t
		WHERE 	proveedor = @Proveedor
		AND		fecha >= $$COMPANIA$$.MinDate( @FechaInicial )
		AND     d.TIPO = t.TIPO
		AND 	((@FechaFinal IS NOT NULL AND fecha <= $$COMPANIA$$.MaxDate(@FechaFinal) OR @FechaFinal IS NULL ))
		AND		((APROBADO IS NOT NULL AND APROBADO = @Aprobado) OR @Aprobado IS NULL)
	END
	ELSE
	BEGIN
		SELECT 	@Total = ISNULL(SUM(monto_local),0)
		FROM 	$$COMPANIA$$.documentos_cp d, $$COMPANIA$$.TIPO_DOC_CP t
		WHERE 	proveedor = @Proveedor
		AND		fecha >= $$COMPANIA$$.MinDate( @FechaInicial )
		AND 	((@FechaFinal IS NOT NULL AND fecha <= $$COMPANIA$$.MaxDate(@FechaFinal) OR @FechaFinal IS NULL ))
		AND 	d.TIPO = t.TIPO 
		AND		((APROBADO IS NOT NULL AND APROBADO = @Aprobado) OR @Aprobado IS NULL)
		AND     t.TIPO_DC = @TipoDC
	END

	RETURN ISNULL(@Total,0)
END;






CREATE FUNCTION $$COMPANIA$$.CPGetMovsLoc
(
	@Proveedor varchar(20),
	@FechaInicial datetime,
	@FechaFinal datetime,
	@TipoDC varchar(1)
)
RETURNS DECIMAL(28,8)
AS
BEGIN
	RETURN $$COMPANIA$$.CPGetMovsXLoc(@Proveedor, @FechaInicial, @FechaFinal, @TipoDC, DEFAULT)
END;







Create PROCEDURE $$COMPANIA$$.CPGetSaldosProvLoc
(
	@Proveedor as varchar(20),
	@FechaInicial as DateTime,
	@FechaFinal as DateTime,
	@SaldoInicial as decimal(28,8) OUTPUT,
	@SaldoFinal as decimal(28,8) OUTPUT,
	@TotalCreditos as decimal(28,8)OUTPUT,
	@TotalDebitos as decimal(28,8) OUTPUT
) AS
BEGIN
	DECLARE
		@SaldoActual as decimal(28,8),
		@Movimientos as decimal(28,8)

	SELECT 	@SaldoActual = saldo_local
	FROM 	$$COMPANIA$$.proveedor
	WHERE 	proveedor = @Proveedor

	SELECT @Movimientos = $$COMPANIA$$.CPGetMovsLoc( @Proveedor, DATEADD( d, 1, @FechaFinal), null, 'A')
   
	Set @SaldoFinal = @SaldoActual + @Movimientos
	 
	Set @TotalCreditos = $$COMPANIA$$.CPGetMovsLoc( @Proveedor, @FechaInicial, @FechaFinal, 'C' )
	set @TotalDebitos = $$COMPANIA$$.CPGetMovsLoc( @Proveedor, @FechaInicial, @FechaFinal, 'D') 
	Set @SaldoInicial = @SaldoActual + @Movimientos - @TotalCreditos + @TotalDebitos
	
	RETURN 1
END;








CREATE FUNCTION $$COMPANIA$$.CPGetMovsXFecha
(
	@Proveedor varchar(20),
	@FechaInicial datetime,
	@FechaFinal datetime,
	@TipoDC varchar(1),
	@Aprobado varchar(1) = NULL
)
RETURNS DECIMAL(28,8)
AS
BEGIN
DECLARE 
	@Total as decimal(28,8)
	
	IF (@TipoDC = 'A')
	BEGIN
		SELECT 	@Total = ISNULL(SUM(CASE TIPO_DC WHEN 'D' THEN monto_prov ELSE -monto_prov END),0)
		FROM 	$$COMPANIA$$.documentos_cp d, $$COMPANIA$$.TIPO_DOC_CP t
		WHERE 	proveedor = @Proveedor
		AND		fecha_documento >= $$COMPANIA$$.MinDate( @FechaInicial )
		AND     d.TIPO = t.TIPO
		AND 	((@FechaFinal IS NOT NULL AND fecha_documento <= $$COMPANIA$$.MaxDate(@FechaFinal) OR @FechaFinal IS NULL ))
		AND		((APROBADO IS NOT NULL AND APROBADO = @Aprobado) OR @Aprobado IS NULL)
	END
	ELSE
	BEGIN
		SELECT 	@Total = ISNULL(SUM(monto_prov),0)
		FROM 	$$COMPANIA$$.documentos_cp d, $$COMPANIA$$.TIPO_DOC_CP t
		WHERE 	proveedor = @Proveedor
		AND		fecha_documento >= $$COMPANIA$$.MinDate( @FechaInicial )
		AND 	((@FechaFinal IS NOT NULL AND fecha_documento <= $$COMPANIA$$.MaxDate(@FechaFinal) OR @FechaFinal IS NULL ))
		AND 	d.TIPO = t.TIPO 
		AND		((APROBADO IS NOT NULL AND APROBADO = @Aprobado) OR @Aprobado IS NULL)
		AND     t.TIPO_DC = @TipoDC
	END

	RETURN ISNULL(@Total,0)
END;







CREATE FUNCTION $$COMPANIA$$.CPGetMovsFecha
(
	@Proveedor varchar(20),
	@FechaInicial datetime,
	@FechaFinal datetime,
	@TipoDC varchar(1)
)
RETURNS DECIMAL(28,8)
AS
BEGIN
	RETURN $$COMPANIA$$.CPGetMovsXFecha(@Proveedor, @FechaInicial, @FechaFinal, @TipoDC, DEFAULT)
END;








Create PROCEDURE $$COMPANIA$$.CPGetSaldosProvFechaDoc
(
	@Proveedor as varchar(20),
	@FechaInicial as DateTime,
	@FechaFinal as DateTime,
	@SaldoInicial as decimal(28,8) OUTPUT,
	@SaldoFinal as decimal(28,8) OUTPUT,
	@TotalCreditos as decimal(28,8)OUTPUT,
	@TotalDebitos as decimal(28,8) OUTPUT
) AS
BEGIN
	DECLARE
		@SaldoActual as decimal(28,8),
		@Movimientos as decimal(28,8)

	SELECT 	@SaldoActual = saldo
	FROM 	$$COMPANIA$$.proveedor
	WHERE 	proveedor = @Proveedor

	SELECT @Movimientos = $$COMPANIA$$.CPGetMovsFecha( @Proveedor, DATEADD( d, 1, @FechaFinal), null, 'A')
   
	Set @SaldoFinal = @SaldoActual + @Movimientos
	 	
	Set @TotalCreditos = $$COMPANIA$$.CPGetMovsFecha( @Proveedor, @FechaInicial, @FechaFinal, 'C' )
	set @TotalDebitos = $$COMPANIA$$.CPGetMovsFecha( @Proveedor, @FechaInicial, @FechaFinal, 'D') 
	Set @SaldoInicial = @SaldoActual + @Movimientos - @TotalCreditos + @TotalDebitos
	
	RETURN 1
END;








CREATE FUNCTION $$COMPANIA$$.CPGetMovsXFechaDol
(
	@Proveedor varchar(20),
	@FechaInicial datetime,
	@FechaFinal datetime,
	@TipoDC varchar(1),
	@Aprobado varchar(1) = NULL
)
RETURNS DECIMAL(28,8)
AS
BEGIN
DECLARE 
	@Total as decimal(28,8)
	
	IF (@TipoDC = 'A')
	BEGIN
		SELECT 	@Total = ISNULL(SUM(CASE TIPO_DC WHEN 'D' THEN monto_dolar ELSE -monto_dolar END),0)
		FROM 	$$COMPANIA$$.documentos_cp d, $$COMPANIA$$.TIPO_DOC_CP t
		WHERE 	proveedor = @Proveedor
		AND		fecha_documento >= $$COMPANIA$$.MinDate( @FechaInicial )
		AND     d.TIPO = t.TIPO
		AND 	((@FechaFinal IS NOT NULL AND fecha_documento <= $$COMPANIA$$.MaxDate(@FechaFinal) OR @FechaFinal IS NULL ))
		AND		((APROBADO IS NOT NULL AND APROBADO = @Aprobado) OR @Aprobado IS NULL)
	END
	ELSE
	BEGIN
		SELECT 	@Total = ISNULL(SUM(monto_dolar),0)
		FROM 	$$COMPANIA$$.documentos_cp d, $$COMPANIA$$.TIPO_DOC_CP t
		WHERE 	proveedor = @Proveedor
		AND		fecha_documento >= $$COMPANIA$$.MinDate( @FechaInicial )
		AND 	((@FechaFinal IS NOT NULL AND fecha_documento <= $$COMPANIA$$.MaxDate(@FechaFinal) OR @FechaFinal IS NULL ))
		AND 	d.TIPO = t.TIPO 
		AND		((APROBADO IS NOT NULL AND APROBADO = @Aprobado) OR @Aprobado IS NULL)
		AND     t.TIPO_DC = @TipoDC
	END

	RETURN ISNULL(@Total,0)
END;









CREATE FUNCTION $$COMPANIA$$.CPGetMovsFechaDol
(
	@Proveedor varchar(20),
	@FechaInicial datetime,
	@FechaFinal datetime,
	@TipoDC varchar(1)
)
RETURNS DECIMAL(28,8)
AS
BEGIN
	RETURN $$COMPANIA$$.CPGetMovsXFechaDol(@Proveedor, @FechaInicial, @FechaFinal, @TipoDC, DEFAULT)
END;







Create PROCEDURE $$COMPANIA$$.CPGetSaldosProvFechaDocDol
(
	@Proveedor as varchar(20),
	@FechaInicial as DateTime,
	@FechaFinal as DateTime,
	@SaldoInicial as decimal(28,8) OUTPUT,
	@SaldoFinal as decimal(28,8) OUTPUT,
	@TotalCreditos as decimal(28,8)OUTPUT,
	@TotalDebitos as decimal(28,8) OUTPUT
) AS
BEGIN
	DECLARE
		@SaldoActual as decimal(28,8),
		@Movimientos as decimal(28,8)

	SELECT 	@SaldoActual = saldo_dolar
	FROM 	$$COMPANIA$$.proveedor
	WHERE 	proveedor = @Proveedor

	SELECT @Movimientos = $$COMPANIA$$.CPGetMovsFechaDol( @Proveedor, DATEADD( d, 1, @FechaFinal), null, 'A')
   
	Set @SaldoFinal = @SaldoActual + @Movimientos
	
	Set @TotalCreditos = $$COMPANIA$$.CPGetMovsFechaDol( @Proveedor, @FechaInicial, @FechaFinal, 'C' )
	set @TotalDebitos = $$COMPANIA$$.CPGetMovsFechaDol( @Proveedor, @FechaInicial, @FechaFinal, 'D') 
	Set @SaldoInicial = @SaldoActual + @Movimientos - @TotalCreditos + @TotalDebitos
	
	RETURN 1
END;








CREATE FUNCTION $$COMPANIA$$.CPGetMovsXFechaLoc
(
	@Proveedor varchar(20),
	@FechaInicial datetime,
	@FechaFinal datetime,
	@TipoDC varchar(1),
	@Aprobado varchar(1) = NULL
)
RETURNS DECIMAL(28,8)
AS
BEGIN
DECLARE 
	@Total as decimal(28,8)
	
	IF (@TipoDC = 'A')
	BEGIN
		SELECT 	@Total = ISNULL(SUM(CASE TIPO_DC WHEN 'D' THEN monto_local ELSE -monto_local END),0)
		FROM 	$$COMPANIA$$.documentos_cp d, $$COMPANIA$$.TIPO_DOC_CP t
		WHERE 	proveedor = @Proveedor
		AND		fecha_documento >= $$COMPANIA$$.MinDate( @FechaInicial )
		AND     d.TIPO = t.TIPO
		AND 	((@FechaFinal IS NOT NULL AND fecha_documento <= $$COMPANIA$$.MaxDate(@FechaFinal) OR @FechaFinal IS NULL ))
		AND		((APROBADO IS NOT NULL AND APROBADO = @Aprobado) OR @Aprobado IS NULL)
	END
	ELSE
	BEGIN
		SELECT 	@Total = ISNULL(SUM(monto_local),0)
		FROM 	$$COMPANIA$$.documentos_cp d, $$COMPANIA$$.TIPO_DOC_CP t
		WHERE 	proveedor = @Proveedor
		AND		fecha_documento >= $$COMPANIA$$.MinDate( @FechaInicial )
		AND 	((@FechaFinal IS NOT NULL AND fecha_documento <= $$COMPANIA$$.MaxDate(@FechaFinal) OR @FechaFinal IS NULL ))
		AND 	d.TIPO = t.TIPO 
		AND		((APROBADO IS NOT NULL AND APROBADO = @Aprobado) OR @Aprobado IS NULL)
		AND     t.TIPO_DC = @TipoDC
	END

	RETURN ISNULL(@Total,0)
END;






CREATE FUNCTION $$COMPANIA$$.CPGetMovsFechaLoc
(
	@Proveedor varchar(20),
	@FechaInicial datetime,
	@FechaFinal datetime,
	@TipoDC varchar(1)
)
RETURNS DECIMAL(28,8)
AS
BEGIN
	RETURN $$COMPANIA$$.CPGetMovsXFechaLoc(@Proveedor, @FechaInicial, @FechaFinal, @TipoDC, DEFAULT)
END;




CREATE FUNCTION $$COMPANIA$$.OBTENERSALDODOCUMENTOCP
(@PESCREDITO VARCHAR(1), @PPROVEEDOR VARCHAR(50), @PTIPO VARCHAR(5), @PDOCUMENTO VARCHAR(100), 
 @PFECHAINICIAL DATETIME, @PFECHAFINAL DATETIME)
RETURNS DECIMAL(28,8)
AS
BEGIN
	DECLARE @MONTO DECIMAL(28,8)

IF @PESCREDITO = 'S'
	SELECT @MONTO = SUM(  MONTO_CREDITO ) 
	FROM $$COMPANIA$$.AUXILIAR_CP
	WHERE PROVEEDOR = @PPROVEEDOR
	AND TIPO_CREDITO = @PTIPO
	AND CREDITO = @PDOCUMENTO
	AND FECHA BETWEEN @PFECHAINICIAL AND @PFECHAFINAL
ELSE
	SELECT @MONTO = SUM(  MONTO_DEBITO ) 
	FROM $$COMPANIA$$.AUXILIAR_CP
	WHERE PROVEEDOR = @PPROVEEDOR
	AND TIPO_DEBITO = @PTIPO
	AND DEBITO = @PDOCUMENTO
	AND FECHA BETWEEN @PFECHAINICIAL AND @PFECHAFINAL

RETURN ISNULL(@MONTO,1)

END;




CREATE FUNCTION $$COMPANIA$$.MONTO_PAGO_CP_SINRET (@PPROVEEDOR VARCHAR(50), @PTIPO VARCHAR(5), @PDOCUMENTO VARCHAR(100), 
  @PFECHAINICIAL DATETIME, @PFECHAFINAL DATETIME)
RETURNS DECIMAL(28,8)
 AS
 BEGIN
  DECLARE @MONTO DECIMAL(28,8)
  
SELECT @MONTO = SUM(MONTO_CREDITO)
FROM $$COMPANIA$$.DOCUMENTOS_CP DCP1 INNER JOIN
	 $$COMPANIA$$.AUXILIAR_CP AUX1 ON 
			DCP1.PROVEEDOR = AUX1.PROVEEDOR AND DCP1.DOCUMENTO = AUX1.CREDITO AND DCP1.TIPO = AUX1.TIPO_CREDITO
WHERE AUX1.TIPO_CREDITO = @PTIPO AND AUX1.CREDITO = @PDOCUMENTO AND AUX1.TIPO_DEBITO NOT IN ( 'RET', 'N/C' )
AND (AUX1.FECHA >= @PFECHAINICIAL 
AND  AUX1.FECHA <= @PFECHAFINAL)
AND AUX1.PROVEEDOR = @PPROVEEDOR

RETURN ISNULL(@MONTO,0)
END;




Create PROCEDURE $$COMPANIA$$.CPGetSaldosProvFechaDocLoc
(
	@Proveedor as varchar(20),
	@FechaInicial as DateTime,
	@FechaFinal as DateTime,
	@SaldoInicial as decimal(28,8) OUTPUT,
	@SaldoFinal as decimal(28,8) OUTPUT,
	@TotalCreditos as decimal(28,8)OUTPUT,
	@TotalDebitos as decimal(28,8) OUTPUT
) AS
BEGIN
	DECLARE
		@SaldoActual as decimal(28,8),
		@Movimientos as decimal(28,8)

	SELECT 	@SaldoActual = saldo_local
	FROM 	$$COMPANIA$$.proveedor
	WHERE 	proveedor = @Proveedor

	SELECT @Movimientos = $$COMPANIA$$.CPGetMovsFechaLoc( @Proveedor, DATEADD( d, 1, @FechaFinal), null, 'A')
   
	Set @SaldoFinal = @SaldoActual + @Movimientos
	
	Set @TotalCreditos = $$COMPANIA$$.CPGetMovsFechaLoc( @Proveedor, @FechaInicial, @FechaFinal, 'C' )
	set @TotalDebitos = $$COMPANIA$$.CPGetMovsFechaLoc( @Proveedor, @FechaInicial, @FechaFinal, 'D') 
	Set @SaldoInicial = @SaldoActual + @Movimientos - @TotalCreditos + @TotalDebitos
	
	RETURN 1
END;



CREATE PROCEDURE $$COMPANIA$$.CPReportes
 (
  @Reporte as varchar(20), /*ANTIGUEDAD, VENCIMIENTO O PROYECCIÓN*/
  @TipoReporte as varchar(1), /*R=RESUMIDO, D= DETALLADO O T= SOLO TOTALES*/
  @ExcluirDifCam as varchar(1), /*Indica si excluye o no documentos por diferencial cambiario*/
  @dtFechaConHoraLim as datetime,
  @ConParcialidades as varchar(1), /*S = USA PARCIALIDADES, N= SIN PARCIALIDADES EFR planes de pago*/ 
  @psFiltro as varchar(max), /*Filtro de documentos y más, se usa porque cuando se hace Resumido, se toman todos los docs de un proveedor*/
  @psRangos as varchar(max), /*Sum de rangos*/
  @psCaseRangos as varchar(max), /*Case para obtener el rango en que se ubica el saldo del proveedor*/
  @psMontosParc as varchar(max) /*Montos de parcialidades, si no usa parcialidades viene en ceros más el nombre de las columnas*/
  )
  as
  declare @sql as nvarchar(max)
  declare @tabla_rep as varchar(11)
  declare @sqlSum as varchar(3)
  declare @sqlWhrSalFec as nvarchar(200)
  declare @sqlFecha as varchar(19)
  declare @sqlCreditos as varchar(60)
  declare @sFechaDoc as varchar(50)
  /* EFR planes de pago en CP */
  declare @sqlSaldos as nvarchar(max) 
  declare @sqlWhrPro as varchar(250)
  declare @sqlFechasDoc as varchar(500)
  declare @sqlMontosDoc as varchar(max) 
  declare @sTablas as varchar(max)
  /*EFR planes de pago en CP */
  begin
  set @tabla_rep = 'REPORTES_CP'
  set @sqlSum = ' '
  set @sqlFecha = convert(varchar(19),@dtFechaConHoraLim,20)
  set @sqlCreditos = '''FAC'',''INT'',''L/C'',''N/D'',''O/D'',''RED'',''B/V'',''RHP''' 
  set @sTablas = '' 
  set @sFechaDoc = ' '
  
  /*Esto se hace porque si es R significa que el reporte no es datallado, lo que implica que se sumariza por proveedor, por lo que se hace de una vez acá en la sentencia ,
  sino, simplemente se deja el ' ' para que convierta los datos pero sin totalizarlos*/
  begin 
  set @sTablas = '$$COMPANIA$$.proveedor pro, $$COMPANIA$$.condicion_pago cop, $$COMPANIA$$.subtipo_doc_cp sdc, $$COMPANIA$$.documentos_cp dcp '
  set @sqlWhrPro = ' pro.proveedor = dcp.proveedor AND cop.condicion_pago = dcp.condicion_pago
  AND dcp.tipo = sdc.tipo
  AND dcp.subtipo = sdc.subtipo '
  end
  
  if(@Reporte <> 'PROYECCION')
  set @sFechaDoc = 'dcp.fecha <= ''' + @sqlFecha + ''' AND '
  
  if(@ExcluirDifCam = 'S')
  set @sqlWhrSalFec = ' ( dcp.fecha_ult_credito > ''' + convert(varchar,@dtFechaConHoraLim,111) + ''' OR
  dcp.saldo <> 0 )'
  else
  set @sqlWhrSalFec = ' ( dcp.fecha_ult_credito > ''' + convert(varchar,@dtFechaConHoraLim,111) + ''' OR
  dcp.saldo <> 0 OR dcp.saldo_local <> 0 OR dcp.saldo_dolar <> 0 )'
  /*EFR planes de pago en cp */
  
  if(@ConParcialidades = 'N') 
  begin
  set @sqlFechasDoc = 'dcp.fecha, dcp.fecha_documento, dcp.fecha_vence,'
  
  set @sqlMontosDoc = '0 AS parcialidad, dcp.monto, dcp.monto_prov, dcp.MONTO_LOCAL, dcp.MONTO_DOLAR,'
  
  set @sqlSaldos = 'dcp.MONTO_PROV - 
  (case when dcp.TIPO in (' + @sqlCreditos + ') then
   (SELECT ISNULL(SUM(acp.monto_prov),0) 
  FROM $$COMPANIA$$.auxiliar_cp acp WHERE acp.tipo_credito = dcp.TIPO
  and acp.credito = dcp.DOCUMENTO
  and acp.proveedor = dcp.proveedor
  AND acp.fecha <= ''' + @sqlFecha + ''') else
  (SELECT ISNULL(SUM(acp.monto_prov),0) 
  FROM $$COMPANIA$$.auxiliar_cp acp WHERE acp.tipo_debito = dcp.TIPO
  and acp.debito = dcp.DOCUMENTO
  and acp.proveedor = dcp.proveedor
  AND acp.fecha <= ''' + @sqlFecha + ''' )  end) AS SALDO, 
   dcp.monto_local - 
  (case when dcp.TIPO in (' + @sqlCreditos + ') then
   (SELECT ISNULL(SUM( acp.monto_local),0) 
  FROM $$COMPANIA$$.auxiliar_cp acp WHERE acp.tipo_credito = dcp.TIPO
  and acp.credito = dcp.DOCUMENTO
  and acp.proveedor = dcp.proveedor
  AND acp.fecha <= ''' + @sqlFecha + ''') else
  (SELECT ISNULL(SUM( acp.monto_local) ,0) 
  FROM $$COMPANIA$$.auxiliar_cp acp WHERE acp.tipo_debito = dcp.TIPO
  and acp.debito = dcp.DOCUMENTO
  and acp.proveedor = dcp.proveedor
  AND acp.fecha <= ''' + @sqlFecha + ''')  end) -
  (SELECT ISNULL(SUM( hdc.dif_cam_local),0)
  FROM $$COMPANIA$$.hist_difcam_cp hdc 
  WHERE hdc.documento = dcp.DOCUMENTO
  AND hdc.PROVEEDOR = dcp.PROVEEDOR
  AND hdc.tipo = dcp.TIPO 
  AND hdc.asiento_proc IS NOT Null
  AND hdc.estado <> ''R''
  AND hdc.fecha_proc > ''' + @sqlFecha + ''') AS SALDO_LOCAL, 
  dcp.monto_dolar -
  (case when dcp.TIPO in (' + @sqlCreditos + ') then
   (SELECT ISNULL(SUM( acp.MONTO_DOLAR),0) 
  FROM $$COMPANIA$$.auxiliar_cp acp WHERE acp.tipo_credito = dcp.TIPO
  and acp.credito = dcp.DOCUMENTO
  and acp.proveedor = dcp.proveedor
  AND acp.fecha <= ''' + @sqlFecha + ''') else
  (SELECT ISNULL(SUM( acp.MONTO_DOLAR ),0) 
  FROM $$COMPANIA$$.auxiliar_cp acp WHERE acp.tipo_debito = dcp.TIPO
  and acp.debito = dcp.DOCUMENTO
  and acp.proveedor = dcp.proveedor
  AND acp.fecha <= ''' + @sqlFecha + ''')  end) -
  (SELECT ISNULL(SUM( hdc.dif_cam_dolar),0)
  FROM $$COMPANIA$$.hist_difcam_cp hdc
  WHERE hdc.documento = dcp.DOCUMENTO
  AND hdc.tipo = dcp.TIPO
  AND hdc.PROVEEDOR = dcp.PROVEEDOR
  AND hdc.asiento_proc IS NOT Null
  AND hdc.estado <> ''R''
  AND hdc.fecha_proc > ''' + @sqlFecha + ''')AS SALDO_DOLAR'
  end
  else 
  begin
  set @sTablas = @sTablas + ' left join $$COMPANIA$$.parcialidades_cp par on dcp.documento = par.documento_origen AND dcp.tipo = par.tipo_doc_origen AND dcp.proveedor =          par.proveedor '
  set @sqlFechasDoc = 'CASE WHEN dcp.NUM_PARCIALIDADES > 0 THEN ( par.fecha_rige ) ELSE ( dcp.fecha ) END as fecha, CASE WHEN dcp.NUM_PARCIALIDADES > 0 THEN ( par.fecha_rige )     ELSE ( dcp.fecha_documento ) END as fecha_documento, CASE WHEN dcp.NUM_PARCIALIDADES > 0 THEN ( par.fecha_vence ) ELSE ( dcp.fecha_vence ) END as fecha_vence,'
  set @sqlMontosDoc = 'par.parcialidad, (CASE WHEN dcp.NUM_PARCIALIDADES > 0 THEN ( CASE WHEN cop.tipo_condpago = ''PA'' THEN (dcp.monto * ( par.porcentaje / 100 )) 
  ELSE (par.monto_cuota) END ) 
  ELSE ( dcp.monto ) END) as MONTO, 
  (CASE WHEN dcp.NUM_PARCIALIDADES > 0 THEN ( CASE WHEN cop.tipo_condpago = ''PA'' THEN (dcp.monto_PROV * (par.porcentaje / 100)) 
  ELSE (par.monto_cuota_loc/ dcp.tipo_camb_act_prov) END )
  ELSE ( dcp.monto_prov ) END) as MONTO_PROV, 
  (CASE WHEN dcp.NUM_PARCIALIDADES > 0 THEN ( CASE WHEN cop.tipo_condpago = ''PA'' THEN (dcp.monto_local * ( par.porcentaje / 100 )) 
  ELSE (par.monto_cuota_loc) END ) 
  ELSE ( dcp.MONTO_LOCAL ) END) as MONTO_LOCAL, 
  (CASE WHEN dcp.NUM_PARCIALIDADES > 0 THEN ( CASE WHEN cop.tipo_condpago = ''PA'' THEN (dcp.monto_dolar * ( par.porcentaje / 100 )) 
  ELSE (par.monto_cuota_dol) END ) 
  ELSE ( dcp.MONTO_DOLAR ) END) as MONTO_DOLAR,'
  set @sqlSaldos = '(CASE WHEN dcp.NUM_PARCIALIDADES > 0 THEN (
  CASE WHEN cop.tipo_condpago = ''PA'' THEN (dcp.monto_prov * (par.porcentaje / 100)) 
  ELSE (par.monto_cuota_loc/ dcp.tipo_camb_act_prov) END)
  ELSE dcp.monto_prov END) - 
  (CASE WHEN dcp.TIPO in ('+ @sqlCreditos +') then
  ( CASE WHEN dcp.NUM_PARCIALIDADES > 0 THEN (
  CASE WHEN cop.tipo_condpago = ''PA'' THEN ( SELECT ISNULL (SUM( apa.monto_prov_debito ),0 )
  FROM $$COMPANIA$$.auxiliar_parc_cp apa WHERE apa.tipo_credito = dcp.tipo
  AND apa.credito = dcp.documento AND apa.parcialidad = par.PARCIALIDAD
  AND apa.fecha <= ''' + @sqlFecha + ''' )
  ELSE ( SELECT ISNULL ( SUM( apa.monto_amortiza + apa.monto_interes ),0) 
  FROM $$COMPANIA$$.auxiliar_parc_cp apa WHERE apa.tipo_credito = dcp.tipo
  AND apa.credito = dcp.documento AND apa.parcialidad = par.PARCIALIDAD
  AND apa.fecha <= ''' + @sqlFecha + ''' ) END)
  ELSE (SELECT ISNULL(SUM( acp.monto_prov),0) 
  FROM $$COMPANIA$$.auxiliar_cp acp WHERE acp.tipo_credito = dcp.TIPO
  and acp.credito = dcp.DOCUMENTO
  and acp.proveedor = dcp.proveedor
  AND acp.fecha <= ''' + @sqlFecha + ''') END ) 
  else 
  (SELECT ISNULL(SUM( acp.monto_prov),0) 
  FROM $$COMPANIA$$.auxiliar_cp acp WHERE acp.tipo_debito = dcp.TIPO
  and acp.debito = dcp.DOCUMENTO
  and acp.proveedor = dcp.proveedor
  AND acp.fecha <= ''' + @sqlFecha + ''') end) AS SALDO,
  (CASE WHEN dcp.NUM_PARCIALIDADES > 0 THEN (
  CASE WHEN cop.tipo_condpago = ''PA'' THEN (dcp.monto_local * ( par.porcentaje / 100 )) 
  ELSE (par.monto_cuota_loc) END)
  ELSE dcp.monto_local END) - 
  (CASE WHEN dcp.TIPO in ('+ @sqlCreditos +') then
  ( CASE WHEN dcp.NUM_PARCIALIDADES > 0 THEN (
  CASE WHEN cop.tipo_condpago = ''PA'' THEN ( SELECT ISNULL (SUM( apa.monto_local ),0 )
  FROM $$COMPANIA$$.auxiliar_parc_cp apa WHERE apa.tipo_credito = dcp.tipo
  AND apa.credito = dcp.documento AND apa.parcialidad = par.PARCIALIDAD
  AND apa.fecha <= ''' + @sqlFecha + ''' )
  ELSE ( SELECT ISNULL ( SUM( apa.monto_amortiza_loc + apa.monto_interes_loc ),0) 
  FROM $$COMPANIA$$.auxiliar_parc_cp apa WHERE apa.tipo_credito = dcp.tipo
  AND apa.credito = dcp.documento AND apa.parcialidad = par.PARCIALIDAD
  AND apa.fecha <= ''' + @sqlFecha + ''' ) END)
  ELSE (SELECT ISNULL(SUM( acp.monto_local),0) 
  FROM $$COMPANIA$$.auxiliar_cp acp WHERE acp.tipo_credito = dcp.TIPO
  and acp.credito = dcp.DOCUMENTO
  and acp.proveedor = dcp.proveedor
  AND acp.fecha <= ''' + @sqlFecha + ''') END ) 
  else 
  (SELECT ISNULL(SUM( acp.monto_local),0) 
  FROM $$COMPANIA$$.auxiliar_cp acp WHERE acp.tipo_debito = dcp.TIPO
  and acp.debito = dcp.DOCUMENTO
  and acp.proveedor = dcp.proveedor
  AND acp.fecha <= ''' + @sqlFecha + ''') end) -
  (SELECT ISNULL(SUM( hdc.dif_cam_local),0)
  FROM $$COMPANIA$$.hist_difcam_cp hdc
  WHERE hdc.documento = dcp.DOCUMENTO
  AND hdc.tipo = dcp.TIPO 
  AND hdc.PROVEEDOR = dcp.PROVEEDOR
  AND hdc.asiento_proc IS NOT Null
  AND hdc.estado <> ''R''
  AND hdc.fecha_proc > ''' + @sqlFecha + ''') AS SALDO_LOCAL, 
  (CASE WHEN dcp.NUM_PARCIALIDADES > 0 THEN (
  CASE WHEN cop.tipo_condpago = ''PA'' THEN (dcp.monto_dolar * ( par.porcentaje / 100 )) 
  ELSE (par.monto_cuota_dol) END)
  ELSE dcp.monto_dolar END) - 
  (CASE WHEN dcp.TIPO in ('+ @sqlCreditos +') then
  ( CASE WHEN dcp.NUM_PARCIALIDADES > 0 THEN (
  CASE WHEN cop.tipo_condpago = ''PA'' THEN ( SELECT ISNULL (SUM( apa.monto_dolar ),0 )
  FROM $$COMPANIA$$.auxiliar_parc_cp apa WHERE apa.tipo_credito = dcp.tipo
  AND apa.credito = dcp.documento AND apa.parcialidad = par.PARCIALIDAD
  AND apa.fecha <= ''' + @sqlFecha + ''' )
  ELSE ( SELECT ISNULL ( SUM( apa.monto_amortiza_dol + apa.monto_interes_dol ),0) 
  FROM $$COMPANIA$$.auxiliar_parc_cp apa WHERE apa.tipo_credito = dcp.tipo
  AND apa.credito = dcp.documento AND apa.parcialidad = par.PARCIALIDAD
  AND apa.fecha <= ''' + @sqlFecha + ''' ) END)
  ELSE (SELECT ISNULL(SUM( acp.monto_dolar),0) 
  FROM $$COMPANIA$$.auxiliar_cp acp WHERE acp.tipo_credito = dcp.TIPO
  and acp.credito = dcp.DOCUMENTO
  and acp.proveedor = dcp.proveedor
  AND acp.fecha <= ''' + @sqlFecha + ''') END ) 
  else 
  (SELECT ISNULL(SUM( acp.MONTO_DOLAR),0) 
  FROM $$COMPANIA$$.auxiliar_cp acp WHERE acp.tipo_debito = dcp.TIPO
  and acp.debito = dcp.DOCUMENTO
  and acp.proveedor = dcp.proveedor
  AND acp.fecha <= ''' + @sqlFecha + ''') end) -
  (SELECT ISNULL(SUM( hdc.dif_cam_dolar),0)
  FROM $$COMPANIA$$.hist_difcam_cp hdc
  WHERE hdc.documento = dcp.DOCUMENTO
  AND hdc.tipo = dcp.TIPO
  AND hdc.PROVEEDOR = dcp.PROVEEDOR
  AND hdc.asiento_proc IS NOT Null
  AND hdc.estado <> ''R''
  AND hdc.fecha_proc > ''' + @sqlFecha + ''')AS SALDO_DOLAR'
  end
  
  
  /*EFR planes de pago en cp */
  set @sql ='DELETE FROM $$COMPANIA$$.' + @tabla_rep + ' 
  WHERE REPORTE = ''' + @Reporte + '''' 
  
  execute sp_executesql @sql
  
  begin
  set @sql =' INSERT INTO $$COMPANIA$$.' + @tabla_rep + ' (REPORTE,PROVEEDOR,DOCUMENTO,TIPO,MONEDA,FECHA,FECHA_DOCUMENTO,FECHA_VENCE,TIPO_CAMB_ACT_LOC,TIPO_CAMB_ACT_DOL,TIPO_CAMB_ACT_PROV,
  CONTRARECIBO,ASIENTO,CONDICION_PAGO,DESCUENTO,SUBTOTAL,MONTO_RETENCION,SALDO_RETENCION,IMPUESTO1,IMPUESTO2,RUBRO1,RUBRO2,
  APLICACION,DESC_SUBTIPO,DIAS_NETO,TIPO_CONDPAGO,NUM_PARCIALIDADES,PARCIALIDAD,PAR_MONTO_PRINCIPAL,PAR_MONTO_AMORTIZA,
  PAR_SALDO_AMORTIZA,PAR_MONTO_INTERES,PAR_SALDO_INTERES,PAR_MONTO_CUOTA,PAR_SALDO_CUOTA,PAR_SALDO_PRINCIPAL,MONTO_DOC,
  MONTO_PROV,MONTO_LOCAL,MONTO_DOLAR,SALDO_PROV,SALDO_LOCAL,SALDO_DOLAR,SALDO_RANGO0,SALDO_RANGO1,SALDO_RANGO2,SALDO_RANGO3,
  SALDO_RANGO4,SALDO_RANGO5)
  SELECT ''' + @Reporte + ''' ,
  proveedor,documento, tipo, moneda, fecha, fecha_documento, fecha_vence, 
  tipo_camb_act_loc, tipo_camb_act_dol, tipo_camb_act_prov,
  contrarecibo, asiento, condicion_pago, 
  descuento, subtotal, monto_retencion, saldo_retencion, impuesto1, impuesto2,
  rubro1, rubro2, aplicacion, descripcion, dias_neto,
  tipo_condpago, num_parcialidades, parcialidad,
  par_monto_principal, par_monto_amortiza, par_saldo_amortiza, par_monto_interes, 
  par_saldo_interes, par_monto_cuota, par_saldo_cuota, par_saldo_principal,
  ISNULL(' + @sqlSum + '(case when TIPO in (' + @sqlCreditos + ') then monto else -1 * monto end ),0)as MONTO_DOC, 
  ISNULL(' + @sqlSum + '(case when TIPO in (' + @sqlCreditos + ') then MONTO_PROV else -1 * MONTO_PROV end ),0)as MONTO_PROV, 
  ISNULL(' + @sqlSum + '(case when TIPO in (' + @sqlCreditos + ') then MONTO_LOCAL else -1 * MONTO_LOCAL end ),0)as MONTO_LOCAL, 
  ISNULL(' + @sqlSum + '(case when TIPO in (' + @sqlCreditos + ') then MONTO_DOLAR else -1 * MONTO_DOLAR end ),0)as MONTO_DOLAR ,
 		 ISNULL(' + @sqlSum + '((case when SALDO < 0 then 0 else (case when TIPO in (' + @sqlCreditos + ') then SALDO
 			else -1 * SALDO end )end)),0)as SALDO_PROV,
 		 ISNULL(' + @sqlSum + '((case when SALDO_LOCAL < 0 then 0 else (case when TIPO in (' + @sqlCreditos + ') then SALDO_LOCAL 
 			else -1 * SALDO_LOCAL end )end )),0)as SALDO_LOCAL, 
 		 ISNULL(' + @sqlSum + '((case when SALDO_DOLAR < 0 then 0 else (case when TIPO in (' + @sqlCreditos + ') then SALDO_DOLAR 
 			else -1 * SALDO_DOLAR end ) end)),0) as SALDO_DOLAR
  ' + @psRangos + ' 
  FROM (
  SELECT dcp.proveedor, dcp.documento, dcp.tipo, dcp.moneda,'+ @sqlFechasDoc +' 
  dcp.tipo_camb_act_loc, dcp.tipo_camb_act_dol, dcp.tipo_camb_act_prov,
  dcp.contrarecibo, dcp.asiento, dcp.condicion_pago, 
  dcp.descuento, dcp.subtotal, dcp.monto_retencion, dcp.saldo_retencion, dcp.impuesto1, dcp.impuesto2,
  dcp.rubro1, dcp.rubro2, dcp.aplicacion, sdc.descripcion, cop.dias_neto,cop.tipo_condpago, dcp.num_parcialidades,
  '+ @psMontosParc +',
  '+ @sqlMontosDoc +'
  '+ @sqlSaldos +'
  ' + @psCaseRangos + '
  FROM '+ @sTablas +'
  WHERE dcp.subtipo = sdc.subtipo
  AND dcp.tipo = sdc.tipo 
  AND dcp.condicion_pago = cop.condicion_pago
  AND dcp.proveedor = pro.proveedor
  AND ' + @sFechaDoc + '
  ' + @sqlWhrSalFec + ' ' + @psFiltro + ' and '+ @sqlWhrPro +'
  )MontosProv group by proveedor, documento, tipo, moneda, fecha, fecha_documento, fecha_vence, 
  tipo_camb_act_loc,tipo_camb_act_dol,contrarecibo, asiento, condicion_pago,
  descuento, subtotal, monto_retencion, saldo_retencion, impuesto1, impuesto2, rubro1, rubro2,
  aplicacion, dias_neto, tipo_condpago, num_parcialidades, parcialidad,tipo_camb_act_prov,
  par_monto_principal, par_monto_amortiza, par_saldo_amortiza, par_monto_interes, descripcion,
  par_saldo_interes, par_monto_cuota, par_saldo_cuota, par_saldo_principal, monto, MONTO_PROV, 
  monto_local, monto_dolar, SALDO, saldo_local, saldo_dolar, Rango_dias'
  execute sp_executesql @sql
 END END;
 
 

CREATE FUNCTION $$COMPANIA$$.OBTENERMONTORETENCIONCP
  (@PCREDITO VARCHAR(50), @PPROVEEDOR VARCHAR(50))
  RETURNS DECIMAL(28,8)
  AS
  BEGIN
   DECLARE @MONTO DECIMAL(28,8)
  
SELECT @MONTO = SUM ( DRET.MONTO )
FROM $$COMPANIA$$.DETALLE_RETENCION DRET INNER JOIN
$$COMPANIA$$.TRASLADO_IVA_RETENCIONES TRET ON DRET.CODIGO_RETENCION = TRET.CODIGO_RETENCION INNER JOIN
$$COMPANIA$$.AUXILIAR_CP AUX ON DRET.RETENCION = AUX.DEBITO INNER JOIN
$$COMPANIA$$.DOCUMENTOS_CP DCP ON AUX.CREDITO = DCP.DOCUMENTO AND AUX.TIPO_CREDITO = DCP.TIPO AND AUX.PROVEEDOR = DCP.PROVEEDOR
WHERE AUX.CREDITO = @PCREDITO AND 
AUX.PROVEEDOR = @PPROVEEDOR AND 
AUX.TIPO_DEBITO = 'RET' 
AND TRET.RET_DIFERENCIA_ACREDITABLE = 'S'
  
  RETURN ISNULL(@MONTO,0)
  
  END;
			   
CREATE FUNCTION $$COMPANIA$$.CPGetSaldoDocDolar_BI 
(
  @Proveedor varchar(20),
  @Documento varchar(50),
  @FechaInicial datetime
)
RETURNS DECIMAL(28,8)
AS
BEGIN
DECLARE 
  @TotalAuxCP as decimal(28,8),
  @TotalDocCP as decimal(28,8),
  @TotalDocs as decimal(28,8)
  
	select 
		@TotalDocCP = isnull( SUM(MONTO_DOLAR), 0) 
	from 
		$$COMPANIA$$.AUXILIAR_CP 
	where 
		CREDITO = @Documento 
		AND PROVEEDOR =@Proveedor 
		AND FECHA <= @FechaInicial
   
	select 
		@TotalAuxCP = isnull(MONTO_DOLAR, 0) 
	from 
		$$COMPANIA$$.DOCUMENTOS_CP 
	where 
			DOCUMENTO = @Documento 
			and PROVEEDOR= @Proveedor 
			AND FECHA <= @FechaInicial
			AND TIPO not in ('CHQ','TEF','RET','N/C','O/C')
			AND APROBADO = 'S'	
   
   set @TotalDocs = @TotalAuxCP -@TotalDocCP   

  RETURN ISNULL(@TotalDocs,0)
END;


CREATE FUNCTION $$COMPANIA$$.CPGetSaldoDocLocal_BI
(
  @Proveedor varchar(20),
  @Documento varchar(50),
  @FechaInicial datetime
)
RETURNS DECIMAL(28,8)
AS
BEGIN
DECLARE 
  @TotalAuxCP as decimal(28,8),
  @TotalDocCP as decimal(28,8),
  @TotalDocs as decimal(28,8)
  
	select 
		@TotalDocCP = isnull( SUM(MONTO_LOCAL), 0) 
	from 
		$$COMPANIA$$.AUXILIAR_CP 
	where 
		CREDITO = @Documento 
		AND PROVEEDOR =@Proveedor 
		AND FECHA <= @FechaInicial
   
	select 
		@TotalAuxCP = isnull(MONTO_LOCAL, 0) 
	from 
		$$COMPANIA$$.DOCUMENTOS_CP 
	where 
		DOCUMENTO = @Documento 
		and PROVEEDOR= @Proveedor 
		AND FECHA <= @FechaInicial
		AND TIPO not in ('CHQ','TEF','RET','N/C','O/C')
		AND APROBADO = 'S'
   
   set @TotalDocs = @TotalAuxCP -@TotalDocCP 

  RETURN ISNULL(@TotalDocs,0)
  
END;



CREATE TRIGGER $$COMPANIA$$.FE_DOCUMENTOS_CP 
   ON  $$COMPANIA$$.DOCUMENTOS_CP 
   AFTER INSERT
AS 
BEGIN		
	SET NOCOUNT ON
	
	DECLARE 
	
	@DOC_ELECTRONICO VARCHAR(1)
	
	IF ((SELECT TIPO FROM $$COMPANIA$$.GLOBALES WHERE NOMBRE='EDI_USAR_DE')='S') 
	BEGIN
		 SET @DOC_ELECTRONICO=(SELECT ACEPTA_DOC_ELECTRONICO FROM $$COMPANIA$$.PROVEEDOR
		WHERE PROVEEDOR=(SELECT PROVEEDOR FROM inserted))
	
		IF @DOC_ELECTRONICO='S' 
			BEGIN
				UPDATE $$COMPANIA$$.DOCUMENTOS_CP SET GENERA_DOC_FE='S'
				WHERE DOCUMENTO=(SELECT DOCUMENTO FROM inserted)
			END 	
	END		  	
END;




