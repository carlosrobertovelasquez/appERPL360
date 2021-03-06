 CREATE TABLE AJUSTE_CONFIG (
        AJUSTE_CONFIG        VARCHAR(4) NOT NULL,
        DESCRIPCION          VARCHAR(15) NOT NULL,
        AJUSTE_BASE          VARCHAR(1) NOT NULL,
        ACTIVA               VARCHAR(1) NOT NULL,
        INGRESO              VARCHAR(1) NOT NULL
 )
go
 
 
 ALTER TABLE AJUSTE_CONFIG
        ADD CONSTRAINT XPKAJUSTE_CONFIG PRIMARY KEY (AJUSTE_CONFIG)
go
 
 
 CREATE TABLE AJUSTE_SUBSUBTIPO (
        AJUSTE_CONFIG        VARCHAR(4) NOT NULL,
        SUBSUBTIPO           VARCHAR(1) NOT NULL
 )
go
 
 
 ALTER TABLE AJUSTE_SUBSUBTIPO
        ADD CONSTRAINT XPKAJUSTE_SUBSUBTIPO PRIMARY KEY NONCLUSTERED (
               AJUSTE_CONFIG, SUBSUBTIPO)
go
 
 
 CREATE TABLE AJUSTE_SUBTIPO (
        AJUSTE_CONFIG        VARCHAR(4) NOT NULL,
        SUBTIPO              VARCHAR(1) NOT NULL
 )
go
 
 
 ALTER TABLE AJUSTE_SUBTIPO
        ADD CONSTRAINT XPKAJUSTE_SUBTIPO PRIMARY KEY NONCLUSTERED (
               AJUSTE_CONFIG, SUBTIPO)
go
 
 
 CREATE TABLE ALIAS_PRODUCCION (
        ALIAS_PRODUCCION     VARCHAR(25) NOT NULL,
        ARTICULO             VARCHAR(20) NOT NULL,
        DESCRIPCION          VARCHAR(50) NULL
 )
go
 
 
 ALTER TABLE ALIAS_PRODUCCION
        ADD CONSTRAINT XPKALIASPRODUCCION PRIMARY KEY NONCLUSTERED (
               ALIAS_PRODUCCION)
go
 
 
 CREATE TABLE ART_UND_DISTRIBUCI (
        ARTICULO             VARCHAR(20) NOT NULL,
        UND_DISTRIBUCION     VARCHAR(6) NOT NULL,
        FACTOR_CONVERSION    DECIMAL(28,8) NOT NULL,
        CODIGO_BARRAS        VARCHAR(20) NOT NULL
 )
go
 
 
 ALTER TABLE ART_UND_DISTRIBUCI
        ADD CONSTRAINT ARTUNDDISTRIBPK PRIMARY KEY (ARTICULO, 
               UND_DISTRIBUCION)
go
 
 
 CREATE TABLE ARTICULO (
        ARTICULO             		VARCHAR(20) 	NOT NULL,
        PLANTILLA_SERIE      		VARCHAR(4) 	NULL,
        DESCRIPCION          		VARCHAR(254) 	NOT NULL,
        CLASIFICACION_1      		VARCHAR(12) 	NULL,
        CLASIFICACION_2      		VARCHAR(12) 	NULL,
        CLASIFICACION_3      		VARCHAR(12) 	NULL,
        CLASIFICACION_4      		VARCHAR(12) 	NULL,
        CLASIFICACION_5      		VARCHAR(12) 	NULL,
        CLASIFICACION_6      		VARCHAR(12) 	NULL,
        FACTOR_CONVER_1      		DECIMAL(28,8) 	NULL,
        FACTOR_CONVER_2      		DECIMAL(28,8) 	NULL,
        FACTOR_CONVER_3      		DECIMAL(28,8) 	NULL,
        FACTOR_CONVER_4      		DECIMAL(28,8) 	NULL,
        FACTOR_CONVER_5      		DECIMAL(28,8) 	NULL,
        FACTOR_CONVER_6      		DECIMAL(28,8) 	NULL,
        TIPO                 		VARCHAR(1) 	NOT NULL,
        ORIGEN_CORP          		VARCHAR(1) 	NOT NULL,
        PESO_NETO            		DECIMAL(28,8) 	NOT NULL,
        PESO_BRUTO           		DECIMAL(28,8) 	NOT NULL,
        VOLUMEN              		DECIMAL(28,8) 	NOT NULL,
        BULTOS               		smallint 	NOT NULL,
        ARTICULO_CUENTA      		VARCHAR(4) 	NOT NULL,
        IMPUESTO             		VARCHAR(4) 	NOT NULL,
        FACTOR_EMPAQUE       		DECIMAL(28,8) 	NOT NULL,
        FACTOR_VENTA         		DECIMAL(28,8) 	NOT NULL,
        EXISTENCIA_MINIMA    		DECIMAL(28,8) 	NOT NULL,
        EXISTENCIA_MAXIMA    		DECIMAL(28,8) 	NOT NULL,
        PUNTO_DE_REORDEN     		DECIMAL(28,8) 	NOT NULL,
        COSTO_FISCAL         		VARCHAR(1) 	NOT NULL,
        COSTO_COMPARATIVO    		VARCHAR(1) 	NOT NULL,
        COSTO_PROM_LOC       		DECIMAL(28,8) 	NOT NULL,
        COSTO_PROM_DOL       		DECIMAL(28,8) 	NOT NULL,
        COSTO_STD_LOC        		DECIMAL(28,8) 	NOT NULL,
        COSTO_STD_DOL        		DECIMAL(28,8) 	NOT NULL,
        COSTO_ULT_LOC        		DECIMAL(28,8) 	NOT NULL,
        COSTO_ULT_DOL        		DECIMAL(28,8) 	NOT NULL,
        PRECIO_BASE_LOCAL    		DECIMAL(28,8) 	NOT NULL,
        PRECIO_BASE_DOLAR    		DECIMAL(28,8) 	NOT NULL,
        ULTIMA_SALIDA        		DATETIME 	NOT NULL,
        ULTIMO_MOVIMIENTO    		DATETIME 	NOT NULL,
        ULTIMO_INGRESO       		DATETIME 	NOT NULL,
        ULTIMO_INVENTARIO    		DATETIME 	NOT NULL,
        CLASE_ABC            		VARCHAR(1) 	NOT NULL,
        FRECUENCIA_CONTEO    		smallint 	NOT NULL,
        CODIGO_BARRAS_VENT   		VARCHAR(20) 	NULL,
        CODIGO_BARRAS_INVT   		VARCHAR(20) 	NULL,
        ACTIVO               		VARCHAR(1) 	NOT NULL,
        USA_LOTES            		VARCHAR(1) 	NOT NULL,
        OBLIGA_CUARENTENA    		VARCHAR(1) 	NOT NULL,
        MIN_VIDA_COMPRA      		smallint 	NOT NULL,
        MIN_VIDA_CONSUMO     		smallint 	NOT NULL,
        MIN_VIDA_VENTA       		smallint 	NOT NULL,
        VIDA_UTIL_PROM       		smallint 	NOT NULL,
        DIAS_CUARENTENA      		smallint 	NOT NULL,
        PROVEEDOR            		VARCHAR(20) 	NULL,
        ARTICULO_DEL_PROV    		VARCHAR(30) 	NULL,
        ORDEN_MINIMA         		DECIMAL(28,8) 	NOT NULL,
        PLAZO_REABAST        		smallint 	NOT NULL,
        LOTE_MULTIPLO        		DECIMAL(28,8) 	NOT NULL,
        NOTAS                		TEXT 		NULL,
        UTILIZADO_MANUFACT   		VARCHAR(1) 	NOT NULL,
        USUARIO_CREACION     		VARCHAR(25) 	NULL,
        FCH_HORA_CREACION    		DATETIME 	NULL,
        USUARIO_ULT_MODIF    		VARCHAR(25) 	NULL,
        FCH_HORA_ULT_MODIF   		DATETIME 	NULL,
        USA_NUMEROS_SERIE    		VARCHAR(1) 	NOT NULL,
        MODALIDAD_INV_FIS    		VARCHAR(1) 	NULL,
        TIPO_COD_BARRA_DET   		VARCHAR(1) 	NULL,
        TIPO_COD_BARRA_ALM   		VARCHAR(1) 	NULL,
        USA_REGLAS_LOCALES   		VARCHAR(1) 	NULL,
        UNIDAD_ALMACEN       		VARCHAR(6) 	NOT NULL,
        UNIDAD_EMPAQUE       		VARCHAR(6) 	NOT NULL,
        UNIDAD_VENTA         		VARCHAR(6) 	NOT NULL,
        PERECEDERO           		VARCHAR(1) 	NOT NULL,
	GTIN         	     		VARCHAR(13) 	NULL,
	MANUFACTURADOR	     		VARCHAR(35) 	NULL,
	CODIGO_RETENCION     		VARCHAR(4) 	NULL,
	RETENCION_VENTA      		VARCHAR(4) 	NULL,
	RETENCION_COMPRA     		VARCHAR(4) 	NULL,
	MODELO_RETENCION     		VARCHAR(4) 	NULL,
	ESTILO 		     		VARCHAR(5) 	NULL,
	TALLA 		     		VARCHAR(5) 	NULL,
	COLOR 		     		VARCHAR(5) 	NULL,
	TIPO_COSTO 	     		VARCHAR(1) 	NOT NULL DEFAULT 'A',
	ARTICULO_ENVASE      		VARCHAR(20)	NULL,
	ES_ENVASE  	     		VARCHAR(1) 	DEFAULT 'N' NOT NULL,
	USA_CONTROL_ENVASE   		VARCHAR(1) 	DEFAULT 'N' NOT NULL,
	COSTO_PROM_COMPARATIVO_LOC 	DECIMAL(28,8) 	NOT NULL DEFAULT 0,
	COSTO_PROM_COMPARATIVO_DOLAR 	DECIMAL(28,8) 	NOT NULL DEFAULT 0,
	COSTO_PROM_ULTIMO_LOC 		DECIMAL(28,8) 	NOT NULL DEFAULT 0,
	COSTO_PROM_ULTIMO_DOL 		DECIMAL(28,8) 	NOT NULL DEFAULT 0,
	UTILIZADO_EN_CONTRATOS 		VARCHAR(1) 	NOT NULL DEFAULT 'N',
	VALIDA_CANT_FASE_PY 		VARCHAR(1) 	NOT NULL DEFAULT 'N',
	OBLIGA_INCLUIR_FASE_PY 		VARCHAR(1) 	NOT NULL DEFAULT 'N',
	ES_IMPUESTO 			VARCHAR(1) 	NOT NULL DEFAULT 'N',
	U_CLAVE_UNIDAD VARCHAR(20) NULL,
	U_CLAVE_PROD_SERV VARCHAR(200) NULL
 )
