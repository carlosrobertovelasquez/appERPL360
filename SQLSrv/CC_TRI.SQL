create trigger $$COMPANIA$$.tD_DOCUMENTOS_CC on $$COMPANIA$$.DOCUMENTOS_CC for DELETE as
/* ERwin Builtin Tue Mar 21 11:09:47 2000 */
/* DELETE trigger on DOCUMENTOS_CC */
begin
  declare  @errno   int,
           @errmsg  VARCHAR(255)
   
    /* Tabla:AUXILIAR_CC */
    /* ERwin Builtin Tue Mar 21 11:09:47 2000 */
    /* DOCUMENTOS_CC AUXCCCRD AUXILIAR_CC ON PARENT DELETE CASCADE */
    delete AUXILIAR_CC
      from $$COMPANIA$$.AUXILIAR_CC,deleted
      where
        /*  %JoinFKPK(AUXILIAR_CC,deleted," = "," and") */
        $$COMPANIA$$.AUXILIAR_CC.CREDITO = deleted.DOCUMENTO and
        $$COMPANIA$$.AUXILIAR_CC.TIPO_CREDITO = deleted.TIPO
   
    /* ERwin Builtin Tue Mar 21 11:09:47 2000 */
    return
error:
    raiserror (@errno, @errmsg, 0)
    rollback transaction
end;


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



CREATE TRIGGER $$COMPANIA$$.FE_DOCUMENTOS_CC 
    ON  $$COMPANIA$$.DOCUMENTOS_CC 
    AFTER INSERT
 AS 
 BEGIN  
  SET NOCOUNT ON
  
  DECLARE 
  
  @DOC_ELECTRONICO VARCHAR(1)
  
  IF ((SELECT TIPO FROM $$COMPANIA$$.GLOBALES WHERE NOMBRE='EDI_USAR_DE')='S') 
  BEGIN
    SET @DOC_ELECTRONICO=(SELECT ACEPTA_DOC_ELECTRONICO FROM $$COMPANIA$$.CLIENTE
   WHERE CLIENTE=(SELECT CLIENTE FROM inserted))
  
   IF @DOC_ELECTRONICO='S' 
    BEGIN
     UPDATE $$COMPANIA$$.DOCUMENTOS_CC SET GENERA_DOC_FE='S'
     WHERE DOCUMENTO=(SELECT DOCUMENTO FROM inserted) and
	TIPO =(SELECT TIPO FROM inserted)
    END  
  END     
 END;



REMARK 
\
------------------------------------------------------------------ 
SE CREA LA FUNCION PARA ObtenerDeudaCliente
------------------------------------------------------------------
/


CREATE FUNCTION $$COMPANIA$$.ObtenerDeudaCliente(@pMesesAplicar int)
RETURNS @TempDeudaCliente TABLE(
	IdDia int NOT NULL,
	Cliente varchar(40) NOT NULL,
	DiasVencidos varchar(10) NOT NULL,
	Moneda varchar(14) NOT NULL,
	ConceptoVenta varchar(10) NOT NULL,
	Cobrador varchar(20) NOT NULL,
	CentroCosto varchar(25) NOT NULL,
	DeudaCargadaLocal decimal(28,8) null,
	DeudaCargadaDolar decimal(28,8) null,
	AbonoRealizadoLocal decimal(28,8) null,
	AbonoRealizadoDolar decimal(28,8) null,
	SaldoLocal decimal(28,8) null,
	SaldoDolar decimal(28,8) null)
