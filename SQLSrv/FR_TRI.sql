REMARK
\
--------------------------------------------------------------
--------------------------------------------------------------

			FUNCIONES
--------------------------------------------------------------
--------------------------------------------------------------
/
CREATE FUNCTION ERPADMIN.LISTA_RUTAS_CLIENTE
(
      @CLIENTE VARCHAR(20)
)
RETURNS VARCHAR(8000)
AS
BEGIN
      DECLARE @RUTAS VARCHAR(4000)
      DECLARE @RUTA VARCHAR(4)

      DECLARE rutas_cursor CURSOR FOR 
            select rc.ruta
            from erpadmin.ruta_cliente rc
          where rc.cliente = @CLIENTE
            and rc.ruta is not null

      OPEN rutas_cursor
      FETCH NEXT FROM rutas_cursor INTO @RUTA

      SET @RUTAS = ''

      WHILE @@FETCH_STATUS = 0
      BEGIN
            SET @RUTAS = @RUTAS + @RUTA + ','
            
            FETCH NEXT FROM rutas_cursor INTO @RUTA
      END

      IF LEN(@RUTAS) > 0
      BEGIN
            SELECT @RUTAS = SUBSTRING(@RUTAS,1,len(@RUTAS)-1)
      END

      CLOSE rutas_cursor
      DEALLOCATE rutas_cursor
 
      RETURN @RUTAS
END
;




CREATE FUNCTION ERPADMIN.RestarFechas(
	@pFechaIncial DATETIME,
	@pFechaFinal DATETIME
)
RETURNS VARCHAR(40)
AS
BEGIN
 
  DECLARE @LHORAS INTEGER
  DECLARE @LMINUTOS INTEGER
  DECLARE @LSEGUNDOS INTEGER
  DECLARE @LTOTAL INTEGER
  DECLARE @LHORASSTR VARCHAR(4)
  DECLARE @LMINUTOSSTR VARCHAR(4)
  DECLARE @LSEGUNDOSSTR VARCHAR(4)
  
  SET @LTOTAL = DATEDIFF(SECOND,  @pFechaIncial, @pFechaFinal)
  
  SET @LHORAS = CAST((@LTOTAL / 3600) AS INTEGER)
  SET @LMINUTOS = CAST(((@LTOTAL % 3600) / 60) AS INTEGER) 
  SET @LSEGUNDOS = CAST(((@LTOTAL % 3600) % 60) AS INTEGER)
  
  IF (@LHORAS IS NULL)
		SET @LHORAS = 0
  IF (@LMINUTOS IS NULL)
		SET @LMINUTOS = 0
  IF (@LMINUTOS IS NULL)
		SET @LMINUTOS = 0
  IF (@LHORAS < 10)
    SET @LHORASSTR = '0' + CAST(@LHORAS as VARCHAR)
  ELSE
    SET @LHORASSTR = CAST(@LHORAS as VARCHAR)   
  IF (@LMINUTOS < 10)
     SET @LMINUTOSSTR = '0' + CAST(@LMINUTOS as VARCHAR)
  ELSE
    SET @LMINUTOSSTR = CAST(@LMINUTOS as VARCHAR)
  
  IF (@LSEGUNDOS < 10)
    SET @LSEGUNDOSSTR = '0' + CAST(@LSEGUNDOS as VARCHAR)
  ELSE
    SET @LSEGUNDOSSTR = CAST(@LSEGUNDOS as VARCHAR)

	RETURN (@LHORASSTR + ':' + @LMINUTOSSTR + ':' + @LSEGUNDOSSTR)
END;



CREATE FUNCTION ERPADMIN.CONVIERTA_FECHA (@VALOR_FECHA varchar(20))
    RETURNS DATETIME
AS
BEGIN   
	DECLARE @FECHA DATETIME
	 
	SET @FECHA = (SELECT CONVERT(DATETIME, @VALOR_FECHA, 101))
	
    RETURN @FECHA   
END;
	


REMARK
\
--------------------------------------------------------------
			VISTAS
--------------------------------------------------------------
/



CREATE VIEW ERPADMIN.V_AGENTE ( 
	COMPANIA, AGENTE, NOMBRE, TIPO, 
	NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate ) AS
SELECT '$$COMPANIA$$', VENDEDOR, NOMBRE, 'V',
        NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate
FROM 	$$COMPANIA$$.VENDEDOR
UNION ALL
SELECT '$$COMPANIA$$', COBRADOR, NOMBRE, 'C',
        NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate
FROM 	$$COMPANIA$$.COBRADOR
;






CREATE VIEW ERPADMIN.V_ARTICULO ( 
	COMPANIA, ARTICULO, DESCRIPCION, CLASIFICACION_1,FACTOR_EMPAQUE, ACTIVO,
        NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate ) AS
SELECT '$$COMPANIA$$', ARTICULO, DESCRIPCION, CLASIFICACION_1,FACTOR_EMPAQUE,ACTIVO,
	NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate
FROM 	$$COMPANIA$$.ARTICULO
;






CREATE VIEW ERPADMIN.V_BODEGA ( 
	COMPANIA, BODEGA, NOMBRE, 
        NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate ) AS
SELECT '$$COMPANIA$$', BODEGA, NOMBRE, 
        NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate
FROM 	$$COMPANIA$$.BODEGA
;






CREATE VIEW ERPADMIN.V_BODEGA_CONSIGNACION ( 
	COMPANIA, BODEGA, NOMBRE, 
        NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate ) AS
SELECT '$$COMPANIA$$', BODEGA, NOMBRE, 
        NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate
FROM 	$$COMPANIA$$.BODEGA
;





CREATE VIEW ERPADMIN.V_BONIFICACION_CLIART (
	COMPANIA, CLIENTE, ARTICULO, CANT_MIN, CANT_MAX, FECHA_INICIO, 
	FECHA_FIN, ARTICULO_BONIF, UNIDADES_BONIF, FACTOR_BONIF ) AS
SELECT '$$COMPANIA$$', CLIENTE, ARTICULO, 1, 999999, '2009-01-01',
	'2999-12-31', ARTICULO_BONIF, UNIDADES_BONIF, FACTOR_BONIF 
FROM 	
$$COMPANIA$$.BONIF_ART_X_CLI
;





CREATE VIEW ERPADMIN.V_CLASIFICACION1 (
        COMPANIA, CLASIFICACION, DESCRIPCION, 
        NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate ) AS
SELECT '$$COMPANIA$$' COMPANIA, CLASIFICACION, DESCRIPCION, 
       NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate
FROM   $$COMPANIA$$.CLASIFICACION
WHERE AGRUPACION = 1
;






CREATE VIEW ERPADMIN.V_CLIENTE ( 
	COMPANIA, CLIENTE, NOMBRE, ACTIVO,FECHA_INGRESO,
        NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate ) AS
SELECT '$$COMPANIA$$', CLIENTE, NOMBRE, ACTIVO,FECHA_INGRESO,
        NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate
FROM 	$$COMPANIA$$.CLIENTE
;





CREATE VIEW ERPADMIN.V_CONSEC_TRASPASO_CONS  
( COMPANIA, CONSECUTIVO,DESCRIPCION,TIPO_TRANSACCION,NOTEEXISTSFLAG, RECORDDATE, ROWPOINTER, CREATEDBY, UPDATEDBY,CREATEDATE )
AS

SELECT '$$COMPANIA$$' AS COMPANIA,   
		CCI.CONSECUTIVO,
		CCI.DESCRIPCION,
		AC.DESCRIPCION AS TIPO_TRANSACCION,
		CCI.NOTEEXISTSFLAG,
		CCI.RECORDDATE,
		CCI.ROWPOINTER,
		CCI.CREATEDBY,
		CCI.UPDATEDBY,
		CCI.CREATEDATE 
FROM $$COMPANIA$$.CONSECUTIVO_CI CCI
INNER JOIN $$COMPANIA$$.CONSEC_AJUSTE_CONF CAC ON CCI.CONSECUTIVO = CAC.CONSECUTIVO
INNER JOIN $$COMPANIA$$.AJUSTE_CONFIG AC ON CAC.AJUSTE_CONFIG = AC.AJUSTE_CONFIG
WHERE CAC.AJUSTE_CONFIG = '~TT~';






CREATE VIEW ERPADMIN.V_DESCUENTO_CLAS (
	COMPANIA, CLIENTE, clasificacion1, clasificacion2, clasificacion3, 
	CANT_MIN, CANT_MAX, TIPO, MONTO, FECHA_INICIO, FECHA_FIN) AS
SELECT '$$COMPANIA$$', CLIENTE, CLASIFICACION1, CLASIFICACION2, CLASIFICACION3,
	1, 999999, TIPO, Monto, '2009-01-01', '2999-12-31' 
FROM 	
ERPADMIN.DESCUENTO_CLAS
;






CREATE VIEW ERPADMIN.V_DESCUENTO_CLIART (
	COMPANIA, ARTICULO, CLIENTE, CANT_MIN, CANT_MAX, TIPO, MONTO, FECHA_INICIO, FECHA_FIN ) AS
SELECT '$$COMPANIA$$', ARTICULO, CLIENTE, 1, 999999, TIPO, MONTO, '2009-01-01', '2999-12-31'
FROM 	
ERPADMIN.DESCUENTO_CLIART
;





CREATE VIEW ERPADMIN.V_LOTE ( 
	COMPANIA, LOTE,ARTICULO, 
	NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate ) AS
