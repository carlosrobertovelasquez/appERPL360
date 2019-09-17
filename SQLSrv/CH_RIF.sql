
 
 ALTER TABLE CAJA_BANCO
        ADD CONSTRAINT CABCOCACH
               FOREIGN KEY (CAJA_CHICA)
                              REFERENCES CAJA_CHICA
go
 
 
 ALTER TABLE CAJA_BANCO
        ADD CONSTRAINT CABCOCTABCO
               FOREIGN KEY (CUENTA_BANCO)
                              REFERENCES CUENTA_BANCARIA
go
 
 
 ALTER TABLE CAJA_CHICA
        ADD CONSTRAINT CACHCTRCTA
               FOREIGN KEY (CENTRO_COSTO, CUENTA_CONTABLE)
                              REFERENCES CENTRO_CUENTA
go
 
 
 ALTER TABLE CAJA_CHICA
        ADD CONSTRAINT CACHDEP
               FOREIGN KEY (AREA_FUNCIONAL)
                              REFERENCES DEPARTAMENTO
go
 
 
 ALTER TABLE CAJA_CHICA
        ADD CONSTRAINT MONEDACAJACH
               FOREIGN KEY (MONEDA)
                              REFERENCES MONEDA
go
 
 
 ALTER TABLE CAJA_CHICA
        ADD CONSTRAINT CACHREP
               FOREIGN KEY (RESPONSABLE)
                              REFERENCES RESPONSABLE
go

ALTER TABLE CAJA_CHICA
	ADD CONSTRAINT CACHCTRCTAREEM 
		FOREIGN KEY (CENTRO_REEMBOLSOS, CUENTA_REEMBOLSOS)
			REFERENCES CENTRO_CUENTA (CENTRO_COSTO, CUENTA_CONTABLE)
go

 
 
 ALTER TABLE CONCEPTO_VALE
        ADD CONSTRAINT CTRCTACONVALE
               FOREIGN KEY (CENTRO_COSTO, CUENTA_CONTABLE)
                              REFERENCES CENTRO_CUENTA
go
 
 
ALTER TABLE CONCEPTO_VALE 
	ADD CONSTRAINT CONVALE_CTACRETASUM
		FOREIGN KEY (CTR_CTO_RET_ASUM, CTA_CTB_RET_ASUM)
			REFERENCES CENTRO_CUENTA 
go
 

 
ALTER TABLE DESG_IMPUESTO_CH
         ADD CONSTRAINT DESGIMPCHIMPUESTO
         	FOREIGN KEY  ( CODIGO_IMPUESTO )
         		REFERENCES IMPUESTO ( IMPUESTO )
go  
         		
ALTER TABLE CONCEPTO_VALE ADD 
	CONSTRAINT FK_CONCEPTO_MODELO 
		FOREIGN KEY (MODELO_RETENCION)  
			REFERENCES MODELO_RETENCION (MODELO_RETENCION)
go
         		
 ALTER TABLE DESG_IMPUESTO_CH
        ADD CONSTRAINT DESGIMPCHDOCSOPOR
               FOREIGN KEY (VALE, LINEA)
                              REFERENCES DOCS_SOPORTE
                              ON DELETE CASCADE
go 
 
 
 ALTER TABLE DET_RETENCION_CH
        ADD CONSTRAINT DETRETCHRET
               FOREIGN KEY (CODIGO_RETENCION)
                              REFERENCES RETENCIONES
go
 
 
 ALTER TABLE DET_RETENCION_CH
        ADD CONSTRAINT DETRETCHDOCSOP
               FOREIGN KEY (VALE, LINEA)
                              REFERENCES DOCS_SOPORTE
                              ON DELETE CASCADE
go
 
 
 ALTER TABLE DOCS_SOPORTE
        ADD CONSTRAINT CONVALEDOCSSOP
               FOREIGN KEY (CONCEPTO)
                              REFERENCES CONCEPTO_VALE
go
 
 
 ALTER TABLE DOCS_SOPORTE 
 	ADD CONSTRAINT VALEDOCSSOP 
 		FOREIGN KEY ( VALE ) 
 			REFERENCES VALE ( CONSECUTIVO ) 
			ON DELETE CASCADE 
go
 
 
 ALTER TABLE DOCS_SOPORTE
        ADD CONSTRAINT NITDOCSOP
               FOREIGN KEY (NIT)
                              REFERENCES NIT
go
 
 
 ALTER TABLE DOCS_SOPORTE
        ADD CONSTRAINT CCDOCSOP
               FOREIGN KEY (CENTRO_COSTO, CUENTA_CONTABLE)
                              REFERENCES CENTRO_CUENTA
go
 
 
ALTER TABLE DOCS_SOPORTE
        ADD CONSTRAINT DOCSOPCODIMP
               FOREIGN KEY (CODIGO_IMPUESTO)
                              REFERENCES IMPUESTO
go                              
                              
