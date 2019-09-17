REMARK 
REMARK 
\
------------------------------------------------------------------ 
Consulta de Medios Electrónicos
------------------------------------------------------------------
/


CREATE FUNCTION $$COMPANIA$$.MEConsulta
 (
    @Formato as Varchar(4),
    @FechaInicial as DateTime,
    @FechaFinal as DateTime
   )
   RETURNS TABLE
   AS
   RETURN
   SELECT  me.FORMATO AS Formato, 
     me.CONCEPTO As Concepto,
     me.VALOR_A_MOSTRAR AS ValorAMostrar,
     me.TIPO_DOCUMENTO AS TipoDocumento,
     me.NUMERO_DOC_NIT AS Nit,
     me.DIGITO_VERIFICADOR AS DigitoVerificacion,
     me.PRIMER_APELLIDO AS PrimerApellido,
     me.SEGUNDO_APELLIDO AS SegundoApellido,
     me.PRIMER_NOMBRE AS PrimerNombre,
     me.SEGUNDO_NOMBRE AS SegundoNombre,
     me.RAZON_SOCIAL AS RazonSocial,
     me.DIRECCION AS Direccion,
     me.DEPARTAMENTO AS Departamento,
     me.MUNICIPIO AS Municipio,
     me.PAIS AS Pais,
     me.EXTERIOR AS Exterior,
     me.FECHA AS Fecha,
     me.TIPO_MOVIMIENTO AS TipoMovimiento,
     me.TOPE_FORMATO AS TopeFormato,
     me.TOPE_CONCEPTO AS TopeConcepto,
     me.CUANTIAS_MENORES AS CuantiasMenores,
     me.TRANSACCIONES_EXTERIOR AS ManejaTransaccionesExterior,
     me.CUENTA_CONTABLE AS CuentaContable,
     me.ES_CUENTA_DEVOLUCIONES AS PagoAbonosCtas,
     me.SALDO_INICIAL AS SaldoInicial,
     me.SALDO_FINAL AS SaldoFinal,
     me.VALOR AS Valor,
     me.VALOR_BASE AS ValorBase,
     CONVERT(char(10),me.fecha_inicio,126) as FechaInicio, 
     CONVERT(char(10),me.fecha_fin,126) FechaFinal,
     '' FechaExpedicion,
     '' NumeroEntidades,
     me.Email,
     me.tipo_medida as TipoMedida,
     me.cargo_contrato as CargoContrato,
     me.edad as Edad,
     me.nivel_educativo as NivelEducativo,
 	me.tipo_impuesto as TipoImpuesto
   from $$COMPANIA$$.ME_PREVIA_MEDIO me
  where me.FORMATO = @Formato ;


REMARK 
\
------------------------------------------------------------------ 
Consulta de Medios Electrónicos, agrupación de todo para su eventual manipulación
------------------------------------------------------------------
/



CREATE FUNCTION $$COMPANIA$$.MEConsultaAgrupada
  (
   @Formato as Varchar(4),
   @FechaInicial as DateTime,
   @FechaFinal as DateTime
  )
  RETURNS TABLE
  AS
  RETURN
  SELECT me.Formato, me.Concepto, me.ValorAMostrar, me.TipoDocumento, me.Nit, me.DigitoVerificacion, me.Exterior,
    me.PrimerApellido, me.SegundoApellido, me.PrimerNombre, me.SegundoNombre, me.RazonSocial,
    me.Direccion, me.Departamento, me.Municipio, me.Pais, me.CuantiasMenores, me.ManejaTransaccionesExterior,
    me.TopeFormato, me.TopeConcepto,  me.CuentaContable, me.PagoAbonosCtas,
    sum(me.SaldoInicial) SaldoInicial,  sum(me.SaldoFinal) SaldoFinal, 
    CASE when sum(me.valor) < 0 then
     sum(me.valor) * -1
     else
     sum(me.valor)
    END Valor, 
    CASE when sum(me.valorBase) < 0 then
     sum(me.valorBase) * -1
     else
     sum(me.valorBase) 
    END ValorBase,
    CONVERT(char(10),me.FechaInicio,126) FechaInicio, 
    CONVERT(char(10),me.FechaFinal,126) FechaFinal,
    me.Email,
    me.TipoMedida,
    me.CargoContrato,
    me.Edad,
    me.NivelEducativo,
	me.TipoImpuesto
  FROM $$COMPANIA$$.MEConsulta( @Formato, @FechaInicial, @FechaFinal ) me
  WHERE (me.valor <> 0 or me.valorBase <> 0)
  AND  me.Nit IS NOT NULL
  group by me.Formato, me.Concepto, me.ValorAMostrar, me.TipoDocumento, me.Nit, me.DigitoVerificacion, me.Exterior,
    me.PrimerApellido, me.SegundoApellido, me.PrimerNombre, me.SegundoNombre, me.RazonSocial,
    me.Direccion, me.Departamento, me.Municipio, me.Pais, me.CuantiasMenores, me.ManejaTransaccionesExterior,
    me.TopeFormato, me.TopeConcepto, me.CuentaContable, me.PagoAbonosCtas,me.FechaInicio,me.FechaFinal,
    me.Email, me.TipoMedida,me.CargoContrato,me.Edad,me.NivelEducativo, me.TipoImpuesto ;



REMARK 
\
------------------------------------------------------------------ 
Consulta de Medios Electrónicos donde los valores sean menor a cero
------------------------------------------------------------------
/
CREATE FUNCTION $$COMPANIA$$.MEConsultaAgrupadaErrores
  (
    @Formato as Varchar(4),
    @FechaInicial as DateTime,
    @FechaFinal as DateTime
   )
   RETURNS TABLE
   AS
   RETURN
   SELECT me.Formato, me.Concepto, me.ValorAMostrar, me.TipoDocumento, me.Nit, me.DigitoVerificacion,
     me.PrimerApellido, me.SegundoApellido, me.PrimerNombre, me.SegundoNombre, me.RazonSocial,
     me.Direccion, me.Departamento, me.Municipio, me.Exterior, me.Pais, me.CuentaContable, me.PagoAbonosCtas,
     sum(me.SaldoInicial) SaldoInicial, sum(me.SaldoFinal) SaldoFinal, sum(me.valor) Valor, sum(me.valorBase) ValorBase,
     CONVERT(char(10),me.FechaInicio,126) FechaInicio, 
     CONVERT(char(10),me.FechaFinal,126) FechaFinal,   '' FechaExpedicion,'' NumeroEntidades,me.Email,
     me.TipoMedida,me.CargoContrato,me.Edad,me.NivelEducativo, me.TipoImpuesto
   FROM $$COMPANIA$$.MEConsulta( @Formato, @FechaInicial, @FechaFinal ) me
   group by me.Formato, me.Concepto, me.ValorAMostrar, me.TipoDocumento, me.Nit, me.DigitoVerificacion,
     me.PrimerApellido, me.SegundoApellido, me.PrimerNombre, me.SegundoNombre, me.RazonSocial,
     me.Direccion, me.Departamento, me.Municipio, me.Exterior, me.Pais, me.CuentaContable, me.PagoAbonosCtas,
     me.FechaInicio,me.FechaFinal,me.Email,me.TipoMedida,me.CargoContrato,me.Edad,me.NivelEducativo, me.TipoImpuesto;





REMARK 
\
------------------------------------------------------------------ 
Consulta de Medios Electrónicos topes sean cero
------------------------------------------------------------------
/
CREATE FUNCTION $$COMPANIA$$.METopesCero
 (
   @Formato as Varchar(4),
   @FechaInicial as DateTime,
   @FechaFinal as DateTime
  )
  RETURNS TABLE
  AS
  RETURN
  SELECT me.Concepto, me.TipoDocumento, me.Nit, me.DigitoVerificacion,  me.ValorAMostrar, 
    me.PrimerApellido, me.SegundoApellido, me.PrimerNombre, me.SegundoNombre, me.RazonSocial,
    me.Direccion, me.Departamento, me.Municipio, me.Exterior, me.Pais, me.CuentaContable, me.PagoAbonosCtas,
    me.SaldoInicial, me.SaldoFinal, me.Valor, me.ValorBase, CONVERT(char(10),me.FechaInicio,126) FechaInicio, 
    CONVERT(char(10),me.FechaFinal,126) FechaFinal,   '' FechaExpedicion,'' NumeroEntidades,me.Email,
    me.TipoMedida,me.CargoContrato,me.Edad,me.NivelEducativo, me.TipoImpuesto
  FROM $$COMPANIA$$.MEConsultaAgrupada( @Formato, @FechaInicial, @FechaFinal) me
  WHERE me.TopeFormato = 0 and me.TopeConcepto = 0
  and (me.exterior = '0' or (me.exterior = '1' and me.ManejaTransaccionesExterior = 'N'));