SELECT	'$$COMPANIA$$' COMPANIA, LOTE,ARTICULO,
	NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate
FROM 	$$COMPANIA$$.LOTE
;






CREATE VIEW ERPADMIN.VLOCALIZACION ( 
	COMPANIA, BODEGA, LOCALIZACION,DESCRIPCION,VOLUMEN,PESO_MAXIMO,
        NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate ) AS
SELECT     '$$COMPANIA$$' AS COMPANIA, LC.*
FROM         $$COMPANIA$$.LOCALIZACION LC
;






CREATE VIEW ERPADMIN.V_FR_DOCUMENTOS_NO_CARGADOS
( COMPANIA, TIPO_DOCUMENTO, DOCUMENTO, RUTA, AGENTE ,CODIGO, CLIENTE, FECHA_DOCUMENTO, FECHA_SINCRONIZACION) AS
SELECT PED.COD_CIA, 'PEDIDOS' AS TIPO_DOCUMENTO, PED.NUM_PED, PED.COD_ZON, AR.NOMBRE, PED.COD_CLT, 
	   CLT.NOMBRE, PED.FEC_PED, PED.CreateDate	    
FROM ERPADMIN.ALFAC_ENC_PED PED, ERPADMIN.CLIENTE_RT CLT_RT, ERPADMIN.CLIENTE_ASOC_RT CLT_AS,
     ERPADMIN.CLIENTE_RT CLT, ERPADMIN.RUTA_ASIGNADA_RT RA, ERPADMIN.AGENTE_RT AR
WHERE PED.DOC_PRO IS NULL AND PED.COD_CLT = CLT_RT.CLIENTE AND CLT_AS.COMPANIA = PED.COD_CIA AND
      CLT_RT.CLIENTE = CLT_AS.CLIENTE AND CLT.CLIENTE = CLT_AS.CODIGO AND RA.RUTA = PED.COD_ZON AND
	  AR.AGENTE = RA.AGENTE
UNION
SELECT DEV.COD_CIA,  'DEVOLUCIONES' AS TIPO_DOCUMENTO, DEV.NUM_DEV, DEV.COD_ZON, AR.NOMBRE, DEV.COD_CLT, 
	   CLT.NOMBRE, DEV.FEC_DEV, DEV.CreateDate
FROM ERPADMIN.ALFAC_ENC_DEV DEV, ERPADMIN.CLIENTE_RT CLT_RT, ERPADMIN.CLIENTE_ASOC_RT CLT_AS,
     ERPADMIN.CLIENTE_RT CLT, ERPADMIN.RUTA_ASIGNADA_RT RA, ERPADMIN.AGENTE_RT AR 
WHERE DEV.DOC_PRO IS NULL AND DEV.COD_CLT = CLT_RT.CLIENTE AND CLT_AS.COMPANIA = DEV.COD_CIA AND
      CLT_RT.CLIENTE = CLT_AS.CLIENTE AND CLT.CLIENTE = CLT_AS.CODIGO AND RA.RUTA = DEV.COD_ZON AND
	  AR.AGENTE = RA.AGENTE
UNION
SELECT CON.COD_CIA,  'CONSIGNACIONES' AS TIPO_DOCUMENTO, CON.NUM_CSG, CON.COD_ZON, AR.NOMBRE, CON.COD_CLT, 
	   CLT.NOMBRE, CON.FEC_BOLETA, CON.CreateDate
FROM ERPADMIN.ALFAC_ENC_CONSIG CON, ERPADMIN.CLIENTE_RT CLT_RT, ERPADMIN.CLIENTE_ASOC_RT CLT_AS,
     ERPADMIN.CLIENTE_RT CLT, ERPADMIN.RUTA_ASIGNADA_RT RA, ERPADMIN.AGENTE_RT AR 
WHERE DOC_PRO = 'N' AND CON.COD_CLT = CLT_RT.CLIENTE AND CLT_AS.COMPANIA = CON.COD_CIA AND
      CLT_RT.CLIENTE = CLT_AS.CLIENTE AND CLT.CLIENTE = CLT_AS.CODIGO AND RA.RUTA = CON.COD_ZON AND
	  AR.AGENTE = RA.AGENTE
UNION
SELECT RE.COD_CIA,  'RECIBOS' AS TIPO_DOCUMENTO, RE.NUM_REC, RE.COD_ZON, AR.NOMBRE, RE.COD_CLT, 
	   CLT.NOMBRE, RE.FEC_PRO, RE.CreateDate
FROM ERPADMIN.ALCXC_DOC_APL RE, ERPADMIN.CLIENTE_RT CLT_RT, ERPADMIN.CLIENTE_ASOC_RT CLT_AS,
     ERPADMIN.CLIENTE_RT CLT, ERPADMIN.RUTA_ASIGNADA_RT RA, ERPADMIN.AGENTE_RT AR  
WHERE DOC_PRO IS NULL AND RE.COD_CLT = CLT_RT.CLIENTE AND CLT_AS.COMPANIA = RE.COD_CIA AND
      CLT_RT.CLIENTE = CLT_AS.CLIENTE AND CLT.CLIENTE = CLT_AS.CODIGO AND RA.RUTA = RE.COD_ZON AND
	  AR.AGENTE = RA.AGENTE
UNION
SELECT COD_CIA,  'DEPOSITOS' AS TIPO_DOCUMENTO, CAST(NUM_DEP AS VARCHAR) AS NUM_DEP, '' AS COD_ZON, '' AS NOMBRE, 
	   '' AS COD_CLT, '' AS NOMBRE, FEC_DEP, CreateDate
FROM ERPADMIN.ALCXC_ENC_DEP 
WHERE DOC_PRO IS NULL
;







CREATE VIEW ERPADMIN.V_FR_EMM_SYNCINFO AS SELECT * FROM ERPADMIN.EMM_SYNCINFO;







CREATE VIEW ERPADMIN.V_NCF_CONSECUTIVO( 
	COMPANIA, PREFIJO, DESCRIPCION, ACTIVO, TIPO,
        NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate ) AS
	SELECT '$$Compania$$', PREFIJO, DESCRIPCION, ACTIVO, TIPO, NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate
	FROM $$Compania$$.NCF_CONSECUTIVO;






CREATE VIEW ERPADMIN.V_PAQUETES_INVENTARIO ( 
	COMPANIA, PAQUETE_INVENTARIO, DESCRIPCION,
        NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate ) AS
	SELECT '$$Compania$$', PAQUETE_INVENTARIO, DESCRIPCION,
		NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate
	FROM 	$$COMPANIA$$.PAQUETE_INVENTARIO;





CREATE VIEW ERPADMIN.V_CONSECUTIVO_CI ( 
		COMPANIA, CONSECUTIVO, DESCRIPCION, SIGUIENTE_CONSEC, MASCARA, AJUSTE_CONFIG,
		NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate ) AS
	SELECT  DISTINCT '$$Compania$$', CCI.CONSECUTIVO, CCI.DESCRIPCION, CCI.SIGUIENTE_CONSEC, CCI.MASCARA, CAC.AJUSTE_CONFIG,
		CCI.NoteExistsFlag, CCI.RecordDate, CCI.RowPointer, CCI.CreatedBy, CCI.UpdatedBy, CCI.CreateDate
	FROM 	$$COMPANIA$$.CONSECUTIVO_CI CCI, $$COMPANIA$$.CONSEC_AJUSTE_CONF CAC, $$COMPANIA$$.AJUSTE_CONFIG AC
	WHERE	CCI.CONSECUTIVO = CAC.CONSECUTIVO
	AND		CAC.AJUSTE_CONFIG = AC.AJUSTE_CONFIG
	AND		AC.ACTIVA = 'S'
	AND		AC.AJUSTE_BASE = 'T'
	AND		CAC.AJUSTE_CONFIG = '~TT~';








