CREATE TABLE FORMATO_PLANIFICACION(
	PLANIFICADOR				VARCHAR(10) NOT NULL,
	DESCRIPCION				VARCHAR(50) NULL,
	CONJUNTO				VARCHAR(10) NOT NULL,
	TIPO_PERIODO				VARCHAR(1) NOT NULL DEFAULT ('M'),
	FECHA_TRANSACCIONES			DATETIME NULL,
	BASE_SUGERENCIA				VARCHAR(1) NOT NULL DEFAULT ('M'),
	MOVIMIENTOS				VARCHAR(1) NOT NULL DEFAULT ('V'),
	TIEMPO_REAPROVISIONAMIENTO		INT NOT NULL,
	FRECUENCIA_PEDIDO			INT NOT NULL,
	INVENTARIO_SEGURIDAD			INT NOT NULL,
	CANTIDAD_PERIODOS			INT NOT NULL,
	ARTIC_CON_MOVIMIENTOS			VARCHAR(1) NOT NULL DEFAULT ('N'),
	DESPLEGAR_SIN_SUGERENCIA		VARCHAR(1) NOT NULL DEFAULT ('N'),
	SOLO_CON_EXISTENCIA			VARCHAR(1) NOT NULL DEFAULT ('N'),
	FECHA_BASE				VARCHAR(1) NOT NULL DEFAULT ('A'),
	CALCULAR_HASTA				VARCHAR(1) NOT NULL DEFAULT ('P'),
	COSTO					VARCHAR(1) NOT NULL DEFAULT ('F'),
	MONEDA					VARCHAR(1) NOT NULL DEFAULT ('L'),
	INCLUIR_CANT_TRANS			VARCHAR(1) NOT NULL DEFAULT ('S'),
	BODEGA_DESDE				VARCHAR(4) NULL,
	BODEGA_DESDE_DESC			VARCHAR(40) NULL,
	BODEGA_HASTA				VARCHAR(4) NULL,
	BODEGA_HASTA_DESC			VARCHAR(40) NULL,
	ESTADO					VARCHAR(1) NOT NULL DEFAULT ('N'),
	PERIODO_LEAD_TIME			VARCHAR(1) NOT NULL DEFAULT ('T'),
	ARTICULO_DESDE				VARCHAR(20) NULL,
	ARTICULO_DESDE_DESC			VARCHAR(254) NULL,
	ARTICULO_HASTA				VARCHAR(20) NULL,
	ARTICULO_HASTA_DESC			VARCHAR(254) NULL,
	PRONOSTICO_VENTAS			VARCHAR(20) NULL,
	PRONOSTICO_VENTAS_DESC			VARCHAR(40) NULL,
	GENERACION				VARCHAR(1) NOT NULL DEFAULT ('S'),
	TIPO_GRAFICO				VARCHAR(1) NOT NULL DEFAULT ('B'),
	SUGERIDO_EN_CERO			VARCHAR(1) NOT NULL DEFAULT ('N'),
	 PROVEEDOR_DESDE 		VARCHAR(20) NULL,
 PROVEEDOR_HASTA 		VARCHAR(20) NULL,
 PROVEEDOR_DESDE_DESC VARCHAR(254) NULL,
 PROVEEDOR_HASTA_DESC VARCHAR(254) NULL,
 CLASIFICACION_1_DESDE VARCHAR(12) NULL,
 CLASIFICACION_1_HASTA VARCHAR(12) NULL,
 CLASIFICACION_2_DESDE VARCHAR(12) NULL,
 CLASIFICACION_2_HASTA VARCHAR(12) NULL,
 CLASIFICACION_3_DESDE VARCHAR(12) NULL,
 CLASIFICACION_3_HASTA VARCHAR(12) NULL,
 CLASIFICACION_4_DESDE VARCHAR(12) NULL,
 CLASIFICACION_4_HASTA VARCHAR(12) NULL,
 CLASIFICACION_5_DESDE VARCHAR(12) NULL,
 CLASIFICACION_5_HASTA VARCHAR(12) NULL,
 CLASIFICACION_6_DESDE VARCHAR(12) NULL,
 CLASIFICACION_6_HASTA VARCHAR(12) NULL
)
go


