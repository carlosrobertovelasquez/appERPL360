
 
 CREATE TABLE CAJA_BANCO (
        CAJA_CHICA           VARCHAR(20) NOT NULL,
        CUENTA_BANCO         VARCHAR(20) NOT NULL
 )
go
 
 
 ALTER TABLE CAJA_BANCO
        ADD CONSTRAINT XPKCAJA_BANCO PRIMARY KEY (CAJA_CHICA, 
               CUENTA_BANCO)
go
 
 
 CREATE TABLE CAJA_CHICA (
        CAJA_CHICA           	VARCHAR(20) 	NOT NULL,
        RESPONSABLE          	VARCHAR(20) 	NULL,
        MONEDA               	VARCHAR(4) 	NOT NULL,
        AREA_FUNCIONAL       	VARCHAR(10) 	NULL,
        CENTRO_COSTO         	VARCHAR(25) 	NULL,
        CUENTA_CONTABLE      	VARCHAR(25) 	NULL,
        DESCRIPCION          	VARCHAR(25) 	NOT NULL,
        FECHA_INICIO         	DATETIME 	NOT NULL,
        MONTO_CAJA           	DECIMAL(28,8) 	NOT NULL,
        MONTO_VALE           	DECIMAL(28,8) 	NULL,
        SALDO                	DECIMAL(28,8) 	NOT NULL,
        NUM_VALES            	smallint 	NULL,
        VALIDAR_LIMITE       	VARCHAR(1) 	NOT NULL,
        REINTEGRO            	int 		NULL,
        LIMITE_PORCENTUAL    	VARCHAR(1) 	NULL,
        ESTADO               	VARCHAR(1) 	NOT NULL,
        ULTIMO_CONSECUTIVO   	VARCHAR(10)	 NULL,
        FCH_HORA_ULT_MODIF   	DATETIME 	NOT NULL,
        USUARIO_ULT_MODIF    	VARCHAR(25) 	NOT NULL,
        FCH_HORA_CREACION    	DATETIME 	NOT NULL,
        USUARIO_CREACION     	VARCHAR(25) 	NOT NULL,
        NOTAS                	TEXT 		NULL,
        PARTICIPA_FLUJOCAJA	VARCHAR(1)  	NOT NULL DEFAULT 'N',
		CUENTA_REEMBOLSOS VARCHAR (25) NULL,
    	CENTRO_REEMBOLSOS VARCHAR(25) NULL
 )
go
 
 
 ALTER TABLE CAJA_CHICA
        ADD CONSTRAINT XPKCAJA_CHICA PRIMARY KEY (CAJA_CHICA)
go
 
 
 CREATE TABLE CONCEPTO_VALE (
        CONCEPTO_VALE        	VARCHAR(10) 	NOT NULL,
        CENTRO_COSTO         	VARCHAR(25) 	NULL,
        CUENTA_CONTABLE      	VARCHAR(25) 	NULL,
        DESCRIPCION          	VARCHAR(30) 	NOT NULL,
        IMP1_AFECTA_COSTO		VARCHAR(1) 	NOT NULL DEFAULT('N'),
		USA_CTA_CONCEPTO		VARCHAR(1) 	NOT NULL DEFAULT('N'),
		CTR_CTO_RET_ASUM		VARCHAR(25) 	NULL,
		CTA_CTB_RET_ASUM		VARCHAR(25) 	NULL,
		MODELO_RETENCION 		VARCHAR(4) 		NULL
 )
go
 
 
 ALTER TABLE CONCEPTO_VALE
        ADD CONSTRAINT XPKCONCEPTO_VALE PRIMARY KEY (CONCEPTO_VALE)
go
 
 
 
CREATE TABLE DESG_IMPUESTO_CH (
        VALE                 	int 		NOT NULL,
        LINEA                	int 		NOT NULL,
        CODIGO_IMPUESTO      	VARCHAR(4) 	NOT NULL,
        PORCENTAJE	     	DECIMAL(28,8)	NULL,
        MONTO                	DECIMAL(28,8) 	NOT NULL,
        BASE		     	DECIMAL(28,8) 	NULL
 )
go
 
 
ALTER TABLE DESG_IMPUESTO_CH
          ADD CONSTRAINT DESGIMPPK PRIMARY KEY NONCLUSTERED
         	( VALE, LINEA, CODIGO_IMPUESTO )
go 
 
 
 CREATE TABLE DET_RETENCION_CH (
        VALE                 int 			NOT NULL,
        LINEA                int 			NOT NULL,
        CODIGO_RETENCION     VARCHAR(4) 	NOT NULL,
        RETENCION            VARCHAR(50)	NULL,
        MONTO                DECIMAL(28,8) 	NOT NULL,
        ESTADO               VARCHAR(1) 	NOT NULL,
        PAGADA               VARCHAR(1) 	NOT NULL,
        BASE		     	 DECIMAL(28,8) 	NULL,
		FECHA_DOCUMENTO 	 DATETIME 		NULL,
		FECHA_RIGE 			 DATETIME NULL
 )