REMARK 
\
------------------------------------------------------------------ 
Consulta de Medios Electrónicos Topes sean sobrepasados por el valor
------------------------------------------------------------------
/
CREATE FUNCTION $$COMPANIA$$.METopesMax
   (
    @Formato as Varchar(4),
    @FechaInicial as DateTime,
    @FechaFinal as DateTime
   )
   RETURNS TABLE
   AS
   RETURN
   SELECT me.Concepto, me.TipoDocumento, me.Nit, me.DigitoVerificacion,  me.ValorAMostrar,
     me.PrimerApellido, me.SegundoApellido, me.PrimerNombre, me.SegundoNombre, me.RazonSocial,
     me.Direccion, me.Departamento, me.Municipio, me.Exterior, me.Pais, me.CuentaContable, me.PagoAbonosCtas,
     me.SaldoInicial, me.SaldoFinal, me.Valor, me.ValorBase,
      CONVERT(char(10),me.FechaInicio,126) FechaInicio, 
     CONVERT(char(10),me.FechaFinal,126) FechaFinal,   '' FechaExpedicion,'' NumeroEntidades,me.Email,
     me.TipoMedida,me.CargoContrato,me.Edad,me.NivelEducativo, me.TipoImpuesto
   FROM $$COMPANIA$$.MEConsultaAgrupada( @Formato, @FechaInicial, @FechaFinal) me inner join
     (SELECT me2.Formato, me2.Concepto, me2.Nit, me2.ValorAMostrar, SUM(me2.Valor) Valor
      FROM $$COMPANIA$$.MEConsultaAgrupada ( @Formato, @FechaInicial, @FechaFinal) me2
      WHERE me2.TopeConcepto > 0
      AND me2.TopeConcepto > me2.TopeFormato
      AND (me2.exterior = '0' or (me2.exterior = '1' and me2.ManejaTransaccionesExterior = 'N'))
      group by me2.Formato, me2.Concepto, me2.Nit, me2.ValorAMostrar) me2  
      on me.Formato = me2.Formato and me.Concepto = me2.Concepto and me.Nit = me2.Nit and me.ValorAMostrar = me2.ValorAMostrar
   WHERE me.TopeConcepto > 0
   and me.TopeConcepto < me2.Valor
   UNION
   SELECT me.Concepto, me.TipoDocumento, me.Nit, me.DigitoVerificacion,  me.ValorAMostrar, 
     me.PrimerApellido, me.SegundoApellido, me.PrimerNombre, me.SegundoNombre, me.RazonSocial,
     me.Direccion, me.Departamento, me.Municipio, me.Exterior, me.Pais, me.CuentaContable, me.PagoAbonosCtas,
     me.SaldoInicial, me.SaldoFinal, me.Valor, me.ValorBase,
     CONVERT(char(10),me.FechaInicio,126) FechaInicio, 
     CONVERT(char(10),me.FechaFinal,126) FechaFinal,
        '' FechaExpedicion,
     '' NumeroEntidades,me.Email,me.TipoMedida,me.CargoContrato,me.Edad,me.NivelEducativo,me.TipoImpuesto
   FROM $$COMPANIA$$.MEConsultaAgrupada( @Formato, @FechaInicial, @FechaFinal) me inner join
    (SELECT me2.Formato, me2.Nit, me2.ValorAMostrar, SUM(me2.Valor) Valor
     FROM $$COMPANIA$$.MEConsultaAgrupada( @Formato, @FechaInicial, @FechaFinal) me2  
     where me2.TopeFormato > 0 
     AND me2.TopeConcepto < me2.TopeFormato
     AND(me2.exterior = '0' or (me2.exterior = '1' and me2.ManejaTransaccionesExterior = 'N'))
     group by me2.Formato, me2.Nit, me2.ValorAMostrar) me2  
     on me.Formato = me2.Formato and me.Nit = me2.Nit and me.ValorAMostrar = me2.ValorAMostrar
   WHERE me.TopeFormato > 0
  and me.TopeFormato < me2.Valor ;






REMARK 
\
------------------------------------------------------------------ 
Consulta de Medios Electrónicos, Topes de conceptos mayor al valor
------------------------------------------------------------------
/
CREATE FUNCTION $$COMPANIA$$.MECuantiaMenorConcepto
 (
   @Formato as Varchar(4),
   @FechaInicial as DateTime,
   @FechaFinal as DateTime,
   @TipoDocCM as Varchar(2),
   @NitCM as Varchar(20),
   @DescripNitCM as Varchar(100),
   @Direccion as Varchar(3000),
   @Departamento as VARCHAR(2),
   @Municipio as Varchar(3),
   @Pais as Varchar(4),
   @Correo as Varchar (100)
  )
  RETURNS TABLE
  AS
  RETURN
  SELECT me.Concepto, @TipoDocCM TipoDocumento, @NitCM Nit, '' DigitoVerificacion,  me.ValorAMostrar, 
    '' PrimerApellido, '' SegundoApellido, '' PrimerNombre, '' SegundoNombre,
    @DescripNitCM RazonSocial, @Direccion Direccion, @Departamento Departamento, @Municipio Muncipio,  
    me.Exterior, @Pais Pais, me.CuentaContable, me.PagoAbonosCtas,
    sum(me.SaldoInicial) SaldoInicial,  sum(me.SaldoFinal) SaldoFinal, SUM(me.Valor) Valor, SUM(me.ValorBase) ValorBase,
       CONVERT(char(10),me.FechaInicio,126) FechaInicio, 
    CONVERT(char(10),me.FechaFinal,126) FechaFinal,
    '' FechaExpedicion,
    '' NumeroEntidades, @Correo Email, '' TipoMedida,'' CargoContrato,' ' Edad,' 'NivelEducativo, me.TipoImpuesto
  FROM $$COMPANIA$$.MEConsultaAgrupada( @Formato, @FechaInicial, @FechaFinal) me inner join
    (SELECT me2.Formato, me2.Concepto, me2.Nit, me2.ValorAMostrar, SUM(me2.Valor) Valor
     FROM $$COMPANIA$$.MEConsultaAgrupada ( @Formato, @FechaInicial, @FechaFinal) me2
     WHERE me2.CuantiasMenores = 'S'
     AND me2.TopeConcepto > 0
     AND me2.TopeConcepto > TopeFormato
     AND (me2.exterior = '0' or (me2.exterior = '1' and me2.ManejaTransaccionesExterior = 'N'))
     group by me2.Formato, me2.Concepto, me2.Nit, me2.ValorAMostrar) me2  
     on me.Formato = me2.Formato and me.Concepto = me2.Concepto and me.Nit = me2.Nit and me.ValorAMostrar = me2.ValorAMostrar
  WHERE me.TopeConcepto >= me2.valor   
  GROUP BY me.Concepto, me.ValorAMostrar, me.Exterior, me.CuentaContable, me.PagoAbonosCtas,
  me.FechaInicio,me.FechaFinal,me.Email,me.TipoMedida,me.CargoContrato,me.Edad,me.NivelEducativo,me.TipoImpuesto ;




REMARK 
\
------------------------------------------------------------------ 
Consulta de Medios Electrónicos, Topes de formato mayor al valor y tope concepto = 0
------------------------------------------------------------------
/
CREATE FUNCTION $$COMPANIA$$.MECuantiaMenorNitMenorFormato
	 (
	  @Formato as Varchar(4),
	  @FechaInicial as DateTime,
	  @FechaFinal as DateTime,
	  @TipoDocCM as Varchar(2),
	  @NitCM as Varchar(20),
	  @DescripNitCM as Varchar(100),
	  @Direccion as Varchar(3000),
	  @Departamento as VARCHAR(2),
	  @Municipio as Varchar(3),
	  @Pais as Varchar(4),
	  @Correo as Varchar (100)
	 )
	 RETURNS TABLE
	 AS
	 RETURN
	 SELECT me.Concepto, @TipoDocCM TipoDocumento, @NitCM Nit, '' DigitoVerificacion,  me.ValorAMostrar, 
	   '' PrimerApellido, '' SegundoApellido, '' PrimerNombre, '' SegundoNombre,
	   @DescripNitCM RazonSocial, @Direccion Direccion, @Departamento Departamento, @Municipio Muncipio, 
	   me.Exterior, @Pais Pais, me.CuentaContable, me.PagoAbonosCtas,
	   sum(me.SaldoInicial) SaldoInicial,  sum(me.SaldoFinal) SaldoFinal, SUM(me.Valor) Valor, SUM(me.ValorBase) ValorBase,
		 CONVERT(char(10),me.FechaInicio,126) FechaInicio, 
	   CONVERT(char(10),me.FechaFinal,126) FechaFinal,
		  '' FechaExpedicion,
	   '' NumeroEntidades, @Correo Email,''TipoMedida,'' CargoContrato,'' Edad,''NivelEducativo
	 FROM $$COMPANIA$$.MEConsultaAgrupada( @Formato, @FechaInicial, @FechaFinal) me inner join
	   (SELECT me2.Formato, me2.Nit, me2.ValorAMostrar, SUM(me2.Valor) Valor
		FROM $$COMPANIA$$.MEConsultaAgrupada ( @Formato, @FechaInicial, @FechaFinal) me2
		WHERE me2.CuantiasMenores = 'S'
		AND me2.TopeFormato > 0
		AND me2.TopeFormato > TopeConcepto
	   AND (me2.exterior = '0' or (me2.exterior = '1' and me2.ManejaTransaccionesExterior = 'N'))
		group by me2.Formato, me2.Nit, me2.ValorAMostrar) me2  
		on me.Formato = me2.Formato and me.Nit = me2.Nit and me.ValorAMostrar = me2.ValorAMostrar
	 WHERE me.TopeFormato >= me2.Valor
	 Group by me.Concepto, me.ValorAMostrar, me.Exterior, me.CuentaContable, me.PagoAbonosCtas,
	  me.FechaInicio,me.FechaFinal,me.Email,me.TipoMedida,me.CargoContrato,me.Edad,me.NivelEducativo;






REMARK 
\
------------------------------------------------------------------ 
Consulta de Medios Electronicos, Contribuyentes que son del exterior
------------------------------------------------------------------
/
CREATE FUNCTION $$COMPANIA$$.MENitsExterior
 (
    @Formato as Varchar(4),
    @FechaInicial as DateTime,
    @FechaFinal as DateTime
   )
   RETURNS TABLE
   AS
   RETURN
   SELECT me.Concepto, me.TipoDocumento, me.Nit, me.DigitoVerificacion,  me.ValorAMostrar, 
     me.PrimerApellido, me.SegundoApellido, me.PrimerNombre, me.SegundoNombre, me.RazonSocial,
     me.Direccion, me.Departamento, me.Municipio, me.Exterior, me.Pais, me.CuentaContable, me.PagoAbonosCtas,
     me.SaldoInicial, me.SaldoFinal, me.Valor, me.ValorBase,
      CONVERT(char(10),me.FechaInicio,126) FechaInicio, 
     CONVERT(char(10),me.FechaFinal,126) FechaFinal,me.Email,me.TipoMedida,me.CargoContrato,me.Edad,me.NivelEducativo, me.TipoImpuesto
   FROM $$COMPANIA$$.MEConsultaAgrupada( @Formato, @FechaInicial, @FechaFinal) me
  WHERE me.exterior = '1' and me.ManejaTransaccionesExterior = 'S' ;