AS
BEGIN

	Declare @Fecha datetime, @FechaFinal datetime
	
	if @pMesesAplicar = 0 
		set @Fecha = '01-jan-2010'
	else
		SET @Fecha = DATEADD(MONTH, -@pMesesAplicar, ERPADMIN.SF_GETDATE())
	
	Set @FechaFinal = ERPADMIN.SF_GETDATE()

	SELECT @Fecha = MIN(FECHA_DOCUMENTO) from $$COMPANIA$$.DOCUMENTOS_CC where FECHA_DOCUMENTO >= @Fecha

	while @Fecha <= @FechaFinal begin

		insert into @TempDeudaCliente
		(IdDia, Cliente, DiasVencidos, Moneda, ConceptoVenta, Cobrador, CentroCosto, 
		DeudaCargadaLocal, DeudaCargadaDolar, AbonoRealizadoLocal, AbonoRealizadoDolar, SaldoLocal, SaldoDolar)
		SELECT	IdDia,
				Cliente,
				DiferenciaDias,
				Moneda,
				ConceptoVenta,
				Cobrador,
				CentroCosto,
				sum(DeudaCargadaLocal),
				sum(DeudaCargadaDolar),
				sum(AbonoRealizadoLocal),
				sum(AbonoRealizadoDolar),
				sum(SaldoLocal),
				sum(SaldoDolar)
		FROM (
		select	CAST(LTRIM(STR(YEAR(@Fecha)))+ RIGHT(REPLACE(STR(Month(@Fecha)),' ','0'),2)+ RIGHT(REPLACE(STR(Day(@Fecha)),' ','0'),2) AS INT) IdDia,
				dcc.CLIENTE Cliente,  
				DATEDIFF(DAY, @Fecha, dcc.FECHA_VENCE) DiferenciaDias,
				dcc.MONEDA Moneda,
				dcc.TIPO + '-' + CAST(dcc.SUBTIPO AS VARCHAR) ConceptoVenta,
				isnull(dcc.Cobrador, c.cobrador) Cobrador,
				case when cc.CTR_CXC is null then erpadmin.GETVALORHASTANIVELSINCARACTER(p.CTR_CXC,1) else erpadmin.GETVALORHASTANIVELSINCARACTER(cc.CTR_CXC,1) end CentroCosto,
				sum(case
					when @Fecha = dcc.fecha then isnull(dcc.MONTO_LOCAL,0)
					else 0
				end) DeudaCargadaLocal,
				sum(case
					when @Fecha = dcc.fecha then isnull(dcc.MONTO_DOLAR,0)
					else 0
				end)	DeudaCargadaDolar,
				sum(case
					when @Fecha = dcc.fecha then isnull(aux.MontoAplicadoLocal,0)
					else 0
				end) AbonoRealizadoLocal,
				sum(case
					when @Fecha = dcc.fecha then isnull(aux.MontoAplicadoDolar,0)
					else 0
				end)	AbonoRealizadoDolar,
				sum(dcc.MONTO_LOCAL - isnull(aux.MontoAplicadoLocal,0)) SaldoLocal, 
				sum(dcc.MONTO_DOLAR - isnull(aux.MontoAplicadoDolar,0)) SaldoDolar
		from $$COMPANIA$$.DOCUMENTOS_CC dcc left join 
						(select	auxcc.DEBITO Documento, auxcc.TIPO_DEBITO Tipo, auxcc.CLI_DOC_DEBITO Cliente, Max(auxcc.FECHA) FechaAplicacion,				
							sum(isnull(auxcc.MONTO_LOCAL, 0)) MontoAplicadoLocal, sum(isnull(auxcc.MONTO_DOLAR, 0)) MontoAplicadoDolar
					from $$COMPANIA$$.DOCUMENTOS_CC dcc 
							left join $$COMPANIA$$.AUXILIAR_CC auxcc
								on dcc.DOCUMENTO = auxcc.DEBITO
								and dcc.TIPO = auxcc.TIPO_DEBITO
								and dcc.CLIENTE = auxcc.CLI_DOC_DEBITO
					where dcc.TIPO in ('FAC', 'N/D',  'INT', 'I/C', 'O/D', 'L/C', 'B/V', 'RHP')
					and auxcc.FECHA <= @Fecha
					group by auxcc.DEBITO, auxcc.TIPO_DEBITO, auxcc.CLI_DOC_DEBITO) aux
					on dcc.DOCUMENTO = aux.Documento and dcc.TIPO = aux.Tipo and dcc.CLIENTE = aux.Cliente
				inner join $$COMPANIA$$.CLIENTE c on dcc.CLIENTE = c.CLIENTE
			inner join $$COMPANIA$$.CATEGORIA_CLIENTE cc on c.CATEGORIA_CLIENTE = cc.CATEGORIA_CLIENTE
			 inner join $$COMPANIA$$.PAIS p on c.PAIS = p.PAIS
		where dcc.TIPO in ('FAC', 'N/D',  'INT', 'I/C', 'O/D', 'L/C', 'B/V', 'RHP')
		and 0 <> (select COUNT(0) from $$COMPANIA$$.AUXILIAR_CC auxcc where dcc.DOCUMENTO = auxcc.DEBITO and dcc.TIPO = auxcc.TIPO_DEBITO and dcc.CLIENTE = auxcc.CLI_DOC_DEBITO)
		and dcc.FECHA <= @Fecha
		group by	dcc.CLIENTE, 
					DATEDIFF(DAY, @Fecha, dcc.FECHA_VENCE),
					dcc.MONEDA, ISNULL(dcc.Cobrador, c.cobrador), dcc.TIPO + '-' + CAST(dcc.SUBTIPO AS VARCHAR),
					case when cc.CTR_CXC is null then erpadmin.GETVALORHASTANIVELSINCARACTER(p.CTR_CXC,1) else erpadmin.GETVALORHASTANIVELSINCARACTER(cc.CTR_CXC,1) end
		union
		select	CAST(LTRIM(STR(YEAR(@Fecha)))+ RIGHT(REPLACE(STR(Month(@Fecha)),' ','0'),2)+ RIGHT(REPLACE(STR(Day(@Fecha)),' ','0'),2) AS INT) IdDia,				
				dcc.CLIENTE Cliente,  
				DATEDIFF(DAY, @Fecha, dcc.FECHA_VENCE) DiferenciaDias,
				dcc.MONEDA Moneda,
				dcc.TIPO + '-' + CAST(dcc.SUBTIPO AS VARCHAR) ConceptoVenta,
				isnull(dcc.Cobrador, c.cobrador) Cobrador,
				case when cc.CTR_CXC is null then erpadmin.GETVALORHASTANIVELSINCARACTER(p.CTR_CXC,1) else erpadmin.GETVALORHASTANIVELSINCARACTER(cc.CTR_CXC,1) end CentroCosto,
				case
					when @Fecha = dcc.fecha then isnull(dcc.MONTO_LOCAL,0)
					else 0
				end DeudaCargadaLocal,
				case
					when @Fecha = dcc.fecha then isnull(dcc.MONTO_DOLAR,0)
					else 0
				end	DeudaCargadaDolar,
				0 AbonoRealizadoLocal,
				0 AbonoRealizadoDolar,
				dcc.MONTO_LOCAL SaldoLocal, 
				dcc.MONTO_DOLAR SaldoDolar
		from $$COMPANIA$$.DOCUMENTOS_CC dcc inner join $$COMPANIA$$.CLIENTE c on dcc.CLIENTE = c.CLIENTE
			inner join $$COMPANIA$$.CATEGORIA_CLIENTE cc on c.CATEGORIA_CLIENTE = cc.CATEGORIA_CLIENTE
			 inner join $$COMPANIA$$.PAIS p on c.PAIS = p.PAIS
		where dcc.TIPO in ('FAC', 'N/D',  'INT', 'I/C', 'O/D', 'L/C', 'B/V', 'RHP')
		and 0 = (select COUNT(0) from $$COMPANIA$$.AUXILIAR_CC auxcc where dcc.DOCUMENTO = auxcc.DEBITO and dcc.TIPO = auxcc.TIPO_DEBITO and dcc.CLIENTE = auxcc.CLI_DOC_DEBITO)
		and dcc.FECHA <= @Fecha) deudaCliente
		where	deudaCliente.DeudaCargadaLocal <> 0 or deudaCliente.DeudaCargadaDolar <> 0or
				deudaCliente.AbonoRealizadoLocal <> 0 or deudaCliente.AbonoRealizadoDolar <> 0 or
				deudaCliente.SaldoLocal <> 0 or deudaCliente.SaldoDolar <> 0
		group by IdDia,
				Cliente,
				DiferenciaDias,
				Moneda,
				ConceptoVenta,
				Cobrador,
				CentroCosto

		set @Fecha = DATEADD(day, 1, @fecha)
	end
RETURN
END;




REMARK 
\
------------------------------------------------------------------ 
-- Función que calcula el texto de Rango de Días entre dos fechas para documentos de CC y CP
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
END
;

REMARK 
\
------------------------------------------------------------------ 
-- Función que convierte un monto a positivo o negativo dependiendo del tipo de documento de CC
------------------------------------------------------------------
/
CREATE FUNCTION $$COMPANIA$$.SoftlandBI_FN_MontoAfectaCC(@TipoDocumento VARCHAR(3), @Monto DECIMAL(28,8))
RETURNS DECIMAL(28,8) AS
BEGIN
	DECLARE @NuevoMonto DECIMAL(28,8)

	IF (@TipoDocumento = 'FAC' OR @TipoDocumento = 'O/D' OR @TipoDocumento = 'N/D' OR @TipoDocumento = 'L/C' OR @TipoDocumento = 'INT' OR @TipoDocumento = 'B/V' OR @TipoDocumento = 'I/C' OR @TipoDocumento = 'RED') BEGIN SET @NuevoMonto = @Monto END
	ELSE BEGIN SET @NuevoMonto = -@Monto END
	
	RETURN ISNULL(@NuevoMonto,0)
END
;



