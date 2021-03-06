
 
 CREATE TABLE AUXILIAR_CP (
        PROVEEDOR            VARCHAR(20) 	NOT NULL,
        TIPO_DEBITO          VARCHAR(3) 	NOT NULL,
        DEBITO               VARCHAR(50) 	NOT NULL,
        FECHA                DATETIME 		NOT NULL,
        TIPO_CREDITO         VARCHAR(3) 	NOT NULL,
        CREDITO              VARCHAR(50) 	NOT NULL,
        MONTO_DEBITO         DECIMAL(28,8) 	NOT NULL,
        MONTO_PROV           DECIMAL(28,8) 	NOT NULL,
        MONTO_LOCAL          DECIMAL(28,8) 	NOT NULL,
        MONTO_DOLAR          DECIMAL(28,8) 	NOT NULL,
        MONEDA_DEBITO        VARCHAR(4) 	NOT NULL,
        MONTO_CREDITO        DECIMAL(28,8) 	NOT NULL,
        MONEDA_CREDITO       VARCHAR(4) 	NOT NULL,
        ASIENTO              VARCHAR(10) 	NULL,
        TIPO_DOCPPAGO        VARCHAR(3) 	NULL,
		DOCUMENTO_DOCPPAGO   VARCHAR(50) 	NULL,
		TIPO_DOCINTCTE       VARCHAR(3)	 	NULL,
        DOC_DOCINTCTE        VARCHAR(50) 	NULL,
        FOLIOSAT_DEBITO      VARCHAR(50) 	NULL,
        FOLIOSAT_CREDITO     VARCHAR(50) 	NULL,
        TIPO_CAMBIO_APLICA   DECIMAL(28,8)	NULL,
		SIENTO_DIF_CAMB_MR 	 VARCHAR(10) 	NULL
 )
go
 
 
 ALTER TABLE AUXILIAR_CP
        ADD CONSTRAINT AUXILIAR_CPPK PRIMARY KEY NONCLUSTERED (
               PROVEEDOR, TIPO_DEBITO, DEBITO, FECHA, TIPO_CREDITO, 
               CREDITO)
go


CREATE TABLE $$COMPANIA$$.AUXILIAR_PARC_CP (
	PROVEEDOR		VARCHAR(20)	NOT NULL,
    	TIPO_CREDITO		VARCHAR(3)	NOT NULL,
	TIPO_DEBITO		VARCHAR(3)	NOT NULL,
	FECHA			DATETIME	NOT NULL,
	CREDITO			VARCHAR(50)	NOT NULL,
	DEBITO			VARCHAR(50)	NOT NULL,
	PARCIALIDAD		SMALLINT	NOT NULL,
	MONTO_DEBITO		DECIMAL(28,8)	NOT NULL,
	MONTO_CREDITO		DECIMAL(28,8)	NOT NULL,
	MONTO_LOCAL		DECIMAL(28,8)	NOT NULL,
	MONTO_DOLAR		DECIMAL(28,8)	NOT NULL,
	MONTO_PROV_CREDITO	DECIMAL(28,8)	NOT NULL,
	MONTO_PROV_DEBITO	DECIMAL(28,8)	NOT NULL,
	ASIENTO			VARCHAR(10)	NULL,
	MONTO_AMORTIZA		DECIMAL(28,8)	NULL,
	MONTO_AMORTIZA_LOC	DECIMAL(28,8)	NULL,
	MONTO_AMORTIZA_DOL	DECIMAL(28,8)	NULL,
	MONTO_INTERES		DECIMAL(28,8)	NULL,
	MONTO_INTERES_LOC	DECIMAL(28,8)	NULL,
	MONTO_INTERES_DOL	DECIMAL(28,8)	NULL,
	MONTO_CUOTA		DECIMAL(28,8)	NULL,
	MONTO_CUOTA_LOC		DECIMAL(28,8)	NULL,
	MONTO_CUOTA_DOL		DECIMAL(28,8)	NULL,
	TIPO_CAMBIO_APLICA      DECIMAL(28,8)	NULL
 )
 go
 
 
 ALTER TABLE $$COMPANIA$$.AUXILIAR_PARC_CP
        ADD CONSTRAINT XPKAUXILIAR_PARC_CP PRIMARY KEY ( PROVEEDOR, TIPO_CREDITO, TIPO_DEBITO, FECHA, CREDITO, DEBITO, PARCIALIDAD )
go
 
CREATE TABLE COD_INGRESO
(
	COD_INGRESO varchar(4) not null,
	DESCRIPCION varchar(200) not null,
	GRAVADO 	varchar(1) not null default 'N'
) 
 
go

ALTER TABLE COD_INGRESO 
	ADD CONSTRAINT PK_COD_INGRESO
		PRIMARY KEY (COD_INGRESO)
go

CREATE TABLE CODING_CARTA_RENTA
(
	COD_INGRESO varchar(4) 		not null,
	CONCEPTO 	varchar(4000) 	null,
	RUBRO 		varchar(40) 	null

)

go

ALTER TABLE CODING_CARTA_RENTA ADD 
	CONSTRAINT PK_CODING_CARTA_RENTA
		PRIMARY KEY (COD_INGRESO)

go

CREATE TABLE CONTRAREC_ASIENTO_CR (
	CONTRARECIBO         	VARCHAR(20)     NOT NULL,
	ASIENTO         	VARCHAR(10) 	NOT NULL )
go 
 


ALTER TABLE CONTRAREC_ASIENTO_CR
         ADD CONSTRAINT XPKCONTRAREC_ASIENTO_CR PRIMARY KEY NONCLUSTERED  ( CONTRARECIBO, ASIENTO )
go 


CREATE TABLE CONTRAREC_MOV_PRES (
         CONTRARECIBO         	VARCHAR(50)     NOT NULL,
         PRESUPUESTO         	VARCHAR(20)     NOT NULL,
         UNIDAD_OPERATIVA	VARCHAR(4)      NULL,
         NUMERO_APARTADO        int         	NULL,
         NUMERO_EJERCIDO        int         	NULL )
go


ALTER TABLE CONTRAREC_MOV_PRES
         ADD CONSTRAINT XPKCONTRA_MOV_PRES PRIMARY KEY NONCLUSTERED  ( CONTRARECIBO )
