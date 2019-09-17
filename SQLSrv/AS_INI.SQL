
INSERT INTO ADUANA( ADUANA, DESCRIPCION )
	VALUES( 'ND',  'NO DEFINIDA' )
go	
	
INSERT INTO AGENTE_ADUANAL ( AGENTE_ADUANAL , DESCRIPCION )
	VALUES( 'ND',  'NO DEFINIDA' )
go	

INSERT INTO IMPUESTO ( IMPUESTO, DESCRIPCION, IMPUESTO1, IMPUESTO2 )
    VALUES ( 'ND', 'No definido', 0, 0 )
go

INSERT INTO DEPARTAMENTO (DEPARTAMENTO, DESCRIPCION)
    VALUES ('ND','No definido')
go

INSERT INTO BODEGA ( BODEGA, NOMBRE, TIPO, TELEFONO )VALUES( 'ND',  'NO DEFINIDA', 'C', 'ND' )
go

INSERT INTO CONDICION_PAGO ( CONDICION_PAGO, DESCRIPCION, DESCUENTO_CONTADO, PAGOS_PARCIALES, DIAS_NETO, TIPO_CONDPAGO ) VALUES( '0', 'CONTADO', 0, 'N', 0 , 'NO')
go

INSERT INTO DENOMINACION ( TIPO, DENOM_MONTO ) VALUES( 'M', 1 )
go

INSERT INTO MONEDA ( MONEDA, NOMBRE ) VALUES( 'ND', 'NO DEFINIDA')
go

INSERT INTO DIRECCION (DIRECCION,DESCRIPCION,NOMBRE_CAMPO_1,USUARIO_CREACION,FECHA_CREACION,USUARIO_ULT_MODIF,FECHA_ULT_MODIF
)  VALUES ('ESTANDAR','DIRECCIÓN ESTÁNDAR POR OMISIÓN','DETALLE','SA', '1980-01-01 12:00:00','SA','1980-01-01 12:00:00')
go

INSERT INTO DETALLE_DIRECCION (DETALLE_DIRECCION, DIRECCION)
VALUES ( 0, 'ESTANDAR')
go

INSERT INTO PAIS( PAIS, DIRECCION,NOMBRE ) VALUES( 'ND', 'ESTANDAR','NO DEFINIDO' )
go

INSERT INTO TIPO_CAMBIO ( TIPO_CAMBIO, DESCRIPCION) VALUES( 'ND', 'NO DEFINIDO' )
go

INSERT INTO TIPO_NIT ( TIPO, MASCARA) VALUES ('ND', ' ' )
go

INSERT INTO VENDEDOR( VENDEDOR, NOMBRE, EMPLEADO, COMISION, ACTIVO ) VALUES( 'ND', 'NO DEFINIDO', 'ND', 0, 'S' )
go

INSERT INTO ZONA (ZONA, NOMBRE ) VALUES( 'ND', 'NO DEFINIDA' )
go

INSERT INTO NIVEL_PRECIO ( NIVEL_PRECIO, MONEDA, ESQUEMA_TRABAJO, DESCUENTOS, SUGERIR_DESCUENTO ) 
			VALUES ('ND-LOCAL','L', 'N','V', 'S')
go	

INSERT INTO NIVEL_PRECIO ( NIVEL_PRECIO, MONEDA, ESQUEMA_TRABAJO, DESCUENTOS, SUGERIR_DESCUENTO ) 
			VALUES ('ND-DOLAR','D', 'N','V', 'S')
go

INSERT INTO CATEGORIA_CLIENTE (CATEGORIA_CLIENTE, DESCRIPCION)
    VALUES ('ND','NO DEFINIDA')
go

INSERT INTO RUTA (RUTA, DESCRIPCION)
    VALUES ('ND','NO DEFINIDA')
go

INSERT INTO COBRADOR (COBRADOR, NOMBRE, COMISION, ACTIVO )VALUES ('ND','NO DEFINIDO',0, 'S')
go

INSERT INTO TIPO_TARJETA (TIPO_TARJETA) VALUES ('ND')
go

INSERT INTO CENTRO_COSTO (CENTRO_COSTO, DESCRIPCION,ACEPTA_DATOS, TIPO)  VALUES ('ND','NO DEFINIDO','S', 'A')
go

INSERT INTO CATEGORIA_PROVEED (CATEGORIA_PROVEED, DESCRIPCION)
    VALUES ('ND','NO DEFINIDA')
go

INSERT INTO UBICACION (UBICACION, DESCRIPCION)
    VALUES ('ND','NO DEFINIDA')
go

INSERT INTO NIT (NIT, RAZON_SOCIAL,TIPO)
    VALUES ('ND','NO DEFINIDO','ND')
go

INSERT INTO ENTIDAD_FINANCIERA (ENTIDAD_FINANCIERA, NIT, DESCRIPCION)
    VALUES ('ND','ND','NO DEFINIDA')
go

INSERT INTO MONEDA_HIST (MONEDA, FECHA, USUARIO, MONTO) 
    VALUES ('ND', '01-JAN-1980', 'SA', 1)
go

INSERT INTO GLOBALES ( MODULO,NOMBRE,TIPO,VALOR) VALUES ('CP', 'ImprimirEtiquetasDireccion','S','N')
go

INSERT INTO GLOBALES (MODULO, NOMBRE, TIPO, VALOR) VALUES ('CO','PRIV_CENTROS_COMPRAS','U','N')
go

INSERT INTO GLOBALES ( MODULO, NOMBRE, TIPO, VALOR) VALUES('FA','ManejarAliasF1Articulos', 'S','N')
go

INSERT INTO GLOBALES (MODULO, NOMBRE, TIPO, VALOR) VALUES ('AS', 'EDI_USAR_DE', 	'S', 	'N')
go
INSERT INTO GLOBALES (MODULO, NOMBRE, TIPO, VALOR) VALUES ('AS', 'EDI_TIPO', 		'S', 	'E')
go
INSERT INTO GLOBALES (MODULO, NOMBRE, TIPO, VALOR) VALUES ('AS', 'EDI_NRESOLUCION', 	'S', 	NULL)
go
INSERT INTO GLOBALES (MODULO, NOMBRE, TIPO, VALOR) VALUES ('AS', 'EDI_FRESOLUCION', 	'D', 	NULL)
go
INSERT INTO GLOBALES (MODULO, NOMBRE, TIPO, VALOR) VALUES ('AS', 'EDI_CONSEFAC', 	'N', 	'1')
go
INSERT INTO GLOBALES (MODULO, NOMBRE, TIPO, VALOR) VALUES ('AS', 'EDI_CONSENC', 	'N', 	'1')
go
INSERT INTO GLOBALES (MODULO, NOMBRE, TIPO, VALOR) VALUES ('AS', 'EDI_CONSEND', 	'N', 	'1')
go
INSERT INTO GLOBALES (MODULO, NOMBRE, TIPO, VALOR) VALUES ('AS', 'EDI_CONSEREC', 	'N', 	'1')
go
INSERT INTO GLOBALES (MODULO, NOMBRE, TIPO, VALOR) VALUES ('AS', 'EDI_FORMATOFAC', 	'S', 	NULL)
go
INSERT INTO GLOBALES (MODULO, NOMBRE, TIPO, VALOR) VALUES ('AS', 'EDI_FORMATONC', 	'S', 	NULL)
go
INSERT INTO GLOBALES (MODULO, NOMBRE, TIPO, VALOR) VALUES ('AS', 'EDI_FORMATOND', 	'S', 	NULL)
go
INSERT INTO GLOBALES (MODULO, NOMBRE, TIPO, VALOR) VALUES ('AS', 'EDI_RUTA_UNC', 	'S', 	NULL)
go
INSERT INTO GLOBALES (MODULO, NOMBRE, TIPO, VALOR) VALUES ('AS', 'EDI_RUTA_PUBCERT',	'S',	NULL)
go


INSERT INTO GLOBALES (MODULO, NOMBRE, TIPO, VALOR) VALUES ('AS', 'EDI_CONSEC_PED', 'S',NULL )
go
INSERT INTO GLOBALES (MODULO, NOMBRE, TIPO, VALOR) VALUES ('AS', 'EDI_EMAIL_ERRORES', 'S',NULL )
go

INSERT INTO globales(modulo, nombre, tipo, valor, texto) 
	values('CN','UsarCálculodeNóminaOptimizado', 'S', 'S',NULL)
go



INSERT into erpadmin.ACCION(ACCION,NOMBREACCION,DESCRIPCION,NOMBRECONSTANTE,ESMODULO,ESESTANDAR,TIPO,SUBTIPO,TABLA,INVOCACION)
Values(62000, 'Tipo Documento ME', 'Tipos de documento ME del ERP', 'U_TIPO_DOCUMENTO', 'N', 'S', 'F','N'	,'U_TIPO_DOCUMENTO', 'WinFormDotNet_v2:Softland.ERP.AS.Mantenimientos.UDE;Softland.ERP.AS.UI')
go


INSERT into erpadmin.PARENTESCO(ACCION,PADRE,NUMEROHERMANO)
VALUES(62000,8, 8)
go


INSERT into erpadmin.ACCION(ACCION,NOMBREACCION,DESCRIPCION,NOMBRECONSTANTE,ESMODULO,ESESTANDAR,TIPO,SUBTIPO,TABLA,INVOCACION)
Values(62001, 'Actividad Económica', 'Actividades Económicas del ERP', 'U_ACTIV_ECONOMICA', 'N', 'S', 'F','N'	,'U_ACTIV_ECONOMICA', 'WinFormDotNet_v2:Softland.ERP.AS.Mantenimientos.UDE;Softland.ERP.AS.UI')
go


INSERT into erpadmin.PARENTESCO(ACCION,PADRE,NUMEROHERMANO)
VALUES(62001,8, 9)
go




INSERT INTO $$COMPANIA$$.U_TIPO_DOCUMENTO(U_CODIGO, U_DESCRIP)VALUES('11','Registro civil de nacimiento')
go

INSERT INTO $$COMPANIA$$.U_TIPO_DOCUMENTO(U_CODIGO, U_DESCRIP)VALUES('12','Tarjeta de identidad')
go

INSERT INTO $$COMPANIA$$.U_TIPO_DOCUMENTO(U_CODIGO, U_DESCRIP)VALUES('13','Cédula de ciudadanía')
go

INSERT INTO $$COMPANIA$$.U_TIPO_DOCUMENTO(U_CODIGO, U_DESCRIP)VALUES('14','Certificado de la Registraduría para sucesiones ilíquidas de personas naturales que no tienen ningún documento de identificación')
go

INSERT INTO $$COMPANIA$$.U_TIPO_DOCUMENTO(U_CODIGO, U_DESCRIP)VALUES('15','Tipo de documento que identifica una sucesión ilíquida, expedido por la notoria o por un juzgado')
go

INSERT INTO $$COMPANIA$$.U_TIPO_DOCUMENTO(U_CODIGO, U_DESCRIP)VALUES('21','Tarjeta de Extranjería')
go

INSERT INTO $$COMPANIA$$.U_TIPO_DOCUMENTO(U_CODIGO, U_DESCRIP)VALUES('22','Cédula de Extranjería')
go

INSERT INTO $$COMPANIA$$.U_TIPO_DOCUMENTO(U_CODIGO, U_DESCRIP)VALUES('31','NIT')
go

INSERT INTO $$COMPANIA$$.U_TIPO_DOCUMENTO(U_CODIGO, U_DESCRIP)VALUES('33','Identificación de extranjeros diferente al NIT asignado DIAN')
go

INSERT INTO $$COMPANIA$$.U_TIPO_DOCUMENTO(U_CODIGO, U_DESCRIP)VALUES('41','Pasaporte')
go

INSERT INTO $$COMPANIA$$.U_TIPO_DOCUMENTO(U_CODIGO, U_DESCRIP)VALUES('42','Documento de identificación extranjero')
go

INSERT INTO $$COMPANIA$$.U_TIPO_DOCUMENTO(U_CODIGO, U_DESCRIP)VALUES('43','Sin identificación del exterior o para uso definido por la DIAN')
go

INSERT INTO $$COMPANIA$$.U_TIPO_DOCUMENTO(U_CODIGO, U_DESCRIP)VALUES('44','Documento de identificación extranjero Persona Jurídica')
go

INSERT INTO $$COMPANIA$$.U_TIPO_DOCUMENTO(U_CODIGO, U_DESCRIP)VALUES('46','Carné Diplomatico: Documento expedido por el Ministerio de Relaciones Exteriores a los miembros de la misiones diplomáticas y consulares, con el que se deben identificar ente las autoridades nacionales')
go


INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('01','Agricultura, ganadería, caza y actividades de servicios conexas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('011','Cultivos agrícolas transitorios')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0111','Cultivo de cereales (excepto arroz), legumbres y semillas oleaginosas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0112','Cultivo de arroz')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0113','Cultivo de hortalizas, raíces y tubérculos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0114','Cultivo de tabaco')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0115','Cultivo de plantas textiles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0119','Otros cultivos transitorios ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('012','Cultivos agrícolas permanentes')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0121','Cultivo de frutas tropicales y subtropicales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0122','Cultivo de plátano y banano')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0123','Cultivo de café')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0124','Cultivo de caña de azúcar')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0125','Cultivo de flor de corte')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0126','Cultivo de palma para aceite (palma africana) y otros frutos oleaginosos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0127','Cultivo de plantas con las que se preparan bebidas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0128','Cultivo de especias y de plantas aromáticas y medicinales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0129','Otros cultivos permanentes ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('013','Propagación de plantas (actividades de los viveros, excepto viveros forestales)')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0130','Propagación de plantas (actividades de los viveros, excepto viveros forestales)')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('014','Ganadería')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0141','Cría de ganado bovino y bufalino')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0142','Cría de caballos y otros equinos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0143','Cría de ovejas y cabras')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0144','Cría de ganado porcino')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0145','Cría de aves de corral')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0149','Cría de otros animales ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('015','Explotación mixta (agrícola y pecuaria)')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0150','Explotación mixta (agrícola y pecuaria)')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('016','Actividades de apoyo a la agricultura y la ganadería, y actividades posteriores a la cosecha')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0161','Actividades de apoyo a la agricultura')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0162','Actividades de apoyo a la ganadería')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0163','Actividades posteriores a la cosecha')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0164','Tratamiento de semillas para propagación')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('017','Caza ordinaria y mediante trampas y actividades de servicios conexas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0170','Caza ordinaria y mediante trampas y actividades de servicios conexas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('02','Silvicultura y extracción de madera')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('021','Silvicultura y otras actividades forestales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0210','Silvicultura y otras actividades forestales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('022','Extracción de madera')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0220','Extracción de madera')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('023','Recolección de productos forestales diferentes a la madera')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0230','Recolección de productos forestales diferentes a la madera')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('024','Servicios de apoyo a la silvicultura')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0240','Servicios de apoyo a la silvicultura')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('03','Pesca y acuicultura')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('031','Pesca')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0311','Pesca marítima')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0312','Pesca de agua dulce')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('032','Acuicultura')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0321','Acuicultura marítima')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0322','Acuicultura de agua dulce')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('05','Extracción de carbón de piedra y lignito')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('051','Extracción de hulla (carbón de piedra)')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0510','Extracción de hulla (carbón de piedra)')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('052','Extracción de carbón lignito')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0520','Extracción de carbón lignito')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('06','Extracción de petróleo crudo y gas natural')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('061','Extracción de petróleo crudo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0610','Extracción de petróleo crudo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('062','Extracción de gas natural')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0620','Extracción de gas natural')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('07','Extracción de minerales metalíferos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('071','Extracción de minerales de hierro')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0710','Extracción de minerales de hierro')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('072','Extracción de minerales metalíferos no ferrosos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0721','Extracción de minerales de uranio y de torio')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0722','Extracción de oro y otros metales preciosos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0723','Extracción de minerales de níquel')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0729','Extracción de otros minerales metalíferos no ferrosos ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('08','Extracción de otras minas y canteras')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('081','Extracción de piedra, arena, arcillas, cal, yeso, caolín, bentonitas y similares')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0811','Extracción de piedra, arena, arcillas comunes, yeso y anhidrita')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0812','Extracción de arcillas de uso industrial, caliza, caolín y bentonitas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('082','Extracción de esmeraldas, piedras preciosas y semipreciosas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0820','Extracción de esmeraldas, piedras preciosas y semipreciosas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('089','Extracción de otros minerales no metálicos ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0891','Extracción de minerales para la fabricación de abonos y productos químicos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0892','Extracción de halita (sal)')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0899','Extracción de otros minerales no metálicos ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('09','Actividades de servicios de apoyo para la explotación de minas y canteras')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('091','Actividades de apoyo para la extracción de petróleo y de gas natural')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0910','Actividades de apoyo para la extracción de petróleo y de gas natural')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('099','Actividades de apoyo para otras actividades de explotación de minas y canteras')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0990','Actividades de apoyo para otras actividades de explotación de minas y canteras')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('10','Elaboración de productos alimenticios')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('101','Procesamiento y conservación de carne, pescado, crustáceos y moluscos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1011','Procesamiento y conservación de carne y productos cárnicos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1012','Procesamiento y conservación de pescados, crustáceos y moluscos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('102','Procesamiento y conservación de frutas, legumbres, hortalizas y tubérculos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1020','Procesamiento y conservación de frutas, legumbres, hortalizas y tubérculos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('103','Elaboración de aceites y grasas de origen vegetal y animal')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1030','Elaboración de aceites y grasas de origen vegetal y animal')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('104','Elaboración de productos lácteos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1040','Elaboración de productos lácteos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('105','Elaboración de productos de molinería, almidones y productos derivados del almidón')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1051','Elaboración de productos de molinería')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1052','Elaboración de almidones y productos derivados del almidón')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('106','Elaboración de productos de café')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1061','Trilla de café')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1062','Descafeinado, tostión y molienda del café')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1063','Otros derivados del café')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('107','Elaboración de azúcar y panela')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1071','Elaboración y refinación de azúcar')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1072','Elaboración de panela')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('108','Elaboración de otros productos alimenticios')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1081','Elaboración de productos de panadería')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1082','Elaboración de cacao, chocolate y productos de confitería')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1083','Elaboración de macarrones, fideos, alcuzcuz y productos farináceos similares')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1084','Elaboración de comidas y platos preparados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1089','Elaboración de otros productos alimenticios ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('109','Elaboración de alimentos preparados para animales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1090','Elaboración de alimentos preparados para animales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('11','Elaboración de bebidas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('110','Elaboración de bebidas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1101','Destilación, rectificación y mezcla de bebidas alcohólicas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1102','Elaboración de bebidas fermentadas no destiladas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1103','Producción de malta, elaboración de cervezas y otras bebidas malteadas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1104','Elaboración de bebidas no alcohólicas, producción de aguas minerales y de otras aguas embotelladas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('12','Elaboración de productos de tabaco')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('120','Elaboración de productos de tabaco')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1200','Elaboración de productos de tabaco')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('13','Fabricación de productos textiles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('131','Preparación, hilatura, tejeduría y acabado de productos textiles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1311','Preparación e hilatura de fibras textiles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1312','Tejeduría de productos textiles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1313','Acabado de productos textiles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('139','Fabricación de otros productos textiles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1391','Fabricación de tejidos de punto y ganchillo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1392','Confección de artículos con materiales textiles, excepto prendas de vestir')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1393','Fabricación de tapetes y alfombras para pisos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1394','Fabricación de cuerdas, cordeles, cables, bramantes y redes')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1399','Fabricación de otros artículos textiles ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('14','Confección de prendas de vestir')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('141','Confección de prendas de vestir, excepto prendas de piel')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1410','Confección de prendas de vestir, excepto prendas de piel')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('142','Fabricación de artículos de piel')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1420','Fabricación de artículos de piel')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('143','Fabricación de artículos de punto y ganchillo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1430','Fabricación de artículos de punto y ganchillo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('15','Curtido y recurtido de cuerosgo fabricación de calzadogo fabricación de artículos de viaje, maletas, bolsos de mano y artículos similares, y fabricación de artículos de talabartería y guarnicioneríago adobo y teñido de pieles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('151','Curtido y recurtido de cuerosgo fabricación de artículos de viaje, bolsos de mano y artículos similares, y fabricación de artículos de talabartería y guarnicionería, adobo y teñido de pieles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1511','Curtido y recurtido de cuerosgo recurtido y teñido de pieles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1512','Fabricación de artículos de viaje, bolsos de mano y artículos similares elaborados en cuero, y fabricación de artículos de talabartería y guarnicionería')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1513','Fabricación de artículos de viaje, bolsos de mano y artículos similaresgo artículos de talabartería y guarnicionería elaborados en otros materiales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('152','Fabricación de calzado')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1521','Fabricación de calzado de cuero y piel, con cualquier tipo de suela')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1522','Fabricación de otros tipos de calzado, excepto calzado de cuero y piel')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1523','Fabricación de partes del calzado')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('16','Transformación de la madera y fabricación de productos de madera y de corcho, excepto mueblesgo fabricación de artículos de cestería y espartería')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('161','Aserrado, acepillado e impregnación de la madera')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1610','Aserrado, acepillado e impregnación de la madera')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('162','Fabricación de hojas de madera para enchapadogo fabricación de tableros contrachapados, tableros laminados, tableros de partículas y otros tableros y paneles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1620','Fabricación de hojas de madera para enchapadogo fabricación de tableros contrachapados, tableros laminados, tableros de partículas y otros tableros y paneles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('163','Fabricación de partes y piezas de madera, de carpintería y ebanistería para la construcción')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1630','Fabricación de partes y piezas de madera, de carpintería y ebanistería para la construcción')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('164','Fabricación de recipientes de madera')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1640','Fabricación de recipientes de madera')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('169','Fabricación de otros productos de maderago fabricación de artículos de corcho, cestería y espartería')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1690','Fabricación de otros productos de maderago fabricación de artículos de corcho, cestería y espartería')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('17','Fabricación de papel, cartón y productos de papel y cartón')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('170','Fabricación de papel, cartón y productos de papel y cartón')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1701','Fabricación de pulpas (pastas) celulósicasgo papel y cartón')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1702','Fabricación de papel y cartón ondulado (corrugado)go fabricación de envases, empaques y de embalajes de papel y cartón')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1709','Fabricación de otros artículos de papel y cartón')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('18','Actividades de impresión y de producción de copias a partir de grabaciones originales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('181','Actividades de impresión y actividades de servicios relacionados con la impresión')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1811','Actividades de impresión')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1812','Actividades de servicios relacionados con la impresión')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('182','Producción de copias a partir de grabaciones originales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1820','Producción de copias a partir de grabaciones originales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('19','Coquización, fabricación de productos de la refinación del petróleo y actividad de mezcla de combustibles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('191','Fabricación de productos de hornos de coque')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1910','Fabricación de productos de hornos de coque')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('192','Fabricación de productos de la refinación del petróleo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1921','Fabricación de productos de la refinación del petróleo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('1922','Actividad de mezcla de combustibles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('20','Fabricación de sustancias y productos químicos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('201','Fabricación de sustancias químicas básicas, abonos y compuestos inorgánicos nitrogenados, plásticos y caucho sintético en formas primarias')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2011','Fabricación de sustancias y productos químicos básicos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2012','Fabricación de abonos y compuestos inorgánicos nitrogenados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2013','Fabricación de plásticos en formas primarias')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2014','Fabricación de caucho sintético en formas primarias')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('202','Fabricación de otros productos químicos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2021','Fabricación de plaguicidas y otros productos químicos de uso agropecuario')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2022','Fabricación de pinturas, barnices y revestimientos similares, tintas para impresión y masillas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2023','Fabricación de jabones y detergentes, preparados para limpiar y pulirgo perfumes y preparados de tocador')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2029','Fabricación de otros productos químicos ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('203','Fabricación de fibras sintéticas y artificiales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2030','Fabricación de fibras sintéticas y artificiales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('21','Fabricación de productos farmacéuticos, sustancias químicas medicinales y productos botánicos de uso farmacéutico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('210','Fabricación de productos farmacéuticos, sustancias químicas medicinales y productos botánicos de uso farmacéutico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2100','Fabricación de productos farmacéuticos, sustancias químicas medicinales y productos botánicos de uso farmacéutico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('22','Fabricación de productos de caucho y de plástico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('221','Fabricación de productos de caucho')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2211','Fabricación de llantas y neumáticos de caucho')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2212','Reencauche de llantas usadas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2219','Fabricación de formas básicas de caucho y otros productos de caucho ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('222','Fabricación de productos de plástico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2221','Fabricación de formas básicas de plástico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2229','Fabricación de artículos de plástico ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('23','Fabricación de otros productos minerales no metálicos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('231','Fabricación de vidrio y productos de vidrio')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2310','Fabricación de vidrio y productos de vidrio')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('239','Fabricación de productos minerales no metálicos ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2391','Fabricación de productos refractarios')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2392','Fabricación de materiales de arcilla para la construcción')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2393','Fabricación de otros productos de cerámica y porcelana')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2394','Fabricación de cemento, cal y yeso')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2395','Fabricación de artículos de hormigón, cemento y yeso')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2396','Corte, tallado y acabado de la piedra')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2399','Fabricación de otros productos minerales no metálicos ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('24','Fabricación de productos metalúrgicos básicos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('241','Industrias básicas de hierro y de acero')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2410','Industrias básicas de hierro y de acero')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('242','Industrias básicas de metales preciosos y de metales no ferrosos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2421','Industrias básicas de metales preciosos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2429','Industrias básicas de otros metales no ferrosos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('243','Fundición de metales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2431','Fundición de hierro y de acero')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2432','Fundición de metales no ferrosos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('25','Fabricación de productos elaborados de metal, excepto maquinaria y equipo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('251','Fabricación de productos metálicos para uso estructural, tanques, depósitos y generadores de vapor')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2511','Fabricación de productos metálicos para uso estructural')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2512','Fabricación de tanques, depósitos y recipientes de metal, excepto los utilizados para el envase o transporte de mercancías')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2513','Fabricación de generadores de vapor, excepto calderas de agua caliente para calefacción central')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('252','Fabricación de armas y municiones')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2520','Fabricación de armas y municiones')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('259','Fabricación de otros productos elaborados de metal y actividades de servicios relacionadas con el trabajo de metales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2591','Forja, prensado, estampado y laminado de metalgo pulvimetalurgia')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2592','Tratamiento y revestimiento de metalesgo mecanizado')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2593','Fabricación de artículos de cuchillería, herramientas de mano y artículos de ferretería')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2599','Fabricación de otros productos elaborados de metal ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('26','Fabricación de productos informáticos, electrónicos y ópticos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('261','Fabricación de componentes y tableros electrónicos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2610','Fabricación de componentes y tableros electrónicos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('262','Fabricación de computadoras y de equipo periférico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2620','Fabricación de computadoras y de equipo periférico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('263','Fabricación de equipos de comunicación')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2630','Fabricación de equipos de comunicación')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('264','Fabricación de aparatos electrónicos de consumo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2640','Fabricación de aparatos electrónicos de consumo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('265','Fabricación de equipo de medición, prueba, navegación y controlgo fabricación de relojes')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2651','Fabricación de equipo de medición, prueba, navegación y control')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2652','Fabricación de relojes')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('266','Fabricación de equipo de irradiación y equipo electrónico de uso médico y terapéutico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2660','Fabricación de equipo de irradiación y equipo electrónico de uso médico y terapéutico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('267','Fabricación de instrumentos ópticos y equipo fotográfico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2670','Fabricación de instrumentos ópticos y equipo fotográfico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('268','Fabricación de medios magnéticos y ópticos para almacenamiento de datos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2680','Fabricación de medios magnéticos y ópticos para almacenamiento de datos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('27','Fabricación de aparatos y equipo eléctrico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('271','Fabricación de motores, generadores y transformadores eléctricos y de aparatos de distribución y control de la energía eléctrica')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2711','Fabricación de motores, generadores y transformadores eléctricos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2712','Fabricación de aparatos de distribución y control de la energía eléctrica')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('272','Fabricación de pilas, baterías y acumuladores eléctricos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2720','Fabricación de pilas, baterías y acumuladores eléctricos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('273','Fabricación de hilos y cables aislados y sus dispositivos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2731','Fabricación de hilos y cables eléctricos y de fibra óptica')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2732','Fabricación de dispositivos de cableado')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('274','Fabricación de equipos eléctricos de iluminación')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2740','Fabricación de equipos eléctricos de iluminación')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('275','Fabricación de aparatos de uso doméstico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2750','Fabricación de aparatos de uso doméstico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('279','Fabricación de otros tipos de equipo eléctrico ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2790','Fabricación de otros tipos de equipo eléctrico ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('28','Fabricación de maquinaria y equipo ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('281','Fabricación de maquinaria y equipo de uso general')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2811','Fabricación de motores, turbinas, y partes para motores de combustión interna')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2812','Fabricación de equipos de potencia hidráulica y neumática')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2813','Fabricación de otras bombas, compresores, grifos y válvulas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2814','Fabricación de cojinetes, engranajes, trenes de engranajes y piezas de transmisión')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2815','Fabricación de hornos, hogares y quemadores industriales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2816','Fabricación de equipo de elevación y manipulación')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2817','Fabricación de maquinaria y equipo de oficina (excepto computadoras y equipo periférico)')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2818','Fabricación de herramientas manuales con motor')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2819','Fabricación de otros tipos de maquinaria y equipo de uso general ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('282','Fabricación de maquinaria y equipo de uso especial')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2821','Fabricación de maquinaria agropecuaria y forestal')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2822','Fabricación de máquinas formadoras de metal y de máquinas herramienta')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2823','Fabricación de maquinaria para la metalurgia')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2824','Fabricación de maquinaria para explotación de minas y canteras y para obras de construcción')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2825','Fabricación de maquinaria para la elaboración de alimentos, bebidas y tabaco')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2826','Fabricación de maquinaria para la elaboración de productos textiles, prendas de vestir y cueros')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2829','Fabricación de otros tipos de maquinaria y equipo de uso especial ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('29','Fabricación de vehículos automotores, remolques y semirremolques')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('291','Fabricación de vehículos automotores y sus motores')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2910','Fabricación de vehículos automotores y sus motores')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('292','Fabricación de carrocerías para vehículos automotoresgo fabricación de remolques y semirremolques')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2920','Fabricación de carrocerías para vehículos automotoresgo fabricación de remolques y semirremolques')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('293','Fabricación de partes, piezas (autopartes) y accesorios (lujos) para vehículos automotores')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('2930','Fabricación de partes, piezas (autopartes) y accesorios (lujos) para vehículos automotores')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('30','Fabricación de otros tipos de equipo de transporte')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('301','Construcción de barcos y otras embarcaciones')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3011','Construcción de barcos y de estructuras flotantes')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3012','Construcción de embarcaciones de recreo y deporte')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('302','Fabricación de locomotoras y de material rodante para ferrocarriles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3020','Fabricación de locomotoras y de material rodante para ferrocarriles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('303','Fabricación de aeronaves, naves espaciales y de maquinaria conexa')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3030','Fabricación de aeronaves, naves espaciales y de maquinaria conexa')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('304','Fabricación de vehículos militares de combate')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3040','Fabricación de vehículos militares de combate')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('309','Fabricación de otros tipos de equipo de transporte ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3091','Fabricación de motocicletas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3092','Fabricación de bicicletas y de sillas de ruedas para personas con discapacidad')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3099','Fabricación de otros tipos de equipo de transporte ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('31','Fabricación de muebles, colchones y somieres')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('311','Fabricación de muebles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3110','Fabricación de muebles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('312','Fabricación de colchones y somieres')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3120','Fabricación de colchones y somieres')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('32','Otras industrias manufactureras')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('321','Fabricación de joyas, bisutería y artículos conexos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3210','Fabricación de joyas, bisutería y artículos conexos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('322','Fabricación de instrumentos musicales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3220','Fabricación de instrumentos musicales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('323','Fabricación de artículos y equipo para la práctica del deporte')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3230','Fabricación de artículos y equipo para la práctica del deporte')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('324','Fabricación de juegos, juguetes y rompecabezas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3240','Fabricación de juegos, juguetes y rompecabezas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('325','Fabricación de instrumentos, aparatos y materiales médicos y odontológicos (incluido mobiliario)')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3250','Fabricación de instrumentos, aparatos y materiales médicos y odontológicos (incluido mobiliario)')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('329','Otras industrias manufactureras ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3290','Otras industrias manufactureras ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('33','Instalación, mantenimiento y reparación especializado de maquinaria y equipo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('331','Mantenimiento y reparación especializado de productos elaborados en metal y de maquinaria y equipo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3311','Mantenimiento y reparación especializado de productos elaborados en metal')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3312','Mantenimiento y reparación especializado de maquinaria y equipo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3313','Mantenimiento y reparación especializado de equipo electrónico y óptico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3314','Mantenimiento y reparación especializado de equipo eléctrico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3315','Mantenimiento y reparación especializado de equipo de transporte, excepto los vehículos automotores, motocicletas y bicicletas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3319','Mantenimiento y reparación de otros tipos de equipos y sus componentes ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('332','Instalación especializada de maquinaria y equipo industrial')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3320','Instalación especializada de maquinaria y equipo industrial')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('35','Suministro de electricidad, gas, vapor y aire acondicionado')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('351','Generación, transmisión, distribución y comercialización de energía eléctrica')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3511','Generación de energía eléctrica')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3512','Transmisión de energía eléctrica')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3513','Distribución de energía eléctrica')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3514','Comercialización de energía eléctrica')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('352','Producción de gasgo distribución de combustibles gaseosos por tuberías')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3520','Producción de gasgo distribución de combustibles gaseosos por tuberías')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('353','Suministro de vapor y aire acondicionado')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3530','Suministro de vapor y aire acondicionado')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('36','Captación, tratamiento y distribución de agua')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('360','Captación, tratamiento y distribución de agua')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3600','Captación, tratamiento y distribución de agua')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('37','Evacuación y tratamiento de aguas residuales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('370','Evacuación y tratamiento de aguas residuales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3700','Evacuación y tratamiento de aguas residuales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('38','Recolección, tratamiento y disposición de desechos, recuperación de materiales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('381','Recolección de desechos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3811','Recolección de desechos no peligrosos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3812','Recolección de desechos peligrosos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('382','Tratamiento y disposición de desechos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3821','Tratamiento y disposición de desechos no peligrosos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3822','Tratamiento y disposición de desechos peligrosos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('383','Recuperación de materiales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3830','Recuperación de materiales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('39','Actividades de saneamiento ambiental y otros servicios de gestión de desechos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('390','Actividades de saneamiento ambiental y otros servicios de gestión de desechos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('3900','Actividades de saneamiento ambiental y otros servicios de gestión de desechos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('41','Construcción de edificios')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('411','Construcción de edificios')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4111','Construcción de edificios residenciales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4112','Construcción de edificios no residenciales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('42','Obras de ingeniería civil')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('421','Construcción de carreteras y vías de ferrocarril')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4210','Construcción de carreteras y vías de ferrocarril')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('422','Construcción de proyectos de servicio público')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4220','Construcción de proyectos de servicio público')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('429','Construcción de otras obras de ingeniería civil')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4290','Construcción de otras obras de ingeniería civil')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('43','Actividades especializadas para la construcción de edificios y obras de ingeniería civil')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('431','Demolición y preparación del terreno')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4311','Demolición')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4312','Preparación del terreno')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('432','Instalaciones eléctricas, de fontanería y otras instalaciones especializadas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4321','Instalaciones eléctricas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4322','Instalaciones de fontanería, calefacción y aire acondicionado')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4329','Otras instalaciones especializadas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('433','Terminación y acabado de edificios y obras de ingeniería civil')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4330','Terminación y acabado de edificios y obras de ingeniería civil')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('439','Otras actividades especializadas para la construcción de edificios y obras de ingeniería civil')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4390','Otras actividades especializadas para la construcción de edificios y obras de ingeniería civil')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('45','Comercio, mantenimiento y reparación de vehículos automotores y motocicletas, sus partes, piezas y accesorios')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('451','Comercio de vehículos automotores')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4511','Comercio de vehículos automotores nuevos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4512','Comercio de vehículos automotores usados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('452','Mantenimiento y reparación de vehículos automotores')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4520','Mantenimiento y reparación de vehículos automotores')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('453','Comercio de partes, piezas (autopartes) y accesorios (lujos) para vehículos automotores')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4530','Comercio de partes, piezas (autopartes) y accesorios (lujos) para vehículos automotores')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('454','Comercio, mantenimiento y reparación de motocicletas y de sus partes, piezas y accesorios')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4541','Comercio de motocicletas y de sus partes, piezas y accesorios')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4542','Mantenimiento y reparación de motocicletas y de sus partes y piezas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('46','Comercio al por mayor y en comisión o por contrata, excepto el comercio de vehículos automotores y motocicletas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('461','Comercio al por mayor a cambio de una retribución o por contrata')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4610','Comercio al por mayor a cambio de una retribución o por contrata')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('462','Comercio al por mayor de materias primas agropecuariasgo animales vivos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4620','Comercio al por mayor de materias primas agropecuariasgo animales vivos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('463','Comercio al por mayor de alimentos, bebidas y tabaco')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4631','Comercio al por mayor de productos alimenticios')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4632','Comercio al por mayor de bebidas y tabaco')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('464','Comercio al por mayor de artículos y enseres domésticos (incluidas prendas de vestir)')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4641','Comercio al por mayor de productos textiles, productos confeccionados para uso doméstico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4642','Comercio al por mayor de prendas de vestir')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4643','Comercio al por mayor de calzado')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4644','Comercio al por mayor de aparatos y equipo de uso doméstico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4645','Comercio al por mayor de productos farmacéuticos, medicinales, cosméticos y de tocador')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4649','Comercio al por mayor de otros utensilios domésticos ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('465','Comercio al por mayor de maquinaria y equipo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4651','Comercio al por mayor de computadores, equipo periférico y programas de informática')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4652','Comercio al por mayor de equipo, partes y piezas electrónicos y de telecomunicaciones')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4653','Comercio al por mayor de maquinaria y equipo agropecuarios')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4659','Comercio al por mayor de otros tipos de maquinaria y equipo ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('466','Comercio al por mayor especializado de otros productos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4661','Comercio al por mayor de combustibles sólidos, líquidos, gaseosos y productos conexos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4662','Comercio al por mayor de metales y productos metalíferos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4663','Comercio al por mayor de materiales de construcción, artículos de ferretería, pinturas, productos de vidrio, equipo y materiales de fontanería y calefacción')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4664','Comercio al por mayor de productos químicos básicos, cauchos y plásticos en formas primarias y productos químicos de uso agropecuario')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4665','Comercio al por mayor de desperdicios, desechos y chatarra')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4669','Comercio al por mayor de otros productos ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('469','Comercio al por mayor no especializado')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4690','Comercio al por mayor no especializado')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('47','Comercio al por menor (incluso el comercio al por menor de combustibles), excepto el de vehículos automotores y motocicletas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('471','Comercio al por menor en establecimientos no especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4711','Comercio al por menor en establecimientos no especializados con surtido compuesto principalmente por alimentos, bebidas o tabaco')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4719','Comercio al por menor en establecimientos no especializados, con surtido compuesto principalmente por productos diferentes de alimentos (víveres en general), bebidas y tabaco')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('472','Comercio al por menor de alimentos (víveres en general), bebidas y tabaco, en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4721','Comercio al por menor de productos agrícolas para el consumo en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4722','Comercio al por menor de leche, productos lácteos y huevos, en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4723','Comercio al por menor de carnes (incluye aves de corral), productos cárnicos, pescados y productos de mar, en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4724','Comercio al por menor de bebidas y productos del tabaco, en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4729','Comercio al por menor de otros productos alimenticios ncp, en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('473','Comercio al por menor de combustible, lubricantes, aditivos y productos de limpieza para automotores, en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4731','Comercio al por menor de combustible para automotores')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4732','Comercio al por menor de lubricantes (aceites, grasas), aditivos y productos de limpieza para vehículos automotores')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('474','Comercio al por menor de equipos de informática y de comunicaciones, en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4741','Comercio al por menor de computadores, equipos periféricos, programas de informática y equipos de telecomunicaciones en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4742','Comercio al por menor de equipos y aparatos de sonido y de video, en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('475','Comercio al por menor de otros enseres domésticos en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4751','Comercio al por menor de productos textiles en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4752','Comercio al por menor de artículos de ferretería, pinturas y productos de vidrio en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4753','Comercio al por menor de tapices, alfombras y cubrimientos para paredes y pisos en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4754','Comercio al por menor de electrodomésticos y gasodomésticos de uso doméstico, muebles y equipos de iluminación')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4755','Comercio al por menor de artículos y utensilios de uso doméstico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4759','Comercio al por menor de otros artículos domésticos en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('476','Comercio al por menor de artículos culturales y de entretenimiento, en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4761','Comercio al por menor de libros, periódicos, materiales y artículos de papelería y escritorio, en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4762','Comercio al por menor de artículos deportivos, en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4769','Comercio al por menor de otros artículos culturales y de entretenimiento ncp en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('477','Comercio al por menor de otros productos en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4771','Comercio al por menor de prendas de vestir y sus accesorios (incluye artículos de piel) en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4772','Comercio al por menor de todo tipo de calzado y artículos de cuero y sucedáneos del cuero en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4773','Comercio al por menor de productos farmacéuticos y medicinales, cosméticos y artículos de tocador en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4774','Comercio al por menor de otros productos nuevos en establecimientos especializados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4775','Comercio al por menor de artículos de segunda mano')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('478','Comercio al por menor en puestos de venta móviles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4781','Comercio al por menor de alimentos, bebidas y tabaco, en puestos de venta móviles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4782','Comercio al por menor de productos textiles, prendas de vestir y calzado, en puestos de venta móviles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4789','Comercio al por menor de otros productos en puestos de venta móviles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('479','Comercio al por menor no realizado en establecimientos, puestos de venta o mercados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4791','Comercio al por menor realizado a través de internet')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4792','Comercio al por menor realizado a través de casas de venta o por correo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4799','Otros tipos de comercio al por menor no realizado en establecimientos, puestos de venta o mercados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('49','Transporte terrestrego transporte por tuberías')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('491','Transporte férreo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4911','Transporte férreo de pasajeros')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4912','Transporte férreo de carga')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('492','Transporte terrestre público automotor')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4921','Transporte de pasajeros')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4922','Transporte mixto')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4923','Transporte de carga por carretera')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('493','Transporte por tuberías')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('4930','Transporte por tuberías')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('50','Transporte acuático')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('501','Transporte marítimo y de cabotaje')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5011','Transporte de pasajeros marítimo y de cabotaje')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5012','Transporte de carga marítimo y de cabotaje')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('502','Transporte fluvial')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5021','Transporte fluvial de pasajeros')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5022','Transporte fluvial de carga')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('51','Transporte aéreo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('511','Transporte aéreo de pasajeros')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5111','Transporte aéreo nacional de pasajeros')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5112','Transporte aéreo internacional de pasajeros')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('512','Transporte aéreo de carga')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5121','Transporte aéreo nacional de carga')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5122','Transporte aéreo internacional de carga')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('52','Almacenamiento y actividades complementarias al transporte')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('521','Almacenamiento y depósito')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5210','Almacenamiento y depósito')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('522','Actividades de las estaciones, vías y servicios complementarios para el transporte')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5221','Actividades de estaciones, vías y servicios complementarios para el transporte terrestre')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5222','Actividades de puertos y servicios complementarios para el transporte acuático')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5223','Actividades de aeropuertos, servicios de navegación aérea y demás actividades conexas al transporte aéreo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5224','Manipulación de carga')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5229','Otras actividades complementarias al transporte')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('53','Correo y servicios de mensajería')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('531','Actividades postales nacionales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5310','Actividades postales nacionales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('532','Actividades de mensajería')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5320','Actividades de mensajería')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('55','Alojamiento')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('551','Actividades de alojamiento de estancias cortas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5511','Alojamiento en hoteles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5512','Alojamiento en apartahoteles')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5513','Alojamiento en centros vacacionales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5514','Alojamiento rural')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5519','Otros tipos de alojamientos para visitantes')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('552','Actividades de zonas de camping y parques para vehículos recreacionales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5520','Actividades de zonas de camping y parques para vehículos recreacionales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('553','Servicio por horas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5530','Servicio por horas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('559','Otros tipos de alojamiento ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5590','Otros tipos de alojamiento ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('56','Actividades de servicios de comidas y bebidas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('561','Actividades de restaurantes, cafeterías y servicio móvil de comidas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5611','Expendio a la mesa de comidas preparadas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5612','Expendio por autoservicio de comidas preparadas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5613','Expendio de comidas preparadas en cafeterías')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5619','Otros tipos de expendio de comidas preparadas ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('562','Actividades de catering para eventos y otros servicios de comidas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5621','Catering para eventos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5629','Actividades de otros servicios de comidas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('563','Expendio de bebidas alcohólicas para el consumo dentro del establecimiento')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5630','Expendio de bebidas alcohólicas para el consumo dentro del establecimiento')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('58','Actividades de edición')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('581','Edición de libros, publicaciones periódicas y otras actividades de edición')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5811','Edición de libros')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5812','Edición de directorios y listas de correo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5813','Edición de periódicos, revistas y otras publicaciones periódicas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5819','Otros trabajos de edición')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('582','Edición de programas de informática (software)')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5820','Edición de programas de informática (software)')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('59','Actividades cinematográficas, de video y producción de programas de televisión, grabación de sonido y edición de música')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('591','Actividades de producción de películas cinematográficas, video y producción de programas, anuncios y comerciales de televisión')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5911','Actividades de producción de películas cinematográficas, videos, programas, anuncios y comerciales de televisión')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5912','Actividades de posproducción de películas cinematográficas, videos, programas, anuncios y comerciales de televisión')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5913','Actividades de distribución de películas cinematográficas, videos, programas, anuncios y comerciales de televisión')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5914','Actividades de exhibición de películas cinematográficas y videos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('592','Actividades de grabación de sonido y edición de música')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('5920','Actividades de grabación de sonido y edición de música')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('60','Actividades de programación, transmisión y/o difusión')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('601','Actividades de programación y transmisión en el servicio de radiodifusión sonora')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6010','Actividades de programación y transmisión en el servicio de radiodifusión sonora')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('602','Actividades de programación y transmisión de televisión')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6020','Actividades de programación y transmisión de televisión')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('61','Telecomunicaciones')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('611','Actividades de telecomunicaciones alámbricas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6110','Actividades de telecomunicaciones alámbricas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('612','Actividades de telecomunicaciones inalámbricas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6120','Actividades de telecomunicaciones inalámbricas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('613','Actividades de telecomunicación satelital')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6130','Actividades de telecomunicación satelital')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('619','Otras actividades de telecomunicaciones')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6190','Otras actividades de telecomunicaciones')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('62','Desarrollo de sistemas informáticos (planificación, análisis, diseño, programación, pruebas), consultoría informática y actividades relacionadas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('620','Desarrollo de sistemas informáticos (planificación, análisis, diseño, programación, pruebas), consultoría informática y actividades relacionadas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6201','Actividades de desarrollo de sistemas informáticos (planificación, análisis, diseño, programación, pruebas)')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6202','Actividades de consultoría informática y actividades de administración de instalaciones informáticas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6209','Otras actividades de tecnologías de información y actividades de servicios informáticos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('63','Actividades de servicios de información')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('631','Procesamiento de datos, alojamiento (hosting) y actividades relacionadasgo portales web')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6311','Procesamiento de datos, alojamiento (hosting) y actividades relacionadas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6312','Portales web')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('639','Otras actividades de servicio de información')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6391','Actividades de agencias de noticias')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6399','Otras actividades de servicio de información ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('64','Actividades de servicios financieros, excepto las de seguros y de pensiones')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('641','Intermediación monetaria')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6411','Banco Central')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6412','Bancos comerciales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('642','Otros tipos de intermediación monetaria')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6421','Actividades de las corporaciones financieras')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6422','Actividades de las compañías de financiamiento')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6423','Banca de segundo piso')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6424','Actividades de las cooperativas financieras')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('643','Fideicomisos, fondos (incluye fondos de cesantías) y entidades financieras similares')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6431','Fideicomisos, fondos y entidades financieras similares')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6432','Fondos de cesantías')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('649','Otras actividades de servicio financiero, excepto las de seguros y pensiones')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6491','Leasing financiero (arrendamiento financiero)')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6492','Actividades financieras de fondos de empleados y otras formas asociativas del sector solidario')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6493','Actividades de compra de cartera o factoring')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6494','Otras actividades de distribución de fondos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6495','Instituciones especiales oficiales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6499','Otras actividades de servicio financiero, excepto las de seguros y pensiones ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('65','Seguros (incluso el reaseguro), seguros sociales y fondos de pensiones, excepto la seguridad social')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('651','Seguros y capitalización')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6511','Seguros generales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6512','Seguros de vida')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6513','Reaseguros')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6514','Capitalización')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('652','Servicios de seguros sociales de salud y riesgos profesionales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6521','Servicios de seguros sociales de salud')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6522','Servicios de seguros sociales de riesgos profesionales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('653','Servicios de seguros sociales de pensiones')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6531','Régimen de prima media con prestación definida (RPM)')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6532','Régimen de ahorro individual (RAI)')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('66','Actividades auxiliares de las actividades de servicios financieros')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('661','Actividades auxiliares de las actividades de servicios financieros, excepto las de seguros y pensiones')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6611','Administración de mercados financieros')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6612','Corretaje de valores y de contratos de productos básicos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6613','Otras actividades relacionadas con el mercado de valores')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6614','Actividades de las casas de cambio')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6615','Actividades de los profesionales de compra y venta de divisas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6619','Otras actividades auxiliares de las actividades de servicios financieros ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('662','Actividades de servicios auxiliares de los servicios de seguros y pensiones')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6621','Actividades de agentes y corredores de seguros')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6629','Evaluación de riesgos y daños, y otras actividades de servicios auxiliares')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('663','Actividades de administración de fondos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6630','Actividades de administración de fondos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('68','Actividades inmobiliarias')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('681','Actividades inmobiliarias realizadas con bienes propios o arrendados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6810','Actividades inmobiliarias realizadas con bienes propios o arrendados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('682','Actividades inmobiliarias realizadas a cambio de una retribución o por contrata')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6820','Actividades inmobiliarias realizadas a cambio de una retribución o por contrata')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('69','Actividades jurídicas y de contabilidad')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('691','Actividades jurídicas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6910','Actividades jurídicas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('692','Actividades de contabilidad, teneduría de libros, auditoría financiera y asesoría tributaria')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('6920','Actividades de contabilidad, teneduría de libros, auditoría financiera y asesoría tributaria')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('70','Actividades de administración empresarialgo actividades de consultoría de gestión')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('701','Actividades de administración empresarial')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7010','Actividades de administración empresarial')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('702','Actividades de consultaría de gestión')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7020','Actividades de consultaría de gestión')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('71','Actividades de arquitectura e ingenieríago ensayos y análisis técnicos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('711','Actividades de arquitectura e ingeniería y otras actividades conexas de consultoría técnica')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7110','Actividades de arquitectura e ingeniería y otras actividades conexas de consultoría técnica')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('712','Ensayos y análisis técnicos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7120','Ensayos y análisis técnicos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('72','Investigación científica y desarrollo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('721','Investigaciones y desarrollo experimental en el campo de las ciencias naturales y la ingeniería')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7210','Investigaciones y desarrollo experimental en el campo de las ciencias naturales y la ingeniería')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('722','Investigaciones y desarrollo experimental en el campo de las ciencias sociales y las humanidades')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7220','Investigaciones y desarrollo experimental en el campo de las ciencias sociales y las humanidades')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('73','Publicidad y estudios de mercado')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('731','Publicidad')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7310','Publicidad')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('732','Estudios de mercado y realización de encuestas de opinión pública')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7320','Estudios de mercado y realización de encuestas de opinión pública')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('74','Otras actividades profesionales, científicas y técnicas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('741','Actividades especializadas de diseño')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7410','Actividades especializadas de diseño')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('742','Actividades de fotografía')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7420','Actividades de fotografía')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('749','Otras actividades profesionales, científicas y técnicas ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7490','Otras actividades profesionales, científicas y técnicas ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('75','Actividades veterinarias')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('750','Actividades veterinarias')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7500','Actividades veterinarias')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('77','Actividades de alquiler y arrendamiento')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('771','Alquiler y arrendamiento de vehículos automotores')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7710','Alquiler y arrendamiento de vehículos automotores')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('772','Alquiler y arrendamiento de efectos personales y enseres domésticos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7721','Alquiler y arrendamiento de equipo recreativo y deportivo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7722','Alquiler de videos y discos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7729','Alquiler y arrendamiento de otros efectos personales y enseres domésticos ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('773','Alquiler y arrendamiento de otros tipos de maquinaria, equipo y bienes tangibles ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7730','Alquiler y arrendamiento de otros tipos de maquinaria, equipo y bienes tangibles ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('774','Arrendamiento de propiedad intelectual y productos similares, excepto obras protegidas por derechos de autor')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7740','Arrendamiento de propiedad intelectual y productos similares, excepto obras protegidas por derechos de autor')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('78','Actividades de empleo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('781','Actividades de agencias de empleo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7810','Actividades de agencias de empleo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('782','Actividades de agencias de empleo temporal')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7820','Actividades de agencias de empleo temporal')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('783','Otras actividades de suministro de recurso humano')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7830','Otras actividades de suministro de recurso humano')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('79','Actividades de las agencias de viajes, operadores turísticos, servicios de reserva y actividades relacionadas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('791','Actividades de las agencias de viajes y operadores turísticos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7911','Actividades de las agencias de viaje')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7912','Actividades de operadores turísticos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('799','Otros servicios de reserva y actividades relacionadas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('7990','Otros servicios de reserva y actividades relacionadas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('80','Actividades de seguridad e investigación privada')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('801','Actividades de seguridad privada')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8010','Actividades de seguridad privada')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('802','Actividades de servicios de sistemas de seguridad')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8020','Actividades de servicios de sistemas de seguridad')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('803','Actividades de detectives e investigadores privados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8030','Actividades de detectives e investigadores privados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('81','Actividades de servicios a edificios y paisajismo (jardines, zonas verdes)')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('811','Actividades combinadas de apoyo a instalaciones')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8110','Actividades combinadas de apoyo a instalaciones')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('812','Actividades de limpieza')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8121','Limpieza general interior de edificios')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8129','Otras actividades de limpieza de edificios e instalaciones industriales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('813','Actividades de paisajismo y servicios de mantenimiento conexos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8130','Actividades de paisajismo y servicios de mantenimiento conexos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('82','Actividades administrativas y de apoyo de oficina y otras actividades de apoyo a las empresas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('821','Actividades administrativas y de apoyo de oficina')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8211','Actividades combinadas de servicios administrativos de oficina')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8219','Fotocopiado, preparación de documentos y otras actividades especializadas de apoyo a oficina')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('822','Actividades de centros de llamadas (Call center)')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8220','Actividades de centros de llamadas (Call center)')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('823','Organización de convenciones y eventos comerciales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8230','Organización de convenciones y eventos comerciales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('829','Actividades de servicios de apoyo a las empresas ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8291','Actividades de agencias de cobranza y oficinas de calificación crediticia')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8292','Actividades de envase y empaque')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8299','Otras actividades de servicio de apoyo a las empresas ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('84','Administración pública y defensago planes de seguridad social de afiliación obligatoria')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('841','Administración del Estado y aplicación de la política económica y social de la comunidad')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8411','Actividades legislativas de la administración pública')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8412','Actividades ejecutivas de la administración pública')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8413','Regulación de las actividades de organismos que prestan servicios de salud, educativos, culturalesy otros servicios sociales, excepto servicios de seguridad social')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8414','Actividades reguladoras y facilitadoras de la actividad económica')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8415','Actividades de los otros órganos de control')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('842','Prestación de servicios a la comunidad en general')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8421','Relaciones exteriores')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8422','Actividades de defensa')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8423','Orden público y actividades de seguridad')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8424','Administración de justicia')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('843','Actividades de planes de seguridad social de afiliación obligatoria')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8430','Actividades de planes de seguridad social de afiliación obligatoria')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('85','Educación')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('851','Educación de la primera infancia, preescolar y básica primaria')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8511','Educación de la primera infancia')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8512','Educación preescolar')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8513','Educación básica primaria')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('852','Educación secundaria y de formación laboral')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8521','Educación básica secundaria')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8522','Educación media académica')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8523','Educación media técnica y de formación laboral')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('853','Establecimientos que combinan diferentes niveles de educación')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8530','Establecimientos que combinan diferentes niveles de educación')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('854','Educación superior')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8541','Educación técnica profesional')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8542','Educación tecnológica')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8543','Educación de instituciones universitarias o de escuelas tecnológicas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8544','Educación de universidades')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('855','Otros tipos de educación')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8551','Formación académica no formal')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8552','Enseñanza deportiva y recreativa')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8553','Enseñanza cultural')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8559','Otros tipos de educación ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('856','Actividades de apoyo a la educación')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8560','Actividades de apoyo a la educación')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('86','Actividades de atención de la salud humana')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('861','Actividades de hospitales y clínicas, con internación')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8610','Actividades de hospitales y clínicas, con internación')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('862','Actividades de práctica médica y odontológica, sin internación')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8621','Actividades de la práctica médica, sin internación')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8622','Actividades de la práctica odontológica')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('869','Otras actividades de atención relacionadas con la salud humana')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8691','Actividades de apoyo diagnóstico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8692','Actividades de apoyo terapéutico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8699','Otras actividades de atención de la salud humana')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('87','Actividades de atención residencial medicalizada')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('871','Actividades de atención residencial medicalizada de tipo general')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8710','Actividades de atención residencial medicalizada de tipo general')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('872','Actividades de atención residencial, para el cuidado de pacientes con retardo mental, enfermedad mental y consumo de sustancias psicoactivas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8720','Actividades de atención residencial, para el cuidado de pacientes con retardo mental, enfermedad mental y consumo de sustancias psicoactivas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('873','Actividades de atención en instituciones para el cuidado de personas mayores y/o discapacitadas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8730','Actividades de atención en instituciones para el cuidado de personas mayores y/o discapacitadas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('879','Otras actividades de atención en instituciones con alojamiento')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8790','Otras actividades de atención en instituciones con alojamiento')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('88','Actividades de asistencia social sin alojamiento')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('881','Actividades de asistencia social sin alojamiento para personas mayores y discapacitadas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8810','Actividades de asistencia social sin alojamiento para personas mayores y discapacitadas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('889','Otras actividades de asistencia social sin alojamiento')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('8890','Otras actividades de asistencia social sin alojamiento')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('90','Actividades creativas, artísticas y de entretenimiento')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('900','Actividades creativas, artísticas y de entretenimiento')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9001','Creación literaria')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9002','Creación musical')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9003','Creación teatral')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9004','Creación audiovisual')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9005','Artes plásticas y visuales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9006','Actividades teatrales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9007','Actividades de espectáculos musicales en vivo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9008','Otras actividades de espectáculos en vivo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('91','Actividades de bibliotecas, archivos, museos y otras actividades culturales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('910','Actividades de bibliotecas, archivos, museos y otras actividades culturales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9101','Actividades de bibliotecas y archivos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9102','Actividades y funcionamiento de museos, conservación de edificios y sitios históricos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9103','Actividades de jardines botánicos, zoológicos y reservas naturales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('92','Actividades de juegos de azar y apuestas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('920','Actividades de juegos de azar y apuestas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9200','Actividades de juegos de azar y apuestas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('93','Actividades deportivas y actividades recreativas y de esparcimiento')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('931','Actividades deportivas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9311','Gestión de instalaciones deportivas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9312','Actividades de clubes deportivos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9319','Otras actividades deportivas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('932','Otras actividades recreativas y de esparcimiento')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9321','Actividades de parques de atracciones y parques temáticos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9329','Otras actividades recreativas y de esparcimiento ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('94','Actividades de asociaciones')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('941','Actividades de asociaciones empresariales y de empleadores, y asociaciones profesionales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9411','Actividades de asociaciones empresariales y de empleadores')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9412','Actividades de asociaciones profesionales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('942','Actividades de sindicatos de empleados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9420','Actividades de sindicatos de empleados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('949','Actividades de otras asociaciones')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9491','Actividades de asociaciones religiosas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9492','Actividades de asociaciones políticas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9499','Actividades de otras asociaciones ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('95','Mantenimiento y reparación de computadores, efectos personales y enseres domésticos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('951','Mantenimiento y reparación de computadores y equipo de comunicaciones')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9511','Mantenimiento y reparación de computadores y de equipo periférico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9512','Mantenimiento y reparación de equipos de comunicación')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('952','Mantenimiento y reparación de efectos personales y enseres domésticos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9521','Mantenimiento y reparación de aparatos electrónicos de consumo')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9522','Mantenimiento y reparación de aparatos y equipos domésticos y de jardinería')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9523','Reparación de calzado y artículos de cuero')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9524','Reparación de muebles y accesorios para el hogar')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9529','Mantenimiento y reparación de otros efectos personales y enseres domésticos')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('96','Otras actividades de servicios personales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('960','Otras actividades de servicios personales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9601','Lavado y limpieza, incluso la limpieza en seco, de productos textiles y de piel')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9602','Peluquería y otros tratamientos de belleza')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9603','Pompas fúnebres y actividades relacionadas')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9609','Otras actividades de servicios personales ncp')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('97','Actividades de los hogares individuales como empleadores de personal doméstico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('970','Actividades de los hogares individuales como empleadores de personal doméstico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9700','Actividades de los hogares individuales como empleadores de personal doméstico')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('98','Actividades no diferenciadas de los hogares individuales como productores de bienes y servicios para uso propio')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('981','Actividades no diferenciadas de los hogares individuales como productores de bienes para uso propio')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9810','Actividades no diferenciadas de los hogares individuales como productores de bienes para uso propio')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('982','Actividades no diferenciadas de los hogares individuales como productores de servicios para uso propio')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9820','Actividades no diferenciadas de los hogares individuales como productores de servicios para uso propio')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('99','Actividades de organizaciones y entidades extraterritoriales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('990','Actividades de organizaciones y entidades extraterritoriales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('9900','Actividades de organizaciones y entidades extraterritoriales')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0010','Asalariados')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0081','Personas Naturales sin Actividad Económica')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0082','Personas Naturales Subsidiadas por Terceros')
go

