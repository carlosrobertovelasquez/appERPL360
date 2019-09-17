REMARK
\
SCRIPT DE MODIFICACION EXACTUS
=================================================================
MODULO:     POS
VERSION ANTERIOR: 6.0 
VERSION QUE GENERA: 6.0 
DBMS:     SQL SERVER
FECHA:      12/11/2007
ANALISTA:   MALFARO
DESCRIPCION:    Modi de Generacion de Tienda 7, Crea ciertas funciones, procedures y triggers
      necesarios en la tienda
ATENCION !!!:
    Estas sentencias SQL deben de ejecutarse conectado como el
    el Usuario Administrador. Para el correcto funcionamiento del mismo!!!
    
    Se debe sustituir $$Compania$$ por el nombre de la compañía.
=================================================================
/
;

CREATE NONCLUSTERED INDEX XIEXISTENCIA 
	ON $$COMPANIA$$.AUDIT_TRANS_INV (APLICACION) INCLUDE (REFERENCIA);


CREATE TABLE AUDIT_EXISTENCIA
(
  CAJA    VARCHAR(10),
  DOCUMENTO VARCHAR(50),
    FECHA   DATETIME  DEFAULT GETDATE(),
  TIPO    VARCHAR(1),
  LINEA   VARCHAR(4),
  BODEGA    VARCHAR(4),
  ARTICULO  VARCHAR(20),
  CANT_DISPONIBLE DECIMAL(28,8),
  CANT_RESERVADA  DECIMAL(28,8),
  CANT_REMITIDA DECIMAL(28,8) NULL,
  TEXTO   VARCHAR(100)
)
;


CREATE FUNCTION $$Compania$$.MANEJA_EXISTENCIAS
(
  @ARTICULO VARCHAR(20)
)
RETURNS BIT
AS
BEGIN
  DECLARE @Tipo VARCHAR(1)
  DECLARE @ValidaExistencia BIT
  SET @ValidaExistencia = 1 
  DECLARE ARTICULOS CURSOR FOR
    SELECT TIPO
    FROM $$Compania$$.ARTICULO
    WHERE ARTICULO = @ARTICULO
  OPEN ARTICULOS
  FETCH NEXT FROM ARTICULOS INTO @Tipo
  IF  @@FETCH_STATUS = 0
  BEGIN
    IF (  @Tipo = 'P'
      OR @Tipo = 'L'
      OR @Tipo = 'V'
      OR @Tipo = 'F'
      OR @Tipo = 'S'
      OR @Tipo = 'O'
      OR @Tipo = 'K'
    )
    BEGIN
      SET @ValidaExistencia = 0
    END
  END
  CLOSE ARTICULOS
  DEALLOCATE ARTICULOS
  RETURN @ValidaExistencia
END
;


CREATE FUNCTION $$Compania$$.ES_ARTICULO_KIT
(
  @ARTICULO VARCHAR(20)
)
RETURNS BIT
AS
BEGIN
  DECLARE @Tipo VARCHAR(1)
  DECLARE @EsKit BIT
  SET @EsKit = 0
  DECLARE ARTICULOS CURSOR FOR
    SELECT TIPO
    FROM $$Compania$$.ARTICULO
    WHERE ARTICULO = @ARTICULO
  OPEN ARTICULOS
  FETCH NEXT FROM ARTICULOS INTO @Tipo
  IF  @@FETCH_STATUS = 0
  BEGIN
    IF @Tipo = 'K'
    BEGIN
      SET @EsKit = 1
    END
  END
  CLOSE ARTICULOS
  DEALLOCATE ARTICULOS
  RETURN @EsKit
END
;