go 
 
 
 CREATE TABLE CONTRARECIBOS (
        CONTRARECIBO         	VARCHAR(50) 	NOT NULL,
        PROVEEDOR            	VARCHAR(20) 	NOT NULL,
        CONDICION_PAGO       	VARCHAR(4) 	NOT NULL,
        USUARIO_ULT_MOD      	VARCHAR(25) 	NOT NULL,
        FECHA_RIGE           	DATETIME 	NULL,
        FECHA_ULT_MOD        	DATETIME 	NULL,
        ESTADO               	VARCHAR(1) 	NULL,
        NOTAS                	TEXT 		NULL,
        FECHA_EMISION        	DATETIME 	NULL,
        CONGELADO            	VARCHAR(1) 	NULL,
        FECHA_VENCE 	     	DATETIME 	NOT NULL DEFAULT('01-JAN-1980'),
        PRESUPUESTO_CR 	     	VARCHAR(20) 	NULL
 )
go
 
 
 ALTER TABLE CONTRARECIBOS
        ADD CONSTRAINT XPKCONTRARECIBOS PRIMARY KEY (CONTRARECIBO)
go
 
 
 
CREATE TABLE CP_DET_RETENCION_PAR
(
	TIPO		VARCHAR(3) 	NOT NULL,
	PROVEEDOR	VARCHAR(20) 	NOT NULL,
	DOCUMENTO	VARCHAR(50) 	NOT NULL,
	RETENCION	VARCHAR(4)	NOT NULL,
	NUM_RETEN	VARCHAR(20)	NOT NULL,
	MONTO		DECIMAL(28,8)	NULL,
	TIPO_CAN	VARCHAR(3)	NULL,
	PROVEE_CAN	VARCHAR(20)     NULL,
	DOC_CAN		VARCHAR(50)	NULL
)
go



ALTER TABLE CP_DET_RETENCION_PAR 
	ADD CONSTRAINT PKCPDETRETPAR PRIMARY KEY (TIPO,PROVEEDOR,DOCUMENTO,RETENCION,NUM_RETEN)
go

 
 
 
 
 CREATE TABLE DETALLE_RETENCION (
        TIPO                 VARCHAR(3) 	NOT NULL,
        PROVEEDOR            VARCHAR(20) 	NOT NULL,
        DOCUMENTO            VARCHAR(50) 	NOT NULL,
        CODIGO_RETENCION     VARCHAR(4) 	NOT NULL,
        RETENCION            VARCHAR(50) 	NULL,
        MONTO                DECIMAL(28,8) 	NOT NULL,
        ESTADO               VARCHAR(1) 	NOT NULL,
        PAGADA               VARCHAR(1) 	NOT NULL,
        BASE		     	 DECIMAL(28,8) 	NULL,
		AUTORETENEDORA	     VARCHAR(1)		DEFAULT ('N') NULL,
		TIPO_APLI_CANCELAR   VARCHAR(1) 	NULL,
		SALDO_CANCELAR	     DECIMAL(28,8) 	NULL,
		ASIENTO  			 VARCHAR(10) 	NULL,
		FECHA_DOCUMENTO		 DATETIME 		NULL,
		FECHA_RIGE 			 DATETIME NULL,
		FECHA_CONTABLE 		 DATETIME NULL
 )
go
 
 
 ALTER TABLE DETALLE_RETENCION
        ADD CONSTRAINT XPKDETALLE_RETENCI PRIMARY KEY (TIPO, 
               PROVEEDOR, DOCUMENTO, CODIGO_RETENCION)
go
 
 
CREATE TABLE DET_TIPOSERVICIO_CP(
       PROVEEDOR            VARCHAR(20) 	NOT NULL,
       DOCUMENTO            VARCHAR(50) 	NOT NULL,
       TIPO                 VARCHAR(3) 	        NOT NULL,
       TIPO_SERVICIO        VARCHAR(10)		NOT NULL,
       CONSECUTIVO	    INT IDENTITY(1,1) 	NOT NULL,
       PROYECTO             VARCHAR(25) 	NULL,
       FASE                 VARCHAR(25) 	NULL,
       MONTO_LOCAL	    DECIMAL(28,8) 	NULL,
       MONTO_DOLAR	    DECIMAL(28,8) 	NULL,
       MONTO_PROVEEDOR	    DECIMAL(28,8) 	NULL,
)
go



ALTER TABLE DET_TIPOSERVICIO_CP ADD CONSTRAINT XPK_DET_TIPOSERVICIO_CP 
     		PRIMARY KEY (PROVEEDOR,DOCUMENTO,TIPO,TIPO_SERVICIO,CONSECUTIVO)