ALTER TABLE FORMATO_PLANIFICACION  
	ADD CONSTRAINT PK_FORMATO_PLANIFICACION PRIMARY KEY NONCLUSTERED (PLANIFICADOR)
go



CREATE TABLE SP_ARTICULO(
	ARTICULO 		VARCHAR(20) NOT NULL,
	DESCRIPCION 		VARCHAR(254) NOT NULL,
	CLASIFICACION_1 	VARCHAR(12) NULL,
	CLASIFICACION_2 	VARCHAR(12) NULL,
	CLASIFICACION_3 	VARCHAR(12) NULL,
	CLASIFICACION_4 	VARCHAR(12) NULL,
	CLASIFICACION_5 	VARCHAR(12) NULL,
	CLASIFICACION_6 	VARCHAR(12) NULL,
	TIPO 			VARCHAR(1) NOT NULL,
	IMPUESTO 		VARCHAR(4) NOT NULL,
	EXISTENCIA_MINIMA 	DECIMAL(28, 8) NOT NULL,
	EXISTENCIA_MAXIMA 	DECIMAL(28, 8) NOT NULL,
	PUNTO_DE_REORDEN 	DECIMAL(28, 8) NOT NULL,
	COSTO_PROM_LOC 		DECIMAL(28, 8) NOT NULL,
	COSTO_PROM_DOL 		DECIMAL(28, 8) NOT NULL,
	CLASE_ABC 		VARCHAR(1) NOT NULL,
	FRECUENCIA_CONTEO 	SMALLINT NOT NULL,
	ACTIVO 			VARCHAR(1) NOT NULL,
	PROVEEDOR 		VARCHAR(20) NULL,
	UNIDAD_ALMACEN 		VARCHAR(6) NOT NULL,
	UNIDAD_EMPAQUE 		VARCHAR(6) NOT NULL,
	 ULTIMO_INGRESO  	DATETIME 	 NULL,
	 ARTICULO_DEL_PROV VARCHAR(30) NULL,
	 LOTE_MULTIPLO  	DECIMAL(28,8)  NULL,
	 ORDEN_MINIMA  	DECIMAL(28,8) 	 NULL,
	 PLAZO_REABAST  	smallint  NULL,
	 COSTO_FISCAL 		VARCHAR(1) NULL,
	 COSTO_COMPARATIVO VARCHAR(1) NULL,
	 FACTOR_EMPAQUE 	DECIMAL(28,8)  NULL
)
go
	
	
	
CREATE TABLE SP_ARTICULO_PROVEEDOR(
	ARTICULO 		VARCHAR(20) NOT NULL,
	PROVEEDOR 		VARCHAR(20) NOT NULL,
	CODIGO_CATALOGO	 	VARCHAR(20) NULL,
	LOTE_MINIMO 		DECIMAL(28, 8) NOT NULL,
	LOTE_ESTANDAR 		DECIMAL(28, 8) NOT NULL,
	PESO_MINIMO_ORDEN 	DECIMAL(28, 8) NOT NULL,
	MULTIPLO_COMPRA 	DECIMAL(28, 8) NOT NULL,
	CANT_ECONOMICA_COM 	DECIMAL(28, 8) NOT NULL,
	UNIDAD_MEDIDA_COMP 	VARCHAR(10) NOT NULL,
	FACTOR_CONVERSION 	DECIMAL(28, 8) NOT NULL,
	PLAZO_REABASTECIMI 	SMALLINT NOT NULL,
	PORC_AJUSTE_COSTO 	DECIMAL(28, 8) NOT NULL,
	FECHA_ULT_COTIZACI 	DATETIME NULL,
	NOTAS 			TEXT NULL,
	DESCRIP_CATALOGO 	VARCHAR(254) NULL,
	PAIS VARCHAR(4) 	NOT NULL DEFAULT ('ND'),
	TIPO VARCHAR(1) 	NOT NULL DEFAULT ('P')
)
go



