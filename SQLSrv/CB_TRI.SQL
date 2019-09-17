
create trigger $$COMPANIA$$.tD_MOV_REPORTADOS on $$COMPANIA$$.MOV_REPORTADOS for DELETE as
/* ERwin Builtin Tue Mar 21 11:09:30 2000 */
/* DELETE trigger on MOV_REPORTADOS */
begin
  declare  @errno   int,
           @errmsg  VARCHAR(255)
    /* Tabla:MOV_REPORTADOS */
    /* ERwin Builtin Tue Mar 21 11:09:30 2000 */
    /* MOV_REPORTADOS DOCREP_DOCCOMPENSA MOV_REPORTADOS ON PARENT DELETE CASCADE */
    delete MOV_REPORTADOS
      from $$COMPANIA$$.MOV_REPORTADOS,deleted
      where
        /*  %JoinFKPK(MOV_REPORTADOS,deleted," = "," and") */
        $$COMPANIA$$.MOV_REPORTADOS.DOC_COMPENSAC = deleted.DOC_REPORTADO

    /* ERwin Builtin Tue Mar 21 11:09:30 2000 */
    return
error:
    raiserror (@errno, @errmsg, 0)
    rollback transaction
end;


REMARK 
\
------------------------------------------------------------------ 
-- Función que convierte un monto a positivo o negativo dependiendo del tipo de documento de CB
------------------------------------------------------------------
/
CREATE FUNCTION $$COMPANIA$$.SoftlandBI_FN_MontoAfectaCB(@TipoDocumento VARCHAR(3), @Monto DECIMAL(28,8))
RETURNS DECIMAL(28,8) AS
BEGIN
	DECLARE @NuevoMonto DECIMAL(28,8)

	IF (@TipoDocumento = 'DEP' OR @TipoDocumento = 'O/C' OR @TipoDocumento = 'N/C' OR @TipoDocumento = 'T/C') BEGIN SET @NuevoMonto = @Monto END
	ELSE BEGIN SET @NuevoMonto = -@Monto END

	RETURN ISNULL(@NuevoMonto,0)
END
;

REMARK 
\
------------------------------------------------------------------ 
-- Función que obtiene el texto del estado del documento de CB en MOV_BANCOS
------------------------------------------------------------------
/
CREATE FUNCTION $$COMPANIA$$.SoftlandBI_FN_EstadoDocCB(@Estado VARCHAR(1))
RETURNS VARCHAR(20) AS
BEGIN
	DECLARE @Descripcion VARCHAR(20)

	SET @Descripcion = 
		CASE  @Estado
			WHEN 'A' THEN 'Anulado'
			WHEN 'D' THEN 'Proceso Anulación'
			WHEN 'F' THEN 'Conciliado en Firme'
			WHEN 'N' THEN 'No Conciliado'
			WHEN 'P' THEN 'Pendiente de Entrega'
			WHEN 'T' THEN 'Conciliado Temporal'
			ELSE 'No Definido' 
		END
	RETURN @Descripcion
END
;