REMARK
\
 ------------------------------------------------------------------
 Se crea el procedimiento EjecutarPreviaMedio
 ------------------------------------------------------------------
/

CREATE PROCEDURE $$COMPANIA$$.EjecutarPreviaMedio 
(	@Formato      AS VARCHAR(4),
    @FechaInicial AS DATETIME,
    @FechaFinal   AS DATETIME )
AS 

	DECLARE @sqlInsert 			VARCHAR(4000)
	DECLARE @sqlConsulta 		VARCHAR(4000)
	DECLARE @sqlConsulta1 		VARCHAR(4000)
	DECLARE @sqlConsulta2 		VARCHAR(4000)
	DECLARE @sqlConsulta3 		VARCHAR(4000)
	DECLARE @sqlConsulta4 		VARCHAR(4000)
	DECLARE @strSQLWhereQuery 	VARCHAR(4000)
	DECLARE @strSQLGroupQuery 	VARCHAR(4000)

BEGIN 
	DELETE FROM $$COMPANIA$$.me_previa_medio 
      WHERE  formato = @Formato 

	SET @sqlInsert = ''
	SET @sqlConsulta = ''
	SET @sqlConsulta1 = ''
	SET @sqlConsulta2 = ''
	SET @sqlConsulta3 = ''
	SET @sqlConsulta4 = ''
	SET @strSQLWhereQuery = ''
	SET @strSQLGroupQuery = ''

set @sqlInsert ='
				INSERT INTO $$COMPANIA$$.me_previa_medio 
                  (formato, 
                   concepto, 
                   valor_a_mostrar, 
                   tipo_documento, 
                   numero_doc_nit, 
                   digito_verificador, 
                   primer_apellido, 
                   segundo_apellido, 
                   primer_nombre, 
                   segundo_nombre, 
                   razon_social, 
                   direccion, 
                   departamento, 
                   municipio, 
                   pais, 
                   exterior, 
                   fecha, 
                   tipo_movimiento, 
                   tope_formato, 
                   tope_concepto, 
                   cuantias_menores, 
                   transacciones_exterior, 
                   cuenta_contable, 
                   es_cuenta_devoluciones, 
                   saldo_inicial, 
                   saldo_final, 
                   valor, 
                   valor_base, 
                   centro_costo, 
                   nit,
				   fecha_inicio,
				   fecha_fin,
				   email,
				   tipo_medida,
				   cargo_contrato,
				   edad,
				   nivel_educativo,
				   tipo_impuesto) '