CREATE TABLE SP_FACTURA_LINEA(
	FACTURA 		VARCHAR(50) NOT NULL,
	TIPO_DOCUMENTO 		VARCHAR(1) NOT NULL,
	LINEA 			SMALLINT NOT NULL,
	BODEGA 			VARCHAR(4) NOT NULL,
	COSTO_TOTAL_DOLAR 	DECIMAL(28, 8) NOT NULL,
	PEDIDO 			VARCHAR(50) NULL,
	ARTICULO 		VARCHAR(20) NOT NULL,	
	ANULADA 		VARCHAR(1) NOT NULL,
	FECHA_FACTURA 		DATETIME NOT NULL,
	CANTIDAD 		DECIMAL(28, 8) NOT NULL,
	PRECIO_UNITARIO 	DECIMAL(28, 8) NOT NULL,
	TOTAL_IMPUESTO1 	DECIMAL(28, 8) NOT NULL,
	TOTAL_IMPUESTO2 	DECIMAL(28, 8) NOT NULL,
	DESC_TOT_LINEA 		DECIMAL(28, 8) NOT NULL,
	DESC_TOT_GENERAL 	DECIMAL(28, 8) NOT NULL,
	COSTO_TOTAL 		DECIMAL(28, 8) NOT NULL,
	PRECIO_TOTAL 		DECIMAL(28, 8) NOT NULL,
	COMENTARIO 		VARCHAR(100) NULL,
	COSTO_TOTAL_LOCAL 	DECIMAL(28, 8) NOT NULL,
	PEDIDO_LINEA 		SMALLINT NULL,
	DOCUMENTO_ORIGEN 	VARCHAR(50) NULL,
	COSTO_ESTIM_LOCAL 	DECIMAL(28, 8) NOT NULL,
	COSTO_ESTIM_DOLAR 	DECIMAL(28, 8) NOT NULL,
	MONTO_RETENCION 	DECIMAL(28, 8) NOT NULL,
	BASE_IMPUESTO1 		DECIMAL(28, 8) NULL,
	BASE_IMPUESTO2 		DECIMAL(28, 8) NULL
)
go	
	
	
	
CREATE TABLE SP_PROVEEDOR(
	PROVEEDOR 		VARCHAR(20) NOT NULL,
	NOMBRE 			VARCHAR(80) NOT NULL,
	CONDICION_PAGO 		VARCHAR(4) NOT NULL,
	LOCAL 			VARCHAR(1) NOT NULL,
	IMPUESTO1_INCLUIDO 	VARCHAR(1) NOT NULL,
	CONTACTO 		VARCHAR(30) NOT NULL,
	DIRECCION 		TEXT NOT NULL,
	TELEFONO1 		VARCHAR(50) NULL,
	ORDEN_MINIMA 		DECIMAL(28, 8) NOT NULL,
	MONEDA 			VARCHAR(4) NOT NULL,
	PAIS 			VARCHAR(4) NOT NULL,
	SALDO 			DECIMAL(28, 8) NOT NULL
)
go



