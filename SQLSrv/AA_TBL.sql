CREATE TABLE AA_SERIE_CADENA_SINCRO
(
	SERIE_CADENA	INT		NOT NULL,
	USUARIO		VARCHAR (10)	NOT NULL
)
go


ALTER TABLE AA_SERIE_CADENA_SINCRO
	ADD CONSTRAINT AA_SERIE_CADENA_SINCRO_PK 	
		PRIMARY KEY (SERIE_CADENA)
go		
	
CREATE TABLE AA_SERIE_CADENA_DET_SINCRO
(
	SERIE_CADENA	INT		NOT NULL,
	SERIE_INICIAL	VARCHAR (20)	NOT NULL,
	CANTIDAD	INT		NOT NULL
)
go

ALTER TABLE AA_SERIE_CADENA_DET_SINCRO
	ADD CONSTRAINT AA_SERIE_CADENA_DET_SINCRO_PK 
		PRIMARY KEY (SERIE_CADENA, SERIE_INICIAL)
go

CREATE TABLE ARTICULO_ALTERNO_SINCRO (
       ARTICULO             VARCHAR(20) NOT NULL,
       ALTERNO              VARCHAR(20) NOT NULL,
       ID_SINCRO            VARCHAR(15) NOT NULL,
       PRIORIDAD            smallint NULL,
       ID_PDA               VARCHAR(15) NOT NULL
)
go


ALTER TABLE  ARTICULO_ALTERNO_SINCRO
       ADD CONSTRAINT ARTICULO_ALTERNO_SINCRO_PK PRIMARY KEY (ARTICULO, ALTERNO, ID_SINCRO)
go

CREATE TABLE ARTICULO_SINCRO (
	ARTICULO             	VARCHAR(20) NOT NULL,
	ID_SINCRO            	VARCHAR(15) NOT NULL,
	PLANTILLA_SERIE      	VARCHAR(4) NULL,
	DESCRIPCION          	VARCHAR(254) NULL,
	UNIDAD_ALMACEN       	VARCHAR(6) NULL,
	UNIDAD_EMPAQUE       	VARCHAR(6) NULL,
	UNIDAD_VENTA         	VARCHAR(6) NULL,
	FACTOR_EMPAQUE       	DECIMAL(28,8) NULL,
	FACTOR_VENTA         	DECIMAL(28,8) NULL,
	CODIGO_BARRAS_VENT   	VARCHAR(20) NULL,
	CODIGO_BARRAS_INVT   	VARCHAR(20) NULL,
	USA_LOTES            	VARCHAR(1) NULL,
	OBLIGA_CUARENTENA    	VARCHAR(1) NULL,
	DIAS_CUARENTENA      	smallint NULL,
	PROVEEDOR            	VARCHAR(20) NULL,
	ARTICULO_DEL_PROV    	VARCHAR(20) NULL,
	USA_NUMEROS_SERIE    	VARCHAR(1) NULL,
	VIDA_UTIL_PROM       	int NULL,
	IMPUESTO             	VARCHAR(4) NULL,
	CLASIFICACION_1      	VARCHAR(12) NULL,
	CLASIFICACION_2      	VARCHAR(12) NULL,
	CLASIFICACION_3      	VARCHAR(12) NULL,
	CLASIFICACION_4      	VARCHAR(12) NULL,
	CLASIFICACION_5      	VARCHAR(12) NULL,
	CLASIFICACION_6      	VARCHAR(12) NULL,
	PERECEDERO		VARCHAR(1) NOT NULL,
	ARTICULO_CUENTA      	VARCHAR(4) NULL,
	COSTO_FISCAL         	DECIMAL(28,8) NULL,
	NOTAS                	TEXT NULL,
	ID_PDA               	VARCHAR(15) NOT NULL,
	CREADO_EN_PDA        	VARCHAR(1) NULL,
	MODIFICADO_EN_PDA    	VARCHAR(1) NULL
)
go


ALTER TABLE  ARTICULO_SINCRO
       ADD CONSTRAINT ARTICULO_SINCRO_PK PRIMARY KEY (ARTICULO,ID_SINCRO)
go

CREATE TABLE DESPACHO_DETALLE_SINCRO (
       LINEA                int NOT NULL,
       DESPACHO             VARCHAR(12) NOT NULL,
       ARTICULO             VARCHAR(20) NULL,
       ID_SINCRO            VARCHAR(15) NOT NULL,
       CANTIDAD             DECIMAL(28,8) NULL,
       LOTE                 VARCHAR(15) NULL,
       LOCALIZACION         VARCHAR(8) NULL,
       COSTO_LOCAL          DECIMAL(28,8) NULL,
       COSTO_DOLAR          DECIMAL(28,8) NULL,
       DOCUM_ORIG           VARCHAR(50) NULL,
       TIPO_DOCUM_ORIG      VARCHAR(1) NULL,
       BODEGA               VARCHAR(4) NULL,
       LINEA_DOCUM_ORIG     int NULL,
       TIPO_LINEA           VARCHAR(1) NULL,
       ID_PDA               VARCHAR(15) NOT NULL
)
go