set @sqlConsulta =' SELECT me.formato AS Formato, 
						me.concepto AS Concepto, 
						me.valor_a_mostrar AS ValorAMostrar, 
						vtme.tipo_documento AS TipoDocumento, 
						vtme.numero_doc_nit AS Nit, 
						vtme.digito_verificador AS DigitoVerificacion, 
					CASE 
						WHEN vtme.clase_documento = ''31'' THEN NULL 
						ELSE  vtme.primer_apellido 
					END AS PrimerApellido, 
					CASE 
						WHEN vtme.clase_documento = ''31'' THEN NULL 
						ELSE vtme.segundo_apellido 
					END AS SegundoApellido, 
					CASE 
						WHEN vtme.clase_documento = ''31'' THEN NULL 
						ELSE primer_nombre 
					END AS PrimerNombre, 
					CASE 
						WHEN vtme.clase_documento = ''31'' THEN NULL 
						ELSE segundo_nombre 
					END AS SegundoNombre, 
					CASE 
						WHEN vtme.clase_documento = ''31'' THEN razon_social 
						ELSE NULL 
					END AS RazonSocial,'

			IF @Formato = '2275' 
				BEGIN
					SET  @sqlConsulta = @sqlConsulta + '(SELECT DIRECCION 
														FROM	$$COMPANIA$$.NIT 
														WHERE NIT IN (
																	SELECT NIT FROM
																	ERPADMIN.CONJUNTO
																	WHERE CONJUNTO = ''$$COMPANIA$$'')) Direccion,'
				END
			ELSE
				BEGIN
					SET  @sqlConsulta = @sqlConsulta + 'vtme.direccion AS Direccion, '
				END

			IF @Formato = '2275' 
				BEGIN
					SET  @sqlConsulta = @sqlConsulta + '(SELECT DEPARTAMENTO 
														FROM	$$COMPANIA$$.NIT 
														WHERE NIT IN (
																	SELECT NIT FROM
																	ERPADMIN.CONJUNTO
																	WHERE CONJUNTO = ''$$COMPANIA$$'')) Departamento,'
				END
			ELSE
				BEGIN
					SET  @sqlConsulta = @sqlConsulta + 'vtme.departamento AS Departamento, '
				END

			IF @Formato = '2275' 
				BEGIN
					SET  @sqlConsulta = @sqlConsulta + '(SELECT MUNICIPIO 
														FROM	$$COMPANIA$$.NIT 
														WHERE NIT IN (
																	SELECT NIT FROM
																	ERPADMIN.CONJUNTO
																	WHERE CONJUNTO = ''$$COMPANIA$$'')) Municipio,'
				END
			ELSE
				BEGIN
				set  @sqlConsulta = @sqlConsulta + 'vtme.municipio AS Municipio, '
				END

			 IF @Formato = '2275' 
				BEGIN
					SET  @sqlConsulta = @sqlConsulta + '(SELECT PAIS 
														FROM	$$COMPANIA$$.NIT 
														WHERE NIT IN (
																	SELECT NIT FROM
																	ERPADMIN.CONJUNTO
																	WHERE CONJUNTO = ''$$COMPANIA$$'')) Pais,'
				END
			ELSE
				BEGIN
					SET  @sqlConsulta = @sqlConsulta + ' vtme.pais AS Pais, '
				END
            
			SET  @sqlConsulta = @sqlConsulta +
				'vtme.exterior AS Exterior, 
				Max(sn.fecha) AS Fecha, 
				me.tipo_movimiento AS TipoMovimiento, 
				CASE 
				WHEN (SELECT Sum(me1.tope_formato) 
                     FROM   $$COMPANIA$$.medios_electronicos me1 
                     WHERE  me.formato = me1.formato 
                            AND me.concepto = me1.concepto 
                     GROUP  BY me1.formato, 
                               me1.concepto) = 0 THEN fme.tope 
				ELSE me.tope_formato 
				END AS TopeFormato, '

			SET @sqlConsulta1 =' 
				CASE 
				WHEN (SELECT Sum(me1.tope_concepto) 
						FROM   $$COMPANIA$$.medios_electronicos me1 
						WHERE  me.formato = me1.formato 
						AND me.concepto = me1.concepto 
						GROUP  BY me1.formato, 
                               me1.concepto) = 0 THEN cme.tope 
               ELSE me.tope_concepto END AS TopeConcepto, 
					cme.cuantias_menores AS CuantiasMenores, 
					cme.transacciones_exterior AS ManejaTransaccionesExterior, 
					sn.cuenta_contable AS CuentaContable, 
					me.es_cuenta_devoluciones AS PagoAbonosCtas, 
				(SELECT 
				CASE WHEN me.TIPO_CONTABILIDAD = ''F'' THEN
					Isnull(Sum(Isnull(sn1.saldo_fisc_local, 0)), 0) 
				ELSE 
					Isnull(Sum(Isnull(sn1.SALDO_CORP_LOCAL, 0)), 0) 
					END
				FROM   $$COMPANIA$$.saldo_nit AS sn1 
				WHERE  sn1.nit = sn.nit 
                     AND SN1.centro_costo = SN.centro_costo 
                     AND SN1.cuenta_contable = SN.cuenta_contable 
                     AND CONVERT(DATETIME, sn1.fecha, 103) = (SELECT 
                         Max(sn2.fecha)
						 FROM $$COMPANIA$$.saldo_nit sn2 
                         WHERE sn2.cuenta_contable = sn1.cuenta_contable 
                             AND sn2.centro_costo = sn1.centro_costo 
                             AND sn2.nit = sn1.nit 
                             AND CONVERT(DATETIME, sn2.fecha, 103) < 
                                 CONVERT(DATETIME,'''+ LEFT(CONVERT(VARCHAR, @FechaInicial, 120), 10) +''', 103))) AS SaldoInicial, 
				CASE WHEN me.TIPO_CONTABILIDAD = ''F'' THEN
					Isnull(Sum(Isnull(sn.saldo_fisc_local, 0)), 0) 
				ELSE 
					Isnull(Sum(Isnull(sn.SALDO_CORP_LOCAL, 0)), 0) 
				END
				AS SaldoFinal, 
				CASE WHEN me.pagos_abonos_ctas = ''N'' THEN CASE 
				WHEN me.tipo_movimiento = ''M'' THEN (
					SELECT
						CASE WHEN me.TIPO_CONTABILIDAD = ''F'' THEN
						Isnull(Sum( Isnull(sn1.debito_fisc_local, 0) - Isnull(sn1.credito_fisc_local, 0)), 0) 
						ELSE 
						Isnull(Sum( Isnull(sn1.debito_corp_local, 0) - Isnull(sn1.credito_corp_local, 0)), 0) 
				END
				FROM   $$COMPANIA$$.saldo_nit AS sn1 
				WHERE  sn1.nit = sn.nit 
				AND SN1.centro_costo = SN.centro_costo 
				AND SN1.cuenta_contable = SN.cuenta_contable 
				AND CONVERT(DATETIME, sn1.fecha, 103) BETWEEN 
				CONVERT(DATETIME, '''+ LEFT(CONVERT(VARCHAR, @FechaInicial, 120), 10) +''', 103) AND 
				CONVERT(DATETIME, ''' + LEFT(CONVERT(VARCHAR, @FechaFinal, 120), 10)+''', 111)) 
				ELSE 
				CASE WHEN me.TIPO_CONTABILIDAD = ''F'' THEN
				  Isnull(Sum(Isnull(sn.saldo_fisc_local, 0)), 0) 
			   ELSE 
				Isnull(Sum(Isnull(sn.SALDO_CORP_LOCAL, 0)), 0) 
								END  	 	  
				END - 
				(SELECT Isnull(Sum(Isnull(m.debito_local, 0) - Isnull(m.credito_local, 0)), 0) 
				FROM   $$COMPANIA$$.mayor m 
	  
				WHERE  m.asiento IN (SELECT asiento 
				FROM $$COMPANIA$$.asiento_mayorizado am 
				WHERE  am.fecha = (SELECT Max(am2.fecha) 
				FROM  $$COMPANIA$$.asiento_mayorizado am2 '

			SET @sqlConsulta2 =' 
				WHERE CONVERT(DATETIME, am2.fecha, 103 ) 
				BETWEEN 
				CONVERT(DATETIME, '''+LEFT(CONVERT(VARCHAR, @FechaInicial, 120), 10)+''', 103) 
				AND 
				CONVERT(DATETIME, '''+LEFT(CONVERT(VARCHAR, @FechaFinal, 120), 10)+''', 111)) 
				AND am.clase_asiento IN ( ''C'', ''E'' ) 
				AND am.contabilidad IN ( ''A'', me.tipo_contabilidad )) 
				AND sn.cuenta_contable = m.cuenta_contable 
				AND sn.nit = m.nit 
				AND sn.centro_costo = m.centro_costo)
				*
				CASE 
				WHEN me.cambio_naturaleza = 
				''N'' THEN 1 
				ELSE 
				CASE 
				WHEN me.formato = ''1007''
				THEN 0 
				ELSE -1 
				END 
				END 
				ELSE 0 
				END AS Valor, '

			SET @sqlConsulta3 =' 
				CASE 
				WHEN ( me.formato = ''1001''
				OR me.formato = ''1043'' 
				OR me.formato = ''1007'' ) THEN 
				CASE 
				WHEN ( me.pagos_abonos_ctas = ''N''
				AND ( me.formato = ''1001''
				OR me.formato = ''1043'' ) ) THEN 0 
				ELSE CASE 
				WHEN me.tipo_movimiento = ''M'' THEN 
				(SELECT 
					CASE WHEN me.TIPO_CONTABILIDAD = ''F'' THEN
					Isnull(Sum( Isnull(sn1.debito_fisc_local, 0) - Isnull(sn1.credito_fisc_local, 0)), 0) 
				ELSE 
					Isnull(Sum( Isnull(sn1.debito_corp_local, 0) - Isnull(sn1.credito_corp_local, 0)), 0) 
				END
				FROM   $$COMPANIA$$.saldo_nit AS sn1 
				WHERE  sn1.nit = sn.nit 
				AND SN1.centro_costo = SN.centro_costo 
				AND SN1.cuenta_contable = SN.cuenta_contable 
				AND CONVERT(DATETIME, sn1.fecha, 103) BETWEEN 
				CONVERT(DATETIME, '''+LEFT(CONVERT(VARCHAR, @FechaInicial, 120), 10)+''', 103) AND 
				CONVERT(DATETIME, '''+LEFT(CONVERT(VARCHAR, @FechaFinal, 120), 10)+''', 111)) 
				ELSE   
				CASE WHEN me.TIPO_CONTABILIDAD = ''F'' THEN
					Isnull(Sum(Isnull(sn.saldo_fisc_local, 0)), 0) 
				ELSE 
					Isnull(Sum(Isnull(sn.SALDO_CORP_LOCAL, 0)), 0) 
				END
				END - (SELECT 
				Isnull(Sum(Isnull(m.debito_local, 0) - Isnull(m.credito_local, 0)), 0) 
				FROM   $$COMPANIA$$.mayor m 
				WHERE  m.asiento IN (SELECT asiento 
				FROM   $$COMPANIA$$.asiento_mayorizado am 
				WHERE  am.fecha = (SELECT Max(am2.fecha) 
				FROM 
				$$COMPANIA$$.asiento_mayorizado am2 
				WHERE 
				CONVERT(DATETIME, am2.fecha, 103 ) 
				BETWEEN 
				CONVERT(DATETIME, '''+LEFT(CONVERT(VARCHAR, @FechaInicial, 120), 10)+''', 103) 
				AND 
				CONVERT(DATETIME, '''+LEFT(CONVERT(VARCHAR, @FechaFinal, 120), 10)+''', 111)) 
				AND am.clase_asiento IN ( ''C'', ''E'' ) 
				AND am.contabilidad IN ( ''A'', me.tipo_contabilidad )) 
				AND sn.cuenta_contable = m.cuenta_contable 
				AND sn.nit = m.nit 
				AND sn.centro_costo = m.centro_costo) - (SELECT 
				Isnull(Sum(Isnull(m.debito_local, 0) - Isnull(m.credito_local, 0)), 0) 
                FROM 
				$$COMPANIA$$.mayor m '
      
			SET @sqlConsulta4 ='
				WHERE m.asiento IN (SELECT asiento 
				FROM   $$COMPANIA$$.valor_adicional_me vam 
				LEFT JOIN	$$COMPANIA$$.medios_electronicos mevam
				ON vam.tipo_impuesto = mevam.tipo_impuesto
				WHERE  CONVERT(DATETIME, vam.fecha, 103) BETWEEN 
				CONVERT(DATETIME, '''+LEFT(CONVERT(VARCHAR, @FechaInicial, 120), 10)+''', 103) 
				AND 
				CONVERT(DATETIME, '''+LEFT(CONVERT(VARCHAR, @FechaFinal, 120), 10)+''', 111) 
				AND m.asiento = vam.asiento 
				AND m.consecutivo = vam.consecutivo 
				AND vam.iva_mayor_valor_costo = ''S''
				AND isnull (VAM.TIPO_IMPUESTO,''TIPOIMPUESTO'') = 
													case when me.TIPO_IMPUESTO is not null then
													me.TIPO_IMPUESTO
													else
													isnull(vam.TIPO_IMPUESTO,''TIPO_IMPUESTO'')
													end) 
				AND sn.cuenta_contable = m.cuenta_contable 
				AND sn.nit = m.nit 
				AND sn.centro_costo = m.centro_costo) * CASE 
				WHEN 
				me.cambio_naturaleza = ''S'' THEN -1 
				ELSE 
				CASE 
				WHEN me.formato = ''1007'' THEN 0 
				ELSE 1 
				END 
				END 
				END 
				ELSE (SELECT Isnull(Sum(Isnull(CASE 
				WHEN ( BASE.debito_local IS NULL ) THEN 
				BASE.base_local 
				ELSE ( BASE.base_local * -1 ) 
				END, 0)), 0) 
				FROM   $$COMPANIA$$.mayor AS BASE 
				WHERE  BASE.nit = sn.nit
				AND BASE.Contabilidad IN ( ''A'', me.tipo_contabilidad ) 
				AND BASE.centro_costo = sn.centro_costo 
				AND BASE.cuenta_contable = sn.cuenta_contable 
				AND CONVERT(DATETIME, BASE.fecha, 103) BETWEEN 
				CONVERT(DATETIME, '''+LEFT(CONVERT(VARCHAR, @FechaInicial, 120), 10)+''', 103) AND 
				CONVERT(DATETIME, '''+LEFT(CONVERT(VARCHAR, @FechaFinal, 120), 10)+''', 111)) 
				END AS ValorBase, 
				sn.centro_costo, 
				sn.nit,'

	
	 IF @Formato = '2276' or @Formato = '2280'
		BEGIN
			SET @sqlConsulta4 = @sqlConsulta4 +'
								'''+LEFT(CONVERT(VARCHAR, @FechaInicial, 120), 10)+''',
								'''+LEFT(CONVERT(VARCHAR, @FechaFinal, 120), 10)+''','
		END
	ELSE
	  BEGIN
			SET @sqlConsulta4 = @sqlConsulta4 +
								'null,
								null,'
	END

	  IF @Formato = '2275'
		BEGIN
			SET  @sqlConsulta4 = @sqlConsulta4 + '(SELECT CORREO 
													FROM	$$COMPANIA$$.NIT 
													WHERE NIT IN (
																	SELECT NIT FROM
																	ERPADMIN.CONJUNTO
																	WHERE CONJUNTO = ''$$COMPANIA$$'')) Email'
		END
	ELSE
	  BEGIN
			SET @sqlConsulta4 = @sqlConsulta4 +
						   'vtme.correo Email'
	END

	IF @Formato = '2280'
		BEGIN
			SET @sqlConsulta4 = @sqlConsulta4 +
						   ',emp.tipo_medidas_certificadas TipoMedida
						    ,puesto.descripcion TipoContrato
							,(DATEDIFF(day,emp.FECHA_NACIMIENTO,getdate())/365 ) edad
							,emp.tipo_nivel_educativo NivelEducativo'
		END
	ELSE
		BEGIN
			SET @sqlConsulta4 = @sqlConsulta4 +
						   ',null
							,null
							,null
							,null'
		END

	SET @sqlConsulta4 = @sqlConsulta4 +
						   ',me.tipo_impuesto'

	SET @sqlConsulta4 = @sqlConsulta4 + '
			FROM	$$COMPANIA$$.nit vtme, 
					$$COMPANIA$$.saldo_nit sn, 
					$$COMPANIA$$.medios_electronicos me, 
					$$COMPANIA$$.formatos_me fme, 
					$$COMPANIA$$.conceptos_me cme'

	IF @Formato = '2276' or @Formato = '2280'
		BEGIN
			SET @sqlConsulta4 = 
								@sqlConsulta4	+ ' , $$COMPANIA$$.EMPLEADO emp'
		END

	IF  @Formato = '2280'
		BEGIN
			SET @sqlConsulta4 = 
								@sqlConsulta4	+ ' , $$COMPANIA$$.PUESTO puesto'
		END
     
	SET @strSQLWhereQuery = @strSQLWhereQuery +' WHERE  sn.cuenta_contable BETWEEN me.cuenta_contable_ini   
			 AND  me.cuenta_contable_fin 
             AND sn.nit = vtme.nit 
             AND CONVERT(DATETIME, sn.fecha, 103) = (SELECT Max(fecha) 
                                                     FROM 
                 $$COMPANIA$$.saldo_nit sn2 
                                                     WHERE 
                     sn2.cuenta_contable = sn.cuenta_contable 
                     AND sn2.centro_costo = sn.centro_costo 
                     AND sn2.nit = vtme.nit 
                     AND CONVERT(DATETIME, sn2.fecha, 103) <= 
                         CONVERT(DATETIME, '''+LEFT(CONVERT(VARCHAR, @FechaFinal, 120), 10)+''', 111)) 
             AND fme.formato = me.formato 
             AND cme.concepto = me.concepto 
             AND me.formato = ''' + @Formato + ''''
			 
	
	IF @Formato = '2276' or @Formato = '2280'
		BEGIN
			SET @strSQLWhereQuery = 
								@strSQLWhereQuery	+ ' AND EMP.nit = vtme.nit'
		END
	IF @Formato = '2280'
		BEGIN
			SET @strSQLWhereQuery = 
								@strSQLWhereQuery	+ ' AND EMP.nit = vtme.nit'
		END
	IF @Formato = '2280'
		BEGIN
			SET @strSQLWhereQuery = 
								@strSQLWhereQuery	+ ' AND EMP.puesto = puesto.puesto 
														AND EMP.TIPO_MEDIDAS_CERTIFICADAS IS NOT NULL
													    AND EMP.TIPO_MEDIDAS_CERTIFICADAS != 0'
		END
	SET @strSQLGroupQuery = '		 
      GROUP  BY me.formato, 
                me.concepto, 
                me.valor_a_mostrar, 
                vtme.tipo_documento, 
                vtme.clase_documento, 
                vtme.numero_doc_nit, 
                vtme.digito_verificador, 
                vtme.primer_apellido, 
                vtme.segundo_apellido, 
                vtme.primer_nombre, 
                vtme.segundo_nombre, 
                vtme.razon_social, 
                vtme.direccion, 
                vtme.departamento, 
                vtme.municipio, 
                vtme.pais, 
                vtme.exterior, 
                sn.nit, 
                sn.centro_costo, 
                sn.cuenta_contable, 
                me.es_cuenta_devoluciones, 
                me.pagos_abonos_ctas, 
                me.tipo_movimiento, 
                me.cambio_naturaleza, 
                fme.tope, 
                cme.tope, 
                cme.cuantias_menores, 
                cme.transacciones_exterior, 
                me.formato, 
                me.concepto, 
                me.tope_concepto, 
                me.tope_formato,
				vtme.correo,
				me.tipo_impuesto,
				me.tipo_contabilidad'

	  IF @Formato = '2280'
	  BEGIN
			SET @strSQLGroupQuery = @strSQLGroupQuery + ',
				emp.TIPO_MEDIDAS_CERTIFICADAS,
				puesto.descripcion,
				emp.tipo_nivel_educativo,
				emp.fecha_nacimiento'
	  END 


	EXEC ( @sqlInsert + @sqlConsulta + @sqlConsulta1 + @sqlConsulta2 + @sqlConsulta3 + @sqlConsulta4 + @strSQLWhereQuery + @strSQLGroupQuery)

  END;