CREATE PROCEDURE $$Compania$$.REGENERACION_EXISTENCIAS (@ARTBUSQUEDA VARCHAR(20)) 
AS 
BEGIN 
    DECLARE @ARTICULO VARCHAR(20) 
    DECLARE @BODEGA VARCHAR(4) 
    DECLARE @DISPONIBLE DECIMAL (28, 8) 
    DECLARE @RESERVADO DECIMAL (28, 8) 
    DECLARE @VENCIDO DECIMAL (28, 8) 
    DECLARE @NO_APROBADA DECIMAL (28, 8) 
    DECLARE @REMITIDA DECIMAL (28, 8) 
    
    IF NOT EXISTS (SELECT * 
               FROM   sysindexes 
               WHERE  name = 'XIEXISTENCIA') 
      BEGIN 
	CREATE NONCLUSTERED INDEX XIEXISTENCIA 
	  	ON $$COMPANIA$$.AUDIT_TRANS_INV (APLICACION) INCLUDE (REFERENCIA)
      END     

    IF EXISTS (SELECT * 
               FROM   sysobjects 
               WHERE  name = 'CUADRE_EXISTENCIA_POS') 
      BEGIN 
          DROP TABLE $$Compania$$.cuadre_existencia_pos 
      END 

    IF @ARTBUSQUEDA IS NULL 
      BEGIN 
          SET @ARTBUSQUEDA = '%' 

          UPDATE $$Compania$$.existencia_bodega
          SET    cant_disponible = 0, 
                 cant_reservada = 0, 
                 cant_vencida = 0, 
                 cant_no_aprobada = 0, 
                 cant_remitida = 0 
          FROM $$Compania$$.EXISTENCIA_BODEGA  WITH ( INDEX (EXISTENCIABODEGAPK) )
          WHERE  bodega IN (SELECT bodega 
                            FROM   $$Compania$$.v_tienda_off_bodega 
                            WHERE  tienda_off = (SELECT tienda_off_local 
                                                 FROM   $$Compania$$.globales_pos)) 
          AND (cant_disponible <> 0 OR cant_reservada <> 0 OR cant_vencida <> 0 OR cant_no_aprobada <> 0 OR cant_remitida <> 0 )                                                   
      END
    ELSE
      BEGIN
          UPDATE $$Compania$$.existencia_bodega 
          SET    cant_disponible = 0, 
                 cant_reservada = 0, 
                 cant_vencida = 0, 
                 cant_no_aprobada = 0, 
                 cant_remitida = 0 
          WHERE  articulo = @ARTBUSQUEDA 
                 AND bodega IN (SELECT bodega 
                                FROM   $$Compania$$.v_tienda_off_bodega 
                                WHERE tienda_off = (SELECT tienda_off_local 
                                                    FROM   $$Compania$$.globales_pos))          
      END

    SELECT articulo, 
           bodega, 
           Sum (CASE 
                  WHEN transaccion_inv.naturaleza = 'E' 
                       AND ( transaccion_inv.tipo = 'R' 
                              OR transaccion_inv.tipo = 'A' 
                              OR transaccion_inv.subtipo = 'D' ) THEN 
                  Abs(Isnull( 
                  transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'S' 
                       AND ( transaccion_inv.tipo = 'R' 
                              OR transaccion_inv.tipo = 'A' 
                              OR transaccion_inv.subtipo = 'D' ) THEN - 
                  Abs(Isnull(transaccion_inv.cantidad, 0)) 
                  ELSE 0 
                END) AS disponible, 
           Sum (CASE 
                  WHEN transaccion_inv.naturaleza = 'S' 
                       AND transaccion_inv.tipo = 'R' THEN Abs( 
                  Isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' 
                       AND transaccion_inv.tipo <> 'R' 
                       AND transaccion_inv.subtipo = 'R' THEN Abs(Isnull( 
                  transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' 
                       AND transaccion_inv.tipo = 'R' THEN -Abs( 
                  Isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'S' 
                       AND transaccion_inv.tipo <> 'R' 
                       AND transaccion_inv.subtipo = 'R' THEN - 
                  Abs(Isnull( 
                  transaccion_inv.cantidad, 0)) 
                  ELSE 0 
                END) AS reservado, 
           Sum (CASE 
                  WHEN transaccion_inv.naturaleza = 'S' 
                       AND transaccion_inv.tipo = 'N' THEN Abs( 
                  Isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' 
                       AND transaccion_inv.tipo <> 'N' 
                       AND transaccion_inv.subtipo = 'V' THEN Abs(Isnull( 
                  transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' 
                       AND transaccion_inv.tipo = 'N' THEN -Abs( 
                  Isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'S' 
                       AND transaccion_inv.tipo <> 'N' 
                       AND transaccion_inv.subtipo = 'V' THEN - 
                  Abs(Isnull( 
                  transaccion_inv.cantidad, 0)) 
                  ELSE 0 
                END) AS vencido, 
           Sum (CASE 
                  WHEN transaccion_inv.naturaleza = 'S' 
                       AND transaccion_inv.tipo = 'A' THEN Abs( 
                  Isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' 
                       AND transaccion_inv.tipo <> 'A' 
                       AND transaccion_inv.subtipo = 'C' THEN Abs(Isnull( 
                  transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' 
                       AND transaccion_inv.tipo = 'A' THEN -Abs( 
                  Isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'S' 
                       AND transaccion_inv.tipo <> 'A' 
                       AND transaccion_inv.subtipo = 'C' THEN - 
                  Abs(Isnull( 
                  transaccion_inv.cantidad, 0)) 
                  ELSE 0 
                END) AS no_aprobada, 
           Sum (CASE 
                  WHEN transaccion_inv.naturaleza = 'S' 
                       AND transaccion_inv.tipo = 'I' THEN Abs( 
                  Isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' 
                       AND transaccion_inv.tipo <> 'I' 
                       AND transaccion_inv.subtipo = 'I' THEN Abs(Isnull( 
                  transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' 
                       AND transaccion_inv.tipo = 'I' THEN -Abs( 
                  Isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'S' 
                       AND transaccion_inv.tipo <> 'I' 
                       AND transaccion_inv.subtipo = 'I' THEN - 
                  Abs(Isnull( 
                  transaccion_inv.cantidad, 0)) 
                  ELSE 0 
                END) AS remitida 
    INTO   $$Compania$$.cuadre_existencia_pos 
    FROM   $$Compania$$.transaccion_inv TRANSACCION_INV WITH (nolock) 
    WHERE  transaccion_inv.tipo IN ( 'A', 'C', 'E', 'F', 
                                     'I', 'M', 'N', 'O', 
                                     'P', 'R', 'T', 'V' ) 
           AND transaccion_inv.bodega IN (SELECT bodega 
                                          FROM   $$Compania$$.v_tienda_off_bodega 
                                          WHERE tienda_off = (SELECT tienda_off_local 
                                                              FROM   $$Compania$$.globales_pos)) 
           AND ( transaccion_inv.articulo = @ARTBUSQUEDA 
                  OR transaccion_inv.articulo LIKE @ARTBUSQUEDA ) 
    GROUP  BY articulo, 
              bodega 
    ORDER  BY 1 

    DECLARE c_existencia CURSOR local FOR 
      SELECT CEX.articulo, 
             CEX.bodega, 
             CEX.disponible, 
             CEX.reservado, 
             CEX.vencido, 
             CEX.no_aprobada, 
             CEX.remitida 
      FROM   $$Compania$$.existencia_bodega EX 
             INNER JOIN $$Compania$$.cuadre_existencia_pos CEX 
                     ON EX.articulo = CEX.articulo 
                        AND EX.bodega = CEX.bodega 
      WHERE  EX.cant_disponible <> CEX.disponible 
              OR EX.cant_reservada <> CEX.reservado 
              OR EX.cant_remitida <> CEX.remitida 
              OR EX.cant_no_aprobada <> CEX.no_aprobada 
              OR EX.cant_vencida <> CEX.vencido 

    OPEN c_existencia 

    FETCH next FROM c_existencia INTO @ARTICULO, @BODEGA, @DISPONIBLE, 
    @RESERVADO, @VENCIDO, @NO_APROBADA, @REMITIDA 

    WHILE @@FETCH_STATUS = 0 
      BEGIN 
          UPDATE $$Compania$$.existencia_bodega 
          SET    cant_disponible = @DISPONIBLE, 
                 cant_reservada = @RESERVADO, 
                 cant_vencida = @VENCIDO, 
                 cant_no_aprobada = @NO_APROBADA, 
                 cant_remitida = @REMITIDA 
          WHERE  articulo = @ARTICULO 
                 AND bodega = @BODEGA 

          FETCH next FROM c_existencia INTO @ARTICULO, @BODEGA, @DISPONIBLE, 
          @RESERVADO, @VENCIDO, @NO_APROBADA, @REMITIDA 
      END 

    DROP TABLE $$Compania$$.cuadre_existencia_pos 

    CLOSE c_existencia 

    DEALLOCATE c_existencia 
END
;

CREATE PROCEDURE $$Compania$$.REGENERACION_EXISTENCIAS_LOTE (@ARTBUSQUEDA VARCHAR(20)) 
AS 
BEGIN 
    DECLARE @ARTICULO VARCHAR(20) 
    DECLARE @BODEGA VARCHAR(4) 
    DECLARE @LOTE VARCHAR(15) 
    DECLARE @LOCALIZACION VARCHAR(8) 
    DECLARE @DISPONIBLE DECIMAL (28, 8) 
    DECLARE @RESERVADO DECIMAL (28, 8) 
    DECLARE @VENCIDO DECIMAL (28, 8) 
    DECLARE @NO_APROBADA DECIMAL (28, 8) 
    DECLARE @REMITIDA DECIMAL (28, 8) 
    
    IF NOT EXISTS (SELECT * 
               FROM   sysindexes 
               WHERE  name = 'XIEXISTENCIA') 
      BEGIN 
	CREATE NONCLUSTERED INDEX XIEXISTENCIA 
	 	ON $$COMPANIA$$.AUDIT_TRANS_INV (APLICACION) INCLUDE (REFERENCIA) 
      END 

    IF EXISTS (SELECT * 
               FROM   sysobjects 
               WHERE  name = 'CUADRE_EXISTENCIA_LOTE_POS') 
      BEGIN 
          DROP TABLE $$Compania$$.cuadre_existencia_lote_pos 
      END 

    IF @ARTBUSQUEDA IS NULL 
      BEGIN 
          SET @ARTBUSQUEDA = '%' 

          UPDATE $$Compania$$.EXISTENCIA_LOTE
          SET    cant_disponible = 0, 
                 cant_reservada = 0, 
                 cant_vencida = 0, 
                 cant_no_aprobada = 0, 
                 cant_remitida = 0 
          FROM $$Compania$$.EXISTENCIA_LOTE  WITH ( INDEX (EXISTENCIALOTEPK) )
          WHERE  bodega IN (SELECT bodega 
                            FROM   $$Compania$$.v_tienda_off_bodega 
                            WHERE  tienda_off = (SELECT tienda_off_local 
                                                 FROM   $$Compania$$.globales_pos)) 
          AND (cant_disponible <> 0 OR cant_reservada <> 0 OR cant_vencida <> 0 OR cant_no_aprobada <> 0 OR cant_remitida <> 0 )                                                   
      END
    ELSE
      BEGIN
          UPDATE $$Compania$$.EXISTENCIA_LOTE 
          SET    cant_disponible = 0, 
                 cant_reservada = 0, 
                 cant_vencida = 0, 
                 cant_no_aprobada = 0, 
                 cant_remitida = 0 
          WHERE  articulo = @ARTBUSQUEDA 
          AND bodega IN (SELECT bodega 
                         FROM   $$Compania$$.v_tienda_off_bodega 
                         WHERE tienda_off = (SELECT tienda_off_local 
                                             FROM   $$Compania$$.globales_pos))         
      END 

    SELECT articulo, 
           bodega, 
           lote, 
           CASE (SELECT USA_LOCALIZACION FROM $$Compania$$.GLOBALES_CI) WHEN 'S' THEN localizacion ELSE 'ND' END localizacion,
            Sum (CASE 
                  WHEN transaccion_inv.naturaleza = 'E' 
                       AND ( transaccion_inv.tipo = 'R' 
                              OR transaccion_inv.tipo = 'A' 
                              OR transaccion_inv.subtipo = 'D' ) THEN 
                  Abs(Isnull( 
                  transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'S' 
                       AND ( transaccion_inv.tipo = 'R' 
                              OR transaccion_inv.tipo = 'A' 
                              OR transaccion_inv.subtipo = 'D' ) THEN - 
                  Abs(Isnull(transaccion_inv.cantidad, 0)) 
                  ELSE 0 
                END) AS DISPONIBLE, 
           Sum (CASE 
                  WHEN transaccion_inv.naturaleza = 'S' 
                       AND transaccion_inv.tipo = 'R' THEN Abs( 
                  Isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' 
                       AND transaccion_inv.tipo <> 'R' 
                       AND transaccion_inv.subtipo = 'R' THEN Abs(Isnull( 
                  transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' 
                       AND transaccion_inv.tipo = 'R' THEN -Abs( 
                  Isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'S' 
                       AND transaccion_inv.tipo <> 'R' 
                       AND transaccion_inv.subtipo = 'R' THEN - 
                  Abs(Isnull( 
                  transaccion_inv.cantidad, 0)) 
                  ELSE 0 
                END) AS RESERVADO, 
           Sum (CASE 
                  WHEN transaccion_inv.naturaleza = 'S' 
                       AND transaccion_inv.tipo = 'N' THEN Abs( 
                  Isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' 
                       AND transaccion_inv.tipo <> 'N' 
                       AND transaccion_inv.subtipo = 'V' THEN Abs(Isnull( 
                  transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' 
                       AND transaccion_inv.tipo = 'N' THEN -Abs( 
                  Isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'S' 
                       AND transaccion_inv.tipo <> 'N' 
                       AND transaccion_inv.subtipo = 'V' THEN - 
                  Abs(Isnull( 
                  transaccion_inv.cantidad, 0)) 
                  ELSE 0 
                END) AS VENCIDO, 
           Sum (CASE 
                  WHEN transaccion_inv.naturaleza = 'S' 
                       AND transaccion_inv.tipo = 'A' THEN Abs( 
                  Isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' 
                       AND transaccion_inv.tipo <> 'A' 
                       AND transaccion_inv.subtipo = 'C' THEN Abs(Isnull( 
                  transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' 
                       AND transaccion_inv.tipo = 'A' THEN -Abs( 
                  Isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'S' 
                       AND transaccion_inv.tipo <> 'A' 
                       AND transaccion_inv.subtipo = 'C' THEN - 
                  Abs(Isnull( 
                  transaccion_inv.cantidad, 0)) 
                  ELSE 0 
                END) AS NO_APROBADA, 
           Sum (CASE 
                  WHEN transaccion_inv.naturaleza = 'S' 
                       AND transaccion_inv.tipo = 'I' THEN Abs( 
                  Isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' 
                       AND transaccion_inv.tipo <> 'I' 
                       AND transaccion_inv.subtipo = 'I' THEN Abs(Isnull( 
                  transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'E' 
                       AND transaccion_inv.tipo = 'I' THEN -Abs( 
                  Isnull(transaccion_inv.cantidad, 0)) 
                  WHEN transaccion_inv.naturaleza = 'S' 
                       AND transaccion_inv.tipo <> 'I' 
                       AND transaccion_inv.subtipo = 'I' THEN - 
                  Abs(Isnull( 
                  transaccion_inv.cantidad, 0)) 
                  ELSE 0 
                END) AS REMITIDA 
    INTO   $$Compania$$.cuadre_existencia_lote_pos 
    FROM   $$Compania$$.transaccion_inv TRANSACCION_INV WITH (nolock) 
    WHERE  transaccion_inv.tipo IN ( 'A', 'C', 'E', 'F', 
                                     'I', 'M', 'N', 'O', 
                                     'P', 'R', 'T', 'V' ) 
           AND transaccion_inv.bodega IN (SELECT bodega 
                                          FROM   $$Compania$$.v_tienda_off_bodega 
                                          WHERE tienda_off = (SELECT tienda_off_local 
                                                              FROM   $$Compania$$.globales_pos)) 
           AND ( transaccion_inv.articulo = @ARTBUSQUEDA 
                  OR transaccion_inv.articulo LIKE @ARTBUSQUEDA ) 
           AND (LOTE IS NOT NULL OR LOCALIZACION IS NOT NULL) 
    GROUP  BY articulo, 
              bodega, 
              lote, 
              localizacion 
    ORDER  BY 1 

    DECLARE c_existencia CURSOR local FOR 
      SELECT CEX.articulo, 
             CEX.bodega, 
             CEX.Lote, 
             CEX.Localizacion, 
             CEX.disponible, 
             CEX.reservado, 
             CEX.vencido, 
             CEX.no_aprobada, 
             CEX.remitida 
      FROM   $$Compania$$.existencia_lote EX 
             INNER JOIN $$Compania$$.cuadre_existencia_lote_pos CEX 
                     ON EX.articulo = CEX.articulo 
                        AND EX.bodega = CEX.bodega 
      WHERE  EX.cant_disponible <> CEX.disponible 
              OR EX.cant_reservada <> CEX.reservado 
              OR EX.cant_remitida <> CEX.remitida 
              OR EX.cant_no_aprobada <> CEX.no_aprobada 
              OR EX.cant_vencida <> CEX.vencido 

    OPEN c_existencia 

    FETCH next FROM c_existencia INTO @ARTICULO, @BODEGA, @LOTE, @LOCALIZACION, @DISPONIBLE,
     @RESERVADO, @VENCIDO, @NO_APROBADA, @REMITIDA 

    WHILE @@FETCH_STATUS = 0 
      BEGIN 
          UPDATE $$Compania$$.existencia_lote 
          SET    cant_disponible = @DISPONIBLE, 
                 cant_reservada = @RESERVADO, 
                 cant_vencida = @VENCIDO, 
                 cant_no_aprobada = @NO_APROBADA, 
                 cant_remitida = @REMITIDA 
          WHERE  articulo = @ARTICULO 
                 AND bodega = @BODEGA 
                 AND lote = @LOTE 
                 AND Localizacion = @LOCALIZACION 

          FETCH next FROM c_existencia INTO @ARTICULO, @BODEGA, @LOTE, @LOCALIZACION, @DISPONIBLE,
     @RESERVADO, @VENCIDO, @NO_APROBADA, @REMITIDA 
      END 

    DROP TABLE $$Compania$$.cuadre_existencia_lote_pos 

    CLOSE c_existencia 

    DEALLOCATE c_existencia 
END
;


CREATE PROCEDURE $$Compania$$.REGENERACION_EXISTENCIAS_DOCUM (@ARTBUSQUEDA VARCHAR(20)) 
AS 
BEGIN 
    DECLARE @ARTICULO VARCHAR(20) 
    DECLARE @BODEGA VARCHAR(4) 
    DECLARE @DISPONIBLE DECIMAL (28, 8) 
    DECLARE @RESERVADO DECIMAL (28, 8) 
    DECLARE @REMITIDA DECIMAL (28, 8) 
    DECLARE @CantidadDisponible DECIMAL (28, 8) 
    DECLARE @CantidadReservada DECIMAL (28, 8) 
    DECLARE @CantidadRemitida DECIMAL (28, 8) 
    DECLARE @DisponibleActualizado DECIMAL (28, 8) 
    DECLARE @ReservadoActualizado DECIMAL (28, 8) 
    DECLARE @RemitidoActualizado DECIMAL (28, 8) 

    IF NOT EXISTS (SELECT * 
               FROM   sysindexes 
               WHERE  name = 'XIEXISTENCIA') 
      BEGIN 
	CREATE NONCLUSTERED INDEX XIEXISTENCIA 
		  ON $$COMPANIA$$.AUDIT_TRANS_INV (APLICACION) INCLUDE (REFERENCIA) 
      END 

    IF @ARTBUSQUEDA IS NULL 
      BEGIN 
          SET @ARTBUSQUEDA = '%' 
      END 

    DECLARE c_existencia CURSOR local FOR 
    SELECT doc_pos_linea.articulo, 
           doc_pos_linea.bodega, 
           Sum (CASE 
                  WHEN ( documento_pos.tipo = 'F' 
                          OR documento_pos.tipo = 'T' ) 
                       AND ( documento_pos.estado_cobro = 'C' ) THEN -Abs(Isnull( 
                doc_pos_linea.cantidad, 0)) 
                  WHEN documento_pos.tipo = 'D' 
                       AND documento_pos.estado_cobro IN ( 'C', 'P' ) THEN 
                  Abs(Isnull(doc_pos_linea.cantidad, 0)) 
                  WHEN documento_pos.tipo = 'P' 
                       AND documento_pos.estado_cobro IN ( 'V' ) THEN Abs(Isnull( 
                doc_pos_linea.cantidad, 0)) 
                  WHEN documento_pos.tipo = 'P' 
                       AND documento_pos.estado_cobro IN ( 'P' ) THEN -Abs(Isnull( 
                doc_pos_linea.cantidad, 0)) 
                  ELSE 0 
                END) AS disponible, 
           Sum (CASE 
                  WHEN documento_pos.tipo = 'P' 
                       AND documento_pos.estado_cobro = 'P' THEN 
                  Abs(Isnull( 
                  doc_pos_linea.cantidad, 0)) 
                  ELSE 0 
                END) AS reservado, 
           Sum (CASE 
                  WHEN documento_pos.tipo = 'T' 
                       AND documento_pos.estado_cobro = 'C' THEN 
                  Abs(Isnull( 
                  doc_pos_linea.cantidad, 0)) 
                  ELSE 0 
                END) AS remitido 
    FROM   $$Compania$$.documento_pos DOCUMENTO_POS, 
           $$Compania$$.doc_pos_linea DOC_POS_LINEA, 
           $$Compania$$.grupo_caja GRUPO_CAJA 
    WHERE  documento_pos.documento = doc_pos_linea.documento 
           AND documento_pos.caja = doc_pos_linea.caja 
           AND documento_pos.tipo = doc_pos_linea.tipo 
           AND ( ( documento_pos.estado_cobro IN ( 'P', 'C' ) 
                   AND documento_pos.tipo IN ( 'P', 'D' ) ) 
                  OR ( documento_pos.estado_cobro IN ( 'C' ) 
                       AND documento_pos.tipo IN ( 'F', 'T' ) ) ) 
           AND documento_pos.caja = grupo_caja.caja 
           AND documento_pos.exportado = 'N' 
           AND ( $$Compania$$.Maneja_existencias (doc_pos_linea.articulo) = 1 ) 
           AND doc_pos_linea.bodega IN (SELECT bodega 
                                        FROM   $$Compania$$.v_tienda_off_bodega 
                                        WHERE  tienda_off = 
                                               (SELECT tienda_off_local 
                                                FROM   $$Compania$$.globales_pos)) 
           AND ( doc_pos_linea.articulo = @ARTBUSQUEDA 
                  OR doc_pos_linea.articulo LIKE @ARTBUSQUEDA ) 
           AND CASE 
             WHEN (SELECT Count(0) 
                   FROM   $$COMPANIA$$.auxiliar_pos 
                   WHERE  documento = documento_pos.documento 
                          AND caja = documento_pos.caja 
                          AND tipo = documento_pos.tipo 
                          AND tipo_aplica = 'P'
						  AND tipo = 'F') > 0 
			 THEN 
				 (
				  SELECT caja_docum_aplica + tipo_aplica + docum_aplica 
				  FROM $$COMPANIA$$.auxiliar_pos 
				  WHERE  documento = documento_pos.documento 
				  AND caja = documento_pos.caja 
				  AND tipo = documento_pos.tipo 
				  AND tipo_aplica = 'P' 
				 ) 
             ELSE 
				 documento_pos.caja + documento_pos.tipo 
					  + documento_pos.documento 
           END NOT IN (SELECT aplicacion 
                       FROM   $$COMPANIA$$.audit_trans_inv WITH (nolock, INDEX( 
                              xiexistencia)) 
                       WHERE  Substring (referencia, 0, 4) = 'POS') 
           AND 0 < (SELECT Count(0) 
                    FROM   $$Compania$$.existencia_bodega EX 
                    WHERE  EX.articulo = doc_pos_linea.articulo 
                           AND EX.bodega = doc_pos_linea.bodega 
                           AND EX.updatedby = 'SoftlandSync') 
    GROUP  BY doc_pos_linea.articulo, 
              doc_pos_linea.bodega 
    ORDER  BY 1  

    OPEN c_existencia 

    FETCH next FROM c_existencia INTO @ARTICULO, @BODEGA, @DISPONIBLE, 
    @RESERVADO, @REMITIDA 

    WHILE @@FETCH_STATUS = 0 
      BEGIN 
          SELECT @CantidadDisponible = cant_disponible, 
                 @CantidadReservada = cant_reservada, 
                 @CantidadRemitida = cant_remitida 
          FROM   $$Compania$$.existencia_bodega 
          WHERE  articulo = @ARTICULO 
                 AND bodega = @BODEGA 

          SET @DisponibleActualizado = @CantidadDisponible + @DISPONIBLE 
          SET @ReservadoActualizado = @CantidadReservada + @RESERVADO 
          SET @RemitidoActualizado = @CantidadRemitida + @REMITIDA 

          UPDATE $$Compania$$.existencia_bodega 
          SET    cant_disponible = @DisponibleActualizado, 
                 cant_reservada = @ReservadoActualizado, 
                 cant_remitida = @RemitidoActualizado 
          WHERE  articulo = @ARTICULO 
                 AND bodega = @BODEGA 

          FETCH next FROM c_existencia INTO @ARTICULO, @BODEGA, @DISPONIBLE, 
          @RESERVADO, @REMITIDA 
      END 

    CLOSE c_existencia 

    DEALLOCATE c_existencia 
END 
;


CREATE PROCEDURE $$Compania$$.REGENERACION_EXISTENCIAS_LOTE_DOCUM (@ARTBUSQUEDA VARCHAR(20)) 
AS 
BEGIN 
    DECLARE @ARTICULO VARCHAR(20) 
    DECLARE @BODEGA VARCHAR(4) 
    DECLARE @LOTE VARCHAR(15) 
    DECLARE @LOCALIZACION VARCHAR(8) 
    DECLARE @DISPONIBLE DECIMAL (28, 8) 
    DECLARE @RESERVADO DECIMAL (28, 8) 
    DECLARE @REMITIDA DECIMAL (28, 8) 
    DECLARE @CantidadDisponible DECIMAL (28, 8) 
    DECLARE @CantidadReservada DECIMAL (28, 8) 
    DECLARE @CantidadRemitida DECIMAL (28, 8) 
    DECLARE @DisponibleActualizado DECIMAL (28, 8) 
    DECLARE @ReservadoActualizado DECIMAL (28, 8) 
    DECLARE @RemitidoActualizado DECIMAL (28, 8) 

    IF NOT EXISTS (SELECT * 
               FROM   sysindexes 
               WHERE  name = 'XIEXISTENCIA') 
      BEGIN 
	CREATE NONCLUSTERED INDEX XIEXISTENCIA 
	  	ON $$COMPANIA$$.AUDIT_TRANS_INV (APLICACION) INCLUDE (REFERENCIA) 
      END 

    IF @ARTBUSQUEDA IS NULL 
      BEGIN 
          SET @ARTBUSQUEDA = '%' 
      END 

    DECLARE c_existencia CURSOR local FOR 
      SELECT doc_pos_linea.articulo, 
             doc_pos_linea.bodega, 
             doc_pos_linea.lote, 
             CASE (SELECT usa_localizacion 
                   FROM   $$Compania$$.globales_ci) 
               WHEN 'S' THEN ISNULL(doc_pos_linea.localizacion,'ND') 
               ELSE 'ND' 
             END       localizacion, 
             Sum (CASE 
                    WHEN ( documento_pos.tipo = 'F' 
                            OR documento_pos.tipo = 'T' ) 
                         AND ( documento_pos.estado_cobro = 'C' ) THEN -Abs( 
                    Isnull( 
                  doc_pos_linea.cantidad, 0)) 
                    WHEN documento_pos.tipo = 'D' 
                         AND documento_pos.estado_cobro IN ( 'C', 'P' ) THEN 
                    Abs(Isnull(doc_pos_linea.cantidad, 0)) 
                    WHEN documento_pos.tipo = 'P' 
                         AND documento_pos.estado_cobro IN ( 'V' ) THEN Abs( 
                    Isnull( 
                  doc_pos_linea.cantidad, 0)) 
                    WHEN documento_pos.tipo = 'P' 
                         AND documento_pos.estado_cobro IN ( 'P' ) THEN -Abs( 
                    Isnull( 
                  doc_pos_linea.cantidad, 0)) 
                    ELSE 0 
                  END) AS disponible, 
             Sum (CASE 
                    WHEN documento_pos.tipo = 'P' 
                         AND documento_pos.estado_cobro = 'P' THEN 
                    Abs(Isnull( 
                    doc_pos_linea.cantidad, 0)) 
                    ELSE 0 
                  END) AS reservado, 
             Sum (CASE 
                    WHEN documento_pos.tipo = 'T' 
                         AND documento_pos.estado_cobro = 'C' THEN 
                    Abs(Isnull( 
                    doc_pos_linea.cantidad, 0)) 
                    ELSE 0 
                  END) AS remitido 
      FROM   $$Compania$$.documento_pos DOCUMENTO_POS, 
             $$Compania$$.doc_pos_linea DOC_POS_LINEA, 
             $$Compania$$.grupo_caja GRUPO_CAJA 
      WHERE  documento_pos.documento = doc_pos_linea.documento 
             AND documento_pos.caja = doc_pos_linea.caja 
             AND documento_pos.tipo = doc_pos_linea.tipo 
             AND ( ( documento_pos.estado_cobro IN ( 'P', 'C' ) 
                     AND documento_pos.tipo IN ( 'P', 'D' ) ) 
                    OR ( documento_pos.estado_cobro IN ( 'C' ) 
                         AND documento_pos.tipo IN ( 'F', 'T' ) ) ) 
             AND documento_pos.caja = grupo_caja.caja 
             AND documento_pos.exportado = 'N' 
             AND ($$Compania$$.MANEJA_EXISTENCIAS (DOC_POS_LINEA.ARTICULO) = 1)
             AND doc_pos_linea.bodega IN (SELECT bodega 
                                          FROM   $$Compania$$.v_tienda_off_bodega 
                                          WHERE  tienda_off = 
                                                 (SELECT tienda_off_local 
                                                  FROM   $$Compania$$.globales_pos)) 
             AND ( doc_pos_linea.articulo = @ARTBUSQUEDA 
                    OR doc_pos_linea.articulo LIKE @ARTBUSQUEDA ) 
             AND CASE 
					 WHEN (SELECT Count(0) 
						   FROM   $$COMPANIA$$.auxiliar_pos 
						   WHERE  documento = documento_pos.documento 
								  AND caja = documento_pos.caja 
								  AND tipo = documento_pos.tipo 
								  AND tipo_aplica = 'P'
								  AND tipo = 'F') > 0 
					 THEN 
						 (
						  SELECT caja_docum_aplica + tipo_aplica + docum_aplica 
						  FROM $$COMPANIA$$.auxiliar_pos 
						  WHERE  documento = documento_pos.documento 
						  AND caja = documento_pos.caja 
						  AND tipo = documento_pos.tipo 
						  AND tipo_aplica = 'P' 
						 ) 
					 ELSE 
						 documento_pos.caja + documento_pos.tipo 
							  + documento_pos.documento 
				   END NOT IN (SELECT aplicacion 
							   FROM   $$COMPANIA$$.audit_trans_inv WITH (nolock, INDEX( 
									  xiexistencia)) 
							   WHERE  Substring (referencia, 0, 4) = 'POS')  
             AND ( doc_pos_linea.lote IS NOT NULL 
                    OR doc_pos_linea.localizacion IS NOT NULL ) 
             AND 0 < (SELECT Count(0) 
                      FROM   $$Compania$$.existencia_lote EX 
                      WHERE  EX.articulo = doc_pos_linea.articulo 
                             AND EX.bodega = doc_pos_linea.bodega
                             AND EX.lote = doc_pos_linea.lote
                             AND EX.localizacion = ISNULL(doc_pos_linea.localizacion,'ND')
                             AND EX.updatedby = 'SoftlandSync')                     
      GROUP  BY doc_pos_linea.articulo, 
                doc_pos_linea.bodega, 
                doc_pos_linea.lote, 
                doc_pos_linea.localizacion 
      ORDER  BY 1 

    OPEN c_existencia 

    FETCH next FROM c_existencia INTO @ARTICULO, @BODEGA, @LOTE, @LOCALIZACION, @DISPONIBLE, @RESERVADO, @REMITIDA 

    WHILE @@FETCH_STATUS = 0 
      BEGIN 
          SELECT @CantidadDisponible = cant_disponible, 
                 @CantidadReservada = cant_reservada, 
                 @CantidadRemitida = cant_remitida 
          FROM   $$Compania$$.existencia_lote 
          WHERE  articulo = @ARTICULO 
                 AND bodega = @BODEGA 
                 AND lote = @LOTE 
                 AND localizacion = @LOCALIZACION 

          SET @DisponibleActualizado = @CantidadDisponible + @DISPONIBLE 
          SET @ReservadoActualizado = @CantidadReservada + @RESERVADO 
          SET @RemitidoActualizado = @CantidadRemitida + @REMITIDA 

          UPDATE $$Compania$$.existencia_lote 
          SET    cant_disponible = @DisponibleActualizado, 
                 cant_reservada = @ReservadoActualizado, 
                 cant_remitida = @RemitidoActualizado 
          WHERE  articulo = @ARTICULO 
                 AND bodega = @BODEGA 
                 AND lote = @LOTE 
                 AND localizacion = @LOCALIZACION 

          FETCH next FROM c_existencia INTO @ARTICULO, @BODEGA, @LOTE, @LOCALIZACION, @DISPONIBLE, @RESERVADO, @REMITIDA 
      END 

    CLOSE c_existencia 

    DEALLOCATE c_existencia 
END
;

CREATE PROCEDURE $$Compania$$.ACTUALIZA_EXISTENCIA_BODEGA
(
  @psBodega AS VARCHAR(4),
  @psArticulo AS VARCHAR(20),
  @pnCantidadDisponible as DECIMAL(28,8),
  @pnCantidadReservada as DECIMAL(28,8),
  @pnCantidadRemitida as DECIMAL(28,8)
)
AS
BEGIN
  DECLARE @MensajeError VARCHAR(1000) 
  DECLARE @Porc_Rebajo_MediaUnidad DECIMAL(28,8)
  DECLARE @MediaUnidadDetalle DECIMAL(28,8)
  DECLARE @Factor_Empaque DECIMAL(28,8)
  DECLARE @CantDipRebajada DECIMAL (28,8)
  DECLARE @CantSolicitadaDisp DECIMAL (28,8)
  DECLARE @CantSolicitadaReserv DECIMAL (28,8)
  DECLARE @ObtenerMediaUnidadDet DECIMAL (28,8)
  DECLARE @Disponible_Almacen DECIMAL (28,8)
  DECLARE @Reservada_Almacen DECIMAL (28,8)
  DECLARE @CantSolicitadaRemit DECIMAL (28,8)
  DECLARE @Remitida_Almacen DECIMAL (28,8)
  
  IF @psBodega IS NULL OR @psArticulo IS NULL
    RETURN
    
  IF 0 = (SELECT COUNT(BODEGA) FROM $$Compania$$.V_TIENDA_OFF_BODEGA WHERE TIENDA_OFF IN (SELECT TIENDA_OFF_LOCAL FROM $$Compania$$.GLOBALES_POS) AND BODEGA = @psBodega)
    RETURN
    
  IF @pnCantidadDisponible IS NULL
    SET @pnCantidadDisponible = 0
  IF @pnCantidadReservada IS NULL
    SET @pnCantidadReservada = 0
  IF @pnCantidadRemitida IS NULL
    SET @pnCantidadRemitida = 0
    
  IF EXISTS( SELECT 'x' FROM $$Compania$$.EXISTENCIA_BODEGA WHERE BODEGA = @psBodega AND ARTICULO = @psArticulo )
    BEGIN
      IF @pnCantidadDisponible = 0 AND @pnCantidadReservada = 0 AND @pnCantidadRemitida = 0
        RETURN
      
      SELECT @Disponible_Almacen = CANT_DISPONIBLE, @Reservada_Almacen = CANT_RESERVADA, @Remitida_Almacen = CANT_REMITIDA
      FROM $$Compania$$.EXISTENCIA_BODEGA 
      WHERE  BODEGA = @psBodega AND ARTICULO  = @psArticulo 

      --Obtiene Factor de Empaque
      SELECT  @Factor_Empaque  = FACTOR_EMPAQUE FROM $$Compania$$.ARTICULO WHERE  ARTICULO = @psArticulo
      SET @Porc_Rebajo_MediaUnidad = 0.01
      
      --Obtener Media Unidad Detalle
      IF @Factor_Empaque > 0 
      BEGIN
        SET @MediaUnidadDetalle = (1 / @Factor_Empaque) / 2
        SET @ObtenerMediaUnidadDet = @MediaUnidadDetalle - (@MediaUnidadDetalle * @Porc_Rebajo_MediaUnidad)       
      END
      
      SET @CantSolicitadaDisp = ABS(@pnCantidadDisponible) * @Factor_Empaque      
      IF @Disponible_Almacen + @CantSolicitadaDisp < 0
      BEGIN

        SET @CantDipRebajada = @Disponible_Almacen - @CantSolicitadaDisp
        IF (Abs(@CantDipRebajada) < @ObtenerMediaUnidadDet)
        BEGIN
          SET @pnCantidadDisponible = -@Disponible_Almacen
        END
      END

      SET @CantSolicitadaReserv = ABS(@pnCantidadReservada) * @Factor_Empaque
      IF @Reservada_Almacen + @CantSolicitadaReserv < 0
      BEGIN
        SET @CantDipRebajada = @Reservada_Almacen - @CantSolicitadaReserv
        IF (Abs(@CantDipRebajada) < @ObtenerMediaUnidadDet)
        BEGIN
          SET @pnCantidadReservada = -@Reservada_Almacen
        END
      END

      SET @CantSolicitadaRemit = ABS(@pnCantidadRemitida) * @Factor_Empaque
      IF @Remitida_Almacen + @CantSolicitadaRemit < 0
      BEGIN
        SET @CantDipRebajada = @Remitida_Almacen - @CantSolicitadaRemit
        IF (Abs(@CantDipRebajada) < @ObtenerMediaUnidadDet)
        BEGIN
          SET @pnCantidadRemitida = -@Remitida_Almacen
        END
      END

      --Pregunta si las cantidades disponibles y reservadas son mayores a '0' antes de actualizar
      IF ((SELECT VALIDAR_EXISTENCIAS FROM $$Compania$$.GLOBALES_POS) = 'S')
      BEGIN
        IF @Disponible_Almacen + @pnCantidadDisponible < 0 OR @Reservada_Almacen + @pnCantidadReservada < 0 OR @Remitida_Almacen + @pnCantidadRemitida < 0
        BEGIN
          SET @MensajeError = 'Error al validar existencias. El artículo ' + @psArticulo + ' no tiene la cantidad suficiente en la bodega ' + @psBodega + ' para facturar.'

          IF @Disponible_Almacen + @pnCantidadDisponible < 0
          BEGIN
            SET @MensajeError = @MensajeError + ' Cantidad Disponible Faltante: ' + CONVERT(VARCHAR(30), ABS(@Disponible_Almacen + @pnCantidadDisponible))
          END

          IF @Reservada_Almacen + @pnCantidadReservada < 0
          BEGIN
            SET @MensajeError = @MensajeError + ' Cantidad Reservada Faltante: ' + CONVERT(VARCHAR(30), ABS(@Reservada_Almacen + @pnCantidadReservada))
          END

          IF @Remitida_Almacen + @pnCantidadRemitida < 0
          BEGIN
            SET @MensajeError = @MensajeError + ' Cantidad Remitida Faltante: ' + CONVERT(VARCHAR(30), ABS(@Remitida_Almacen + @pnCantidadRemitida))
          END   

          RAISERROR(@MensajeError,16,1)
        END
      END     
      
      UPDATE $$Compania$$.EXISTENCIA_BODEGA
      SET CANT_DISPONIBLE = CANT_DISPONIBLE + @pnCantidadDisponible,
        CANT_RESERVADA = CANT_RESERVADA + @pnCantidadReservada,
        CANT_REMITIDA = CANT_REMITIDA + @pnCantidadRemitida
      WHERE BODEGA = @psBodega 
      AND ARTICULO = @psArticulo
    END
  ELSE
    BEGIN
      INSERT INTO $$Compania$$.EXISTENCIA_BODEGA (
        ARTICULO, 
        BODEGA, 
        EXISTENCIA_MINIMA, 
        EXISTENCIA_MAXIMA, 
        PUNTO_DE_REORDEN,       
        CANT_DISPONIBLE, 
        CANT_RESERVADA, 
        CANT_NO_APROBADA, 
        CANT_VENCIDA,
        CANT_TRANSITO, 
        CANT_PRODUCCION, 
        CANT_PEDIDA, 
        CANT_REMITIDA, 
        CONGELADO,
        FECHA_CONG, 
        BLOQUEA_TRANS, 
        FECHA_DESCONG
      )
      VALUES
      (
        @psArticulo, 
        @psBodega, 
        0, 
        0, 
        0,
        @pnCantidadDisponible, 
        @pnCantidadReservada, 
        0, 
        0,
        0, 
        0, 
        0, 
        @pnCantidadRemitida, 
        'N',
        NULL, 
        'N', 
        NULL
      )
    END
END
;


CREATE PROCEDURE $$Compania$$.ACTUALIZA_EXISTENCIA_LOTE
 (
   @psBodega AS VARCHAR(4),
   @psArticulo AS VARCHAR(20),
   @psLote AS VARCHAR(15),
   @psLocalizacion AS VARCHAR(8),
   @pnCantidadDisponible as DECIMAL(28,8),
   @pnCantidadReservada as DECIMAL(28,8),
   @pnCantidadRemitida as DECIMAL(28,8)
 )
 AS
 BEGIN
  DECLARE @MensajeError VARCHAR(1000) 
    DECLARE @Porc_Rebajo_MediaUnidad DECIMAL(28,8)
    DECLARE @MediaUnidadDetalle DECIMAL(28,8)  
    DECLARE @Factor_Empaque DECIMAL(28,8)
    DECLARE @CantDipRebajada DECIMAL (28,8)
    DECLARE @CantSolicitadaDisp DECIMAL (28,8)
    DECLARE @CantSolicitadaReserv DECIMAL (28,8)
    DECLARE @ObtenerMediaUnidadDet DECIMAL (28,8)
    DECLARE @Disponible_Almacen DECIMAL (28,8)
    DECLARE @Reservada_Almacen DECIMAL (28,8)
    DECLARE @CantSolicitadaRemit DECIMAL (28,8)
    DECLARE @Remitida_Almacen DECIMAL (28,8)
 
  IF @psBodega IS NULL OR @psArticulo IS NULL
    RETURN

  IF 0 = (SELECT COUNT(BODEGA) FROM $$Compania$$.V_TIENDA_OFF_BODEGA WHERE TIENDA_OFF IN (SELECT TIENDA_OFF_LOCAL FROM $$Compania$$.GLOBALES_POS) AND BODEGA = @psBodega)
    RETURN
  IF @pnCantidadDisponible IS NULL
    SET @pnCantidadDisponible = 0
  IF @pnCantidadReservada IS NULL
    SET @pnCantidadReservada = 0
  IF @pnCantidadRemitida IS NULL
    SET @pnCantidadRemitida = 0
  
  IF @psLocalizacion IS NULL
    SET @psLocalizacion = 'ND'  
   
  IF EXISTS( SELECT 'x' FROM $$Compania$$.EXISTENCIA_LOTE WHERE BODEGA = @psBodega AND ARTICULO = @psArticulo AND LOTE = @psLote AND LOCALIZACION = @psLocalizacion )
    BEGIN
       IF @pnCantidadDisponible = 0 AND @pnCantidadReservada = 0 AND @pnCantidadRemitida = 0
           RETURN
   
    SELECT @Disponible_Almacen = CANT_DISPONIBLE, @Reservada_Almacen = CANT_RESERVADA, @Remitida_Almacen = CANT_REMITIDA
    FROM $$Compania$$.EXISTENCIA_LOTE
    WHERE  BODEGA = @psBodega AND ARTICULO = @psArticulo AND LOTE = @psLote AND LOCALIZACION = @psLocalizacion
   
    SELECT  @Factor_Empaque  = FACTOR_EMPAQUE FROM $$Compania$$.ARTICULO WHERE  ARTICULO = @psArticulo
    
    SET @Porc_Rebajo_MediaUnidad = 0.01
   
    IF @Factor_Empaque > 0 
    BEGIN
      SET @MediaUnidadDetalle = (1 / @Factor_Empaque) / 2
      SET @ObtenerMediaUnidadDet = @MediaUnidadDetalle - (@MediaUnidadDetalle * @Porc_Rebajo_MediaUnidad)     
    END
   
    SET @CantSolicitadaDisp = ABS(@pnCantidadDisponible) * @Factor_Empaque

    IF @Disponible_Almacen + @CantSolicitadaDisp < 0
    BEGIN
      SET @CantDipRebajada = @Disponible_Almacen - @CantSolicitadaDisp
      IF (Abs(@CantDipRebajada) < @ObtenerMediaUnidadDet)
      BEGIN
        SET @pnCantidadDisponible = -@Disponible_Almacen
      END
    END
 
    SET @CantSolicitadaReserv = ABS(@pnCantidadReservada) * @Factor_Empaque
    IF @Reservada_Almacen + @CantSolicitadaReserv < 0
    BEGIN
      SET @CantDipRebajada = @Reservada_Almacen - @CantSolicitadaReserv
      IF (Abs(@CantDipRebajada) < @ObtenerMediaUnidadDet)
      BEGIN
        SET @pnCantidadReservada = -@Reservada_Almacen
      END
    END
 
    SET @CantSolicitadaRemit = ABS(@pnCantidadRemitida) * @Factor_Empaque
    IF @Remitida_Almacen + @CantSolicitadaRemit < 0
    BEGIN
      SET @CantDipRebajada = @Remitida_Almacen - @CantSolicitadaRemit
      IF (Abs(@CantDipRebajada) < @ObtenerMediaUnidadDet)
      BEGIN
        SET @pnCantidadRemitida = -@Remitida_Almacen
      END
    END 
   
    IF ((SELECT VALIDAR_EXISTENCIAS FROM $$Compania$$.GLOBALES_POS) = 'S')
    BEGIN
      IF @Disponible_Almacen + @pnCantidadDisponible < 0 OR @Reservada_Almacen + @pnCantidadReservada < 0 OR @Remitida_Almacen + @pnCantidadRemitida < 0
      BEGIN
        SET @MensajeError = 'Error al validar existencias. El artículo ' + @psArticulo + ' no tiene la cantidad suficiente en la bodega ' + @psBodega + ' para facturar.'

        IF @Disponible_Almacen + @pnCantidadDisponible < 0
        BEGIN
          SET @MensajeError = @MensajeError + ' Cantidad Disponible Faltante: ' + CONVERT(VARCHAR(30), ABS(@Disponible_Almacen + @pnCantidadDisponible))
        END

        IF @Reservada_Almacen + @pnCantidadReservada < 0
        BEGIN
          SET @MensajeError = @MensajeError + ' Cantidad Reservada Faltante: ' + CONVERT(VARCHAR(30), ABS(@Reservada_Almacen + @pnCantidadReservada))
        END

        IF @Remitida_Almacen + @pnCantidadRemitida < 0
        BEGIN
          SET @MensajeError = @MensajeError + ' Cantidad Remitida Faltante: ' + CONVERT(VARCHAR(30), ABS(@Remitida_Almacen + @pnCantidadRemitida))
        END   

        RAISERROR(@MensajeError,16,1)
      END
    END   
   
    UPDATE $$Compania$$.EXISTENCIA_LOTE
    SET CANT_DISPONIBLE = CANT_DISPONIBLE + @pnCantidadDisponible,
      CANT_RESERVADA = CANT_RESERVADA + @pnCantidadReservada,
      CANT_REMITIDA = CANT_REMITIDA + @pnCantidadRemitida
    WHERE BODEGA = @psBodega 
    AND ARTICULO = @psArticulo 
    AND LOTE = @psLote
    AND LOCALIZACION = @psLocalizacion 
  END
  ELSE
  BEGIN
    INSERT INTO $$Compania$$.EXISTENCIA_LOTE 
    (
      ARTICULO, 
      BODEGA, 
      LOTE, 
      LOCALIZACION, 
      CANT_DISPONIBLE, 
      CANT_RESERVADA, 
      CANT_NO_APROBADA, 
      CANT_VENCIDA, 
      CANT_REMITIDA
    )
    VALUES
    (
      @psArticulo, 
      @psBodega, 
      @psLote, 
      @psLocalizacion, 
      @pnCantidadDisponible, 
      @pnCantidadReservada, 
      0, 
      0, 
      @pnCantidadRemitida
    )
  END
 END
;


CREATE PROCEDURE $$Compania$$.ACT_EXIST_BODEGA
(
  @psBodega AS VARCHAR(4),
  @psArticulo AS VARCHAR(20),
  @pnCantidadDisponible as DECIMAL(28,8),
  @pnCantidadReservada as DECIMAL(28,8),
  @pnCantidadRemitida as DECIMAL(28,8)
)
AS
BEGIN
  DECLARE @MensajeError VARCHAR(1000) 
  DECLARE @Porc_Rebajo_MediaUnidad DECIMAL(28,8)
  DECLARE @MediaUnidadDetalle DECIMAL(28,8)
  DECLARE @Factor_Empaque DECIMAL(28,8)
  DECLARE @CantDipRebajada DECIMAL (28,8)
  DECLARE @CantSolicitadaDisp DECIMAL (28,8)
  DECLARE @CantSolicitadaReserv DECIMAL (28,8)
  DECLARE @ObtenerMediaUnidadDet DECIMAL (28,8)
  DECLARE @Disponible_Almacen DECIMAL (28,8)
  DECLARE @Reservada_Almacen DECIMAL (28,8)
  DECLARE @CantSolicitadaRemit DECIMAL (28,8)
  DECLARE @Remitida_Almacen DECIMAL (28,8)

  IF @pnCantidadDisponible IS NULL
    SET @pnCantidadDisponible = 0
  IF @pnCantidadReservada IS NULL
    SET @pnCantidadReservada = 0
  IF @pnCantidadRemitida IS NULL
    SET @pnCantidadRemitida = 0
  
  IF @psBodega IS NULL OR @psArticulo IS NULL
    RETURN
    
  IF 0 = (SELECT COUNT(BODEGA) FROM $$Compania$$.V_TIENDA_OFF_BODEGA WHERE TIENDA_OFF IN (SELECT TIENDA_OFF_LOCAL FROM $$Compania$$.GLOBALES_POS) AND BODEGA = @psBodega)
    RETURN
    
  IF @pnCantidadDisponible = 0 AND @pnCantidadReservada = 0 AND @pnCantidadRemitida = 0
    RETURN    
    
  IF NOT EXISTS( SELECT 'x' FROM $$Compania$$.EXISTENCIA_BODEGA WHERE BODEGA = @psBodega AND ARTICULO = @psArticulo )
  BEGIN
    INSERT INTO $$Compania$$.EXISTENCIA_BODEGA (
          ARTICULO, 
          BODEGA, 
          EXISTENCIA_MINIMA, 
          EXISTENCIA_MAXIMA, 
          PUNTO_DE_REORDEN,       
          CANT_DISPONIBLE, 
          CANT_RESERVADA, 
          CANT_NO_APROBADA, 
          CANT_VENCIDA,
          CANT_TRANSITO, 
          CANT_PRODUCCION, 
          CANT_PEDIDA, 
          CANT_REMITIDA, 
          CONGELADO,
          FECHA_CONG, 
          BLOQUEA_TRANS, 
          FECHA_DESCONG
        )
        VALUES
        (
          @psArticulo, 
          @psBodega, 
          0, 
          0, 
          0,
          0, 
          0, 
          0, 
          0,
          0, 
          0, 
          0, 
          0, 
          'N',
          NULL, 
          'N', 
          NULL
        )
  END

  --Pregunta si las cantidades disponibles y reservadas son mayores a '0' antes de actualizar
  IF ((SELECT VALIDAR_EXISTENCIAS FROM $$Compania$$.GLOBALES_POS) = 'S')
  BEGIN 
    SELECT @Disponible_Almacen = CANT_DISPONIBLE, @Reservada_Almacen = CANT_RESERVADA, @Remitida_Almacen = CANT_REMITIDA
    FROM $$Compania$$.EXISTENCIA_BODEGA 
    WHERE  BODEGA = @psBodega AND ARTICULO  = @psArticulo 

    --Obtiene Factor de Empaque
    SELECT  @Factor_Empaque  = FACTOR_EMPAQUE FROM $$Compania$$.ARTICULO WHERE  ARTICULO = @psArticulo
    SET @Porc_Rebajo_MediaUnidad = 0.01
    
    --Obtener Media Unidad Detalle
    IF @Factor_Empaque > 0 
    BEGIN
      SET @MediaUnidadDetalle = (1 / @Factor_Empaque) / 2
      SET @ObtenerMediaUnidadDet = @MediaUnidadDetalle - (@MediaUnidadDetalle * @Porc_Rebajo_MediaUnidad)       
    END
    
    SET @CantSolicitadaDisp = ABS(@pnCantidadDisponible) * @Factor_Empaque      
    IF @Disponible_Almacen + @CantSolicitadaDisp < 0
    BEGIN
        SET @CantDipRebajada = @Disponible_Almacen - @CantSolicitadaDisp
        IF (Abs(@CantDipRebajada) < @ObtenerMediaUnidadDet)
        BEGIN
          SET @pnCantidadDisponible = -@Disponible_Almacen
        END
    END

    SET @CantSolicitadaReserv = ABS(@pnCantidadReservada) * @Factor_Empaque
    IF @Reservada_Almacen + @CantSolicitadaReserv < 0
    BEGIN
        SET @CantDipRebajada = @Reservada_Almacen - @CantSolicitadaReserv
        IF (Abs(@CantDipRebajada) < @ObtenerMediaUnidadDet)
        BEGIN
          SET @pnCantidadReservada = -@Reservada_Almacen
        END
    END

    SET @CantSolicitadaRemit = ABS(@pnCantidadRemitida) * @Factor_Empaque
    IF @Remitida_Almacen + @CantSolicitadaRemit < 0
    BEGIN
        SET @CantDipRebajada = @Remitida_Almacen - @CantSolicitadaRemit
        IF (Abs(@CantDipRebajada) < @ObtenerMediaUnidadDet)
        BEGIN
          SET @pnCantidadRemitida = -@Remitida_Almacen
        END
    END

    IF @Disponible_Almacen + @pnCantidadDisponible < 0 OR @Reservada_Almacen + @pnCantidadReservada < 0 OR @Remitida_Almacen + @pnCantidadRemitida < 0
    BEGIN
      SET @MensajeError = 'Error al validar existencias. El artículo ' + @psArticulo + ' no tiene la cantidad suficiente en la bodega ' + @psBodega + ' para facturar.'

      IF @Disponible_Almacen + @pnCantidadDisponible < 0
      BEGIN
        SET @MensajeError = @MensajeError + ' Cantidad Disponible Faltante: ' + CONVERT(VARCHAR(30), ABS(@Disponible_Almacen + @pnCantidadDisponible))
      END

      IF @Reservada_Almacen + @pnCantidadReservada < 0
      BEGIN
        SET @MensajeError = @MensajeError + ' Cantidad Reservada Faltante: ' + CONVERT(VARCHAR(30), ABS(@Reservada_Almacen + @pnCantidadReservada))
      END

      IF @Remitida_Almacen + @pnCantidadRemitida < 0
      BEGIN
        SET @MensajeError = @MensajeError + ' Cantidad Remitida Faltante: ' + CONVERT(VARCHAR(30), ABS(@Remitida_Almacen + @pnCantidadRemitida))
      END   

      RAISERROR(@MensajeError,16,1)
    END
  END     
  
  --Regenera la existencia del artículo con respecto a las transacciones de inventario
  EXEC $$Compania$$.Regeneracion_existencias @psArticulo

  --Aplica los documentos hechos en el POS y que aún no se han reflejado en las transacciones de inventario
  EXEC $$Compania$$.Regeneracion_existencias_docum  @psArticulo 
END
;


CREATE PROCEDURE $$Compania$$.ACT_EXIST_LOTE
 (
   @psBodega AS VARCHAR(4),
   @psArticulo AS VARCHAR(20),
   @psLote AS VARCHAR(15),
   @psLocalizacion AS VARCHAR(8),
   @pnCantidadDisponible as DECIMAL(28,8),
   @pnCantidadReservada as DECIMAL(28,8),
   @pnCantidadRemitida as DECIMAL(28,8)
 )
 AS
 BEGIN
    DECLARE @MensajeError VARCHAR(1000) 
    DECLARE @Porc_Rebajo_MediaUnidad DECIMAL(28,8)
    DECLARE @MediaUnidadDetalle DECIMAL(28,8)  
    DECLARE @Factor_Empaque DECIMAL(28,8)
    DECLARE @CantDipRebajada DECIMAL (28,8)
    DECLARE @CantSolicitadaDisp DECIMAL (28,8)
    DECLARE @CantSolicitadaReserv DECIMAL (28,8)
    DECLARE @ObtenerMediaUnidadDet DECIMAL (28,8)
    DECLARE @Disponible_Almacen DECIMAL (28,8)
    DECLARE @Reservada_Almacen DECIMAL (28,8)
    DECLARE @CantSolicitadaRemit DECIMAL (28,8)
    DECLARE @Remitida_Almacen DECIMAL (28,8)
 
  IF @psBodega IS NULL OR @psArticulo IS NULL
    RETURN
    
  IF 0 = (SELECT COUNT(BODEGA) FROM $$Compania$$.V_TIENDA_OFF_BODEGA WHERE TIENDA_OFF IN (SELECT TIENDA_OFF_LOCAL FROM $$Compania$$.GLOBALES_POS) AND BODEGA = @psBodega)
    RETURN

  IF @pnCantidadDisponible = 0 AND @pnCantidadReservada = 0 AND @pnCantidadRemitida = 0
     RETURN   
  
  IF @psLocalizacion IS NULL
    SET @psLocalizacion = 'ND'
    
  IF @pnCantidadDisponible IS NULL
    SET @pnCantidadDisponible = 0
  IF @pnCantidadReservada IS NULL
    SET @pnCantidadReservada = 0
  IF @pnCantidadRemitida IS NULL
    SET @pnCantidadRemitida = 0
  
  IF NOT EXISTS( SELECT 'x' FROM $$Compania$$.EXISTENCIA_LOTE WHERE BODEGA = @psBodega AND ARTICULO = @psArticulo AND LOTE = @psLote AND LOCALIZACION = @psLocalizacion )
  BEGIN
    INSERT INTO $$Compania$$.EXISTENCIA_LOTE 
    (
      ARTICULO, 
      BODEGA, 
      LOTE, 
      LOCALIZACION, 
      CANT_DISPONIBLE, 
      CANT_RESERVADA, 
      CANT_NO_APROBADA, 
      CANT_VENCIDA, 
      CANT_REMITIDA
    )
    VALUES
    (
      @psArticulo, 
      @psBodega, 
      @psLote, 
      @psLocalizacion, 
      0, 
      0, 
      0, 
      0, 
      0
    )   
  END  
  
  IF ((SELECT VALIDAR_EXISTENCIAS FROM $$Compania$$.GLOBALES_POS) = 'S')
  BEGIN
   
    SELECT @Disponible_Almacen = CANT_DISPONIBLE, @Reservada_Almacen = CANT_RESERVADA, @Remitida_Almacen = CANT_REMITIDA
    FROM $$Compania$$.EXISTENCIA_LOTE
    WHERE  BODEGA = @psBodega AND ARTICULO = @psArticulo AND LOTE = @psLote AND LOCALIZACION = @psLocalizacion
   
    SELECT  @Factor_Empaque  = FACTOR_EMPAQUE FROM $$Compania$$.ARTICULO WHERE  ARTICULO = @psArticulo
    
    SET @Porc_Rebajo_MediaUnidad = 0.01
   
    IF @Factor_Empaque > 0 
    BEGIN
      SET @MediaUnidadDetalle = (1 / @Factor_Empaque) / 2
      SET @ObtenerMediaUnidadDet = @MediaUnidadDetalle - (@MediaUnidadDetalle * @Porc_Rebajo_MediaUnidad)     
    END
   
    SET @CantSolicitadaDisp = ABS(@pnCantidadDisponible) * @Factor_Empaque

    IF @Disponible_Almacen + @CantSolicitadaDisp < 0
    BEGIN
      SET @CantDipRebajada = @Disponible_Almacen - @CantSolicitadaDisp
      IF (Abs(@CantDipRebajada) < @ObtenerMediaUnidadDet)
      BEGIN
        SET @pnCantidadDisponible = -@Disponible_Almacen
      END
    END

    SET @CantSolicitadaReserv = ABS(@pnCantidadReservada) * @Factor_Empaque
    IF @Reservada_Almacen + @CantSolicitadaReserv < 0
    BEGIN
      SET @CantDipRebajada = @Reservada_Almacen - @CantSolicitadaReserv
      IF (Abs(@CantDipRebajada) < @ObtenerMediaUnidadDet)
      BEGIN
        SET @pnCantidadReservada = -@Reservada_Almacen
      END
    END

    SET @CantSolicitadaRemit = ABS(@pnCantidadRemitida) * @Factor_Empaque
    IF @Remitida_Almacen + @CantSolicitadaRemit < 0
    BEGIN
      SET @CantDipRebajada = @Remitida_Almacen - @CantSolicitadaRemit
      IF (Abs(@CantDipRebajada) < @ObtenerMediaUnidadDet)
      BEGIN
        SET @pnCantidadRemitida = -@Remitida_Almacen
      END
    END 
 
    IF @Disponible_Almacen + @pnCantidadDisponible < 0 OR @Reservada_Almacen + @pnCantidadReservada < 0 OR @Remitida_Almacen + @pnCantidadRemitida < 0
    BEGIN
      SET @MensajeError = 'Error al validar existencias. El artículo ' + @psArticulo + ' no tiene la cantidad suficiente en la bodega ' + @psBodega + ' para facturar.'

      IF @Disponible_Almacen + @pnCantidadDisponible < 0
      BEGIN
        SET @MensajeError = @MensajeError + ' Cantidad Disponible Faltante: ' + CONVERT(VARCHAR(30), ABS(@Disponible_Almacen + @pnCantidadDisponible))
      END

      IF @Reservada_Almacen + @pnCantidadReservada < 0
      BEGIN
        SET @MensajeError = @MensajeError + ' Cantidad Reservada Faltante: ' + CONVERT(VARCHAR(30), ABS(@Reservada_Almacen + @pnCantidadReservada))
      END

      IF @Remitida_Almacen + @pnCantidadRemitida < 0
      BEGIN
        SET @MensajeError = @MensajeError + ' Cantidad Remitida Faltante: ' + CONVERT(VARCHAR(30), ABS(@Remitida_Almacen + @pnCantidadRemitida))
      END   

      RAISERROR(@MensajeError,16,1)
    END
  END   
   
  --Regenera la existencia por lotes/localizaciones del artículo con respecto a las transacciones de inventario
  EXEC $$Compania$$.Regeneracion_existencias_lote @psArticulo
  
  --Aplica los documentos hechos en el POS que aplicaron lotes/localizaciones y que aún no se han reflejado en las transacciones de inventario
  EXEC $$Compania$$.Regeneracion_existencias_lote_docum   @psArticulo     
END
;


CREATE PROCEDURE $$Compania$$.ACTUALIZA_EXISTENCIA
(
  @psBodega AS VARCHAR(4),
  @psArticulo AS VARCHAR(20),
  @psLote AS VARCHAR(15),
  @psLocalizacion AS VARCHAR(8),
  @pnCantidadDisponible as DECIMAL(28,8),
  @pnCantidadReservada as DECIMAL(28,8),
  @pnCantidadRemitida as DECIMAL(28,8)
)
AS
BEGIN

  EXEC $$Compania$$.ACTUALIZA_EXISTENCIA_BODEGA
            @psBodega,
            @psArticulo,
            @pnCantidadDisponible,
            @pnCantidadReservada,
            @pnCantidadRemitida
            
  IF ((SELECT MANEJO_LOTE FROM $$Compania$$.GLOBALES_POS) = 'S') AND
    ((SELECT USA_LOTES FROM $$Compania$$.ARTICULO WHERE  ARTICULO = @psArticulo) = 'S')
  BEGIN
    EXEC $$Compania$$.ACTUALIZA_EXISTENCIA_LOTE
              @psBodega,
              @psArticulo,
              @psLote,
              @psLocalizacion,
              @pnCantidadDisponible,
              @pnCantidadReservada,
              @pnCantidadRemitida
  END
END
;


CREATE PROCEDURE $$Compania$$.ACTUA_EXISTENCIA_GENERAL
(
  @psBodega AS VARCHAR(4),
  @psArticulo AS VARCHAR(20),
  @psLote AS VARCHAR(15),
  @psLocalizacion AS VARCHAR(8),
  @pnCantidadDisponible as DECIMAL(28,8),
  @pnCantidadReservada as DECIMAL(28,8),
  @pnCantidadRemitida as DECIMAL(28,8)
)
AS
BEGIN

  EXEC $$Compania$$.ACT_EXIST_BODEGA
            @psBodega,
            @psArticulo,
            @pnCantidadDisponible,
            @pnCantidadReservada,
            @pnCantidadRemitida
            
  IF ((SELECT MANEJO_LOTE FROM $$Compania$$.GLOBALES_POS) = 'S') AND
    ((SELECT USA_LOTES FROM $$Compania$$.ARTICULO WHERE  ARTICULO = @psArticulo) = 'S')
  BEGIN
    EXEC $$Compania$$.ACT_EXIST_LOTE
              @psBodega,
              @psArticulo,
              @psLote,
              @psLocalizacion,
              @pnCantidadDisponible,
              @pnCantidadReservada,
              @pnCantidadRemitida
  END
END
;


CREATE PROCEDURE $$Compania$$.EXPLOTA_LOTE_LOC_DISPONIBLE
(
  @ARTICULO_KIT VARCHAR(20),
  @BODEGA VARCHAR(4),
  @ARTICULO VARCHAR(20),
  @CANT_DISPONIBLE DECIMAL(28,8),
  @CANT_RESERVADA DECIMAL(28,8),
  @CANT_REMITIDA DECIMAL(28,8)
  
)
AS
BEGIN
  DECLARE @MensajeError VARCHAR(1000)
  
  DECLARE @Lote VARCHAR(15)
  DECLARE @Localizacion VARCHAR(8)
  --Existencia que tiene el lote en BD
  DECLARE @CantDispEnLote DECIMAL(28,8)
  DECLARE @CantResvEnLote DECIMAL(28,8)
  DECLARE @CantRemiEnLote DECIMAL(28,8)

  --Existencia pendiente de rebajar de los lotes
  DECLARE @CantPendDisponible DECIMAL(28,8)
  DECLARE @CantPendReservada DECIMAL(28,8)
  DECLARE @CantPendRemitida DECIMAL(28,8)
  
  --Existencia a rebajar del lote
  DECLARE @CantARebajarDisp DECIMAL(28,8)
  DECLARE @CantARebajarResv DECIMAL(28,8)
  DECLARE @CantARebajarRemi DECIMAL(28,8)
  
  
  SET @CantPendDisponible = ABS(@CANT_DISPONIBLE)
  SET @CantPendReservada = ABS(@CANT_RESERVADA)
  SET @CantPendRemitida = ABS(@CANT_REMITIDA)


  DECLARE EXIST_LOTE CURSOR FOR
    SELECT EXL.LOTE, EXL.LOCALIZACION, CANT_DISPONIBLE, CANT_RESERVADA, CANT_REMITIDA
    FROM $$Compania$$.EXISTENCIA_LOTE EXL 
        INNER JOIN $$Compania$$.LOTE LT
          ON EXL.ARTICULO = LT.ARTICULO
             AND EXL.LOTE = LT.LOTE 
    WHERE EXL.BODEGA = @BODEGA
    AND EXL.ARTICULO = @ARTICULO
    AND LT.ESTADO NOT IN ('V','C')
    AND LT.FECHA_VENCIMIENTO > GETDATE()
    ORDER BY EXL.LOTE, EXL.LOCALIZACION 
    
  OPEN EXIST_LOTE
  FETCH NEXT FROM EXIST_LOTE INTO @Lote, @Localizacion, @CantDispEnLote, @CantResvEnLote, @CantRemiEnLote
  
  WHILE @@FETCH_STATUS = 0 AND (@CantPendDisponible > 0 OR @CantPendReservada > 0 OR @CantPendRemitida > 0)
  BEGIN
    SET @CantARebajarDisp = 0
    SET @CantARebajarResv = 0
    SET @CantARebajarRemi = 0

    --Disponible
    IF @CANT_DISPONIBLE < 0
    BEGIN 
      IF @CantPendDisponible > @CantDispEnLote
        BEGIN
          SET @CantARebajarDisp = @CantDispEnLote
        END
      ELSE
        BEGIN
          SET @CantARebajarDisp = @CantPendDisponible
        END
    END
    ELSE
    BEGIN
      --Se trata de una devolución o anulación
      SET @CantARebajarDisp = @CANT_DISPONIBLE
    END
    
    --Reservado 
    IF @CANT_RESERVADA < 0
    BEGIN     
      IF @CantPendReservada > @CantResvEnLote
        BEGIN
          SET @CantARebajarResv = @CantResvEnLote
        END
      ELSE
        BEGIN
          SET @CantARebajarResv = @CantPendReservada
        END
    END
    ELSE
    BEGIN
      --Se trata de una devolución o anulación
      SET @CantARebajarResv = @CANT_RESERVADA
    END
  
    
    --Remitido  
    IF @CANT_REMITIDA < 0
    BEGIN     
      IF @CantPendRemitida > @CantRemiEnLote
        BEGIN
          SET @CantARebajarRemi = @CantRemiEnLote
        END
      ELSE
        BEGIN
          SET @CantARebajarRemi = @CantPendRemitida
        END
    END
    ELSE
    BEGIN
      --Se trata de una devolución o anulación
      SET @CantARebajarRemi = @CANT_REMITIDA
    END
    
    --Se asigna signo según signo que ingresa en el método
    IF @CANT_DISPONIBLE < 0
    BEGIN
      SET @CantARebajarDisp = @CantARebajarDisp * -1
    END
    
    IF @CANT_RESERVADA < 0
    BEGIN
      SET @CantARebajarResv = @CantARebajarResv * -1
    END
    
    IF @CANT_REMITIDA < 0
    BEGIN
      SET @CantARebajarRemi = @CantARebajarRemi * -1
    END   
  
    EXEC $$Compania$$.ACTUALIZA_EXISTENCIA_LOTE @BODEGA, @ARTICULO, @Lote, @Localizacion, @CantARebajarDisp, @CantARebajarResv, @CantARebajarRemi
    
    
    IF @CANT_DISPONIBLE > 0
    BEGIN
      SET @CantARebajarDisp = @CantARebajarDisp * -1
    END
    
    IF @CANT_RESERVADA > 0
    BEGIN
      SET @CantARebajarResv = @CantARebajarResv * -1
    END
    
    IF @CANT_REMITIDA > 0
    BEGIN
      SET @CantARebajarRemi = @CantARebajarRemi * -1
    END   
    
    SET @CantPendDisponible = @CantPendDisponible + @CantARebajarDisp
    SET @CantPendReservada = @CantPendReservada + @CantARebajarResv
    SET @CantPendRemitida = @CantPendRemitida + @CantARebajarRemi   
    
    FETCH NEXT FROM EXIST_LOTE INTO @Lote, @Localizacion, @CantDispEnLote, @CantResvEnLote, @CantRemiEnLote
  END
  CLOSE EXIST_LOTE
  DEALLOCATE EXIST_LOTE
  
  IF (@CantPendDisponible > 0 OR @CantPendReservada > 0 OR @CantPendRemitida > 0) AND (@CANT_DISPONIBLE < 0 OR @CANT_RESERVADA < 0 OR @CANT_REMITIDA < 0)
    BEGIN
      SET @MensajeError = 'Error al validar las existencias de los componentes del Kit "' + @ARTICULO_KIT + '". El artículo "' + @ARTICULO + '" no tiene la cantidad suficiente disponible para facturar.'
      IF @CantPendDisponible > 0
      BEGIN
        SET @MensajeError = @MensajeError + ' Cantidad Disponible Faltante: ' + CONVERT (VARCHAR(30),@CantPendDisponible)
      END
      
      IF @CantPendReservada > 0
      BEGIN
        SET @MensajeError = @MensajeError + ' Cantidad Reservada Faltante: ' + CONVERT (VARCHAR(30),@CantPendReservada)
      END

      IF @CantPendRemitida > 0
      BEGIN     
        SET @MensajeError = @MensajeError + ' Cantidad Remitida Faltante: ' + CONVERT (VARCHAR(30),@CantPendRemitida)
      END
      --Error porque no había lotes con existencias suficientes para el componente del Kit
      RAISERROR(@MensajeError,16,1)
    END
  ELSE
    BEGIN
      INSERT INTO $$Compania$$.AUDIT_EXISTENCIA
      (
        CAJA,
        DOCUMENTO,
        TIPO,
        LINEA,
        BODEGA,
        ARTICULO,
        CANT_DISPONIBLE,
        CANT_RESERVADA,
        CANT_REMITIDA,
        TEXTO
      )
      VALUES
      (
        'KIT',
        @ARTICULO_KIT,
        'K',
        '0',
        @BODEGA,
        @ARTICULO,
        @CANT_DISPONIBLE,
        @CANT_RESERVADA,
        @CANT_REMITIDA,
        'EXPLOTA_EXIST_COMP_KITS KIT: ' + @ARTICULO_KIT + ' Ensamble: ' + @ARTICULO
      )   
      EXEC $$Compania$$.ACTUALIZA_EXISTENCIA_BODEGA @BODEGA, @ARTICULO, @CANT_DISPONIBLE, @CANT_RESERVADA, @CANT_REMITIDA     
    END
END
;


CREATE PROCEDURE $$COMPANIA$$.EXPLOTA_EXIST_COMP_KITS
(
  @BODEGA VARCHAR(4),
  @ARTICULO VARCHAR(20),
  @LOTE VARCHAR(15),
  @LOCALIZACION VARCHAR(8),
  @CANT_DISPONIBLE DECIMAL(28,8),
  @CANT_RESERVADA DECIMAL(28,8),
  @CANT_REMITIDA DECIMAL(28,8)
)
AS
BEGIN
  DECLARE @ArticuloHijo VARCHAR(20)
  DECLARE @CantidadEnsamble DECIMAL(28,8)
  DECLARE @CantDispEnsamble DECIMAL(28,8)
  DECLARE @CantReservEnsamble DECIMAL(28,8)
  DECLARE @CantRemitEnsamble DECIMAL(28,8)

  /*Se toca la existencia del kit, para cambiar usuario de última mofidicación*/
  UPDATE $$COMPANIA$$.EXISTENCIA_BODEGA 
  SET CANT_DISPONIBLE = CANT_DISPONIBLE 
  WHERE ARTICULO = @ARTICULO 
  AND BODEGA = @BODEGA
  
  DECLARE ART_ENSAMBLADOS CURSOR FOR  
    SELECT ARTICULO_HIJO, CANTIDAD
    FROM $$COMPANIA$$.ARTICULO_ENSAMBLE
    WHERE ARTICULO_PADRE = @ARTICULO
    
  OPEN ART_ENSAMBLADOS
  FETCH NEXT FROM ART_ENSAMBLADOS INTO @ArticuloHijo, @CantidadEnsamble
  
  WHILE @@FETCH_STATUS = 0
  BEGIN
    IF $$COMPANIA$$.MANEJA_EXISTENCIAS (@ArticuloHijo) = 1
    BEGIN
      SET @CantDispEnsamble = @CantidadEnsamble * @CANT_DISPONIBLE
      SET @CantReservEnsamble = @CantidadEnsamble * @CANT_RESERVADA
      SET @CantRemitEnsamble = @CantidadEnsamble * @CANT_REMITIDA
      
      
      /*Si el artículo maneja lotes y en el POS se registran los lotes, se debe obtener el lote y localización a utilizar para el artículo*/
      IF ((SELECT MANEJO_LOTE FROM $$COMPANIA$$.GLOBALES_POS) = 'S') AND
        ((SELECT USA_LOTES FROM $$COMPANIA$$.ARTICULO WHERE  ARTICULO = @ArticuloHijo) = 'S')
        BEGIN
          EXEC $$COMPANIA$$.EXPLOTA_LOTE_LOC_DISPONIBLE @ARTICULO, @BODEGA, @ArticuloHijo, @CantDispEnsamble, @CantReservEnsamble, @CantRemitEnsamble
        END
      ELSE
        BEGIN
          INSERT INTO $$COMPANIA$$.AUDIT_EXISTENCIA
          (
            CAJA,
            DOCUMENTO,
            TIPO,
            LINEA,
            BODEGA,
            ARTICULO,
            CANT_DISPONIBLE,
            CANT_RESERVADA,
            CANT_REMITIDA,
            TEXTO
          )
          VALUES
          (
            'KIT',
            @ARTICULO,
            'K',
            '0',
            @BODEGA,
            @ArticuloHijo,
            @CantDispEnsamble,
            @CantReservEnsamble,
            @CantRemitEnsamble,
            'EXPLOTA_EXIST_COMP_KITS KIT: ' + @ARTICULO + ' Ensamble: ' + @ArticuloHijo
          )
          
          EXEC $$COMPANIA$$.ACTUALIZA_EXISTENCIA @BODEGA, @ArticuloHijo, @LOTE, @LOCALIZACION, @CantDispEnsamble, @CantReservEnsamble, @CantRemitEnsamble 
        END
    END
    FETCH NEXT FROM ART_ENSAMBLADOS INTO @ArticuloHijo, @CantidadEnsamble
  END

  CLOSE ART_ENSAMBLADOS
  DEALLOCATE ART_ENSAMBLADOS
END
;


CREATE PROCEDURE $$Compania$$.REGENERACION_EXISTENCIAS_DOCUM_KIT (@ARTBUSQUEDA VARCHAR(20)) 
AS 
BEGIN 
    DECLARE @ARTICULO VARCHAR(20) 
    DECLARE @BODEGA VARCHAR(4) 
    DECLARE @DISPONIBLE DECIMAL (28, 8) 
    DECLARE @RESERVADO DECIMAL (28, 8) 
    DECLARE @REMITIDA DECIMAL (28, 8) 

    IF NOT EXISTS (SELECT * 
               FROM   sysindexes 
               WHERE  name = 'XIEXISTENCIA') 
      BEGIN 
        CREATE NONCLUSTERED INDEX XIEXISTENCIA 
	 	 ON $$COMPANIA$$.AUDIT_TRANS_INV (APLICACION) INCLUDE (REFERENCIA)
      END 


    IF @ARTBUSQUEDA IS NULL 
      BEGIN 
          SET @ARTBUSQUEDA = '%' 
      END 

    DECLARE c_KitsVendidos CURSOR local FOR 
      SELECT doc_pos_linea.articulo, 
             doc_pos_linea.bodega,               
             Sum (CASE 
                    WHEN ( documento_pos.tipo = 'F' 
                            OR documento_pos.tipo = 'T' ) 
                         AND ( documento_pos.estado_cobro = 'C' ) THEN -Abs( 
                    Isnull( 
                    doc_pos_linea.cantidad, 0)) 
                    WHEN documento_pos.tipo = 'D' 
                         AND documento_pos.estado_cobro IN ( 'C', 'P' ) THEN 
                    Abs(Isnull(doc_pos_linea.cantidad, 0)) 
                    WHEN documento_pos.tipo = 'P' 
                         AND documento_pos.estado_cobro IN ( 'V' ) THEN Abs( 
                    Isnull( 
                    doc_pos_linea.cantidad, 0)) 
                    WHEN documento_pos.tipo = 'P' 
                         AND documento_pos.estado_cobro IN ( 'P' ) THEN -Abs( 
                    Isnull( 
                    doc_pos_linea.cantidad, 0)) 
                    ELSE 0 
                  END) AS disponible, 
             Sum (CASE 
                    WHEN documento_pos.tipo = 'P' 
                         AND documento_pos.estado_cobro = 'P' THEN 
                    Abs(Isnull( 
                    doc_pos_linea.cantidad, 0)) 
                    ELSE 0 
                  END) AS reservado, 
             Sum (CASE 
                    WHEN documento_pos.tipo = 'T' 
                         AND documento_pos.estado_cobro = 'C' THEN 
                    Abs(Isnull( 
                    doc_pos_linea.cantidad, 0)) 
                    ELSE 0 
                  END) AS remitido
      FROM   $$Compania$$.documento_pos DOCUMENTO_POS, 
             $$Compania$$.doc_pos_linea DOC_POS_LINEA, 
             $$Compania$$.grupo_caja GRUPO_CAJA 
      WHERE  documento_pos.documento = DOC_POS_LINEA.documento 
             AND DOCUMENTO_POS.caja = DOC_POS_LINEA.caja 
             AND DOCUMENTO_POS.tipo = DOC_POS_LINEA.tipo 
             AND ( ( DOCUMENTO_POS.estado_cobro IN ( 'P', 'C' ) 
                     AND DOCUMENTO_POS.tipo IN ( 'P', 'D' ) ) 
                    OR ( DOCUMENTO_POS.estado_cobro IN ( 'C' ) 
                         AND DOCUMENTO_POS.tipo IN ( 'F', 'T' ) ) ) 
             AND DOCUMENTO_POS.caja = GRUPO_CAJA.caja 
             AND DOCUMENTO_POS.exportado = 'N' 
             AND ($$Compania$$.ES_ARTICULO_KIT (DOC_POS_LINEA.ARTICULO) = 1)
             AND DOC_POS_LINEA.bodega IN (SELECT bodega 
                                          FROM   $$Compania$$.v_tienda_off_bodega 
                                          WHERE  tienda_off = 
                                                 (SELECT tienda_off_local 
                                                  FROM   $$Compania$$.globales_pos)) 
             AND ( DOC_POS_LINEA.articulo = @ARTBUSQUEDA 
                    OR DOC_POS_LINEA.articulo LIKE @ARTBUSQUEDA )
             AND DOCUMENTO_POS.caja + DOCUMENTO_POS.tipo 
                 + DOCUMENTO_POS.documento NOT IN (SELECT aplicacion 
                                                   FROM 
                     $$Compania$$.audit_trans_inv WITH (nolock, INDEX(XIEXISTENCIA)) 
                                                   WHERE 
                 Substring (referencia, 0, 4) = 'POS') 
             AND 0 < (SELECT Count(0) 
                      FROM   $$Compania$$.existencia_bodega EX 
                      WHERE  EX.articulo = doc_pos_linea.articulo 
                             AND EX.bodega = doc_pos_linea.bodega 
                             AND EX.updatedby = 'SoftlandSync')                  
      GROUP  BY DOC_POS_LINEA.articulo, 
                DOC_POS_LINEA.bodega 
      ORDER  BY 1  

    OPEN c_KitsVendidos 

    FETCH next FROM c_KitsVendidos INTO @ARTICULO, @BODEGA, @DISPONIBLE, @RESERVADO, @REMITIDA 

    WHILE @@FETCH_STATUS = 0 
      BEGIN 

          EXEC $$Compania$$.EXPLOTA_EXIST_COMP_KITS @BODEGA,
                                            @ARTICULO,
                                            NULL,
                                            NULL,
                                            @DISPONIBLE,
                                            @RESERVADO,
                                            @REMITIDA

          FETCH next FROM c_KitsVendidos INTO @ARTICULO, @BODEGA, @DISPONIBLE, @RESERVADO, @REMITIDA 
      END 

    CLOSE c_KitsVendidos 
    DEALLOCATE c_KitsVendidos 
END
;

CREATE FUNCTION $$Compania$$.CANTIDAD_DISPONIBLE
(
  @psTIPO AS VARCHAR(1),
  @psESTADO AS VARCHAR(1),
  @psCantidad as DECIMAL(28,8)
)
RETURNS DECIMAL(28,8)
AS
BEGIN
  DECLARE @CANT_RETORNO DECIMAL(28,8)
  
  SET @CANT_RETORNO = 0

  IF @psTIPO = 'F'
  BEGIN
    IF @psESTADO = 'C'
      SET @CANT_RETORNO = -@psCANTIDAD
    ELSE IF @psESTADO = 'A'
      SET @CANT_RETORNO = @psCANTIDAD
    ELSE
      SET @CANT_RETORNO = 0
  END
  ELSE IF @psTIPO = 'D'
  BEGIN
    IF @psESTADO = 'P'
      SET @CANT_RETORNO = @psCANTIDAD
    ELSE IF @psESTADO = 'C'
      SET @CANT_RETORNO = @psCANTIDAD
    ELSE IF @psESTADO = 'A'
      SET @CANT_RETORNO = -@psCANTIDAD
    ELSE
      SET @CANT_RETORNO =  0
  END
  ELSE IF @psTIPO = 'P'
  BEGIN
    IF @psESTADO = 'P'
      SET @CANT_RETORNO = -@psCANTIDAD
    ELSE IF @psESTADO = 'C'
      SET @CANT_RETORNO = @psCANTIDAD
    ELSE IF @psESTADO = 'A'
      SET @CANT_RETORNO = @psCANTIDAD
    ELSE IF @psESTADO = 'V'
      SET @CANT_RETORNO = @psCANTIDAD
  END
  ELSE IF @psTipo = 'T'
  BEGIN
    IF @psESTADO = 'C'
      SET @CANT_RETORNO = -@psCANTIDAD
    ELSE IF @psESTADO = 'A'
      SET @CANT_RETORNO = @psCANTIDAD
  END
  ELSE IF @psTIPO = 'O'
  BEGIN
    IF @psESTADO = 'C'
      SET @CANT_RETORNO = -@psCANTIDAD
    ELSE IF @psESTADO = 'A'
      SET @CANT_RETORNO = @psCANTIDAD
    ELSE
      SET @CANT_RETORNO = 0
  END
  RETURN @CANT_RETORNO
END
;

CREATE FUNCTION $$Compania$$.CANTIDAD_RESERVADA
(
  @psTIPO AS VARCHAR(1),
  @psESTADO AS VARCHAR(1),
  @psCantidad as DECIMAL(28,8)
)
RETURNS DECIMAL(28,8)
AS
BEGIN
  DECLARE @CANT_RETORNO DECIMAL(28,8)
  
  SET @CANT_RETORNO = 0

  IF @psTIPO = 'P'
  BEGIN
    IF @psESTADO = 'P'
      SET @CANT_RETORNO = @psCANTIDAD
    ELSE IF @psESTADO = 'C'
      SET @CANT_RETORNO = -@psCANTIDAD
    ELSE IF @psESTADO = 'A'
      SET @CANT_RETORNO = -@psCANTIDAD
    ELSE IF @psESTADO = 'V'
      SET @CANT_RETORNO = -@psCANTIDAD
  END
  RETURN @CANT_RETORNO
END
;


CREATE FUNCTION $$Compania$$.CANTIDAD_REMITIDA
(
  @psTIPO AS VARCHAR(1),
  @psESTADO AS VARCHAR(1),
  @psCantidad as DECIMAL(28,8)
)
RETURNS DECIMAL(28,8)
AS
BEGIN
  DECLARE @CANT_RETORNO DECIMAL(28,8)
  
  SET @CANT_RETORNO = 0

  IF @psTIPO = 'T'
  BEGIN
    IF @psESTADO = 'C'
      SET @CANT_RETORNO = @psCANTIDAD
    ELSE IF @psESTADO = 'A'
      SET @CANT_RETORNO = -@psCANTIDAD
    ELSE IF @psESTADO = 'D'
      SET @CANT_RETORNO = -@psCANTIDAD
  END
  RETURN @CANT_RETORNO
END
;


CREATE  FUNCTION $$Compania$$.CANTIDAD_TRASPASO
(
  @psSITIOLOCAL AS VARCHAR(10),
  @psBODEGAORIGEN AS VARCHAR(4),
  @psBODEGADESTINO AS VARCHAR(4),
  @psESTADO AS VARCHAR(1),
  @psCantidad as DECIMAL(28,8)
)
RETURNS DECIMAL(28,8)
AS
BEGIN
  IF 0 < (SELECT COUNT(BODEGA) FROM $$Compania$$.V_TIENDA_OFF_BODEGA WHERE TIENDA_OFF IN (SELECT TIENDA_OFF_LOCAL FROM $$Compania$$.GLOBALES_POS) AND BODEGA = @psBODEGADESTINO)
  BEGIN
    IF @psESTADO = 'A'
      RETURN @psCANTIDAD
    ELSE IF @psESTADO = 'U'
      RETURN -@psCANTIDAD
  END
  ELSE IF 0 < (SELECT COUNT(BODEGA) FROM $$Compania$$.V_TIENDA_OFF_BODEGA WHERE TIENDA_OFF IN (SELECT TIENDA_OFF_LOCAL FROM $$Compania$$.GLOBALES_POS) AND BODEGA = @psBODEGAORIGEN)
  BEGIN
    IF @psESTADO = 'A'
      RETURN -@psCANTIDAD
    ELSE IF @psESTADO = 'U'
      RETURN @psCANTIDAD
  END
  RETURN 0
END
;



CREATE TRIGGER $$Compania$$.tU_TRASPASO_POS_EXISTENCIA ON $$Compania$$.TRASPASO_POS
FOR UPDATE
AS
  BEGIN
      DECLARE @ESTADO_OLD           AS VARCHAR(1),
              @ESTADO_NEW           AS VARCHAR(1),
              @CANTIDAD_ROWS        AS INT,
              @CANTIDAD_DOC         AS DECIMAL(28, 8),
              @lsConsecutivo        AS VARCHAR(10),
              @lsDocumento          AS VARCHAR(50),
              @lsBodegaOrigen       AS VARCHAR(4),
              @lsBodegaDestino      AS VARCHAR(4),
              @lsArticulo           AS VARCHAR(20),
              @lsLote               AS VARCHAR(15),
              @lsLocalizacion       AS VARCHAR(8),
              @lnCantidadDisponible AS DECIMAL(28, 8)

      IF NOT UPDATE(estado)
        RETURN
          SELECT @CANTIDAD_ROWS = COUNT(*)
          FROM   inserted

      IF @CANTIDAD_ROWS = 1
        BEGIN
            SELECT @ESTADO_OLD = estado
            FROM   deleted d

            SELECT @ESTADO_NEW = estado
            FROM   inserted d

            IF @ESTADO_NEW <> @ESTADO_OLD
              BEGIN
                  DECLARE c_trasp_det CURSOR LOCAL FOR
                    SELECT
                    i.consecutivo_ci,
                           i.documento,
                           i.bodega_origen,
                           i.bodega_destino,
                           l.articulo,
                           l.lote,
                           NULL,
                           $$Compania$$.CANTIDAD_TRASPASO(g.TIENDA_OFF_LOCAL,i.bodega_origen,NULL,i.estado,l.cantidad),
                           l.cantidad
                    FROM   inserted i,
                           $$Compania$$.traspaso_pos_det l,
                           $$Compania$$.globales_pos g
                    WHERE  i.estado IN ( 'A', 'U' )
                           AND l.consecutivo_ci = i.consecutivo_ci
                           AND l.documento = i.documento

                  OPEN c_trasp_det

                  FETCH NEXT FROM c_trasp_det INTO @lsConsecutivo, @lsDocumento,
                                                   @lsBodegaOrigen, @lsBodegaDestino, @lsArticulo, @lsLote,
                                                   @lsLocalizacion,
                                                   @lnCantidadDisponible, @CANTIDAD_DOC

                  WHILE @@FETCH_STATUS = 0
                    BEGIN
                        INSERT INTO $$Compania$$.audit_existencia
                                    (caja,
                                     documento,
                                     tipo,
                                     linea,
                                     bodega,
                                     articulo,
                                     cant_disponible,
                                     cant_reservada,
                                     cant_remitida,
                                     texto)
                        VALUES      ( @lsConsecutivo,
                                      @lsDocumento,
                                      'T',
                                      NULL,
                                      @lsBodegaOrigen,
                                      @lsArticulo,
                                      @lnCantidadDisponible,
                                      0,
                                      0,
                                      'tU_TRASPASO_POS_EXISTENCIA ESTADO = ' +
                                      @ESTADO_NEW )

                        IF $$Compania$$.Maneja_existencias (@lsArticulo) = 1
                          BEGIN
                              EXEC $$Compania$$.ACTUALIZA_EXISTENCIA
                                @lsBodegaOrigen,
                                @lsArticulo,
                                @lsLote,
                                @lsLocalizacion,
                                @lnCantidadDisponible,
                                0,
                                0
                          END
                        ELSE
                          IF $$Compania$$.ES_ARTICULO_KIT (@lsArticulo) = 1
                            BEGIN
                                EXEC $$Compania$$.Explota_exist_comp_kits
                                  @lsBodegaOrigen,
                                  @lsArticulo,
                                  @lsLote,
                                  @lsLocalizacion,
                                  @lnCantidadDisponible,
                                  0,
                                  0
                            END

                        IF 0 < (SELECT COUNT(bodega)
                                FROM   $$Compania$$.V_TIENDA_OFF_BODEGA
                                WHERE  TIENDA_OFF IN (SELECT TIENDA_OFF_LOCAL
                                                 FROM   $$Compania$$.globales_pos)
                                       AND bodega = @lsBodegaDestino)
                          BEGIN
                              SET @lnCantidadDisponible = $$Compania$$.CANTIDAD_TRASPASO( (SELECT TIENDA_OFF_LOCAL
                                                                                            FROM   $$Compania$$.globales_pos), 
                                                                                            NULL, 
                                                                                            @lsBodegaDestino, 
                                                                                            @ESTADO_NEW,
                                                                                            @CANTIDAD_DOC)

                              INSERT INTO $$Compania$$.audit_existencia
                                          (caja,
                                           documento,
                                           tipo,
                                           linea,
                                           bodega,
                                           articulo,
                                           cant_disponible,
                                           cant_reservada,
                                           cant_remitida,
                                           texto)
                              VALUES      ( @lsConsecutivo,
                                            @lsDocumento,
                                            'T',
                                            NULL,
                                            @lsBodegaDestino,
                                            @lsArticulo,
                                            @lnCantidadDisponible,
                                            0,
                                            0,
                              'tU_TRASPASO_POS_EXISTENCIA ESTADO = '
                              +
                              @ESTADO_NEW )

                              IF $$Compania$$.Maneja_existencias (@lsArticulo) = 1
                                BEGIN
                                    EXEC $$Compania$$.Actualiza_existencia
                                                                          @lsBodegaDestino,
                                                                          @lsArticulo,
                                                                          @lsLote,
                                                                          @lsLocalizacion,
                                                                          @lnCantidadDisponible,
                                                                          0,
                                                                          0
                                END
                              ELSE
                                IF $$Compania$$.Es_articulo_kit (@lsArticulo) = 1
                                  BEGIN
                                      EXEC $$Compania$$.Explota_exist_comp_kits
                                                                                @lsBodegaDestino,
                                                                                @lsArticulo,
                                                                                @lsLote,
                                                                                @lsLocalizacion,
                                                                                @lnCantidadDisponible,
                                                                                0,
                                                                                0
                                  END
                          END

                        FETCH NEXT FROM c_trasp_det INTO @lsConsecutivo,
                                                         @lsDocumento,
                                                         @lsBodegaOrigen, @lsBodegaDestino, @lsArticulo, @lsLote,
                                                         @lsLocalizacion,
                                                         @lnCantidadDisponible, @CANTIDAD_DOC
                    END
              END
        END
      ELSE
        BEGIN
            RAISERROR ( 'No se permite actualizar multiples traspasos',
                        16,
                        1 )

            ROLLBACK TRANSACTION
        END
  END
;

CREATE TRIGGER $$Compania$$.tU_DOCUMENTO_POS_EXISTENCIA ON $$Compania$$.DOCUMENTO_POS
FOR UPDATE
AS
BEGIN
  DECLARE
    @InfoTrigger AS VARCHAR(100),
    @lsCaja AS VARCHAR(6),
    @lsDocumento AS VARCHAR(50),
    @lsTipo AS VARCHAR(1),
    @lsLinea AS VARCHAR(4),
    @ESTADO_OLD AS VARCHAR(1),
    @ESTADO_NEW AS VARCHAR(1),
    @CANTIDAD_ROWS AS INT,
    @lsBodega as VARCHAR(4),
    @lsArticulo AS VARCHAR(20),
    @lsLote AS VARCHAR(15),
    @lsLocalizacion AS VARCHAR(8),
    @lnCantidadDisponible as DECIMAL(28,8),
    @lnCantidadReservada as DECIMAL(28,8),
    @lnCantidadRemitida as DECIMAL(28,8),
    @DOCUMENTO AS VARCHAR(50), 
    @CAJA AS VARCHAR(6),
    @TIPO AS VARCHAR(1),
    @ESTADO AS VARCHAR(1),
	@USADESPACHOS AS VARCHAR(1),
    @error AS INT
  IF NOT UPDATE(ESTADO_COBRO)
    RETURN
  --Se declara el cursor para obtener los documentos
  DECLARE c_DOC CURSOR FOR
      SELECT DOCUMENTO, CAJA, TIPO, ESTADO_COBRO, USA_DESPACHOS
      FROM INSERTED
      WHERE ((ESTADO_COBRO IN ('C','A','P','V') AND TIPO IN ('F','P','O'))
          OR (ESTADO_COBRO = 'A' AND TIPO IN ('D', 'T')) OR (ESTADO_COBRO = 'D' AND TIPO = 'T'))    
            
  OPEN c_DOC
  FETCH c_DOC INTO @DOCUMENTO, @CAJA, @TIPO, @ESTADO, @USADESPACHOS
  WHILE @@FETCH_STATUS >=0 
  BEGIN

  IF @USADESPACHOS = 'N'
  BEGIN
  
    SELECT @ESTADO_OLD = ESTADO_COBRO
    FROM DELETED D
    SELECT @ESTADO_NEW = ESTADO_COBRO
    FROM INSERTED D
    
    IF @TIPO = 'D' AND @ESTADO_OLD = 'P' AND @ESTADO_NEW = 'C'
    BEGIN
      SET @ESTADO = '-1'
    END
    
    IF @ESTADO_NEW <> @ESTADO_OLD
    BEGIN
      DECLARE c_DOCPOS_DET CURSOR LOCAL FOR
        SELECT  L.CAJA,
          L.DOCUMENTO,
          L.TIPO,
          L.LINEA,
          C.BODEGA,
          L.ARTICULO,
          L.LOTE,
          L.LOCALIZACION,
          $$Compania$$.CANTIDAD_DISPONIBLE( L.TIPO, @ESTADO, L.CANTIDAD),
          $$Compania$$.CANTIDAD_RESERVADA( L.TIPO, @ESTADO, L.CANTIDAD),
          $$Compania$$.CANTIDAD_REMITIDA( L.TIPO, @ESTADO, L.CANTIDAD)
        FROM  $$Compania$$.DOC_POS_LINEA L,
          $$Compania$$.CAJA_POS C
        WHERE L.DOCUMENTO = @DOCUMENTO
          AND   L.CAJA = @CAJA
          AND   L.TIPO = @TIPO
          AND   L.CAJA = C.CAJA
      OPEN c_DOCPOS_DET
      FETCH NEXT FROM c_DOCPOS_DET
      INTO  @lsCaja,
            @lsDocumento,
            @lsTipo,
            @lsLinea,
            @lsBodega,
            @lsArticulo,
            @lsLote,
            @lsLocalizacion,
            @lnCantidadDisponible,
            @lnCantidadReservada,
            @lnCantidadRemitida
      WHILE @@FETCH_STATUS = 0
      BEGIN
        --Se verifica que no sea una factura producto de un Ticket
        IF 0 <= (SELECT COUNT(0) 
              FROM $$Compania$$.AUXILIAR_POS 
              WHERE @lsTipo = 'F' 
              AND @ESTADO_NEW = 'C' 
              AND TIPO = @lsTipo
              AND CAJA = @lsCaja
              AND DOCUMENTO = @lsDocumento 
              AND TIPO_APLICA = 'T')
        BEGIN     
          SET @InfoTrigger = 'tU_DOCUMENTO_POS_EXISTENCIA ESTADO = ' + @ESTADO_NEW

          IF  $$Compania$$.ES_ARTICULO_KIT (@lsArticulo) = 1
          BEGIN
            SET @InfoTrigger = 'tU_DOCUMENTO_POS_EXISTENCIA ESTADO = ' + @ESTADO_NEW + ' - ARTICULO KIT: ' + @lsArticulo
          END   
          
          --Si se aplica el ticket se cambia el Tipo de documento y Documento para reflejar la factura para efectos de bitácora auditoría
          IF @lsTipo = 'T' AND @ESTADO_NEW = 'D' 
          BEGIN
            SET @InfoTrigger = @InfoTrigger + ' TICKET: ' + @lsDocumento
            
            IF  $$Compania$$.ES_ARTICULO_KIT (@lsArticulo) = 1
            BEGIN
              SET @InfoTrigger = 'tU_DOCUMENTO_POS_EXISTENCIA ESTADO = ' + @ESTADO_NEW + ' TICKET: ' + @lsDocumento + ' - ARTICULO KIT: ' + @lsArticulo
            END   
            
            SELECT DISTINCT @lsTipo = TIPO, @lsDocumento = DOCUMENTO
            FROM $$Compania$$.AUXILIAR_POS 
            WHERE TIPO_APLICA = @lsTipo
            AND CAJA_DOCUM_APLICA = @lsCaja
            AND DOCUM_APLICA = @lsDocumento 
            AND TIPO = 'F'
          END
              
          INSERT INTO $$Compania$$.AUDIT_EXISTENCIA
          (
            CAJA,
            DOCUMENTO,
            TIPO,
            LINEA,
            BODEGA,
            ARTICULO,
            CANT_DISPONIBLE,
            CANT_RESERVADA,
            CANT_REMITIDA,
            TEXTO
          )
          VALUES
          (
            @lsCaja,
            @lsDocumento,
            @lsTipo,
            @lsLinea,
            @lsBodega,
            @lsArticulo,
            @lnCantidadDisponible,
            @lnCantidadReservada,
            @lnCantidadRemitida,
            @InfoTrigger
          )
          Select @error = @@error
          
          If @error != 0
          Begin
           RAISERROR ('Error actualizando los documentos', 16, 1)
           Rollback 
          End
                 
          IF $$Compania$$.MANEJA_EXISTENCIAS (@lsArticulo) = 1
          BEGIN
            EXEC $$Compania$$.Actualiza_Existencia @lsBodega,
                                               @lsArticulo,
                                               @lsLote,
                                               @lsLocalizacion, 
                                               @lnCantidadDisponible,
                                               @lnCantidadReservada,
                                               @lnCantidadRemitida
          END
          ELSE IF $$Compania$$.ES_ARTICULO_KIT (@lsArticulo) = 1
          BEGIN
            EXEC $$Compania$$.EXPLOTA_EXIST_COMP_KITS @lsBodega,
                        @lsArticulo,
                        @lsLote,
                        @lsLocalizacion,
                        @lnCantidadDisponible,
                        @lnCantidadReservada,
                        @lnCantidadRemitida
          END
          
          FETCH NEXT FROM c_DOCPOS_DET
          INTO  @lsCaja,
                @lsDocumento,
                @lsTipo,
                @lsLinea,
                @lsBodega,
                @lsArticulo,
                @lsLote,
                @lsLocalizacion,
                @lnCantidadDisponible,
                @lnCantidadReservada,
                @lnCantidadRemitida
          END
        END
      CLOSE c_DOCPOS_DET
      DEALLOCATE c_DOCPOS_DET
    END
  FETCH c_DOC INTO @DOCUMENTO, @CAJA, @TIPO, @ESTADO, @USADESPACHOS
  END
  END
  CLOSE c_DOC
  DEALLOCATE c_DOC
END
;

CREATE TRIGGER $$compania$$.[tI_DOC_POS_LINEA_EXISTENCIA] ON $$compania$$.[DOC_POS_LINEA] FOR INSERT AS 
BEGIN 
  DECLARE @InfoTrigger AS    VARCHAR(100), 
    @CANTIDAD_ROWS AS        INT, 
    @lsCaja AS               VARCHAR(6), 
    @lsDocumento AS          VARCHAR(50), 
    @lsTipo AS               VARCHAR(1), 
    @lsLinea AS              VARCHAR(4), 
    @lsBodega AS             VARCHAR(4), 
    @lsArticulo AS           VARCHAR(20), 
    @lsLote AS               VARCHAR(15), 
    @lsLocalizacion AS       VARCHAR(8), 
    @lnCantidadDisponible AS DECIMAL(28,8), 
    @lnCantidadReservada AS  DECIMAL(28,8), 
    @lnCantidadRemitida AS   DECIMAL(28,8), 
    @lsUsaDespachos AS       VARCHAR(1) 
  DECLARE c_docpos_lin CURSOR local FOR 
  SELECT i.caja, 
         i.documento, 
         i.tipo, 
         l.linea, 
         c.bodega, 
         l.articulo, 
         l.lote, 
         l.localizacion, 
         $$compania$$.Cantidad_disponible( i.tipo, i.estado_cobro, l.cantidad), 
         $$compania$$.Cantidad_reservada( i.tipo, i.estado_cobro, l.cantidad), 
         $$compania$$.Cantidad_remitida( i.tipo, i.estado_cobro, l.cantidad), 
         i.usa_despachos 
  FROM   inserted L, 
         $$compania$$.documento_pos I, 
         $$compania$$.caja_pos C 
  WHERE  i.estado_cobro IN ('c', 
                            'a', 
                            'p') 
  AND    i.tipo IN ('f', 
                    'p', 
                    'd', 
                    't', 
                    'o') 
  AND    l.documento = i.documento 
  AND    l.caja = i.caja 
  AND    l.tipo = i.tipo 
  AND    i.caja = c.caja 
  OPEN c_docpos_lin 
  FETCH next 
  FROM  c_docpos_lin 
  INTO  @lsCaja, 
        @lsDocumento, 
        @lsTipo, 
        @lsLinea, 
        @lsBodega, 
        @lsArticulo, 
        @lsLote, 
        @lsLocalizacion, 
        @lnCantidadDisponible, 
        @lnCantidadReservada, 
        @lnCantidadRemitida, 
        @lsUsaDespachos 
  WHILE @@FETCH_STATUS = 0 
  BEGIN 
    /*  Si se trata de una factura, pero viene de Ticket, se vende de lo remitido, como esto ya se dio con el cambio de estado del Ticket el efecto acá es cero */
    IF @lsTipo = 'f' 
    BEGIN 
      DECLARE @Fac_de_ticket INT 
      SELECT @Fac_de_ticket = Count(0) 
      FROM   $$compania$$.auxiliar_pos 
      WHERE  documento = @lsDocumento 
      AND    caja = @lsCaja 
      AND    tipo = @lsTipo 
      AND    tipo_aplica = 't' 
      IF @Fac_de_ticket > 0 
      BEGIN 
        SET @lnCantidadRemitida = 0 
        SET @lnCantidadDisponible = 0 
      END 
    END 
    IF (@lnCantidadDisponible <> 0 OR @lnCantidadReservada <> 0 OR @lnCantidadRemitida <> 0 ) AND  @lsUsaDespachos = 'N' 
    BEGIN 
      IF @lsCaja IS NOT NULL 
      BEGIN 
        SET @InfoTrigger = 'ti_doc_pos_linea_existencia' 
        IF $$compania$$.Es_articulo_kit (@lsArticulo) = 1 
        BEGIN 
          SET @InfoTrigger = 'ti_doc_pos_linea_existencia - articulo KIT: ' + @lsArticulo 
        END 
        INSERT INTO $$compania$$.audit_existencia 
                    ( 
                                caja, 
                                documento, 
                                tipo, 
                                linea, 
                                bodega, 
                                articulo, 
                                cant_disponible, 
                                cant_reservada, 
                                cant_remitida, 
                                texto 
                    ) 
                    VALUES 
                    ( 
                                @lsCaja, 
                                @lsDocumento, 
                                @lsTipo, 
                                @lsLinea, 
                                @lsBodega, 
                                @lsArticulo, 
                                @lnCantidadDisponible, 
                                @lnCantidadReservada, 
                                @lnCantidadRemitida, 
                                @InfoTrigger 
                    ) 
      END 
      IF $$compania$$.Maneja_existencias (@lsArticulo) = 1 
      BEGIN 
        EXEC $$compania$$.actualiza_existencia 
          @lsBodega, 
          @lsArticulo, 
          @lsLote, 
          @lsLocalizacion, 
          @lnCantidadDisponible, 
          @lnCantidadReservada, 
          @lnCantidadRemitida 
      END 
      ELSE 
      IF $$compania$$.Es_articulo_kit (@lsArticulo) = 1 
      BEGIN 
        EXEC $$compania$$.explota_exist_comp_kits 
          @lsBodega, 
          @lsArticulo, 
          @lsLote, 
          @lsLocalizacion, 
          @lnCantidadDisponible, 
          @lnCantidadReservada, 
          @lnCantidadRemitida 
      END 
    END 
    FETCH next 
    FROM  c_docpos_lin 
    INTO  @lsCaja, 
          @lsDocumento, 
          @lsTipo, 
          @lsLinea, 
          @lsBodega, 
          @lsArticulo, 
          @lsLote, 
          @lsLocalizacion, 
          @lnCantidadDisponible, 
          @lnCantidadReservada, 
          @lnCantidadRemitida, 
          @lsUsaDespachos 
  END 
END
;

CREATE PROCEDURE $$Compania$$.Regeneracion_existencias_traspaso (@ARTBUSQUEDA VARCHAR(20)) 
AS 
  BEGIN 
      DECLARE @ARTICULO VARCHAR(20) 
      DECLARE @BODEGA VARCHAR(4) 
      DECLARE @DISPONIBLE DECIMAL (28, 8) 
      DECLARE @RESERVADO DECIMAL (28, 8) 
      DECLARE @REMITIDA DECIMAL (28, 8) 
      DECLARE @CantidadDisponible DECIMAL (28, 8) 
      DECLARE @CantidadReservada DECIMAL (28, 8) 
      DECLARE @CantidadRemitida DECIMAL (28, 8) 
      DECLARE @DisponibleActualizado DECIMAL (28, 8) 
      DECLARE @ReservadoActualizado DECIMAL (28, 8) 
      DECLARE @RemitidoActualizado DECIMAL (28, 8) 

      IF NOT EXISTS (SELECT * 
                     FROM   sysindexes 
                     WHERE  NAME = 'XIAUDTRANSINV') 
        BEGIN 
            CREATE NONCLUSTERED INDEX xiaudtransinv 
              ON $$Compania$$.audit_trans_inv (consecutivo, aplicacion) 
        END 

      IF @ARTBUSQUEDA IS NULL 
        BEGIN 
            SET @ARTBUSQUEDA = '%' 
        END 

      DECLARE c_existencia CURSOR local FOR 
        SELECT traspaso_pos_det.articulo, 
               traspaso_pos_det.bodega_origen, 
               Sum (-Abs(Isnull(traspaso_pos_det.cantidad, 0))) AS disponible, 
               0                                                AS reservado, 
               0                                                AS remitido 
        FROM   $$Compania$$.traspaso_pos traspaso_pos, 
               $$Compania$$.traspaso_pos_det traspaso_pos_det 
        WHERE  traspaso_pos.documento = traspaso_pos_det.documento 
               AND traspaso_pos.consecutivo_ci = traspaso_pos_det.consecutivo_ci
                AND ( $$Compania$$.Maneja_existencias (traspaso_pos_det.articulo) = 1 ) 
               AND traspaso_pos_det.bodega_origen IN 
                   (SELECT bodega 
                    FROM   $$Compania$$.v_tienda_off_bodega 
                    WHERE  tienda_off = 
                   (SELECT tienda_off_local 
                    FROM   $$Compania$$.globales_pos)) 
               AND ( traspaso_pos_det.articulo = @ARTBUSQUEDA
                      OR traspaso_pos_det.articulo LIKE @ARTBUSQUEDA ) 
               AND 0 = (SELECT Count(0) 
                        FROM   $$Compania$$.audit_trans_inv ati WITH (nolock, INDEX( 
                               xiaudtransinv)) 
                        WHERE  ati.consecutivo = traspaso_pos.consecutivo_ci 
                               AND ati.aplicacion = traspaso_pos.documento) 
               AND 0 < (SELECT Count(0) 
                        FROM   $$Compania$$.existencia_bodega EX 
                        WHERE  EX.articulo = traspaso_pos_det.articulo 
                               AND EX.bodega = traspaso_pos_det.bodega_origen 
                               AND EX.updatedby = 'SoftlandSync') 
        GROUP  BY traspaso_pos_det.articulo, 
                  traspaso_pos_det.bodega_origen 
        ORDER  BY 1 

      OPEN c_existencia 

      FETCH next FROM c_existencia INTO @ARTICULO, @BODEGA, @DISPONIBLE, 
      @RESERVADO, @REMITIDA 

      WHILE @@FETCH_STATUS = 0 
        BEGIN 
            SELECT @CantidadDisponible = cant_disponible, 
                   @CantidadReservada = cant_reservada, 
                   @CantidadRemitida = cant_remitida 
            FROM   $$Compania$$.existencia_bodega 
            WHERE  articulo = @ARTICULO 
                   AND bodega = @BODEGA 

            SET @DisponibleActualizado = @CantidadDisponible + @DISPONIBLE 
            SET @ReservadoActualizado = @CantidadReservada + @RESERVADO 
            SET @RemitidoActualizado = @CantidadRemitida + @REMITIDA 

            UPDATE $$Compania$$.existencia_bodega 
            SET    cant_disponible = @DisponibleActualizado, 
                   cant_reservada = @ReservadoActualizado, 
                   cant_remitida = @RemitidoActualizado 
            WHERE  articulo = @ARTICULO 
                   AND bodega = @BODEGA 

            FETCH next FROM c_existencia INTO @ARTICULO, @BODEGA, @DISPONIBLE, 
            @RESERVADO, @REMITIDA 
        END 

      CLOSE c_existencia 

      DEALLOCATE c_existencia 
  END
;  
