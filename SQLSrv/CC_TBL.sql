
 
 CREATE TABLE AUXILIAR_CC (
        TIPO_CREDITO         VARCHAR(3) 	NOT NULL,
        TIPO_DEBITO          VARCHAR(3) 	NOT NULL,
        FECHA                DATETIME 		NOT NULL,
        CREDITO              VARCHAR(50) 	NOT NULL,
        DEBITO               VARCHAR(50) 	NOT NULL,
        MONTO_DEBITO         DECIMAL(28,8) 	NOT NULL,
        MONTO_CREDITO        DECIMAL(28,8) 	NOT NULL,
        MONTO_LOCAL          DECIMAL(28,8) 	NOT NULL,
        MONTO_DOLAR          DECIMAL(28,8) 	NOT NULL,
        MONTO_CLI_CREDITO    DECIMAL(28,8) 	NOT NULL,
        ASIENTO              VARCHAR(10) 	NULL,
        TIPO_DOCPPAGO        VARCHAR(3) 	NULL,
        DOCUMENTO_DOCPPAGO   VARCHAR(50) 	NULL,
        MONTO_CLI_DEBITO     DECIMAL(28,8) 	NOT NULL,
        MONEDA_CREDITO       VARCHAR(4) 	NOT NULL,
        MONEDA_DEBITO        VARCHAR(4) 	NOT NULL,
        CLI_REPORTE_CREDIT   VARCHAR(20) 	NOT NULL,
        CLI_REPORTE_DEBITO   VARCHAR(20) 	NOT NULL,
        CLI_DOC_CREDIT       VARCHAR(20) 	NOT NULL,
        CLI_DOC_DEBITO       VARCHAR(20) 	NOT NULL,
        TIPO_DOCINTCTE       VARCHAR(3) 	NULL,
        DOC_DOCINTCTE        VARCHAR(50) 	NULL,
        FOLIOSAT_DEBITO      VARCHAR(50) 	NULL,
        FOLIOSAT_CREDITO     VARCHAR(50) 	NULL,
        TIPO_CAMBIO_APLICA   DECIMAL(28,8)	NULL,
		ASIENTO_DIF_CAMB_MR  VARCHAR(10) 	NULL
		
 )
go
 
 
 ALTER TABLE AUXILIAR_CC
        ADD CONSTRAINT AUXILIAR_CCPK PRIMARY KEY NONCLUSTERED (
               TIPO_CREDITO, TIPO_DEBITO, FECHA, CREDITO, DEBITO)
go
 
 
 CREATE TABLE AUXILIAR_PARC_CC (
        TIPO_CREDITO         VARCHAR(3) NOT NULL,
        TIPO_DEBITO          VARCHAR(3) NOT NULL,
        FECHA                DATETIME NOT NULL,
        CREDITO              VARCHAR(50) NOT NULL,
        DEBITO               VARCHAR(50) NOT NULL,
        PARCIALIDAD          smallint NOT NULL,
        MONTO_DEBITO         DECIMAL(28,8) NOT NULL,
        MONTO_CREDITO        DECIMAL(28,8) NOT NULL,
        MONTO_LOCAL          DECIMAL(28,8) NOT NULL,
        MONTO_DOLAR          DECIMAL(28,8) NOT NULL,
        MONTO_CLI_CREDITO    DECIMAL(28,8) NOT NULL,
        MONTO_CLI_DEBITO     DECIMAL(28,8) NOT NULL,
        ASIENTO              VARCHAR(10) NULL,
        MONTO_AMORTIZA	     DECIMAL(28,8) NULL,
	MONTO_AMORTIZA_LOC   DECIMAL(28,8) NULL,
	MONTO_AMORTIZA_DOL   DECIMAL(28,8) NULL,
	MONTO_INTERES	     DECIMAL(28,8) NULL,
	MONTO_INTERES_LOC    DECIMAL(28,8) NULL,
	MONTO_INTERES_DOL    DECIMAL(28,8) NULL,
	MONTO_CUOTA	     DECIMAL(28,8) NULL,
	MONTO_CUOTA_LOC	     DECIMAL(28,8) NULL,
	MONTO_CUOTA_DOL	     DECIMAL(28,8) NULL,
	TIPO_CAMBIO_APLICA   DECIMAL(28,8) NULL
 )
go
 
 
 ALTER TABLE AUXILIAR_PARC_CC
        ADD CONSTRAINT XPKAUXILIAR_PARC_CC PRIMARY KEY (TIPO_CREDITO, 
               TIPO_DEBITO, FECHA, CREDITO, DEBITO, PARCIALIDAD)