go
 
 CREATE TABLE DOCUMENTOS_CP (
        PROVEEDOR            		VARCHAR(20) 	NOT NULL,
        DOCUMENTO            		VARCHAR(50) 	NOT NULL,
        TIPO                 		VARCHAR(3) 	NOT NULL,
        EMBARQUE_APROBADO    		VARCHAR(1) 	NOT NULL,
        TIPO_CAMB_LIQ_LOC    		DECIMAL(28,8) 	NULL,
        TIPO_CAMB_LIQ_DOL    		DECIMAL(28,8) 	NULL,
        FECHA_DOCUMENTO      		DATETIME 	NOT NULL,
        FECHA                		DATETIME 	NOT NULL,
        TIPO_PRORRATEO       		VARCHAR(2) 	NULL,
        ETIQUETA             		VARCHAR(20) 	NULL,
        TIPO_EMBARQUE        		VARCHAR(1) 	NOT NULL,
        APLICACION           		VARCHAR(249) 	NOT NULL,
        MONTO                		DECIMAL(28,8) 	NOT NULL,
        SALDO                		DECIMAL(28,8) 	NOT NULL,
        MONTO_LOCAL          		DECIMAL(28,8) 	NOT NULL,
        SALDO_LOCAL          		DECIMAL(28,8) 	NOT NULL,
        MONTO_DOLAR          		DECIMAL(28,8) 	NOT NULL,
        SALDO_DOLAR          		DECIMAL(28,8) 	NOT NULL,
        TIPO_CAMBIO_MONEDA   		DECIMAL(28,8) 	NOT NULL,
        TIPO_CAMBIO_DOLAR    		DECIMAL(28,8) 	NOT NULL,
        FECHA_ULT_CREDITO    		DATETIME 	NOT NULL,
        CHEQUE_IMPRESO       		VARCHAR(1) 	NOT NULL,
        APROBADO             		VARCHAR(1) 	NOT NULL,
        SELECCIONADO         		VARCHAR(1) 	NOT NULL,
        CONGELADO            		VARCHAR(1) 	NOT NULL,
        MONTO_PROV           		DECIMAL(28,8) 	NOT NULL,
        SALDO_PROV           		DECIMAL(28,8) 	NOT NULL,
        TIPO_CAMBIO_PROV     		DECIMAL(28,8) 	NOT NULL,
        SUBTOTAL             		DECIMAL(28,8) 	NOT NULL,
        DESCUENTO            		DECIMAL(28,8) 	NOT NULL,
        IMPUESTO1            		DECIMAL(28,8) 	NOT NULL,
        IMPUESTO2            		DECIMAL(28,8) 	NOT NULL,
        RUBRO1               		DECIMAL(28,8) 	NOT NULL,
        RUBRO2               		DECIMAL(28,8) 	NOT NULL,
        FECHA_ULT_MOD        		DATETIME 	NOT NULL,
        MONTO_RETENCION      		DECIMAL(28,8) 	NOT NULL,
        SALDO_RETENCION      		DECIMAL(28,8) 	NOT NULL,
        DEPENDIENTE          		VARCHAR(1) 	NOT NULL,
        ASIENTO              		VARCHAR(10) 	NULL,
        ASIENTO_PENDIENTE    		VARCHAR(1) 	NOT NULL,
        NOTAS                		TEXT 		NULL,
        TIPO_CAMB_ACT_LOC    		DECIMAL(28,8) 	NOT NULL,
        TIPO_CAMB_ACT_DOL    		DECIMAL(28,8) 	NOT NULL,
        TIPO_CAMB_ACT_PROV   		DECIMAL(28,8) 	NOT NULL,
        DOCUMENTO_EMBARQUE   		VARCHAR(1) 	NOT NULL,
        FECHA_REVISION       		DATETIME 	NULL,
        LIQUIDAC_COMPRA      		VARCHAR(15) 	NULL,
        USUARIO_ULT_MOD      		VARCHAR(25) 	NOT NULL,
        CONDICION_PAGO       		VARCHAR(4) 	NOT NULL,
        MONEDA               		VARCHAR(4) 	NOT NULL,
        CHEQUE_CUENTA        		VARCHAR(20) 	NULL,
        CONTRARECIBO         		VARCHAR(50) 	NULL,
        SUBTIPO              		smallint 	NULL,
        FECHA_VENCE 	     		DATETIME 	DEFAULT('01-JAN-1980') NOT NULL,
        FECHA_ANUL 	     		DATETIME 	NULL,
        AUD_USUARIO_ANUL     		VARCHAR(25) 	NULL,
        AUD_FECHA_ANUL 	     		DATETIME      	NULL,
        USUARIO_APROBACION   		VARCHAR(25)   	NULL,
	FECHA_APROBACION     		DATETIME      	NULL,
	MONTO_PAGO  	     		DECIMAL(28,8) 	NULL,
	USUARIO		     		VARCHAR(25)   	NULL,
        CUENTA_BANCO	     		VARCHAR(20)   	NULL,
        TIPO_CAMBIO 	     		DECIMAL(28,8) 	NULL,
        ANULADO              		VARCHAR(1) 	NULL,
        CODIGO_IMPUESTO      		VARCHAR(4) 	NULL,
        PAIS				VARCHAR(4) 	NULL,
	DIVISION_GEOGRAFICA1		VARCHAR(12)	NULL,
	DIVISION_GEOGRAFICA2		VARCHAR(12)	NULL,
	BASE_IMPUESTO1			DECIMAL(28,8) 	NULL,
	BASE_IMPUESTO2			DECIMAL(28,8) 	NULL,
	DEPENDIENTE_GP			VARCHAR(1) 	DEFAULT 'N' 	NOT NULL,
	SALDO_TRANS 			DECIMAL(28,8) 	DEFAULT 0 	NOT NULL,
	SALDO_TRANS_LOCAL 		DECIMAL(28,8) 	DEFAULT 0 	NOT NULL,
	SALDO_TRANS_DOLAR 		DECIMAL(28,8) 	DEFAULT 0 	NOT NULL,
	FECHA_PROYECTADA		DATETIME 	NULL,
	IMP1_ASUMIDO_DESC		DECIMAL(28,8) 	NULL,
	IMP1_ASUMIDO_NODESC		DECIMAL(28,8) 	NULL,
	IMP1_RETENIDO_DESC		DECIMAL(28,8) 	NULL,
	IMP1_RETENIDO_NODESC		DECIMAL(28,8) 	NULL,
	TIPO_ASIENTO 			VARCHAR(4) 	NULL,
	PAQUETE 			VARCHAR(4) 	NULL,
	DOCUMENTO_FISCAL 		VARCHAR(50) 	NULL,
	ESTADO_ENVIO 			VARCHAR(1) 	NULL,
        CONCEPTO_ME			VARCHAR(4)  	NULL,
        PARTICIPA_IETU 			VARCHAR(1) 	NOT NULL DEFAULT 'N',
        CLASE_DOCUMENTO      		VARCHAR(1) 	NOT NULL DEFAULT 'N',
	PORC_INTCTE          		DECIMAL(28,8)	NOT NULL DEFAULT 0,
	CONTRATO             		VARCHAR(20)	NULL,
	NUM_PARCIALIDADES    		SMALLINT 	NOT NULL DEFAULT 0,
	TASA_IMPOSITIVA			VARCHAR(4)	NULL,
	TASA_IMPOSITIVA_PORC		DECIMAL(28,8)	NULL,
	TASA_CREE1			VARCHAR(4)	NULL,
	TASA_CREE1_PORC			DECIMAL(28,8)	NULL,
	TASA_CREE2			VARCHAR(4)	NULL,
	TASA_CREE2_PORC			DECIMAL(28,8)	NULL,
	TASA_GAN_OCASIONAL_PORC 	DECIMAL(28,8)	NULL,
	GENERA_DOC_FE 			VARCHAR(1) 	DEFAULT 'N' NOT NULL,
	DOCUMENTO_GLOBAL 		VARCHAR(50) 	NULL,
	FECHA_CAI DATETIME NULL,
	CAI VARCHAR(50) NULL
 )
go
 
 
 ALTER TABLE DOCUMENTOS_CP
        ADD CONSTRAINT DOCUMENTOS_CPPK PRIMARY KEY NONCLUSTERED (
               PROVEEDOR, DOCUMENTO, TIPO)