CREATE TABLE SP_TRANSACCION_INV(
	AUDIT_TRANS_INV 	INT NOT NULL,
	CONSECUTIVO 		INT NOT NULL,
	FECHA_HORA_TRANSAC 	DATETIME NULL,
	NIT 			VARCHAR(20) NULL,
	SERIE_CADENA 		INT NULL,
	AJUSTE_CONFIG 		VARCHAR(4) NULL,
	ARTICULO 		VARCHAR(20) NOT NULL,
	BODEGA 			VARCHAR(4) NULL,
	LOCALIZACION 		VARCHAR(8) NULL,
	LOTE 			VARCHAR(15) NULL,
	TIPO 			VARCHAR(1) NOT NULL,
	SUBTIPO 		VARCHAR(1) NOT NULL,
	SUBSUBTIPO 		VARCHAR(1) NOT NULL,
	NATURALEZA 		VARCHAR(1) NOT NULL,
	CANTIDAD 		DECIMAL(28, 8) NOT NULL,
	COSTO_TOT_FISC_LOC 	DECIMAL(28, 8) NOT NULL,
	COSTO_TOT_FISC_DOL 	DECIMAL(28, 8) NOT NULL,
	COSTO_TOT_COMP_LOC 	DECIMAL(28, 8) NOT NULL,
	COSTO_TOT_COMP_DOL 	DECIMAL(28, 8) NOT NULL,
	PRECIO_TOTAL_LOCAL 	DECIMAL(28, 8) NOT NULL,
	PRECIO_TOTAL_DOLAR 	DECIMAL(28, 8) NOT NULL,
	CONTABILIZADA 		VARCHAR(1) NOT NULL,
	FECHA 			DATETIME NOT NULL,
	CENTRO_COSTO 		VARCHAR(25) NULL,
	UNIDAD_DISTRIBUCIO 	VARCHAR(6) NULL,
	CUENTA_CONTABLE 	VARCHAR(25) NULL,
	ASIENTO_CARDEX 		VARCHAR(10) NULL
)
go	
	
	
	
CREATE TABLE SP_PRECIO_ART_PROV(
	ARTICULO 	VARCHAR(20) NOT NULL,
	PROVEEDOR 	VARCHAR(20) NOT NULL,
	LINEA 		SMALLINT NOT NULL,
	CANTIDAD_HASTA 	DECIMAL(28, 8) NOT NULL,
	PRECIO 		DECIMAL(28, 8) NOT NULL
)
go



CREATE TABLE SP_EXISTENCIA_BODEGA(
	ARTICULO 			VARCHAR(20) NOT NULL,
	BODEGA 				VARCHAR(4) NOT NULL,
	EXISTENCIA_MINIMA 		DECIMAL(28, 8) NOT NULL,
	EXISTENCIA_MAXIMA 		DECIMAL(28, 8) NOT NULL,
	PUNTO_DE_REORDEN 		DECIMAL(28, 8) NOT NULL,
	CANT_DISPONIBLE 		DECIMAL(28, 8) NOT NULL,
	CANT_RESERVADA 			DECIMAL(28, 8) NOT NULL,
	CANT_NO_APROBADA 		DECIMAL(28, 8) NOT NULL,
	CANT_VENCIDA 			DECIMAL(28, 8) NOT NULL,
	CANT_TRANSITO 			DECIMAL(28, 8) NOT NULL,
	CANT_PRODUCCION 		DECIMAL(28, 8) NOT NULL,
	CANT_PEDIDA 			DECIMAL(28, 8) NOT NULL,
	CANT_REMITIDA 			DECIMAL(28, 8) NOT NULL,
	CONGELADO 			VARCHAR(1) NOT NULL,
	FECHA_CONG 			DATETIME NULL,
	BLOQUEA_TRANS 			VARCHAR(1) NOT NULL,
	FECHA_DESCONG 			DATETIME NULL,
	COSTO_UNT_PROMEDIO_LOC 		DECIMAL(28, 8) NOT NULL,
	COSTO_UNT_PROMEDIO_DOL 		DECIMAL(28, 8) NOT NULL,
	COSTO_UNT_ESTANDAR_LOC 		DECIMAL(28, 8) NOT NULL,
	COSTO_UNT_ESTANDAR_DOL 		DECIMAL(28, 8) NOT NULL,
	COSTO_PROM_COMPARATIVO_LOC 	DECIMAL(28, 8) NOT NULL,
	COSTO_PROM_COMPARATIVO_DOLAR 	DECIMAL(28, 8) NOT NULL
)
go
	
	
	