go
 
 
 ALTER TABLE ARTICULO
        ADD CONSTRAINT ARTICULOPK PRIMARY KEY NONCLUSTERED (ARTICULO)
go
 
 
 CREATE TABLE ARTICULO_ALTERNO (
        ARTICULO             VARCHAR(20) NOT NULL,
        ALTERNO              VARCHAR(20) NOT NULL,
        PRIORIDAD            smallint NOT NULL
 )
go
 
 
 ALTER TABLE ARTICULO_ALTERNO
        ADD CONSTRAINT ARTICULOALTERNOPK PRIMARY KEY NONCLUSTERED (
               ARTICULO, ALTERNO)
go
 
 

CREATE TABLE ARTICULO_COLOR (
        COLOR        	VARCHAR(5) 	NOT NULL,
        DESCRIPCION	VARCHAR(50) 	NOT NULL,
        CODIGO_BARRAS	VARCHAR(5) 	NULL
 )
go
 
ALTER TABLE ARTICULO_COLOR ADD CONSTRAINT XPKARTICULO_COLOR PRIMARY KEY (COLOR)
go
 
 
 CREATE TABLE ARTICULO_CUENTA (
        ARTICULO_CUENTA      VARCHAR(4) NOT NULL,
        DESCRIPCION          VARCHAR(40) NOT NULL,
        CTR_INVENTARIO       VARCHAR(25) NULL,
        CTA_INVENTARIO       VARCHAR(25) NULL,
        CTR_VENTAS_LOC       VARCHAR(25) NULL,
        CTA_VENTAS_LOC       VARCHAR(25) NULL,
        CTR_VENTAS_EXP       VARCHAR(25) NULL,
        CTA_VENTAS_EXP       VARCHAR(25) NULL,
        CTR_COMPRA_LOC       VARCHAR(25) NULL,
        CTA_COMPRA_LOC       VARCHAR(25) NULL,
        CTR_COMPRA_IMP       VARCHAR(25) NULL,
        CTA_COMPRA_IMP       VARCHAR(25) NULL,
        CTR_DESC_VENTA_LOC   VARCHAR(25) NULL,
        CTA_DESC_VENTA_LOC   VARCHAR(25) NULL,
        CTR_DESC_VENTA_EXP   VARCHAR(25) NULL,
        CTA_DESC_VENTA_EXP   VARCHAR(25) NULL,
        CTR_COST_VENTA_LOC   VARCHAR(25) NULL,
        CTA_COST_VENTA_LOC   VARCHAR(25) NULL,
        CTR_COST_VENTA_EXP   VARCHAR(25) NULL,
        CTA_COST_VENTA_EXP   VARCHAR(25) NULL,
        CTR_COMS_VENTA_LOC   VARCHAR(25) NULL,
        CTA_COMS_VENTA_LOC   VARCHAR(25) NULL,
        CTR_COMS_VENTA_EXP   VARCHAR(25) NULL,
        CTA_COMS_VENTA_EXP   VARCHAR(25) NULL,
        CTR_COMS_COBRO_LOC   VARCHAR(25) NULL,
        CTA_COMS_COBRO_LOC   VARCHAR(25) NULL,
        CTR_COMS_COBRO_EXP   VARCHAR(25) NULL,
        CTA_COMS_COBRO_EXP   VARCHAR(25) NULL,
        CTR_DESC_LINEA_LOC   VARCHAR(25) NULL,
        CTA_DESC_LINEA_LOC   VARCHAR(25) NULL,
        CTR_DESC_LINEA_EXP   VARCHAR(25) NULL,
        CTA_DESC_LINEA_EXP   VARCHAR(25) NULL,
        CTR_COST_DESC_LOC    VARCHAR(25) NULL,
        CTA_COST_DESC_LOC    VARCHAR(25) NULL,
        CTR_COST_DESC_EXP    VARCHAR(25) NULL,
        CTA_COST_DESC_EXP    VARCHAR(25) NULL,
        CTR_SOBR_INVENTFIS   VARCHAR(25) NULL,
        CTA_SOBR_INVENTFIS   VARCHAR(25) NULL,
        CTR_FALT_INVENTFIS   VARCHAR(25) NULL,
        CTA_FALT_INVENTFIS   VARCHAR(25) NULL,
        CTR_VARIA_COSTO      VARCHAR(25) NULL,
        CTA_VARIA_COSTO      VARCHAR(25) NULL,
        CTR_VENCIMIENTO      VARCHAR(25) NULL,
        CTA_VENCIMIENTO      VARCHAR(25) NULL,
        CTR_SOBRANTE_REMIS   VARCHAR(25) NULL,
        CTA_SOBRANTE_REMIS   VARCHAR(25) NULL,
        CTR_FALTANTE_REMIS   VARCHAR(25) NULL,
        CTA_FALTANTE_REMIS   VARCHAR(25) NULL,
        CTR_INV_REMITIDO     VARCHAR(25) NULL,
        CTA_INV_REMITIDO     VARCHAR(25) NULL,
        CTR_MAT_PROCESO      VARCHAR(25) NULL,
        CTA_MAT_PROCESO      VARCHAR(25) NULL,
        CTR_CONS_NORMAL      VARCHAR(25) NULL,
        CTA_CONS_NORMAL      VARCHAR(25) NULL,
        CTR_CONS_RETRABAJO   VARCHAR(25) NULL,
        CTA_CONS_RETRABAJO   VARCHAR(25) NULL,
        CTR_CONS_GASTO       VARCHAR(25) NULL,
        CTA_CONS_GASTO       VARCHAR(25) NULL,
        CTR_CONS_DESPERDIC   VARCHAR(25) NULL,
        CTA_CONS_DESPERDIC   VARCHAR(25) NULL,
        CTR_DESC_BONIF_LOC   VARCHAR(25) NULL,
        CTA_DESC_BONIF_LOC   VARCHAR(25) NULL,
        CTR_DESC_BONIF_EXP   VARCHAR(25) NULL,
        CTA_DESC_BONIF_EXP   VARCHAR(25) NULL,
        CTR_DEV_VENTAS_LOC   VARCHAR(25) NULL,
        CTA_DEV_VENTAS_LOC   VARCHAR(25) NULL,
        CTR_DEV_VENTAS_EXP   VARCHAR(25) NULL,
        CTA_DEV_VENTAS_EXP   VARCHAR(25) NULL,
		CTR_CTO_RET_ASUM     VARCHAR(25) NULL,
		CTA_CTB_RET_ASUM     VARCHAR(25) NULL,
		CTR_CTO_AJU	     	 VARCHAR(25) NULL,
		CTA_CTB_AJU	     	 VARCHAR(25) NULL,
		CTR_CTO_AJU_CMV	     VARCHAR(25) NULL,
		CTA_CTB_AJU_CMV	     VARCHAR(25) NULL,
		CTR_CTO_CPGAR 	     VARCHAR(25) NULL,
		CTA_CTB_CPGAR 	     VARCHAR(25) NULL,
		CTR_CTO_PUGAR 	     VARCHAR(25) NULL,
		CTA_CTB_PUGAR 	     VARCHAR(25) NULL,
		CTR_CTO_ING_DEVOLUC  VARCHAR(25) NULL,
		CTA_CTB_ING_DEVOLUC  VARCHAR(25) NULL,
		CTR_CTO_PERD_DEVOLUC VARCHAR(25) NULL,
		CTA_CTB_PERD_DEVOLUC VARCHAR(25) NULL,
		CTA_MAT_APLICADOS    VARCHAR(25) NULL,
		CTR_MAT_APLICADOS    VARCHAR(25) NULL,
		CTR_VENTAS_EXEN_LOC  VARCHAR(25) NULL,
		CTA_VENTAS_EXEN_LOC  VARCHAR(25) NULL,
		CTR_VENTAS_EXEN_EXP  VARCHAR(25) NULL,
		CTA_VENTAS_EXEN_EXP  VARCHAR(25) NULL
 )