go
 
 
 CREATE TABLE EMBARQUE_DOC_CP (
        PROVEEDOR            VARCHAR(20) NOT NULL,
        DOCUMENTO            VARCHAR(50) NOT NULL,
        TIPO                 VARCHAR(3) NOT NULL,
        EMBARQUE             VARCHAR(10) NOT NULL,
        NOTAS                TEXT NULL,
        MONTO_APLICAR 	     DECIMAL(28,8) NULL,
	LIQUIDAC_COMPRA      VARCHAR(15) NULL,
	ETIQUETA 	     VARCHAR(20) NULL
 )
go
 
 
 ALTER TABLE EMBARQUE_DOC_CP
        ADD CONSTRAINT XPKEMBARQUE_DOC_CP PRIMARY KEY (PROVEEDOR, 
               DOCUMENTO, TIPO, EMBARQUE)
go



CREATE TABLE $$COMPANIA$$.FIADORES_DOC_CP (
	FIADOR_ID        	VARCHAR(20)		NOT NULL,
	PROVEEDOR		VARCHAR(20)		NOT NULL,
	DOCUMENTO		VARCHAR(50)		NOT NULL,
	TIPO			VARCHAR(3)		NOT NULL,
	NOMBRE_FIADOR		VARCHAR(80)		NOT NULL,
	OCUPAC_FIADOR  		VARCHAR(30)		NULL,
	TIPO_FIADOR 		VARCHAR(20)		NULL,
	DIREC_FIADOR 		VARCHAR(80)		NULL,
	TEL_DOM_FIADOR 		VARCHAR(10)		NULL,
	LUG_TRAB_FIADOR 	VARCHAR(80)		NULL,
	DIR_TRAB_FIADOR  	VARCHAR(80)		NULL,
	TEL_TRAB_FIADOR 	VARCHAR(10)		NULL,
	CONTRATO_FIADOR  	VARCHAR(20)		NULL,
	OBS_FIADOR   		VARCHAR(200)		NULL 
)
go

ALTER TABLE $$COMPANIA$$.FIADORES_DOC_CP 
	ADD CONSTRAINT XPKFIADORCP PRIMARY KEY NONCLUSTERED 
         ( FIADOR_ID, PROVEEDOR, DOCUMENTO, TIPO )
go


CREATE TABLE $$COMPANIA$$.GARANTIAS_DOC_CP (
	GARANTIA_ID		VARCHAR(20)		NOT NULL,
	PROVEEDOR		VARCHAR(20)		NOT NULL,
	DOCUMENTO		VARCHAR(50)		NOT NULL,
	TIPO			VARCHAR(3)		NOT NULL,
	TIPO_GARANTIA		VARCHAR(20)		NULL,
	DESC_GARANTIA		VARCHAR(40)		NULL,
	OBS_GARANTIA		VARCHAR(200)		NULL,
	ART_GARANTIA		VARCHAR(20)		NULL 
)
go


ALTER TABLE $$COMPANIA$$.GARANTIAS_DOC_CP
	ADD CONSTRAINT XPKGARANTIACP PRIMARY KEY NONCLUSTERED
         ( GARANTIA_ID, PROVEEDOR, DOCUMENTO, TIPO )
go

 
 
 CREATE TABLE GLOBALES_CP (
        FECHA_ULT_COMPRIME   	DATETIME 	NOT NULL,
        LIMPIAR_APLICACION   	VARCHAR(1) 	NOT NULL,
        DETALLE_OBLIGAT      	VARCHAR(1) 	NOT NULL,
        CHQ_A_PANTALLA       	VARCHAR(1) 	NULL,
        PAGO_OTRA_MONEDA     	VARCHAR(1) 	NOT NULL,
        DOC_PRONTO_PAGO      	VARCHAR(3) 	NOT NULL,
        ULTIMO_CH            	VARCHAR(20)	NULL,
        ULTIMO_NC            	VARCHAR(20)	NULL,
        ULTIMO_OC            	VARCHAR(20)	NULL,
        ULTIMO_RET           	VARCHAR(50)	NULL,
        VENC_PERIODO1        	smallint 	NULL,
        VENC_PERIODO2        	smallint 	NULL,
        VENC_PERIODO3        	smallint 	NULL,
        VENC_PERIODO4        	smallint 	NULL,
        ANT_PERIODO1         	smallint 	NULL,
        ANT_PERIODO2         	smallint 	NULL,
        ANT_PERIODO3         	smallint 	NULL,
        ANT_PERIODO4         	smallint 	NULL,
        USAR_RUBROS          	VARCHAR(1) 	NOT NULL,
        RUBRO1_NOMBRE        	VARCHAR(15)	NULL,
        RUBRO2_NOMBRE        	VARCHAR(15)	NULL,
        IMPUESTO_X_OMISION   	VARCHAR(4) 	NULL,
        ASIENTO_ND           	VARCHAR(1) 	NOT NULL,
        ASIENTO_FAC          	VARCHAR(1) 	NOT NULL,
        ASIENTO_INT          	VARCHAR(1) 	NOT NULL,
        ASIENTO_OD           	VARCHAR(1) 	NOT NULL,
        ASIENTO_CHQ          	VARCHAR(1) 	NOT NULL,
        ASIENTO_TEF          	VARCHAR(1) 	NOT NULL,
        ASIENTO_LC           	VARCHAR(1) 	NOT NULL,
        ASIENTO_NC           	VARCHAR(1) 	NOT NULL,
        ASIENTO_OC           	VARCHAR(1) 	NOT NULL,
        PAQUETE_CRE          	VARCHAR(4) 	NULL,
        TIPO_ASIENTO_CRE     	VARCHAR(4) 	NULL,
        PAQUETE_DEB          	VARCHAR(4) 	NULL,
        TIPO_ASIENTO_DEB     	VARCHAR(4) 	NULL,
        ASIENTOS_CTA_PAIS    	VARCHAR(1) 	NOT NULL,
        INTEGRACION_CONTA    	VARCHAR(1) 	NOT NULL,
        MOD_APLIC_ASIENTO    	smallint 	NOT NULL,
        TIPO_CONTA_OMISION   	VARCHAR(1) 	NOT NULL,
        ULTIMO_CONTRAREC     	VARCHAR(20)	NULL,
        NIT_DUPLICADO        	VARCHAR(1) 	NOT NULL,
        REFRESCA_AUTO        	VARCHAR(1) 	NOT NULL,
        USAR_RUBROS_PROV     	VARCHAR(1) 	NOT NULL,
        RUBRO1_PROV_NOMBRE   	VARCHAR(15)	NULL,
        RUBRO2_PROV_NOMBRE   	VARCHAR(15)	NULL,
        RUBRO3_PROV_NOMBRE   	VARCHAR(15)	NULL,
        RUBRO4_PROV_NOMBRE   	VARCHAR(15)	NULL,
        RUBRO5_PROV_NOMBRE   	VARCHAR(15)	NULL,
        COPIARNOTASENASNT    	VARCHAR(1) 	NOT NULL,
        ASOCOBLIGCONTFACT    	VARCHAR(1) 	NOT NULL,
        USAR_RUBROS_VAL      	VARCHAR(1) 	NOT NULL,
        NOM_RUBRO1_PRO       	VARCHAR(60)	NULL,
        NOM_RUBRO2_PRO       	VARCHAR(60)	NULL,
        NOM_RUBRO3_PRO       	VARCHAR(60)	NULL,
        NOM_RUBRO4_PRO       	VARCHAR(60)	NULL,
        NOM_RUBRO5_PRO       	VARCHAR(60)	NULL,
        FORMA_CREACION       	VARCHAR(1) 	NOT NULL,
        RUBROS_DIAS_REV      	smallint 	NULL,
        USA_FECHA_CONT       	VARCHAR(1) 	NOT NULL,
        DIAS_CONTABLES       	smallint 	NULL,
        NUM_LIMITE_RET       	VARCHAR(20)	NULL,
        FECHA_ULT_DIFCAMB    	DATETIME 	NOT NULL,
        ULTIMO_FAC 	     	VARCHAR(20) 	DEFAULT ('0') NULL,
        ULTIMO_INT 	     	VARCHAR(20) 	DEFAULT ('0') NULL,
        ULTIMO_LC 	     	VARCHAR(20) 	DEFAULT ('0') NULL,
        ULTIMO_ND 	     	VARCHAR(20) 	DEFAULT ('0') NULL,
        ULTIMO_OD 	     	VARCHAR(20) 	DEFAULT ('0') NULL,
        NOM_RUBRO6_PRO       	VARCHAR(60) 	NULL,
	NOM_RUBRO7_PRO       	VARCHAR(60) 	NULL,
	NOM_RUBRO8_PRO       	VARCHAR(60) 	NULL,
	NOM_RUBRO9_PRO       	VARCHAR(60) 	NULL,
        NOM_RUBRO10_PRO      	VARCHAR(60) 	NULL,
        ASIGNAR_MISMA_ENTIDAD	VARCHAR(1) 	DEFAULT ('N') NOT NULL,
        ULTIMO_RED 	     	VARCHAR(50) 	NULL,
        INTEGRACION_CR 	     	VARCHAR(1) 	NULL,
	PAQUETE_CR 		VARCHAR(4) 	NULL,
	PRESUPUESTO_CR  	VARCHAR(20) 	NULL,
	REQUIERE_PRESUP 	VARCHAR(1) 	NULL,
	ASIENTO_INT_CORRIENTE	VARCHAR(1) 	NOT NULL DEFAULT 'S'
 )