CREATE TABLE SP_ORDEN_COMPRA(
	ORDEN_COMPRA		VARCHAR(10) NOT NULL,
	USUARIO			VARCHAR(25) NULL,
	PROVEEDOR		VARCHAR(20) NOT NULL,
	BODEGA			VARCHAR(4) NOT NULL,
	CONDICION_PAGO		VARCHAR(4) NOT NULL,
	FECHA 			DATETIME NOT NULL,
	FECHA_COTIZACION	DATETIME NULL,
	FECHA_OFRECIDA		DATETIME NULL,
	FECHA_EMISION		DATETIME NULL,
	FECHA_REQ_EMBARQUE	DATETIME NULL,
	FECHA_REQUERIDA		DATETIME NOT NULL,
	MONTO_DESCUENTO		DECIMAL(28, 8) NULL,
	TOTAL_MERCADERIA	DECIMAL(28, 8) NOT NULL,
	TOTAL_IMPUESTO1		DECIMAL(28, 8) NOT NULL,
	TOTAL_IMPUESTO2		DECIMAL(28, 8) NOT NULL,
	TOTAL_A_COMPRAR		DECIMAL(28, 8) NOT NULL,
	PRIORIDAD		VARCHAR(1) NOT NULL,
	ESTADO			VARCHAR(1) NOT NULL,
	FECHA_HORA		DATETIME NOT NULL
)
go	
	
	
	
CREATE TABLE SP_ORDEN_COMPRA_LINEA(
	ORDEN_COMPRA 			VARCHAR(10) NOT NULL,
	ORDEN_COMPRA_LINEA 		SMALLINT NOT NULL,
	ARTICULO VARCHAR(20) 		NOT NULL,
	BODEGA VARCHAR(4) 		NOT NULL,
	DESCRIPCION TEXT 		NULL,
	CANTIDAD_ORDENADA 		DECIMAL(28, 8) NOT NULL,
	CANTIDAD_EMBARCADA 		DECIMAL(28, 8) NOT NULL,
	CANTIDAD_RECIBIDA 		DECIMAL(28, 8) NOT NULL,
	CANTIDAD_RECHAZADA		DECIMAL(28, 8) NOT NULL,
	PRECIO_UNITARIO			DECIMAL(28, 8) NOT NULL,
	IMPUESTO1			DECIMAL(28, 8) NOT NULL,
	IMPUESTO2			DECIMAL(28, 8) NOT NULL,
	MONTO_DESCUENTO			DECIMAL(28, 8) NOT NULL,
	FECHA				DATETIME NOT NULL,
	ESTADO				VARCHAR(1) NOT NULL,
	FECHA_REQUERIDA			DATETIME NOT NULL,
	FACTURA				VARCHAR(50) NULL,
	E_MAIL				VARCHAR(250) NULL,
	PRECIO_ART_PROV			DECIMAL(28, 8) NOT NULL
)
go
	
	
	
CREATE TABLE SP_AUDIT_TRANS_INV(
	AUDIT_TRANS_INV 	INT NOT NULL,
	CONSECUTIVO 		VARCHAR(10) NULL,
	USUARIO 		VARCHAR(25) NOT NULL,
	FECHA_HORA 		DATETIME NOT NULL,
	MODULO_ORIGEN 		VARCHAR(4) NOT NULL,
	APLICACION 		VARCHAR(249) NOT NULL,
	REFERENCIA 		VARCHAR(200) NOT NULL,
	ASIENTO 		VARCHAR(10) NULL,
	USUARIO_APRO 		VARCHAR(25) NULL,
	FECHA_HORA_APROB 	DATETIME NULL,
	PAQUETE_INVENTARIO 	VARCHAR(4) NULL
)
go
	