ALTER TABLE DOCS_SOPORTE 
        ADD CONSTRAINT DOCSOPDIVGEO
               FOREIGN KEY (PAIS,DIVISION_GEOGRAFICA1,DIVISION_GEOGRAFICA2 )
                              REFERENCES DIVISION_GEOGRAFICA2
go                              
 
 
 ALTER TABLE GLOBALES_CH
        ADD CONSTRAINT IMPGLOCH
               FOREIGN KEY (IMPUESTO_OMISION)
                              REFERENCES IMPUESTO
go
 
 
 ALTER TABLE GLOBALES_CH
        ADD CONSTRAINT CCGLOCH
               FOREIGN KEY (CENTRO_COSTO_AD, CUENTA_CONTABLE_AD)
                              REFERENCES CENTRO_CUENTA
go
 
 
 ALTER TABLE GLOBALES_CH
        ADD CONSTRAINT PAQGLOBCH
               FOREIGN KEY (PAQUETE)
                              REFERENCES PAQUETE
go
 
 
 ALTER TABLE GLOBALES_CH
        ADD CONSTRAINT TIPASIGLOBCH
               FOREIGN KEY (TIPO_ASIENTO)
                              REFERENCES TIPO_ASIENTO
go
 

ALTER TABLE GLOBALES_CH
       ADD CONSTRAINT GLOBCHPRESUPCR
              FOREIGN KEY (PRESUPUESTO_CR)
                             REFERENCES PRESUPUESTO_CR (PRESUPUESTO)
go


ALTER TABLE GLOBALES_CH
       ADD CONSTRAINT GLOBCHPAQUETECR
              FOREIGN KEY (PAQUETE_CR)
                             REFERENCES PAQUETE_CR (PAQUETE)
go



ALTER TABLE $$Compania$$.GLOBALES_CH 
	ADD  CONSTRAINT FK_CENTRO_CUENTA_RUBRO1 
		FOREIGN KEY(CTR_RUBRO1_CH, CTA_RUBRO1_CH)
			REFERENCES  $$Compania$$.CENTRO_CUENTA (CENTRO_COSTO, CUENTA_CONTABLE)
go			
			

ALTER TABLE $$Compania$$.GLOBALES_CH 
	ADD  CONSTRAINT FK_CENTRO_CUENTA_RUBRO2 
		FOREIGN KEY(CTR_RUBRO2_CH, CTA_RUBRO2_CH)
			REFERENCES  $$Compania$$.CENTRO_CUENTA (CENTRO_COSTO, CUENTA_CONTABLE)
go			
			

ALTER TABLE $$Compania$$.GLOBALES_CH 
		ADD  CONSTRAINT FK_CENTRO_CUENTA_IMP1 
			FOREIGN KEY(CTR_IMPUESTO1_CH, CTA_IMPUESTO1_CH)
				REFERENCES  $$Compania$$.CENTRO_CUENTA (CENTRO_COSTO, CUENTA_CONTABLE)
go


ALTER TABLE $$Compania$$.GLOBALES_CH 
	ADD  CONSTRAINT FK_CENTRO_CUENTA_IMP2 
		FOREIGN KEY(CTR_IMPUESTO2_CH, CTA_IMPUESTO2_CH)
			REFERENCES  $$Compania$$.CENTRO_CUENTA (CENTRO_COSTO, CUENTA_CONTABLE)
go

 
 ALTER TABLE PROCESOCH
        ADD CONSTRAINT CAJAPROCESOCH
               FOREIGN KEY (CAJA_CHICA)
                              REFERENCES CAJA_CHICA
go
 
 
 ALTER TABLE USUARIO_CAJA
        ADD CONSTRAINT FKCAJAUSUARIO
               FOREIGN KEY (CAJA_CHICA)
                              REFERENCES CAJA_CHICA
go
 
 
 ALTER TABLE VALE
        ADD CONSTRAINT CAJACHVALE
               FOREIGN KEY (CAJA_CHICA)
                              REFERENCES CAJA_CHICA
go
 
 
 ALTER TABLE VALE
        ADD CONSTRAINT CONVALEVALE
               FOREIGN KEY (CONCEPTO_VALE)
                              REFERENCES CONCEPTO_VALE
go
 
 
 ALTER TABLE VALE
        ADD CONSTRAINT DEPTOVALE
               FOREIGN KEY (DEPARTAMENTO)
                              REFERENCES DEPARTAMENTO
go


ALTER TABLE VALE
         ADD CONSTRAINT PRESUPUESTOCRVALE
         	FOREIGN KEY  ( PRESUPUESTO_CR )
         		REFERENCES PRESUPUESTO_CR ( PRESUPUESTO )
go



ALTER TABLE VALE_MOV_PRES
	ADD CONSTRAINT FKVALEMOVPRES
		FOREIGN KEY (VALE)
			REFERENCES VALE(CONSECUTIVO)
			ON DELETE CASCADE
go



ALTER TABLE VALE_MOV_PRES
         ADD CONSTRAINT VALEMOVPRESPRESUPCR
         	FOREIGN KEY  ( PRESUPUESTO )
         		REFERENCES PRESUPUESTO_CR ( PRESUPUESTO )
go
 
 