go
 
 
 ALTER TABLE ARTICULO_CUENTA
        ADD CONSTRAINT ARTICULOCUENTASPK PRIMARY KEY NONCLUSTERED (
               ARTICULO_CUENTA)
go
 
 
 CREATE TABLE ARTICULO_ESPE (
        ATRIBUTO             VARCHAR(20) 	NOT NULL,
        ARTICULO             VARCHAR(25) 	NOT NULL,
        MAXIMA               DECIMAL(28,8) 	NOT NULL,
        MINIMA               DECIMAL(28,8) 	NOT NULL,
        NORMAL               DECIMAL(28,8) 	NOT NULL,
        UNIDAD               VARCHAR(6) 	NOT NULL,
        VALOR                VARCHAR(20) 	NOT NULL,
        NOTAS                TEXT 		NULL,
        CHEQUEAR_INGRESO     VARCHAR(1) 	NOT NULL,
        HEREDAR_LOTES        VARCHAR(1) 	NOT NULL
 )
go
 
 
 ALTER TABLE ARTICULO_ESPE
        ADD CONSTRAINT XPKARTICULO_ESPECI PRIMARY KEY NONCLUSTERED (
               ATRIBUTO, ARTICULO)
go
 
 
CREATE TABLE ARTICULO_ESTILO (
        ESTILO        	VARCHAR(5) 	NOT NULL,
        DESCRIPCION	VARCHAR(50) 	NOT NULL,
        CODIGO_BARRAS	VARCHAR(5) 	NULL
 )
go
  
ALTER TABLE ARTICULO_ESTILO ADD CONSTRAINT XPKARTICULO_ESTILO PRIMARY KEY (ESTILO)
go

 
 
 
 
CREATE TABLE ARTICULO_FOTO (
	ARTICULO   	VARCHAR(20) 	NOT NULL,
	SECUENCIA 	int 		NOT NULL,
	FOTO       	image  		NULL,
	PRIORIDAD 	int 		NOT NULL,
	ARCHIVO	        VARCHAR(254) 	NOT NULL,
	DESCRIPCION 	VARCHAR(254) 	NOT NULL,
	FECHA_ULT_MODIF DATETIME 	NULL
)
go

 
 
 ALTER TABLE ARTICULO_FOTO
        ADD CONSTRAINT ARTICULOFOTOPK PRIMARY KEY NONCLUSTERED (
               ARTICULO, SECUENCIA)
go
 

 CREATE TABLE ARTICULO_PADRE_HIJO (
        ARTICULO_PADRE	VARCHAR(20) 	NOT NULL,
        ARTICULO_HIJO	VARCHAR(20) 	NOT NULL
 )
go
 
 
CREATE TABLE ARTICULO_TALLA (
        TALLA        	VARCHAR(5) 	NOT NULL,
        DESCRIPCION	VARCHAR(50) 	NOT NULL,
        CODIGO_BARRAS	VARCHAR(5)  	NULL
 )
go
  
ALTER TABLE ARTICULO_TALLA ADD CONSTRAINT XPKARTICULO_TALLA PRIMARY KEY (TALLA)
go
 
 
 
 CREATE TABLE AUDIT_TRANS_INV (
        AUDIT_TRANS_INV      int IDENTITY(1,1) 	NOT NULL,
        CONSECUTIVO          VARCHAR(10) 	NULL,
        USUARIO              VARCHAR(25) 	NOT NULL,
        FECHA_HORA           DATETIME 		NOT NULL,
        MODULO_ORIGEN        VARCHAR(4) 	NOT NULL,
        APLICACION           VARCHAR(249) 	NOT NULL,
        REFERENCIA           VARCHAR(200) 	NOT NULL,
        ASIENTO              VARCHAR(10) 	NULL,
        USUARIO_APRO         VARCHAR(25) 	NULL,
        FECHA_HORA_APROB     DATETIME 		NULL,
        PAQUETE_INVENTARIO   VARCHAR(4) 	NULL
 )
go
 
 
 ALTER TABLE AUDIT_TRANS_INV
        ADD CONSTRAINT AUDITRANSINVPK PRIMARY KEY NONCLUSTERED (
               AUDIT_TRANS_INV)
go


CREATE TABLE AUTOR_COMPRA(
	CODIGO 		VARCHAR(4) 	NOT NULL,
	DESCRIPCION 	VARCHAR(30) 	NOT NULL,
	CLASIFICACION 	SMALLINT 	NOT NULL,
	NUM_AUTOR 	VARCHAR(50) 	NOT NULL,
	FECHA_RIGE 	DATETIME 	NOT NULL,
	FECHA_VENCE 	DATETIME 	NOT NULL,
	PORCENTAJE 	DECIMAL(28,8) 	NOT NULL,
	NOTAS  		TEXT 		NULL
)
go


ALTER TABLE AUTOR_COMPRA  
	ADD CONSTRAINT PK_AUTOR_COMPRA PRIMARY KEY CLUSTERED ( CODIGO)