REMARK 
\
------------------------------------------------------------------ 
Función MEConsultaRetenciones para calcular las rentenciones
------------------------------------------------------------------
/
CREATE FUNCTION $$COMPANIA$$.MEConsultaRetenciones(
		@Formato as Varchar(4),
		@Concepto as Varchar(5),
		@Nit as varchar(20),
		@FechaInicial as DateTime,
		@FechaFinal as DateTime
 )
 RETURNS decimal(28,8)
 AS
 BEGIN
 DECLARE @montoRetencion DECIMAL(28,8)
 SELECT @montoRetencion= isnull(SUM(me.Valor),0) 
			FROM $$COMPANIA$$.MEConsultaAgrupada  ( @Formato, @FechaInicial, @FechaFinal)  me
			WHERE me.ValorAMostrar in ( 'RETP', 'RETA', 'COMUN', 'SIMP', 'NDOM')
			and me.Formato = @Formato
			and me.Concepto = @Concepto
			and me.Nit = @Nit
			
RETURN @montoRetencion			
END;


REMARK 
\
------------------------------------------------------------------ 
Consulta de Medios Electrónicos Topes sean sobrepasados por el valor
------------------------------------------------------------------
/
CREATE FUNCTION $$COMPANIA$$.METopesMax1001
  (
   @Formato as Varchar(4),
   @FechaInicial as DateTime,
   @FechaFinal as DateTime
  )
  RETURNS TABLE
  AS
  RETURN
   SELECT me.Concepto, me.TipoDocumento, me.Nit, me.DigitoVerificacion,  me.ValorAMostrar,
     me.PrimerApellido, me.SegundoApellido, me.PrimerNombre, me.SegundoNombre, me.RazonSocial,
     me.Direccion, me.Departamento, me.Municipio, me.Exterior, me.Pais, me.CuentaContable, me.PagoAbonosCtas,
     me.SaldoInicial, me.SaldoFinal, me.Valor, me.ValorBase,
  CONVERT(char(10),me.FechaInicio,126) FechaInicio, 
    CONVERT(char(10),me.FechaFinal,126) FechaFinal,   '' FechaExpedicion,'' NumeroEntidades,me.Email,
    me.TipoMedida,me.CargoContrato,me.Edad,me.NivelEducativo, me.TipoImpuesto
   FROM $$COMPANIA$$.MEConsultaAgrupada( @Formato, @FechaInicial, @FechaFinal) me inner join
     (SELECT me2.Formato, me2.Concepto, me2.Nit, me2.ValorAMostrar, SUM(me2.Valor) Valor
      FROM $$COMPANIA$$.MEConsultaAgrupada ( @Formato, @FechaInicial, @FechaInicial) me2
      WHERE me2.TopeConcepto > 0
      AND me2.TopeConcepto > me2.TopeFormato
      AND (me2.exterior = '0' or (me2.exterior = '1' and me2.ManejaTransaccionesExterior = 'N'))
      group by me2.Formato, me2.Concepto, me2.Nit, me2.ValorAMostrar,me2.FechaInicio,me2.FechaFinal) me2  
      on me.Formato = me2.Formato and me.Concepto = me2.Concepto and me.Nit = me2.Nit and me.ValorAMostrar = me2.ValorAMostrar
   WHERE me.TopeConcepto > 0
   and (me.TopeConcepto < me2.Valor or (me.TopeConcepto > me2.Valor AND 0 <> $$COMPANIA$$.MEConsultaRetenciones(@Formato, me.Concepto, me.Nit, @FechaInicial, @FechaFinal)))
   UNION
   SELECT me.Concepto, me.TipoDocumento, me.Nit, me.DigitoVerificacion,  me.ValorAMostrar, 
     me.PrimerApellido, me.SegundoApellido, me.PrimerNombre, me.SegundoNombre, me.RazonSocial,
     me.Direccion, me.Departamento, me.Municipio, me.Exterior, me.Pais, me.CuentaContable, me.PagoAbonosCtas,
     me.SaldoInicial, me.SaldoFinal, me.Valor, me.ValorBase,
  CONVERT(char(10),me.FechaInicio,126) FechaInicio, 
    CONVERT(char(10),me.FechaFinal,126) FechaFinal,
     '' FechaExpedicion,'' NumeroEntidades,me.Email,me.TipoMedida,me.CargoContrato,me.Edad,me.NivelEducativo, me.TipoImpuesto
   FROM $$COMPANIA$$.MEConsultaAgrupada( @Formato, @FechaInicial, @FechaFinal) me inner join
    (SELECT me2.Formato, me2.Nit, me2.ValorAMostrar, SUM(me2.Valor) Valor
     FROM $$COMPANIA$$.MEConsultaAgrupada( @Formato, @FechaInicial, @FechaFinal) me2  
     where me2.TopeFormato > 0 
     AND me2.TopeConcepto < me2.TopeFormato
     AND(me2.exterior = '0' or (me2.exterior = '1' and me2.ManejaTransaccionesExterior = 'N'))
     group by me2.Formato, me2.Nit, me2.ValorAMostrar, me2.FechaInicio,me2.FechaFinal) me2  
     on me.Formato = me2.Formato and me.Nit = me2.Nit and me.ValorAMostrar = me2.ValorAMostrar
   WHERE me.TopeFormato > 0
   and (me.TopeFormato < me2.Valor 
   or (me.TopeFormato > me2.Valor 
   AND 0 <> $$COMPANIA$$.MEConsultaRetenciones(@Formato, me.Concepto, me.Nit, @FechaInicial, @FechaFinal)));
	