INSERT INTO $$COMPANIA$$.U_ACTIV_ECONOMICA(U_CODIGO, U_DESCRIP)VALUES('0090','Rentistas de Capital, solo para personas naturales')
go

/* --------- Se crea IF de 941-36AS ------------ */

IF EXISTS(
SELECT 1 FROM ERPADMIN.CONJUNTO WHERE (UPPER(PAIS) = 'MEXICO' OR UPPER(PAIS) = 'GUATEMALA' OR UPPER(PAIS) = 'MÉXICO')
AND CONJUNTO =  '$$COMPANIA$$'
)
BEGIN

/*METODO DE PAGO*/
CREATE TABLE $$COMPANIA$$.U_METODO_PAGO (
    U_CODIGO VARCHAR(4) NOT NULL,
    U_DESCRIP VARCHAR(100) NULL
)
    
/*Inserta la tabla como tabla de usuario*/
IF NOT  EXISTS(
SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'CONDICION_PAGO'
)
BEGIN
    insert into $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('CONDICION_PAGO','Condiciones de Pago','','E','Condiciones de Pago')
END

IF NOT  EXISTS(
SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_METODO_PAGO'
)
BEGIN
    insert into $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('U_METODO_PAGO','METODO_PAGO','','U','METODO_PAGO')