go
 
 
 CREATE TABLE CLIENTE (
        CLIENTE              		VARCHAR(20) 	NOT NULL,
        NOMBRE               		VARCHAR(150) 	NOT NULL,
        DETALLE_DIRECCION    		int 		NULL,
        ALIAS                		VARCHAR(150) 	NULL,
        CONTACTO             		VARCHAR(30) 	NOT NULL,
        CARGO                		VARCHAR(30) 	NOT NULL,
        DIRECCION            		TEXT 		NULL,
        DIR_EMB_DEFAULT      		VARCHAR(8) 	NULL,
        TELEFONO1            		VARCHAR(50) 	NOT NULL,
        TELEFONO2            		VARCHAR(50) 	NOT NULL,
        FAX                  		VARCHAR(50) 	NOT NULL,
        CONTRIBUYENTE        		VARCHAR(20) 	NOT NULL,
        FECHA_INGRESO        		DATETIME 	NOT NULL,
        MULTIMONEDA          		VARCHAR(1) 	NOT NULL,
        MONEDA               		VARCHAR(4) 	NOT NULL,
        SALDO                		DECIMAL(28,8) 	NOT NULL,
        SALDO_LOCAL          		DECIMAL(28,8) 	NOT NULL,
        SALDO_DOLAR          		DECIMAL(28,8) 	NOT NULL,
        SALDO_CREDITO        		DECIMAL(28,8) 	NOT NULL,
        SALDO_NOCARGOS       		DECIMAL(28,8) 	NULL,
        LIMITE_CREDITO       		DECIMAL(28,8) 	NULL,
        EXCEDER_LIMITE       		VARCHAR(1) 	NOT NULL,
        TASA_INTERES         		DECIMAL(28,8) 	NOT NULL,
        TASA_INTERES_MORA    		DECIMAL(28,8) 	NOT NULL,
        FECHA_ULT_MORA       		DATETIME 	NOT NULL,
        FECHA_ULT_MOV        		DATETIME 	NOT NULL,
        CONDICION_PAGO       		VARCHAR(4) 	NOT NULL,
        NIVEL_PRECIO         		VARCHAR(12) 	NOT NULL,
        DESCUENTO            		DECIMAL(28,8) 	NOT NULL,
        MONEDA_NIVEL         		VARCHAR(1) 	NOT NULL,
        ACEPTA_BACKORDER     		VARCHAR(1) 	NOT NULL,
        PAIS                 		VARCHAR(4) 	NOT NULL,
        ZONA                 		VARCHAR(4) 	NOT NULL,
        RUTA                 		VARCHAR(4) 	NOT NULL,
        VENDEDOR             		VARCHAR(4) 	NULL,
        COBRADOR             		VARCHAR(4) 	NOT NULL,
        ACEPTA_FRACCIONES    		VARCHAR(1) 	NOT NULL,
        ACTIVO               		VARCHAR(1) 	NOT NULL,
        EXENTO_IMPUESTOS     		VARCHAR(1) 	NOT NULL,
        EXENCION_IMP1        		DECIMAL(28,8) 	NOT NULL,
        EXENCION_IMP2        		DECIMAL(28,8) 	NOT NULL,
        COBRO_JUDICIAL       		VARCHAR(1) 	NOT NULL,
        CATEGORIA_CLIENTE    		VARCHAR(8) 	NOT NULL,
        CLASE_ABC            		VARCHAR(1) 	NULL,
        DIAS_ABASTECIMIEN    		smallint 	NOT NULL,
        USA_TARJETA          		VARCHAR(1) 	NOT NULL,
        TARJETA_CREDITO      		VARCHAR(20) 	NULL,
        TIPO_TARJETA         		VARCHAR(12) 	NULL,
        FECHA_VENCE_TARJ     		DATETIME 	NULL,
        E_MAIL               		VARCHAR(249) 	NULL,
        REQUIERE_OC          		VARCHAR(1) 	NOT NULL,
        ES_CORPORACION       		VARCHAR(1) 	NOT NULL,
        CLI_CORPORAC_ASOC    		VARCHAR(20)	NULL,
        REGISTRARDOCSACORP   		VARCHAR(1) 	NOT NULL,
        USAR_DIREMB_CORP     		VARCHAR(1) 	NOT NULL,
        APLICAC_ABIERTAS     		VARCHAR(1) 	NOT NULL,
        VERIF_LIMCRED_CORP   		VARCHAR(1) 	NOT NULL,
        USAR_DESC_CORP       		VARCHAR(1) 	NOT NULL,
        DOC_A_GENERAR        		VARCHAR(1) 	NOT NULL,
        RUBRO1_CLIENTE       		VARCHAR(40)	NULL,
        RUBRO2_CLIENTE       		VARCHAR(40)	NULL,
        RUBRO3_CLIENTE       		VARCHAR(40)	NULL,
        TIENE_CONVENIO       		VARCHAR(1) 	NOT NULL,
        NOTAS                		TEXT 		NULL,
        DIAS_PROMED_ATRASO   		smallint 	NOT NULL,
        RUBRO1_CLI           		VARCHAR(50) 	NULL,
        RUBRO2_CLI           		VARCHAR(50) 	NULL,
        RUBRO3_CLI           		VARCHAR(50) 	NULL,
        RUBRO4_CLI           		VARCHAR(50) 	NULL,
        RUBRO5_CLI           		VARCHAR(50) 	NULL,
        ASOCOBLIGCONTFACT    		VARCHAR(1) 	NOT NULL,
        RUBRO4_CLIENTE       		VARCHAR(40) 	NULL,
        RUBRO5_CLIENTE       		VARCHAR(40) 	NULL,
        RUBRO6_CLIENTE       		VARCHAR(40) 	NULL,
        RUBRO7_CLIENTE       		VARCHAR(40) 	NULL,
        RUBRO8_CLIENTE       		VARCHAR(40) 	NULL,
        RUBRO9_CLIENTE       		VARCHAR(40) 	NULL,
        RUBRO10_CLIENTE      		VARCHAR(40) 	NULL,
        USAR_PRECIOS_CORP    		VARCHAR(1) 	NOT NULL,
        USAR_EXENCIMP_CORP   		VARCHAR(1) 	NOT NULL,
        DIAS_DE_COBRO 	     		VARCHAR(13) 	NULL,
        AJUSTE_FECHA_COBRO   		VARCHAR(1)	NOT NULL,
	GLN 	   	     		VARCHAR(13)	NULL,
	UBICACION  	     		VARCHAR(10)	NULL,
	CLASE_DOCUMENTO      		VARCHAR(1) 	NOT NULL,
	LOCAL                		VARCHAR(1) 	DEFAULT ('L')	NOT NULL,
	TIPO_CONTRIBUYENTE   		VARCHAR(1) 	NULL,
	RUBRO11_CLIENTE      		VARCHAR(40)	NULL,
	RUBRO12_CLIENTE      		VARCHAR(40)	NULL,
	RUBRO13_CLIENTE      		VARCHAR(40)	NULL,
	RUBRO14_CLIENTE      		VARCHAR(40)	NULL,
	RUBRO15_CLIENTE      		VARCHAR(40)	NULL,
	RUBRO16_CLIENTE      		VARCHAR(40)	NULL,
	RUBRO17_CLIENTE      		VARCHAR(40)	NULL,
	RUBRO18_CLIENTE      		VARCHAR(40)	NULL,
	RUBRO19_CLIENTE      		VARCHAR(40)	NULL,
        RUBRO20_CLIENTE      		VARCHAR(40)	NULL,
        MODELO_RETENCION     		VARCHAR(4) 	NULL,
        ACEPTA_DOC_ELECTRONICO		VARCHAR(1)	NOT NULL DEFAULT ('N'),
	CONFIRMA_DOC_ELECTRONICO	VARCHAR(1)	NOT NULL DEFAULT ('N'),
	EMAIL_DOC_ELECTRONICO		VARCHAR(249)	NULL,
	EMAIL_PED_EDI 			VARCHAR(249) 	NULL,
	ACEPTA_DOC_EDI 			VARCHAR(1) 	NOT NULL DEFAULT 'N',
	NOTIFICAR_ERROR_EDI 		VARCHAR(1) 	NOT NULL DEFAULT 'N',
	EMAIL_ERROR_PED_EDI 		VARCHAR(249) 	NULL,
	CODIGO_IMPUESTO                 VARCHAR(4) 	NULL,
	DIVISION_GEOGRAFICA1		VARCHAR(12)	NULL,
	DIVISION_GEOGRAFICA2		VARCHAR(12)	NULL,
	REGIMEN_TRIB			VARCHAR(12)	NULL,
	MOROSO 				VARCHAR(1) 	NOT NULL DEFAULT 'N',
	MODIF_NOMB_EN_FAC 		VARCHAR(1) 	NOT NULL DEFAULT 'N',
	SALDO_TRANS 			DECIMAL(28,8) 	NOT NULL DEFAULT 0,
	SALDO_TRANS_LOCAL 		DECIMAL(28,8) 	NOT NULL DEFAULT 0,
	SALDO_TRANS_DOLAR 		DECIMAL(28,8) 	NOT NULL DEFAULT 0,
	PERMITE_DOC_GP			VARCHAR(1) 	NOT NULL DEFAULT 'N',
	PARTICIPA_FLUJOCAJA		VARCHAR(1)	NOT NULL DEFAULT 'N',
	CURP	 			VARCHAR(18) 	NULL,
	USUARIO_CREACION		VARCHAR(25)	NULL,
	FECHA_HORA_CREACION		DATETIME	NULL,
	USUARIO_ULT_MOD			VARCHAR(25)	NULL,
	FCH_HORA_ULT_MOD		DATETIME	NULL,
	EMAIL_DOC_ELECTRONICO_COPIA	VARCHAR(249) 	NULL,
	DETALLAR_KITS 			VARCHAR(1) 	NOT NULL DEFAULT 'N',
	XSLT_PERSONALIZADO 		VARCHAR(20) 	NULL,
	NOMBRE_ADDENDA 			VARCHAR(20) 	NULL,
	GEO_LATITUD 			DECIMAL(28, 12) NULL,
	GEO_LONGITUD 			DECIMAL(28, 12) NULL,
	DIVISION_GEOGRAFICA3 	VARCHAR(12) NULL,
	DIVISION_GEOGRAFICA4 	VARCHAR(12) NULL,
	OTRAS_SENAS 			VARCHAR(160) NULL,
	SUBTIPODOC 			 	VARCHAR(25) NULL
 )
