REMARK
\
SCRIPT DE MODIFICACION EXACTUS
=================================================================
MODULO:     POS
VERSION ANTERIOR: 6.0
VERSION QUE GENERA: 6.0
DBMS:     SQL SERVER
FECHA:      12/11/2007
ANALISTA:   MALFARO
DESCRIPCION:    Modi de Generacion de Tienda 6, Elimina las tablas de exactus que el POS no
      necesita
ATENCION !!!:
    Estas sentencias SQL deben de ejecutarse conectado como el
    el Usuario Administrador. Para el correcto funcionamiento del mismo!!!
    
    Se debe sustituir $$Compania$$ por el nombre de la compa��a.
=================================================================
/
;
DECLARE
  @LSRENAMETABLA AS VARCHAR(1000),
  @LSCOMPANIA AS VARCHAR(20),
  @LSTABLASPOS AS VARCHAR(4000),
  @LNNUMTABLAS AS INT,
  @LNNUMTABANT AS INT
SET @LSCOMPANIA = '$$Compania$$'
SET @LSTABLASPOS = ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ACCION' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ACCION_VERSION' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'AFILIADO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'AJUSTE_CONFIG' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ALIAS_PRODUCCION' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ARCHIVO_APLICADO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ARTICULO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ARTICULO_COLOR' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ARTICULO_CUENTA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ARTICULO_ENSAMBLE ' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ARTICULO_ESPE' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ARTICULO_ESTILO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ARTICULO_FOTO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ARTICULO_PADRE_HIJO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ARTICULO_PRECIO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ARTICULO_SERIE_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ARTICULO_TALLA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'AUDITORIA_DE_PROC' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'AUDIT_CUPON' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'AUDIT_TRANS_INV' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'AUXILIAR_CC' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'AUXILIAR_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'BITACORA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'BITACORA_PROCESO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'BODEGA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'BONIF_ART_X_CLI' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'BONIF_CLAS_X_CLI' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'BONO_CATEGORIA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'BONO_PAGO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'BONO_TIENDA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CADENA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CAJA_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CAJERO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CARGA_CCCB_ERRORES' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CARPETA_FAVORITOS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CATEGORIA_CLIENTE' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CENTRO_COSTO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CENTRO_CUENTA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CIERRE_CAJA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CIERRE_DESG_TARJ' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CIERRE_DET_PAGO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CIERRE_INFO_TARJ' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CIERRE_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CIERRE_TIENDA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CLASE_DOC_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CLASIFICACION' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CLASIFICACION_ADI' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CLASIFICACION_ADI_VALOR' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CLASIFIC_ADI_ARTICULO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CLIENTE' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CLIENTE_EXPRESS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CLIENTE_EXPR_ENTR' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CLIENTE_FORMA_PAGO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CLIENTE_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CLIENTE_RETENCION' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CLIENTE_VENDEDOR' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'COBRADOR ' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'COBRO_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CONDICION_PAGO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CONEXION' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CONFIGURACION' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CONFIG_CAJA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CONFIG_ENVIOS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CONFIG_SEGURIDAD' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CONFIG_TARJETAS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CONJUNTO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CONSECUTIVO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CONSECUTIVO_CI' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CONSECUTIVO_FA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CONSECUTIVO_USUARIO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CONSEC_CAJA_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CONTROL' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'COSTO_UEPS_PEPS' + ' ' 
SET @LSTABLASPOS = @LSTABLASPOS + 'CUENTA_BANCARIA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CUENTA_CONTABLE' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'CUPON' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DCTO_ART_X_CLI' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DCTO_CLAS_X_CLI' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DD_AREA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DD_CARGA_CONSTR' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DD_CARGA_DICCIO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DD_CARGA_ENCDET' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DD_MODULO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DD_MODULO_TABLA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DD_PROPIETARIO_TABLA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DD_TABLA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DENOMINACION' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DEPOSITO_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DES_BON_ESCALA_BONIFICACION' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DES_BON_ESPECIFICACION_GRUPO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DES_BON_PAQUETE' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DES_BON_PAQUETE_REGLA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DES_BON_PAQUETE_RUTA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DES_BON_PAQUETE_TIENDA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DES_BON_REGLA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DES_BON_REGLA_LOTE' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DETALLE_DIRECCION' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DET_MOD_RETENCION' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DET_REG_BILLETE' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DIRECCION' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DIRECC_CLIENTE_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DIRECC_EMBARQUE' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DIVISION_GEOGRAFICA1' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DIVISION_GEOGRAFICA2' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DOCUMENTOS_CC' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DOCUMENTO_EN_ESPERA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DOCUMENTO_LINEA_ESPERA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DOCUMENTO_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DOC_ADJUNTO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DOC_ESPERA_SERIE_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DOC_POS_LINEA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DOC_POS_RETENCION' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ELIMINACION_SINCRO_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ENC_TABLA_UDF' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ENTIDAD_FINANCIERA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ERROR_CAJA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ESCALA_BONIF' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ESCALA_DCTO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'EXCEP_CIUDAD' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'EXCEP_REGIMEN' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'EXISTENCIA_BODEGA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'EXISTENCIA_LOTE' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'EXISTENCIA_RESERVA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'EXISTENCIA_SERIE' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'FACTURA_DEVUELTA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'FAVORITOS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'FORMA_PAGO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'GLOBALES' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'GLOBALES_AS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'GLOBALES_CC' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'GLOBALES_CI' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'GLOBALES_FA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'GLOBALES_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'GRUPO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'GRUPO_CAJA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'HIST_MEMBRESIA_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'HISTORIAL_DESCUENTOS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'HOOK_DETALLE' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'HOOK_PERSONALIZ' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'IMPUESTO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'IMPUESTO_ADICIONAL' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'INCONSISTENCIA_SINC_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'INFO_DOC_SEGURO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'INFO_REG_BILLETE' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'LICENCIA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'LOCALIZACION' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'LOCKS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'LOTE' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'MEMBRESIA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'MEMBRESIA_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'MENSAJERO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'MODELO_RETENCION' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'MODULO_INSTALADO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'MONEDA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'MOTIVO_CANCEL_EXPR' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'NCF_CAJA_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'NCF_CONSECUTIVO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'NCF_CONSECUTIVO_USUARIO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'NCF_SECUENCIA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'NIT' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'NIVEL_PRECIO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'OPCION_CONFIG' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ORDEN_COMPRA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ORDEN_COMPRA_LINEA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'PAGO_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'PAIS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'PAQUETE' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'PAQUETE_INVENTARIO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'PARENTESCO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'PEDIDO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'PEDIDO_LINEA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'PERFIL_CLIENTE' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'PERIODO_CONTABLE' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'PREFERENCIA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'PRIVILEGIO_EX' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'REGIMENES' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'REPORTE_DETALLE' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'REPORTE_PERSONALIZ' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'REPORTE_PREF' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'REPORTE_USUARIO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'RESOLUCION_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'RETENCIONES' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'RUTA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'SERIE_PLANTILLA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'SITE' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'SUBTIPO_DOC_CC' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'SUPERVISOR' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'TABLA_UDF' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'TIENDA_OFFLINE' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'TIENDA_OFF_GRUPO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'TIPO_ASIENTO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'TIPO_CAMBIO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'TIPO_CAMBIO_HIST' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'TIPO_DOC_DEFAULT' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'TIPO_TARJETA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'TIPO_TARJETA_CAJA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'TIPO_TARJETA_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'TRANSACCION_INV' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'TRASPASO_POS' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'TRASPASO_POS_DET' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'UNIDAD_DE_MEDIDA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'UNIDAD_FRACCION' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'USUARIO' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'USUARIO_ACTUAL' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'USUARIO_BODEGA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'VENDEDOR' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'VERSION_NIVEL' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ZONA' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'AccountAuthorizations' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ActiveBGTasks' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ApplicationMessages' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'AuditLog' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'AuditLogTypes' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'BGTaskDefinitions' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'BGTaskHistory' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ClassNotes' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'DefaultTypes' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'GroupNames' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'LanguageIDs' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'LoginCfg' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'MGDataSourceMaps' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'MGDataSources' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'MessageTypes' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'NoteHeaders' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'NoteTypes' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ODTColumns' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ODTObjectDepends' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ODTObjects' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ODTTableColumns' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ODTTables' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ObjectBuildMessages' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ObjectMainMessages' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ObjectNotes' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ObjectTypes' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'OutputFormats' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ProcessErrorLog' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ProcessLineNumbers' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ProductVersion' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'ReportOptions' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'SpecificNotes' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'SystemNotes' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'SystemProcessDefaults' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'TaskExclusion' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'TaskTypes' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'UserDefinedFields' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'UserDefinedTypeValues' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'UserDefinedTypes' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'UserGroupMap' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'UserNames' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'UserNotes' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'UserProcessDefaults' + ' '
SET @LSTABLASPOS = @LSTABLASPOS + 'dtproperties' + ' '
SET @LNNUMTABANT = 0
SELECT  @LNNUMTABLAS = COUNT(*)
FROM  SYSOBJECTS O,
  SYSUSERS U