END

/*Insertan los UDF de usuario*/

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('U_METODO_PAGO','U_CODIGO','Codigo', 'A' ,1, 'N', NULL,'N',NULL , 4)

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('U_METODO_PAGO','U_DESCRIP','Descripción', 'A' ,2, 'S', NULL,'N',NULL , 100)

declare @ORDEN INT
declare @ORDEN1 INT
/*Se Inserta el UDF en articulo*/

SET @ORDEN = ( SELECT ISNULL(MAX(ORDEN),0) +1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'CONDICION_PAGO' )

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('CONDICION_PAGO','METODO_PAGO','METODO_PAGO', 'A' ,@ORDEN, 'S', NULL,'T','U_METODO_PAGO' , 20)

/*IMPUESTOS*/

CREATE TABLE $$COMPANIA$$.U_IMPUESTO
(
U_CODIGO VARCHAR(4) NOT NULL,
U_DESCRIP VARCHAR(100) NULL,
)

/*Inserta la tabla IMPUESTO como tabla de usuario*/
IF NOT  EXISTS(
SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'IMPUESTO'
)
BEGIN
    insert into $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('IMPUESTO','Códigos de Impuesto','','E','Códigos de Impuesto')
END

/*Inserta la tabla RETENCIONES como tabla de usuario*/
IF NOT  EXISTS(
SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'RETENCIONES'
)
BEGIN
    insert into $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('RETENCIONES','Tipos de Retenciones','','E','Tipos de Retenciones')
END

/*Inserta la tabla como tabla de usuario*/
IF NOT  EXISTS(
SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_IMPUESTO'
)
BEGIN
    insert into $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('U_IMPUESTO','IMPUESTO','','U','IMPUESTO')
END

/*Insertan los UDF de usuario*/

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('U_IMPUESTO','U_CODIGO','Codigo', 'A' ,1, 'N', NULL,'N',NULL , 4)

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('U_IMPUESTO','U_DESCRIP','Descripción', 'A' ,2, 'S', NULL,'N',NULL , 20)

/*Se Inserta el UDF en IMPUESTO*/

SET @ORDEN = ( SELECT ISNULL(MAX(ORDEN),0) +1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'IMPUESTO')

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS,VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('IMPUESTO','IMPUESTO1_SAT','IMPUESTO1_SAT', 'A' ,@ORDEN, 'S', NULL,'T','U_IMPUESTO' , 3)

SET @ORDEN = @ORDEN + 1

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('IMPUESTO','IMPUESTO2_SAT','IMPUESTO2_SAT', 'A' ,@ORDEN, 'S', NULL,'T','U_IMPUESTO' , 3)

/*Se Inserta el UDF en RETENCIONES*/

declare @ORDENR INT

SET @ORDENR = ( SELECT ISNULL(MAX(ORDEN),0) +1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'RETENCIONES' )

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('RETENCIONES','IMPUESTO_SAT','IMPUESTO_SAT', 'A' ,@ORDENR, 'S', NULL,'T','U_IMPUESTO' , 3)

 /* CLAVE UNIDAD */

 CREATE TABLE $$COMPANIA$$.U_CLAVE_UNIDAD
(
U_CODIGO VARCHAR(4) NOT NULL,
U_DESCRIP VARCHAR(100) NULL,
)

/*Inserta la tabla como tabla de usuario*/
IF NOT  EXISTS(
SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_CLAVE_UNIDAD'
)
BEGIN
    insert into $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('U_CLAVE_UNIDAD','CLAVE_UNIDAD','','U','CLAVE_UNIDAD')
END

IF NOT  EXISTS(
SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'ARTICULO'
)
BEGIN
    insert into $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('ARTICULO','Artículos','','E','Artículos')
END

IF NOT  EXISTS(
SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'DOCUMENTOS_CC'
)
BEGIN
    insert into $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('DOCUMENTOS_CC','Documentos','','E','Documentos')
END

/*Insertan los UDF de usuario*/

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('U_CLAVE_UNIDAD','U_CODIGO','Codigo', 'A' ,1, 'N', NULL,'N',NULL , 4)

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('U_CLAVE_UNIDAD','U_DESCRIP','Descripción', 'A' ,2, 'S', NULL,'N',NULL , 20)

/*Se Inserta el UDF en articulo*/

SET @ORDEN = ( SELECT ISNULL(MAX(ORDEN),0) +1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'ARTICULO' )

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('ARTICULO','CLAVE_UNIDAD','CLAVE_UNIDAD', 'A' ,@ORDEN, 'S', NULL,'T','U_CLAVE_UNIDAD' , 20)

SET @ORDEN1 = ( SELECT ISNULL(MAX(ORDEN),0) +1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'DOCUMENTOS_CC' )

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('DOCUMENTOS_CC','CLAVE_UNIDAD','CLAVE_UNIDAD', 'A' ,@ORDEN1, 'S', NULL,'T','U_CLAVE_UNIDAD' , 20)

 /* CLAVE_PROD_SERV */
 
CREATE TABLE $$COMPANIA$$.U_CLAVE_PROD_SERV
(
U_CODIGO VARCHAR(20) NOT NULL,
U_DESCRIP VARCHAR(100) NULL,
U_FECHA_INICIO DATE NULL,
U_FECHA_FIN DATE NULL,
U_INCLUIR_IVA VARCHAR(20) NULL,
U_INCLUIR_IEPS VARCHAR(20) NULL
)

/*Inserta la tabla como tabla de usuario*/
IF NOT  EXISTS(
SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'ARTICULO'
)
BEGIN
    insert into $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('ARTICULO','Artículos','','E','Artículos')
END

IF NOT  EXISTS(
SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'DOCUMENTOS_CC'
)
BEGIN
    insert into $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('DOCUMENTOS_CC','Documentos','','E','Documentos')
END

IF NOT  EXISTS(
SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_CLAVE_PROD_SERV'
)
BEGIN
    insert into $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('U_CLAVE_PROD_SERV','CLAVE_PROD_SERV','','U','CLAVE_PROD_SERV')
END

/*Insertan los UDF de usuario*/

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('U_CLAVE_PROD_SERV','U_CODIGO','Codigo', 'A' ,1, 'N', NULL,'N',NULL , 20)

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('U_CLAVE_PROD_SERV','U_DESCRIP','Descripción', 'A' ,2, 'S', NULL,'N',NULL , 100)

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('U_CLAVE_PROD_SERV','FECHA_INICIO','Fecha inicio vigencia ', 'F' ,3, 'S', '08/05/2017','N',NULL , 0)

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('U_CLAVE_PROD_SERV','FECHA_FIN','Fecha fin vigencia', 'F' ,4, 'S', '08/05/2017' ,'N',NULL , 0)

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('U_CLAVE_PROD_SERV','INCLUIR_IVA','Incluir IVA Traslado', 'A' ,5, 'S', NULL,'N',NULL , 20)

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('U_CLAVE_PROD_SERV','INCLUIR_IEPS','Incluir IEPS Traslado', 'A' ,6, 'S', NULL,'N',NULL , 20)

/*Se Inserta el UDF en articulo*/

SET @ORDEN = ( SELECT ISNULL(MAX(ORDEN),0) +1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'ARTICULO' )

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('ARTICULO','CLAVE_PROD_SERV','CLAVE_PROD_SERV', 'A' ,@ORDEN, 'S', NULL,'T','U_CLAVE_PROD_SERV' , 200)

SET @ORDEN1 = ( SELECT ISNULL(MAX(ORDEN),0) +1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'DOCUMENTOS_CC' )

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('DOCUMENTOS_CC','CLAVE_PROD_SERV','CLAVE_PROD_SERV', 'A' ,@ORDEN1, 'S', NULL,'T','U_CLAVE_PROD_SERV' , 200)

 /* FORMA DE PAGO*/
CREATE TABLE $$COMPANIA$$.U_FORMA_PAGO
(
U_CODIGO VARCHAR(4) NOT NULL,
U_DESCRIP VARCHAR(100) NULL,
)

/*Inserta la tabla como tabla de usuario*/
IF NOT  EXISTS(
SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'CONDICION_PAGO'
)
BEGIN
    insert into $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('CONDICION_PAGO','Condiciones de Pago','','E','Condiciones de Pago')
END

IF NOT  EXISTS(
SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_FORMA_PAGO'
)
BEGIN
    insert into $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('U_FORMA_PAGO','FORMA_PAGO','','U','FORMA_PAGO')
END

/*Insertan los UDF de usuario*/

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('U_FORMA_PAGO','U_CODIGO','Codigo', 'A' ,1, 'N', NULL,'N',NULL , 4)

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('U_FORMA_PAGO','U_DESCRIP','Descripción', 'A' ,2, 'S', NULL,'N',NULL , 100)

/*Se Inserta el UDF en CONDICIÓN DE PAGO*/

SET @ORDEN = ( SELECT ISNULL(MAX(ORDEN),0) +1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'CONDICION_PAGO' )

INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('CONDICION_PAGO','FORMA_PAGO','FORMA_PAGO', 'A' ,@ORDEN, 'S', NULL,'T','U_FORMA_PAGO' , 20)
END
go

IF EXISTS(
SELECT 1 FROM ERPADMIN.CONJUNTO WHERE (UPPER(PAIS) = 'MEXICO' OR UPPER(PAIS) = 'MÉXICO')
AND CONJUNTO =  '$$COMPANIA$$'
)
BEGIN

DECLARE @ORDEN INT
DECLARE @ORDEN2 INT
DECLARE @HERMANO INT

/*Inserta la tabla UDF U_CLAVE_PROD_SERV al menú de artículos*/
SET @ORDEN = ( SELECT ISNULL(MAX(accion),0)+1 FROM ERPADMIN.ACCION)
INSERT INTO ERPADMIN.ACCION (ACCION, NOMBREACCION, DESCRIPCION, NOMBRECONSTANTE, ESMODULO, ESESTANDAR,TIPO, SUBTIPO , TABLA , INVOCACION)
VALUES  (@ORDEN, 'Catálogo de productos / servicios' , 'Tabla UDF para almacenar el catálogo de productos / servicios de la SAT', 'U_CLAVE_PROD_SERV','N', 'S' , 'F' , 'N', 'U_CLAVE_PROD_SERV' , 'WinFormDotNet_v2:Softland.ERP.AS.Mantenimientos.UDE;Softland.ERP.AS.UI')

SET @HERMANO = ( SELECT ISNULL(MAX(NUMEROHERMANO),0) +1 FROM ERPADMIN.PARENTESCO where PADRE = 3261)
SET @ORDEN2 = ( SELECT ISNULL(MAX(accion),0) FROM ERPADMIN.ACCION where NOMBRECONSTANTE = 'U_CLAVE_PROD_SERV')
INSERT INTO ERPADMIN.PARENTESCO (ACCION, PADRE, NUMEROHERMANO)
VALUES(@ORDEN2,3261,@HERMANO)

/*Inserta la tabla UDF U_CLAVE_UNIDAD al menú de artículos*/
SET @ORDEN = @ORDEN + 1
INSERT INTO ERPADMIN.ACCION (ACCION, NOMBREACCION, DESCRIPCION, NOMBRECONSTANTE, ESMODULO, ESESTANDAR,TIPO, SUBTIPO , TABLA , INVOCACION)
VALUES  (@ORDEN, 'Catálogo de unidades de medida' , 'Tabla UDF para almacenar el catálogo de unidades de medida', 'U_CLAVE_UNIDAD','N', 'S' , 'F' , 'N', 'U_CLAVE_UNIDAD' , 'WinFormDotNet_v2:Softland.ERP.AS.Mantenimientos.UDE;Softland.ERP.AS.UI')

SET @HERMANO = @HERMANO + 1
SET @ORDEN2 = ( SELECT ISNULL(MAX(accion),0) FROM ERPADMIN.ACCION where NOMBRECONSTANTE = 'U_CLAVE_UNIDAD')
INSERT INTO ERPADMIN.PARENTESCO (ACCION, PADRE, NUMEROHERMANO)
VALUES(@ORDEN2,3261,@HERMANO)

/*Inserta la tabla UDF U_FORMA_PAGO al menú de artículos*/
SET @ORDEN = @ORDEN + 1
INSERT INTO ERPADMIN.ACCION (ACCION, NOMBREACCION, DESCRIPCION, NOMBRECONSTANTE, ESMODULO, ESESTANDAR,TIPO, SUBTIPO , TABLA , INVOCACION)
VALUES  (@ORDEN, 'Catálogo de formas de pago' , 'Tabla UDF para almacenar el Catálogo de formas de pago de la SAT', 'U_FORMA_PAGO','N', 'S' , 'F' , 'N', 'U_FORMA_PAGO' , 'WinFormDotNet_v2:Softland.ERP.AS.Mantenimientos.UDE;Softland.ERP.AS.UI')

SET @HERMANO = ( SELECT ISNULL(MAX(NUMEROHERMANO),0) +1 FROM ERPADMIN.PARENTESCO where PADRE = 8)
SET @ORDEN2 = ( SELECT ISNULL(MAX(accion),0) FROM ERPADMIN.ACCION where NOMBRECONSTANTE = 'U_FORMA_PAGO')
INSERT INTO ERPADMIN.PARENTESCO (ACCION, PADRE, NUMEROHERMANO)
VALUES(@ORDEN2,8,@HERMANO)