go
 
 
 ALTER TABLE CLIENTE
        ADD CONSTRAINT CLIENTEPK PRIMARY KEY NONCLUSTERED (CLIENTE)
go


CREATE TABLE CLIENTE_RETENCION (
        CLIENTE     	          VARCHAR(20) NOT NULL,
        CODIGO_RETENCION          VARCHAR(4)  NOT NULL,
        NOTAS                     TEXT        NULL
 )
go

  
 ALTER TABLE CLIENTE_RETENCION
        ADD CONSTRAINT XPKCLIENTE_RETENCI PRIMARY KEY (CLIENTE,CODIGO_RETENCION)
go


 CREATE TABLE CLIENTE_VENDEDOR (
        CLIENTE              VARCHAR(20) NOT NULL,
        VENDEDOR             VARCHAR(4) NOT NULL
 )
go
 
 
 ALTER TABLE CLIENTE_VENDEDOR
        ADD CONSTRAINT CLIENTE_VENDEDORPK PRIMARY KEY NONCLUSTERED (
               CLIENTE, VENDEDOR)
go
 
 
CREATE TABLE CONTACTO_CLIENTE
(
      CLIENTE 		VARCHAR(20) 	NOT NULL,
      CONTACTO 		VARCHAR(20) 	NOT NULL,
      NOMBRE 		VARCHAR(50) 	NOT NULL,
      APELLIDOS 	VARCHAR(50) 	NOT NULL,
      GENERO 		VARCHAR(1) 	NOT NULL,
      CARGO 		VARCHAR(100) 	NOT NULL,
      DEPARTAMENTO 	VARCHAR(100) 	NULL,
      EMAIL 		VARCHAR(100) 	NULL,
      TELEFONO 		VARCHAR(50) 	NULL,
      CELULAR 		VARCHAR(50) 	NULL,
      FAX 		VARCHAR(50) 	NULL,
      NOTAS 		VARCHAR(max) 	NULL
)
go

ALTER TABLE CONTACTO_CLIENTE  
      ADD CONSTRAINT XPKCONTACTOCLIENTE PRIMARY KEY (CLIENTE, CONTACTO)
go      
 
 
 
 CREATE TABLE CONTRARECIBOS_CC (
        CLIENTE              VARCHAR(20) NOT NULL,
        CONTRARECIBO         VARCHAR(50) NOT NULL,
        FECHA_EMISION        DATETIME NOT NULL,
        CONGELADO            VARCHAR(1) NOT NULL,
        CONDICION_PAGO       VARCHAR(4) NOT NULL,
        FECHA_RIGE           DATETIME NOT NULL,
        ESTADO               VARCHAR(1) NOT NULL,
        USUARIO_ULT_MOD      VARCHAR(25) NOT NULL,
        FECHA_ULT_MOD        DATETIME NOT NULL,
        NOTAS                TEXT NULL
 )
go
 
 
 ALTER TABLE CONTRARECIBOS_CC
        ADD CONSTRAINT XPKCONTRARECIBOS_C PRIMARY KEY (CLIENTE, 
               CONTRARECIBO)
go
 
CREATE TABLE  DETALLE_FACTURA_RETENCION(
RETENCION VARCHAR(4),
FACTURA   VARCHAR(50),
TIPO_DOC  VARCHAR(3),
FACTURA_LINEA INT,
ARTICULO  VARCHAR(20),
BASE_RETENCION DECIMAL(28,8),
MONTO_RETENCION DECIMAL(28,8)
)
go


 
CREATE TABLE DET_TIPOSERVICIO_CC(
       DOCUMENTO            VARCHAR(50) 	NOT NULL,
       TIPO                 VARCHAR(3) 	        NOT NULL,
       TIPO_SERVICIO        VARCHAR(10)		NOT NULL,
       CONSECUTIVO	    INT IDENTITY(1,1)	NOT NULL,
       PROYECTO             VARCHAR(25) 	NULL,
       FASE                 VARCHAR(25) 	NULL,
       MONTO_LOCAL	    DECIMAL(28,8) 	NULL,
       MONTO_DOLAR	    DECIMAL(28,8) 	NULL,
       MONTO_CLIENTE	    DECIMAL(28,8) 	NULL,
)
go



ALTER TABLE DET_TIPOSERVICIO_CC ADD CONSTRAINT XPKDET_TIPOSERVICIO_CC 
     		PRIMARY KEY (DOCUMENTO,TIPO,TIPO_SERVICIO,CONSECUTIVO)