go	
 
 
 CREATE TABLE AUTOR_VENTA(
 	CODIGO 		VARCHAR(4) 	NOT NULL,
 	DESCRIPCION 	VARCHAR(30) 	NOT NULL,
 	CLIENTE 	VARCHAR(20) 	NOT NULL,
 	NUM_AUTOR 	VARCHAR(50) 	NOT NULL,
 	FECHA_RIGE 	DATETIME 	NOT NULL,
 	FECHA_VENCE 	DATETIME 	NOT NULL,
 	PORCENTAJE 	DECIMAL(28,8) 	NOT NULL,
 	NOTAS  		TEXT 		NULL,
	TIPO_DOC 		VARCHAR(3) 	NULL,
	NOMBRE_INSTITUCION 	VARCHAR(100) NULL
 )
 go
 
 ALTER TABLE AUTOR_VENTA  
	ADD CONSTRAINT PK_AUTOR_VENTA PRIMARY KEY CLUSTERED ( CODIGO )
 go
 
 
 CREATE TABLE BOLETA_INV_FISICO (
        BOLETA               VARCHAR(8) 	NOT NULL,
        ARTICULO             VARCHAR(20) 	NOT NULL,
        BODEGA               VARCHAR(4) 	NOT NULL,
        LOCALIZACION         VARCHAR(8) 	NULL,
        LOTE                 VARCHAR(15) 	NULL,
        CANT_DISP_RESERV     DECIMAL(28,8) 	NOT NULL,
        CANT_NO_APROBADA     DECIMAL(28,8) 	NOT NULL,
        CANT_VENCIDA         DECIMAL(28,8) 	NOT NULL,
        USUARIO              VARCHAR(25) 	NOT NULL,
        FECHA_HORA           DATETIME 		NOT NULL,
        VALIDADA             VARCHAR(1) 	NOT NULL,
        SERIE_CADENA_DISP    int 		NULL,
        SERIE_CADENA_NOAPR   int 		NULL,
        SERIE_CADENA_VENC    int 		NULL
 )
go
 
 
 ALTER TABLE BOLETA_INV_FISICO
        ADD CONSTRAINT BOLETAPK PRIMARY KEY NONCLUSTERED (BOLETA)
go
 
 
 CREATE TABLE CLASIFICACION (
        CLASIFICACION        VARCHAR(12) NOT NULL,
        DESCRIPCION          VARCHAR(40) NOT NULL,
        AGRUPACION           smallint NOT NULL,
        USA_NUMEROS_SERIE    VARCHAR(1) NOT NULL,
        PLANTILLA_SERIE      VARCHAR(4) NULL,
        APORTE_CODIGO        VARCHAR(5) NULL,
        TIPO_CODIGO_BARRAS   VARCHAR(1) NULL,
        UNIDAD_MEDIDA        VARCHAR(6) NOT NULL
 )
go
 
 
 ALTER TABLE CLASIFICACION
        ADD CONSTRAINT CLASIFICACIONPK PRIMARY KEY NONCLUSTERED (
               CLASIFICACION)
go

CREATE TABLE CLASIFICACION_ADI (
        CLASIFICACION        VARCHAR(12) NOT NULL,
        DESCRIPCION          VARCHAR(70) NOT NULL,
        POSICION             smallint NOT NULL
 )
go 

ALTER TABLE CLASIFICACION_ADI
        ADD CONSTRAINT CLASIFICACION_ADIPK PRIMARY KEY NONCLUSTERED (CLASIFICACION)
go        

  CREATE TABLE CLASIFICACION_ADI_VALOR (
        CLASIFICACION        VARCHAR(12) NOT NULL,
        VALOR                VARCHAR(12) NOT NULL,
        DESCRIPCION          VARCHAR(254) NOT NULL
 )
go 

ALTER TABLE CLASIFICACION_ADI_VALOR
        ADD CONSTRAINT CLASIF_ADI_VALORPK PRIMARY KEY NONCLUSTERED (CLASIFICACION,VALOR)
go 

CREATE TABLE CLASIFIC_ADI_ARTICULO (
        ARTICULO             VARCHAR(20)  NOT NULL,
        CLASIFICACION        VARCHAR(12) NOT NULL,
        VALOR                VARCHAR(12) NOT NULL
 )
go

ALTER TABLE CLASIFIC_ADI_ARTICULO
        ADD CONSTRAINT CLASIF_ADI_ARTICULOPK PRIMARY KEY NONCLUSTERED (ARTICULO,CLASIFICACION)
go



CREATE TABLE CLASIFICACION_COMPRA(
	CODIGO 			VARCHAR(4) 	NOT NULL,
	CODIGO_CLASIFICACION 	VARCHAR(12) 	NOT NULL
)
go

ALTER TABLE CLASIFICACION_COMPRA  
	ADD CONSTRAINT PK_CLASIFICACION_COMPRA PRIMARY KEY CLUSTERED ( CODIGO,CODIGO_CLASIFICACION)
go


CREATE TABLE CLASIFICACION_VENTA(
	CODIGO 			VARCHAR(4) 	NOT NULL,
	CODIGO_ARTICULO 	VARCHAR(20) 	NOT NULL
)
go

ALTER TABLE CLASIFICACION_VENTA  
	ADD CONSTRAINT PK_CLASIFICACION_VENTA PRIMARY KEY CLUSTERED ( CODIGO,CODIGO_ARTICULO)
go	


 CREATE TABLE CONSEC_AJUSTE_CONF (
        CONSECUTIVO          VARCHAR(10) NOT NULL,
        AJUSTE_CONFIG        VARCHAR(4) NOT NULL
 )
go
 
 
 ALTER TABLE CONSEC_AJUSTE_CONF
        ADD CONSTRAINT XPKCONSEC_AJUSTE_CONF PRIMARY KEY (CONSECUTIVO, 
               AJUSTE_CONFIG)
go
 
 
 CREATE TABLE CONSEC_USUARIO (
        CONSECUTIVO          VARCHAR(10) NOT NULL,
        USUARIO              VARCHAR(25) NOT NULL
 )
go
 
 
 ALTER TABLE CONSEC_USUARIO
        ADD CONSTRAINT XPKCONSEC_USUARIO PRIMARY KEY (CONSECUTIVO, 
               USUARIO)
go
 
 
 CREATE TABLE CONSECUTIVO_CI (
        CONSECUTIVO          VARCHAR(10) NOT NULL,
        ULTIMO_USUARIO       VARCHAR(25) NOT NULL,
        DESCRIPCION          VARCHAR(40) NOT NULL,
        MASCARA              VARCHAR(50) NOT NULL,
        SIGUIENTE_CONSEC     VARCHAR(50) NOT NULL,
        EDITABLE             VARCHAR(1) NOT NULL,
        MULTIPLES_TRANS      VARCHAR(1) NOT NULL,
        FORMATO_IMP          VARCHAR(254) NULL,
        ULT_FECHA_HORA       DATETIME NOT NULL,
        TODAS_TRANS          VARCHAR(1) NOT NULL,
        TIPO                 VARCHAR(4) NOT NULL,
		USA_TRASLADO 		 VARCHAR(1) NOT NULL DEFAULT 'N',
		EMAIL_CFDI 			 VARCHAR(254) NULL
 )
go
 
 
 ALTER TABLE CONSECUTIVO_CI
        ADD CONSTRAINT XPKCONSECUTIVO_CI PRIMARY KEY (CONSECUTIVO)
go
 
 
 CREATE TABLE COST_STD_BATCH (
        ARTICULO             VARCHAR(20) 	NOT NULL,
        USUARIO              VARCHAR(25) 	NOT NULL,
        MAT_CORP_LOC         DECIMAL(28,8) 	NOT NULL,
        MAT_CORP_DOL         DECIMAL(28,8) 	NOT NULL,
        MAT_TERCEROS_LOC     DECIMAL(28,8) 	NOT NULL,
        MAT_TERCEROS_DOL     DECIMAL(28,8) 	NOT NULL,
        COSTO_MO_LOC         DECIMAL(28,8) 	NOT NULL,
        COSTO_MO_DOL         DECIMAL(28,8) 	NOT NULL,
        COSTO_INDIR_LOC      DECIMAL(28,8) 	NOT NULL,
        COSTO_INDIR_DOL      DECIMAL(28,8) 	NOT NULL,
        BODEGA 		     VARCHAR(4) 	NOT NULL DEFAULT 'ND'
 )