/*Inserta la tabla UDF U_METODO_PAGO al menú de artículos*/
SET @ORDEN = @ORDEN + 1
INSERT INTO ERPADMIN.ACCION (ACCION, NOMBREACCION, DESCRIPCION, NOMBRECONSTANTE, ESMODULO, ESESTANDAR,TIPO, SUBTIPO , TABLA , INVOCACION)
VALUES  (@ORDEN, 'Catálogo de Método de Pago' , 'Tabla UDF para almacenar el catálogo de Método de Pago de la SAT', 'U_METODO_PAGO','N', 'S' , 'F' , 'N', 'U_METODO_PAGO' , 'WinFormDotNet_v2:Softland.ERP.AS.Mantenimientos.UDE;Softland.ERP.AS.UI')

SET @HERMANO = @HERMANO + 1
SET @ORDEN2 = ( SELECT ISNULL(MAX(accion),0) FROM ERPADMIN.ACCION where NOMBRECONSTANTE = 'U_METODO_PAGO')
INSERT INTO ERPADMIN.PARENTESCO (ACCION, PADRE, NUMEROHERMANO)
VALUES(@ORDEN2,8,@HERMANO)

/*Inserta la tabla UDF U_METODO_PAGO al menú de artículos*/
SET @ORDEN = @ORDEN + 1
INSERT INTO ERPADMIN.ACCION (ACCION, NOMBREACCION, DESCRIPCION, NOMBRECONSTANTE, ESMODULO, ESESTANDAR,TIPO, SUBTIPO , TABLA , INVOCACION)
VALUES  (@ORDEN, 'Catálogo de impuestos' , 'Tabla UDF para almacenar el catálogo de impuestos de la SAT', 'U_IMPUESTO','N', 'S' , 'F' , 'N', 'U_IMPUESTO' , 'WinFormDotNet_v2:Softland.ERP.AS.Mantenimientos.UDE;Softland.ERP.AS.UI')

SET @HERMANO = @HERMANO + 1
SET @ORDEN2 = ( SELECT ISNULL(MAX(accion),0) FROM ERPADMIN.ACCION where NOMBRECONSTANTE = 'U_IMPUESTO')
INSERT INTO ERPADMIN.PARENTESCO (ACCION, PADRE, NUMEROHERMANO)
VALUES(@ORDEN2,8,@HERMANO)

END
go

/* --------- Se crea IF de 942-03AS ------------ */

IF EXISTS(
SELECT 1 FROM ERPADMIN.CONJUNTO WHERE (UPPER(PAIS) = 'MEXICO' OR UPPER(PAIS) = 'GUATEMALA' OR UPPER(PAIS) = 'MÉXICO')
AND CONJUNTO =  '$$COMPANIA$$'
)
BEGIN

/*U_TIPO_RELACION*/


CREATE TABLE $$COMPANIA$$.U_TIPO_RELACION
(
U_CODIGO VARCHAR(20) NOT NULL,
U_DESCRIP VARCHAR(100) NULL
)

	


/*Inserta la tabla como tabla de usuario*/


IF NOT  EXISTS(
SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'Documentos_CC'
)

BEGIN 
	insert into $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('Documentos_CC','TIPO_RELACION','','E','Documentos')

END



IF NOT  EXISTS(
SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_TIPO_RELACION'
)

BEGIN
	insert into $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('U_TIPO_RELACION','TIPO_RELACION','','U','TIPO_RELACION')

END



/*Insertan los UDF de usuario*/


INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('U_TIPO_RELACION','U_CODIGO','Codigo', 'A' ,1, 'N', NULL,'N',NULL , 20)




INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('U_TIPO_RELACION','U_DESCRIP','Descripción', 'A' ,2, 'S', NULL,'N',NULL , 100)




/*Se Inserta el UDF en tipo_relacion */


declare @ORDEN1 INT



SET @ORDEN1 = ( SELECT ISNULL(MAX(ORDEN),0) +1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'DOCUMENTOS_CC' );



INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT,TIPO_FUENTE, UDT, LARGO) VALUES ('DOCUMENTOS_CC','TIPO_RELACION','TIPO_RELACION', 'A' ,@ORDEN1, 'S', NULL,'T','U_TIPO_RELACION' , 200);

END
go

IF EXISTS(
SELECT 1 FROM ERPADMIN.CONJUNTO WHERE (UPPER(PAIS) = 'MEXICO' OR UPPER(PAIS) = 'MÉXICO')
AND CONJUNTO =  '$$COMPANIA$$'
)
BEGIN


DECLARE @ORDEN INT
DECLARE @ORDEN2 INT
DECLARE @HERMANO INT

/*Inserta la tabla UDF U_CLAVE_PROD_SERV al menú de artículos*/
SET @ORDEN = ( SELECT ISNULL(MAX(accion),0)+1 FROM ERPADMIN.ACCION)

INSERT INTO ERPADMIN.ACCION (ACCION, NOMBREACCION, DESCRIPCION, NOMBRECONSTANTE, ESMODULO, ESESTANDAR,TIPO, SUBTIPO , TABLA , INVOCACION)
VALUES	(@ORDEN, 'Catálogo de tipos de relación' , 'Tabla UDF para almacenar los tipos de relaciones entre documentos de la SAT', 'U_TIPO_RELACION','N', 'S' , 'F' , 'N', 'U_TIPO_RELACION' , 'WinFormDotNet_v2:Softland.ERP.AS.Mantenimientos.UDE;Softland.ERP.AS.UI');

SET @HERMANO = ( SELECT ISNULL(MAX(NUMEROHERMANO),0) +1 FROM ERPADMIN.PARENTESCO where PADRE = 8)
SET @ORDEN2 = ( SELECT ISNULL(MAX(accion),0) FROM ERPADMIN.ACCION where NOMBRECONSTANTE = 'U_TIPO_RELACION')
INSERT INTO ERPADMIN.PARENTESCO (ACCION, PADRE, NUMEROHERMANO)
VALUES(@ORDEN2,8,@HERMANO)


END
go

/* --------- Se crea IF de 944-23AS ------------ */