go
 
 
  
 CREATE TABLE DIRECC_EMBARQUE (
        CLIENTE              VARCHAR(20) NOT NULL,
        DIRECCION            VARCHAR(8) NOT NULL,
        DETALLE_DIRECCION    int NULL,
        DESCRIPCION          TEXT  NULL,
        CONTACTO             VARCHAR(30) NULL,
        CARGO                VARCHAR(30) NULL,
        TELEFONO1            VARCHAR(15) NULL,
        TELEFONO2            VARCHAR(15) NULL,
        FAX                  VARCHAR(15) NULL,
        EMAIL                VARCHAR(40) NULL
 )
go
 
 
 ALTER TABLE DIRECC_EMBARQUE
        ADD CONSTRAINT DIRECCEMBARQUEPK PRIMARY KEY NONCLUSTERED (
               CLIENTE, DIRECCION)
go
 
 
 CREATE TABLE DOCUMENTO_ASOCIADO (
        TIPO                 VARCHAR(3) NOT NULL,
        TIPO_DOC_ORIGEN      VARCHAR(3) NOT NULL,
        DOCUMENTO            VARCHAR(50) NOT NULL,
        DOC_ORIGEN           VARCHAR(50) NOT NULL,
        CLASE                VARCHAR(1) NOT NULL,
        APROBADO             VARCHAR(1) NOT NULL
 )
go
 
 
 ALTER TABLE DOCUMENTO_ASOCIADO
        ADD CONSTRAINT XPKDOCUMENTO_ASOCIADO PRIMARY KEY (TIPO, 
               TIPO_DOC_ORIGEN, DOCUMENTO, DOC_ORIGEN)
go
 
 
 CREATE TABLE DOCUMENTOS_CC (
        DOCUMENTO            	VARCHAR(50) 	NOT NULL,
        TIPO                 	VARCHAR(3) 	NOT NULL,
        CONTRARECIBO         	VARCHAR(50) 	NULL,
        APLICACION           	VARCHAR(249) 	NOT NULL,
        FECHA_DOCUMENTO      	DATETIME 	NOT NULL,
        FECHA                	DATETIME 	NOT NULL,
        MONTO                	DECIMAL(28,8) 	NOT NULL,
        SALDO                	DECIMAL(28,8) 	NOT NULL,
        MONTO_LOCAL          	DECIMAL(28,8) 	NOT NULL,
        SALDO_LOCAL          	DECIMAL(28,8) 	NOT NULL,
        MONTO_DOLAR          	DECIMAL(28,8) 	NOT NULL,
        SALDO_DOLAR          	DECIMAL(28,8) 	NOT NULL,
        MONTO_CLIENTE        	DECIMAL(28,8) 	NOT NULL,
        SALDO_CLIENTE        	DECIMAL(28,8) 	NOT NULL,
        TIPO_CAMBIO_MONEDA   	DECIMAL(28,8) 	NOT NULL,
        TIPO_CAMBIO_DOLAR    	DECIMAL(28,8) 	NOT NULL,
        TIPO_CAMBIO_CLIENT   	DECIMAL(28,8) 	NOT NULL,
        TIPO_CAMB_ACT_LOC    	DECIMAL(28,8) 	NOT NULL,
        TIPO_CAMB_ACT_DOL    	DECIMAL(28,8) 	NOT NULL,
        TIPO_CAMB_ACT_CLI    	DECIMAL(28,8) 	NOT NULL,
        SUBTOTAL             	DECIMAL(28,8) 	NOT NULL,
        DESCUENTO            	DECIMAL(28,8) 	NOT NULL,
        IMPUESTO1            	DECIMAL(28,8) 	NOT NULL,
        IMPUESTO2            	DECIMAL(28,8) 	NOT NULL,
        RUBRO1               	DECIMAL(28,8) 	NOT NULL,
        RUBRO2               	DECIMAL(28,8) 	NOT NULL,
        MONTO_RETENCION      	DECIMAL(28,8) 	NOT NULL,
        SALDO_RETENCION      	DECIMAL(28,8) 	NOT NULL,
        DEPENDIENTE          	VARCHAR(1) 	NOT NULL,
        FECHA_ULT_CREDITO    	DATETIME 	NOT NULL,
        CARGADO_DE_FACT      	VARCHAR(1) 	NOT NULL,
        APROBADO             	VARCHAR(1) 	NOT NULL,
        ASIENTO              	VARCHAR(10) 	NULL,
        ASIENTO_PENDIENTE    	VARCHAR(1) 	NOT NULL,
        FECHA_ULT_MOD        	DATETIME 	NOT NULL,
        NOTAS                	TEXT 		NULL,
        CLASE_DOCUMENTO      	VARCHAR(1) 	NOT NULL,
        FECHA_VENCE          	DATETIME 	NOT NULL,
        NUM_PARCIALIDADES    	smallint 	NOT NULL,
        FECHA_REVISION       	DATETIME 	NULL,
        COBRADOR             	VARCHAR(4) 	NULL,
        USUARIO_ULT_MOD      	VARCHAR(25) 	NOT NULL,
        CONDICION_PAGO       	VARCHAR(4) 	NOT NULL,
        MONEDA               	VARCHAR(4) 	NOT NULL,
        CTA_BANCARIA         	VARCHAR(20) 	NULL,
        VENDEDOR             	VARCHAR(4) 	NULL,
        CLIENTE_REPORTE      	VARCHAR(20) 	NOT NULL,
        CLIENTE_ORIGEN       	VARCHAR(20) 	NOT NULL,
        CLIENTE              	VARCHAR(20) 	NOT NULL,
        SUBTIPO              	smallint 	NULL,
        PORC_INTCTE          	DECIMAL(28,8) 	NOT NULL,
	CONTRATO             	VARCHAR(20)	NULL,
	TIPO_DOC_ORIGEN      	VARCHAR(3)  	NULL,
	DOC_DOC_ORIGEN       	VARCHAR(50) 	NULL,
	FECHA_ANUL           	DATETIME    	NULL,
	AUD_USUARIO_ANUL     	VARCHAR(25) 	NULL,
	AUD_FECHA_ANUL	     	DATETIME    	NULL,
	NUM_DOC_CB	     	decimal(28,0)	NULL,
	FECHA_COBRO	     	DATETIME 	NULL,
	AUDITORIA_COBRO	     	VARCHAR(80) 	NULL,
	FECHA_SEGUIMIENTO    	DATETIME 	NULL,
	OBSERVACIONES_COBRO  	VARCHAR(249) 	NULL,
	USUARIO_APROBACION   	VARCHAR(25)  	NULL,
	FECHA_APROBACION     	DATETIME    	NULL,
	ANULADO 	     	VARCHAR(1) 	NULL,
	CODIGO_IMPUESTO      	VARCHAR(4)      NULL,
	PAIS		     	VARCHAR(4) 	NULL,
	DIVISION_GEOGRAFICA1 	VARCHAR(12)	NULL,
	DIVISION_GEOGRAFICA2 	VARCHAR(12)	NULL,
	BASE_IMPUESTO1	     	DECIMAL(28,8) 	NULL,
	BASE_IMPUESTO2	     	DECIMAL(28,8) 	NULL,
	DEPENDIENTE_GP		VARCHAR(1) 	DEFAULT 'N' 	NOT NULL,
	SALDO_TRANS 		DECIMAL(28,8) 	DEFAULT 0 	NOT NULL,
	SALDO_TRANS_LOCAL 	DECIMAL(28,8) 	DEFAULT 0 	NOT NULL,
	SALDO_TRANS_DOLAR 	DECIMAL(28,8) 	DEFAULT 0 	NOT NULL,
	FECHA_PROYECTADA	DATETIME 	NULL,
	PORC_RECUPERACION	DECIMAL(28,8)	NULL,
	TIPO_ASIENTO 		VARCHAR(4)  	NULL,
	PAQUETE 		VARCHAR(4)  	NULL,
	SALDO_TRANS_CLI         DECIMAL(28,8)   DEFAULT 0   	NOT NULL,
	DOCUMENTO_FISCAL 	VARCHAR(50) 	NULL,
	FACTURADO 		VARCHAR(1) 	DEFAULT 'N' 	NOT NULL,
	GENERA_DOC_FE 		VARCHAR(1) 	DEFAULT 'N' 	NOT NULL,
	TASA_IMPOSITIVA 	VARCHAR(4) 	NULL,
	TASA_IMPOSITIVA_PORC 	DECIMAL(28, 8) 	NULL,
	TASA_CREE1 		VARCHAR(4) 	NULL,
	TASA_CREE1_PORC 	DECIMAL(28, 8) 	NULL,
	TASA_CREE2 		VARCHAR(4) 	NULL,
	TASA_CREE2_PORC 	DECIMAL(28, 8) 	NULL,
	TASA_GAN_OCASIONAL_PORC DECIMAL(28, 8) 	NULL,
	ENTIDAD_FINANCIERA 	VARCHAR(8) 	NULL,
	CONTRATO_AC 		VARCHAR(10) 	NULL,
	DOCUMENTO_GLOBAL 	VARCHAR(50) 	NULL,
	CUENTA_ORIGEN VARCHAR(20) NULL,
	USO_CFDI	  VARCHAR(3) NULL,
	U_CLAVE_UNIDAD VARCHAR(20) NULL,
	U_CLAVE_PROD_SERV VARCHAR(200) NULL,
	FORMA_PAGO VARCHAR(3) NULL,
	U_TIPO_RELACION VARCHAR(200) NULL,
	CLAVE_REFERENCIA_DE VARCHAR(50) NULL,
	FECHA_REFERENCIA_DE DATETIME NULL,
	JUSTI_DEV_HACIEND VARCHAR(2) NULL,
	INCOTERMS VARCHAR(3) NULL, 
	CONSECUTIVO VARCHAR(10) NULL
 )