go
 
 
 ALTER TABLE COST_STD_BATCH
        ADD CONSTRAINT COSTSTDBATCHPK PRIMARY KEY NONCLUSTERED (
               ARTICULO)
go
 
 
 CREATE TABLE COSTO_STD_DESGL (
        ARTICULO             VARCHAR(20) 	NOT NULL,
        FECHA_HORA           DATETIME 		NOT NULL,
        USUARIO              VARCHAR(25) 	NOT NULL,
        MAT_CORP_LOC         DECIMAL(28,8) 	NOT NULL,
        MAT_CORP_DOL         DECIMAL(28,8) 	NOT NULL,
        MAT_TERCEROS_LOC     DECIMAL(28,8) 	NOT NULL,
        MAT_TERCEROS_DOL     DECIMAL(28,8) 	NOT NULL,
        COSTO_MO_LOC         DECIMAL(28,8) 	NOT NULL,
        COSTO_MO_DOL         DECIMAL(28,8) 	NOT NULL,
        COSTO_INDIR_LOC      DECIMAL(28,8) 	NOT NULL,
        COSTO_INDIR_DOL      DECIMAL(28,8) 	NOT NULL,
        BODEGA 		     VARCHAR(4) 	NOT NULL DEFAULT 'ND'
 )
go
 
 
ALTER TABLE COSTO_STD_DESGL 
	ADD CONSTRAINT COSTOSTDDESGLPK PRIMARY KEY NONCLUSTERED ( ARTICULO, FECHA_HORA, BODEGA )

go
 
 
 CREATE TABLE COSTO_UEPS_PEPS (
        ARTICULO             VARCHAR(20) NOT NULL,
        SECUENCIA            DATETIME NOT NULL,
        CANTIDAD_ORIGINAL    DECIMAL(28,8) NOT NULL,
        CANTIDAD_RESTANTE    DECIMAL(28,8) NOT NULL,
        COSTO_LOCAL          DECIMAL(28,8) NOT NULL,
        COSTO_DOLAR          DECIMAL(28,8) NOT NULL
 )
go
 
 
 ALTER TABLE COSTO_UEPS_PEPS
        ADD CONSTRAINT COSTOUEPSPEPSPK PRIMARY KEY NONCLUSTERED (
               ARTICULO, SECUENCIA)
go
 
 
 CREATE TABLE DOCUMENTO_INV (
        PAQUETE_INVENTARIO   VARCHAR(4) NOT NULL,
        DOCUMENTO_INV        VARCHAR(50) NOT NULL,
        CONSECUTIVO          VARCHAR(10) NULL,
        REFERENCIA           VARCHAR(200) NOT NULL,
        FECHA_HOR_CREACION   DATETIME NOT NULL,
        FECHA_DOCUMENTO      DATETIME NOT NULL,
        SELECCIONADO         VARCHAR(1) NOT NULL,
        USUARIO              VARCHAR(25) NOT NULL,
        MENSAJE_SISTEMA      TEXT NULL,
        USUARIO_APRO         VARCHAR(25) NULL,
        FECHA_HORA_APROB     DATETIME NULL,
        APROBADO             VARCHAR(1) NULL
 )
go
 
 
 ALTER TABLE DOCUMENTO_INV
        ADD CONSTRAINT DOCPAQINVPK PRIMARY KEY NONCLUSTERED (
               PAQUETE_INVENTARIO, DOCUMENTO_INV)
go
 
 
 CREATE TABLE EXISTENCIA_BODEGA (
        ARTICULO             		VARCHAR(20) 	NOT NULL,
        BODEGA               		VARCHAR(4) 	NOT NULL,
        EXISTENCIA_MINIMA    		DECIMAL(28,8) 	NOT NULL,
        EXISTENCIA_MAXIMA    		DECIMAL(28,8) 	NOT NULL,
        PUNTO_DE_REORDEN     		DECIMAL(28,8) 	NOT NULL,
        CANT_DISPONIBLE      		DECIMAL(28,8) 	NOT NULL,
        CANT_RESERVADA       		DECIMAL(28,8) 	NOT NULL,
        CANT_NO_APROBADA     		DECIMAL(28,8) 	NOT NULL,
        CANT_VENCIDA         		DECIMAL(28,8) 	NOT NULL,
        CANT_TRANSITO        		DECIMAL(28,8) 	NOT NULL,
        CANT_PRODUCCION      		DECIMAL(28,8) 	NOT NULL,
        CANT_PEDIDA          		DECIMAL(28,8) 	NOT NULL,
        CANT_REMITIDA        		DECIMAL(28,8) 	NOT NULL,
        CONGELADO            		VARCHAR(1) 	NOT NULL,
        FECHA_CONG           		DATETIME 	NULL,
        BLOQUEA_TRANS        		VARCHAR(1) 	NOT NULL,
        FECHA_DESCONG        		DATETIME 	NULL,
        COSTO_UNT_PROMEDIO_LOC 		DECIMAL (28,8) 	NOT NULL DEFAULT 0,
	COSTO_UNT_PROMEDIO_DOL 		DECIMAL (28,8) 	NOT NULL DEFAULT 0,
	COSTO_UNT_ESTANDAR_LOC 		DECIMAL (28,8) 	NOT NULL DEFAULT 0,
	COSTO_UNT_ESTANDAR_DOL 		DECIMAL (28,8) 	NOT NULL DEFAULT 0,
	COSTO_PROM_COMPARATIVO_LOC 	DECIMAL(28,8) 	NOT NULL DEFAULT 0,
	COSTO_PROM_COMPARATIVO_DOLAR 	DECIMAL(28,8) 	NOT NULL DEFAULT 0
 )
go
 
 
 ALTER TABLE EXISTENCIA_BODEGA
        ADD CONSTRAINT EXISTENCIABODEGAPK PRIMARY KEY NONCLUSTERED (
               ARTICULO, BODEGA)
go
 
 
CREATE TABLE EXISTENCIA_CIERRE
(
      FECHA_CIERRE 		DATETIME 	NOT NULL,
      ARTICULO 			VARCHAR(20) 	NOT NULL,
      TIPO_COSTO 		VARCHAR(1) 	NOT NULL,
      TIPO_FECHA 		VARCHAR(1) 	NOT NULL,
      BODEGA 			VARCHAR(4) 	NOT NULL,  
      COSTO_FISC_UNT_LOC 	DECIMAL(28,8) 	NOT NULL,
      COSTO_FISC_UNT_DOL 	DECIMAL(28,8) 	NOT NULL,
      COSTO_COMP_UNT_LOC 	DECIMAL(28,8) 	NOT NULL,
      COSTO_COMP_UNT_DOL 	DECIMAL(28,8) 	NOT NULL,
      CANT_DISPONIBLE 		DECIMAL(28,8) 	NOT NULL,
      CANT_RESERVADA 		DECIMAL(28,8) 	NOT NULL,
      CANT_NO_APROBADA 		DECIMAL(28,8) 	NOT NULL,
      CANT_VENCIDA 		DECIMAL(28,8) 	NOT NULL,
      CANT_REMITIDA 		DECIMAL(28,8) 	NOT NULL
)
go

	
ALTER TABLE EXISTENCIA_CIERRE 
	ADD CONSTRAINT PK_EXISTCIERRE PRIMARY KEY NONCLUSTERED (FECHA_CIERRE, ARTICULO, TIPO_COSTO, TIPO_FECHA, BODEGA)
