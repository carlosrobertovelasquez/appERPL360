
 CREATE INDEX XIE1CHEQUECTAPAGA ON CHEQUE
 (
        PAGADERO_A,
        CUENTA_BANCO
 )
go
 
 CREATE INDEX XIE2CHEQUECTASELEC ON CHEQUE
 (
        CUENTA_BANCO,
        SELECCIONADO
 )
go
 
 CREATE INDEX XIE1CTABANNOMB ON CUENTA_BANCARIA
 (
        NOMBRE
 )
go
 
 CREATE INDEX FKMOVBANCONT ON MOV_BANCOS
 (
        CONTRIBUYENTE
 )
go
 
 CREATE INDEX FKMOVBANUSMO ON MOV_BANCOS
 (
        USUARIO_MODIFIC
 )
go
 
 CREATE INDEX FKMOVBANUSCR ON MOV_BANCOS
 (
        USUARIO_CREACION
 )
go
 
 CREATE INDEX FKMOVBANTDST ON MOV_BANCOS
 (
        TIPO_DOCUMENTO,
        SUBTIPO
 )
go
 
 CREATE INDEX FKMOVBANCTAB ON MOV_BANCOS
 (
        CUENTA_BANCO
 )
go
 
 CREATE INDEX FKMOVBANPROV ON MOV_BANCOS
 (
        PROVEEDOR
 )
go
 
 CREATE INDEX FKMOVBANDORE ON MOV_BANCOS
 (
        DOC_REPORTADO
 )
go
 
 CREATE INDEX FKMOVBANDOAJ ON MOV_BANCOS
 (
        DOC_AJUSTE
 )
go
 
 CREATE INDEX FKMOVBANCBCO ON MOV_BANCOS
 (
        CUENTA_BANCO,
        CONCILIACION
 )
go
 
 CREATE INDEX FKMOVBANCBCA ON MOV_BANCOS
 (
        CUENTA_BANCO,
        CONCIL_ACLARACION
 )
go
 
 CREATE INDEX XIE2MOV_BANCTAESTF ON MOV_BANCOS
 (
        CUENTA_BANCO,
        ESTADO,
        FECHA
 )
go
 
 