go
 
 
 ALTER TABLE DOCUMENTOS_CC
        ADD CONSTRAINT DOCUMENTOS_CCPK PRIMARY KEY NONCLUSTERED (
               DOCUMENTO, TIPO)
go
 
CREATE TABLE FIADORES_DOC_CC (
        FIADOR_ID        	VARCHAR(20)   NOT NULL,
	DOCUMENTO		VARCHAR(50)   NOT NULL,
	TIPO			VARCHAR(3)    NOT NULL,
	NOMBRE_FIADOR		VARCHAR(80)   NOT NULL,
	OCUPAC_FIADOR  		VARCHAR(30)   NULL,
	TIPO_FIADOR 		VARCHAR(20)   NULL,
	DIREC_FIADOR 		VARCHAR(80)   NULL,
	TEL_DOM_FIADOR 		VARCHAR(10)   NULL,
	LUG_TRAB_FIADOR 	VARCHAR(80)   NULL,
	DIR_TRAB_FIADOR  	VARCHAR(80)   NULL,
	TEL_TRAB_FIADOR 	VARCHAR(10)   NULL,
	CONTRATO_FIADOR  	VARCHAR(20)   NULL,
	OBS_FIADOR   		VARCHAR(200)  NULL)
go


ALTER TABLE FIADORES_DOC_CC 
         ADD CONSTRAINT XPKFIADOR PRIMARY KEY NONCLUSTERED 
         (FIADOR_ID,DOCUMENTO,TIPO)
go         
  
  
CREATE TABLE GARANTIAS_DOC_CC (
	GARANTIA_ID		VARCHAR(20)   NOT NULL,
	DOCUMENTO		VARCHAR(50)   NOT NULL,
	TIPO			VARCHAR(3)    NOT NULL,
	TIPO_GARANTIA		VARCHAR(20)   NULL,
	DESC_GARANTIA		VARCHAR(40)   NULL,
	OBS_GARANTIA		VARCHAR(200)  NULL,
	ART_GARANTIA		VARCHAR(20)   NULL)
go


ALTER TABLE GARANTIAS_DOC_CC 
         ADD CONSTRAINT XPKGARANTIA PRIMARY KEY NONCLUSTERED
         (GARANTIA_ID,DOCUMENTO,TIPO)