go	
 
 
 
 CREATE TABLE EXISTENCIA_LOTE (
        BODEGA               	VARCHAR(4) 	NOT NULL,
        ARTICULO             	VARCHAR(20) 	NOT NULL,
        LOCALIZACION         	VARCHAR(8) 	NOT NULL,
        LOTE                 	VARCHAR(15) 	NOT NULL,
        CANT_DISPONIBLE      	DECIMAL(28,8) 	NOT NULL,
        CANT_RESERVADA       	DECIMAL(28,8) 	NOT NULL,
        CANT_NO_APROBADA     	DECIMAL(28,8) 	NOT NULL,
        CANT_VENCIDA         	DECIMAL(28,8) 	NOT NULL,
        CANT_REMITIDA        	DECIMAL(28,8) 	NOT NULL,
        COSTO_UNT_PROMEDIO_LOC 	DECIMAL (28,8) 	NOT NULL DEFAULT 0,
	COSTO_UNT_PROMEDIO_DOL 	DECIMAL (28,8) 	NOT NULL DEFAULT 0,
	COSTO_UNT_ESTANDAR_LOC 	DECIMAL (28,8) 	NOT NULL DEFAULT 0,
	COSTO_UNT_ESTANDAR_DOL 	DECIMAL (28,8) 	NOT NULL DEFAULT 0
 )
go
 
 
 ALTER TABLE EXISTENCIA_LOTE
        ADD CONSTRAINT EXISTENCIALOTEPK PRIMARY KEY NONCLUSTERED (
               BODEGA, ARTICULO, LOCALIZACION, LOTE)
go
 
 
 CREATE TABLE EXISTENCIA_RESERVA (
        ARTICULO             	VARCHAR(20) 	NOT NULL,
        APLICACION           	VARCHAR(60) 	NOT NULL,
        BODEGA               	VARCHAR(4) 	NOT NULL,
        LOTE                 	VARCHAR(15) 	NOT NULL,
        LOCALIZACION         	VARCHAR(8) 	NOT NULL,
        SERIE_CADENA         	int 		NULL,
        MODULO_ORIGEN        	VARCHAR(4) 	NOT NULL,
        CANTIDAD             	DECIMAL(28,8) 	NOT NULL,
        USUARIO              	VARCHAR(25) 	NOT NULL,
        FECHA_HORA           	DATETIME 	NOT NULL
 )
go
 
 
ALTER TABLE EXISTENCIA_RESERVA
        ADD CONSTRAINT EXISTENCIARESERVPK 
			PRIMARY KEY NONCLUSTERED (ARTICULO, APLICACION, BODEGA, LOTE, LOCALIZACION)
go
 
 
 CREATE TABLE EXISTENCIA_SERIE (
        BODEGA               VARCHAR(4) NOT NULL,
        LOTE                 VARCHAR(15) NOT NULL,
        TIPO                 VARCHAR(1) NOT NULL,
        LOCALIZACION         VARCHAR(8) NOT NULL,
        ARTICULO             VARCHAR(20) NOT NULL,
        SERIE_INICIAL        VARCHAR(20) NOT NULL,
        SERIE_FINAL          VARCHAR(20) NOT NULL,
        CANTIDAD             DECIMAL(28,8) NOT NULL
 )
go
 
 
 ALTER TABLE EXISTENCIA_SERIE
        ADD CONSTRAINT XPKEXISTENCIA_SERIE PRIMARY KEY (BODEGA, LOTE, 
               TIPO, LOCALIZACION, SERIE_INICIAL, SERIE_FINAL, 
               ARTICULO)
go
 
 
 CREATE TABLE GLOBALES_CI (
        COSTOS_DEC           smallint NOT NULL,
        EXISTENCIAS_DEC      smallint NOT NULL,
        PESOS_DEC            smallint NOT NULL,
        COSTO_FISCAL         VARCHAR(1) NOT NULL,
        COSTO_COMPARATIVO    VARCHAR(1) NOT NULL,
        COSTO_INGR_DEFAULT   VARCHAR(1) NOT NULL,
        UNIDAD_PESO          VARCHAR(6) NOT NULL,
        UNIDAD_VOLUMEN       VARCHAR(6) NOT NULL,
        USA_LOCALIZACION     VARCHAR(1) NOT NULL,
        AJUSTAR_CONTEO       VARCHAR(1) NOT NULL,
        MAX_AUDITORIA        int NOT NULL,
        FCH_ULT_PROC_VCTO    DATETIME NOT NULL,
        FCH_ULT_PROC_APROB   DATETIME NOT NULL,
        FECHA_INICIO_TRANS   DATETIME NOT NULL,
        PURGAR_CAPAS_COSTO   VARCHAR(1) NOT NULL,
        NOMBRE_CLASIF_1      VARCHAR(10) NOT NULL,
        NOMBRE_CLASIF_2      VARCHAR(10) NOT NULL,
        NOMBRE_CLASIF_3      VARCHAR(10) NOT NULL,
        NOMBRE_CLASIF_4      VARCHAR(10) NULL,
        NOMBRE_CLASIF_5      VARCHAR(10) NULL,
        NOMBRE_CLASIF_6      VARCHAR(10) NULL,
        TIPO_ASIENTO         VARCHAR(4) NULL,
        PAQUETE              VARCHAR(4) NULL,
        ASNT_AJU_VENTA       VARCHAR(1) NOT NULL,
        ASNT_AJU_CONSUMO     VARCHAR(1) NOT NULL,
        ASNT_AJU_COMPRA      VARCHAR(1) NOT NULL,
        ASNT_AJU_PRODUC      VARCHAR(1) NOT NULL,
        ASNT_AJU_MISCELAN    VARCHAR(1) NOT NULL,
        ASNT_AJU_FISICO      VARCHAR(1) NOT NULL,
        ASNT_AJU_VENCIM      VARCHAR(1) NOT NULL,
        ASNT_AJU_COSTO       VARCHAR(1) NOT NULL,
        TIPO_FASB52          VARCHAR(1) NOT NULL,
        MOD_APLIC_ASIENTO    smallint NOT NULL,
        INTEGRACION_CONTA    VARCHAR(1) NOT NULL,
        TIPO_CONTA_OMISION   VARCHAR(1) NOT NULL,
        CTR_EN_TRANSACCION   VARCHAR(1) NOT NULL,
        EXIST_EN_TOTALES     VARCHAR(10) NOT NULL,
        TRANSAC_X_USUARIO    VARCHAR(1) NOT NULL,
        USA_CONSECUTIVOS     VARCHAR(1) NOT NULL,
        MODALIDAD_USO        VARCHAR(1) NULL,
        USAR_NUMEROS_SERIE   VARCHAR(1) NOT NULL,
        CNTRL_SERIES_ENTR    VARCHAR(1) NOT NULL,
        USA_CODIGO_BARRAS    VARCHAR(1) NOT NULL,
        USA_UNIDADES_DIST    VARCHAR(1) NULL,
        ASISTENCIA_AUTOMAT   VARCHAR(1) NULL,
        USA_CODIGO_EAN13     VARCHAR(1) NULL,
        USA_CODIGO_EAN8      VARCHAR(1) NULL,
        USA_CODIGO_UCC12     VARCHAR(1) NULL,
        USA_CODIGO_UCC8      VARCHAR(1) NULL,
        EAN13_REGLA_LOCAL    VARCHAR(18) NULL,
        EAN8_REGLA_LOCAL     VARCHAR(3) NULL,
        UCC12_REGLA_LOCAL    VARCHAR(6) NULL,
        PRIORIDAD_BUSQUEDA   VARCHAR(1) NULL,
        USA_PEDIMENTOS       VARCHAR(1) NOT NULL,
        USA_CODIGO_GENERIC   VARCHAR(1) NULL,
        LINEAS_MAX_TRANS     int        NULL,
        USAR_APROBACION      VARCHAR(1) NULL
 )
go

CREATE TABLE GUID_RELACIONADO (
	GUID_ORIGEN 		VARCHAR(48) 	NOT NULL,
	GUID_RELACIONADO 	VARCHAR(48) 	NOT NULL,
	TABLA_ORIGEN 		VARCHAR(30) 	NOT NULL,
	TABLA_RELACIONADA	VARCHAR(30) 	NOT NULL 
)
go