go

CREATE TABLE HIST_DIFCAM_CP(
        USUARIO_AUDITORIA 	VARCHAR(25)	NOT NULL,
	FECHA_AUDITORIA 	DATETIME        NOT NULL,
	FECHA_PROC		DATETIME        NOT NULL,
	DOCUMENTO		VARCHAR(50)	NOT NULL,
	TIPO			VARCHAR(3)	NOT NULL,
	PROVEEDOR		VARCHAR(20)	NOT NULL,
	TIPO_CAMBIO_PROC	DECIMAL(28,8) 	NOT NULL,
	ASIENTO_PROC		VARCHAR(10)	NULL,
	DIF_CAM_LOCAL		DECIMAL(28,8) 	NOT NULL,
	DIF_CAM_DOLAR		DECIMAL(28,8) 	NOT NULL,
	TCAMB_LOC_DOC_ANT	DECIMAL(28,8) 	NOT NULL,
	TCAMB_DOL_DOC_ANT	DECIMAL(28,8) 	NOT NULL,
	TCAMB_LOC_DOC_ACT	DECIMAL(28,8) 	NOT NULL,
	TCAMB_DOL_DOC_ACT	DECIMAL(28,8) 	NOT NULL,
	CUENTA_CONTABLE		VARCHAR(25)	NULL,
	CENTRO_COSTO		VARCHAR(25)	NULL,
	ESTADO			VARCHAR(1)	NOT NULL,
	NOTAS_REV    		TEXT            NULL,
	ID_HIST 		UniqueIdentifier NOT NULL)
go

ALTER TABLE HIST_DIFCAM_CP 
	ADD CONSTRAINT IDDEF_HISTDCCP   
		DEFAULT (NEWID()) FOR [ID_HIST]
go		


ALTER TABLE HIST_DIFCAM_CP
         ADD CONSTRAINT HISTDFCPPK PRIMARY KEY NONCLUSTERED 
         (Id_hist)
go  