go         
         
 CREATE TABLE GLOBALES_CC (
        ULT_NOTA_CREDITO     VARCHAR(20) 	NULL,
        ULT_NOTA_DEBITO      VARCHAR(20) 	NULL,
        ULT_INTERES_MORA     VARCHAR(20) 	NULL,
        ULT_RECIBO_DINERO    VARCHAR(20) 	NULL,
        ULT_FACTURA          VARCHAR(20) 	NULL,
        ULT_OTRO_CREDITO     VARCHAR(20) 	NULL,
        ULT_OTRO_DEBITO      VARCHAR(20) 	NULL,
        ULT_RETENCION        VARCHAR(50) 	NULL,
        FECHA_ULT_COMPRIME   DATETIME 		NOT NULL,
        LIMPIAR_APLICACION   VARCHAR(1) 	NOT NULL,
        INTRO_FACTURAS       VARCHAR(1) 	NOT NULL,
        TIPO_ASIENTO_DEB     VARCHAR(4) 	NULL,
        PAQUETE_DEB          VARCHAR(4) 	NULL,
        TIPO_ASIENTO_CRE     VARCHAR(4) 	NULL,
        PAQUETE_CRE          VARCHAR(4) 	NULL,
        VENC_PERIODO1        smallint 		NULL,
        VENC_PERIODO2        smallint 		NULL,
        VENC_PERIODO3        smallint 		NULL,
        VENC_PERIODO4        smallint 		NULL,
        ANT_PERIODO1         smallint 		NULL,
        ANT_PERIODO2         smallint 		NULL,
        ANT_PERIODO3         smallint 		NULL,
        ANT_PERIODO4         smallint 		NULL,
        ASIENTO_FAC          VARCHAR(1) 	NOT NULL,
        ASIENTO_INT          VARCHAR(1) 	NOT NULL,
        ASIENTO_ND           VARCHAR(1) 	NOT NULL,
        ASIENTO_OD           VARCHAR(1) 	NOT NULL,
        ASIENTO_LC           VARCHAR(1) 	NOT NULL,
        ASIENTO_REC          VARCHAR(1) 	NOT NULL,
        ASIENTO_NC           VARCHAR(1) 	NOT NULL,
        ASIENTO_OC           VARCHAR(1) 	NOT NULL,
        ASIENTO_DEP          VARCHAR(1) 	NOT NULL,
        ASIENTO_TEF          VARCHAR(1) 	NOT NULL,
        ASIENTOS_CTA_PAIS    VARCHAR(1) 	NOT NULL,
        TIPO_CONTA_OMISION   VARCHAR(1) 	NOT NULL,
        INTEGRACION_CONTA    VARCHAR(1) 	NOT NULL,
        MOD_APLIC_ASIENTO    smallint 		NOT NULL,
        NIT_DUPLICADO        VARCHAR(1) 	NOT NULL,
        REFRESCA_AUTO        VARCHAR(1) 	NOT NULL,
        DOC_PRONTO_PAGO      VARCHAR(3) 	NOT NULL,
        DETALLE_OBLIGAT      VARCHAR(1) 	NOT NULL,
        USAR_RUBROS          VARCHAR(1) 	NOT NULL,
        RUBRO1_NOMBRE        VARCHAR(15)	NULL,
        RUBRO2_NOMBRE        VARCHAR(15)	NULL,
        IMPUESTO_X_OMISION   VARCHAR(4) 	NULL,
        USAR_RUBROS_CLI      VARCHAR(1) 	NOT NULL,
        RUBRO1_CLI_NOMBRE    VARCHAR(15)	NULL,
        RUBRO2_CLI_NOMBRE    VARCHAR(15)	NULL,
        RUBRO3_CLI_NOMBRE    VARCHAR(15)	NULL,
        RUBRO4_CLI_NOMBRE    VARCHAR(15)	NULL,
        RUBRO5_CLI_NOMBRE    VARCHAR(15)	NULL,
        COPIARNOTASENASNT    VARCHAR(1) 	NOT NULL,
        ASOCOBLIGCONTFACT    VARCHAR(1) 	NOT NULL,
        VENC_PERIODO5        smallint 		NULL,
        VENC_PERIODO6        smallint 		NULL,
        ANT_PERIODO5         smallint 		NULL,
        ANT_PERIODO6         smallint 		NULL,
        ASOCIACION_DE_DOCS   VARCHAR(1) 	NOT NULL,
        NOM_RUBRO1_CLI       VARCHAR(60)	NULL,
        NOM_RUBRO2_CLI       VARCHAR(60)	NULL,
        NOM_RUBRO3_CLI       VARCHAR(60)	NULL,
        NOM_RUBRO4_CLI       VARCHAR(60)	NULL,
        NOM_RUBRO5_CLI       VARCHAR(60)	NULL,
        USAR_RUBROS_VAL      VARCHAR(1) 	NOT NULL,
        FORMA_CREACION       VARCHAR(1) 	NOT NULL,
        RUBROS_DIAS_REV      smallint 		NULL,
        ASIENTO_INTC         VARCHAR(1) 	NOT NULL,
	ULT_INTERES_CTE      VARCHAR(20)	NULL,
	FECHA_ULT_DIFCAMB    DATETIME 		NOT NULL,
	ULT_LETRACAMBIO	     VARCHAR(20)	NULL,
	ULT_DEPOSITO	     VARCHAR(20)	NULL,
	ULT_TEF	      	     VARCHAR(20)	NULL,
	ULT_RETDEBITO 	     VARCHAR(50)	NULL,
	NOM_RUBRO11_CLI      VARCHAR(60) 	NULL,
	NOM_RUBRO12_CLI      VARCHAR(60) 	NULL,
       	NOM_RUBRO13_CLI      VARCHAR(60) 	NULL,
       	NOM_RUBRO14_CLI      VARCHAR(60) 	NULL,
       	NOM_RUBRO15_CLI      VARCHAR(60) 	NULL	
 )
go
 

CREATE TABLE HIST_DIFCAM_CC(
        usuario_auditoria 	VARCHAR(25)	NOT NULL,
	fecha_auditoria 	DATETIME        NOT NULL,
	fecha_proc		DATETIME        NOT NULL,
	documento		VARCHAR(50)	NOT NULL,
	tipo			VARCHAR(3)	NOT NULL,
	tipo_cambio_proc	DECIMAL(28,8) 	NOT NULL,
	asiento_proc		VARCHAR(10)	NULL,
	dif_cam_local		DECIMAL(28,8) 	NOT NULL,
	dif_cam_dolar		DECIMAL(28,8) 	NOT NULL,
	tcamb_loc_doc_ant	DECIMAL(28,8) 	NOT NULL,
	tcamb_dol_doc_ant	DECIMAL(28,8) 	NOT NULL,
	tcamb_loc_doc_act	DECIMAL(28,8) 	NOT NULL,
	tcamb_dol_doc_act	DECIMAL(28,8) 	NOT NULL,
	cuenta_contable		VARCHAR(25)	NULL,
	centro_costo		VARCHAR(25)	NULL,
	estado			VARCHAR(1)	NOT NULL,
	notas_rev    		TEXT 		NULL,
	id_hist 		uniqueidentifier NOT NULL)
go


ALTER TABLE HIST_DIFCAM_CC 
	ADD CONSTRAINT IDDEF_HISTDCCC   
		DEFAULT (NEWID()) FOR [ID_HIST]
go		


ALTER TABLE HIST_DIFCAM_CC
         ADD CONSTRAINT HISTDFCCPK PRIMARY KEY NONCLUSTERED (Id_hist)