go
 
 
 ALTER TABLE DET_RETENCION_CH
        ADD CONSTRAINT XPKDET_RETENCION_C PRIMARY KEY (VALE, LINEA, 
               CODIGO_RETENCION)
go
 
 
 CREATE TABLE DOCS_SOPORTE (
        VALE                 	int 		NOT NULL,
        LINEA                	int 		NOT NULL,
        CENTRO_COSTO         	VARCHAR(25) 	NULL,
        CUENTA_CONTABLE      	VARCHAR(25) 	NULL,
        NIT                  	VARCHAR(20) 	NULL,
        DOC_SOPORTE          	VARCHAR(50) 	NOT NULL,
        TIPO                 	VARCHAR(3) 	NOT NULL,
        MONTO                	DECIMAL(28,8) 	NULL,
        MONTO_VALE           	DECIMAL(28,8) 	NULL,
        CONCEPTO             	VARCHAR(10) 	NOT NULL,
        DETALLE              	TEXT 		NULL,
        SUBTOTAL             	DECIMAL(28,8) 	NULL,
        IMPUESTO1            	DECIMAL(28,8) 	NULL,
        IMPUESTO2            	DECIMAL(28,8) 	NULL,
        RUBRO1               	DECIMAL(28,8) 	NULL,
        RUBRO2               	DECIMAL(28,8) 	NULL,
        DESCUENTO            	DECIMAL(28,8) 	NULL,
        SUBTIPO              	smallint 	NULL,
        FECHA                	DATETIME 	NULL,
        FECHA_RIGE 	     	DATETIME 	NULL,
        PAIS			VARCHAR(4) 	NULL,
		DIVISION_GEOGRAFICA1	VARCHAR(12)	NULL,
		DIVISION_GEOGRAFICA2	VARCHAR(12)	NULL,
		CODIGO_IMPUESTO		VARCHAR(4) 	NULL,
		BASE_IMPUESTO1		DECIMAL(28,8)	NULL,
		BASE_IMPUESTO2		DECIMAL(28,8)	NULL,
		IMP1_AFECTA_COSTO	VARCHAR(1) 	NOT NULL DEFAULT('N'),
		IMP1_ASUMIDO_DESC	DECIMAL(28,8) 	NULL,
		IMP1_ASUMIDO_NODESC	DECIMAL(28,8) 	NULL,
		IMP1_RETENIDO_DESC	DECIMAL(28,8) 	NULL,
		IMP1_RETENIDO_NODESC	DECIMAL(28,8) 	NULL,
		DOCUMENTO_FISCAL 	VARCHAR(50) 	NULL,
		CONCEPTO_ME		VARCHAR(4)  	NULL,
		DESC_UBIC_GEOGRAFICA	VARCHAR(40) 	NULL,
		FECHA_CAI DATETIME NULL,
		CAI VARCHAR (50) NULL
 )
go
 
 
 ALTER TABLE DOCS_SOPORTE
        ADD CONSTRAINT XPKDOCS_SOPORTE PRIMARY KEY (VALE, LINEA)
go
 
 
 CREATE TABLE GLOBALES_CH (
        IMPUESTO_OMISION     	VARCHAR(4) 	NOT NULL,
        TIPO_ASIENTO         	VARCHAR(4) 	NULL,
        PAQUETE              	VARCHAR(4) 	NULL,
        CENTRO_COSTO_AD      	VARCHAR(25) 	NULL,
        CUENTA_CONTABLE_AD   	VARCHAR(25) 	NULL,
        INTEGRACION_CG       	VARCHAR(1) 	NOT NULL,
        INTEGRACION_CB       	VARCHAR(1) 	NOT NULL,
        MOD_APLIC_ASIENTO    	smallint 	NULL,
        TIPO_CONTA_OMISION   	VARCHAR(1) 	NULL,
        DETALLE              	VARCHAR(1) 	NULL,
        ASIENTO_VALE         	VARCHAR(1) 	NULL,
        CTR_RUBRO1_CH 	     	VARCHAR(25) 	NULL,
        CTA_RUBRO1_CH 	     	VARCHAR(25) 	NULL,
        CTR_RUBRO2_CH 	     	VARCHAR(25) 	NULL,
        CTA_RUBRO2_CH 	     	VARCHAR(25) 	NULL,
        CTR_IMPUESTO1_CH     	VARCHAR(25) 	NULL,
        CTA_IMPUESTO1_CH     	VARCHAR(25) 	NULL,
        CTR_IMPUESTO2_CH     	VARCHAR(25) 	NULL,
        CTA_IMPUESTO2_CH     	VARCHAR(25) 	NULL,
        INTEGRACION_CR 		VARCHAR(1) 	NULL,
	PAQUETE_CR 		VARCHAR(4) 	NULL,
	PRESUPUESTO_CR  	VARCHAR(20) 	NULL,
	REQUIERE_PRESUP 	VARCHAR(1) 	NULL
 )