CREATE VIEW ERPADMIN.V_LIQUIDACION_AGENTE
 AS
 SELECT AGE.agente AS Agente,
 AGE.nombre AS AgenteNombre,
 RAR.ruta AS Ruta,
 CLI.cliente AS Cliente,
 CLI.nombre AS ClienteNombre,
 DOCUMENTOS.compania,
 VSD.inicio AS Fecha,
 DOCUMENTOS.tipodocumento,
 DOCUMENTOS.documento,
 DOCUMENTOS.montochequelocal,
 DOCUMENTOS.montochequedolar,
 DOCUMENTOS.montoefectivolocal,
 DOCUMENTOS.montoefectivodolar,
 DOCUMENTOS.moneda,
 DOCUMENTOS.documentoasociado,
 DOCUMENTOS.montolocal,
 DOCUMENTOS.montodolar,
 DOCUMENTOS.saldolocal,
 DOCUMENTOS.saldodolar,
 DOCUMENTOS.contado
 FROM erpadmin.agente_rt AGE
 INNER JOIN erpadmin.ruta_asignada_rt RAR
 ON AGE.agente = RAR.agente
 INNER JOIN erpadmin.visita_documento VSD
 ON RAR.ruta = VSD.ruta
 INNER JOIN erpadmin.cliente_rt CLI
 ON VSD.cliente = CLI.cliente
 INNER JOIN (SELECT 
 RECIBO.num_rec AS Documento,
 RECIBO.ind_mon AS Moneda,
 RECIBO.cod_cia AS Compania,
 RECIBO.cod_clt AS Cliente,
 RECIBO.cod_zon AS Ruta,
 RECIBO.mon_che_local AS MontoChequeLocal,
 RECIBO.mon_che_dolar AS MontoChequeDolar,
 RECIBO.mon_efe_local AS MontoEfectivoLocal,
 RECIBO.mon_efe_dolar AS MontoEfectivoDolar,
 RDET.num_doc_af AS DocumentoAsociado,
 RDET.mon_mov_local AS MontoLocal,
 RDET.mon_mov_dol AS MontoDolar,
 RDET.mon_sal_loc AS SaldoLocal,
 RDET.mon_sal_dol AS SaldoDolar,
 CASE CDP.can_dia
 WHEN 0 THEN 'S'
 ELSE 'N'
 END AS Contado,
 
 CASE CDP.can_dia
 WHEN 0 THEN (CASE RDET.COD_TIP_DC
 WHEN 7 THEN 'NC' /* Nota aplicada*/
 WHEN 15 THEN 'NC'
 ELSE 'RF'
 END )
 ELSE 'RF' 
 END AS TipoDocumento 
 
 FROM erpadmin.alcxc_doc_apl RECIBO,
 erpadmin.alcxc_mov_dir RDET
 INNER JOIN erpadmin.alfac_enc_ped FACTURA
 ON RDET.num_doc_af = FACTURA.num_ped
 AND RDET.cod_cia = FACTURA.cod_cia
 AND RDET.cod_clt = FACTURA.cod_clt
 INNER JOIN erpadmin.alfac_cnd_pag CDP
 ON FACTURA.cod_cnd = CDP.cod_cnd
 AND FACTURA.cod_cia = CDP.cod_cia
 WHERE RECIBO.num_rec = RDET.num_rec
 AND RECIBO.cod_cia = RDET.cod_cia
 AND RECIBO.cod_clt = RDET.cod_clt
 AND RECIBO.cod_zon = RDET.cod_zon
 UNION ALL
 SELECT FACTURA.num_ped AS Documento,
 LISTA.moneda AS Moneda,
 FACTURA.cod_cia AS Compania,
 FACTURA.cod_clt AS Cliente,
 FACTURA.cod_zon AS Ruta,
 NULL AS MontoChequeLocal,
 NULL AS MontoChequeDolar,
 NULL AS MontoEfectivoLocal,
 NULL AS MontoEfectivoDolar,
 NULL AS DocumentoAsociado,
 CASE LISTA.moneda
 WHEN 'L' THEN FACTURA.mon_siv
 ELSE Round(FACTURA.mon_siv * GLOBALES.montocambiodolar, 7)
 END AS MontoLocal,
 CASE LISTA.moneda
 WHEN 'D' THEN FACTURA.mon_siv
 ELSE Round(FACTURA.mon_siv / GLOBALES.montocambiodolar, 7)
 END AS MontoDolar,
 CASE LISTA.moneda
 WHEN 'L' THEN FACTURA.mon_civ + FACTURA.mon_imp_cs
 - FACTURA.mon_dsc -
 FACTURA.mont_desc1
 - FACTURA.mont_desc2
 ELSE Round(( FACTURA.mon_civ + FACTURA.mon_imp_cs
 -
 FACTURA.mon_dsc -
 FACTURA.mont_desc1
 - FACTURA.mont_desc2 ) * GLOBALES.montocambiodolar, 7)
 END AS SaldoLocal,
 CASE LISTA.moneda
 WHEN 'D' THEN FACTURA.mon_civ + FACTURA.mon_imp_cs
 - FACTURA.mon_dsc -
 FACTURA.mont_desc1
 - FACTURA.mont_desc2
 ELSE Round(( FACTURA.mon_civ + FACTURA.mon_imp_cs
 -
 FACTURA.mon_dsc -
 FACTURA.mont_desc1
 - FACTURA.mont_desc2 ) / GLOBALES.montocambiodolar, 7)
 END AS SaldoDolar,
 CASE CDP.can_dia
 WHEN 0 THEN 'S'
 ELSE 'N'
 END AS Contado,
 'F' AS TipoDocumento
 FROM erpadmin.alfac_enc_ped FACTURA
 INNER JOIN erpadmin.alfac_cnd_pag CDP
 ON FACTURA.cod_cnd = CDP.cod_cnd
 AND FACTURA.cod_cia = CDP.cod_cia,
 erpadmin.nivel_lista LISTA,
 (SELECT cod_cia AS compania,
 cond_pago_contad AS CondicionContado,
 cambiodolar AS MontoCambioDolar
 FROM erpadmin.compania_descripcion) GLOBALES
 WHERE FACTURA.cod_cia = LISTA.compania
 AND FACTURA.NIVEL_PRECIO = lista.NIVEL_PRECIO
 AND FACTURA.cod_cia = GLOBALES.compania
 AND FACTURA.tip_doc = 'F'
 UNION ALL
 SELECT RECIBO.num_rec AS Documento,
 RECIBO.ind_mon AS Moneda,
 RECIBO.cod_cia AS Compania,
 RECIBO.cod_clt AS Cliente,
 RECIBO.cod_zon AS Ruta,
 RECIBO.mon_che_local AS MontoChequeLocal,
 RECIBO.mon_che_dolar AS MontoChequeDolar,
 RECIBO.mon_efe_local AS MontoEfectivoLocal,
 RECIBO.mon_efe_dolar AS MontoEfectivoDolar,
 CHEQUE.num_che AS DocumentoAsociado,
 CHEQUE.mon_che AS MontoLocal,
 NULL AS MontoDolar,
 NULL AS SaldoLocal,
 NULL AS SaldoDolar,
 NULL Contado,
 'RC' AS TipoDocumento
 FROM erpadmin.alcxc_doc_apl RECIBO
 LEFT JOIN erpadmin.alcxc_che CHEQUE
 ON RECIBO.num_rec = CHEQUE.num_rec
 AND RECIBO.cod_cia = CHEQUE.cod_cia
 AND RECIBO.cod_clt = CHEQUE.cod_clt
 AND RECIBO.cod_zon = CHEQUE.cod_zon
 
 UNION ALL
 SELECT 
 DEVOLUCION_EFECTIVO.NUM_DEV AS Documento,
 DEVOLUCION_EFECTIVO.MONEDA AS Moneda,
 DEVOLUCION_EFECTIVO.cod_cia AS Compania,
 DEVOLUCION_EFECTIVO.cod_clt AS Cliente,
 DEVOLUCION_EFECTIVO.cod_zon AS Ruta,
 NULL AS MontoChequeLocal,
 NULL AS MontoChequeDolar,
 
 Case when DEVOLUCION_EFECTIVO.MONEDA = 'L' THEN((mon_siv + mon_imp_vt + mon_imp_cs)- Mon_dsc)ELSE 0 END AS MontoEfectivoLocal, -- ojo 
 Case when DEVOLUCION_EFECTIVO.MONEDA = 'D' THEN((mon_siv + mon_imp_vt + mon_imp_cs)- Mon_dsc)ELSE 0 END AS MontoEfectivoDolar,
 NULL AS DocumentoAsociado,
 NULL AS MontoLocal,
 NULL AS MontoDolar,
 NULL AS SaldoLocal,
 NULL AS SaldoDolar,
 NULL Contado,
 'DE' AS TipoDocumento /* devolucion efectivo*/
 FROM erpadmin.alFAC_ENC_DEV DEVOLUCION_EFECTIVO
 
 )DOCUMENTOS
 ON VSD.compania = DOCUMENTOS.compania
 AND VSD.cliente = DOCUMENTOS.cliente
 AND VSD.ruta = DOCUMENTOS.ruta
 AND VSD.documento = DOCUMENTOS.documento
 UNION ALL
 SELECT AGE.agente AS Agente,
 AGE.nombre AS AgenteNombre,
 RAR.ruta AS Ruta,
 NULL AS Cliente,
 NULL AS ClienteNombre,
 DEPOSITO.cod_cia AS Compania,
 DEPOSITO.fec_dep AS Fecha,
 'D' AS TipoDocumento,
 Cast(DEPOSITO.num_dep AS VARCHAR(256)) AS Documento,
 CASE DEPOSITO.ind_mon
 WHEN 'L' THEN Sum(DEPDET.mon_che)
 ELSE NULL
 END AS MontoChequeLocal,
 CASE DEPOSITO.ind_mon
 WHEN 'D' THEN Sum(DEPDET.mon_che)
 ELSE NULL
 END AS MontoChequeDolar,
 CASE DEPOSITO.ind_mon
 WHEN 'L' THEN Sum(DEPDET.mon_efe)
 ELSE NULL
 END AS MontoEfectivoLocal,
 CASE DEPOSITO.ind_mon
 WHEN 'D' THEN Sum(DEPDET.mon_efe)
 ELSE NULL
 END AS MontoEfectivoDolar,
 DEPOSITO.ind_mon AS Moneda,
 CHEQUE.num_che AS DocumentoAsociado,
 CASE DEPOSITO.ind_mon
 WHEN 'L' THEN CHEQUE.mon_che
 ELSE NULL
 END AS MontoLocal,
 CASE DEPOSITO.ind_mon
 WHEN 'D' THEN CHEQUE.mon_che
 ELSE NULL
 END AS MontoDolar,
 NULL AS SaldoLocal,
 NULL AS SaldoDolar,
 NULL AS Contado
 FROM erpadmin.agente_rt AGE
 INNER JOIN erpadmin.ruta_asignada_rt RAR
 ON AGE.agente = RAR.agente
 INNER JOIN erpadmin.alcxc_doc_apl RECIBO
 ON RAR.ruta = RECIBO.cod_zon
 AND RAR.compania = RECIBO.cod_cia
 LEFT JOIN erpadmin.alcxc_che CHEQUE
 ON RECIBO.num_rec = CHEQUE.num_rec
 AND RECIBO.cod_cia = CHEQUE.cod_cia
 AND RECIBO.cod_zon = CHEQUE.cod_zon
 INNER JOIN erpadmin.alcxc_det_dep DEPDET
 ON RECIBO.num_rec = DEPDET.num_doc
 INNER JOIN erpadmin.alcxc_enc_dep DEPOSITO
 ON DEPDET.num_dep = DEPOSITO.num_dep
 where  DEPDET.CTA_BCO=DEPOSITO.CTA_BCO
 GROUP BY AGE.agente,
 AGE.nombre,
 RAR.ruta,
 DEPOSITO.num_dep,
 DEPOSITO.ind_mon,
 DEPOSITO.cod_cia,
 RECIBO.cod_zon,
 CHEQUE.num_che,
 CHEQUE.mon_che,
 DEPOSITO.fec_dep;

	