ALTER TABLE  DESPACHO_DETALLE_SINCRO
       ADD CONSTRAINT DESPACHO_DETALLE_SINCRO_PK PRIMARY KEY (LINEA, DESPACHO, ID_SINCRO)
go

CREATE TABLE DESPACHO_SINCRO (
       DESPACHO             VARCHAR(12) NOT NULL,
       CONSECUTIVO          VARCHAR(10) NULL,
       ID_SINCRO            VARCHAR(15) NOT NULL,
       CLIENTE              VARCHAR(20) NULL,
       FECHA                DATETIME NULL,
       TRANSPORTISTA        VARCHAR(80) NULL,
       NOTAS_TRANSPORTE     VARCHAR(255) NULL,
       DIRECCION_EMBARQUE   VARCHAR(4) NULL,
       EMBARCAR_A           VARCHAR(80) NULL,
       ESTADO               VARCHAR(1) NULL,
       OBSERVACIONES        TEXT NULL,
       FCH_HORA_CREACION    DATETIME NULL,
       USUARIO_CREACION     VARCHAR(10) NULL,
       CARGADO_CG           VARCHAR(1) NULL,
       ASIENTO_DESPACHO     VARCHAR(10) NULL,
       ID_PDA               VARCHAR(15) NOT NULL
)
go


ALTER TABLE  DESPACHO_SINCRO
       ADD CONSTRAINT DESPACHO_SINCRO_PK PRIMARY KEY (DESPACHO, ID_SINCRO)
go

CREATE TABLE DOCUMENTO_INV_SINCRO (
       DOCUMENTO_INV        VARCHAR(50) NOT NULL,
       PAQUETE_INVENTARIO   VARCHAR(4) NOT NULL,
       CONSECUTIVO          VARCHAR(10) NULL,
       ID_SINCRO            VARCHAR(15) NOT NULL,
       REFERENCIA           VARCHAR(200) NULL,
       FECHA_HOR_CREACION   DATETIME NULL,
       FECHA_DOCUMENTO      DATETIME NULL,
       SELECCIONADO         VARCHAR(1) NULL,
       USUARIO              VARCHAR(10) NULL,
       MENSAJE_SISTEMA      TEXT NULL,
       ID_PDA               VARCHAR(15) NOT NULL,
       DOCUMENTO_NUEVO	    VARCHAR(1) NOT NULL DEFAULT 'N'
)
go


ALTER TABLE  DOCUMENTO_INV_SINCRO
       ADD CONSTRAINT DOCUMENTO_INV_SINCRO_PK PRIMARY KEY (DOCUMENTO_INV, PAQUETE_INVENTARIO, ID_SINCRO)
go


CREATE TABLE FACTURA_DISPOSITIVO
(
	TIPO_DOCUMENTO 	VARCHAR(1) 	NOT NULL, 
	FACTURA 	VARCHAR(50) 	NOT NULL, 
	DISPOSITIVO 	VARCHAR(20) 	NOT NULL
)
go


ALTER TABLE FACTURA_DISPOSITIVO
        ADD CONSTRAINT XPKFACTURA_DISPOSITIVO 
            PRIMARY KEY (FACTURA, TIPO_DOCUMENTO)
go            



CREATE TABLE LINEA_CONTEO_SINCRO (
       LINEA                int NOT NULL,
       ID_SINCRO            VARCHAR(15) NOT NULL,
       RECIBO               VARCHAR(20) NOT NULL,
       ARTICULO             VARCHAR(20) NULL,
       CANT_APROBADA        DECIMAL(28,8) NULL,
       CANT_RECHAZADA       DECIMAL(28,8) NULL,
       SERIE_INICIAL        VARCHAR(20) NULL,
       MOTIVO_RECHAZO       VARCHAR(30) NULL,
       ID_PDA               VARCHAR(15) NULL
)
go


ALTER TABLE  LINEA_CONTEO_SINCRO
       ADD CONSTRAINT LINEA_CONTEO_SINCRO_PK PRIMARY KEY (ID_SINCRO, LINEA, RECIBO)
go