CREATE TABLE SP_EMBARQUE(
	EMBARQUE 		VARCHAR(10) NOT NULL,
	LIQUIDAC_COMPRA 	VARCHAR(15) NULL,
	PROVEEDOR 		VARCHAR(20) NULL,
	FECHA_REQUERIDA 	DATETIME NULL,
	FECHA_OFRECIDA 		DATETIME NULL,
	FECHA_EMBARQUE 		DATETIME NULL,
	ESTADO 			VARCHAR(1) NOT NULL,
	USUARIO_CREADO 		VARCHAR(25) NOT NULL,
	FECHA_HORA_CREADO 	DATETIME NOT NULL,
	USUARIO_APLICADO 	VARCHAR(25) NULL,
	FECHA_HORA_APLICAC 	DATETIME NULL,
	ASIENTO 		VARCHAR(10) NULL,
	AUDIT_TRANS_INV 	INT NULL,
	AUDIT_TRANS_LIQ 	INT NULL,
	FECHA_CRM 		DATETIME NULL,
	TIENE_FACTURA 		VARCHAR(1) NOT NULL
)
go
	

CREATE TABLE SP_EMBARQUE_LINEA(
	EMBARQUE 		VARCHAR(10) NOT NULL,
	EMBARQUE_LINEA 		SMALLINT NOT NULL,
	ORDEN_COMPRA 		VARCHAR(10) NULL,
	ORDEN_COMPRA_LINEA 	SMALLINT NULL,
	ARTICULO 		VARCHAR(20) NOT NULL,
	BODEGA 			VARCHAR(4) NOT NULL,
	CANTIDAD_EMBARCADA 	DECIMAL(28, 8) NOT NULL,
	CANTIDAD_RECIBIDA 	DECIMAL(28, 8) NOT NULL,
	CANTIDAD_RECHAZADA 	DECIMAL(28, 8) NOT NULL,
	PRECIO_UNITARIO 	DECIMAL(28, 8) NOT NULL,
	SUBTOTAL 		DECIMAL(28, 8) NULL,
	DESCUENTO 		DECIMAL(28, 8) NULL,
	IMPUESTO1 		DECIMAL(28, 8) NULL,
	IMPUESTO2 		DECIMAL(28, 8) NULL,
	DOCUMENTO 		VARCHAR(50) NULL,
	TIPO_DOCUMENTO 		VARCHAR(1) NULL
)
go



CREATE TABLE SP_DEPARTAMENTO(
	DEPARTAMENTO		VARCHAR(10) NOT NULL,
	DESCRIPCION		VARCHAR(40) NOT NULL
)
go



CREATE TABLE SP_BODEGA(
	BODEGA		VARCHAR(4) NOT NULL,
	NOMBRE		VARCHAR(40) NOT NULL,
	TIPO		VARCHAR(1) NOT NULL,
	TELEFONO	VARCHAR(15) NOT NULL,
	DIRECCION	VARCHAR(120) NULL
)
go
	
	
	
CREATE TABLE SP_PRONOSTICO(
	PRONOSTICO		VARCHAR(20) NOT NULL,
	DESCRIPCION		VARCHAR(40) NOT NULL,
	PDO_INI_PRONOST		DATETIME NOT NULL,
	PDO_FIN_PRONOST		DATETIME NOT NULL
)
go
	
ALTER TABLE SP_PRONOSTICO 
	ADD  CONSTRAINT XPKSPPRONOSTICO PRIMARY KEY NONCLUSTERED (PRONOSTICO)
go
	
	
CREATE TABLE SP_PRONOSTICO_DETALLE(
	ID			INT	IDENTITY(1,1) NOT NULL,
	PRONOSTICO		VARCHAR(20) NOT NULL,
	PERIODO			DATETIME NOT NULL,
	ITEM_PRONOSTICADO	SMALLINT NOT NULL,
	ARTICULO		VARCHAR(20) NOT NULL,
	BODEGA			VARCHAR(4) NULL,
	CANTIDAD_PRONOSTICADA		DECIMAL(28, 8) NOT NULL
)
go
		