go         


 
 CREATE TABLE PARCIALIDADES_CC (
        TIPO_DOC_ORIGEN      		VARCHAR(3) 	NOT NULL,
        DOCUMENTO_ORIGEN     		VARCHAR(50) 	NOT NULL,
        PARCIALIDAD          		smallint 	NOT NULL,
        FECHA_RIGE           		DATETIME 	NOT NULL,
        FECHA_VENCE          		DATETIME 	NOT NULL,
        PORCENTAJE           		Decimal(28,8) 	NOT NULL,
        SALDO                		DECIMAL(28,8) 	NOT NULL,
        SALDO_LOCAL          		DECIMAL(28,8) 	NOT NULL,
        SALDO_DOLAR          		DECIMAL(28,8) 	NOT NULL,
        MONTO_PRINCIPAL      		DECIMAL(28,8) 	NULL,
	MONTO_PRINCIPAL_LOC  		DECIMAL(28,8) 	NULL,
	MONTO_PRINCIPAL_DOL  		DECIMAL(28,8) 	NULL,
	MONTO_AMORTIZA	     		DECIMAL(28,8) 	NULL,
	MONTO_AMORTIZA_LOC   		DECIMAL(28,8) 	NULL,
	MONTO_AMORTIZA_DOL   		DECIMAL(28,8) 	NULL,
	SALDO_AMORTIZA	     		DECIMAL(28,8) 	NULL,
	SALDO_AMORTIZA_LOC   		DECIMAL(28,8) 	NULL,
	SALDO_AMORTIZA_DOL   		DECIMAL(28,8) 	NULL,
	MONTO_INTERES	     		DECIMAL(28,8) 	NULL,
	MONTO_INTERES_LOC    		DECIMAL(28,8) 	NULL,
	MONTO_INTERES_DOL    		DECIMAL(28,8) 	NULL,
	SALDO_INTERES	     		DECIMAL(28,8) 	NULL,
	SALDO_INTERES_LOC    		DECIMAL(28,8) 	NULL,
	SALDO_INTERES_DOL    		DECIMAL(28,8) 	NULL,
	MONTO_CUOTA	     		DECIMAL(28,8) 	NULL,
	MONTO_CUOTA_LOC	     		DECIMAL(28,8) 	NULL,
	MONTO_CUOTA_DOL	     		DECIMAL(28,8) 	NULL,
	SALDO_CUOTA	     		DECIMAL(28,8) 	NULL,
	SALDO_CUOTA_LOC	     		DECIMAL(28,8) 	NULL,
	SALDO_CUOTA_DOL	     		DECIMAL(28,8) 	NULL,
	SALDO_PRINCIPAL	     		DECIMAL(28,8) 	NULL,
	SALDO_PRINCIPAL_LOC  		DECIMAL(28,8) 	NULL,
	SALDO_PRINCIPAL_DOL  		DECIMAL(28,8) 	NULL,
	FECHA_PROYECTADA     		DATETIME      	NULL,
	MONTO_IMP_RENTA 		DECIMAL(28, 8) 	NULL,
	MONTO_IMP_RENTA_LOCAL 		DECIMAL(28, 8) 	NULL,
	MONTO_IMP_RENTA_DOLAR 		DECIMAL(28, 8) 	NULL,
	MONTO_IMP_CREE1 		DECIMAL(28, 8) 	NULL,
	MONTO_IMP_CREE1_LOCAL 		DECIMAL(28, 8) 	NULL,
	MONTO_IMP_CREE1_DOLAR 		DECIMAL(28, 8) 	NULL,
	MONTO_IMP_CREE2 		DECIMAL(28, 8) 	NULL,
	MONTO_IMP_CREE2_LOCAL 		DECIMAL(28, 8) 	NULL,
	MONTO_IMP_CREE2_DOLAR 		DECIMAL(28, 8) 	NULL,
	MONTO_GAN_OCASIONAL 		DECIMAL(28, 8) 	NULL,
	MONTO_GAN_OCASIONAL_LOCAL 	DECIMAL(28, 8) 	NULL,
	MONTO_GAN_OCASIONAL_DOLAR 	DECIMAL(28, 8) 	NULL
 )
go
 
 
 ALTER TABLE PARCIALIDADES_CC
        ADD CONSTRAINT XPKPARCIALIDADES_CC PRIMARY KEY (
               TIPO_DOC_ORIGEN, DOCUMENTO_ORIGEN, PARCIALIDAD)