CREATE TABLE LINEA_DOC_INV_SINCRO (
       LINEA_DOC_INV        int NOT NULL,
       DOCUMENTO_INV        VARCHAR(50) NOT NULL,
       PAQUETE_INVENTARIO   VARCHAR(4) NOT NULL,
       AJUSTE_CONFIG        VARCHAR(4) NULL,
       ID_SINCRO            VARCHAR(15) NOT NULL,
       NIT                  VARCHAR(20) NULL,
       ARTICULO             VARCHAR(20) NULL,
       BODEGA               VARCHAR(4) NULL,
       LOCALIZACION         VARCHAR(8) NULL,
       LOTE                 VARCHAR(15) NULL,
       TIPO                 VARCHAR(1) NULL,
       SUBTIPO              VARCHAR(1) NULL,
       SUBSUBTIPO           VARCHAR(1) NULL,
       CANTIDAD             DECIMAL(28,8) NULL,
       COSTO_TOTAL_LOCAL    DECIMAL(28,8) NULL,
       COSTO_TOTAL_DOLAR    DECIMAL(28,8) NULL,
       PRECIO_TOTAL_LOCAL   DECIMAL(28,8) NULL,
       PRECIO_TOTAL_DOLAR   DECIMAL(28,8) NULL,
       BODEGA_DESTINO       VARCHAR(4) NULL,
       LOCALIZACION_DEST    VARCHAR(8) NULL,
       CENTRO_COSTO         VARCHAR(25) NULL,
       CUENTA_CONTABLE      VARCHAR(25) NULL,
       SECUENCIA            DATETIME NULL,
       SERIE_CADENA         int NULL,
       USUARIO              VARCHAR(10) NULL,
       ID_PDA               VARCHAR(15) NOT NULL
)
go

ALTER TABLE  LINEA_DOC_INV_SINCRO
       ADD CONSTRAINT LINEA_DOC_INV_SINCRO_PK PRIMARY KEY (LINEA_DOC_INV, DOCUMENTO_INV, 
              PAQUETE_INVENTARIO, ID_SINCRO)
go

CREATE TABLE LOTE_SINCRO (
       LOTE                 VARCHAR(15) NOT NULL,
       ARTICULO             VARCHAR(20) NOT NULL,
       ID_SINCRO            VARCHAR(15) NOT NULL,
       FECHA_VENCIMIENTO    DATETIME NULL,
       ESTADO               VARCHAR(1) NULL,
       TIPO_INGRESO         VARCHAR(1) NULL,
       CANTIDAD_INGRESADA   DECIMAL(28,8) NULL,
       LOTE_DEL_PROVEEDOR   VARCHAR(15) NULL,
       FECHA_CUARENTENA     DATETIME NULL,
       ID_PDA               VARCHAR(20) NOT NULL,
       CREADO_EN_PDA        VARCHAR(1) NULL,
       MODIFICADO_EN_PDA    VARCHAR(1) NULL
)
go


ALTER TABLE  LOTE_SINCRO
       ADD CONSTRAINT LOTE_SINCRO_PK PRIMARY KEY (LOTE, ARTICULO, ID_SINCRO)
go

CREATE TABLE ORDEN_CARGADA_SINCRO (
       ORDEN_COMPRA         VARCHAR(10) NOT NULL,
       ID_PDA               VARCHAR(15) NOT NULL,
       ID_SINCRO            VARCHAR(15) NOT NULL,
       DESCARGADA           VARCHAR(1) NULL
)
go


ALTER TABLE  ORDEN_CARGADA_SINCRO
       ADD CONSTRAINT ORDEN_CARGADA_SINCRO_PK PRIMARY KEY (ORDEN_COMPRA, ID_PDA, ID_SINCRO)
go

CREATE TABLE PAQUETE_INVENTARIO_SINCRO (
       PAQUETE_INVENTARIO   VARCHAR(4) NOT NULL,
       DESCRIPCION          VARCHAR(40) NULL,
       ID_SINCRO            VARCHAR(15) NOT NULL,
       ULTIMO_USUARIO       VARCHAR(10) NULL,
       USUARIO_CREADOR      VARCHAR(10) NULL,
       FECHA_ULT_ACCESO     DATETIME NULL,
       ID_PDA               VARCHAR(15) NOT NULL,
       PAQUETE_NUEVO 	    VARCHAR(1) NOT NULL DEFAULT 'N'
)
go


ALTER TABLE  PAQUETE_INVENTARIO_SINCRO
       ADD CONSTRAINT PAQUETE_INVENTARIO_SINCRO_PK PRIMARY KEY (PAQUETE_INVENTARIO, ID_SINCRO)
go

CREATE TABLE RECIBO_SINCRO (
       RECIBO               VARCHAR(20) NOT NULL,
       ID_SINCRO            VARCHAR(15) NOT NULL,
       PROVEEDOR            VARCHAR(20) NULL,
       AGENTE_ADUANAL       VARCHAR(12) NULL,
       CANT_BULTOS          int NULL,
       PEDIMENTO            VARCHAR(15) NULL,
       FECHA_INGRESO        DATETIME NULL,
       FECHA_CREACION       DATETIME NULL,
       ID_PDA               VARCHAR(15) NOT NULL,
       ADUANA               VARCHAR(12) NULL,
       ID_TRANSPORTISTA     int NULL,
       FECHA_SINCRO         DATETIME NULL
)
go