REMARK 
\
------------------------------------------------------------------ 
-- Vista de Documentos por Cuenta para Softland Análisis
------------------------------------------------------------------
/
CREATE VIEW $$COMPANIA$$.SoftlandBI_CB_MovimientoCuenta
AS
	SELECT	CUENTA.cuenta_banco AS CuentaBancaria
		, CUENTA.nombre AS NombreCuentaBancaria
		, CUENTA.moneda AS MonedaCuenta
		, CASE CUENTA.activa WHEN 'S' THEN 'Sí' ELSE 'No' END AS CuentaActiva
		, CUENTA.entidad_financiera AS EntidadFinanciera
		, ENTIDAD.descripcion AS DescripcionEntidadFinanciera
		, MOVIMIENTO.tipo_documento AS TipoDocumento
		, SUBTIPO.descripcion AS SubtipoDocumento
		, MOVIMIENTO.numero AS NumeroDocumento
		, CASE MOVIMIENTO.anulado WHEN 'S' THEN 'Sí' ELSE 'No' END AS DocumentoAnulado
		, CASE MOVIMIENTO.aprobado WHEN 'S' THEN 'Sí' ELSE 'No' END AS DocumentoAprobado
		, MOVIMIENTO.origen AS ModuloOrigen
		, MOVIMIENTO.monto AS Monto
		, $$COMPANIA$$.SoftlandBI_FN_MontoAfectaCB(MOVIMIENTO.tipo_documento, MOVIMIENTO.monto) AS MontoAfecta
		, MOVIMIENTO.fecha AS Fecha
		, YEAR(MOVIMIENTO.fecha) AS AnoFecha
		, DATEPART(QUARTER,MOVIMIENTO.fecha) AS TrimestreFecha
		, MONTH(MOVIMIENTO.fecha) AS MesFecha
		, DATEPART(WEEK,MOVIMIENTO.fecha) AS SemanaFecha
		, MOVIMIENTO.proveedor AS Proveedor
		, PROVEEDOR.nombre AS NombreProveedor
		, ISNULL(MOVIMIENTO.pagadero_a, 'No Indicado') AS PagaderoA
		, MOVIMIENTO.conciliacion AS NumeroConciliacion
		, $$COMPANIA$$.SoftlandBI_FN_EstadoDocCB(MOVIMIENTO.estado) AS EstadoDocumento
	FROM	mov_bancos MOVIMIENTO (NOLOCK)
		INNER JOIN $$COMPANIA$$.subtipo_doc_cb SUBTIPO (NOLOCK)
			ON MOVIMIENTO.tipo_documento = SUBTIPO.tipo
			   AND MOVIMIENTO.subtipo = SUBTIPO.subtipo
		INNER JOIN $$COMPANIA$$.cuenta_bancaria CUENTA (NOLOCK)
			ON MOVIMIENTO.cuenta_banco = CUENTA.cuenta_banco
		INNER JOIN $$COMPANIA$$.entidad_financiera ENTIDAD (NOLOCK)
			ON CUENTA.entidad_financiera = ENTIDAD.entidad_financiera
		LEFT JOIN $$COMPANIA$$.proveedor PROVEEDOR (NOLOCK)
			ON MOVIMIENTO.proveedor = PROVEEDOR.proveedor
;

REMARK 
\
------------------------------------------------------------------ 
-- Vista de Saldos por Cuenta de Banco para Softland Análisis
------------------------------------------------------------------
/
CREATE VIEW $$COMPANIA$$.SoftlandBI_CB_SaldosPorCuenta
AS
	SELECT	CUENTA.cuenta_banco AS CuentaBancaria
		, CUENTA.nombre AS NombreCuentaBancaria
		, CUENTA.moneda AS MonedaCuenta
		, CASE CUENTA.activa WHEN 'S' THEN 'Sí' ELSE 'No' END AS CuentaActiva
		, CUENTA.entidad_financiera AS EntidadFinanciera
		, ENTIDAD.descripcion AS DescripcionEntidadFinanciera
		, CASE CUENTA.permite_sobregiro WHEN 'S' THEN 'Sí' ELSE 'No' END AS PermiteSobregiro
		, CUENTA.limite_sobregiro AS LimiteSobregiro
		, CUENTA.ctr_contable AS CentroCosto
		, CUENTA.cta_contable AS CuentaContable
		, CUENTA.posicion_de_caja AS PosicionDeCaja
		, CUENTA.saldo_bancos AS SaldoEnBancos
		, CUENTA.saldo AS SaldoEnLibros
	FROM	cuenta_bancaria CUENTA (NOLOCK)
		INNER JOIN $$COMPANIA$$.entidad_financiera ENTIDAD (NOLOCK)
			ON CUENTA.entidad_financiera = ENTIDAD.entidad_financiera
;



CREATE NONCLUSTERED INDEX IEMOVBANCOSCTAFECDOCSUTI ON MOV_BANCOS
(
	CUENTA_BANCO 	ASC,
	FECHA 		ASC,
	TIPO_DOCUMENTO 	ASC,
	SUBTIPO 	ASC,
	RowPointer 	ASC
)
go