IF EXISTS(
SELECT 1 FROM ERPADMIN.CONJUNTO WHERE ( UPPER(PAIS) = 'COLOMBIA' ) AND CONJUNTO =  '$$COMPANIA$$'
)
BEGIN

	DECLARE @ORDEN INT
	DECLARE @ORDEN2 INT
	DECLARE @HERMANO INT

	/* TABLA DE USUARIO DE TIPO DE DOCUMENTOS DE IDENTIDAD */
	CREATE TABLE $$COMPANIA$$.U_TIPO_DOC_IDENT
	(
		U_CODIGO  VARCHAR(4)	NOT NULL,
		U_DESCRIP VARCHAR(100)  NULL
	)

	IF NOT  EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_TIPO_DOC_IDENT'
	)
	BEGIN
		INSERT INTO $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('U_TIPO_DOC_IDENT','Tipo de documentos de identidad',null,'U','Tipo de documento de identidad');
	END

	IF NOT  EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'TIPO_NIT'
	)
	BEGIN
		INSERT INTO $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('TIPO_NIT','Tipos de NITs','','E','Tipos de NITs');
	END

	INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO, ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('U_TIPO_DOC_IDENT', 'U_CODIGO', 'Codigo', 'A', 1, 'N', NULL, 'N', NULL, 4);
	INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO, ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('U_TIPO_DOC_IDENT', 'U_DESCRIP', 'Descripción', 'A', 2, 'S', NULL, 'N', NULL, 100);

	SET @ORDEN = ( SELECT ISNULL(MAX(accion),0)+1 FROM ERPADMIN.ACCION);
	INSERT INTO ERPADMIN.ACCION (ACCION, NOMBREACCION, DESCRIPCION, NOMBRECONSTANTE, ESMODULO, ESESTANDAR, TIPO, SUBTIPO, TABLA , INVOCACION)
	VALUES	(@ORDEN, 'Tipo de documentos de identidad' , 'Tabla UDF para almacenar los tipo de documentos de identidad', 'U_TIPO_DOC_IDENT','N', 'S' , 'F' , 'N', 'U_TIPO_DOC_IDENT', 'WinFormDotNet_v2:Softland.ERP.AS.Mantenimientos.UDE;Softland.ERP.AS.UI');

	SET @HERMANO = ( SELECT ISNULL(MAX(NUMEROHERMANO),0) +1 FROM ERPADMIN.PARENTESCO where PADRE = 8);
	SET @ORDEN2 = ( SELECT ISNULL(MAX(accion),0) FROM ERPADMIN.ACCION where NOMBRECONSTANTE = 'U_TIPO_DOC_IDENT');
	INSERT INTO ERPADMIN.PARENTESCO (ACCION, PADRE, NUMEROHERMANO) VALUES(@ORDEN2, 8, @HERMANO);

	/*Se incluye el UDF en el mantenimiento de tipos de nit*/
	SET @ORDEN = ( SELECT ISNULL(MAX(ORDEN),0) +1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'TIPO_NIT' )

	INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('TIPO_NIT', 'TIPO_DOCUMENTO_IDENTIDAD', 'TIPO_DOCUMENTO_IDENTIDAD', 'A', @ORDEN, 'S', NULL, 'T', 'U_TIPO_DOC_IDENT', 4);

	UPDATE erpadmin.ACCION SET TABLA = 'TIPO_NIT' WHERE ACCION = 3827

	/* TABLA DE USUARIO DE CONCEPTOS DE NOTAS DE CRÉDITO */
	CREATE TABLE $$COMPANIA$$.U_CONCEP_NOTA_CRE
	(
		U_CODIGO  VARCHAR(4)	NOT NULL,
		U_DESCRIP VARCHAR(100)  NULL
	)

	IF NOT  EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_CONCEP_NOTA_CRE'
	)
	BEGIN
		INSERT INTO $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('U_CONCEP_NOTA_CRE','Conceptos de notas de crédito',null,'U','Conceptos de notas de crédito');
	END

	IF NOT  EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'SUBTIPO_DOC_CC'
	)
	BEGIN
		INSERT INTO $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('SUBTIPO_DOC_CC','Subtipo de documentos de CxC','','E','Subtipo de documentos de CxC');
	END

	INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO, ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('U_CONCEP_NOTA_CRE', 'U_CODIGO', 'Codigo', 'A', 1, 'N', NULL, 'N', NULL, 4);
	INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO, ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('U_CONCEP_NOTA_CRE', 'U_DESCRIP', 'Descripción', 'A', 2, 'S', NULL, 'N', NULL, 100);

	SET @ORDEN = ( SELECT ISNULL(MAX(accion),0)+1 FROM ERPADMIN.ACCION);
	INSERT INTO ERPADMIN.ACCION (ACCION, NOMBREACCION, DESCRIPCION, NOMBRECONSTANTE, ESMODULO, ESESTANDAR, TIPO, SUBTIPO, TABLA , INVOCACION)
	VALUES	(@ORDEN, 'Conceptos de notas de crédito' , 'Tabla UDF para almacenar los conceptos de notas de crédito', 'U_CONCEP_NOTA_CRE','N', 'S' , 'F' , 'N', 'U_CONCEP_NOTA_CRE', 'WinFormDotNet_v2:Softland.ERP.AS.Mantenimientos.UDE;Softland.ERP.AS.UI');

	SET @HERMANO = ( SELECT ISNULL(MAX(NUMEROHERMANO),0) +1 FROM ERPADMIN.PARENTESCO where PADRE = 746);
	SET @ORDEN2 = ( SELECT ISNULL(MAX(accion),0) FROM ERPADMIN.ACCION where NOMBRECONSTANTE = 'U_CONCEP_NOTA_CRE');
	INSERT INTO ERPADMIN.PARENTESCO (ACCION, PADRE, NUMEROHERMANO) VALUES(@ORDEN2, 746, @HERMANO);

	SET @HERMANO = ( SELECT ISNULL(MAX(NUMEROHERMANO),0) +1 FROM ERPADMIN.PARENTESCO where PADRE = 145);
	SET @ORDEN2 = ( SELECT ISNULL(MAX(accion),0) FROM ERPADMIN.ACCION where NOMBRECONSTANTE = 'U_CONCEP_NOTA_CRE');
	INSERT INTO ERPADMIN.PARENTESCO (ACCION, PADRE, NUMEROHERMANO) VALUES(@ORDEN2, 145, @HERMANO);

	/*Se incluye el UDF en el mantenimiento de subtipo de documentos de cxc */
	SET @ORDEN = ( SELECT ISNULL(MAX(ORDEN),0) +1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'SUBTIPO_DOC_CC' )

	INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('SUBTIPO_DOC_CC', 'CONCEPTO_NC', 'CONCEPTO_NC', 'A', @ORDEN, 'S', NULL, 'T', 'U_CONCEP_NOTA_CRE', 4);

	/* TABLA DE USUARIO DE CONCEPTOS DE NOTAS DE DÉBITO */
	CREATE TABLE $$COMPANIA$$.U_CONCEP_NOTA_DEB
	(
		U_CODIGO  VARCHAR(4)	NOT NULL,
		U_DESCRIP VARCHAR(100)  NULL
	)

	IF NOT  EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_CONCEP_NOTA_DEB'
	)
	BEGIN
		INSERT INTO $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('U_CONCEP_NOTA_DEB','Conceptos de notas de débito',null,'U','Conceptos de notas de débito');
	END


	INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO, ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('U_CONCEP_NOTA_DEB', 'U_CODIGO', 'Codigo', 'A', 1, 'N', NULL, 'N', NULL, 4);
	INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO, ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('U_CONCEP_NOTA_DEB', 'U_DESCRIP', 'Descripción', 'A', 2, 'S', NULL, 'N', NULL, 100);

	SET @ORDEN = ( SELECT ISNULL(MAX(accion),0)+1 FROM ERPADMIN.ACCION);
	INSERT INTO ERPADMIN.ACCION (ACCION, NOMBREACCION, DESCRIPCION, NOMBRECONSTANTE, ESMODULO, ESESTANDAR, TIPO, SUBTIPO, TABLA , INVOCACION)
	VALUES	(@ORDEN, 'Conceptos de notas de débito' , 'Tabla UDF para almacenar los conceptos de notas de débito', 'U_CONCEP_NOTA_DEB','N', 'S' , 'F' , 'N', 'U_CONCEP_NOTA_DEB', 'WinFormDotNet_v2:Softland.ERP.AS.Mantenimientos.UDE;Softland.ERP.AS.UI');

	SET @HERMANO = ( SELECT ISNULL(MAX(NUMEROHERMANO),0) +1 FROM ERPADMIN.PARENTESCO where PADRE = 746);
	SET @ORDEN2 = ( SELECT ISNULL(MAX(accion),0) FROM ERPADMIN.ACCION where NOMBRECONSTANTE = 'U_CONCEP_NOTA_DEB');
	INSERT INTO ERPADMIN.PARENTESCO (ACCION, PADRE, NUMEROHERMANO) VALUES(@ORDEN2, 746, @HERMANO);

	SET @HERMANO = ( SELECT ISNULL(MAX(NUMEROHERMANO),0) +1 FROM ERPADMIN.PARENTESCO where PADRE = 145);
	SET @ORDEN2 = ( SELECT ISNULL(MAX(accion),0) FROM ERPADMIN.ACCION where NOMBRECONSTANTE = 'U_CONCEP_NOTA_DEB');
	INSERT INTO ERPADMIN.PARENTESCO (ACCION, PADRE, NUMEROHERMANO) VALUES(@ORDEN2, 145, @HERMANO);

	/*Se incluye el UDF en el mantenimiento de subtipo de documentos de cxp */
	SET @ORDEN = ( SELECT ISNULL(MAX(ORDEN),0) +1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'SUBTIPO_DOC_CC' )

	INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('SUBTIPO_DOC_CC', 'CONCEPTO_ND', 'CONCEPTO_ND', 'A', @ORDEN, 'S', NULL, 'T', 'U_CONCEP_NOTA_DEB', 4);

	/* TABLA DE USUARIO DE CONCEPTOS DE FACTURAS */
	
	CREATE TABLE $$COMPANIA$$.U_CONCEP_FAC
	(
		U_CODIGO  VARCHAR(4)	NOT NULL,
		U_DESCRIP VARCHAR(100)  NULL
	)

	IF NOT  EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_CONCEP_FAC'
	)
	BEGIN
		INSERT INTO $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('U_CONCEP_FAC','Conceptos de factura',null,'U','Conceptos de factura');
	END

	INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO, ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('U_CONCEP_FAC', 'U_CODIGO', 'Codigo', 'A', 1, 'N', NULL, 'N', NULL, 4);
	INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO, ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('U_CONCEP_FAC', 'U_DESCRIP', 'Descripción', 'A', 2, 'S', NULL, 'N', NULL, 100);

	SET @ORDEN = ( SELECT ISNULL(MAX(accion),0)+1 FROM ERPADMIN.ACCION);
	INSERT INTO ERPADMIN.ACCION (ACCION, NOMBREACCION, DESCRIPCION, NOMBRECONSTANTE, ESMODULO, ESESTANDAR, TIPO, SUBTIPO, TABLA , INVOCACION)
	VALUES	(@ORDEN, 'Conceptos de facturas' , 'Tabla UDF para almacenar los conceptos de facturas', 'U_CONCEP_FAC','N', 'S' , 'F' , 'N', 'U_CONCEP_FAC', 'WinFormDotNet_v2:Softland.ERP.AS.Mantenimientos.UDE;Softland.ERP.AS.UI');

	SET @HERMANO = ( SELECT ISNULL(MAX(NUMEROHERMANO),0) +1 FROM ERPADMIN.PARENTESCO where PADRE = 746);
	SET @ORDEN2 = ( SELECT ISNULL(MAX(accion),0) FROM ERPADMIN.ACCION where NOMBRECONSTANTE = 'U_CONCEP_FAC');
	INSERT INTO ERPADMIN.PARENTESCO (ACCION, PADRE, NUMEROHERMANO) VALUES(@ORDEN2, 746, @HERMANO);

	SET @HERMANO = ( SELECT ISNULL(MAX(NUMEROHERMANO),0) +1 FROM ERPADMIN.PARENTESCO where PADRE = 145);
	SET @ORDEN2 = ( SELECT ISNULL(MAX(accion),0) FROM ERPADMIN.ACCION where NOMBRECONSTANTE = 'U_CONCEP_FAC');
	INSERT INTO ERPADMIN.PARENTESCO (ACCION, PADRE, NUMEROHERMANO) VALUES(@ORDEN2, 145, @HERMANO);

	/* Se incluye el UDF en el mantenimiento de subtipo de documentos de cxp */
	SET @ORDEN = ( SELECT ISNULL(MAX(ORDEN),0) +1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'SUBTIPO_DOC_CC' )

	INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('SUBTIPO_DOC_CC', 'CONCEPTO_FAC', 'CONCEPTO_FAC', 'A', @ORDEN, 'S', NULL, 'T', 'U_CONCEP_FAC', 4);

	/* TABLA DE USUARIO DE IMPUESTOS */
	IF NOT  EXISTS(
	SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '$$COMPANIA$$' AND  TABLE_NAME = 'U_IMPUESTO'
	)
	BEGIN
		CREATE TABLE $$COMPANIA$$.U_IMPUESTO
		(
			U_CODIGO  VARCHAR(4)	NOT NULL,
			U_DESCRIP VARCHAR(100)  NULL
		)
	END

	IF NOT  EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_IMPUESTO'
	)
	BEGIN
		INSERT INTO $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('U_IMPUESTO','IMPUESTO','','U','IMPUESTO');
	END

	IF NOT  EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'IMPUESTO'
	)
	BEGIN
		INSERT INTO $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('IMPUESTO','Impuestos','','E','Impuestos');
	END

	IF NOT  EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'RETENCIONES'
	)
	BEGIN
		INSERT INTO $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('RETENCIONES','Retenciones','','E','Retenciones');
	END

	IF NOT  EXISTS(
	SELECT 1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'U_IMPUESTO'
	)
	BEGIN
		INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO, ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('U_IMPUESTO', 'U_CODIGO', 'Codigo', 'A', 1, 'N', NULL, 'N', NULL, 4);
		INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO, ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('U_IMPUESTO', 'U_DESCRIP', 'Descripción', 'A', 2, 'S', NULL, 'N', NULL, 100);
	END

	IF NOT  EXISTS(
	SELECT 1 FROM ERPADMIN.ACCION WHERE NOMBRECONSTANTE = 'U_IMPUESTO'
	)
	BEGIN
		SET @ORDEN = (SELECT ISNULL(MAX(ACCION),0)+1 FROM ERPADMIN.ACCION);
		INSERT INTO ERPADMIN.ACCION (ACCION, NOMBREACCION, DESCRIPCION, NOMBRECONSTANTE, ESMODULO, ESESTANDAR, TIPO, SUBTIPO, TABLA, INVOCACION)
		VALUES	(@ORDEN, 'Catálogo de impuestos', 'Tabla UDF para almacenar el catálogo de impuestos', 'U_IMPUESTO', 'N', 'S', 'F', 'N', 'U_IMPUESTO', 'WinFormDotNet_v2:Softland.ERP.AS.Mantenimientos.UDE;Softland.ERP.AS.UI');

		SET @HERMANO = (SELECT ISNULL(MAX(NUMEROHERMANO),0)+1 FROM ERPADMIN.PARENTESCO WHERE PADRE = 8)
		SET @ORDEN2 = ( SELECT ISNULL(MAX(accion),0) FROM ERPADMIN.ACCION where NOMBRECONSTANTE = 'U_IMPUESTO')
		INSERT INTO ERPADMIN.PARENTESCO (ACCION, PADRE, NUMEROHERMANO)
		VALUES(@ORDEN2,8,@HERMANO);
	END

	/* Se incluye el UDF en el mantenimiento de impuestos */
	IF NOT  EXISTS(
	SELECT 1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'IMPUESTO' AND UDF = 'IMPUESTO'
	)
	BEGIN
		SET @ORDEN = ( SELECT ISNULL(MAX(ORDEN),0) +1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'IMPUESTO' )

		INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('IMPUESTO', 'IMPUESTO', 'IMPUESTO', 'A', @ORDEN, 'S', NULL, 'T', 'U_IMPUESTO', 4);
	END

	/* Se incluye el UDF en el mantenimiento de impuestos */
	IF NOT  EXISTS(
	SELECT 1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'IMPUESTO' AND UDF = 'IMPUESTO2'
	)
	BEGIN
		SET @ORDEN = ( SELECT ISNULL(MAX(ORDEN),0) +1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'IMPUESTO' )

		INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('IMPUESTO', 'IMPUESTO2', 'IMPUESTO2', 'A', @ORDEN, 'S', NULL, 'T', 'U_IMPUESTO', 4);
	END

	/* Se incluye el UDF en el mantenimiento de retenciones */
	IF NOT  EXISTS(
	SELECT 1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'RETENCIONES' AND UDF = 'U_IMPUESTO'
	)
	BEGIN
		SET @ORDEN = ( SELECT ISNULL(MAX(ORDEN),0) +1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'RETENCIONES' )

		INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('RETENCIONES', 'IMPUESTO', 'IMPUESTO', 'A', @ORDEN, 'S', NULL, 'T', 'U_IMPUESTO', 4);
	END

	/* TABLA DE USUARIO DE FORMA DE PAGO */
	IF NOT  EXISTS(
	SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '$$COMPANIA$$' AND  TABLE_NAME = 'U_FORMA_PAGO'
	)
	BEGIN
		CREATE TABLE $$COMPANIA$$.U_FORMA_PAGO
		(
			U_CODIGO VARCHAR(4) NOT NULL,
			U_DESCRIP VARCHAR(100) NULL
		)
	END

	IF NOT  EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_FORMA_PAGO'
	)
	BEGIN
		INSERT INTO $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('U_FORMA_PAGO','FORMA_PAGO','','U','FORMA_PAGO')
	END

	IF NOT  EXISTS(
	SELECT 1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'U_FORMA_PAGO'
	)
	BEGIN
		INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO, ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('U_FORMA_PAGO', 'U_CODIGO', 'Codigo', 'A', 1, 'N', NULL, 'N', NULL, 4);
		INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO, ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('U_FORMA_PAGO', 'U_DESCRIP', 'Descripción', 'A', 2, 'S', NULL, 'N', NULL, 100);
	END

	IF NOT  EXISTS(
	SELECT 1 FROM ERPADMIN.ACCION WHERE NOMBRECONSTANTE = 'U_FORMA_PAGO'
	)
	BEGIN
		SET @ORDEN = (SELECT ISNULL(MAX(ACCION),0)+1 FROM ERPADMIN.ACCION);
		INSERT INTO ERPADMIN.ACCION (ACCION, NOMBREACCION, DESCRIPCION, NOMBRECONSTANTE, ESMODULO, ESESTANDAR,TIPO, SUBTIPO , TABLA , INVOCACION)
		VALUES	(@ORDEN, 'Catálogo de formas de pago', 'Tabla UDF para almacenar el Catálogo de formas de pago de la SAT', 'U_FORMA_PAGO', 'N', 'S', 'F', 'N', 'U_FORMA_PAGO', 'WinFormDotNet_v2:Softland.ERP.AS.Mantenimientos.UDE;Softland.ERP.AS.UI');

		SET @HERMANO = ( SELECT ISNULL(MAX(NUMEROHERMANO),0) +1 FROM ERPADMIN.PARENTESCO WHERE PADRE = 8)
		SET @ORDEN2 = ( SELECT ISNULL(MAX(accion),0) FROM ERPADMIN.ACCION WHERE NOMBRECONSTANTE = 'U_FORMA_PAGO')
		INSERT INTO ERPADMIN.PARENTESCO (ACCION, PADRE, NUMEROHERMANO) VALUES(@ORDEN2, 8, @HERMANO);
	END

	/* TABLA DE USUARIO DE PAIS */
	CREATE TABLE $$COMPANIA$$.U_PAIS
	(
		U_CODIGO  VARCHAR(4)	NOT NULL,
		U_DESCRIP VARCHAR(100)  NULL
	)

	IF NOT  EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_PAIS'
	)
	BEGIN
		INSERT INTO $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('U_PAIS', 'Estándar de códigos de países', null, 'U', 'Códigos de países');
	END

	IF NOT  EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'PAIS'
	)
	BEGIN
		INSERT INTO $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('PAIS','Países','','E','Países');
	END

	INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO, ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('U_PAIS', 'U_CODIGO', 'Codigo', 'A', 1, 'N', NULL, 'N', NULL, 4);
	INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO, ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('U_PAIS', 'U_DESCRIP', 'Descripción', 'A', 2, 'S', NULL, 'N', NULL, 100);

	SET @ORDEN = ( SELECT ISNULL(MAX(accion),0)+1 FROM ERPADMIN.ACCION);
	INSERT INTO ERPADMIN.ACCION (ACCION, NOMBREACCION, DESCRIPCION, NOMBRECONSTANTE, ESMODULO, ESESTANDAR, TIPO, SUBTIPO, TABLA , INVOCACION)
	VALUES	(@ORDEN, 'Códigos de países' , 'Tabla UDF para almacenar los códigos estándar de países', 'U_PAIS','N', 'S' , 'F' , 'N', 'U_PAIS', 'WinFormDotNet_v2:Softland.ERP.AS.Mantenimientos.UDE;Softland.ERP.AS.UI');

	SET @HERMANO = ( SELECT ISNULL(MAX(NUMEROHERMANO),0) +1 FROM ERPADMIN.PARENTESCO where PADRE = 8);
	SET @ORDEN2 = ( SELECT ISNULL(MAX(accion),0) FROM ERPADMIN.ACCION where NOMBRECONSTANTE = 'U_PAIS');
	INSERT INTO ERPADMIN.PARENTESCO (ACCION, PADRE, NUMEROHERMANO) VALUES(@ORDEN2, 8, @HERMANO);

	/* Se incluye el UDF en el mantenimiento de subtipo de documentos de cxp */
	SET @ORDEN = ( SELECT ISNULL(MAX(ORDEN),0) +1 FROM $$COMPANIA$$.TABLA_UDF WHERE TABLA = 'PAIS' )

	INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO , ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('PAIS', 'PAIS', 'PAIS', 'A', @ORDEN, 'S', NULL, 'T', 'U_PAIS', 4);

	/* TABLA DE USUARIO DE INCOTERMS */
	CREATE TABLE $$COMPANIA$$.U_INCOTERMS
	(
		U_CODIGO  VARCHAR(4)	NOT NULL,
		U_DESCRIP VARCHAR(100)  NULL
	)

	IF NOT  EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_INCOTERMS'
	)
	BEGIN
		INSERT INTO $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('U_INCOTERMS', 'Catálogo de Incoterms', null, 'U', 'Catálogo de Incoterms');
	END

	INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO, ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('U_INCOTERMS', 'U_CODIGO', 'Codigo', 'A', 1, 'N', NULL, 'N', NULL, 4);
	INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO, ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('U_INCOTERMS', 'U_DESCRIP', 'Descripción', 'A', 2, 'S', NULL, 'N', NULL, 100);

	SET @ORDEN = ( SELECT ISNULL(MAX(accion),0)+1 FROM ERPADMIN.ACCION);
	INSERT INTO ERPADMIN.ACCION (ACCION, NOMBREACCION, DESCRIPCION, NOMBRECONSTANTE, ESMODULO, ESESTANDAR, TIPO, SUBTIPO, TABLA , INVOCACION)
	VALUES	(@ORDEN, 'Catálogo de incotermns' , 'Tabla UDF para almacenar el catálogo de incoterms', 'U_INCOTERMS','N', 'S' , 'F' , 'N', 'U_INCOTERMS', 'WinFormDotNet_v2:Softland.ERP.AS.Mantenimientos.UDE;Softland.ERP.AS.UI');

	SET @HERMANO = ( SELECT ISNULL(MAX(NUMEROHERMANO),0) +1 FROM ERPADMIN.PARENTESCO where PADRE = 8);
	SET @ORDEN2 = ( SELECT ISNULL(MAX(accion),0) FROM ERPADMIN.ACCION where NOMBRECONSTANTE = 'U_INCOTERMS');
	INSERT INTO ERPADMIN.PARENTESCO (ACCION, PADRE, NUMEROHERMANO) VALUES(@ORDEN2, 8, @HERMANO);

	/* TABLA DE USUARIO DE RAZONES DE RECHAZO */
	CREATE TABLE $$COMPANIA$$.U_IMPORTA_RECHAZO
	(
		U_CODIGO  VARCHAR(4)	NOT NULL,
		U_DESCRIP VARCHAR(150)  NULL
	)

	IF NOT  EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_IMPORTA_RECHAZO'
	)
	BEGIN
		INSERT INTO $$COMPANIA$$.ENC_TABLA_UDF (TABLA, NOTAS, LAYOUT,TIPO, ETIQUETA) VALUES('U_IMPORTA_RECHAZO', 'Catálogo de rechazos de importación', null, 'U', 'Catálogo de rechazos');
	END;
	INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO, ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('U_IMPORTA_RECHAZO', 'U_CODIGO', 'Codigo', 'A', 1, 'N', NULL, 'N', NULL, 4);
	INSERT INTO $$COMPANIA$$.TABLA_UDF (TABLA, UDF, DESCRIPCION, TIPO, ORDEN, PERMITE_NULOS, VALOR_DEFAULT, TIPO_FUENTE, UDT, LARGO) VALUES ('U_IMPORTA_RECHAZO', 'U_DESCRIP', 'Descripción', 'A', 2, 'S', NULL, 'N', NULL, 150);

	SET @ORDEN = ( SELECT ISNULL(MAX(accion),0)+1 FROM ERPADMIN.ACCION);
	INSERT INTO ERPADMIN.ACCION (ACCION, NOMBREACCION, DESCRIPCION, NOMBRECONSTANTE, ESMODULO, ESESTANDAR, TIPO, SUBTIPO, TABLA , INVOCACION)
	VALUES	(@ORDEN, 'Catálogo de rechazos de importación' , 'Tabla UDF para almacenar el catálogo de rechazos de importación', 'U_IMPORTA_RECHAZO','N', 'S' , 'F' , 'N', 'U_IMPORTA_RECHAZO', 'WinFormDotNet_v2:Softland.ERP.AS.Mantenimientos.UDE;Softland.ERP.AS.UI');

	SET @HERMANO = ( SELECT ISNULL(MAX(NUMEROHERMANO),0) +1 FROM ERPADMIN.PARENTESCO where PADRE = 5206);
	SET @ORDEN2 = ( SELECT ISNULL(MAX(accion),0) FROM ERPADMIN.ACCION where NOMBRECONSTANTE = 'U_IMPORTA_RECHAZO');
	INSERT INTO ERPADMIN.PARENTESCO (ACCION, PADRE, NUMEROHERMANO) VALUES(@ORDEN2, 5206, @HERMANO);

END
go


/* --------- Se crea IF de 944-24AS ------------ */