CREATE TABLE $$COMPANIA$$.PARCIALIDADES_CP (
	PROVEEDOR			VARCHAR(20)		NOT NULL,
	TIPO_DOC_ORIGEN			VARCHAR(3)		NOT NULL,
	DOCUMENTO_ORIGEN		VARCHAR(50)		NOT NULL,
	PARCIALIDAD			SMALLINT		NOT NULL,
	FECHA_RIGE			DATETIME		NOT NULL,
	FECHA_VENCE			DATETIME		NOT NULL,
	PORCENTAJE			DECIMAL(28,8)		NOT NULL,
	SALDO				DECIMAL(28,8)		NOT NULL,
	SALDO_LOCAL			DECIMAL(28,8)		NOT NULL,
	SALDO_DOLAR			DECIMAL(28,8)		NOT NULL,
	MONTO_PRINCIPAL			DECIMAL(28,8)		NULL,
	MONTO_PRINCIPAL_LOC		DECIMAL(28,8)		NULL,
	MONTO_PRINCIPAL_DOL		DECIMAL(28,8)		NULL,
	MONTO_AMORTIZA			DECIMAL(28,8)		NULL,
	MONTO_AMORTIZA_LOC		DECIMAL(28,8)		NULL,
	MONTO_AMORTIZA_DOL		DECIMAL(28,8)		NULL,
	SALDO_AMORTIZA			DECIMAL(28,8)		NULL,
	SALDO_AMORTIZA_LOC		DECIMAL(28,8)		NULL,
	SALDO_AMORTIZA_DOL		DECIMAL(28,8)		NULL,
	MONTO_INTERES			DECIMAL(28,8)		NULL,
	MONTO_INTERES_LOC		DECIMAL(28,8)		NULL,
	MONTO_INTERES_DOL		DECIMAL(28,8)		NULL,
	SALDO_INTERES			DECIMAL(28,8)		NULL,
	SALDO_INTERES_LOC		DECIMAL(28,8)		NULL,
	SALDO_INTERES_DOL		DECIMAL(28,8)		NULL,
	MONTO_CUOTA			DECIMAL(28,8)		NULL,
	MONTO_CUOTA_LOC			DECIMAL(28,8)		NULL,
	MONTO_CUOTA_DOL			DECIMAL(28,8)		NULL,
	SALDO_CUOTA			DECIMAL(28,8)		NULL,
	SALDO_CUOTA_LOC			DECIMAL(28,8)		NULL,
	SALDO_CUOTA_DOL			DECIMAL(28,8)		NULL,
	SALDO_PRINCIPAL			DECIMAL(28,8)		NULL,
	SALDO_PRINCIPAL_LOC		DECIMAL(28,8)		NULL,
	SALDO_PRINCIPAL_DOL		DECIMAL(28,8)		NULL,
	FECHA_PROYECTADA		DATETIME		NULL,
	MONTO_IMP_RENTA			DECIMAL(28,8)		NULL,
	MONTO_IMP_RENTA_LOCAL		DECIMAL(28,8)		NULL,
	MONTO_IMP_RENTA_DOLAR		DECIMAL(28,8)		NULL,
	MONTO_IMP_CREE1			DECIMAL(28,8)		NULL,
	MONTO_IMP_CREE1_LOCAL		DECIMAL(28,8)		NULL,
	MONTO_IMP_CREE1_DOLAR		DECIMAL(28,8)		NULL,
	MONTO_IMP_CREE2			DECIMAL(28,8)		NULL,
	MONTO_IMP_CREE2_LOCAL		DECIMAL(28,8)		NULL,
	MONTO_IMP_CREE2_DOLAR		DECIMAL(28,8)		NULL,
	MONTO_GAN_OCASIONAL		DECIMAL(28,8)		NULL,
	MONTO_GAN_OCASIONAL_LOCAL 	DECIMAL(28,8) 		NULL,
	MONTO_GAN_OCASIONAL_DOLAR 	DECIMAL(28,8) 		NULL
 )
 go
 
 ALTER TABLE $$COMPANIA$$.PARCIALIDADES_CP
        ADD CONSTRAINT XPKPARCIALIDADES_CP PRIMARY KEY ( PROVEEDOR, TIPO_DOC_ORIGEN, DOCUMENTO_ORIGEN, PARCIALIDAD )
 go

 
 
 CREATE TABLE PROV_RETENCION (
        PROVEEDOR            VARCHAR(20) NOT NULL,
        CODIGO_RETENCION     VARCHAR(4) NOT NULL,
        NOTAS                TEXT NULL
 )
go
 
 
 ALTER TABLE PROV_RETENCION
        ADD CONSTRAINT XPKPROV_RETENCION PRIMARY KEY (PROVEEDOR, 
               CODIGO_RETENCION)
go
 
 
 

CREATE TABLE PROV_VALORES_CERTIF (
         PROVEEDOR         		VARCHAR(20)     NOT NULL,
         PERIODO         		DATETIME     	NOT NULL,
         PAGOS_ABONOS			DECIMAL(28,8)   NULL,
         APORTES_SALUD         		DECIMAL(28,8)   NULL,
         APORTES_PENSION		DECIMAL(28,8)   NULL,
         APORTES_AFC         		DECIMAL(28,8)   NULL,
         BASE_RET_UVT 			DECIMAL(28,8) 	NULL,
         PORCENTAJE_RET			DECIMAL(28,8)   NULL,
         PAGOS_ABONOS_REAL    		DECIMAL(28,8)   NULL,
         PORCENTAJE_RET_REAL		DECIMAL(28,8)   NULL,
         RETENIDO_APLICADO     		DECIMAL(28,8)   NULL,
         RETENIDO_AJUSTADO		DECIMAL(28,8)   NULL,
         DIFERENCIA_RET        		DECIMAL(28,8)   NULL,
         FECHA_ULT_AJUSTE      		DATETIME     	NULL,
	 APORTES_PENSION_VOL		DECIMAL(28,8)   NULL,
         INTERES_PRESTAMO      		DECIMAL(28,8)   NULL,
         APORTES_SALUD_REAL    		DECIMAL(28,8)   NULL,
         APORTES_PEN_REAL		DECIMAL(28,8)   NULL,
         APORTES_PEN_VOL_REAL		DECIMAL(28,8)   NULL,
         APORTES_AFC_REAL     		DECIMAL(28,8)   NULL,
         INTERES_PREST_REAL 		DECIMAL(28,8) 	NULL,
         APORTES_MINIMA			DECIMAL(28,8)   NULL,
         APORTES_ACUM_UVT		DECIMAL(28,8)   NULL,
         DECLARANTE			VARCHAR(1)  	NOT NULL DEFAULT 'N',
	 APORTE_SALUD_VOLUNTARIA	DECIMAL(18,2) 	NULL,
	 DEPENDIENTES			DECIMAL(18,2) 	NULL,
	 RENTA_EXENTA			DECIMAL(18,2) 	NULL,
	 APORTES_MINIMA_REAL		DECIMAL(18,2) 	NULL,
	 CUENTA_CONTABLE383		VARCHAR(25) 	NULL,
	 CENTRO_COSTO383		VARCHAR(25) 	NULL,
	 CUENTA_CONTABLE384		VARCHAR(25) 	NULL,
	 CENTRO_COSTO384		VARCHAR(25) 	NULL,
	 APORTE_SALUD_VOLUNTARIO_REAL	DECIMAL(18,2)	NULL,
	 DEPENDIENTES_REAL		DECIMAL(18,2)	NULL,
	 RENTA_EXENTA_REAL		DECIMAL(18,2)	NULL,
	 ACUM_RENTA_EXENTA_UVT		DECIMAL(18,2)	NULL,
	 ES383                          VARCHAR(1) 	NULL
)
go