ALTER TABLE SP_PRONOSTICO_DETALLE 
	ADD  CONSTRAINT XPKSPPRONOSTICODET PRIMARY KEY NONCLUSTERED (ID)
go
     
     
 CREATE TABLE SP_PROBABILIDAD(
	COMBINACION	VARCHAR(4) NULL,
	PORCENTAJE	VARCHAR(3) NULL
)
go


CREATE TABLE SP_PROB_DETALLE(
	COMBINACION 	VARCHAR(4) NULL,
	PORCENTAJE 	VARCHAR(3) NULL
)
go


CREATE TABLE SP_HISTORIAL(
	ID				INT IDENTITY(1,1) NOT NULL,
	PLANIFICADOR			VARCHAR(10) NOT NULL,
	CONJUNTO			VARCHAR(10) NOT NULL,
	CONSECUTIVO			VARCHAR(10) NOT NULL,
	ARTICULO			VARCHAR(20) NOT NULL,
	DESCRIPCION			VARCHAR(254) NOT NULL,
	ARTICULO_PROVEEDOR		VARCHAR(20) NOT NULL,
	CONSUMO_PROMEDIO		DECIMAL(28, 8) NOT NULL,
	INV_MAXIMO			DECIMAL(28, 8) NOT NULL,
	INV_TRANSITO			DECIMAL(28, 8) NOT NULL,
	INV_ACTUAL			DECIMAL(28, 8) NOT NULL,
	REFERENCIA_PEDIDO		DECIMAL(28, 8) NOT NULL,
	PRECIO_UNITARIO			DECIMAL(28, 8) NOT NULL,
	PRECIO_TOTAL			DECIMAL(28, 8) NOT NULL,
	SUGERENCIA_PEDIDO		DECIMAL(28, 8) NOT NULL,
	CANTIDAD_COMPRADA		DECIMAL(28, 8) NOT NULL,
	USUARIO				VARCHAR(30) NOT NULL,
	FECHA_HORA			DATETIME NULL,
	NOTAS VARCHAR(250) NULL
)
go


CREATE TABLE GLOBALES_SP(
	FORMULA				VARCHAR(1) 	NOT NULL DEFAULT 'S',
	ULT_FACTURA_LINEA 		DATETIME 	NOT NULL DEFAULT DATEADD(YEAR, -1, ERPADMIN.SF_GETDATE()),
	ULT_TRANSACCION_INV 		DATETIME 	NOT NULL DEFAULT DATEADD(YEAR, -1, ERPADMIN.SF_GETDATE()), 
	ULT_ORDEN_COMPRA 		DATETIME 	NOT NULL DEFAULT DATEADD(YEAR, -1, ERPADMIN.SF_GETDATE()), 
	ULT_ORDEN_COMPRA_LINEA 		DATETIME 	NOT NULL DEFAULT DATEADD(YEAR, -1, ERPADMIN.SF_GETDATE()),
	ULT_AUDIT_TRANS_INV 		DATETIME 	NOT NULL DEFAULT DATEADD(YEAR, -1, ERPADMIN.SF_GETDATE()),
	ULT_EMBARQUE 			DATETIME 	NOT NULL DEFAULT DATEADD(YEAR, -1, ERPADMIN.SF_GETDATE()),
	ULT_EMBARQUE_LINEA 		DATETIME 	NOT NULL DEFAULT DATEADD(YEAR, -1, ERPADMIN.SF_GETDATE()),
	USA_CONSUMO			VARCHAR(1) 	NOT NULL DEFAULT 'N',
	USA_ROTACION			VARCHAR(1) 	NOT NULL DEFAULT 'N',
	USA_FRECUENCIA			VARCHAR(1) 	NOT NULL DEFAULT 'N',
	USA_MARGEN			VARCHAR(1) 	NOT NULL DEFAULT 'N',
	PERIODICIDAD_ABC		VARCHAR(1) 	NOT NULL DEFAULT 'T',
	CATEG_CONSUMO			VARCHAR(1) 	NOT NULL DEFAULT 'A',
	CATEG_FRECUENCIA		VARCHAR(1) 	NOT NULL DEFAULT 'B',
	CATEG_ROTACION			VARCHAR(1) 	NOT NULL DEFAULT 'C',
	CATEG_MARGEN			VARCHAR(1) 	NOT NULL DEFAULT 'D',
	PORC_CONSUMO_A			INT 		NOT NULL DEFAULT 0,
	PORC_CONSUMO_B			INT 		NOT NULL DEFAULT 0,
	PORC_CONSUMO_C			INT 		NOT NULL DEFAULT 0,
	PORC_FRECUENCIA_A		INT 		NOT NULL DEFAULT 0,
	PORC_FRECUENCIA_B		INT 		NOT NULL DEFAULT 0,
	PORC_FRECUENCIA_C		INT 		NOT NULL DEFAULT 0,
	PORC_ROTACION_A			INT 		NOT NULL DEFAULT 0,
	PORC_ROTACION_B			INT 		NOT NULL DEFAULT 0,
	PORC_ROTACION_C			INT 		NOT NULL DEFAULT 0,
	PORC_MARGEN_A			INT 		NOT NULL DEFAULT 0,
	PORC_MARGEN_B			INT 		NOT NULL DEFAULT 0,
	PORC_MARGEN_C			INT 		NOT NULL DEFAULT 0,
	MODULO_INICIALIZADO		VARCHAR(1) 	NOT NULL DEFAULT 'N'
)
go   