CREATE VIEW ERPADMIN.ReporteVisitas
AS
SELECT 
	VST.ruta AS Ruta
	, RUT.descripcion AS RutaDescripcion
	, RAR.agente AS Agente
	, AGN.nombre AS AgenteNombre
	, CASE DATEPART(WEEKDAY,VST.inicio) 
		WHEN 1 THEN 'D' 
		WHEN 2 THEN 'L' 
		WHEN 3 THEN 'K'
		WHEN 4 THEN 'M'
		WHEN 5 THEN 'J' 
		WHEN 6 THEN 'V'
		WHEN 7 THEN 'S'
		ELSE '' END AS Dia 
	, ORDEN.orden AS Orden
	, DATEADD(day, 0, DATEDIFF(day,0,VST.inicio)) AS VisitaFecha
	, CASE WHEN ORDEN.dia IS NULL THEN 'N' ELSE 'S' END AS EnRuta
	, VST.inicio AS VisitaInicio
	, VST.fin AS VisitaFin
	, VST.notas AS VisitaNotas
	, VST.cliente AS Cliente
	, VST.razon AS Razon
	, RZV.des_rzn AS RazonDescripcion
	, CLI.nom_clt AS NombreCliente
	, CLI.dir_clt AS DireccionCliente
	, CLC.cod_cia AS CompaniaCliente
	, VSD.documento AS Documento
	, VSD.tipo_documento AS DocumentoTipo
	, DOCUMENTOS.FechaDocumento AS DocumentoFecha
	, DOCUMENTOS.Inicio AS DocumentoInicio
	, DOCUMENTOS.Fin AS DocumentoFin
	, DOCUMENTOS.Moneda AS Moneda
	, DOCUMENTOS.MontoSinImpLocal AS MontoLocal
	, DOCUMENTOS.MontoConImpLocal AS MontoConImp1Local
	, DOCUMENTOS.MontoImpuesto1Local AS MontoImpuesto1Local
	, DOCUMENTOS.MontoImpuesto2Local AS MontoImpuesto2Local
	, DOCUMENTOS.MontoDescuentoLocal AS MontoDescuentoLocal
	, DOCUMENTOS.MontoDesc1Local AS MontoDesc1Local 
	, DOCUMENTOS.MontoDesc2Local AS MontoDesc2Local 
	, DOCUMENTOS.MontoSinImpDolar AS MontoDolar
	, DOCUMENTOS.MontoConImpDolar AS MontoConImpDolar 
	, DOCUMENTOS.MontoImpuesto1Dolar AS MontoImpuesto1Dolar 
	, DOCUMENTOS.MontoImpuesto2Dolar AS MontoImpuesto2Dolar 
	, DOCUMENTOS.MontoDescuentoDolar AS MontoDescuentoDolar 
	, DOCUMENTOS.MontoDesc1Dolar AS MontoDesc1Dolar 
	, DOCUMENTOS.MontoDesc2Dolar AS MontoDesc2Dolar 
	, DOCUMENTOS.PorcentajeDesc1 AS PorcentajeDesc1 
	, DOCUMENTOS.PorcentajeDesc2 AS PorcentajeDesc2 
	, DOCUMENTOS.CondicionPago AS CondicionPago 
	, DOCUMENTOS.Bodega AS Bodega
	, DOCUMENTOS.Observaciones AS DocumentoObservaciones
	, DOCUMENTOS.PagoContado AS PagoContado 