go
 
 
CREATE TABLE $$COMPANIA$$.REPORTES_CC (
    	REPORTE			VARCHAR(30) 	NULL,
    	CLIENTE			VARCHAR(20) 	NULL, 
	DOCUMENTO		VARCHAR(50) 	NULL, 
	TIPO			VARCHAR(3) 	NULL, 
    	CLIENTE_ORIGEN		VARCHAR(20) 	NULL, 
	MONEDA			VARCHAR(4) 	NULL,
	FECHA			DATETIME 	NULL, 
	FECHA_DOCUMENTO		DATETIME 	NULL, 
	FECHA_VENCE		DATETIME 	NULL,	
	TIPO_CAMB_ACT_LOC	DECIMAL(28,8) 	NULL,
	TIPO_CAMB_ACT_DOL	DECIMAL(28,8) 	NULL,  
	TIPO_CAMB_ACT_CLI	DECIMAL(28,8) 	NULL, 
	CONTRARECIBO		VARCHAR(50) 	NULL, 
	ASIENTO			VARCHAR(10) 	NULL, 
	CONDICION_PAGO		VARCHAR(10) 	NULL, 
	VENDEDOR		VARCHAR(4) 	NULL,
	COBRADOR		VARCHAR(4) 	NULL, 
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
	TIPO_CONDPAGO		VARCHAR(2) 	NULL,
	NUM_PARCIALIDADES	SMALLINT 	NULL,
	PARCIALIDAD		SMALLINT 	NULL,
	PAR_MONTO_PRINCIPAL	DECIMAL(28,8) 	NULL,
	PAR_MONTO_AMORTIZA	DECIMAL(28,8) 	NULL,
	PAR_SALDO_AMORTIZA	DECIMAL(28,8) 	NULL,
	PAR_MONTO_INTERES	DECIMAL(28,8) 	NULL,
	PAR_SALDO_INTERES	DECIMAL(28,8) 	NULL,
	PAR_MONTO_CUOTA		DECIMAL(28,8) 	NULL,
	PAR_SALDO_CUOTA		DECIMAL(28,8) 	NULL,
	PAR_SALDO_PRINCIPAL	DECIMAL(28,8) 	NULL,
	MONTO_DOC		DECIMAL(28,8) 	NULL,
	MONTO_CLI		DECIMAL(28,8) 	NULL,
	MONTO_LOCAL 		DECIMAL(28,8) 	NULL,
	MONTO_DOLAR 		DECIMAL(28,8)  	NULL,
	SALDO_CLI		DECIMAL(28,8)  	NULL,
	SALDO_LOCAL 		DECIMAL(28,8)  	NULL,
	SALDO_DOLAR 		DECIMAL(28,8)  	NULL,
	SALDO_RANGO0		DECIMAL(28,8)  	NULL,
	SALDO_RANGO1		DECIMAL(28,8)  	NULL,
	SALDO_RANGO2		DECIMAL(28,8)  	NULL,
	SALDO_RANGO3		DECIMAL(28,8)  	NULL,
	SALDO_RANGO4		DECIMAL(28,8)  	NULL,
	SALDO_RANGO5		DECIMAL(28,8)  	NULL,
	SALDO_RANGO6		DECIMAL(28,8)  	NULL,
	SALDO_RANGO7		DECIMAL(28,8)  	NULL
 )
 go
 
 
 CREATE TABLE RETENCIONES_DOC_CC (
        TIPO                 VARCHAR(3) 	NOT NULL,
        DOCUMENTO            VARCHAR(50)	NOT NULL,
        CODIGO_RETENCION     VARCHAR(4) 	NOT NULL,
        RETENCION            VARCHAR(50) 	NULL,
        DOC_REFERENCIA       VARCHAR(20) 	NOT NULL,
        MONTO                DECIMAL(28,8) 	NOT NULL,
        ESTADO               VARCHAR(1) 	NOT NULL,
        BASE		     	 DECIMAL(28,8)	NULL,
		AUTORETENEDORA	     VARCHAR(1) 	DEFAULT ('N')	NULL,
		ASIENTO 	     	 VARCHAR(10) 	NULL,
		FECHA_DOCUMENTO		 DATETIME 		NULL,
		FECHA_RIGE 			 DATETIME 		NULL,
		FECHA_CONTABLE 		 DATETIME 		NULL
 )
go
 
 
 ALTER TABLE RETENCIONES_DOC_CC
        ADD CONSTRAINT XPKRETENCIONES_CC PRIMARY KEY (TIPO, DOCUMENTO, 
               CODIGO_RETENCION)
go
 
 
 CREATE TABLE SALDO_CLIENTE (
        CLIENTE              VARCHAR(20) 	NOT NULL,
        MONEDA               VARCHAR(4) 	NOT NULL,
        SALDO                DECIMAL(28,8) 	NOT NULL,
        SALDO_CORPORACION    DECIMAL(28,8) 	NOT NULL,
        SALDO_SUCURSALES     DECIMAL(28,8) 	NOT NULL,
        FECHA_ULT_MOV        DATETIME 		NOT NULL
 )
go
 
 
 ALTER TABLE SALDO_CLIENTE
        ADD CONSTRAINT XPKSALDO_CLIENTE PRIMARY KEY (CLIENTE, MONEDA)
go
 
 
 CREATE TABLE SUBTIPO_DOC_CC (
        TIPO                 	VARCHAR(3) 	NOT NULL,
        SUBTIPO              	smallint 	NOT NULL,
        TIPO_CB              	VARCHAR(3) 	NULL,
        SUBTIPO_CB           	smallint 	NULL,
        DESCRIPCION          	VARCHAR(25) NOT NULL,
        CUENTA_CONTABLE      	VARCHAR(25) NULL,
        CENTRO_COSTO         	VARCHAR(25) NULL,
        CALCULA_IMP2 	     	VARCHAR(1) 	NOT NULL DEFAULT 'S',
        TIPO_ASIENTO 			VARCHAR(4) 	NULL,
		PAQUETE 				VARCHAR(4) 	NULL,
		TIPO_SERVICIO 			VARCHAR(2) 	NULL,
		DOCUMENTO_GLOBAL 		VARCHAR(10) NULL,
		U_CONCEPTO_NC 			VARCHAR(4) NULL, 
		U_CONCEPTO_FAC 			VARCHAR(4) NULL, 
		U_CONCEPTO_ND 			VARCHAR(4) NULL
 )
go
 
 
 ALTER TABLE SUBTIPO_DOC_CC
        ADD CONSTRAINT XPKSUBTIPO_DOC_CC PRIMARY KEY (TIPO, SUBTIPO)
go
 
 
 CREATE TABLE TEXTOS_DOCS_CC (
        TIPO            VARCHAR(3) 	NOT NULL,
        DOCUMENTO       VARCHAR(50) 	NOT NULL,
        TEXTO_ID        VARCHAR(18) 	NOT NULL,
        TEXTO           TEXT 		null,
        RECIBIDO_DE  	VARCHAR(80)     NULL,
        MONTO_CHK  	DECIMAL(28,8)   NULL,
        MONTO_TEF  	DECIMAL(28,8)   NULL,
        MONTO_OTROS  	DECIMAL(28,8)   NULL,
        MONTO_EFECTIVO 	DECIMAL(28,8)   NULL,
        DOC_CHK  	VARCHAR(50)     NULL,
        DOC_TEF  	VARCHAR(50)     NULL,
        DOC_OTROS  	VARCHAR(50)     NULL           
 )
go
 
 
 ALTER TABLE TEXTOS_DOCS_CC
        ADD CONSTRAINT XPKTEXTOS_DOCS_CC PRIMARY KEY (TIPO, DOCUMENTO, 
               TEXTO_ID)
go
 
 
CREATE TABLE TIPO_SERVICIO_CC(
       TIPO_SERVICIO	    VARCHAR(10) 	NOT NULL,
       DESCRIPCION          VARCHAR(249) 	NULL,
       CENTRO_COSTO         VARCHAR(25)		NULL,
       CUENTA_CONTABLE      VARCHAR(25) 	NULL
)
go


ALTER TABLE TIPO_SERVICIO_CC ADD CONSTRAINT XPKTIPO_SERVICIO_CC PRIMARY KEY (TIPO_SERVICIO)
go
 
CREATE TABLE USO_CFDI(	
USO_CFDI VARCHAR(3) NOT NULL,
DESCRIPCION VARCHAR(150) NULL,
TIPO_PERSONA_FISICA VARCHAR(1) NULL,
TIPO_PERSONA_MORAL	VARCHAR(1) NULL
)
go