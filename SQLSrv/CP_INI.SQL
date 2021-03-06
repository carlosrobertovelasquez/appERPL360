INSERT INTO SUBTIPO_DOC_CP (TIPO, SUBTIPO, DESCRIPCION, TIPO_CB, SUBTIPO_CB )VALUES ( 'CHQ', 0, 'Cheque', 'CHQ', 0 )
go

INSERT INTO SUBTIPO_DOC_CP (TIPO, SUBTIPO, DESCRIPCION)VALUES ( 'N/C', 0, 'Nota de Cr�dito' )
go

INSERT INTO SUBTIPO_DOC_CP (TIPO, SUBTIPO, DESCRIPCION)VALUES ( 'O/C', 0, 'Otro Cr�dito' )
go

INSERT INTO SUBTIPO_DOC_CP (TIPO, SUBTIPO, DESCRIPCION, TIPO_CB, SUBTIPO_CB )VALUES ( 'TEF', 0, 'T.E.F.', 'T/D', 0 )
go

INSERT INTO SUBTIPO_DOC_CP (TIPO, SUBTIPO, DESCRIPCION)VALUES ( 'RET', 0, 'Retenci�n' )
go

INSERT INTO SUBTIPO_DOC_CP (TIPO, SUBTIPO, DESCRIPCION)VALUES ( 'CNJ', 0, 'Canje' )
go

INSERT INTO SUBTIPO_DOC_CP (TIPO, SUBTIPO, DESCRIPCION)VALUES ( 'FAC', 0, 'Factura' )
go

INSERT INTO SUBTIPO_DOC_CP (TIPO, SUBTIPO, DESCRIPCION)VALUES ( 'FAC', 1, 'Adelanto' )
go	

INSERT INTO SUBTIPO_DOC_CP (TIPO, SUBTIPO, DESCRIPCION)VALUES ( 'FAC', 2, '�vance' )
go	

INSERT INTO SUBTIPO_DOC_CP (TIPO, SUBTIPO, DESCRIPCION)VALUES ( 'FAC', 3, 'Retenci�n' )
go

INSERT INTO SUBTIPO_DOC_CP (TIPO, SUBTIPO, DESCRIPCION)VALUES ( 'L/C', 0, 'Letra de Cambio' )
go

INSERT INTO SUBTIPO_DOC_CP (TIPO, SUBTIPO, DESCRIPCION)VALUES ( 'N/D', 0, 'Nota de D�bito' )
go

INSERT INTO SUBTIPO_DOC_CP (TIPO, SUBTIPO, DESCRIPCION)VALUES ( 'O/D', 0, 'Otro D�bito' )
go

INSERT INTO SUBTIPO_DOC_CP (TIPO, SUBTIPO, DESCRIPCION)VALUES ( 'INT', 0, 'Intereses' )
go


INSERT INTO SUBTIPO_DOC_CP (TIPO, SUBTIPO, DESCRIPCION)VALUES ( 'B/V', 0, 'Boleta de Venta' )
go


INSERT INTO SUBTIPO_DOC_CP (TIPO, SUBTIPO, DESCRIPCION,TIPO_CB, SUBTIPO_CB)VALUES ('RED', 0, 'Retenci�n - Cr�dito', 'N/D', 0  )
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('01','Servicios de car�cter permanente con subordinaci�n o dependencia laboral','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('05','Rentas de personas jur�dicas domiciliadas provenientes de dep�sitos de dinero','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('06','Rentas de personas jur�dicas domiciliadas provenientes de t�tulos valores','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('07','Retenciones por actividades agropecuarias 26 Operaciones de renta y asimiladas a rentas a personas domiciliadas','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('08','Retenciones por juicios ejecutivos','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('09','Otras retenciones acreditables RETENCIONES NO ACREDITABLES (ENTERO DEFINITIVO)','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('11','Servicios sin dependencia laboral','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('12','Rentas obtenidas en el pa�s por personas no domiciliadas','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('13','Retenciones sobre premios a domiciliados','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('14','Transferencia de bienes intangibles por personas domiciliadas','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('15','Transferencia de bienes intangibles por personas no domiciliadas','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('16','Servicios utilizados en el pa�s por actividades originadas en el exterior','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('17','Pagos efectuados a casa matriz por filiales y/o sucursales','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('18','Retenciones sobre premios a no domiciliadas','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('19','Costos y gastos incurridos sujetos a retenci�n y entero 36 Servicio de transporte internacional a personas no domiciliadas','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('20','Valores garantizados por seguro dotal u otros tipos de seguros','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('21','Otros servicios sin dependencia laboral','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('22','Transferencia de bienes intangibles por personas naturales domiciliadas','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('23','Transferencia de bienes intangibles por personas jur�dicas domiciliadas 39 Operaciones con intangibles o uso concesi�n de uso de derechos de bienes tangibles e intangibles a no domiciliados','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('24','Por uso o concesi�n de uso, de derechos de bienes tangibles e intangibles a personas naturales domiciliadas','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('25','Por uso o concesi�n de uso, de derechos de bienes tangibles e intangibles a personas jur�dicas domiciliadas','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('27','Retenciones por servicios de arrendamiento a personas naturales','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('28','Rentas de personas naturales domiciliadas provenientes de t�tulos valores','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('29','Premios o ganancias de domiciliadas provenientes de concursos, rifas, sorteos o juegos de azar o de habilidad','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('31','Por uso o concesi�n de uso, de derechos de bienes tangibles e intangibles a no domiciliadas 48 Indemnizaciones (Art. 156 b del CT)','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('32','Transferencia de bienes intangibles por no domiciliadas INGRESOS GRAVADOS SIN RETENCION','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('33','Rentas obtenidas en el pa�s por personas no domiciliadas','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('34','Servicios utilizados en el pa�s por actividades originadas en el exterior INGRESOS NO GRAVADOS','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('35','Pagos efectuados a casa matriz (no domiciliadas) por filiales y/o sucursales domiciliadas','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('37','Servicios por aseguradoras, reaseguradoras, afianzadoras, reafianzadoras y corredores de reaseguros no domiciliados','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('38','Servicios de financiamiento por instituciones financieras no domiciliadas','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('40','Rentas de personas constituidas, domiciliadas o residentes en pa�ses con reg�menes fiscales preferentes o para�sos fiscales','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('41','Premios o ganancias de no domiciliadas provenientes de concursos, rifas, sorteos o juegos de azar o de habilidad','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('42','Otras retenciones no acreditables','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('43','Pago o Acreditaci�n de utilidades a socios, accionistas, asociados, fideicomisarios, participes, inversionistas o beneficiarios.','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('44','Pago o Acreditaci�n de utilidades a sujetos no domiciliados en El Salvador.','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('45','Pago o acreditaci�n en disminuci�n de capital o patrimonio (parte correspondiente a capitalizaciones o reinversi�n de utilidades).','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('46','Prestamos, mutuos, anticipos o financiamientos (en dinero o bienes en especie).','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('47','Rentas a Personas Naturales Domiciliadas en concepto de Intereses, Premios y otras Utilidades provenientes de Dep�sitos en Dinero','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('48','Indemnizaciones (Art. 156 b del CT)','S')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('70','Indemnizaciones por despido, retiro voluntario, muerte, incapacidad, accidente o enfermedad (seg�n ley)','N')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('71','Valores garantizados por seguro dotal u otros tipos de seguros','N')
go

INSERT INTO cod_ingreso(COD_INGRESO,DESCRIPCION,GRAVADO) VALUES ('72','Remuneraciones, compensaciones y gastos de representaci�n por servicios en el exterior de funcionarios o empleados de gobierno','N')
go