REMARK 
\
------------------------------------------------------------------ 
Consulta de Medios Electrónicos, Topes de formato mayor al valor y tope concepto = 0
------------------------------------------------------------------
/
CREATE FUNCTION $$COMPANIA$$.MECuantiaMenorConcepto1001
 (
   @Formato as Varchar(4),
   @FechaInicial as DateTime,
   @FechaFinal as DateTime,
   @TipoDocCM as Varchar(2),
   @NitCM as Varchar(20),
   @DescripNitCM as Varchar(100),
   @Direccion as Varchar(3000),
   @Departamento as VARCHAR(2),
   @Municipio as Varchar(3),
   @Pais as Varchar(4)
  )
  RETURNS TABLE
  AS
  RETURN
  SELECT me.Concepto, @TipoDocCM TipoDocumento, @NitCM Nit, '' DigitoVerificacion,  me.ValorAMostrar, 
    '' PrimerApellido, '' SegundoApellido, '' PrimerNombre, '' SegundoNombre,
    @DescripNitCM RazonSocial, @Direccion Direccion, @Departamento Departamento, @Municipio Muncipio,  
    me.Exterior, @Pais Pais, me.CuentaContable, me.PagoAbonosCtas,
    sum(me.SaldoInicial) SaldoInicial,  sum(me.SaldoFinal) SaldoFinal, SUM(me.Valor) Valor, SUM(me.ValorBase) ValorBase,
       CONVERT(char(10),me.FechaInicio,126) FechaInicio, 
      CONVERT(char(10),me.FechaFinal,126) FechaFinal,
   '' FechaExpedicion,
    '' NumeroEntidades,me.Email, me.TipoMedida,me.CargoContrato,me.Edad,me.NivelEducativo, me.TipoImpuesto
  FROM $$COMPANIA$$.MEConsultaAgrupada( @Formato, @FechaInicial, @FechaFinal) me inner join
    (SELECT me2.Formato, me2.Concepto, me2.Nit, me2.ValorAMostrar, SUM(me2.Valor) Valor
     FROM $$COMPANIA$$.MEConsultaAgrupada ( @Formato, @FechaInicial, @FechaFinal) me2
     WHERE me2.CuantiasMenores = 'S'
     AND me2.TopeConcepto > 0
     AND me2.TopeConcepto > me2.TopeFormato
     AND (me2.exterior = '0' or (me2.exterior = '1' and me2.ManejaTransaccionesExterior = 'N'))
     group by me2.Formato, me2.Concepto, me2.Nit, me2.ValorAMostrar) me2  
     on me.Formato = me2.Formato and me.Concepto = me2.Concepto and me.Nit = me2.Nit and me.ValorAMostrar = me2.ValorAMostrar
  WHERE me.TopeConcepto >= me2.valor  
  AND 0 = $$COMPANIA$$.MEConsultaRetenciones(@Formato, me.Concepto, me.Nit, @FechaInicial, @FechaFinal) 
  GROUP BY me.Concepto, me.ValorAMostrar, me.Exterior, me.CuentaContable, me.PagoAbonosCtas,
   me.FechaInicio,me.FechaFinal,me.Email,me.TipoMedida,me.CargoContrato,me.Edad,me.NivelEducativo,me.TipoImpuesto ;



REMARK 
\
------------------------------------------------------------------ 
Consulta de Medios Electrónicos, Topes de formato mayor al valor y tope concepto = 0
------------------------------------------------------------------
/

CREATE FUNCTION $$COMPANIA$$.MECuantiaMenorNitMenorFormato1001
 (
   @Formato as Varchar(4),
   @FechaInicial as DateTime,
   @FechaFinal as DateTime,
   @TipoDocCM as Varchar(2),
   @NitCM as Varchar(20),
   @DescripNitCM as Varchar(100),
   @Direccion as Varchar(3000),
   @Departamento as VARCHAR(2),
   @Municipio as Varchar(3),
   @Pais as Varchar(4)
  )
  RETURNS TABLE
  AS
  RETURN
  SELECT me.Concepto, @TipoDocCM TipoDocumento, @NitCM Nit, '' DigitoVerificacion,  me.ValorAMostrar, 
    '' PrimerApellido, '' SegundoApellido, '' PrimerNombre, '' SegundoNombre,
    @DescripNitCM RazonSocial, @Direccion Direccion, @Departamento Departamento, @Municipio Muncipio, 
    me.Exterior, @Pais Pais, me.CuentaContable, me.PagoAbonosCtas,
    sum(me.SaldoInicial) SaldoInicial,  sum(me.SaldoFinal) SaldoFinal, SUM(me.Valor) Valor, SUM(me.ValorBase) ValorBase,
       CONVERT(char(10),me.FechaInicio,126) FechaInicio, 
       CONVERT(char(10),me.FechaFinal,126) FechaFinal,
       '' FechaExpedicion,
    '' NumeroEntidades,me.Email,me.TipoMedida,me.CargoContrato,me.Edad,me.NivelEducativo, me.TipoImpuesto
  FROM $$COMPANIA$$.MEConsultaAgrupada( @Formato, @FechaInicial, @FechaFinal) me inner join
    (SELECT me2.Formato, me2.Nit, me2.ValorAMostrar, SUM(me2.Valor) Valor
     FROM $$COMPANIA$$.MEConsultaAgrupada ( @Formato, @FechaInicial, @FechaFinal) me2
     WHERE me2.CuantiasMenores = 'S'
     AND me2.TopeFormato > 0
     AND me2.TopeFormato > me2.TopeConcepto
    AND (me2.exterior = '0' or (me2.exterior = '1' and me2.ManejaTransaccionesExterior = 'N'))
     group by me2.Formato, me2.Nit, me2.ValorAMostrar) me2  
     on me.Formato = me2.Formato and me.Nit = me2.Nit and me.ValorAMostrar = me2.ValorAMostrar
  WHERE me.TopeFormato >= me2.Valor
  AND 0 = $$COMPANIA$$.MEConsultaRetenciones(@Formato, me.Concepto, me.Nit, @FechaInicial, @FechaFinal)
  Group by me.Concepto, me.ValorAMostrar, me.Exterior, me.CuentaContable, me.PagoAbonosCtas,
   me.FechaInicio,me.FechaFinal,me.Email,me.TipoMedida,me.CargoContrato,me.Edad,me.NivelEducativo,me.TipoImpuesto;

REMARK 
\
------------------------------------------------------------------ 
Consulta de AcumuladoConceptos
------------------------------------------------------------------
/
CREATE PROCEDURE $$COMPANIA$$.AcumuladoConceptos
(@EMPLEADO AS VARCHAR(100), @FECHAINICIAL AS DATETIME, @FECHAFINAL AS DATETIME, @FECHAMIN AS DATETIME, @CONCEPTOS AS VARCHAR(MAX), @LIQUIDACION AS VARCHAR(MAX),  @VALOR AS DECIMAL(28,8) OUTPUT ) 
/*RETURNS DECIMAL(28,8)*/
AS 
BEGIN
DECLARE @SQL NVARCHAR(MAX)
DECLARE @VALUE DECIMAL(28,8)
DECLARE @VAL DECIMAL(28,8)
DECLARE @VALUE2 DECIMAL(28,8)
DECLARE @VAL2 DECIMAL(28,8)

IF @LIQUIDACION = 'N'
BEGIN
SET @SQL = 'DECLARE @MONTO AS DECIMAL(28,8) '

  SET @SQL = @SQL + ' SELECT @MONTO = SUM(ecn.total)