CREATE FUNCTION $$COMPANIA$$.OBTENERSALDODOCUMENTOCC
 (@PESDEBITO VARCHAR(1), @PCLIENTE VARCHAR(50), @PTIPO VARCHAR(5), @PDOCUMENTO VARCHAR(100), 
  @PFECHAINICIAL DATETIME, @PFECHAFINAL DATETIME)
 RETURNS DECIMAL(28,8)
 AS
 BEGIN
  DECLARE @MONTO DECIMAL(28,8)
 
 IF @PESDEBITO = 'S'
  SELECT @MONTO = SUM(  MONTO_DEBITO ) 
  FROM $$COMPANIA$$.AUXILIAR_CC
  WHERE CLI_REPORTE_DEBITO = @PCLIENTE
  AND TIPO_DEBITO = @PTIPO
  AND DEBITO = @PDOCUMENTO
  AND FECHA BETWEEN @PFECHAINICIAL AND @PFECHAFINAL
 ELSE
  SELECT @MONTO = SUM(  MONTO_CREDITO ) 
  FROM $$COMPANIA$$.AUXILIAR_CC
  WHERE CLI_REPORTE_CREDIT = @PCLIENTE
  AND TIPO_CREDITO = @PTIPO
  AND CREDITO = @PDOCUMENTO
  AND FECHA BETWEEN @PFECHAINICIAL AND @PFECHAFINAL
 
 RETURN ISNULL(@MONTO,1)
 
 END
 ;



CREATE FUNCTION $$COMPANIA$$.MONTO_PAGO_CC_SINRET(@PCLIENTE VARCHAR(50), @PTIPO VARCHAR(5), @PDOCUMENTO VARCHAR(100), 
  @PFECHAINICIAL DATETIME, @PFECHAFINAL DATETIME)
RETURNS DECIMAL(28,8)
 AS
 BEGIN
  DECLARE @MONTO DECIMAL(28,8)
  
SELECT @MONTO = SUM(MONTO_DEBITO)
FROM $$COMPANIA$$.DOCUMENTOS_CC DCC1 INNER JOIN
	 $$COMPANIA$$.AUXILIAR_CC AUX1 ON 
			DCC1.CLIENTE = AUX1.CLI_REPORTE_DEBITO AND DCC1.DOCUMENTO = AUX1.DEBITO AND DCC1.TIPO = AUX1.TIPO_DEBITO
WHERE AUX1.TIPO_DEBITO = @PTIPO AND AUX1.DEBITO = @PDOCUMENTO and AUX1.TIPO_CREDITO NOT IN( 'RET','N/C')
AND (AUX1.FECHA >= @PFECHAINICIAL 
AND  AUX1.FECHA <= @PFECHAFINAL)
AND AUX1.CLI_REPORTE_DEBITO = @PCLIENTE

RETURN ISNULL(@MONTO,0)
END
;



