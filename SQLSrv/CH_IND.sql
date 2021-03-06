CREATE INDEX FKDEIMPCHVLLN ON DESG_IMPUESTO_CH  
(
	VALE, 
	LINEA 
)
go
 

CREATE INDEX FKDEIMPCHCDIMP ON DESG_IMPUESTO_CH  
(
	CODIGO_IMPUESTO 
)
go


CREATE INDEX FKDERECHVLLN ON DET_RETENCION_CH
 (
        VALE,
        LINEA
 )
go
 
 CREATE INDEX FKDERECHCDRE ON DET_RETENCION_CH
 (
        CODIGO_RETENCION
 )
go
 
 CREATE INDEX FKDOCSOPCECU ON DOCS_SOPORTE
 (
        CENTRO_COSTO,
        CUENTA_CONTABLE
 )
go
 
 CREATE INDEX FKDOCSOPNIT ON DOCS_SOPORTE
 (
        NIT
 )
go
 
 CREATE INDEX FKDOCSOPVALE ON DOCS_SOPORTE
 (
        VALE
 )
go
 
 CREATE INDEX FKDOCSOPCONPT ON DOCS_SOPORTE
 (
        CONCEPTO
 )
go
 
  CREATE INDEX FHPROCECHCJCH ON PROCESOCH
 (
        CAJA_CHICA
 )
go
 
  CREATE INDEX FKVALEDEPA ON VALE
 (
        DEPARTAMENTO
 )
go
 
 CREATE INDEX FKVALECOVA ON VALE
 (
        CONCEPTO_VALE
 )
go
 
 CREATE INDEX FKVALECJCH ON VALE
 (
        CAJA_CHICA
 )
go
 
 CREATE INDEX XIE1VALECAJA ON VALE
 (
        CAJA_CHICA,
        VALE
 )
go

 
 