WHERE O.XTYPE = 'u'
  AND U.UID = O.UID
  AND NOT O.NAME LIKE 'TEMP%'
  AND (CHARINDEX(' ' + O.NAME + ' ',@LSTABLASPOS) = 0 OR U.NAME NOT IN (@LSCOMPANIA, 'DBO','ERPADMIN'))
WHILE @LNNUMTABLAS > 0 AND @LNNUMTABLAS <> @LNNUMTABANT
BEGIN
  PRINT('======================================================================')
  PRINT( 'ENTRE: ' + CONVERT(VARCHAR(30), @LNNUMTABLAS) + ' ANTES: ' + CONVERT(VARCHAR(30), @LNNUMTABANT))
  DECLARE C_TABLAS CURSOR FOR
    SELECT 'DROP TABLE ' + U.NAME + '.' + UPPER(O.NAME)
    FROM SYSOBJECTS O, SYSUSERS U
    WHERE O.XTYPE = 'u'
    AND U.UID = O.UID
    AND NOT O.NAME LIKE 'TEMP%'
    AND (CHARINDEX(' ' + O.NAME + ' ',@LSTABLASPOS) = 0 OR U.NAME NOT IN (@LSCOMPANIA, 'DBO', 'ERPADMIN'))
    ORDER BY CRDATE
  OPEN C_TABLAS
  FETCH C_TABLAS INTO @LSRENAMETABLA
  WHILE @@FETCH_STATUS >= 0
  BEGIN
    EXEC (@LSRENAMETABLA)
    FETCH C_TABLAS INTO @LSRENAMETABLA
  END
  DEALLOCATE C_TABLAS
  SET @LNNUMTABANT = @LNNUMTABLAS
  SELECT  @LNNUMTABLAS = COUNT(*)
  FROM  SYSOBJECTS O,
    SYSUSERS U
  WHERE O.XTYPE = 'u'
    AND U.UID = O.UID
    AND NOT O.NAME LIKE 'TEMP%'
    AND (CHARINDEX(' ' + O.NAME + ' ',@LSTABLASPOS) = 0 OR U.NAME NOT IN (@LSCOMPANIA, 'DBO', 'ERPADMIN'))
  PRINT( 'SALI: ' + CONVERT(VARCHAR(30), @LNNUMTABLAS) + ' ANTES: ' + CONVERT(VARCHAR(30), @LNNUMTABANT))
  PRINT('======================================================================')
END;