CREATE PROCEDURE $$COMPANIA$$.CCReportes
 (
  @Reporte as varchar(20), /*ANTIGUEDAD, VENCIMIENTO O PROYECCIÓN*/
  @TipoReporte as varchar(1),/*R=RESUMIDO(Normal, sin detalle o totalizado), D= DETALLADO O T= SOLO TOTALES*/
  @ExcluirDifCam as varchar(1),/*Indica si excluye o no documentos por diferencial cambiario*/
  @ClienteRegistro as varchar(1),/*Indica si es cliente registro o reporte, S=Registro, N = Reporte. Solo se ocupa si es Resumido, ya que detallado se hace por documento*/
  @ConParcialidades as varchar(1),/*S = USA PARCIALIDADES, N= SIN PARCIALIDADES*/
  @UsarFecha as varchar(1),/*Indica el tipo de fecha a usar para filtrar, si es R = rige o D = documento*/
  @dtFechaConHoraLim as datetime,
  @psFiltro as varchar(max),/*Filtro de documentos y más, se usa para llenar la tabla REPORTES_CC con lo que se necesita*/
  @psRangos as varchar(max),/*Sum de rangos*/
  @psCaseRangos as varchar(max),/*Case para obtener el rango en que se ubica el saldo del cliente según fechas de parcialidad*/
  @psMontosParc as varchar(max) /*Montos de parcialidades, si no usa parcialidades viene en ceros más el nombre de las columnas*/
 )
 as
  declare @sql as nvarchar(max)
  declare @tabla_rep as varchar(11)
  declare @sqlSum as varchar(3)
  declare @sqlCampoCliente as varchar(18) /* NBH >> Caso CR4-15422-9Q8Y*/
  declare @sqlWhrCli as varchar(250)
  declare @sqlWhrSalFec as nvarchar(200)
  declare @sqlSaldos as nvarchar(max)
  declare @sqlFecha as varchar(19)
  declare @sqlDebitos as varchar(60)
  declare @sTablas as varchar(250)
  declare @sFechaDoc as varchar(50)
  declare @sqlFechasDoc as varchar(500)
  declare @sqlMontosDoc as varchar(max)
 begin
  set @tabla_rep = 'REPORTES_CC'
  set @sqlSum = ' '
  set @sqlFecha = convert(varchar(19),@dtFechaConHoraLim,20)
  set @sqlDebitos = '''B/V'',''FAC'',''I/C'',''INT'',''L/C'',''N/D'',''O/D'',''RED'',''RHP'''
  set @sTablas = ' '
  set @sFechaDoc = ' '
    
  if(@ClienteRegistro = 'S')
   begin
   set @sqlWhrCli = 'AND cli.cliente = dc.cliente '
   set @sqlCampoCliente = 'dc.cliente' /* NBH >> Caso CR4-15422-9Q8Y*/
   end
  else
   begin
   set @sqlWhrCli = 'AND cli.cliente = dc.cliente_reporte '
   set @sqlCampoCliente = 'dc.cliente_reporte' /* NBH >> Caso CR4-15422-9Q8Y*/
   end 
  
     /*Esto se hace porque si es R significa que el reporte no es datallado, lo que implica que se sumariza por cliente, por lo que se hace de una vez acá en la sentencia ,*/
     /* sino, simplemente se deja el ' ' para que convierta los datos pero sin totalizarlos*/
   begin      
   set @sTablas = '$$COMPANIA$$.cliente cli, $$COMPANIA$$.condicion_pago cop, $$COMPANIA$$.subtipo_doc_cc sdc, $$COMPANIA$$.documentos_cc dc '
   set @sqlWhrCli = @sqlWhrCli + ' AND cop.condicion_pago = dc.condicion_pago
       AND dc.tipo = sdc.tipo
       AND dc.subtipo = sdc.subtipo '
   end
   
 
  if(@Reporte <> 'PROYECCION') 
   begin
   if(@UsarFecha = 'R')  
    set @sFechaDoc = 'dc.fecha <= ''' + @sqlFecha + ''' AND '
   else /* @UsarFecha = 'D'*/
    set @sFechaDoc = 'dc.fecha_documento <= ''' + @sqlFecha + ''' AND '
   end
   
  if(@ExcluirDifCam = 'S')
   set @sqlWhrSalFec = ' ( dc.fecha_ult_credito >= ''' + convert(varchar,@dtFechaConHoraLim,111) + ''' OR
        dc.saldo <> 0 )' 
  else
   set @sqlWhrSalFec = ' ( dc.fecha_ult_credito >= ''' + convert(varchar,@dtFechaConHoraLim,111) + ''' OR
        dc.saldo <> 0 OR dc.saldo_local <> 0 OR dc.saldo_dolar <> 0  )'
  
  if(@ConParcialidades = 'N') 
   begin
   set @sqlFechasDoc = 'dc.fecha, dc.fecha_documento, dc.fecha_vence,'
 
   set @sqlMontosDoc = '0 AS parcialidad, dc.monto, dc.monto_cliente, dc.MONTO_LOCAL, dc.MONTO_DOLAR,'
 
   set @sqlSaldos = 'dc.monto_cliente - (case when dc.TIPO in (' + @sqlDebitos + ') then
        (SELECT ISNULL(SUM( acc.monto_cli_debito),0)  
      FROM  $$COMPANIA$$.auxiliar_cc acc WHERE  acc.tipo_debito = dc.TIPO
      and acc.debito = dc.DOCUMENTO
      AND  acc.fecha <= ''' + @sqlFecha + ''' ) else 
      (SELECT ISNULL(SUM( acc.monto_cli_credito),0) 
      FROM  $$COMPANIA$$.auxiliar_cc acc WHERE acc.tipo_credito = dc.TIPO
      and acc.credito = dc.DOCUMENTO
      AND  acc.fecha <= ''' + @sqlFecha + ''') end) AS SALDO, 
      dc.monto_local - (case when dc.TIPO in (' + @sqlDebitos + ') then
        (SELECT ISNULL(SUM( acc.monto_local) ,0) 
      FROM  $$COMPANIA$$.auxiliar_cc acc WHERE acc.tipo_debito = dc.TIPO
      and acc.debito = dc.DOCUMENTO
      AND  acc.fecha <= ''' + @sqlFecha + ''')  else 
      (SELECT ISNULL(SUM( acc.monto_local),0) 
      FROM  $$COMPANIA$$.auxiliar_cc acc WHERE acc.tipo_credito = dc.TIPO
      and acc.credito = dc.DOCUMENTO
      AND  acc.fecha <= ''' + @sqlFecha + ''') end) -
      (SELECT ISNULL(SUM( hdc.dif_cam_local),0)
      FROM $$COMPANIA$$.hist_difcam_cc hdc
      WHERE hdc.documento = dc.DOCUMENTO
      AND hdc.tipo = dc.TIPO 
      AND hdc.asiento_proc IS  NOT Null
      AND hdc.estado <> ''R''
      AND hdc.fecha_proc > ''' + @sqlFecha + ''') AS SALDO_LOCAL,    
      dc.monto_dolar - (case when dc.TIPO in (' + @sqlDebitos + ') then
        (SELECT ISNULL(SUM( acc.MONTO_DOLAR ),0)  
      FROM  $$COMPANIA$$.auxiliar_cc acc WHERE acc.tipo_debito = dc.TIPO
      and acc.debito = dc.DOCUMENTO
      AND  acc.fecha <= ''' + @sqlFecha + ''') else 
      (SELECT ISNULL(SUM( acc.MONTO_DOLAR),0) 
      FROM  $$COMPANIA$$.auxiliar_cc acc WHERE acc.tipo_credito = dc.TIPO
      and acc.credito = dc.DOCUMENTO
      AND  acc.fecha <= ''' + @sqlFecha + ''') end)  -
      (SELECT ISNULL(SUM( hdc.dif_cam_dolar),0)
      FROM $$COMPANIA$$.hist_difcam_cc hdc
      WHERE hdc.documento = dc.DOCUMENTO
      AND hdc.tipo = dc.TIPO
      AND hdc.asiento_proc IS  NOT Null
      AND hdc.estado <> ''R''
      AND hdc.fecha_proc > ''' + @sqlFecha + ''')AS SALDO_DOLAR'
   end
  else 
   begin
   set @sTablas = @sTablas + ' left join $$COMPANIA$$.parcialidades_cc par on dc.documento = par.documento_origen AND dc.tipo = par.tipo_doc_origen '
 
   set @sqlFechasDoc = 'CASE WHEN dc.NUM_PARCIALIDADES > 0 THEN ( par.fecha_rige ) ELSE ( dc.fecha ) END as fecha,  CASE WHEN dc.NUM_PARCIALIDADES > 0 THEN ( par.fecha_rige ) ELSE ( dc.fecha_documento ) END as fecha_documento, CASE WHEN dc.NUM_PARCIALIDADES > 0 THEN ( par.fecha_vence ) ELSE ( dc.fecha_vence ) END as fecha_vence,'
 
   set @sqlMontosDoc = 'par.parcialidad, (CASE WHEN dc.NUM_PARCIALIDADES > 0 THEN ( CASE WHEN cop.tipo_condpago =  ''PA'' THEN (dc.monto * ( par.porcentaje / 100 )) 
                   ELSE (par.monto_cuota) END ) 
         ELSE ( dc.monto ) END) as MONTO, 
        (CASE WHEN dc.NUM_PARCIALIDADES > 0 THEN ( CASE WHEN cop.tipo_condpago =  ''PA'' THEN (dc.monto_cliente * (par.porcentaje / 100)) 
                   ELSE (par.monto_cuota_loc/ dc.tipo_camb_act_cli) END )
         ELSE ( dc.monto_cliente ) END) as monto_cliente, 
        (CASE WHEN dc.NUM_PARCIALIDADES > 0 THEN ( CASE WHEN cop.tipo_condpago =  ''PA'' THEN (dc.monto_local * ( par.porcentaje / 100 )) 
                   ELSE (par.monto_cuota_loc) END ) 
         ELSE ( dc.MONTO_LOCAL ) END) as MONTO_LOCAL, 
        (CASE WHEN dc.NUM_PARCIALIDADES > 0 THEN ( CASE WHEN cop.tipo_condpago =  ''PA'' THEN (dc.monto_dolar * ( par.porcentaje / 100 )) 
                   ELSE (par.monto_cuota_dol) END ) 
         ELSE ( dc.MONTO_DOLAR ) END) as MONTO_DOLAR,'
 
   set @sqlSaldos = '(CASE WHEN dc.NUM_PARCIALIDADES > 0 THEN (
      CASE WHEN cop.tipo_condpago =  ''PA'' THEN (dc.monto_cliente * (par.porcentaje / 100)) 
       ELSE (par.monto_cuota_loc/ dc.tipo_camb_act_cli) END)
        ELSE dc.monto_cliente END) -         
    (CASE WHEN dc.TIPO in ('+ @sqlDebitos +') then
    ( CASE WHEN dc.NUM_PARCIALIDADES > 0 THEN (
     CASE WHEN cop.tipo_condpago =  ''PA'' THEN ( SELECT  ISNULL (SUM( apa.monto_cli_debito ),0 )
                FROM $$COMPANIA$$.auxiliar_parc_cc apa WHERE apa.tipo_debito = dc.tipo
                 AND  apa.debito = dc.documento AND apa.parcialidad = par.PARCIALIDAD
		 AND  apa.fecha <= ''' + @sqlFecha + ''' )
            ELSE ( SELECT ISNULL ( SUM( apa.monto_amortiza + apa.monto_interes ),0) 
              FROM $$COMPANIA$$.auxiliar_parc_cc apa WHERE apa.tipo_debito = dc.tipo
                 AND  apa.debito = dc.documento AND apa.parcialidad = par.PARCIALIDAD
		 AND  apa.fecha <= ''' + @sqlFecha + ''' ) END)
          ELSE (SELECT ISNULL(SUM( acc.monto_cli_debito),0)  
            FROM  $$COMPANIA$$.auxiliar_cc acc WHERE  acc.tipo_debito = dc.TIPO
            and acc.debito = dc.DOCUMENTO
            AND  acc.fecha <= ''' + @sqlFecha + ''') END ) 
       else 
      (SELECT ISNULL(SUM( acc.monto_cli_credito),0) 
      FROM  $$COMPANIA$$.auxiliar_cc acc WHERE acc.tipo_credito = dc.TIPO
      and acc.credito = dc.DOCUMENTO
      AND  acc.fecha <= ''' + @sqlFecha + ''') end) AS SALDO,
     (CASE WHEN dc.NUM_PARCIALIDADES > 0 THEN (
      CASE WHEN cop.tipo_condpago =  ''PA'' THEN (dc.monto_local * ( par.porcentaje / 100 )) 
       ELSE (par.monto_cuota_loc) END)
        ELSE dc.monto_local END) -         
    (CASE WHEN dc.TIPO in ('+ @sqlDebitos +') then
    ( CASE WHEN dc.NUM_PARCIALIDADES > 0 THEN (
     CASE WHEN cop.tipo_condpago =  ''PA'' THEN ( SELECT  ISNULL (SUM( apa.monto_local ),0 )
                FROM $$COMPANIA$$.auxiliar_parc_cc apa WHERE apa.tipo_debito = dc.tipo
                 AND  apa.debito = dc.documento AND apa.parcialidad = par.PARCIALIDAD
		 AND  apa.fecha <= ''' + @sqlFecha + ''' )
            ELSE ( SELECT ISNULL ( SUM( apa.monto_amortiza_loc + apa.monto_interes_loc ),0) 
              FROM $$COMPANIA$$.auxiliar_parc_cc apa WHERE apa.tipo_debito = dc.tipo
                 AND  apa.debito = dc.documento AND apa.parcialidad = par.PARCIALIDAD
		 AND  apa.fecha <= ''' + @sqlFecha + ''' ) END)
          ELSE (SELECT ISNULL(SUM( acc.monto_local),0)  
            FROM  $$COMPANIA$$.auxiliar_cc acc WHERE  acc.tipo_debito = dc.TIPO
            and acc.debito = dc.DOCUMENTO
            AND  acc.fecha <= ''' + @sqlFecha + ''') END ) 
       else 
      (SELECT ISNULL(SUM( acc.monto_local),0) 
      FROM  $$COMPANIA$$.auxiliar_cc acc WHERE acc.tipo_credito = dc.TIPO
      and acc.credito = dc.DOCUMENTO
      AND  acc.fecha <= ''' + @sqlFecha + ''') end) -
      (SELECT ISNULL(SUM( hdc.dif_cam_local),0)
      FROM $$COMPANIA$$.hist_difcam_cc hdc
      WHERE hdc.documento = dc.DOCUMENTO
      AND hdc.tipo = dc.TIPO 
      AND hdc.asiento_proc IS  NOT Null
      AND hdc.estado <> ''R''
      AND hdc.fecha_proc > ''' + @sqlFecha + ''') AS SALDO_LOCAL,
     (CASE WHEN dc.NUM_PARCIALIDADES > 0 THEN (
      CASE WHEN cop.tipo_condpago =  ''PA'' THEN (dc.monto_dolar * ( par.porcentaje / 100 )) 
       ELSE (par.monto_cuota_dol) END)
        ELSE dc.monto_dolar END) -         
    (CASE WHEN dc.TIPO in ('+ @sqlDebitos +') then
    ( CASE WHEN dc.NUM_PARCIALIDADES > 0 THEN (
     CASE WHEN cop.tipo_condpago =  ''PA'' THEN ( SELECT  ISNULL (SUM( apa.monto_dolar ),0 )
                FROM $$COMPANIA$$.auxiliar_parc_cc apa WHERE apa.tipo_debito = dc.tipo
                 AND  apa.debito = dc.documento AND apa.parcialidad = par.PARCIALIDAD
		 AND  apa.fecha <= ''' + @sqlFecha + ''' )
            ELSE ( SELECT ISNULL ( SUM( apa.monto_amortiza_dol + apa.monto_interes_dol ),0) 
              FROM $$COMPANIA$$.auxiliar_parc_cc apa WHERE apa.tipo_debito = dc.tipo
                 AND  apa.debito = dc.documento AND apa.parcialidad = par.PARCIALIDAD
		 AND  apa.fecha <= ''' + @sqlFecha + ''' ) END)
          ELSE (SELECT ISNULL(SUM( acc.monto_dolar),0)  
            FROM  $$COMPANIA$$.auxiliar_cc acc WHERE  acc.tipo_debito = dc.TIPO
            and acc.debito = dc.DOCUMENTO
            AND  acc.fecha <= ''' + @sqlFecha + ''') END ) 
       else 
      (SELECT ISNULL(SUM( acc.MONTO_DOLAR),0) 
      FROM  $$COMPANIA$$.auxiliar_cc acc WHERE acc.tipo_credito = dc.TIPO
      and acc.credito = dc.DOCUMENTO
      AND  acc.fecha <= ''' + @sqlFecha + ''') end)  -
      (SELECT ISNULL(SUM( hdc.dif_cam_dolar),0)
      FROM $$COMPANIA$$.hist_difcam_cc hdc
      WHERE hdc.documento = dc.DOCUMENTO
      AND hdc.tipo = dc.TIPO
      AND hdc.asiento_proc IS  NOT Null
      AND hdc.estado <> ''R''
      AND hdc.fecha_proc > ''' + @sqlFecha + ''')AS SALDO_DOLAR'

   end
  
  set @sql ='DELETE FROM $$COMPANIA$$.' + @tabla_rep + ' 
     WHERE REPORTE = ''' + @Reporte + ''''  
 
  execute sp_executesql @sql
  
      begin
   /*Inserta en la tabla de totales o de documentos calculado */
   set @sql =' INSERT INTO $$COMPANIA$$.' + @tabla_rep + ' 
    ( reporte,cliente,documento,tipo,cliente_origen,moneda,fecha              
      ,fecha_documento,fecha_vence,tipo_camb_act_loc,tipo_camb_act_dol,tipo_camb_act_cli  
      ,contrarecibo,asiento,condicion_pago,vendedor,cobrador           
      ,descuento,subtotal,monto_retencion,saldo_retencion,impuesto1,impuesto2          
      ,rubro1,rubro2,aplicacion,desc_subtipo,dias_neto,tipo_condpago,num_parcialidades  
      ,parcialidad,par_monto_principal,par_monto_amortiza,par_saldo_amortiza 
      ,par_monto_interes,par_saldo_interes,par_monto_cuota,par_saldo_cuota,par_saldo_principal
      ,monto_doc,monto_cli,monto_local,monto_dolar,saldo_cli,saldo_local,saldo_dolar        
      ,saldo_rango0,saldo_rango1,saldo_rango2,saldo_rango3,saldo_rango4       
    ,saldo_rango5,saldo_rango6,saldo_rango7 )  
    SELECT ''' + @Reporte + ''' ,
    cliente, documento, tipo, cliente_origen, moneda, fecha, fecha_documento, fecha_vence, 
    tipo_camb_act_loc,tipo_camb_act_dol,tipo_camb_act_cli,contrarecibo, asiento, condicion_pago, vendedor, cobrador,
    descuento, subtotal, monto_retencion, saldo_retencion, impuesto1, impuesto2, rubro1, rubro2,
    aplicacion, desc_subtipo, dias_neto, tipo_condpago, num_parcialidades, parcialidad,
    par_monto_principal, par_monto_amortiza, par_saldo_amortiza, par_monto_interes, 
    par_saldo_interes, par_monto_cuota, par_saldo_cuota, par_saldo_principal,
    ISNULL(' + @sqlSum + '(case when TIPO in (' + @sqlDebitos + ') then monto else -1 * monto end ),0)as MONTO_DOC, 
    ISNULL(' + @sqlSum + '(case when TIPO in (' + @sqlDebitos + ') then monto_cliente else -1 * monto_cliente end ),0)as MONTO_CLI, 
    ISNULL(' + @sqlSum + '(case when TIPO in (' + @sqlDebitos + ') then MONTO_LOCAL else -1 * MONTO_LOCAL end ),0)as MONTO_LOCAL,  
    ISNULL(' + @sqlSum + '(case when TIPO in (' + @sqlDebitos + ') then MONTO_DOLAR else -1 * MONTO_DOLAR end ),0)as MONTO_DOLAR ,
    ISNULL(' + @sqlSum + '((case when SALDO < 0 then 0 else (case when TIPO in (' + @sqlDebitos + ') then SALDO
    else -1 * SALDO end )end)),0)as SALDO_CLI,
    ISNULL(' + @sqlSum + '((case when SALDO_LOCAL < 0 then 0 else (case when TIPO in (' + @sqlDebitos + ') then SALDO_LOCAL 
    else -1 * SALDO_LOCAL end )end )),0)as SALDO_LOCAL, 
    ISNULL(' + @sqlSum + '((case when SALDO_DOLAR < 0 then 0 else (case when TIPO in (' + @sqlDebitos + ') then SALDO_DOLAR 
    else -1 * SALDO_DOLAR end ) end)),0) as SALDO_DOLAR
    ' + @psRangos + '           
   FROM (
   SELECT cli.cliente, dc.documento, dc.tipo, dc.cliente_origen, dc.moneda, ' + @sqlFechasDoc + ' 
   dc.tipo_camb_act_loc,dc.tipo_camb_act_dol,dc.tipo_camb_act_cli,dc.contrarecibo, dc.asiento, dc.condicion_pago, dc.vendedor, dc.cobrador,
   dc.descuento, dc.subtotal, dc.monto_retencion, dc.saldo_retencion, dc.impuesto1, dc.impuesto2, dc.rubro1, dc.rubro2,
   dc.aplicacion, sdc.descripcion as desc_subtipo, cop.dias_neto, cop.tipo_condpago, dc.num_parcialidades, 
   ' + @psMontosParc + ',
   ' + @sqlMontosDoc  + '
   ' + @sqlSaldos + '
   ' + @psCaseRangos + '
   FROM  ' + @sTablas + '
   WHERE ' + @sFechaDoc + '
   ' + @sqlWhrSalFec + ' ' + @psFiltro + ' ' + @sqlWhrCli + '
    ) MontosCli group by cliente, documento, tipo, cliente_origen, moneda, fecha, fecha_documento, fecha_vence, 
    tipo_camb_act_loc,tipo_camb_act_dol,tipo_camb_act_cli,contrarecibo, asiento, condicion_pago, vendedor, cobrador,
    descuento, subtotal, monto_retencion, saldo_retencion, impuesto1, impuesto2, rubro1, rubro2,
    aplicacion, desc_subtipo, dias_neto, tipo_condpago, num_parcialidades, parcialidad,
    par_monto_principal, par_monto_amortiza, par_saldo_amortiza, par_monto_interes, 
    par_saldo_interes, par_monto_cuota, par_saldo_cuota, par_saldo_principal, monto, monto_cliente, 
	monto_local, monto_dolar, saldo, saldo_local, saldo_dolar, Rango_dias'
   execute sp_executesql @sql
   end end;






REMARK 
\
------------------------------------------------------------------ 
-- Vista de Saldos de Clientes para  para Softland Análisis
------------------------------------------------------------------
/
CREATE VIEW $$COMPANIA$$.SoftlandBI_CC_SaldoClientes
AS
	SELECT	CLIENTE.cliente AS Cliente
		, CLIENTE.nombre AS Nombre
		, CLIENTE.categoria_cliente AS CategoriaDeCliente
		, CATEGORIA.descripcion AS NombreCategoriaDeCliente
		, CLIENTE.clase_abc AS ClaseABC
		, CLIENTE.moneda AS Moneda
		, CLIENTE.saldo AS Saldo
		, CLIENTE.saldo_local AS SaldoLocal
		, CLIENTE.saldo_Dolar AS SaldoDolar
		, CLIENTE.tasa_interes AS TasaInteres
		, CLIENTE.tasa_interes_mora AS TasaInteresMora
		, CASE CLIENTE.activo WHEN 'S' THEN 'Activo' ELSE 'Inactivo' END AS Activo
		, CASE CLIENTE.multimoneda WHEN 'S' THEN 'Sí' ELSE 'No' END AS Multimoneda
		, CASE CLIENTE.es_corporacion WHEN 'S' THEN 'Sí' ELSE 'No' END AS EsCorporacion
		, CLIENTE.cli_corporac_asoc AS ClienteCorporacion
		, CLIENTE.pais AS Pais
		, PAIS.nombre AS NombrePais
		, CLIENTE.zona AS Zona
		, ZONA.nombre AS NombreZona
		, CLIENTE.ruta AS Ruta
		, RUTA.descripcion AS DescripcionRuta
		, CLIENTE.vendedor AS Vendedor
		, VENDEDOR.nombre AS NombreVendedor
		, CLIENTE.cobrador AS Cobrador
		, COBRADOR.nombre AS NombreCobrador
		, CLIENTE.fecha_ingreso AS FechaRegistro
		, YEAR(CLIENTE.fecha_ingreso) AS AnoFechaRegistro
		, DATEPART(QUARTER,CLIENTE.fecha_ingreso) AS TrimestreFechaRegistro
		, MONTH(CLIENTE.fecha_ingreso) AS MesFechaRegistro
	FROM	cliente CLIENTE (NOLOCK)
		INNER JOIN $$COMPANIA$$.categoria_cliente CATEGORIA (NOLOCK)
			ON CLIENTE.categoria_cliente = CATEGORIA.categoria_cliente
		INNER JOIN $$COMPANIA$$.pais PAIS (NOLOCK)
			ON CLIENTE.pais = PAIS.pais
		INNER JOIN $$COMPANIA$$.zona ZONA (NOLOCK)
			ON CLIENTE.zona = ZONA.zona
		INNER JOIN $$COMPANIA$$.ruta RUTA (NOLOCK)
			ON CLIENTE.ruta = RUTA.ruta
		INNER JOIN $$COMPANIA$$.cobrador COBRADOR (NOLOCK)
			ON CLIENTE.cobrador = COBRADOR.cobrador
		LEFT JOIN $$COMPANIA$$.vendedor VENDEDOR (NOLOCK)
			ON CLIENTE.vendedor = VENDEDOR.vendedor
;

REMARK 
\
------------------------------------------------------------------ 
-- Vista de Movimientos Clientes para Softland Análisis
------------------------------------------------------------------
/
CREATE VIEW $$COMPANIA$$.SoftlandBI_CC_MovClientes
AS
	SELECT	DOCUMENTO.cliente AS Cliente
		, CLIENTE.nombre AS NombreCliente
		, CLIENTE.categoria_cliente AS CategoriaDeCliente
		, CATEGORIA.descripcion AS NombreCategoriaDeCliente
		, CLIENTE.clase_abc AS ClaseABC
		, CASE CLIENTE.activo WHEN 'S' THEN 'Activo' ELSE 'Inactivo' END AS Activo
		, CASE DOCUMENTO.anulado WHEN 'S' THEN 'Sí' ELSE 'No' END AS DocumentoAnulado
		, CASE DOCUMENTO.aprobado WHEN 'S' THEN 'Sí' ELSE 'No' END AS DocumentoAprobado
		, CLIENTE.pais AS Pais
		, PAIS.nombre AS NombrePais
		, CLIENTE.zona AS Zona
		, ZONA.nombre AS NombreZona
		, CLIENTE.ruta AS Ruta
		, RUTA.descripcion AS DescripcionRuta
		, CLIENTE.vendedor AS Vendedor
		, VENDEDOR.nombre AS NombreVendedor
		, CLIENTE.cobrador AS Cobrador
		, COBRADOR.nombre AS NombreCobrador
		, DOCUMENTO.documento AS Documento
		, DOCUMENTO.tipo AS TipoDocumento
		, SUBTIPO.descripcion AS SubtipoDocumento
		, DOCUMENTO.fecha_documento AS FechaDocumento
		, YEAR(DOCUMENTO.fecha_documento) AS AnoFechaDocumento
		, DATEPART(QUARTER,DOCUMENTO.fecha_documento) AS TrimestreFechaDocumento
		, MONTH(DOCUMENTO.fecha_documento) AS MesFechaDocumento
		, DATEDIFF (DAY, DOCUMENTO.fecha_documento, ERPADMIN.SF_GETDATE()) AS DiasAntiguedad
		, DATEDIFF (MONTH, DOCUMENTO.fecha_documento, ERPADMIN.SF_GETDATE()) AS MesesAntiguedad
		, $$COMPANIA$$.SoftlandBI_FN_RangoFechas(DOCUMENTO.fecha_documento, ERPADMIN.SF_GETDATE()) AS RangoAntiguedadDocumento
		, DOCUMENTO.fecha AS FechaRige
		, YEAR(DOCUMENTO.fecha) AS AnoFechaRige
		, DATEPART(QUARTER,DOCUMENTO.fecha) AS TrimestreFechaRige
		, MONTH(DOCUMENTO.fecha) AS MesFechaRige
		, DATEDIFF (DAY, DOCUMENTO.fecha, ERPADMIN.SF_GETDATE()) AS DiasAntiguedadRige
		, DATEDIFF (MONTH, DOCUMENTO.fecha, ERPADMIN.SF_GETDATE()) AS MesesAntiguedadRige
		, $$COMPANIA$$.SoftlandBI_FN_RangoFechas(DOCUMENTO.fecha, ERPADMIN.SF_GETDATE()) AS RangoAntiguedadRige
		, DOCUMENTO.fecha_vence AS FechaVencimiento
		, YEAR(DOCUMENTO.fecha_vence) AS AnoFechaVencimiento
		, DATEPART(QUARTER,DOCUMENTO.fecha_vence) AS TrimestreFechaVencimiento
		, MONTH(DOCUMENTO.fecha_vence) AS MesFechaVencimiento
		, DATEDIFF (DAY, DOCUMENTO.fecha_vence, ERPADMIN.SF_GETDATE()) AS DiasVencimiento
		, DATEDIFF (MONTH, DOCUMENTO.fecha_vence, ERPADMIN.SF_GETDATE()) AS MesesVencimiento
		, $$COMPANIA$$.SoftlandBI_FN_RangoFechas(DOCUMENTO.fecha_vence, ERPADMIN.SF_GETDATE()) AS RangoVencimientoDocumento
		, DOCUMENTO.moneda AS MonedaDocumento
		, DOCUMENTO.monto AS Monto
		, DOCUMENTO.saldo AS Saldo
		, DOCUMENTO.monto_local AS MontoLocal
		, DOCUMENTO.saldo_local AS SaldoLocal
		, DOCUMENTO.monto_dolar AS MontoDolar
		, DOCUMENTO.saldo_dolar AS SaldoDolar
		, DOCUMENTO.monto_retencion AS MontoRetencion
		, DOCUMENTO.saldo_retencion AS SaldoRetencion
		, DOCUMENTO.num_parcialidades AS NumeroDeParcialidades
		, $$COMPANIA$$.SoftlandBI_FN_MontoAfectaCC(DOCUMENTO.tipo, DOCUMENTO.monto_local) AS MontoAfectaLocal
		, $$COMPANIA$$.SoftlandBI_FN_MontoAfectaCC(DOCUMENTO.tipo,DOCUMENTO.saldo_local) AS SaldoAfectaLocal
		, $$COMPANIA$$.SoftlandBI_FN_MontoAfectaCC(DOCUMENTO.tipo,DOCUMENTO.monto_dolar) AS MontoAfectaDolar
		, $$COMPANIA$$.SoftlandBI_FN_MontoAfectaCC(DOCUMENTO.tipo,DOCUMENTO.saldo_dolar) AS SaldoAfectaDolar
	FROM	documentos_cc DOCUMENTO
		INNER JOIN $$COMPANIA$$.subtipo_doc_cc SUBTIPO (NOLOCK)
			ON DOCUMENTO.tipo = SUBTIPO.tipo
			   AND DOCUMENTO.subtipo = SUBTIPO.subtipo
		INNER JOIN $$COMPANIA$$.cliente CLIENTE (NOLOCK)
			ON DOCUMENTO.cliente = CLIENTE.cliente
		INNER JOIN $$COMPANIA$$.categoria_cliente CATEGORIA (NOLOCK)
			ON CLIENTE.categoria_cliente = CATEGORIA.categoria_cliente
		INNER JOIN $$COMPANIA$$.condicion_pago CONDICION (NOLOCK)
			ON CLIENTE.condicion_pago = CONDICION.condicion_pago
		INNER JOIN $$COMPANIA$$.pais PAIS (NOLOCK)
			ON CLIENTE.pais = PAIS.pais
		INNER JOIN $$COMPANIA$$.zona ZONA (NOLOCK)
			ON CLIENTE.zona = ZONA.zona
		INNER JOIN $$COMPANIA$$.ruta RUTA (NOLOCK)
			ON CLIENTE.ruta = RUTA.ruta
		INNER JOIN $$COMPANIA$$.cobrador COBRADOR (NOLOCK)
			ON CLIENTE.cobrador = COBRADOR.cobrador
		LEFT JOIN $$COMPANIA$$.vendedor VENDEDOR (NOLOCK)
			ON CLIENTE.vendedor = VENDEDOR.vendedor
;

REMARK 
\
------------------------------------------------------------------ 
-- Vista de Créditos para Softland Análisis
------------------------------------------------------------------
/
CREATE VIEW $$COMPANIA$$.SoftlandBI_CC_Creditos
AS
	SELECT	AUXILIAR.tipo_debito AS TipoDebito
		, AUXILIAR.debito AS Debito
		, AUXILIAR.credito AS Credito
		, CREDITO.cliente AS Cliente
		, CLIENTE.nombre AS NombreCliente
		, CLIENTE.vendedor AS Vendedor
		, VENDEDOR.nombre AS NombreVendedor
		, CLIENTE.cobrador AS Cobrador
		, COBRADOR.nombre AS NombreCobrador
		, CREDITO.fecha AS FechaCredito
		, YEAR(CREDITO.fecha) AS AnoFechaCredito
		, DATEPART(QUARTER,CREDITO.fecha) AS TrimestreFechaCredito
		, MONTH(CREDITO.fecha) AS MesFechaCredito
		, DATEDIFF(DAY, DEBITO.fecha, AUXILIAR.fecha) AS DiasHastaCancelacion
		, DATEDIFF(DAY, DEBITO.fecha_vence, AUXILIAR.fecha) AS DiasDespuesVencimiento
		, DEBITO.condicion_pago AS CondicionPagoDebito
		, CREDITO.aplicacion AS AplicacionCredito
		, AUXILIAR.monto_local AS Abono
		, CREDITO.monto_local AS MontoLocalCredito
		, CREDITO.monto_dolar AS MontoDolarCredito
		, CREDITO.saldo_local AS SaldoLocalCredito
		, CREDITO.saldo_dolar AS SaldoDolarCredito
		, DEBITO.monto_local AS MontoLocalDebito
		, DEBITO.monto_dolar AS MontoDolarDebito
	FROM	
		auxiliar_cc AUXILIAR (NOLOCK)
		INNER JOIN $$COMPANIA$$.documentos_cc CREDITO (NOLOCK)
			ON AUXILIAR.tipo_credito = CREDITO.tipo
			   AND AUXILIAR.credito = CREDITO.documento
		INNER JOIN $$COMPANIA$$.cliente CLIENTE (NOLOCK)
			ON CREDITO.cliente = CLIENTE.cliente
		INNER JOIN $$COMPANIA$$.documentos_cc DEBITO (NOLOCK)
			ON AUXILIAR.tipo_debito = DEBITO.tipo
			   AND AUXILIAR.debito = DEBITO.documento
		INNER JOIN $$COMPANIA$$.cobrador COBRADOR (NOLOCK)
			ON CLIENTE.cobrador = COBRADOR.cobrador
		LEFT JOIN $$COMPANIA$$.vendedor VENDEDOR (NOLOCK)
			ON CLIENTE.vendedor = VENDEDOR.vendedor
;

CREATE FUNCTION $$COMPANIA$$.OBTENERMONTORETENCIONCC
  (@PDEBITO VARCHAR(50), @PCLIENTE VARCHAR(50))
    RETURNS DECIMAL(28,8)
    AS
    BEGIN
     DECLARE @MONTO DECIMAL(28,8)
    
   SELECT @MONTO = SUM ( DRET.MONTO )
   FROM $$COMPANIA$$.RETENCIONES_DOC_CC DRET INNER JOIN
   $$COMPANIA$$.TRASLADO_IVA_RETENCIONES TRET ON DRET.CODIGO_RETENCION = TRET.CODIGO_RETENCION INNER JOIN
   $$COMPANIA$$.AUXILIAR_CC AUX ON DRET.RETENCION = AUX.CREDITO INNER JOIN
   $$COMPANIA$$.DOCUMENTOS_CC DCC ON AUX.DEBITO = DCC.DOCUMENTO AND AUX.TIPO_DEBITO = DCC.TIPO AND AUX.CLI_DOC_DEBITO = DCC.CLIENTE
   WHERE AUX.DEBITO = @PDEBITO AND 
   AUX.CLI_DOC_DEBITO = @PCLIENTE AND
   AUX.TIPO_CREDITO = 'RET' 
   AND TRET.RET_DIFERENCIA_ACREDITABLE = 'S'
    
    RETURN ISNULL(@MONTO,0)
    
  END;

CREATE TRIGGER $$COMPANIA$$.CLIENTE_VEND_POS_SINC_DEL
			ON $$COMPANIA$$.CLIENTE_VENDEDOR
FOR DELETE  
AS 
BEGIN   	
	DECLARE @ERROR 				INT
	DECLARE @SENTENCIA   		VARCHAR(254)
	DECLARE @NOMBRETABLA		VARCHAR(254)
	DECLARE @USUARIO_ACTUAL		VARCHAR(30)
	DECLARE @CLIENTE 			VARCHAR(20)
	DECLARE @VENDEDOR 			VARCHAR(4)

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
END;


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
END;