FROM 
	ERPADMIN.visita VST
	LEFT JOIN ERPADMIN.visita_documento VSD
			ON VST.cliente = VSD.cliente 
			AND VST.ruta = VSD.ruta 
			AND VST.inicio = VSD.inicio
			AND VSD.tipo_documento IN ('1', '4', '5','F')
	LEFT JOIN ERPADMIN.cliente CLI 
		ON VST.cliente = CLI.cod_clt
			AND VST.ruta = CLI.cod_zon
	LEFT JOIN ERPADMIN.cliente_cia CLC
		ON VSD.cliente = CLC.cod_clt
			AND VSD.compania = CLC.cod_cia
	INNER JOIN ERPADMIN.ruta_asignada_rt RAR 
		ON VST.ruta = RAR.ruta
	INNER JOIN ERPADMIN.ruta_rt RUT
		ON VST.ruta = RUT.ruta
	INNER JOIN ERPADMIN.agente_rt AGN
		ON RAR.agente = AGN.agente
	LEFT JOIN ERPADMIN.alFAC_RZN_VIS RZV
		ON VST.razon = RZV.cod_rzn
	LEFT JOIN (
		SELECT 
			PEDIDO.num_ped AS Documento
			, PEDIDO.tip_doc AS TipoDocumento
			, PEDIDO.cod_cia AS Compania
			, PEDIDO.cod_clt AS Cliente
			, PEDIDO.cod_zon AS Ruta
			, PEDIDO.fec_ped AS FechaDocumento
			, PEDIDO.hor_ini AS Inicio
			, PEDIDO.hor_fin AS Fin
			, LISTA.moneda AS Moneda
			, CASE LISTA.moneda WHEN 'L' THEN PEDIDO.mon_siv ELSE ROUND(PEDIDO.mon_siv * GLOBALES.MontoCambioDolar,7) END AS MontoSinImpLocal
			, CASE LISTA.moneda WHEN 'L' THEN PEDIDO.mon_civ ELSE ROUND(PEDIDO.mon_civ * GLOBALES.MontoCambioDolar,7) END AS MontoConImpLocal
			, CASE LISTA.moneda WHEN 'L' THEN PEDIDO.mon_imp_vt ELSE ROUND(PEDIDO.mon_imp_vt * GLOBALES.MontoCambioDolar,7) END AS MontoImpuesto1Local
			, CASE LISTA.moneda WHEN 'L' THEN PEDIDO.mon_imp_cs ELSE ROUND(PEDIDO.mon_imp_cs * GLOBALES.MontoCambioDolar,7) END AS MontoImpuesto2Local
			, CASE LISTA.moneda WHEN 'L' THEN PEDIDO.mon_dsc ELSE ROUND(PEDIDO.mon_dsc * GLOBALES.MontoCambioDolar,7) END AS MontoDescuentoLocal
			, CASE LISTA.moneda WHEN 'L' THEN PEDIDO.mont_desc1 ELSE ROUND(PEDIDO.mont_desc1 * GLOBALES.MontoCambioDolar,7) END AS MontoDesc1Local
			, CASE LISTA.moneda WHEN 'L' THEN PEDIDO.mont_desc2 ELSE ROUND(PEDIDO.mont_desc2 * GLOBALES.MontoCambioDolar,7) END AS MontoDesc2Local
			, CASE LISTA.moneda WHEN 'D' THEN PEDIDO.mon_siv ELSE ROUND(PEDIDO.mon_siv / GLOBALES.MontoCambioDolar,7) END AS MontoSinImpDolar
			, CASE LISTA.moneda WHEN 'D' THEN PEDIDO.mon_civ ELSE ROUND(PEDIDO.mon_civ / GLOBALES.MontoCambioDolar,7) END AS MontoConImpDolar
			, CASE LISTA.moneda WHEN 'D' THEN PEDIDO.mon_imp_vt ELSE ROUND(PEDIDO.mon_imp_vt / GLOBALES.MontoCambioDolar,7) END AS MontoImpuesto1Dolar
			, CASE LISTA.moneda WHEN 'D' THEN PEDIDO.mon_imp_cs ELSE ROUND(PEDIDO.mon_imp_cs / GLOBALES.MontoCambioDolar,7) END AS MontoImpuesto2Dolar
			, CASE LISTA.moneda WHEN 'D' THEN PEDIDO.mon_dsc ELSE ROUND(PEDIDO.mon_dsc / GLOBALES.MontoCambioDolar,7) END AS MontoDescuentoDolar
			, CASE LISTA.moneda WHEN 'D' THEN PEDIDO.mont_desc1 ELSE ROUND(PEDIDO.mont_desc1 / GLOBALES.MontoCambioDolar,7) END AS MontoDesc1Dolar
			, CASE LISTA.moneda WHEN 'D' THEN PEDIDO.mont_desc2 ELSE ROUND(PEDIDO.mont_desc2 / GLOBALES.MontoCambioDolar,7) END AS MontoDesc2Dolar
			, PEDIDO.desc1 AS PorcentajeDesc1
			, PEDIDO.desc2 AS PorcentajeDesc2
			, PEDIDO.cod_cnd AS CondicionPago
			, PEDIDO.cod_bod AS Bodega
			, PEDIDO.obs_ped AS Observaciones
			, CASE WHEN PEDIDO.cod_cnd = GLOBALES.CondicionContado THEN 'S' ELSE 'N' END AS PagoContado
		FROM 	ERPADMIN.alFAC_ENC_PED PEDIDO
				, ERPADMIN.NIVEL_LISTA LISTA
				, (SELECT cod_cia AS compania, cond_pago_contad AS CondicionContado, cambiodolar AS MontoCambioDolar
					 FROM ERPADMIN.compania_descripcion) GLOBALES
		WHERE	PEDIDO.cod_cia = LISTA.compania
			AND PEDIDO.lst_pre = LISTA.lista
			AND PEDIDO.cod_cia = GLOBALES.compania
		UNION ALL
		SELECT 
			DEVOLUCION.num_dev AS Documento
			, '4' AS TipoDocumento
			, DEVOLUCION.cod_cia AS Compania
			, DEVOLUCION.cod_clt AS Cliente
			, DEVOLUCION.cod_zon AS Ruta
			, DEVOLUCION.fec_dev AS FechaDocumento
			, DEVOLUCION.hor_ini AS Inicio
			, DEVOLUCION.hor_fin AS Fin
			, LISTA.moneda AS Moneda
			, CASE LISTA.moneda WHEN 'L' THEN DEVOLUCION.mon_siv ELSE ROUND(DEVOLUCION.mon_siv * GLOBALES.MontoCambioDolar,7) END AS MontoSinImpLocal
			, CASE LISTA.moneda WHEN 'L' THEN DEVOLUCION.mon_siv + DEVOLUCION.mon_imp_vt ELSE ROUND((DEVOLUCION.mon_siv + DEVOLUCION.mon_imp_vt) * GLOBALES.MontoCambioDolar,7) END AS MontoConImpLocal
			, CASE LISTA.moneda WHEN 'L' THEN DEVOLUCION.mon_imp_vt ELSE ROUND(DEVOLUCION.mon_imp_vt * GLOBALES.MontoCambioDolar,7) END AS MontoImpuesto1Local
			, CASE LISTA.moneda WHEN 'L' THEN DEVOLUCION.mon_imp_cs ELSE ROUND(DEVOLUCION.mon_imp_cs * GLOBALES.MontoCambioDolar,7) END AS MontoImpuesto2Local
			, 0 AS MontoDescuentoLocal
			, CASE LISTA.moneda WHEN 'L' THEN DEVOLUCION.mon_dsc ELSE ROUND(DEVOLUCION.mon_dsc * GLOBALES.MontoCambioDolar,7) END AS MontoDesc1Local
			, 0 AS MontoDesc2Local
			, CASE LISTA.moneda WHEN 'D' THEN DEVOLUCION.mon_siv ELSE ROUND(DEVOLUCION.mon_siv / GLOBALES.MontoCambioDolar,7) END AS MontoSinImpDolar
			, CASE LISTA.moneda WHEN 'D' THEN DEVOLUCION.mon_siv + DEVOLUCION.mon_imp_vt ELSE ROUND((DEVOLUCION.mon_siv + DEVOLUCION.mon_imp_vt) / GLOBALES.MontoCambioDolar,7) END AS MontoConImpDolar
			, CASE LISTA.moneda WHEN 'D' THEN DEVOLUCION.mon_imp_vt ELSE ROUND(DEVOLUCION.mon_imp_vt / GLOBALES.MontoCambioDolar,7) END AS MontoImpuesto1Dolar
			, CASE LISTA.moneda WHEN 'D' THEN DEVOLUCION.mon_imp_cs ELSE ROUND(DEVOLUCION.mon_imp_cs / GLOBALES.MontoCambioDolar,7) END AS MontoImpuesto2Dolar
			, 0 AS MontoDescuentoDolar
			, CASE LISTA.moneda WHEN 'D' THEN DEVOLUCION.mon_dsc ELSE ROUND(DEVOLUCION.mon_dsc / GLOBALES.MontoCambioDolar,7) END AS MontoDesc1Dolar
			, 0 AS MontoDesc2Dolar
			, DEVOLUCION.por_dsc_ap AS PorcentajeDesc1
			, 0 AS PorcentajeDesc2
			, NULL AS CondicionPago
			, DEVOLUCION.cod_bod AS Bodega
			, DEVOLUCION.obs_dev AS Observaciones
			, NULL AS PagoContado
		FROM 	ERPADMIN.alFAC_ENC_DEV DEVOLUCION
				, ERPADMIN.NIVEL_LISTA LISTA
				, (SELECT cod_cia AS compania, cond_pago_contad AS CondicionContado, cambiodolar AS MontoCambioDolar
					 FROM ERPADMIN.compania_descripcion) GLOBALES
		WHERE	DEVOLUCION.cod_cia = LISTA.compania
			AND DEVOLUCION.lst_pre = LISTA.lista
			AND DEVOLUCION.cod_cia = GLOBALES.compania
		UNION ALL
		SELECT 
			RECIBO.num_rec AS Documento
			, RECIBO.cod_tip_dc AS TipoDocumento
			, RECIBO.cod_cia AS Compania
			, RECIBO.cod_clt AS Cliente
			, RECIBO.cod_zon AS Ruta
			, RECIBO.fec_pro AS FechaDocumento
			, RECIBO.hor_ini AS Inicio
			, RECIBO.hor_fin AS Fin
			, RECIBO.ind_mon AS Moneda
			, RECIBO.mon_doc_loc AS MontoSinImpLocal
			, RECIBO.mon_doc_loc AS MontoConImpLocal
			, 0 AS MontoImpuesto1Local
			, 0 AS MontoImpuesto2Local
			, 0 AS MontoDescuentoLocal
			, 0 AS MontoDesc1Local
			, 0 AS MontoDesc2Local
			, RECIBO.mon_doc_dol AS MontoSinImpDolar
			, RECIBO.mon_doc_dol AS MontoConImpDolar
			, 0 AS MontoImpuesto1Dolar
			, 0 AS MontoImpuesto2Dolar
			, 0 AS MontoDescuentoDolar
			, 0 AS MontoDesc1Dolar
			, 0 AS MontoDesc2Dolar
			, 0 AS PorcentajeDesc1
			, 0 AS PorcentajeDesc2
			, NULL AS CondicionPago
			, NULL AS Bodega
			, NULL AS Observaciones
			, NULL AS PagoContado 
		FROM 	ERPADMIN.alCXC_DOC_APL RECIBO
	) DOCUMENTOS
		ON VSD.documento = DOCUMENTOS.documento
			AND VSD.tipo_documento = DOCUMENTOS.TipoDocumento
			AND VSD.compania = DOCUMENTOS.Compania
			AND VSD.cliente = DOCUMENTOS.Cliente
			AND VSD.ruta = DOCUMENTOS.Ruta
	LEFT JOIN	ERPADMIN.alFAC_RUTA_ORDEN ORDEN
		ON VST.ruta = ORDEN.cod_zon
			AND VST.cliente = ORDEN.cod_clt
			AND DATEPART(WEEKDAY,VST.inicio)
				= CASE ORDEN.dia WHEN 'D' THEN 1 WHEN 'L' THEN 2 WHEN 'K' THEN 3 WHEN 'M' THEN 4 WHEN 'J' THEN 5 WHEN 'V' THEN 6 WHEN 'S' THEN 7 ELSE 0 END;





CREATE VIEW erpadmin.V_Pedidos_FR AS SELECT '$$COMPANIA$$' AS Compania, p.* FROM $$COMPANIA$$.PEDIDO p;



CREATE VIEW erpadmin.V_MonitoreoPedidos AS
SELECT  afep.COD_CIA 	AS Compania, 
	afep.NUM_PED 	AS Pedido, 
    lar.MONEDA AS Moneda_Documento,
	vc.CLIENTE 	AS Cliente_ERP, 
	vc.NOMBRE 	AS Nombre_Cliente_ERP,
	cr.CLIENTE 	AS Cliente_FR, 
	cr.NOMBRE 	AS Nombre_Cliente_FR, 
	afep.COD_ZON 	AS Ruta, 
	rr.DESCRIPCION 	AS Nombre_Ruta, 
	rar.HANDHELD 	AS HandHeld, 
	hr.DESCRIPCION 	AS Nombre_HandHeld, 
	hr.SERIE 	AS Serie_HandHeld, 
	hr.MODELO 	AS Modelo_HandHel, 
	rar.AGENTE 	AS Agente,
	ar.NOMBRE 	AS Nombre_Agente, 
	CASE afep.DOC_PRO
	   WHEN 'S' THEN 'S'
	   WHEN '' THEN 'N'
	   ELSE ISNULL( afep.DOC_PRO, 'N')
	   END 		AS Cargado_ERP, 
	afep.MON_CIV 	AS Monto, 
	afep.HOR_INI 	AS Inicio, 
	afep.HOR_FIN 	AS fin, 
	afep.FEC_PED 	AS Fecha_Pedido, 
    ERPADMIN.RestarFechas( afep.HOR_INI, afep.HOR_FIN) AS Tiempo_Laborado,
	vpf.ESTADO 	AS Estado, 
	afep.NoteExistsFlag, 
	afep.RecordDate, 
	afep.RowPointer, 
	afep.CreatedBy, 
	afep.UpdatedBy, 
	afep.CreateDate