ALTER TABLE PROV_VALORES_CERTIF  ADD CONSTRAINT XPKPROV_VALORES_CERTIF PRIMARY KEY NONCLUSTERED  ( PROVEEDOR,PERIODO )
go
         
          
 
 
 
 CREATE TABLE PROVEEDOR (
        PROVEEDOR            	VARCHAR(20) 	NOT NULL,
        DETALLE_DIRECCION    	int 		NULL,
        NOMBRE               	VARCHAR(150) 	NOT NULL,
        ALIAS                	VARCHAR(150) 	NULL,
        CONTACTO             	VARCHAR(30) 	NOT NULL,
        CARGO                	VARCHAR(30) 	NOT NULL,
        DIRECCION            	TEXT 		NOT NULL,
        E_MAIL               	VARCHAR(249) 	NULL,
        FECHA_INGRESO        	DATETIME 	NOT NULL,
        FECHA_ULT_MOV        	DATETIME 	NOT NULL,
        TELEFONO1            	VARCHAR(50) 	NOT NULL,
        TELEFONO2            	VARCHAR(50) 	NOT NULL,
        FAX                  	VARCHAR(50) 	NOT NULL,
        ORDEN_MINIMA         	DECIMAL(28,8) 	NOT NULL,
        DESCUENTO            	DECIMAL(28,8) 	NOT NULL,
        TASA_INTERES_MORA    	DECIMAL(28,8) 	NULL,
        LOCAL                	VARCHAR(1) 	NOT NULL,
        CONGELADO            	VARCHAR(1) 	NOT NULL,
        CONTRIBUYENTE        	VARCHAR(20)	NOT NULL,
        CONDICION_PAGO       	VARCHAR(4) 	NOT NULL,
        MONEDA               	VARCHAR(4) 	NOT NULL,
        PAIS                 	VARCHAR(4) 	NOT NULL,
        CATEGORIA_PROVEED    	VARCHAR(8) 	NOT NULL,
        MULTIMONEDA          	VARCHAR(1) 	NOT NULL,
        SALDO                	DECIMAL(28,8)	NOT NULL,
        SALDO_LOCAL          	DECIMAL(28,8)	NOT NULL,
        SALDO_DOLAR          	DECIMAL(28,8)	NOT NULL,
        NOTAS                	TEXT 		NULL,
        RUBRO1_PROV          	VARCHAR(50) 	NULL,
        RUBRO2_PROV          	VARCHAR(50) 	NULL,
        RUBRO3_PROV          	VARCHAR(50) 	NULL,
        RUBRO4_PROV          	VARCHAR(50) 	NULL,
        RUBRO5_PROV          	VARCHAR(50) 	NULL,
        RUBRO1_PROVEEDOR     	VARCHAR(40) 	NULL,
        RUBRO2_PROVEEDOR     	VARCHAR(40) 	NULL,
        RUBRO3_PROVEEDOR     	VARCHAR(40) 	NULL,
        RUBRO4_PROVEEDOR     	VARCHAR(40) 	NULL,
        RUBRO5_PROVEEDOR     	VARCHAR(40) 	NULL,
		GLN 		     		VARCHAR(13) 	NULL,
		UBICACION 	     		VARCHAR(50) 	NULL,
		ACTIVO               	VARCHAR(1) 	NOT NULL,
		TIPO_CONTRIBUYENTE   	VARCHAR(1) 	NULL,
		RUBRO6_PROVEEDOR     	VARCHAR(40) 	NULL,
		RUBRO7_PROVEEDOR     	VARCHAR(40) 	NULL,
		RUBRO8_PROVEEDOR     	VARCHAR(40) 	NULL,
		RUBRO9_PROVEEDOR     	VARCHAR(40) 	NULL,
        RUBRO10_PROVEEDOR    	VARCHAR(40) 	NULL,
        MODELO_RETENCION     	VARCHAR(4) 	NULL ,
        CODIGO_IMPUESTO      	VARCHAR(4)      NULL,
        DIVISION_GEOGRAFICA1	VARCHAR(12)	NULL,
		DIVISION_GEOGRAFICA2	VARCHAR(12)	NULL,
		AUTORETENEDOR			VARCHAR(1)	NOT NULL DEFAULT 'N',
		REGIMEN_TRIB			VARCHAR(12)	NULL,
		SALDO_TRANS 			DECIMAL(28,8) 	DEFAULT 0 	NOT NULL,
		SALDO_TRANS_LOCAL 		DECIMAL(28,8) 	DEFAULT 0 	NOT NULL,
		SALDO_TRANS_DOLAR 		DECIMAL(28,8) 	DEFAULT 0 	NOT NULL,
		PERMITE_DOC_GP			VARCHAR(1) 	DEFAULT 'N' 	NOT NULL,
		PARTICIPA_FLUJOCAJA		VARCHAR(1)	DEFAULT 'N'	NOT NULL, 
		CURP  					VARCHAR(18)   	NULL,
		USUARIO_CREACION		VARCHAR(25)	NULL,
		FECHA_HORA_CREACION		DATETIME	NULL,
		USUARIO_ULT_MOD			VARCHAR(25)	NULL,
		FCH_HORA_ULT_MOD		DATETIME	NULL,
		IMPUESTO1_INCLUIDO 		VARCHAR(1) 	NOT NULL DEFAULT ('N'),
		XSLT_PERSONALIZADO 		VARCHAR(50) 	NULL,
		UBICACIONDOCELECTRONICO 	VARCHAR(10)	NULL,
		EMAIL_DOC_ELECTRONICO 		VARCHAR(249) 	NULL,
		EMAIL_DOC_ELECTRONICO_COPIA VARCHAR(249) 	NULL,
		ACEPTA_DOC_ELECTRONICO 		VARCHAR(1) 	DEFAULT ('N') NOT NULL,
		INTERNACIONES				VARCHAR(1) 	NOT NULL 	DEFAULT 'N'

 )
go
 
 
 ALTER TABLE PROVEEDOR
        ADD CONSTRAINT PROVEEDORPK 
        	PRIMARY KEY NONCLUSTERED (PROVEEDOR)