IF EXISTS(
SELECT 1 FROM ERPADMIN.CONJUNTO WHERE ( UPPER(PAIS) = 'COLOMBIA' ) AND CONJUNTO =  '$$COMPANIA$$'
)
BEGIN

	/* IMPUESTOS */
	/* VALORES DEFAULT DE LA TABLA */
	IF EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_IMPUESTO'
	)
	BEGIN	
		INSERT INTO $$COMPANIA$$.U_IMPUESTO(U_CODIGO, U_DESCRIP) VALUES('01','VALOR TOTAL DE IVA')
		INSERT INTO $$COMPANIA$$.U_IMPUESTO(U_CODIGO, U_DESCRIP) VALUES('02','VALOR TOTAL DE IMPUESTO AL CONSUMO')
		INSERT INTO $$COMPANIA$$.U_IMPUESTO(U_CODIGO, U_DESCRIP) VALUES('03','VALOR TOTAL DE ICA')
	END

	/* INCOTERMS */
	/* VALORES DEFAULT DE LA TABLA */
	IF EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_INCOTERMS'
	)
	BEGIN	
		INSERT INTO $$COMPANIA$$.U_INCOTERMS(U_CODIGO, U_DESCRIP) VALUES('CFR','Costo y flete')
		INSERT INTO $$COMPANIA$$.U_INCOTERMS(U_CODIGO, U_DESCRIP) VALUES('CIF','Costo')
		INSERT INTO $$COMPANIA$$.U_INCOTERMS(U_CODIGO, U_DESCRIP) VALUES('CIP','Flete y seguro pagado hasta')
		INSERT INTO $$COMPANIA$$.U_INCOTERMS(U_CODIGO, U_DESCRIP) VALUES('CPT','Flete pagado hasta')
		INSERT INTO $$COMPANIA$$.U_INCOTERMS(U_CODIGO, U_DESCRIP) VALUES('DAF','Entregado en frontera o “a mitad de puente”')
		INSERT INTO $$COMPANIA$$.U_INCOTERMS(U_CODIGO, U_DESCRIP) VALUES('DAP','Entregado en un punto')
		INSERT INTO $$COMPANIA$$.U_INCOTERMS(U_CODIGO, U_DESCRIP) VALUES('DAT','Entregado en terminal')
		INSERT INTO $$COMPANIA$$.U_INCOTERMS(U_CODIGO, U_DESCRIP) VALUES('DDP','Entregado en destino con derechos pagados')
		INSERT INTO $$COMPANIA$$.U_INCOTERMS(U_CODIGO, U_DESCRIP) VALUES('DDU','Entregado en destino de derechos no pagados')
		INSERT INTO $$COMPANIA$$.U_INCOTERMS(U_CODIGO, U_DESCRIP) VALUES('DEQ','Entregado en muelle de destino con derechos pagados')
		INSERT INTO $$COMPANIA$$.U_INCOTERMS(U_CODIGO, U_DESCRIP) VALUES('DES','Entregado sobre buque en puerto de destino')
		INSERT INTO $$COMPANIA$$.U_INCOTERMS(U_CODIGO, U_DESCRIP) VALUES('EXW','En fábrica')
		INSERT INTO $$COMPANIA$$.U_INCOTERMS(U_CODIGO, U_DESCRIP) VALUES('FAS','Libre al costado del buque')
		INSERT INTO $$COMPANIA$$.U_INCOTERMS(U_CODIGO, U_DESCRIP) VALUES('FCA','Libre transportista')
		INSERT INTO $$COMPANIA$$.U_INCOTERMS(U_CODIGO, U_DESCRIP) VALUES('FOB','Libre a bordo')
		INSERT INTO $$COMPANIA$$.U_INCOTERMS(U_CODIGO, U_DESCRIP) VALUES('OTR','Otras condiciones de entrega distintas a las anteriores')
	END

	/* PAIS */
	/* VALORES DEFAULT DE LA TABLA */
	IF EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_PAIS'
	)
	BEGIN	
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('AD','Andorra')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('AE','Emiratos Árabes Unidos')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('AF','Afganistán')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('AG','Antigua y Barbuda')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('AI','Anguila')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('AL','Albania')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('AM','Armenia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('AN','Antillas Neerlandesas')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('AO','Angola')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('AQ','Antártida')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('AR','Argentina')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('AS','Samoa Americana')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('AT','Austria')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('AU','Australia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('AW','Aruba')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('AX','Islas Áland')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('AZ','Azerbaiyán')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('BA','Bosnia y Herzegovina')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('BB','Barbados')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('BD','Bangladesh')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('BE','Bélgica')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('BF','Burkina Faso')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('BG','Bulgaria')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('BH','Bahréin')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('BI','Burundi')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('BJ','Benin')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('BL','San Bartolomé')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('BM','Bermudas')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('BN','Brunéi')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('BO','Bolivia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('BR','Brasil')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('BS','Bahamas')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('BT','Bhután')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('BV','Isla Bouvet')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('BW','Botsuana')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('BY','Belarús')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('BZ','Belice')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('CA','Canadá')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('CC','Islas Cocos')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('CF','República Centro-Africana')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('CG','Congo')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('CH','Suiza')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('CI','Costa de Marfil')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('CK','Islas Cook')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('CL','Chile')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('CM','Camerún')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('CN','China')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('CO','Colombia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('CR','Costa Rica')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('CU','Cuba')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('CV','Cabo Verde')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('CX','Islas Christmas')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('CY','Chipre')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('CZ','República Checa')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('DE','Alemania')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('DJ','Yibuti')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('DK','Dinamarca')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('DM','Domínica')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('DO','República Dominicana')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('DZ','Argel')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('EC','Ecuador')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('EE','Estonia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('EG','Egipto')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('EH','Sahara Occidental')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('ER','Eritrea')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('ES','España')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('ET','Etiopía')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('FI','Finlandia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('FJ','Fiji')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('FK','Islas Malvinas')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('FM','Micronesia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('FO','Islas Faroe')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('FR','Francia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('GA','Gabón')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('GB','Reino Unido')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('GD','Granada')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('GE','Georgia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('GF','Guayana Francesa')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('GG','Guernsey')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('GH','Ghana')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('GI','Gibraltar')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('GL','Groenlandia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('GM','Gambia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('GN','Guinea')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('GP','Guadalupe')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('GQ','Guinea Ecuatorial')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('GR','Grecia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('GS','Georgia del Sur e Islas Sandwich del Sur')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('GT','Guatemala')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('GU','Guam')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('GW','Guinea-Bissau')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('GY','Guayana')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('HK','Hong Kong')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('HM','Islas Heard y McDonald')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('HN','Honduras')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('HR','Croacia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('HT','Haití')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('HU','Hungría')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('ID','Indonesia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('IE','Irlanda')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('IL','Israel')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('IM','Isla de Man')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('IN','India')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('IO','Territorio Británico del Océano Índico')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('IQ','Irak')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('IR','Irán')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('IS','Islandia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('IT','Italia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('JE','Jersey')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('JM','Jamaica')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('JO','Jordania')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('JP','Japón')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('KE','Kenia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('KG','Kirguistán')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('KH','Camboya')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('KI','Kiribati')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('KM','Comoros')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('KN','San Cristóbal y Nieves')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('KP','Corea del Norte')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('KR','Corea del Sur')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('KW','Kuwait')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('KY','Islas Caimán')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('KZ','Kazajstán')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('LA','Laos')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('LB','Líbano')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('LC','Santa Lucía')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('LI','Liechtenstein')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('LK','Sri Lanka')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('LR','Liberia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('LS','Lesotho')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('LT','Lituania')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('LU','Luxemburgo')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('LV','Letonia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('LY','Libia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('MA','Marruecos')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('MC','Mónaco')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('MD','Moldova')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('ME','Montenegro')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('MG','Madagascar')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('MH','Islas Marshall')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('MK','Macedonia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('ML','Mali')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('MM','Myanmar')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('MN','Mongolia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('MO','Macao')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('MQ','Martinica')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('MR','Mauritania')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('MS','Montserrat')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('MT','Malta')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('MU','Mauricio')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('MV','Maldivas')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('MW','Malawi')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('MX','México')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('MY','Malasia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('MZ','Mozambique')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('NA','Namibia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('NC','Nueva Caledonia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('NE','Níger')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('NF','Islas Norkfolk')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('NG','Nigeria')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('NI','Nicaragua')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('NL','Países Bajos')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('NO','Noruega')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('NP','Nepal')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('NR','Nauru')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('NU','Niue')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('NZ','Nueva Zelanda')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('OM','Omán')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('PA','Panamá')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('PE','Perú')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('PF','Polinesia Francesa')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('PG','Papúa Nueva Guinea')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('PH','Filipinas')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('PK','Pakistán')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('PL','Polonia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('PM','San Pedro y Miquelón')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('PN','Islas Pitcairn')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('PR','Puerto Rico')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('PS','Palestina')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('PT','Portugal')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('PW','Islas Palaos')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('PY','Paraguay')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('QA','Qatar')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('RE','Reunión')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('RO','Rumanía')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('RS','Serbia y Montenegro')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('RU','Rusia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('RW','Ruanda')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('SA','Arabia Saudita')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('SB','Islas Solomón')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('SC','Seychelles')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('SD','Sudán')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('SE','Suecia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('SG','Singapur')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('SH','Santa Elena')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('SI','Eslovenia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('SJ','Islas Svalbard y Jan Mayen')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('SK','Eslovaquia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('SL','Sierra Leona')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('SM','San Marino')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('SN','Senegal')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('SO','Somalia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('SR','Surinam')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('ST','Santo Tomé y Príncipe')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('SV','El Salvador')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('SY','Siria')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('SZ','Suazilandia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('TC','Islas Turcas y Caicos')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('TD','Chad')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('TF','Territorios Australes Franceses')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('TG','Togo')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('TH','Tailandia')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('TH','Tanzania')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('TJ','Tayikistán')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('TK','Tokelau')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('TL','Timor-Leste')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('TM','Turkmenistán')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('TN','Túnez')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('TO','Tonga')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('TR','Turquía')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('TT','Trinidad y Tobago')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('TV','Tuvalu')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('TW','Taiwán')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('UA','Ucrania')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('UG','Uganda')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('US','Estados Unidos de América')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('UY','Uruguay')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('UZ','Uzbekistán')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('VA','Ciudad del Vaticano')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('VC','San Vicente y las Granadinas')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('VE','Venezuela')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('VG','Islas Vírgenes Británicas')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('VI','Islas Vírgenes de los Estados Unidos de América')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('VN','Vietnam')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('VU','Vanuatu')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('WF','Wallis y Futuna')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('WS','Samoa')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('YE','Yemen')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('YT','Mayotte')
		INSERT INTO $$COMPANIA$$.U_PAIS(U_CODIGO, U_DESCRIP) VALUES('ZA','Sudáfrica')
	END

	/* TIPO DOCUMENTOS IDENTIDAD */
	/* VALORES DEFAULT DE LA TABLA */
	IF EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_TIPO_DOC_IDENT'
	)
	BEGIN	
		INSERT INTO $$COMPANIA$$.U_TIPO_DOC_IDENT(U_CODIGO, U_DESCRIP) VALUES('11','Registro civil')
		INSERT INTO $$COMPANIA$$.U_TIPO_DOC_IDENT(U_CODIGO, U_DESCRIP) VALUES('12','Tarjeta de identidad')
		INSERT INTO $$COMPANIA$$.U_TIPO_DOC_IDENT(U_CODIGO, U_DESCRIP) VALUES('13','Cédula de ciudadanía')
		INSERT INTO $$COMPANIA$$.U_TIPO_DOC_IDENT(U_CODIGO, U_DESCRIP) VALUES('21','Tarjeta de extranjería')
		INSERT INTO $$COMPANIA$$.U_TIPO_DOC_IDENT(U_CODIGO, U_DESCRIP) VALUES('22','Cédula de extranjería')
		INSERT INTO $$COMPANIA$$.U_TIPO_DOC_IDENT(U_CODIGO, U_DESCRIP) VALUES('31','NIT')
		INSERT INTO $$COMPANIA$$.U_TIPO_DOC_IDENT(U_CODIGO, U_DESCRIP) VALUES('41','Pasaporte')
		INSERT INTO $$COMPANIA$$.U_TIPO_DOC_IDENT(U_CODIGO, U_DESCRIP) VALUES('42','Documento de identificación extranjero')
	END

	/* CONCEPTO DE NOTAS DE CREDITO */
	/* VALORES DEFAULT DE LA TABLA */
	IF EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_CONCEP_NOTA_CRE'
	)
	BEGIN	
		INSERT INTO $$COMPANIA$$.U_CONCEP_NOTA_CRE(U_CODIGO, U_DESCRIP) VALUES('1','Devolución de parte de los bienes; no aceptación de partes del servicio')
		INSERT INTO $$COMPANIA$$.U_CONCEP_NOTA_CRE(U_CODIGO, U_DESCRIP) VALUES('2','Anulación de factura electrónica')
		INSERT INTO $$COMPANIA$$.U_CONCEP_NOTA_CRE(U_CODIGO, U_DESCRIP) VALUES('3','Rebaja total aplicada')
		INSERT INTO $$COMPANIA$$.U_CONCEP_NOTA_CRE(U_CODIGO, U_DESCRIP) VALUES('4','Descuento total aplicado')
		INSERT INTO $$COMPANIA$$.U_CONCEP_NOTA_CRE(U_CODIGO, U_DESCRIP) VALUES('5','Rescisión: nulidad por falta de requisitos')
		INSERT INTO $$COMPANIA$$.U_CONCEP_NOTA_CRE(U_CODIGO, U_DESCRIP) VALUES('6','Otros')
	END

	/* CONCEPTO DE NOTAS DE DEBITO */
	/* VALORES DEFAULT DE LA TABLA */
	IF EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_CONCEP_NOTA_DEB'
	)
	BEGIN	
		INSERT INTO $$COMPANIA$$.U_CONCEP_NOTA_DEB(U_CODIGO, U_DESCRIP) VALUES('1','Intereses')
		INSERT INTO $$COMPANIA$$.U_CONCEP_NOTA_DEB(U_CODIGO, U_DESCRIP) VALUES('2','Gastos por cobrar')
		INSERT INTO $$COMPANIA$$.U_CONCEP_NOTA_DEB(U_CODIGO, U_DESCRIP) VALUES('3','Cambio del valor')
	END

	/* CONCEPTO DE FACTURAS */
	/* VALORES DEFAULT DE LA TABLA */
	IF EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_CONCEP_FAC'
	)
	BEGIN	
		INSERT INTO $$COMPANIA$$.U_CONCEP_FAC(U_CODIGO, U_DESCRIP) VALUES('1','Venta');
		INSERT INTO $$COMPANIA$$.U_CONCEP_FAC(U_CODIGO, U_DESCRIP) VALUES('2','Exportación');
		INSERT INTO $$COMPANIA$$.U_CONCEP_FAC(U_CODIGO, U_DESCRIP) VALUES('3','Contingencia');
	END

	/* FORMAS DE PAGO */
	/* VALORES DEFAULT DE LA TABLA */
	IF EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_FORMA_PAGO'
	)
	BEGIN	
		INSERT INTO $$COMPANIA$$.U_FORMA_PAGO(U_CODIGO, U_DESCRIP) VALUES('10','Efectivo')
		INSERT INTO $$COMPANIA$$.U_FORMA_PAGO(U_CODIGO, U_DESCRIP) VALUES('20','Cheque')
		INSERT INTO $$COMPANIA$$.U_FORMA_PAGO(U_CODIGO, U_DESCRIP) VALUES('41','Transferencia bancaria')
		INSERT INTO $$COMPANIA$$.U_FORMA_PAGO(U_CODIGO, U_DESCRIP) VALUES('42','Consignación bancaria')
	END

	/* UNIDADES DE MEDIDA */
	/* VALORES DEFAULT DE LA TABLA */
	IF EXISTS(
	SELECT 1 FROM $$COMPANIA$$.ENC_TABLA_UDF WHERE TABLA = 'U_FEUNIDAD'
	)
	BEGIN	
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('4','small spray')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('5','lift')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('8','heat lot')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('10','group')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('11','outfit')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('13','ration')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('14','shot')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('15','stick')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('16','hundred fifteen kg drum')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('17','hundred lb drum')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('18','fiftyfive gallon (US) drum')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('19','tank truck')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('20','twenty foot container')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('21','forty foot container')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('22','decilitre per gram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('23','gram per cubic centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('24','theoretical pound')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('25','gram per square centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('26','actual ton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('27','theoretical ton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('28','kilogram per square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('29','pound per thousand square feet')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('30','horse power day per air dry metric ton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('31','catch weight')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('32','kilogram per air dry metric ton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('33','kilopascal square metres per gram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('34','kilopascals per millimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('35','millilitres per square centimetre second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('36','cubic feet per minute per square foot')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('37','ounce per square foot')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('38','ounces per square foot per 0,01 inch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('40','millilitre per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('41','millilitre per minute')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('43','super bulk bag')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('44','fivehundred kg bulk bag')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('45','threehundred kg bulk bag')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('46','fifty lb bulk bag')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('47','fifty lb bag')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('48','bulk car load')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('53','theoretical kilograms')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('54','theoretical tonne')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('56','sitas')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('57','mesh')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('58','net kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('59','part per million')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('60','percent weight')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('61','part per billion (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('62','percent per 1000 hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('63','failure rate in time')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('64','pound per square inch, gauge')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('66','oersted')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('69','test specific scale')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('71','volt ampere per pound')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('72','watt per pound')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('73','ampere tum per centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('74','millipascal')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('76','gauss')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('77','milli-inch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('78','kilogauss')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('80','pounds per square inch absolute')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('81','henry')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('84','kilopound per square inch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('85','foot pound-force')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('87','pound per cubic foot')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('89','poise')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('90','Saybold universal second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('91','stokes')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('92','calorie per cubic centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('93','calorie per gram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('94','curl unit')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('95','twenty thousand gallon (US) tankcar')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('96','ten thousand gallon (US) tankcar')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('97','ten kg drum')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('98','fifteen kg drum')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('1A','car mile')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('1B','car count')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('1C','locomotive count')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('1D','caboose count')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('1E','empty car')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('1F','train mile')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('1G','fuel usage gallon (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('1H','caboose mile')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('1I','fixed rate')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('1J','ton mile')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('1K','locomotive mile')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('1L','total car count')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('1M','total car mile')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('1X','quarter mile')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('2A','radian per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('2B','radian per second squared')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('2C','röntgen')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('2I','British thermal unit per hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('2J','cubic centimetre per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('2K','cubic foot per hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('2L','cubic foot per minute')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('2M','centimetre per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('2N','decibel')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('2P','kilobyte')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('2Q','kilobecquerel')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('2R','kilocurie')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('2U','megagram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('2V','megagram per hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('2W','bin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('2X','metre per minute')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('2Y','milliröntgen')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('2Z','millivolt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('3B','megajoule')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('3C','manmonth')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('3E','pound per pound of product')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('3G','pound per piece of product')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('3H','kilogram per kilogram of product')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('3I','kilogram per piece of product')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('4A','bobbin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('4B','cap')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('4C','centistokes')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('4E','twenty pack')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('4G','microlitre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('4H','micrometre (micron)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('4K','milliampere')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('4L','megabyte')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('4M','milligram per hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('4N','megabecquerel')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('4O','microfarad')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('4P','newton per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('4Q','ounce inch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('4R','ounce foot')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('4T','picofarad')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('4U','pound per hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('4W','ton(US) per hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('4X','kilolitre per hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('5A','barrel per minute')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('5B','batch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('5C','gallon(US) per thousand')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('5E','MMSCF/day')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('5F','pounds per thousand')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('5G','pump')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('5H','stage')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('5I','standard cubic foot')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('5J','hydraulic horse power')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('5K','count per minute')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('5P','seismic level')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('5Q','seismic line')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A1','15 C calorie')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A10','ampere square metre per joule second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A11','ångström')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A12','astronomical unit')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A13','attojoule')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A14','barn')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A15','barn per electron volt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A16','barn per steradian electron volt,')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A17','barn per sterdian')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A18','becquerel per kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A19','becquerel per metre cubed')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A2','ampere per centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A20','British thermal unit per second square foot degree Rankin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A21','British thermal unit per pound degree Rankin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A22','British thermal unit per second foot degree Rankin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A23','British thermal unit per hour square foot degree Rankin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A24','candela per square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A25','cheval vapeur')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A26','coulomb metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A27','coulomb metre squared per volt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A28','coulomb per cubic centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A29','coulomb per cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A3','ampere per millimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A30','coulomb per cubic millimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A31','coulomb per kilogram second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A32','coulomb per mole')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A33','coulomb per square centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A34','coulomb per square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A35','coulomb per square millimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A36','cubic centimetre per mole')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A37','cubic decimetre per mole')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A38','cubic metre per coulomb')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A39','cubic metre per kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A4','ampere per square centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A40','cubic metre per mole')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A41','ampere per square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A42','curie per kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A43','deadweight tonnage')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A44','decalitre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A45','decametre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A47','decitex')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A48','degree Rankin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A49','denier')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A5','ampere square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A50','dyn second per cubic centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A51','dyne second per centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A52','dyne second per centimetre to the fifth')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A53','electronvolt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A54','electronvolt per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A55','electronvolt square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A56','electronvolt square metre per kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A57','erg')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A58','erg per centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A6','ampere per square metre kelvin squared')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A60','erg per cubic centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A61','erg per gram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A62','erg per gram second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A63','erg per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A64','erg per second square centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A65','erg per square centimetre second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A66','erg square centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A67','erg square centimetre per gram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A68','exajoule')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A69','farad per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A7','ampere per square millimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A70','femtojoule')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A71','femtometre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A73','foot per second squared')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A74','foot pound-force per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A75','freight ton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A76','gal')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A77','Gaussian CGS unit of displacement')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A78','Gaussian CGS unit of electic current')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A79','Gaussian CGS unit of electric charge')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A8','ampere second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A80','Gaussian CGS unit of electric field strength')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A81','Gaussian CGS unit of electric polarization')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A82','Gaussian CGS unit of electric potential')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A83','Gaussian CGS unit of magnetization')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A84','gigacoulomb per cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A85','gigaelectronvolt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A86','gigahertz')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A87','gigaohm')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A88','gigaohm metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A89','gigapascal')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A9','rate')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A90','gigawatt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A91','gon')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A93','gram per cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A94','gram per mole')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A95','gray')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A96','gray per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A97','hectopascal')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('A98','henry per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('AA','ball')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('AB','bulk pack')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('ACR','acre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('AD','byte')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('AE','ampere per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('AH','additional minute')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('AI','average minute per call')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('AJ','cop')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('AK','fathom')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('AL','access line')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('AM','ampoule')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('AMH','ampere hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('AMP','ampere')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('ANN','year')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('AP','aluminium pound only')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('APZ','troy ounce or apothecaries ounce')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('AQ','anti-hemophilic factor (AHF) unit')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('AR','suppository')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('ARE','are')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('AS','assortment')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('ASM','alcoholic strength by mass')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('ASU','alcoholic strength by volume')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('ATM','standard atmosphere')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('ATT','technical atmosphere')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('AV','capsule')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('AW','powder filled vial')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('AY','assembly')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('AZ','British thermal unit per pound')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B0','Btu per cubic foot')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B1','barrel (US) per day')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B11','joule per kilogram kelvin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B12','joule per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B13','joule per square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B14','joule per metre to the fourth power')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B15','joule per mole')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B16','joule per mole kelvin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B18','joule second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B2','bunk')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B20','joule square metre per kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B21','kelvin per watt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B22','kiloampere')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B23','kiloampere per square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B24','kiloampere per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B25','kilobecquerel per kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B26','kilocoulomb')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B27','kilocoulomb per cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B28','kilocoulomb per square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B29','kiloelectronvolt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B3','batting pound')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B31','kilogram metre per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B32','kilogram metre squared')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B33','kilogram metre squared per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B34','kilogram per cubic decimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B35','kilogram per litre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B36','thermochemical calorie per gram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B37','kilogram-force')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B38','kilogram-force metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B39','kilogram-force metre per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B4','barrel, imperial')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B40','kilogram-force per square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B41','kilojoule per kelvin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B42','kilojoule per kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B43','kilojoule per kilogram kelvin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B44','kilojoule per mole')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B45','kilomole')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B46','kilomole per cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B47','kilonewton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B48','kilonewton metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B49','kiloohm')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B5','billet')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B50','kiloohm metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B51','kilopond')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B52','kilosecond')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B53','kilosiemens')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B54','kilosiemens per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B55','kilovolt per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B56','kiloweber per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B57','light year')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B58','litre per mole')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B59','lumen hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B6','bun')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B60','lumen per square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B61','lumen per watt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B62','lumen second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B63','lux hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B64','lux second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B65','maxwell')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B66','megaampere per square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B67','megabecquerel per kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B69','megacoulomb per cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B7','cycle')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B70','megacoulomb per square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B71','megaelectronvolt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B72','megagram per cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B73','meganewton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B74','meganewton metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B75','megaohm')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B76','megaohm metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B77','megasiemens per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B78','megavolt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B79','megavolt per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B8','joule per cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B81','reciprocal metre squared reciprocal second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B83','metre to the fourth power')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B84','microampere')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B85','microbar')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B86','microcoulomb')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B87','microcoulomb per cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B88','microcoulomb per square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B89','microfarad per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B9','batt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B90','microhenry')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B91','microhenry per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B92','micronewton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B93','micronewton metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B94','microohm')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B95','microohm metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B96','micropascal')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B97','microradian')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B98','microsecond')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('B99','microsiemens')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BAR','bar')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BB','base box')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BD','board')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BE','bundle')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BFT','board foot')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BG','bag')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BH','brush')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BHP','brake horse power')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BIL','trillion (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BJ','bucket')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BK','basket')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BL','bale')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BLD','dry barrel (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BLL','barrel (US) (petroleum etc.)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BO','bottle')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BP','hundred board feet')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BQL','becquerel')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BR','bar')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BT','bolt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BTU','British thermal unit')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BUA','bushel (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BUI','bushel (UK)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BW','base weight')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BX','box')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('BZ','million BTUs')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C0','call')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C1','composite product pound (total weight)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C10','millifarad')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C11','milligal')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C12','milligram per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C13','milligray')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C14','millihenry')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C15','millijoule')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C16','millimetre per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C17','millimetre squared per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C18','millimole')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C19','mole per kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C2','carset')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C20','millinewton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C22','millinewton per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C23','milliohm metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C24','millipascal second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C25','milliradian')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C26','millisecond')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C27','millisiemens')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C28','millisievert')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C29','millitesla')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C3','microvolt per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C30','millivolt per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C31','milliwatt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C32','milliwatt per square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C33','milliweber')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C34','mole')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C35','mole per cubic decimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C36','mole per cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C38','mole per litre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C39','nanoampere')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C4','carload')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C40','nanocoulomb')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C41','nanofarad')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C42','nanofarad per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C43','nanohenry')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C44','nanohenry per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C45','nanometre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C46','nanoohm metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C47','nanosecond')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C48','nanotesla')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C49','nanowatt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C5','cost')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C50','neper')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C51','neper per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C52','picometre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C53','newton metre second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C54','newton metre squared kilogram squared')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C55','newton per square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C56','newton per square millimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C57','newton second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C58','newton second per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C59','octave')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C6','cell')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C60','ohm centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C61','ohm metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C62','one')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C63','parsec')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C64','pascal per kelvin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C65','pascal second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C66','pascal second per cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C67','pascal second per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C68','petajoule')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C69','phon')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C7','centipoise')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C70','picoampere')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C71','picocoulomb')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C72','picofarad per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C73','picohenry')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C75','picowatt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C76','picowatt per square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C77','pound gage')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C78','pound-force')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C8','millicoulomb per kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C80','rad')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C81','radian')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C82','radian meter squared per mole')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C83','radian metre squared per kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C84','radian per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C85','reciprocal †ngstr"m')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C86','reciprocal cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C87','reciprocal cubic metre per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C88','reciprocal electron volt per cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C89','reciprocal henry')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C9','coil group')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C90','reciprocal joule per cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C91','reciprocal kelvin or kelvin to the power minus one')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C92','reciprocal metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C93','reciprocal square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C94','reciprocal minute')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C95','reciprocal mole')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C96','reciprocal pascal or pascal to the power minus one')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C97','reciprocal second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C98','reciprocal second per cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('C99','reciprocal second per metre squared')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CA','can')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CCT','carrying capacity in metric ton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CDL','candela')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CEL','degree Celsius')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CEN','hundred')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CG','card')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CGM','centigram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CH','container')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CJ','cone')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CK','connector')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CKG','coulomb per kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CL','coil')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CLF','hundred leave')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CLT','centilitre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CMK','square centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CMQ','cubic centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CMT','centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CNP','hundred pack')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CNT','cental (UK)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CO','carboy')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('COU','coulomb')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CQ','cartridge')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CR','crate')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CS','case')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CT','carton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CTM','metric carat')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CU','cup')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CUR','curie')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CV','cover')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CWA','hundred pounds (cwt)/hundred weight (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CWI','hundred weight (UK)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CY','cylinder')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('CZ','combo')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D1','reciprocal second per steradian')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D10','siemens per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D12','siemens square metre per mole')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D13','sievert')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D14','thousand linear yard')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D15','sone')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D16','square centimetre per erg')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D17','square centimetre per steradian erg')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D18','metre kelvin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D19','square metre kelvin per watt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D2','reciprocal second per steradian metre squared')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D20','square metre per joule')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D21','square metre per kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D22','square metre per mole')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D23','pen gram (protein)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D24','square metre per steradian')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D25','square metre per steradian joule')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D26','square metre per volt second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D27','steradian')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D28','syphon')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D29','terahertz')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D30','terajoule')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D31','terawatt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D32','terawatt hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D33','tesla')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D34','tex')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D35','thermochemical calorie')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D37','thermochemical calorie per gram kelvin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D38','thermochemical calorie per second centimetre kelvin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D39','thermochemical calorie per second square centimetre kelvin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D40','thousand litre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D41','tonne per cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D42','tropical year')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D43','unified atomic mass unit')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D44','var')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D45','volt squared per kelvin squared')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D46','volt - ampere')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D47','volt per centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D48','volt per kelvin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D49','millivolt per kelvin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D5','kilogram per square centimeter')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D50','volt per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D51','volt per millimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D52','watt per kelvin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D53','watt per metre kelvin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D54','watt per square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D55','watt per square metre kelvin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D56','watt per square metre kelvin to the fourth power')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D57','watt per steradian')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D58','watt per steradian square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D59','weber per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D6','röntgen per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D60','weber per millimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D61','minute')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D62','second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D63','book')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D64','block')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D65','round')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D66','cassette')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D67','dollar per hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D69','inch to the fourth power')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D7','sandwich')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D70','International Table (IT) calorie')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D71','International Table (IT) calorie per second centimetre kelvin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D72','International Table (IT) calorie per second square centimetre kelvin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D73','joule square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D74','kilogram per mole')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D75','International Table (IT) calorie per gram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D76','International Table (IT) calorie per gram kelvin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D77','megacoulomb')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D79','beam')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D8','draize score')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D80','microwatt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D81','microtesla')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D82','microvolt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D83','millinewton metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D85','microwatt per square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D86','millicoulomb')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D87','millimole per kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D88','millicoulomb per cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D89','millicoulomb per square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D9','dyne per square centimeter')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D90','cubic metre (net)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D91','rem')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D92','band')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D93','second per cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D94','second per radian cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D95','joule per gram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D96','pound gross')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D97','pallet/unit load')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D98','mass pound')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('D99','sleeve')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DAA','decare')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DAD','ten day')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DAY','day')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DB','dry pound')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DC','disk (disc)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DD','degree')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DE','deal')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DEC','decade')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DG','decigram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DI','dispenser')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DJ','decagram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DLT','decilitre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DMK','square decimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DMQ','cubic decimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DMT','decimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DN','decinewton metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DPC','dozen piece')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DPR','dozen pair')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DPT','displacement tonnage')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DQ','data record')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DR','drum')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DRA','dram (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DRI','dram (UK)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DRL','dozen roll')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DRM','drachm (UK)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DS','display')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DT','dry ton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DTN','decitonne')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DU','dyne')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DWT','pennyweight')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DX','dyne per centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DY','directory book')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DZN','dozen')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('DZP','dozen pack')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('E2','belt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('E3','trailer')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('E4','gross kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('E5','metric long ton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('EA','each')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('EB','electronic mail box')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('EC','each per month')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('EP','eleven pack')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('EQ','equivalent gallon')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('EV','envelope')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('F1','thousand cubic feet per day')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('F9','fibre per cubic centimetre of air')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('FAH','degree Fahrenheit')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('FAR','farad')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('FB','field')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('FC','thousand cubic feet')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('FD','million particle per cubic foot')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('FE','track foot')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('FF','hundred cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('FG','transdermal patch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('FH','micromole')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('FL','flake ton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('FM','million cubic feet')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('FOT','foot')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('FP','pound per square foot')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('FR','foot per minute')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('FS','foot per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('FTK','square foot')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('FTQ','cubic foot')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('G2','US gallon per minute')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('G3','Imperial gallon per minute')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('G7','microfiche sheet')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GB','gallon (US) per day')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GBQ','gigabecquerel')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GC','gram per 100 gram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GD','gross barrel')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GE','pound per gallon (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GF','gram per metre (gram per 100 centimetres)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GFI','gram of fissile isotope')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GGR','great gross')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GH','half gallon (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GIA','gill (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GII','gill (UK)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GJ','gram per millilitre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GK','gram per kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GL','gram per litre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GLD','dry gallon (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GLI','gallon (UK)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GLL','gallon (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GM','gram per square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GN','gross gallon')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GO','milligrams per square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GP','milligram per cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GQ','microgram per cubic meter')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GRM','gram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GRN','grain')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GRO','gross')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GRT','gross register ton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GT','gross ton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GV','gigajoule')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GW','gallon per thousand cubic feet')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GWH','gigawatt hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GY','gross yard')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('GZ','gage system')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('H1','half page - electronic')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('H2','half litre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HA','hank')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HAR','hectare')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HBA','hectobar')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HBX','hundred boxe')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HC','hundred count')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HD','half dozen')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HE','hundredth of a carat')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HF','hundred feet')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HGM','hectogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HH','hundred cubic feet')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HI','hundred sheet')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HIU','hundred international unit')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HJ','metric horse power')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HK','hundred kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HL','hundred feet (linear)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HLT','hectolitre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HM','mile per hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HMQ','million cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HMT','hectometre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HN','conventional millimetre of mercury')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HO','hundred troy ounce')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HP','conventional millimetre of water')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HPA','hectolitre of pure alcohol')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HS','hundred square feet')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HT','half hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HTZ','hertz')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HUR','hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('HY','hundred yard')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('IA','inch pound (pound inch)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('IC','count per inch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('IE','person')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('IF','inches of water')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('II','column inch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('IL','inch per minute')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('IM','impression')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('INH','inch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('INK','square inch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('INQ','inch cubed')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('IP','insurance policy')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('IT','count per centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('IU','inch per second (linear speed)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('IV','inch per second squared (acceleration)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('J2','joule per kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('JB','jumbo')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('JE','joule per kelvin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('JG','jug')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('JK','megajoule per kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('JM','megajoule per cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('JO','joint')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('JOU','joule')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('JR','jar')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('K1','kilowatt demand')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('K2','kilovolt ampere reactive demand')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('K3','kilovolt ampere reactive hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('K5','kilovolt ampere (reactive)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('K6','kilolitre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KA','cake')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KB','kilocharacter')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KBA','kilobar')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KD','kilogram decimal')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KEL','kelvin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KF','kilopacket')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KG','keg')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KGM','kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KGS','kilogram per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KHZ','kilohertz')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KI','kilogram per millimetre width')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KJ','kilosegment')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KJO','kilojoule')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KL','kilogram per metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KMH','kilometre per hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KMK','square kilometre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KMQ','kilogram per cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KNI','kilogram of nitrogen')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KNS','kilogram named substance')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KNT','knot')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KO','milliequivalence caustic potash per gram of product')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KPA','kilopascal')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KPH','kilogram of potassium hydroxide (caustic potash)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KPO','kilogram of potassium oxide')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KPP','kilogram of phosphorus pentoxide (phosphoric anhydride)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KR','kiloröntgen')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KS','thousand pound per square inch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KSD','kilogram of substance 90 % dry')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KSH','kilogram of sodium hydroxide (caustic soda)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KT','kit')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KTM','kilometre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KTN','kilotonne')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KUR','kilogram of uranium')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KVA','kilovolt - ampere')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KVR','kilovar')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KVT','kilovolt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KW','kilograms per millimeter')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KWH','kilowatt hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KWT','kilowatt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('KX','millilitre per kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('L2','litre per minute')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LA','pound per cubic inch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LBR','pound')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LBT','troy pound (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LC','linear centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LD','litre per day')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LE','lite')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LEF','leaf')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LF','linear foot')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LH','labour hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LI','linear inch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LJ','large spray')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LK','link')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LM','linear metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LN','length')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LO','lot')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LP','liquid pound')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LPA','litre of pure alcohol')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LR','layer')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LS','lump sum')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LTN','ton (UK) or longton (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LTR','litre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LUM','lumen')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LUX','lux')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LX','linear yard per pound')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('LY','linear yard')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('M0','magnetic tape')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('M1','milligrams per litre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('M4','monetary value')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('M5','microcurie')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('M7','micro-inch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('M9','million Btu per 1000 cubic feet')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MA','machine per unit')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MAL','mega litre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MAM','megametre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MAW','megawatt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MBE','thousand standard brick equivalent')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MBF','thousand board feet')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MBR','millibar')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MC','microgram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MCU','millicurie')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MD','air dry metric ton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MF','milligram per square foot per side')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MGM','milligram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MHZ','megahertz')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MIK','square mile')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MIL','thousand')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MIN','minute')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MIO','million')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MIU','million international unit')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MK','milligram per square inch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MLD','milliard')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MLT','millilitre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MMK','square millimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MMQ','cubic millimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MMT','millimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MON','month')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MPA','megapascal')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MQ','thousand metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MQH','cubic metre per hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MQS','cubic metre per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MSK','metre per second squared')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MT','mat')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MTK','square metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MTQ','cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MTR','metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MTS','metre per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MV','number of mults')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MVA','megavolt - ampere')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('MWH','megawatt hour (1000 kW.h)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('N1','pen calorie')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('N2','number of lines')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('N3','print point')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NA','milligram per kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NAR','number of articles')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NB','barge')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NBB','number of bobbins')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NC','car')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NCL','number of cells')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('ND','net barrel')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NE','net litre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NEW','newton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NF','message')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NG','net gallon (us)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NH','message hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NI','net imperial gallon')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NIU','number of international units')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NJ','number of screens')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NL','load')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NMI','nautical mile')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NMP','number of packs')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NN','train')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NPL','number of parcels')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NPR','number of pairs')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NPT','number of parts')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NQ','mho')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NR','micromho')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NRL','number of rolls')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NT','net ton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NTT','net register ton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NU','newton metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NV','vehicle')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NX','part per thousand')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('NY','pound per air dry metric ton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('OA','panel')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('OHM','ohm')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('ON','ounce per square yard')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('ONZ','ounce')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('OP','two pack')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('OT','overtime hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('OZ','ounce av')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('OZA','fluid ounce (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('OZI','fluid ounce (UK)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('P0','page - electronic')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('P1','percent')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('P2','pound per foot')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('P3','three pack')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('P4','four pack')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('P5','five pack')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('P6','six pack')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('P7','seven pack')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('P8','eight pack')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('P9','nine pack')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PA','packet')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PAL','pascal')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PB','pair inch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PD','pad')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PE','pound equivalent')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PF','pallet (lift)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PG','plate')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PGL','proof gallon')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PI','pitch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PK','package')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PL','pail')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PM','pound percentage')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PN','pound net')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PO','pound per inch of length')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PQ','page per inch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PR','pair')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PS','pound-force per square inch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PT','pint (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PTD','dry pint (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PTI','pint (UK)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PTL','liquid pint (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PU','tray / tray pack')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PV','half pint (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PW','pound per inch of width')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PY','peck dry (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('PZ','peck dry (UK)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('Q3','meal')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('QA','page - facsimile')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('QAN','quarter (of a year)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('QB','page - hardcopy')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('QD','quarter dozen')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('QH','quarter hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('QK','quarter kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('QR','quire')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('QT','quart (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('QTD','dry quart (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('QTI','quart (UK)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('QTL','liquid quart (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('QTR','quarter (UK)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('R1','pica')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('R4','calorie')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('R9','thousand cubic metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('RA','rack')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('RD','rod')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('RG','ring')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('RH','running or operating hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('RK','roll metric measure')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('RL','reel')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('RM','ream')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('RN','ream metric measure')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('RO','roll')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('RP','pound per ream')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('RPM','revolutions per minute')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('RPS','revolutions per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('RS','reset')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('RT','revenue ton mile')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('RU','run')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('S3','square foot per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('S4','square metre per second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('S5','sixty fourths of an inch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('S6','session')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('S7','storage unit')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('S8','standard advertising unit')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SA','sack')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SAN','half year (6 months)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SCO','score')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SCR','scruple')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SD','solid pound')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SE','section')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SEC','second')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SET','set')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SG','segment')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SHT','shipping ton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SIE','siemens')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SK','split tanktruck')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SL','slipsheet')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SMI','mile (statute mile)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SN','square rod')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SO','spool')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SP','shelf package')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SQ','square')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SR','strip')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SS','sheet metric measure')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SST','short standard (7200 matches)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('ST','sheet')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('STI','stone (UK)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('STN','ton (US) or short ton (UK/US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SV','skid')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SW','skein')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('SX','shipment')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('T0','telecommunication line in service')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('T1','thousand pound gross')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('T3','thousand piece')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('T4','thousand bag')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('T5','thousand casing')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('T6','thousand gallon (US)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('T7','thousand impression')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('T8','thousand linear inch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TA','tenth cubic foot')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TAH','kiloampere hour (thousand ampere hour)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TC','truckload')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TD','therm')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TE','tote')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TF','ten square yard')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TI','thousand square inch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TJ','thousand square centimetre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TK','tank, rectangular')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TL','thousand feet (linear)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TN','tin')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TNE','tonne (metric ton)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TP','ten pack')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TPR','ten pair')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TQ','thousand feet')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TQD','thousand cubic metre per day')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TR','ten square feet')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TRL','trillion (EUR)')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TS','thousand square feet')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TSD','tonne of substance 90 % dry')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TSH','ton of steam per hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TT','thousand linear metre')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TU','tube')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TV','thousand kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TW','thousand sheet')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('TY','tank, cylindrical')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('U1','treatment')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('U2','tablet')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('UA','torr')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('UB','telecommunication line in service average')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('UC','telecommunication port')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('UD','tenth minute')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('UE','tenth hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('UF','usage per telecommunication line average')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('UH','ten thousand yard')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('UM','million unit')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('VA','volt ampere per kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('VI','vial')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('VLT','volt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('VQ','bulk')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('VS','visit')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('W2','wet kilo')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('W4','two week')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('WA','watt per kilogram')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('WB','wet pound')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('WCD','cord')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('WE','wet ton')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('WEB','weber')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('WEE','week')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('WG','wine gallon')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('WH','wheel')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('WHR','watt hour')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('WI','weight per square inch')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('WM','working month')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('WR','wrap')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('WSD','standard')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('WTT','watt')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('YDQ','cubic yard')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('YL','hundred linear yard')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('YRD','yard')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('YT','ten yard')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('Z1','lift van')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('Z2','chest')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('Z3','cask')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('Z4','hogshead')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('Z5','lug')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('Z6','conference point')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('Z8','newspage agate line')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('ZP','page')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('ZZ','mutually defined')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('WW','millilitre of water')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('X1','chain')
		INSERT INTO $$COMPANIA$$.U_FEUNIDAD(U_CODIGO, U_DESCRIP)VALUES('YDK','square yard')
	END
END
go