ALTER TABLE GUID_RELACIONADO
       ADD CONSTRAINT XPKGUID_RELACIONADO 
       		PRIMARY KEY NONCLUSTERED(GUID_ORIGEN, GUID_RELACIONADO)
go
 
 
CREATE TABLE IMPUESTO_ADICIONAL
(
  CLASIFICACION          VARCHAR(50)   NOT NULL,
  CODIGO_VALOR           VARCHAR(20)   NOT NULL,
  ARTICULO               VARCHAR(150)  NOT NULL,
  DESC_AFECTA_IMPUESTO   VARCHAR(1)    NOT NULL DEFAULT('N'),
  TIPO_IMPUESTO          VARCHAR(1)    NOT NULL DEFAULT('P'), 
  IMPUESTO		 DECIMAL(28,8) NOT NULL  
)
go


ALTER TABLE IMPUESTO_ADICIONAL
        ADD CONSTRAINT XPIMPUESTOADICIONAL
            PRIMARY KEY NONCLUSTERED (CLASIFICACION, CODIGO_VALOR)
go


CREATE TABLE INGRESOS_LOTE (
        ARTICULO             VARCHAR(20) NOT NULL,
        LOTE                 VARCHAR(15) NOT NULL,
        SECUENCIA_LOTE       int 	 NOT NULL,
        FECHA_ENTRADA        DATETIME 	 NULL,
        CANTIDAD_INGRESADA   DECIMAL(28,8) NULL
 )
go
 
 
ALTER TABLE INGRESOS_LOTE
         ADD CONSTRAINT XPKINGRESOS_LOTE PRIMARY KEY NONCLUSTERED
         (ARTICULO, LOTE, SECUENCIA_LOTE )
go
 
 
 CREATE TABLE LINEA_DOC_INV (
        PAQUETE_INVENTARIO   	VARCHAR(4) 	NOT NULL,
        DOCUMENTO_INV        	VARCHAR(50)	NOT NULL,
        LINEA_DOC_INV        	int 		NOT NULL,
        AJUSTE_CONFIG        	VARCHAR(4) 	NOT NULL,
        NIT                  	VARCHAR(20)	NULL,
        ARTICULO             	VARCHAR(20)	NOT NULL,
        BODEGA               	VARCHAR(4) 	NULL,
        LOCALIZACION         	VARCHAR(8) 	NULL,
        LOTE                 	VARCHAR(15)	NULL,
        TIPO                 	VARCHAR(1) 	NOT NULL,
        SUBTIPO              	VARCHAR(1) 	NOT NULL,
        SUBSUBTIPO           	VARCHAR(1) 	NOT NULL,
        CANTIDAD             	DECIMAL(28,8) 	NOT NULL,
        COSTO_TOTAL_LOCAL    	DECIMAL(28,8) 	NOT NULL,
        COSTO_TOTAL_DOLAR    	DECIMAL(28,8) 	NOT NULL,
        PRECIO_TOTAL_LOCAL   	DECIMAL(28,8) 	NOT NULL,
        PRECIO_TOTAL_DOLAR   	DECIMAL(28,8) 	NOT NULL,
        BODEGA_DESTINO       	VARCHAR(4) 	NULL,
        LOCALIZACION_DEST    	VARCHAR(8) 	NULL,
        CENTRO_COSTO         	VARCHAR(25)	NULL,
        SECUENCIA            	DATETIME 	NULL,
        SERIE_CADENA         	int 		NULL,
        UNIDAD_DISTRIBUCIO   	VARCHAR(6) 	NULL,
        CUENTA_CONTABLE      	VARCHAR(25) 	NULL,
        COSTO_TOTAL_LOCAL_COMP 	DECIMAL(28,8) 	NOT NULL DEFAULT 0,
		COSTO_TOTAL_DOLAR_COMP 	DECIMAL(28,8) 	NOT NULL DEFAULT 0,
		CAI VARCHAR(50) NULL
 )
go
 
 
 ALTER TABLE LINEA_DOC_INV
        ADD CONSTRAINT LNPAQINVPK PRIMARY KEY NONCLUSTERED (
               PAQUETE_INVENTARIO, DOCUMENTO_INV, LINEA_DOC_INV)
go
 
 
 CREATE TABLE LOTE (
        LOTE                 VARCHAR(15) NOT NULL,
        ARTICULO             VARCHAR(20) NOT NULL,
        PROVEEDOR            VARCHAR(20) NULL,
        LOTE_DEL_PROVEEDOR   VARCHAR(15) NULL,
        FECHA_ENTRADA        DATETIME NOT NULL,
        FECHA_VENCIMIENTO    DATETIME NOT NULL,
        FECHA_CUARENTENA     DATETIME NOT NULL,
        CANTIDAD_INGRESADA   DECIMAL(28,8) NOT NULL,
        ESTADO               VARCHAR(1) NOT NULL,
        TIPO_INGRESO         VARCHAR(1) NOT NULL,
        NOTAS                TEXT NULL,
        ULTIMO_INGRESO       int NOT NULL
 )
go
 
 
 ALTER TABLE LOTE
         ADD CONSTRAINT LOTEPK PRIMARY KEY NONCLUSTERED
         (ARTICULO, LOTE )
go
 
 
 CREATE TABLE LOTE_ESPE (
        ARTICULO         VARCHAR(20)         NOT NULL,
        LOTE                 VARCHAR(15) NOT NULL,
        ATRIBUTO             VARCHAR(20) NOT NULL,
        VALOR_REAL           DECIMAL(28,8) NULL,
        UNIDAD               VARCHAR(6) NULL,
        VALOR_CUALITATIVO    VARCHAR(20) NULL
 )
go
 
 
ALTER TABLE LOTE_ESPE
         ADD CONSTRAINT XPKLOTE_ESPE PRIMARY KEY NONCLUSTERED
         (ARTICULO, LOTE, ATRIBUTO )
go
 
 
 CREATE TABLE PAQUETE_INVENTARIO (
        PAQUETE_INVENTARIO   VARCHAR(4) 	NOT NULL,
        DESCRIPCION          VARCHAR(40) 	NOT NULL,
        ULTIMO_USUARIO       VARCHAR(25) 	NOT NULL,
        USUARIO_CREADOR      VARCHAR(25) 	NOT NULL,
        FECHA_ULT_ACCESO     DATETIME 		NOT NULL
 )
go
 
 
 ALTER TABLE PAQUETE_INVENTARIO
        ADD CONSTRAINT XPKPAQUETE_INVENTA PRIMARY KEY (
               PAQUETE_INVENTARIO)
go
 
 
CREATE TABLE PEDIMENTO (
         PEDIMENTO         VARCHAR(15)         NOT NULL,
         FECHA         DATETIME         NOT NULL,
         ADUANA         VARCHAR(12)         NOT NULL,
         AGENTE_ADUANAL		VARCHAR(12)	NULL )
go

ALTER TABLE PEDIMENTO
         ADD CONSTRAINT PEDIMENTOPK PRIMARY KEY NONCLUSTERED
         (PEDIMENTO )
go


CREATE TABLE PEDIMENTO_LOTE (
         PEDIMENTO         VARCHAR(15)         NOT NULL,
         ARTICULO         VARCHAR(20)         NOT NULL,
         LOTE         VARCHAR(15)         NOT NULL )
go

ALTER TABLE PEDIMENTO_LOTE
         ADD CONSTRAINT PEDILOTEPK PRIMARY KEY NONCLUSTERED
         (PEDIMENTO, ARTICULO, LOTE )