go
 
 
 CREATE TABLE PROVEEDOR_ENTIDAD (
        PROVEEDOR            	VARCHAR(20) NOT NULL,
        ENTIDAD_FINANCIERA   	VARCHAR(8) 	NOT NULL,
        CUENTA_BANCO         	VARCHAR(20) NOT NULL,
        NOTAS                	TEXT 		NULL,
        MONEDA               	VARCHAR(4) 	NOT NULL,
        CTA_DEFAULT 	     	VARCHAR(1) 	NULL,
        TIPO_CUENTA				VARCHAR(12) NULL,
        CTA_ELECTRONICA 		VARCHAR(50) NULL

 )
go
 
 
 ALTER TABLE PROVEEDOR_ENTIDAD
        ADD CONSTRAINT PROVEEDOR_ENTIDPK PRIMARY KEY NONCLUSTERED (
               PROVEEDOR, ENTIDAD_FINANCIERA, MONEDA)
go
 
 

CREATE TABLE $$COMPANIA$$.REPORTES_CP (
	REPORTE			VARCHAR(30) 	NULL,
	PROVEEDOR		VARCHAR(20) 	NULL, 
	DOCUMENTO		VARCHAR(50) 	NULL, 
	TIPO			VARCHAR(3) 	NULL, 
	MONEDA			VARCHAR(4) 	NULL,
	FECHA			DATETIME 	NULL, 
	FECHA_DOCUMENTO		DATETIME 	NULL, 
	FECHA_VENCE		DATETIME 	NULL,	
	TIPO_CAMB_ACT_LOC	DECIMAL(28,8) 	NULL,
	TIPO_CAMB_ACT_DOL	DECIMAL(28,8) 	NULL,  
	TIPO_CAMB_ACT_PROV	DECIMAL(28,8) 	NULL, 
	CONTRARECIBO		VARCHAR(50) 	NULL, 
	ASIENTO			VARCHAR(10) 	NULL, 
	CONDICION_PAGO		VARCHAR(10) 	NULL,  
	DESCUENTO		DECIMAL(28,8) 	NULL, 
	SUBTOTAL		DECIMAL(28,8) 	NULL, 
	MONTO_RETENCION		DECIMAL(28,8) 	NULL, 
	SALDO_RETENCION		DECIMAL(28,8) 	NULL, 
	IMPUESTO1		DECIMAL(28,8) 	NULL, 
	IMPUESTO2		DECIMAL(28,8) 	NULL,  
	RUBRO1			DECIMAL(28,8) 	NULL,
	RUBRO2			DECIMAL(28,8) 	NULL, 
	APLICACION		VARCHAR(249) 	NULL, 
	DESC_SUBTIPO		VARCHAR(25) 	NULL,	
	DIAS_NETO		INT 		NULL,
	MONTO_DOC	 	DECIMAL(28,8) 	NULL,
	MONTO_PROV	 	DECIMAL(28,8) 	NULL,
	MONTO_LOCAL  		DECIMAL(28,8) 	NULL,
	MONTO_DOLAR  		DECIMAL(28,8) 	NULL,    
	SALDO_PROV		DECIMAL(28,8) 	NULL,
	SALDO_LOCAL  		DECIMAL(28,8) 	NULL,
	SALDO_DOLAR  		DECIMAL(28,8) 	NULL,
	SALDO_RANGO0 		DECIMAL(28,8) 	NULL,
	SALDO_RANGO1 		DECIMAL(28,8) 	NULL,
	SALDO_RANGO2 		DECIMAL(28,8) 	NULL,
	SALDO_RANGO3 		DECIMAL(28,8) 	NULL,
	SALDO_RANGO4 		DECIMAL(28,8) 	NULL,
	SALDO_RANGO5 		DECIMAL(28,8) 	NULL,
	TIPO_CONDPAGO 		VARCHAR(2)	NULL,
	NUM_PARCIALIDADES	INT 		NULL,
	PARCIALIDAD		INT 		NULL,
	PAR_MONTO_PRINCIPAL	DECIMAL(28,8) 	NULL,
	PAR_MONTO_AMORTIZA	DECIMAL(28,8) 	NULL,
	PAR_SALDO_AMORTIZA	DECIMAL(28,8) 	NULL,
	PAR_MONTO_INTERES	DECIMAL(28,8) 	NULL,
	PAR_SALDO_INTERES	DECIMAL(28,8) 	NULL,
	PAR_MONTO_CUOTA		DECIMAL(28,8) 	NULL,
	PAR_SALDO_CUOTA		DECIMAL(28,8) 	NULL,
	PAR_SALDO_PRINCIPAL	DECIMAL(28,8) 	NULL
	
 )
 go
 


 
 CREATE TABLE SUBTIPO_DOC_CP (
        SUBTIPO              	smallint 	NOT NULL,
        TIPO                 	VARCHAR(3) 	NOT NULL,
        DESCRIPCION          	VARCHAR(25) 	NOT NULL,
        TIPO_CB              	VARCHAR(3) 	NULL,
        SUBTIPO_CB           	smallint 	NULL,
        CUENTA_CONTABLE      	VARCHAR(25) 	NULL,
        CENTRO_COSTO         	VARCHAR(25) 	NULL,
        TIPO_ASIENTO 		VARCHAR(4) 	NULL,
	PAQUETE 		VARCHAR(4) 	NULL,
	TIPO_SERVICIO 		VARCHAR (2) 	NULL,
	DOCUMENTO_GLOBAL 	VARCHAR(10) 	NULL
 )
go
 
 
 ALTER TABLE SUBTIPO_DOC_CP
        ADD CONSTRAINT XPKSUBTIPO_DOC_CP PRIMARY KEY (SUBTIPO, TIPO)
go
 
 
 

CREATE TABLE TIPO_CUENTA (
        TIPO_CUENTA	     VARCHAR(12) 	NOT NULL,
        DESCRIPCION          VARCHAR(40)	NOT NULL        
 )
 go


ALTER TABLE TIPO_CUENTA
        ADD CONSTRAINT XPKTIPO_CUENTA PRIMARY KEY (TIPO_CUENTA)
go        
 
 
CREATE TABLE TIPO_SERVICIO_CP(
       TIPO_SERVICIO	    VARCHAR(10) 	NOT NULL,
       DESCRIPCION          VARCHAR(249) 	NULL,
       CENTRO_COSTO         VARCHAR(25)		NULL,
       CUENTA_CONTABLE      VARCHAR(25) 	NULL)
go       



ALTER TABLE TIPO_SERVICIO_CP ADD CONSTRAINT XPK_TIPO_SERVICIO_CP PRIMARY KEY (TIPO_SERVICIO)
go