FROM erpadmin.alFAC_ENC_PED afep
	LEFT JOIN erpadmin.V_Pedidos_FR vpf	 ON vpf.Compania = afep.COD_CIA  AND vpf.PEDIDO = afep.NUM_PED
	INNER JOIN erpadmin.RUTA_ASIGNADA_RT rar ON afep.COD_ZON = rar.RUTA AND afep.TIP_DOC = '1'
	INNER JOIN erpadmin.RUTA_RT rr  	ON rar.RUTA = rr.RUTA
	INNER JOIN erpadmin.HANDHELD_RT hr 	ON rar.HANDHELD = hr.HANDHELD
	INNER JOIN erpadmin.AGENTE_RT ar   	ON rar.AGENTE = ar.AGENTE
	INNER JOIN erpadmin.CLIENTE_RT cr  	ON afep.COD_CLT = cr.CLIENTE
	INNER JOIN erpadmin.CLIENTE_ASOC_RT car ON cr.CLIENTE = car.CLIENTE AND car.COMPANIA = afep.COD_CIA
	INNER JOIN erpadmin.V_CLIENTE vc        ON car.CODIGO = vc.CLIENTE AND car.COMPANIA = vc.COMPANIA
	INNER JOIN erpadmin.LSTPRECIO_ALDO_RT lar ON afep.LST_PRE = lar.LISTA_PRECIO AND afep.COD_CIA = lar.COMPANIA AND lar.RUTA = rr.RUTA;
	





CREATE VIEW erpadmin.V_MonitoreoFacturas AS
SELECT  afep.COD_CIA 	AS Compania, 
	afep.NUM_PED 	AS Factura,
	lar.MONEDA AS Moneda_Documento, 
	vc.CLIENTE 	AS Cliente_ERP, 
	vc.NOMBRE 	AS Nombre_Cliente_ERP,
	cr.CLIENTE 	AS Cliente_FR, 
	cr.NOMBRE 	AS Nombre_Cliente_FR, 
	afep.COD_ZON 	AS Ruta, 
	rr.DESCRIPCION 	AS Nombre_Ruta, 
	rar.HANDHELD 	AS HandHeld, 
	hr.DESCRIPCION 	AS Nombre_HandHeld, 
	hr.SERIE 	AS Serie_HandHeld, 
	hr.MODELO 	AS Modelo_HandHel, 
	rar.AGENTE 	AS Agente, 
	ar.NOMBRE 	AS Nombre_Agente, 
	CASE afep.DOC_PRO
	   WHEN 'S' THEN 'S'
	   WHEN '' THEN 'N'
	   ELSE ISNULL( afep.DOC_PRO, 'N')
	   END 		AS Cargado_ERP, 
	afep.MON_CIV 	AS Monto, 
	afep.HOR_INI 	AS Inicio, 
	afep.HOR_FIN 	AS fin, 
	afep.FEC_PED 	AS Fecha_Factura,
   	ERPADMIN.RestarFechas( afep.HOR_INI, afep.HOR_FIN) AS Tiempo_Laborado,
	afep.NoteExistsFlag, 
	afep.RecordDate, 
	afep.RowPointer, 
	afep.CreatedBy, 
	afep.UpdatedBy, 
	afep.CreateDate
FROM erpadmin.alFAC_ENC_PED afep
	INNER JOIN erpadmin.RUTA_ASIGNADA_RT rar ON afep.COD_ZON = rar.RUTA AND afep.TIP_DOC = 'F'
	INNER JOIN erpadmin.RUTA_RT rr ON rar.RUTA = rr.RUTA
	INNER JOIN erpadmin.HANDHELD_RT hr ON rar.HANDHELD = hr.HANDHELD
	INNER JOIN erpadmin.AGENTE_RT ar ON rar.AGENTE = ar.AGENTE
	INNER JOIN erpadmin.CLIENTE_RT cr ON afep.COD_CLT = cr.CLIENTE
	INNER JOIN erpadmin.CLIENTE_ASOC_RT car ON cr.CLIENTE = car.CLIENTE AND car.COMPANIA = afep.COD_CIA
	INNER JOIN erpadmin.V_CLIENTE vc        ON car.CODIGO = vc.CLIENTE AND car.COMPANIA = vc.COMPANIA
	INNER JOIN erpadmin.LSTPRECIO_ALDO_RT lar ON afep.LST_PRE = lar.LISTA_PRECIO AND afep.COD_CIA = lar.COMPANIA AND lar.RUTA = rr.RUTA;
	






CREATE VIEW erpadmin.V_MonitoreoDevolucion AS
SELECT  afed.COD_CIA 	AS Compania, 
	afed.NUM_DEV 	AS Devolucion,
	lar.MONEDA AS Moneda_Documento,
	vc.CLIENTE 	AS Cliente_ERP, 
	vc.NOMBRE 	AS Nombre_Cliente_ERP,
	cr.CLIENTE 	AS Cliente_FR, 
	cr.NOMBRE 	AS Nombre_Cliente_FR, 
	afed.COD_ZON 	AS Ruta, 
	rr.DESCRIPCION 	AS Nombre_Ruta, 
	rar.HANDHELD 	AS HandHeld, 
	hr.DESCRIPCION 	AS Nombre_HandHeld, 
	hr.SERIE 	AS Serie_HandHeld, 
	hr.MODELO 	AS Modelo_HandHeld, 
	rar.AGENTE 	AS Agente,
	ar.NOMBRE 	AS Nombre_Agente, 
	CASE afed.DOC_PRO
	WHEN 'S' THEN 'S'
	WHEN '' THEN 'N'
	ELSE ISNULL(afed.DOC_PRO, 'N')
	END 		AS Cargado_ERP, 
	afed.MON_SIV 	AS Monto_Bruto, 
	afed.MON_DSC 	AS Monto_Desc, 
	afed.MON_IMP_VT AS Monto_Imp_Venta, 
	afed.MON_IMP_CS AS Monto_Imp_Consumo, 
	( ( afed.MON_SIV - afed.MON_DSC ) + afed.MON_IMP_VT + afed.MON_IMP_CS ) AS Monto_Total,  
	afed.HOR_INI 	AS Inicio, 
	afed.HOR_FIN 	AS fin, 
	afed.FEC_DEV 	AS Fecha_Devolucion,
    ERPADMIN.RestarFechas( afed.HOR_INI, afed.HOR_FIN) AS Tiempo_Laborado,
	afed.NoteExistsFlag, 
	afed.RecordDate, 
	afed.RowPointer, 
	afed.CreatedBy, 
	afed.UpdatedBy, 
	afed.CreateDate
FROM erpadmin.alFAC_ENC_DEV afed
	INNER JOIN erpadmin.RUTA_ASIGNADA_RT rar ON afed.COD_ZON = rar.RUTA
	INNER JOIN erpadmin.RUTA_RT rr  	ON rar.RUTA = rr.RUTA
	INNER JOIN erpadmin.HANDHELD_RT hr  	ON rar.HANDHELD = hr.HANDHELD
	INNER JOIN erpadmin.AGENTE_RT ar     	ON rar.AGENTE = ar.AGENTE
	INNER JOIN erpadmin.CLIENTE_RT cr      	ON afed.COD_CLT = cr.CLIENTE
	INNER JOIN erpadmin.CLIENTE_ASOC_RT car ON cr.CLIENTE = car.CLIENTE AND car.COMPANIA = afed.COD_CIA
	INNER JOIN erpadmin.V_CLIENTE vc        ON car.CODIGO = vc.CLIENTE AND car.COMPANIA = vc.COMPANIA
	INNER JOIN erpadmin.LSTPRECIO_ALDO_RT lar ON afed.LST_PRE = lar.LISTA_PRECIO AND afed.COD_CIA = lar.COMPANIA AND lar.RUTA = rr.RUTA;






CREATE VIEW erpadmin.V_MonitoreoConsignaciones AS
SELECT  afec.COD_CIA AS Compania, 
	afec.NUM_CSG AS Consignacion,
	lar.MONEDA AS Moneda_Documento, 
	vc.CLIENTE AS Cliente_ERP, 
	vc.NOMBRE AS Nombre_Cliente_ERP,
	cr.CLIENTE AS Cliente_FR, 
	cr.NOMBRE AS Nombre_Cliente_FR, 
	afec.COD_ZON AS Ruta, 
	rr.DESCRIPCION AS Nombre_Ruta, 
	rar.HANDHELD AS HandHeld, 
	hr.DESCRIPCION AS Nombre_HandHeld, 
	hr.SERIE AS Serie_HandHeld, 
	hr.MODELO AS Modelo_HandHel, 
	rar.AGENTE AS Agente, ar.NOMBRE AS Nombre_Agente, 
	CASE afec.DOC_PRO
	    WHEN 'S' THEN 'S'
	    WHEN '' THEN 'N'
	    ELSE ISNULL( afec.DOC_PRO, 'N')
	    END AS Cargado_ERP, 
	afec.MONT_DESC1 AS Monto_Desc1, 
	afec.MONT_DESC2 AS Monto_Desc2, 
	afec.MON_IMP_VT AS Monto_Imp_Ventas, 
	afec.MON_IMP_CS Monto_Imp_Consumo, 
	afec.MON_SIV AS Monto_Documento,
	afec.NUM_ITM AS Lineas, 
	afec.COD_BOD AS Bodega, 
	vbc.NOMBRE AS Nombre_Bodega, 
	afec.DESCUENTO_CASCADA AS Descuento_Cascada, 
	afec.IMPRESO AS Impreso,
	afec.HOR_INI AS Inicio, 
	afec.HOR_FIN AS Fin, 
	afec.FEC_BOLETA AS Fecha, 
	ERPADMIN.RestarFechas( afec.HOR_INI, afec.HOR_FIN) AS Tiempo_Laborado,
	afec.NoteExistsFlag, 
	afec.RecordDate, 
	afec.RowPointer, 
	afec.CreatedBy, 
	afec.UpdatedBy, 
	afec.CreateDate