go
 
 
 CREATE TABLE PROCESOCH (
        CONSECUTIVO          int NOT NULL,
        CAJA_CHICA           VARCHAR(20) NOT NULL,
        TIPO                 VARCHAR(1) NOT NULL,
        DOCUMENTO            VARCHAR(249) NULL,
        USUARIO              VARCHAR(25) NOT NULL,
        FECHA_HORA           DATETIME NOT NULL,
        MONTO                DECIMAL(28,8) NOT NULL,
        ESTADO               VARCHAR(1) NOT NULL,
        ASIENTO              VARCHAR(10) NULL
 )
go
 
 
 ALTER TABLE PROCESOCH
        ADD CONSTRAINT XPKPROCESOCH PRIMARY KEY (CONSECUTIVO)
go
 
 
 CREATE TABLE USUARIO_CAJA (
        CAJA_CHICA           VARCHAR(20) NOT NULL,
        USUARIO              VARCHAR(25) NOT NULL
 )
go
 
 
 ALTER TABLE USUARIO_CAJA
        ADD CONSTRAINT XPKUSUARIO_CAJA PRIMARY KEY (CAJA_CHICA, 
               USUARIO)
go
 
 
 CREATE TABLE VALE (
        CONSECUTIVO          	int 		NOT NULL,
        DEPARTAMENTO         	VARCHAR(10) 	NULL,
        CAJA_CHICA           	VARCHAR(20) 	NOT NULL,
        VALE                 	VARCHAR(10) 	NOT NULL,
        FECHA_EMISION        	DATETIME 	NOT NULL,
        FECHA_LIQUIDACION    	DATETIME 	NULL,
        CONCEPTO_VALE        	VARCHAR(10) 	NOT NULL,
        BENEFICIARIO         	VARCHAR(80) 	NOT NULL,
        NOTAS                	TEXT 		NULL,
        MONTO_CAJA           	DECIMAL(28,8) 	NOT NULL,
        MONTO_LOCAL          	DECIMAL(28,8) 	NOT NULL,
        MONTO_DOLAR          	DECIMAL(28,8) 	NOT NULL,
        TIPO_CAMB_CAJA       	DECIMAL(28,8) 	NOT NULL,
        TIPO_CAMB_DOLAR      	DECIMAL(28,8) 	NOT NULL,
        ESTADO               	VARCHAR(1) 	NOT NULL,
        USUARIO_CREACION     	VARCHAR(25) 	NOT NULL,
        FECHA_CREACION       	DATETIME 	NOT NULL,
        ADMIN_CREACION       	VARCHAR(20) 	NOT NULL,
        USUARIO_MODIFIC      	VARCHAR(25) 	NOT NULL,
        FECHA_MODIFIC        	DATETIME 	NOT NULL,
        ADMIN_MODIFIC        	VARCHAR(20) 	NULL,
        MONTO_VALE           	DECIMAL(28,8) 	NULL,
        MONTO_EFECTIVO       	DECIMAL(28,8) 	NULL,
        REINTEGRO            	int 		NULL,
        ASIENTO              	VARCHAR(10) 	NULL,
        PRESUPUESTO_CR 		VARCHAR(20) 	NULL,
        USUARIO_ANULACION      	VARCHAR(25) 	NULL,
	FECHA_ANULACION        	DATETIME 	NULL,
	ADMIN_ANULACION        	VARCHAR(20) 	NULL,
        FECHA_CONT_ANULACION    DATETIME 	NULL
 )
go
 
 
 ALTER TABLE VALE
        ADD CONSTRAINT XPKVALE PRIMARY KEY (CONSECUTIVO)
go
 
 
 
CREATE TABLE VALE_MOV_PRES (
         VALE         		int		NOT NULL,
         PRESUPUESTO         	VARCHAR(20)     NOT NULL,
         UNIDAD_OPERATIVA	VARCHAR(4)      NULL,
         NUMERO_EJERCIDO 	INT 		NULL,
         NUMERO_APARTADO 	INT 		NULL
)
go



ALTER TABLE VALE_MOV_PRES
         ADD CONSTRAINT XPKVALE_MOV_PRES PRIMARY KEY NONCLUSTERED  (VALE )
go 
 