ALTER TABLE  RECIBO_SINCRO
       ADD CONSTRAINT RECIBO_SINCRO_PK PRIMARY KEY (RECIBO, ID_SINCRO)
go

CREATE TABLE TRANSACCION_INV_SINCRO (
       CONSECUTIVO          VARCHAR(100) NULL,
       LINEA_DOC_INV        int NOT NULL,
       DOCUMENTO_INV        VARCHAR(50) NOT NULL,
       PAQUETE_INVENTARIO   VARCHAR(4) NOT NULL,
       AJUSTE_CONFIG        VARCHAR(4) NULL,
       ID_SINCRO            VARCHAR(15) NOT NULL,
       NIT                  VARCHAR(20) NULL,
       ARTICULO             VARCHAR(20) NULL,
       BODEGA               VARCHAR(4) NULL,
       LOCALIZACION         VARCHAR(8) NULL,
       LOTE                 VARCHAR(15) NULL,
       TIPO                 VARCHAR(1) NULL,
       SUBTIPO              VARCHAR(1) NULL,
       SUBSUBTIPO           VARCHAR(1) NULL,
       CANTIDAD             DECIMAL(28,8) NULL,
       COSTO_TOTAL_LOCAL    DECIMAL(28,8) NULL,
       COSTO_TOTAL_DOLAR    DECIMAL(28,8) NULL,
       PRECIO_TOTAL_LOCAL   DECIMAL(28,8) NULL,
       PRECIO_TOTAL_DOLAR   DECIMAL(28,8) NULL,
       BODEGA_DESTINO       VARCHAR(4) NULL,
       LOCALIZACION_DESTINO VARCHAR(8) NULL,
       CENTRO_COSTO         VARCHAR(25) NULL,
       CUENTA_CONTABLE	    VARCHAR(25) NULL,
       SECUENCIA            DATETIME NULL,
       SERIE_CADENA         int NULL,
       USUARIO              VARCHAR(10) NULL,
       ID_PDA               VARCHAR(15) NOT NULL,
       CODRESERVAR          VARCHAR(20) NULL,
       REFERENCIA           VARCHAR(200) NULL
)
go


ALTER TABLE  TRANSACCION_INV_SINCRO
       ADD CONSTRAINT TRANSACCION_INV_SINCRO_PK PRIMARY KEY (LINEA_DOC_INV, DOCUMENTO_INV, 
              PAQUETE_INVENTARIO, ID_SINCRO)
go

CREATE TABLE TRANSPORTISTA_SINCRO (
       CONSECUTIVO          int NOT NULL,
       NOMBRE               VARCHAR(20) NULL,
       CEDULA               VARCHAR(15) NULL,
       PLACA_TRANSPORTE     VARCHAR(10) NULL,
       MARCHAMO_TRANSPORTE  VARCHAR(10) NULL,
       FECHA_CREACION       DATETIME NULL,
       ID_PDA               VARCHAR(15) NOT NULL,
       ID_SINCRO            VARCHAR(15) NOT NULL
)
go


ALTER TABLE  TRANSPORTISTA_SINCRO
       ADD CONSTRAINT TRANSPORTISTA_SINCRO_PK PRIMARY KEY (CONSECUTIVO, ID_SINCRO)
go


CREATE TABLE UBICACION_SINCRO (
       LINEA                int NOT NULL,
       ID_SINCRO            VARCHAR(15) NOT NULL,
       RECIBO               VARCHAR(20) NOT NULL,
       BODEGA               VARCHAR(4) NULL,
       LOCALIZACION         VARCHAR(8) NULL,
       LOTE                 VARCHAR(15) NULL,
       ID_PDA               VARCHAR(15) NULL
)
go


ALTER TABLE  UBICACION_SINCRO
       ADD CONSTRAINT UBICACION_SINCRO_PK PRIMARY KEY (ID_SINCRO, LINEA, RECIBO)
go


if not exists (select * from dbo.sysobjects where name='USUARIO_SINCRO_TRANSAC')
CREATE TABLE ERPADMIN.USUARIO_SINCRO_TRANSAC (
       USUARIO              VARCHAR(10) NOT NULL,
       BASE_DATOS           VARCHAR(50) NOT NULL,
       COMPANIA             VARCHAR(50) NOT NULL,
       TIPOUSUARIO          VARCHAR(1) NOT NULL,
       FECHA		    DATETIME NOT NULL
)
go