FROM erpadmin.alFAC_ENC_CONSIG afec
	INNER JOIN erpadmin.V_BODEGA_CONSIGNACION vbc ON afec.COD_CIA = vbc.COMPANIA AND afec.COD_BOD = vbc.BODEGA              
	INNER JOIN erpadmin.RUTA_ASIGNADA_RT rar ON afec.COD_ZON = rar.RUTA
	INNER JOIN erpadmin.RUTA_RT rr         	 ON rar.RUTA = rr.RUTA
	INNER JOIN erpadmin.HANDHELD_RT hr   	 ON rar.HANDHELD = hr.HANDHELD
	INNER JOIN erpadmin.AGENTE_RT ar     	 ON rar.AGENTE = ar.AGENTE
	INNER JOIN erpadmin.CLIENTE_RT cr   	 ON afec.COD_CLT = cr.CLIENTE
	INNER JOIN erpadmin.CLIENTE_ASOC_RT car  ON cr.CLIENTE = car.CLIENTE AND car.COMPANIA = afec.COD_CIA
	INNER JOIN erpadmin.V_CLIENTE vc        ON car.CODIGO = vc.CLIENTE AND car.COMPANIA = vc.COMPANIA
	INNER JOIN erpadmin.LSTPRECIO_ALDO_RT lar ON afec.LST_PRE = lar.LISTA_PRECIO AND afec.COD_CIA = lar.COMPANIA AND lar.RUTA = rr.RUTA;





CREATE VIEW erpadmin.V_MonitoreoCobros AS
SELECT  acda.COD_CIA 	 AS Compania, 
	acda.NUM_REC 	 AS Cobro, 
	vc.CLIENTE 	 AS Cliente_ERP, 
	vc.NOMBRE 	 AS Nombre_Cliente_ERP,
	cr.CLIENTE 	 AS Cliente_FR, 
	cr.NOMBRE 	 AS Nombre_Cliente_FR, 
	acda.COD_ZON 	 AS Ruta, 
	rr.DESCRIPCION 	 AS Nombre_Ruta, 
	rar.HANDHELD 	 AS HandHeld, 
	hr.DESCRIPCION 	 AS Nombre_HandHeld, 
	hr.SERIE 	 AS Serie_HandHeld, 
	hr.MODELO 	 AS Modelo_HandHel, 
	rar.AGENTE 	 AS Agente, 
	ar.NOMBRE 	 AS Nombre_Agente, 
	CASE acda.DOC_PRO
	    WHEN 'S' THEN 'S'
	    WHEN '' THEN 'N'
	    ELSE ISNULL( acda.DOC_PRO, 'N')
	    END 	 AS Cargado_ERP, 
	    acda.IND_MON AS Moneda_Documento,
	acda.MON_DOC_LOC AS Monto_Doc_Local, 
	acda.MON_DOC_DOL AS Monto_Doc_Dolar, 
	acda.MON_EFE_LOCAL AS Monto_Efectivo_Local, 
	acda.MON_EFE_DOLAR AS Monto_Efectivo_Dolar,
	acda.MON_CHE_LOCAL AS Monto_Cheque_Local, 
	acda.MON_CHE_DOLAR AS Monto_Cheque_Dolar, 
	acda.HOR_INI 	 AS Inicio, 
	acda.HOR_FIN 	 AS fin, 
	acda.FEC_PRO 	 AS Fecha_Cobro,
    ERPADMIN.RestarFechas( acda.HOR_INI, acda.HOR_FIN) AS Tiempo_Laborado,
	acda.NoteExistsFlag, 
	acda.RecordDate, 
	acda.RowPointer, 
	acda.CreatedBy, 
	acda.UpdatedBy, 
	acda.CreateDate
FROM erpadmin.alCXC_DOC_APL acda
	INNER JOIN erpadmin.RUTA_ASIGNADA_RT rar ON acda.COD_ZON = rar.RUTA
	INNER JOIN erpadmin.RUTA_RT rr    	 ON rar.RUTA = rr.RUTA
	INNER JOIN erpadmin.HANDHELD_RT hr  	 ON rar.HANDHELD = hr.HANDHELD
	INNER JOIN erpadmin.AGENTE_RT ar    	 ON rar.AGENTE = ar.AGENTE
	INNER JOIN erpadmin.CLIENTE_RT cr  	 ON acda.COD_CLT = cr.CLIENTE
	INNER JOIN erpadmin.CLIENTE_ASOC_RT car  ON cr.CLIENTE = car.CLIENTE AND car.COMPANIA = acda.COD_CIA
	INNER JOIN erpadmin.V_CLIENTE vc     	 ON car.CODIGO = vc.CLIENTE AND car.COMPANIA = vc.COMPANIA ;
	
	





CREATE VIEW erpadmin.V_MonitoreoDepositos AS
SELECT  aced.COD_CIA 	AS Compania, 
	aced.NUM_DEP 	AS Deposito, 
	aced.CTA_BCO 	AS Cuenta_Banco, 
	accb.NOM_CTA 	AS Nombre_Cuenta, 
	aced.COD_BCO 	AS Banco, 
	acb.DES_BCO 	AS Nombre_Banco, 
	aced.NOTAS 	AS Notas,
	CASE aced.DOC_PRO
	   WHEN 'S' THEN 'S'
	   WHEN ''  THEN 'N'
	   ELSE ISNULL( aced.DOC_PRO, 'N')
	   END 		AS Cargado_ERP, aced.IND_MON AS Moneda_Documento, aced.FEC_DEP AS Fecha_Deposito,
	aced.MON_DEP 	AS Monto_Deposito, 
    	aced.NoteExistsFlag, 
    	aced.RecordDate, 
    	aced.RowPointer, 
    	aced.CreatedBy, 
    	aced.UpdatedBy, 
    	aced.CreateDate
FROM erpadmin.alCXC_ENC_DEP aced
	INNER JOIN erpadmin.alCXC_CTA_BCO accb  ON accb.CTA_BCO = aced.CTA_BCO
		AND accb.COD_BCO = aced.COD_BCO AND accb.COD_CIA = aced.COD_CIA
	INNER JOIN erpadmin.alCXC_BCO acb   	ON acb.COD_BCO = accb.COD_BCO
		AND acb.COD_CIA = accb.COD_CIA;




CREATE VIEW ERPADMIN.V_MonitoreoGarantias AS
SELECT     afep.COD_CIA AS Compania, 
               afep.NUM_GAR AS Garantia, 
               lar.MONEDA AS Moneda_Documento, 
               vc.CLIENTE AS Cliente_ERP, 
               vc.NOMBRE AS Nombre_Cliente_ERP, 
           cr.CLIENTE AS Cliente_FR, 
           cr.NOMBRE AS Nombre_Cliente_FR, 
           afep.COD_ZON AS Ruta, 
           rr.DESCRIPCION AS Nombre_Ruta, 
           rar.HANDHELD, 
           hr.DESCRIPCION AS Nombre_HandHeld, 
           hr.SERIE AS Serie_HandHeld, 
           hr.MODELO AS Modelo_HandHel, 
           rar.AGENTE, ar.NOMBRE AS Nombre_Agente, 
               CASE afep.DOC_PRO WHEN 'S' THEN 'S' WHEN '' THEN 'N' ELSE ISNULL(afep.DOC_PRO, 'N') END AS Cargado_ERP, 
           afep.MON_TOT AS Monto, 
           afep.FEC_GAR AS Fecha_Garantia, 
		   afep.Asiento_Contable AS Asiento_Contable, 
           afep.NoteExistsFlag, 
           afep.RecordDate, 
           afep.RowPointer, 
           afep.CreatedBy, 
           afep.UpdatedBy, 
           afep.CreateDate          
FROM       ERPADMIN.alFAC_ENC_GARANTIA AS afep INNER JOIN
           ERPADMIN.RUTA_ASIGNADA_RT AS rar ON afep.COD_ZON = rar.RUTA INNER JOIN
           ERPADMIN.RUTA_RT AS rr ON rar.RUTA = rr.RUTA INNER JOIN
           ERPADMIN.HANDHELD_RT AS hr ON rar.HANDHELD = hr.HANDHELD INNER JOIN
           ERPADMIN.AGENTE_RT AS ar ON rar.AGENTE = ar.AGENTE INNER JOIN
           ERPADMIN.CLIENTE_RT AS cr ON afep.COD_CLT = cr.CLIENTE INNER JOIN
           ERPADMIN.CLIENTE_ASOC_RT AS car ON cr.CLIENTE = car.CLIENTE AND car.COMPANIA = afep.COD_CIA INNER JOIN
           ERPADMIN.V_CLIENTE AS vc ON car.CODIGO = vc.CLIENTE AND car.COMPANIA = vc.COMPANIA INNER JOIN
           ERPADMIN.LSTPRECIO_ALDO_RT AS lar ON afep.LST_PRE = lar.LISTA_PRECIO AND afep.COD_CIA = lar.COMPANIA AND lar.RUTA = rr.RUTA;
           
           
           