FROM $$COMPANIA$$.empleado_conc_nomi ecn,$$COMPANIA$$.concepto c,$$COMPANIA$$.nomina_historico nh
WHERE ecn.concepto = c.concepto
      AND ecn.nomina =  nh.nomina
      AND ecn.numero_nomina = nh.numero_nomina
      AND ecn.empleado = ''' + @EMPLEADO +  '''
      AND nh.periodo >=  ''' + CONVERT(NVARCHAR(75),@FECHAINICIAL, 111) + '''
      AND nh.periodo <= DATEADD(MS, -1, DATEADD(D, 1, CONVERT(DATETIME2, ''' + CONVERT(NVARCHAR(75),@FECHAFINAL, 111) + ''' )) )
      AND nh.fecha_aprobacion <> ''' + CONVERT(NVARCHAR(75),@FECHAMIN, 111) + '''
      AND nh.fecha_aplicacion IS NOT NULL AND c.concepto IN (' + @CONCEPTOS +
	  ' ) AND  ( c.concepto  = c.concepto   ) '
     
	 SET @SQL = @SQL + ' SELECT @VALUE = ISNULL(@MONTO,0) '

	 EXECUTE SP_EXECUTESQL @SQL, N'@VALUE DECIMAL(28,8) OUTPUT', @VALUE = @VAL OUTPUT
	 SET @VALOR = @VAL
	 END
IF @LIQUIDACION = 'S'
BEGIN
SET @SQL = 'DECLARE @MONTO AS DECIMAL(28,8) '

  SET @SQL = @SQL + ' SELECT @MONTO = SUM(ecn.total)
FROM $$COMPANIA$$.empleado_conc_nomi ecn,$$COMPANIA$$.concepto c,$$COMPANIA$$.nomina_historico nh
WHERE ecn.concepto = c.concepto
      AND ecn.nomina =  nh.nomina
      AND ecn.numero_nomina = nh.numero_nomina
      AND ecn.empleado = ''' + @EMPLEADO +  '''
      AND nh.periodo >=  ''' + CONVERT(NVARCHAR(75),@FECHAINICIAL, 111) + '''
      AND nh.periodo <= DATEADD(MS, -1, DATEADD(D, 1, CONVERT(DATETIME2, ''' + CONVERT(NVARCHAR(75),@FECHAFINAL, 111) + ''' )) )
      AND nh.fecha_aprobacion <> ''' + CONVERT(NVARCHAR(75),@FECHAMIN, 111) + '''
      AND nh.fecha_aplicacion IS NOT NULL AND c.concepto IN (' + @CONCEPTOS +
	  ' ) AND  ( c.concepto  = c.concepto   ) '
     
	 SET @SQL = @SQL + ' SELECT @VALUE = ISNULL(@MONTO,0) '

	 EXECUTE SP_EXECUTESQL @SQL, N'@VALUE DECIMAL(28,8) OUTPUT', @VALUE = @VAL OUTPUT
	 /*SET @VALOR = @VAL*/

  SET @SQL = 'DECLARE @MONTOLIQ AS DECIMAL(28,8) '
  SET @SQL = @SQL + ' SELECT @MONTOLIQ = SUM( lc.total_calculado )
 FROM $$COMPANIA$$.empleado e,$$COMPANIA$$.liquidacion l,$$COMPANIA$$.concepto c,$$COMPANIA$$.liquidacion_concep lc
WHERE e.empleado = ''' + @EMPLEADO +  '''
	  AND e.empleado = l.empleado
      AND l.liquidacion = lc.liquidacion
      AND lc.concepto = c.concepto
	  AND ( l.estado_liquidac = ''L'' OR l.estado_liquidac = ''G'' )
      AND l.fecha_retiro_pago >=  ''' + CONVERT(NVARCHAR(75),@FECHAINICIAL, 111) + '''
      AND l.fecha_retiro_pago <= DATEADD(MS, -1, DATEADD(D, 1, CONVERT(DATETIME2, ''' + CONVERT(NVARCHAR(75),@FECHAFINAL, 111) + ''' )) )
      AND c.concepto IN (' + @CONCEPTOS +
	  ' ) AND  ( c.concepto  = c.concepto   ) '

	  SET @SQL = @SQL + ' SELECT @VALUE2 = ISNULL(@MONTOLIQ,0) '

	 EXECUTE SP_EXECUTESQL @SQL, N'@VALUE2 DECIMAL(28,8) OUTPUT', @VALUE2 = @VAL2 OUTPUT
	 SET @VALOR = @VAL + @VAL2
	 END

	 END;


CREATE PROCEDURE $$COMPANIA$$.ConsultaCNME
 (
   @FECHAINICIAL as DATETIME,
   @FECHAFINAL as DATETIME,
   @FECHAMIN AS DATETIME,
   @INGRESOSBRUTOS AS VARCHAR(MAX),
   @DEDUCCIONESBRUTOS AS VARCHAR(MAX),
   @CESANTIAS AS VARCHAR(MAX),
   @GASTOSREP AS VARCHAR(MAX),
   @JUBILACION AS VARCHAR(MAX),
   @OTROSINGRESOS AS VARCHAR(MAX),
   @TOTALBRUTOS AS VARCHAR(MAX),
   @OBLSALUD AS VARCHAR(MAX),
   @OBLPENSION AS VARCHAR(MAX),
   @VOLPENSION AS VARCHAR(MAX),
   @RETENCION AS VARCHAR(MAX),
   @USUARIO AS VARCHAR(MAX),
   @EMPLEADOLIKE AS NVARCHAR(MAX),
   @NOMINALIKE AS NVARCHAR(MAX),
   @CENTROCOSTOLIKE AS NVARCHAR(MAX),
   @DEPARTAMENTOLIKE AS NVARCHAR(MAX),
   @ESTADOLIKE AS NVARCHAR(MAX),
   @UBICACIONLIKE AS NVARCHAR(MAX),
   @FECHAINGRESOINICIAL AS DATETIME,
   @FECHAINGRESOFINAL AS DATETIME,
   @FECHASALIDAINICIAL AS DATETIME,
   @FECHASALIDAFINAL AS DATETIME,
   @EMPPOSTERIORES AS NVARCHAR(MAX),
   @LIQUIDACIONES AS NVARCHAR(MAX)
   )
 /*RETURNS DECIMAL(28,8)*/
 AS 
 BEGIN
 
 DECLARE @TIPO_DOCUMENTO varchar(max), 
     @NIT varchar(max), 
 	@PRIMER_APELLIDO varchar(max), 
 	@SEGUNDO_APELLIDO varchar(max), 
 	@PRIMER_NOMBRE varchar(max),  
     @SEGUNDO_NOMBRE varchar(max), 
 	@DIRECCION varchar(max), 
 	@DEPARTAMENTO varchar(max), 
 	@MUNICIPIO varchar(max), 
 	@PAIS varchar(max), 
 	@CORREO varchar(max), 
     @FECHAINICIALT datetime, 
 	@FECHAFINALT datetime, 
 	@FECHAEXP datetime, 
 	@DEPTORET varchar(max), 
 	@MUNRET varchar(max), 
 	@ENTIDADES int, 
 	@INGRESOSSALARIALES decimal(28,8),
 	@DEDUCCIONESSALARIALES decimal(28,8),
 	@CESANTIAST decimal(28,8), 
 	@GASTOSREPT decimal(28,8), 
 	@JUBILACIONT decimal(28,8), 
 	@OTROSINGRESOST decimal(28,8), 
 	@TOTALBRUTOST decimal(28,8),
 	@OBLSALUDT decimal(28,8), 
 	@OBLPENSIONT decimal(28,8), 
 	@VOLPENSIONT decimal(28,8), 
 	@RETENCIONT decimal(28,8),
 	@EMPLEADO AS VARCHAR(100),
 	@VALOR AS DECIMAL(28,8),
 	@SQL AS NVARCHAR(MAX),
 	@TABLA AS NVARCHAR(MAX),
 	@BLANCO AS NVARCHAR(MAX)
 
 	SET @BLANCO = ''''''
 	SET @TABLA = 'TEMP' + @USUARIO
 
 SET @SQL = '
 create table ' + @TABLA + '
 (
 	TIPO_DOCUMENTO varchar(max), 
 	NIT varchar(max), 
 	PRIMER_APELLIDO varchar(max), 
 	SEGUNDO_APELLIDO varchar(max), 
 	PRIMER_NOMBRE varchar(max),  
     SEGUNDO_NOMBRE varchar(max),  
     FECHAINICIAL datetime, 
 	FECHAFINAL datetime, 
 	FECHAEXP datetime, 
 	DEPTORET varchar(max), 
 	MUNRET varchar(max), 
 	ENTIDADES int, 
 	INGRESOSSALARIALES decimal(28,8),
 	DEDUCCIONESSALARIALES decimal(28,8),
 	CENSATIAS decimal(28,8), 
 	GASTOSREP decimal(28,8), 
 	JUBILACION decimal(28,8), 
 	OTROSINGRESOS decimal(28,8), 
 	TOTALBRUTOS decimal(28,8),
 	OBLSALUD decimal(28,8), 
 	OBLPENSION decimal(28,8), 
 	VOLPENSION decimal(28,8), 
 	RETENCION decimal(28,8)
 ) '
 
 EXEC SP_EXECUTESQL @SQL
 SET @SQL = ''
 
 SET @SQL = 'DECLARE CNME CURSOR FOR '
 SET @SQL = @SQL + 'SELECT  i.TIPO_DOCUMENTO, i.NIT, i.PRIMER_APELLIDO, i.SEGUNDO_APELLIDO, i.PRIMER_NOMBRE,  
         i.SEGUNDO_NOMBRE,
 		ERPADMIN.SF_GETDATE() FECHAINICIAL, ERPADMIN.SF_GETDATE() FECHAFINAL, ERPADMIN.SF_GETDATE() FECHAEXP, '''' DEPTORET, '''' MUNRET, 0 ENTIDADES,
 		0 INGRESOSSALARIALES,
 		0 DEDUCCIONESSALARIALES,
 		0 CENSATIAS, 
 		0 GASTOSREP, 
 		0 JUBILACION, 
 		0 OTROSINGRESOS, 
 		0 TOTALBRUTOS,
 		0 OBLSALUD, 
 		0 OBLPENSION, 
 		0 VOLPENSION, 
 		0 RETENCION,
 		e.EMPLEADO
                             FROM 	$$COMPANIA$$.empleado e left join $$COMPANIA$$.NIT i ON e.NIT = i.NIT '
 							SET @SQL = @SQL + ' WHERE	( ( e.fecha_salida = CONVERT(DATETIME,''' + CONVERT(NVARCHAR,@FECHAMIN) + ''', 111) ) OR (e.fecha_salida IS NULL ) OR  
                             	( e.fecha_salida >= CONVERT(DATETIME,''' + CONVERT(NVARCHAR,@FECHAINICIAL) + ''', 111) )) '
 
 							/*DATEADD(MS, -1, DATEADD(D, 1, CONVERT(DATETIME2, @d)))*/
 
 							IF(@EMPPOSTERIORES = 'S')
 							SET @SQL = @SQL + ' AND	e.fecha_ingreso <= DATEADD(MS, -1, DATEADD(D, 1, CONVERT(DATETIME2,''' +  CONVERT(NVARCHAR,@FECHAFINAL) + ''')) ) '
 							IF (@EMPLEADOLIKE IS NOT NULL) AND (@EMPLEADOLIKE != @BLANCO)
 							SET @SQL = @SQL + ' AND (E.EMPLEADO IN ( ' + @EMPLEADOLIKE + ' ) ) '	
 							IF (@NOMINALIKE IS NOT NULL) AND (@NOMINALIKE != @BLANCO)
 							SET @SQL = @SQL + ' AND (E.NOMINA IN ( ' + @NOMINALIKE + ' ) ) '
 							IF (@CENTROCOSTOLIKE IS NOT NULL) AND (@CENTROCOSTOLIKE != @BLANCO)
 							SET @SQL = @SQL + ' AND (E.CENTRO_COSTO IN ( ' + @CENTROCOSTOLIKE + ' ) ) '
 							IF (@DEPARTAMENTOLIKE IS NOT NULL) AND (@DEPARTAMENTOLIKE != @BLANCO)
 							SET @SQL = @SQL + ' AND (E.DEPARTAMENTO IN ( ' + @DEPARTAMENTOLIKE + ' ) ) '
 							IF (@ESTADOLIKE IS NOT NULL) AND (@ESTADOLIKE != @BLANCO)
 							SET @SQL = @SQL + ' AND (E.ESTADO_EMPLEADO IN ( ' + @ESTADOLIKE + ') ) '
 							IF (@UBICACIONLIKE IS NOT NULL) AND (@UBICACIONLIKE != @BLANCO)
 							SET @SQL = @SQL + ' AND (E.UBICACION IN ( ' + @UBICACIONLIKE + ') ) '
 							IF (@FECHAINGRESOINICIAL IS NOT NULL) AND (@FECHAINGRESOINICIAL != '1980-01-01 00:00:00.000')
 							SET @SQL = @SQL + ' AND e.fecha_ingreso >= CONVERT(DATETIME,''' + CONVERT(NVARCHAR,@FECHAINGRESOINICIAL) + ''', 111) '
 							IF (@FECHAINGRESOFINAL IS NOT NULL) AND (@FECHAINGRESOFINAL != '1980-01-01 00:00:00.000')
 							SET @SQL = @SQL + ' AND e.fecha_ingreso <= CONVERT(DATETIME,''' + CONVERT(NVARCHAR,@FECHAINGRESOFINAL) + ''', 111) '
 							IF (@FECHASALIDAINICIAL IS NOT NULL) AND (@FECHASALIDAINICIAL != '1980-01-01 00:00:00.000')
 							SET @SQL = @SQL + ' AND e.fecha_salida >= CONVERT(DATETIME,''' + CONVERT(NVARCHAR,@FECHASALIDAINICIAL) + ''', 111) '
 							IF (@FECHASALIDAFINAL IS NOT NULL) AND (@FECHASALIDAFINAL != '1980-01-01 00:00:00.000')
 							SET @SQL = @SQL + ' AND e.fecha_salida >= CONVERT(DATETIME,''' + CONVERT(NVARCHAR,@FECHASALIDAFINAL) + ''', 111) '
 
 
 							 
 							SET @SQL = @SQL + ' group by  i.TIPO_DOCUMENTO, i.Nit,   
                                i.PRIMER_APELLIDO, i.SEGUNDO_APELLIDO, i.PRIMER_NOMBRE, i.SEGUNDO_NOMBRE,   
                                e.EMPLEADO '
 
 EXEC SP_EXECUTESQL @SQL
 SET @SQL = ''
 
 OPEN CNME
 FETCH NEXT FROM CNME INTO @TIPO_DOCUMENTO ,@NIT , @PRIMER_APELLIDO , @SEGUNDO_APELLIDO, 
 	@PRIMER_NOMBRE  ,   @SEGUNDO_NOMBRE /*,@DIRECCION  ,@DEPARTAMENTO  ,@MUNICIPIO ,
 	@PAIS ,@CORREO */ ,@FECHAINICIALT  ,@FECHAFINALT,  @FECHAEXP , @DEPTORET , 
 	@MUNRET , @ENTIDADES,  
 	@INGRESOSSALARIALES ,@DEDUCCIONESSALARIALES ,@CESANTIAST , @GASTOSREPT , @JUBILACIONT , @OTROSINGRESOST , 
 	@TOTALBRUTOST ,@OBLSALUDT , @OBLPENSIONT , @VOLPENSIONT , @RETENCIONT, @EMPLEADO 
 
 while @@FETCH_STATUS = 0
 begin
 
 /*INGRESOS SALARIALES*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @INGRESOSBRUTOS, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @INGRESOSSALARIALES = @VALOR
 /*DEDUCCIONES SALARIALES*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @DEDUCCIONESBRUTOS, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @DEDUCCIONESSALARIALES = @VALOR
 SET @INGRESOSSALARIALES = ( @INGRESOSSALARIALES - @DEDUCCIONESSALARIALES)
 /*CESANTIAS*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @CESANTIAS, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @CESANTIAST = @VALOR
 /*GASTOSREP*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @GASTOSREP, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @GASTOSREPT = @VALOR
 /*JUBILACION*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @JUBILACION, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @JUBILACIONT = @VALOR
 /*OTROSINGRESOS*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @OTROSINGRESOS, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @OTROSINGRESOST = @VALOR
 /*TOTALBRUTOS*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @TOTALBRUTOS, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @TOTALBRUTOST = @VALOR
 /*OBLSALUD*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @OBLSALUD, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @OBLSALUDT = @VALOR
 /*OBLPENSION*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @OBLPENSION, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @OBLPENSIONT = @VALOR
 /*VOLPENSION*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @VOLPENSION, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @VOLPENSIONT = @VALOR
 /*RETENCION*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @RETENCION, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @RETENCIONT = @VALOR
 
 IF @TIPO_DOCUMENTO IS NULL
 SET @TIPO_DOCUMENTO = ''
 IF @NIT IS NULL
 SET @NIT = ''
 IF @PRIMER_APELLIDO IS NULL
 SET @PRIMER_APELLIDO = ''
 IF @SEGUNDO_APELLIDO IS NULL
 SET @SEGUNDO_APELLIDO = ''
 IF @PRIMER_NOMBRE IS NULL
 SET @PRIMER_NOMBRE = ''
 IF @SEGUNDO_NOMBRE IS NULL
 SET @SEGUNDO_NOMBRE = ''
 /*IF @DIRECCION IS NULL
 SET @DIRECCION = ''
 IF @DEPARTAMENTO IS NULL
 SET @DEPARTAMENTO = ''
 IF @MUNICIPIO IS NULL
 SET @MUNICIPIO = ''
 IF @PAIS IS NULL
 SET @PAIS = ''
 IF @CORREO IS NULL
 SET @CORREO = ''
 IF @DEPTORET IS NULL
 SET @DEPTORET = ''
 IF @MUNRET IS NULL
 SET @MUNRET = ''*/
 
 SET @SQL = ' insert into ' + @TABLA + '
 (
 	TIPO_DOCUMENTO, 
 	NIT, 
 	PRIMER_APELLIDO, 
 	SEGUNDO_APELLIDO, 
 	PRIMER_NOMBRE,  
     SEGUNDO_NOMBRE, 
     FECHAINICIAL, 
 	FECHAFINAL , 
 	FECHAEXP , 
 	DEPTORET, 
 	MUNRET , 
 	ENTIDADES, 
 	INGRESOSSALARIALES,
 	DEDUCCIONESSALARIALES,
 	CENSATIAS , 
 	GASTOSREP, 
 	JUBILACION, 
 	OTROSINGRESOS, 
 	TOTALBRUTOS,
 	OBLSALUD, 
 	OBLPENSION, 
 	VOLPENSION, 
 	RETENCION
 )
 VALUES
 ( ' + '''' + CONVERT(NVARCHAR,@TIPO_DOCUMENTO) + '''' + ','
 	+ '''' +CONVERT(NVARCHAR,@NIT)+ '''' + ','
 	+ '''' +CONVERT(NVARCHAR,@PRIMER_APELLIDO)+ '''' + ',' 
 	+ '''' +CONVERT(NVARCHAR,@SEGUNDO_APELLIDO)+ '''' + ',' 
 	+ '''' +CONVERT(NVARCHAR,@PRIMER_NOMBRE)+ '''' + ','   
 	+ '''' +CONVERT(NVARCHAR,@SEGUNDO_NOMBRE)+ '''' + ','
 	/*+ '''' +CONVERT(NVARCHAR,@DIRECCION)+ '''' + ','
 	+ '''' +CONVERT(NVARCHAR,@DEPARTAMENTO)+ '''' + ','
 	+ '''' +CONVERT(NVARCHAR,@MUNICIPIO) + '''' + ','
 	+ '''' +CONVERT(NVARCHAR,@PAIS)+ '''' + ','
 	+ '''' +CONVERT(NVARCHAR,@CORREO)+ '''' + ','*/
 	+ '''1980-01-01''' + ','
 	+ '''1980-01-01''' + ',' 
 	+ '''1980-01-01''' + ',' 
 	+ '''' +CONVERT(NVARCHAR,@DEPTORET)+ '''' + ','
 	+ '''' +CONVERT(NVARCHAR,@MUNRET)+ '''' + ',' 
 	+ CONVERT(NVARCHAR,@ENTIDADES) + ','  
 	+ CONVERT(NVARCHAR,@INGRESOSSALARIALES) + ','
 	+ CONVERT(NVARCHAR,@DEDUCCIONESSALARIALES) + ','
 	+ CONVERT(NVARCHAR,@CESANTIAST) + ',' 
 	+ CONVERT(NVARCHAR,@GASTOSREPT) + ',' 
 	+ CONVERT(NVARCHAR,@JUBILACIONT) + ',' 
 	+ CONVERT(NVARCHAR,@OTROSINGRESOST) + ',' 
 	+ CONVERT(NVARCHAR,@TOTALBRUTOST) + ','
 	+ CONVERT(NVARCHAR,@OBLSALUDT) + ',' 
 	+ CONVERT(NVARCHAR,@OBLPENSIONT) + ',' 
 	+ CONVERT(NVARCHAR,@VOLPENSIONT) + ',' 
 	+ CONVERT(NVARCHAR,@RETENCIONT) + '		
 ) '
 
 EXEC SP_EXECUTESQL @SQL
 
 fetch next from CNME into @TIPO_DOCUMENTO ,@NIT , @PRIMER_APELLIDO , @SEGUNDO_APELLIDO, 
 	@PRIMER_NOMBRE  ,   @SEGUNDO_NOMBRE /*,@DIRECCION  ,@DEPARTAMENTO  ,@MUNICIPIO ,
 	@PAIS ,@CORREO */ ,@FECHAINICIALT  ,@FECHAFINALT,  @FECHAEXP , @DEPTORET , 
 	@MUNRET , @ENTIDADES,  
 	@INGRESOSSALARIALES ,@DEDUCCIONESSALARIALES ,@CESANTIAST , @GASTOSREPT , @JUBILACIONT , @OTROSINGRESOST , 
 	@TOTALBRUTOST ,@OBLSALUDT , @OBLPENSIONT , @VOLPENSIONT , @RETENCIONT, @EMPLEADO		
 END
 CLOSE CNME
 DEALLOCATE CNME
END;