go

 CREATE TABLE PISTA_EXISTEN_DET (
        FECHA                DATETIME NOT NULL,
        BODEGA               VARCHAR(4) NOT NULL,
        ARTICULO             VARCHAR(20) NOT NULL,
        LOCALIZACION         VARCHAR(8) NOT NULL,
        LOTE                 VARCHAR(15) NOT NULL,
        CANT_DISPONIBLE      DECIMAL(28,8) NOT NULL,
        CANT_RESERVADA       DECIMAL(28,8) NOT NULL,
        CANT_NO_APROBADA     DECIMAL(28,8) NOT NULL,
        CANT_VENCIDA         DECIMAL(28,8) NOT NULL,
        CANT_REMITIDA        DECIMAL(28,8) NOT NULL,
        COSTO_FISCAL_LOC     DECIMAL(28,8) NOT NULL,
        COSTO_FISCAL_DOL     DECIMAL(28,8) NOT NULL,
        COSTO_COMP_LOC       DECIMAL(28,8) NOT NULL,
        COSTO_COMP_DOL       DECIMAL(28,8) NOT NULL
 )
go
 
 
 ALTER TABLE PISTA_EXISTEN_DET
        ADD CONSTRAINT PISTAEXISTENDETPK PRIMARY KEY (FECHA, BODEGA, 
               ARTICULO, LOCALIZACION, LOTE)
go
 
 
 CREATE TABLE PISTA_EXISTENCIA (
        FECHA                DATETIME 	 NOT NULL,
        USUARIO              VARCHAR(25) NOT NULL,
        REFERENCIA           VARCHAR(50) NULL
 )
go
 
 
 ALTER TABLE PISTA_EXISTENCIA
        ADD CONSTRAINT PISTAEXISTENCIAPK PRIMARY KEY (FECHA)
go
 
 
CREATE TABLE PRESUPUESTO_CI_CR(
	AUDIT_TRANS_INV 	INT 		NULL,
	PAQUETE_INVENTARIO 	VARCHAR(4) 	NULL,
	DOCUMENTO_INV 		VARCHAR(20) 	NOT NULL,
	PRESUPUESTO 		VARCHAR(20) 	NOT NULL,
	APARTADO 		INT 		NULL
)
go


 
 CREATE TABLE SERIE_CADENA (
        SERIE_CADENA         int IDENTITY(1,1)	NOT NULL,
        MODULO_ORIGEN        VARCHAR(4) 	NOT NULL,
        USUARIO              VARCHAR(25) 	NOT NULL,
        FECHA_HORA           DATETIME 		NOT NULL
 )
go
 
 
 ALTER TABLE SERIE_CADENA
        ADD CONSTRAINT XPKSERIE_CADENA PRIMARY KEY (SERIE_CADENA)
go
 
 
 CREATE TABLE SERIE_CADENA_DET (
        SERIE_CADENA         int NOT NULL,
        SERIE_INICIAL        VARCHAR(20) NOT NULL,
        SERIE_FINAL          VARCHAR(20) NOT NULL,
        CANTIDAD             DECIMAL(28,8) NOT NULL
 )
go
 
 
 ALTER TABLE SERIE_CADENA_DET
        ADD CONSTRAINT XPKSERIE_CADENA_DET PRIMARY KEY (SERIE_CADENA, 
               SERIE_INICIAL, SERIE_FINAL)
go
 
 
 CREATE TABLE SERIE_PLANTILLA (
        SERIE_PLANTILLA      VARCHAR(4) NOT NULL,
        DESCRIPCION          VARCHAR(40) NOT NULL,
        TIPO_SERIE           VARCHAR(1) NOT NULL,
        MASCARA              VARCHAR(20) NOT NULL,
        SERIE_MINIMA         VARCHAR(20) NULL,
        SERIE_MAXIMA         VARCHAR(20) NULL
 )
go
 
 
 ALTER TABLE SERIE_PLANTILLA
        ADD CONSTRAINT XPKSERIE_PLANTILLA PRIMARY KEY (
               SERIE_PLANTILLA)
go
 
 
 CREATE TABLE TIPO_AJUSTE (
        TIPO                 VARCHAR(1) NOT NULL,
        DESCRIPCION          VARCHAR(15) NOT NULL,
        AJUSTE_A_CANT        VARCHAR(1) NOT NULL,
        AJUSTE_NEGATIVO      VARCHAR(1) NOT NULL
 )
go
 
 
 ALTER TABLE TIPO_AJUSTE
        ADD CONSTRAINT TIPOAJUSTEPK PRIMARY KEY NONCLUSTERED (TIPO)
go
 
 
 CREATE TABLE TRANS_INV_AUX (
        AUDIT_TRANS_INV      int NOT NULL,
        CONSECUTIVO          int NOT NULL,
        ORDEN                VARCHAR(10) NULL,
        OPERACION            VARCHAR(10) NULL
 )
go
 
 
 ALTER TABLE TRANS_INV_AUX
        ADD CONSTRAINT XPKAUDITORIA_AUX PRIMARY KEY (AUDIT_TRANS_INV, 
               CONSECUTIVO)
go
 
 
 CREATE TABLE TRANSACCION_INV (
        AUDIT_TRANS_INV      int 		NOT NULL,
        CONSECUTIVO          int 		NOT NULL,
        FECHA_HORA_TRANSAC   DATETIME 		NULL,
        NIT                  VARCHAR(20) 	NULL,
        SERIE_CADENA         int 		NULL,
        AJUSTE_CONFIG        VARCHAR(4) 	NULL,
        ARTICULO             VARCHAR(20)	NOT NULL,
        BODEGA               VARCHAR(4) 	NULL,
        LOCALIZACION         VARCHAR(8) 	NULL,
        LOTE                 VARCHAR(15)	NULL,
        TIPO                 VARCHAR(1) 	NOT NULL,
        SUBTIPO              VARCHAR(1) 	NOT NULL,
        SUBSUBTIPO           VARCHAR(1) 	NOT NULL,
        NATURALEZA           VARCHAR(1) 	NOT NULL,
        CANTIDAD             DECIMAL(28,8) 	NOT NULL,
        COSTO_TOT_FISC_LOC   DECIMAL(28,8) 	NOT NULL,
        COSTO_TOT_FISC_DOL   DECIMAL(28,8) 	NOT NULL,
        COSTO_TOT_COMP_LOC   DECIMAL(28,8) 	NOT NULL,
        COSTO_TOT_COMP_DOL   DECIMAL(28,8) 	NOT NULL,
        PRECIO_TOTAL_LOCAL   DECIMAL(28,8) 	NOT NULL,
        PRECIO_TOTAL_DOLAR   DECIMAL(28,8) 	NOT NULL,
        CONTABILIZADA        VARCHAR(1) 	NOT NULL,
        FECHA                DATETIME 		NOT NULL,
        CENTRO_COSTO         VARCHAR(25) 	NULL,
        UNIDAD_DISTRIBUCIO   VARCHAR(6)  	NULL,
        CUENTA_CONTABLE      VARCHAR(25) 	NULL,
        ASIENTO_CARDEX 	     VARCHAR(10) 	NULL,
		DOC_FISCAL VARCHAR(50) NULL
        
 )
go
 
 
 ALTER TABLE TRANSACCION_INV
        ADD CONSTRAINT TRANSINVPK PRIMARY KEY NONCLUSTERED (
               AUDIT_TRANS_INV, CONSECUTIVO)
go
 
 
 CREATE TABLE UNIDAD_DE_MEDIDA (
        UNIDAD_MEDIDA        VARCHAR(6)  NOT NULL,
        DESCRIPCION          VARCHAR(40) NOT NULL,
		U_FEUNIDAD VARCHAR(200) NULL
 )
go
 
 
 ALTER TABLE UNIDAD_DE_MEDIDA
        ADD CONSTRAINT UNIDADMEDIDAPK PRIMARY KEY NONCLUSTERED (
               UNIDAD_MEDIDA)
go
 
 
 CREATE TABLE USUARIO_AJUSTE (
        USUARIO              VARCHAR(25) NOT NULL,
        AJUSTE_CONFIG        VARCHAR(4)  NOT NULL
 )
go
 
 
 ALTER TABLE USUARIO_AJUSTE
        ADD CONSTRAINT XPKUSUARIO_AJUSTE PRIMARY KEY NONCLUSTERED (
               USUARIO, AJUSTE_CONFIG)
go
 
 