CREATE TABLE SP_ARTICULO_TEMP(
PKSP_ARTICULO_TEMP 	int IDENTITY(1,1), 
PLANIFICADOR 		NVARCHAR(10) NOT NULL,
FKVERSION 			INT  NOT NULL,
FKSP_HISTORIAL 		int  NOT NULL,
CODIGO 				NVARCHAR(20) NOT NULL,
DESCRIPCION 		NVARCHAR(254) NOT NULL,
SUGERIDO 			DECIMAL(28,8) NOT NULL,
CLASE_TOTAL 		NVARCHAR(10) NOT NULL, 
CONSUMO_PROMEDIO 	DECIMAL(28,8) NOT NULL,
INV_MAXIMO 			DECIMAL(28,8) NOT NULL,
INV_TRANSITO 		DECIMAL(28,8) NOT NULL, 
INV_ACTUAL 			DECIMAL(28,8) NOT NULL, 
REFERENCIA_PEDIDO 	DECIMAL(28,8) NOT NULL,
SUGERENCIA_PEDIDO 	DECIMAL(28,8) NOT NULL, 
PROVEEDOR 			NVARCHAR(20)  NULL, 
PRECIO_UNITARIO 	DECIMAL(28,8) NOT NULL,
PRECIO_TOTAL 		DECIMAL(28,8) NOT NULL
)
go

ALTER TABLE SP_ARTICULO_TEMP ADD CONSTRAINT XARTICULOEMP PRIMARY KEY NONCLUSTERED (PKSP_ARTICULO_TEMP)
go

CREATE TABLE SP_VERSION_PLANIFICADOR_TEMP(
PKSP_VERSION_TEMP 		int IDENTITY(1,1) ,
FKPLANIFICADOR 			NVARCHAR(10) NOT NULL,
FECHA_INI_PLANIFICADOR 	DATETIME NOT NULL,
FECHA_FIN_PLANIFICADOR 	DATETIME NOT NULL,
VERSION_PLANIFICADOR 	INT  NOT NULL
)
go

ALTER TABLE SP_VERSION_PLANIFICADOR_TEMP ADD CONSTRAINT XVERSIONPLANIFICADOR PRIMARY KEY NONCLUSTERED (PKSP_VERSION_TEMP)
go
 