CREATE VIEW ERPADMIN.V_SUBTIPO_NOTACREDITO_CC  
( COMPANIA, TIPO,SUBTIPO,DESCRIPCION ,NOTEEXISTSFLAG, RECORDDATE, ROWPOINTER, CREATEDBY, UPDATEDBY,CREATEDATE )
AS
  SELECT '$$COMPANIA$$' AS COMPANIA, 
    
	TIPO,
	SUBTIPO,
	DESCRIPCION,
	NOTEEXISTSFLAG,
	RECORDDATE,
	ROWPOINTER,
	CREATEDBY,
	UPDATEDBY,
	CREATEDATE 
	FROM $$COMPANIA$$.SUBTIPO_DOC_CC 
	WHERE TIPO = 'N/C';





CREATE VIEW ERPADMIN.V_SUBTIPO_NOTADEBITO_CC 
( COMPANIA, TIPO,SUBTIPO,DESCRIPCION ,NOTEEXISTSFLAG, RECORDDATE, ROWPOINTER, CREATEDBY, UPDATEDBY,CREATEDATE )
AS
  SELECT '$$COMPANIA$$' AS COMPANIA, 
    
	TIPO,
	SUBTIPO,
	DESCRIPCION,
	NOTEEXISTSFLAG,
	RECORDDATE,
	ROWPOINTER,
	CREATEDBY,
	UPDATEDBY,
	CREATEDATE 
	FROM $$COMPANIA$$.SUBTIPO_DOC_CC 
	WHERE TIPO = 'N/D';





CREATE VIEW ERPADMIN.V_SUBTIPO_RECIBO_CC  
( COMPANIA, TIPO,SUBTIPO,DESCRIPCION ,NOTEEXISTSFLAG, RECORDDATE, ROWPOINTER, CREATEDBY, UPDATEDBY,CREATEDATE )
AS
  SELECT '$$COMPANIA$$' AS COMPANIA,  
    
	TIPO,
	SUBTIPO,
	DESCRIPCION,
	NOTEEXISTSFLAG,
	RECORDDATE,
	ROWPOINTER,
	CREATEDBY,
	UPDATEDBY,
	CREATEDATE 
	FROM $$COMPANIA$$.SUBTIPO_DOC_CC 
	WHERE TIPO = 'REC';







CREATE FUNCTION ERPADMIN.FR_DISTANCIA_GPS(
@LATITUD1 DECIMAL(28,8) ,@LONGITUD1 DECIMAL(28,8),@LATITUD2 DECIMAL(28,8),@LONGITUD2 DECIMAL(28,8))
RETURNS FLOAT
AS
BEGIN
	DECLARE @resultado FLOAT
	DECLARE @dtr FLOAT
	DECLARE @rtd FLOAT
	SET @dtr = PI() / 180
	SET @rtd = 180 / PI()
	SET @resultado = ACOS((SIN(@LATITUD1 * @dtr) * SIN(@LATITUD2 * @dtr)) 
		+ (COS(@LATITUD1 * @dtr) * COS(@LATITUD2 * @dtr) * COS((@LONGITUD1 - @LONGITUD2) * @dtr))) * @rtd * 111.302 * 1000
	RETURN(@resultado)
END;





CREATE FUNCTION ERPADMIN.FR_VISITA_VALIDA(@RUTA VARCHAR(4),@DISTANCIA FLOAT)
RETURNS INT
AS
BEGIN
	DECLARE @PERMITIDA FLOAT
	DECLARE @RESULTADO INT
	SELECT @PERMITIDA = CONVERT(DECIMAL(28,8),gc.VALOR) 
					FROM erpadmin.GLOBALES_CONF_FR gc
						INNER JOIN erpadmin.RUTA_ASIGNADA_RT ra 
						ON gc.HANDHELD = ra.HANDHELD
					WHERE ra.RUTA = @RUTA
					AND gc.CONSTANTE = 'CG_DISTANCIA_UBI_CLIENTE'
	IF(@DISTANCIA <= @PERMITIDA)
		SET @RESULTADO =  1
	ELSE
		SET @RESULTADO = 0	
	RETURN @RESULTADO
END;




CREATE FUNCTION ERPADMIN.TO_DEGREES_MINUTES_SECONDS(@DECIMAL_DEGREES DECIMAL(28,8))
RETURNS VARCHAR(100)
AS 
BEGIN
	DECLARE @RESULT VARCHAR(100)
	DECLARE @DEGREES INT
	DECLARE @MINUTES INT
	DECLARE @FLOAT_MINUTES FLOAT
	DECLARE @SECONDS FLOAT
	
	SET @DEGREES = CONVERT(INT,ABS(@DECIMAL_DEGREES))
	SET @FLOAT_MINUTES = (ABS(@DECIMAL_DEGREES) - ABS(CONVERT(FLOAT,@DEGREES))) * 60.0
	SET @MINUTES = CONVERT(INT,ABS(@FLOAT_MINUTES))
	SET @SECONDS = (@FLOAT_MINUTES - CONVERT(FLOAT,@MINUTES)) * 60.0
	SET @RESULT = CONVERT(VARCHAR(10),@DEGREES) + '° ' + CONVERT(VARCHAR(10),@MINUTES) + ''' ' + CONVERT(VARCHAR(10),@SECONDS) + '"'
	
	RETURN @RESULT

END;






CREATE VIEW ERPADMIN.V_UBICACIONES_VISITA
AS
SELECT vu.RUTA,vu.INICIO,CONVERT(VARCHAR(8), vis.INICIO, 3) AS FECHA 
	, CONVERT(VARCHAR(8),vis.FIN, 108) AS HORA_FIN
	, vis.CLIENTE, cli.NOMBRE NOMBRE_CLIENTE
	, cu.LATITUD LATITUD_CLIENTE, cu.LONGITUD LONGITUD_CLIENTE
	, vu.LATITUD LATITUD_VISITA, vu.LONGITUD LONGITUD_VISITA
	, erpadmin.FR_DISTANCIA_GPS(cu.LATITUD,cu.LONGITUD,vu.LATITUD,vu.LONGITUD) DISTANCIA_METROS
	, CASE WHEN cu.LATITUD is not null or cu.LONGITUD is not null
		THEN erpadmin.TO_DEGREES_MINUTES_SECONDS(cu.LATITUD) + ',' + erpadmin.TO_DEGREES_MINUTES_SECONDS(cu.LONGITUD) 
		ELSE 'Ubicación No Registrada' END AS UBICACION_CLIENTE 
	, CASE WHEN vu.LATITUD is not null or vu.LONGITUD is not null 
		THEN erpadmin.TO_DEGREES_MINUTES_SECONDS(vu.LATITUD) + ',' + erpadmin.TO_DEGREES_MINUTES_SECONDS(vu.LONGITUD)
		ELSE 'Ubicación No Registrada' END AS UBICACION_VISITA
	, erpadmin.FR_VISITA_VALIDA(vu.RUTA,erpadmin.FR_DISTANCIA_GPS(cu.LATITUD,cu.LONGITUD,vu.LATITUD,vu.LONGITUD)) VISITA_VALIDA
	, razon.EFECT_VISITA RAZON
	, razon.DESCRIPCION RAZON_VISITA
	, vsd.DOCUMENTO
FROM erpadmin.VISITA_UBICACION vu
	LEFT JOIN erpadmin.CLIENTE_UBICACION cu ON vu.CLIENTE = cu.CLIENTE AND vu.RUTA = cu.RUTA
	LEFT JOIN erpadmin.VISITA vis 		ON vu.INICIO = vis.INICIO AND vu.RUTA = vis.RUTA AND vu.CLIENTE = vis.CLIENTE
	LEFT JOIN erpadmin.EFECT_VISITA_RT razon ON vis.RAZON = razon.EFECT_VISITA
	LEFT JOIN erpadmin.CLIENTE_RT cli 	ON vu.CLIENTE = cli.CLIENTE
	LEFT JOIN erpadmin.VISITA_DOCUMENTO vsd ON vis.CLIENTE = vsd.CLIENTE AND vis.RUTA = vsd.RUTA AND vis.INICIO = vsd.INICIO;







CREATE VIEW ERPADMIN.V_CONSECUTIVO_FA(COMPANIA, CODIGO_CONSECUTIVO, DESCRIPCION, VALOR_CONSECUTIVO, 
	LONGITUD, MASCARA,NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate ) AS		
		SELECT '$$COMPANIA$$' AS COMPANIA, CODIGO_CONSECUTIVO, DESCRIPCION, VALOR_CONSECUTIVO, 
		LONGITUD, MASCARA,NoteExistsFlag, RecordDate, RowPointer, CreatedBy, UpdatedBy, CreateDate 
			FROM $$COMPANIA$$.CONSECUTIVO_FA;
			
			
			
 CREATE VIEW ERPADMIN.V_MonitoreoTraspasos AS
 SELECT TRS.Consecutivo,TRS.Compania,TRS.HandHeld,TRS.FECHA AS Fecha,TRS.Articulo,TRS.Bodega,TRS.Localizacion,TRS.Lote, 
 CASE TRS.Tipo WHEN 'E' THEN 'Entrada'  ELSE 'Salida' END AS Tipo,
 CASE TRS.Clase WHEN 'L' THEN 'Lleno'	ELSE 'Vacío'  END AS Clase,
 TRS.Cant_dif AS Cantidad,
 CASE TRS.Estado WHEN 'P'  THEN 'Pendiente' ELSE 'Aplicado' END AS Estado,
 TRS.OBS AS Observaciones,
 TRS.NoteExistsFlag,
 TRS.RecordDate,
 TRS.RowPointer,
 TRS.CreatedBy,
 TRS.UpdatedBy,
 TRS.CreateDate
 FROM  ERPADMIN.TRASIEGO TRS;