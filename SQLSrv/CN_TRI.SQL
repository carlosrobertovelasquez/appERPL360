CREATE PROCEDURE $$COMPANIA$$.SP_CN_UPDATEEMPLEADOCONCNOMI
   @NOMINA  VARCHAR(4),
   @NUMNOMINA  SMALLINT,
   @ESAJUSTE VARCHAR(1) 
 AS 
 BEGIN 
 SET NOCOUNT ON
 IF @ESAJUSTE = 'S'
 BEGIN
    UPDATE $$COMPANIA$$.CALCULO_AJUSTES_NOMI
    SET TOTAL = ecnc.TOTAL
    FROM
     $$COMPANIA$$.CALCULO_AJUSTES_NOMI ecn
    INNER JOIN
     $$COMPANIA$$.EMPLEADO_CONC_NOMI_CALC ecnc
    ON
     ecn.nomina = ecnc.nomina AND
     ecn.numero_nomina = ecnc.numero_nomina AND
     ecn.empleado = ecnc.empleado AND
     ecn.concepto = ecnc.concepto AND
     ecn.centro_costo = ecnc.centro_costo AND
     ecn.consecutivo = ecnc.consecutivo
   END
   ELSE
   BEGIN
    UPDATE $$COMPANIA$$.EMPLEADO_CONC_NOMI
    SET TOTAL = ecnc.TOTAL
    FROM
     $$COMPANIA$$.EMPLEADO_CONC_NOMI ecn
    INNER JOIN
     $$COMPANIA$$.EMPLEADO_CONC_NOMI_CALC ecnc
    ON
     ecn.nomina = ecnc.nomina AND
     ecn.numero_nomina = ecnc.numero_nomina AND
     ecn.empleado = ecnc.empleado AND
     ecn.concepto = ecnc.concepto AND
     ecn.centro_costo = ecnc.centro_costo AND
     ecn.consecutivo = ecnc.consecutivo
    END
    
    DELETE 
    FROM 
     $$COMPANIA$$.empleado_conc_nomi_calc 
    WHERE 
     NOMINA = @NOMINA AND 
     NUMERO_NOMINA = @NUMNOMINA
 END;


CREATE PROCEDURE $$COMPANIA$$.Crear_tabla_pivote (@psNomina       VARCHAR(4), 
                                                 @pnNumeroNomina SMALLINT, 
                                                 @pdtFechaFinal  DATETIME, 
                                                 @psTablaCalculo NVARCHAR(50), 
                                                 @psFiltro       AS VARCHAR(max) , 
                                                 @pnAjuste       AS INT, 
                                                 @psColumnas     VARCHAR(max) output) 
AS 
    DECLARE @sql AS NVARCHAR(max) 
    DECLARE @tabla_ecn AS NVARCHAR(max) 
    DECLARE @tabla_ecn_ajuste AS NVARCHAR(max) 

  BEGIN 
      SET @psColumnas = '' 
      SET @tabla_ecn = @psTablaCalculo + '_ECN' 

      IF @pnAjuste = 1 
        BEGIN 
            SET @tabla_ecn_ajuste = 'CALCULO_AJUSTES_NOMI' 

            SELECT @psColumnas = @psColumnas + ( CASE 
                                                   WHEN ( @psColumnas != '' ) 
                                                 THEN 
                                                   ',' 
                                                   ELSE '' 
                                                 END ) + '[' + concepto + ']' 
            FROM   (SELECT DISTINCT ecn.concepto, 
                                    c.max_nivel 
                    FROM   $$compania$$.calculo_ajustes_nomi ecn, 
                           $$compania$$.concepto c, 
                           $$compania$$.empleado_concepto ec, 
                           $$compania$$.nomina n 
                    WHERE  ecn.nomina = @psNomina 
                           AND ecn.numero_nomina = @pnNumeroNomina 
                           AND ecn.concepto = c.concepto 
                           AND ecn.empleado = ec.empleado 
                           AND ecn.concepto = ec.concepto 
                           AND ec.fecha_prox_aplic <= @pdtFechaFinal 
                           AND ec.fecha_vence >= @pdtFechaFinal 
                           AND ecn.nomina = n.nomina 
                           AND ( c.omitir_mont_cant_cero = 'N' 
                                  OR ( ( ecn.monto != 0 
                                          OR ecn.cantidad != 0 ) 
                                       AND c.omitir_mont_cant_cero = 'S' ) ) 
                           AND NOT( c.tipo_concepto = 'N' 
                                    AND n.estado IN ( 'H', 'B', 'L', 'A' ) )) dd 
            ORDER  BY dd.max_nivel 
        END 
      ELSE 
        BEGIN 
            SET @tabla_ecn_ajuste = 'empleado_conc_nomi' 

            SELECT @psColumnas = @psColumnas + ( CASE 
                                                   WHEN ( @psColumnas != '' ) 
                                                 THEN 
                                                   ',' 
                                                   ELSE '' 
                                                 END ) + '[' + concepto + ']' 
            FROM   (SELECT DISTINCT ecn.concepto, 
                                    c.max_nivel 
                    FROM   $$compania$$.empleado_conc_nomi ecn, 
                           $$compania$$.concepto c, 
                           $$compania$$.empleado_concepto ec, 
                           $$compania$$.nomina n 
                    WHERE  ecn.nomina = @psNomina 
                           AND ecn.numero_nomina = @pnNumeroNomina 
                           AND ecn.concepto = c.concepto 
                           AND ecn.empleado = ec.empleado 
                           AND ecn.concepto = ec.concepto 
                           AND ec.fecha_prox_aplic <= @pdtFechaFinal 
                           AND ec.fecha_vence >= @pdtFechaFinal 
                           AND ecn.nomina = n.nomina 
                           AND ( c.omitir_mont_cant_cero = 'N' 
                                  OR ( ( ecn.monto != 0 
                                          OR ecn.cantidad != 0 ) 
                                       AND c.omitir_mont_cant_cero = 'S' ) ) 
                           AND NOT( c.tipo_concepto = 'N' 
                                    AND n.estado IN ( 'H', 'B', 'L', 'A' ) )) dd 
            ORDER  BY dd.max_nivel 
        END 

      IF ( Len(@psColumnas) > 0 ) 
        BEGIN 
            SET @sql =' SELECT *        INTO $$COMPANIA$$.' + @psTablaCalculo 
                      + '       FROM ( SELECT  ecn.empleado, ecn.centro_costo, isnull(ecn.fase,''NULL'') ''fase'', isnull(ecn.proyecto,''NULL'') ''proyecto'', ecn.concepto, CAST(0 as decimal(28,8)) ''total''         FROM $$COMPANIA$$.' 
                      + @tabla_ecn_ajuste 
                      + ' ecn              WHERE ecn.nomina = ''' 
                      + @psNomina + ''' ' + @psFiltro 
                      + '                  AND ecn.numero_nomina = ' 
                      + CONVERT(VARCHAR(10), @pnNumeroNomina) 
                      + ') AS source_table       PIVOT (MIN(total) for concepto in ( ' 
                      + @psColumnas + ')) as PivotTable' 

            EXECUTE Sp_executesql 
              @sql 

            SET @sql =' SELECT ecn.nomina, ecn.numero_nomina, ecn.empleado, isnull(ecn.fase,''NULL'') ''fase'', isnull(ecn.proyecto,''NULL'') ''proyecto'',        ecn.concepto, ecn.centro_costo, ecn.cantidad, ecn.monto, ec.forma_aplicacion, ec.numero_cuotas, ec.cuotas_aplicadas, ec.saldo,        CAST(0 as decimal(28,8)) ''total''       
			INTO $$COMPANIA$$.' + @tabla_ecn 
                      + '       FROM $$COMPANIA$$.' 
                      + @tabla_ecn_ajuste 
                      + ' ecn,        $$COMPANIA$$.empleado_concepto ec       WHERE ecn.nomina = ''' + @psNomina 
                      + ''' ' + @psFiltro 
                      + '         AND ecn.NUMERO_NOMINA = ' 
                      + CONVERT(VARCHAR(10), @pnNumeroNomina) 
                      + '       AND ecn.empleado = ec.empleado       AND ecn.concepto = ec.concepto       AND ec.fecha_prox_aplic <= ''' 
                      + CONVERT(VARCHAR, @pdtFechaFinal, 111) 
                      + '''       AND ec.fecha_vence >= ''' 
                      + CONVERT(VARCHAR, @pdtFechaFinal, 111) + '''' 

            EXECUTE Sp_executesql 
              @sql 

            SET @sql =' ALTER TABLE $$COMPANIA$$.' 
                      + @psTablaCalculo + ' ADD CONSTRAINT ' 
                      + @psTablaCalculo 
                      + 'PK PRIMARY KEY NONCLUSTERED (empleado,centro_costo, fase, proyecto)' 

  EXECUTE Sp_executesql 
    @sql 

  SET @sql =' ALTER TABLE $$COMPANIA$$.' + @tabla_ecn 
            + ' ADD CONSTRAINT ' + @tabla_ecn 
            + 'PK PRIMARY KEY NONCLUSTERED (empleado,centro_costo,concepto, fase, proyecto) ' 

    EXECUTE Sp_executesql 
      @sql 
END 
END;




CREATE FUNCTION $$COMPANIA$$.CN_DIFERENCIA_ANNOS 
(	
	@pdtFechaInicial datetime, 
	@pdtFechaFinal datetime,
	@pnContable int
)
returns decimal(28,8)
as
begin

	declare @years as decimal set @years = YEAR(@pdtFechaFinal) - YEAR(@pdtFechaInicial)
	declare @lnDias as decimal set @lnDias = 0
	declare @lnDiasEnAnno as decimal(28,8) set @lnDiasEnAnno = 0
	declare @lnContador as decimal set @lnContador = 0
	declare @lnResultado as decimal(28,8) set @lnResultado = 0

	if(@years < 0)
		set @years = 0
		
	if (@pdtFechaInicial >= @pdtFechaFinal)
		return 0
		
	--Si el mes de la fecha inicial es mayor al de fecha final, se calculan por separado los dias entre una fecha 
	--y otra para utilizarla en Año Contable	
	if(MONTH(@pdtFechaFinal) < MONTH(@pdtFechaInicial))
		set @years = @years - 1
	
	--Se calculan los dias hasta la fecha Final
	if(@pnContable = 1)
		set @lnDias = DATEDIFF(day, @pdtFechaInicial, @pdtFechaFinal)
	
	if(@years <> 0)
	begin
		while (@lnContador < @years)
		begin
			if(@pnContable = 1)
				set @lnDiasEnAnno = @lnDiasEnAnno + 360
			else
			begin
				--Si es año bisiesto
				if ( (YEAR(@pdtFechaInicial) + @lnContador) % 400 = 0 ) OR ( (YEAR(@pdtFechaInicial) + @lnContador) % 4 = 0 )
					set @lnDiasEnAnno = @lnDiasEnAnno + 366
				else
					set @lnDiasEnAnno = @lnDiasEnAnno + 365
			end
			
			set @lnContador = @lnContador + 1
		end
		
		if(@pnContable = 1)
			Set @lnResultado = (@lnDiasEnAnno + @lnDias) / 360
		else
		begin
			Set @lnDiasEnAnno = @lnDiasEnAnno / @years
			Set @lnResultado =  DATEDIFF(day, @pdtFechaInicial, @pdtFechaFinal) / @lnDiasEnAnno
		end

	end
	else
	begin
		if(@pnContable = 1)
			set @lnDiasEnAnno = 360
		else
		begin
			--Si es año bisiesto
			if ( YEAR(@pdtFechaInicial) % 400 = 0 ) OR (YEAR(@pdtFechaInicial) % 4 = 0 )
				set @lnDiasEnAnno = 366
			else
				set @lnDiasEnAnno = 365
		end
		Set @lnResultado =  DATEDIFF(day, @pdtFechaInicial, @pdtFechaFinal) / @lnDiasEnAnno

	end	
	
	return @lnResultado
end;




CREATE FUNCTION $$COMPANIA$$.CN_DIFERENCIA_MESES 
(	
	@pdtFechaInicial datetime, 
	@pdtFechaFinal datetime
)
returns decimal(28,8)
as
begin
	declare @fecha1 as datetime
	declare @fecha2 as datetime
	declare @anos as decimal set @anos = 0
	declare @meses as decimal set @meses = 0
	declare @dias as decimal set @dias = 0
	declare @lnResultado as decimal(28,8) set @lnResultado = 0

	set @fecha1 = @pdtFechaInicial
	set @fecha2 = @pdtFechaFinal

	set @anos = $$COMPANIA$$.cn_Diferencia_Annos(@fecha1,@fecha2,0)
	set @fecha1 = DATEADD(YYYY,@anos, @fecha1) 
	set @meses = DATEDIFF(mm,@fecha1, @fecha2)
	set @fecha1 = DATEADD(mm,@meses, @fecha1) 
	set @dias = DATEDIFF(dd,@fecha1, @fecha2)

	if(@dias < 0) 
		set @lnResultado = @anos * 12 + @meses - 1
	else
		set @lnResultado = @anos * 12 + @meses

	return @lnResultado		
end;




CREATE FUNCTION $$COMPANIA$$.CN_CALCULARDIFERENCIAFECHAS
(	
	@pdtFechaInicial datetime, 
	@pdtFechaFinal datetime,
	@pnUnidad int,
	@pnContable int
)
returns decimal(28,8)
as
begin

	declare @lnDias as decimal set @lnDias = 0
	declare @lnMeses as decimal set @lnMeses = 0
	declare @lnResultado as decimal(28,8) set @lnResultado = 0

	if (@pdtFechaInicial > @pdtFechaFinal)
		return 0
	else
	begin
		if(@pnContable = 1)
		begin
			if(@pdtFechaInicial IS NULL OR @pdtFechaFinal IS NULL  )
				begin
					if(@pdtFechaInicial IS NULL)
						begin
							set @lnMeses  = (YEAR(@pdtFechaFinal) - -1)*12
							set @lnMeses = @lnMeses + MONTH(@pdtFechaFinal) - -1
							set @lnDias = @lnMeses * 30 + DAY(@pdtFechaFinal) - -1 + 1
						end
					else
						begin
							set @lnMeses  = (YEAR(@pdtFechaInicial) - -1)*12
							set @lnMeses = @lnMeses + MONTH(@pdtFechaInicial) - -1
							set @lnDias = @lnMeses * 30 + DAY(@pdtFechaInicial) - -1 + 1
						end
				end
			else
				begin
					if(DAY(@pdtFechaInicial) > 30)
						Set @pdtFechaInicial = @pdtFechaInicial - 1
					if(DAY(@pdtFechaFinal) > 30)
						Set @pdtFechaFinal = @pdtFechaFinal - 1
					
					Set @lnDias = DATEDIFF(DAY, @pdtFechaInicial,  @pdtFechaFinal)
					Set @lnMeses = $$Compania$$.cn_Diferencia_Meses(@pdtFechaInicial,  @pdtFechaFinal)
			
					if(DAY(@pdtFechaFinal) >= DAY(@pdtFechaInicial))
					begin
						Set @lnDias = @lnMeses * 30 + DAY(@pdtFechaFinal) - DAY(@pdtFechaInicial) + 1
						
						/*Si el mes es febrero*/
						if (MONTH(@pdtFechaFinal) = 2)
						begin
							/*Si es año bisiesto*/
							if ( (YEAR(@pdtFechaInicial) % 400 = 0 ) OR (YEAR(@pdtFechaInicial) % 4 = 0 )) AND (DAY(@pdtFechaFinal) = 29)
								set @lnDias = @lnDias + 1
							else if (DAY(@pdtFechaFinal) = 28)
								set @lnDias = @lnDias + 2
						end
					end
					else
						if (MONTH(@pdtFechaFinal) = 2)
							Set @lnDias = (@lnMeses * 30 ) + (30 - DAY(@pdtFechaInicial)) + 1
						else
							Set @lnDias = @lnMeses * 30 + ( 30 - DAY(@pdtFechaInicial) + 1 ) + DAY(@pdtFechaFinal)
				end
			/*Hace la conversión de días a la unidad requerida*/
			if(@pnUnidad = 0) /*años*/
				set @lnResultado = @lnDias / 360
			else if(@pnUnidad = 1) /*meses*/
				Set @lnResultado = @lnDias / 30
			else if(@pnUnidad = 2) /*dias*/
				Set @lnResultado = @lnDias
			else if(@pnUnidad = 3) /*horas*/
				Set @lnResultado = @lnDias * 24
			else
				Set @lnResultado = 0
		end
		else
		begin
			if(@pnUnidad = 0) /*años*/
				set @lnResultado = $$Compania$$.cn_Diferencia_Annos ( @pdtFechaInicial, @pdtFechaFinal + 1, @pnContable )
			else if(@pnUnidad = 1) /*meses*/
				Set @lnResultado = $$Compania$$.cn_Diferencia_Annos( @pdtFechaInicial, @pdtFechaFinal + 1, @pnContable ) * 12
			else if(@pnUnidad = 2) /*dias*/
				Set @lnResultado = DATEDIFF(DAY, @pdtFechaInicial,  @pdtFechaFinal) + 1 
			else if(@pnUnidad = 3) /*horas*/
				Set @lnResultado = DATEDIFF(DAY, @pdtFechaInicial,  @pdtFechaFinal) * 24
			else
				Set @lnResultado = 0
		end
	end
		
	return @lnResultado
end;




CREATE FUNCTION $$COMPANIA$$.CN_FERIADOSENTREFECHAS 
(	
	@pdtFechaInicial datetime, 
	@pdtFechaFinal datetime,
	@pnExcluirSabados int,
	@pnExcluirDomingos int
)
returns decimal(28,8)
as
begin

	declare @lnDias as decimal set @lnDias = 0
	declare @lnMeses as decimal set @lnMeses = 0
	declare @lnAno as decimal set @lnAno = 0
	declare @lnAnoInicial as decimal set @lnAnoInicial = 0
	declare @lnAnoFinal as decimal set @lnAnoFinal = 0
	declare @ldtFecha as datetime
	declare @lnResultado as decimal(28,8) set @lnResultado = 0
	declare @ldtFechaInicial as datetime set @ldtFechaInicial = CAST(CAST(DATEPART(year, @pdtFechaInicial) AS varchar) + '/' +
																CAST(DATEPART(month, @pdtFechaInicial) AS varchar) + '/' + 
																CAST(DATEPART(day, @pdtFechaInicial) as varchar) + ' ' +
																CAST(0 as varchar) + ':' + 
																CAST(0 as varchar) + ':' + 
																CAST(0 as varchar) AS datetime)
	declare @ldtFechaFinal as datetime set @ldtFechaFinal = CAST(CAST(DATEPART(year, @pdtFechaFinal) AS varchar) + '/' +
															CAST(DATEPART(month, @pdtFechaFinal) AS varchar) + '/' + 
															CAST(DATEPART(day, @pdtFechaFinal) as varchar) + ' ' +
															CAST(23 as varchar) + ':' + 
															CAST(59 as varchar) + ':' + 
															CAST(59 as varchar) AS datetime)
	
	
	declare feriados_cursor cursor for
			select 	dia, mes, ano
			from 	$$COMPANIA$$.dias_feriados
			
	-- abre cursor
	Open feriados_cursor
	
	-- carga la información en las variables 
	fetch next from feriados_cursor
	into @lnDias,@lnMeses,@lnAno
	
	-- ciclo que realiza la inserción
	while @@fetch_status = 0
	begin
		
		--Si el año es nulo de trata de un feriado Fijo, es decir, válido para todos los años.
		if(@lnAno is null)
		begin
			--Se obtienen los años de la fecha inicial y la final 
			set @lnAnoInicial = DATEPART(year,@ldtFechaInicial)
			set @lnAnoFinal = DATEPART(year,@ldtFechaFinal)
			set @lnAno = @lnAnoInicial
			
			While (@lnAno <= @lnAnoFinal )
			begin
				set @ldtFecha = CAST(CAST(@lnAno AS varchar) + '/' + CAST(@lnMeses AS varchar) + '/' + CAST(@lnDias as varchar) AS datetime) 
			
				--Si el feriado esta en el rango se cuenta 
				if ( @ldtFecha >=  @ldtFechaInicial ) AND ( @ldtFecha <=  @ldtFechaFinal)
				begin
					if NOT( (@pnExcluirSabados = 1 AND DATEPART(DW,@ldtFecha) = 7 ) OR ( @pnExcluirDomingos = 1 AND DATEPART(DW,@ldtFecha) = 1 ) )
						Set @lnResultado = @lnResultado + 1
				end
				set @lnAno = @lnAno + 1
			end
		end
		--Si el año NO es nulo se trata de un feriado Variable, es decir, el feriado varía todos los años por lo que se indica la fecha exacta del mismo para un año específico
		else
		begin
			set @ldtFecha = CAST(CAST(@lnAno AS varchar) + '/' + CAST(@lnMeses AS varchar) + '/' + CAST(@lnDias as varchar) AS datetime) 
			
			--Si el feriado esta en el rango se cuenta 
			if ( @ldtFecha >=  @ldtFechaInicial ) AND ( @ldtFecha <=  @ldtFechaFinal)
			begin
				if NOT( (@pnExcluirSabados = 1 AND DATEPART(DW,@ldtFecha) = 7 ) OR ( @pnExcluirDomingos = 1 AND DATEPART(DW,@ldtFecha) = 1 ) )
					Set @lnResultado = @lnResultado + 1
			end

		end
		
		fetch next from feriados_cursor
		into @lnDias,@lnMeses,@lnAno
	end
		
	-- cierra cursor
	Close feriados_cursor
	deallocate feriados_cursor
	
	return @lnResultado
end;




CREATE FUNCTION $$COMPANIA$$.CN_WORKINGDAYS 
(	
	@pdtFechaInicial datetime, 
	@pdtFechaFinal datetime,
	@pnExcluirSabados int,
	@pnExcluirDomingos int
)
returns decimal(28,8)
as
begin

	declare @lnDias as decimal(28,8) set @lnDias = 0
	
	--Se eliminan las horas minutos y segundos para comparar las fechas
	declare @ldtFechaCalculo as datetime set @ldtFechaCalculo = CAST(CAST(DATEPART(year,@pdtFechaInicial) AS varchar) + '/' + 
								    CAST(DATEPART(month,@pdtFechaInicial) AS varchar) + '/' + 
								    CAST(DATEPART(day,@pdtFechaInicial) as varchar) AS datetime) 
																															
	declare @ldtFechaFinal as datetime set @ldtFechaFinal = CAST(CAST(DATEPART(year,@pdtFechaFinal) AS varchar) + '/' + 
								CAST(DATEPART(month,@pdtFechaFinal) AS varchar) + '/' + 
								CAST(DATEPART(day,@pdtFechaFinal) as varchar) AS datetime) 
	
	--Recorre los días hasta la fecha final y descuenta los sabados y domingos
	While (@ldtFechaCalculo <= @pdtFechaFinal )
	begin
		--Si es Sábado 
		if ( DATEPART(DW,@ldtFechaCalculo) = 7 )
		begin
			if (@pnExcluirSabados = 0)
				set @lnDias = @lnDias + 1
		end
			
		--Si es Domingo
		else if ( DATEPART(DW,@ldtFechaCalculo) = 1 )
		begin
			if( @pnExcluirDomingos = 0) 
				set @lnDias = @lnDias + 1
		end
		else
			set @lnDias = @lnDias + 1
			
		set @ldtFechaCalculo = @ldtFechaCalculo + 1
	end	
	return @lnDias
end;





CREATE FUNCTION $$COMPANIA$$.CN_TIEMPOLABORADO 
(	@pdtFechaInicial datetime, 
	@pdtFechaFinal datetime, 
	@pdtFechaIngreso datetime, 
	@pdtFechaSalida datetime,
	@pdtFechaNoPago datetime,
	@pdtFechaMaxima datetime,
	@pdtFechaMinima datetime,
	@pnExcluirSabados int,
	@pnExcluirDomingos int,
	@pnMedida varchar(20)
)
returns decimal(28,8)
as
begin

	declare @lnTiempo as decimal(28,8) set @lnTiempo = 0
	declare @lnFeriados as decimal(28,8) set @lnFeriados = 0
	
	/*Al empleado se le cambió a estado de no pago antes del período de la nómina*/
	if (@pdtFechaNoPago <> @pdtFechaMaxima) AND (@pdtFechaNoPago < @pdtFechaInicial)
		set @lnTiempo = 0
		
	/*Si el empleado tenia fecha no pago durante el periodo*/
	else if(@pdtFechaNoPago <> @pdtFechaMaxima) AND (@pdtFechaNoPago >= @pdtFechaInicial AND @pdtFechaNoPago <= @pdtFechaFinal)
	begin
		/*Al empleado se le cambió a estado de no pago durante el período de la nómina*/
		if(@pdtFechaIngreso > @pdtFechaInicial)
		begin
			/*Calcula los días feriados sólo si es necesario, cuando los parámetros pbExcluirSabados y pbExcluirDomingos son falsos quiere decir días naturales*/
			if ( @pnExcluirSabados = 1 OR @pnExcluirDomingos = 1 )
				set @lnFeriados = $$COMPANIA$$.cn_FeriadosEntreFechas(@pdtFechaNoPago, @pdtFechaIngreso, @pnExcluirSabados, @pnExcluirDomingos)
			else
				set @lnFeriados = 0
			
			/*Calcula los días de la acción*/
			set @lnTiempo = $$COMPANIA$$.cn_WorkingDays(@pdtFechaIngreso, @pdtFechaSalida, @pnExcluirSabados, @pnExcluirDomingos) - @lnFeriados
		end
		else
		begin
			set @lnTiempo = DATEDIFF(DAY, @pdtFechaInicial, @pdtFechaNoPago)
			
			/*Calcula los días feriados sólo si es necesario, cuando los parámetros pbExcluirSabados y pbExcluirDomingos son falsos quiere decir días naturales*/
			if ( @pnExcluirSabados = 1 OR @pnExcluirDomingos = 1 )
				set @lnFeriados = $$COMPANIA$$.cn_FeriadosEntreFechas(@pdtFechaInicial, @pdtFechaNoPago, @pnExcluirSabados, @pnExcluirDomingos)
			else
				set @lnFeriados = 0
				
			/*Calcula los días de la acción*/
			set @lnTiempo = $$COMPANIA$$.cn_WorkingDays(@pdtFechaInicial, @pdtFechaNoPago, @pnExcluirSabados, @pnExcluirDomingos) - @lnFeriados	
		end
	end
	
	/*El empleado laboró todo el período de la nómina*/
	else  if (@pdtFechaIngreso <= @pdtFechaInicial) AND 
			 ( ( @pdtFechaSalida <> @pdtFechaMinima AND @pdtFechaSalida > @pdtFechaFinal ) OR ( @pdtFechaSalida is null OR @pdtFechaSalida = @pdtFechaMinima ) )
	begin
		/*Calcula los días feriados sólo si es necesario, cuando los parámetros pbExcluirSabados y pbExcluirDomingos son falsos quiere decir días naturales*/
		if ( @pnExcluirSabados = 1 OR @pnExcluirDomingos = 1 )
			set @lnFeriados = $$COMPANIA$$.cn_FeriadosEntreFechas(@pdtFechaInicial, @pdtFechaFinal, @pnExcluirSabados, @pnExcluirDomingos)
		else
			set @lnFeriados = 0
		
		/*Calcula los días de la acción*/
		set @lnTiempo = $$COMPANIA$$.cn_WorkingDays(@pdtFechaInicial, @pdtFechaFinal, @pnExcluirSabados, @pnExcluirDomingos) - @lnFeriados
	end
	
	/* El empleado ingresó después del período*/
	else  if (@pdtFechaIngreso > @pdtFechaFinal)
		set @lnTiempo = 0
	
	/*El empleado salió antes del período*/
	else  if (@pdtFechaSalida <> @pdtFechaMinima AND @pdtFechaSalida <= @pdtFechaInicial)
		set @lnTiempo = 0
	
	/*El empleado Ingresó antes del período y salió durante el período*/
	else  if (@pdtFechaIngreso <= @pdtFechaInicial) AND ( @pdtFechaSalida <> @pdtFechaMinima ) AND ( @pdtFechaSalida > @pdtFechaInicial AND @pdtFechaSalida <= @pdtFechaFinal )
	begin
		set @lnTiempo = DATEDIFF(DAY, @pdtFechaInicial, @pdtFechaSalida)
		
		/*Calcula los días feriados sólo si es necesario, cuando los parámetros pbExcluirSabados y pbExcluirDomingos son falsos quiere decir días naturales*/
		if ( @pnExcluirSabados = 1 OR @pnExcluirDomingos = 1 )
			set @lnFeriados = $$COMPANIA$$.cn_FeriadosEntreFechas(@pdtFechaInicial, @pdtFechaSalida, @pnExcluirSabados, @pnExcluirDomingos)
		else
			set @lnFeriados = 0
		
		/*Calcula los días de la acción*/
		set @lnTiempo = $$COMPANIA$$.cn_WorkingDays(@pdtFechaInicial, @pdtFechaSalida, @pnExcluirSabados, @pnExcluirDomingos) - @lnFeriados
	end
	
	/*El empleado ingresó durante el período y no ha salido o salió después*/
	else  if (@pdtFechaIngreso > @pdtFechaInicial AND @pdtFechaIngreso <= @pdtFechaFinal ) AND 
			 ( ( @pdtFechaSalida <> @pdtFechaMinima AND @pdtFechaSalida > @pdtFechaFinal ) OR ( @pdtFechaSalida is null OR @pdtFechaSalida = @pdtFechaMinima ) )
	begin
		set @lnTiempo = DATEDIFF(DAY, @pdtFechaIngreso, @pdtFechaFinal) + 1
		
		/*Calcula los días feriados sólo si es necesario, cuando los parámetros pbExcluirSabados y pbExcluirDomingos son falsos quiere decir días naturales*/
		if ( @pnExcluirSabados = 1 OR @pnExcluirDomingos = 1 )
			set @lnFeriados = $$COMPANIA$$.cn_FeriadosEntreFechas(@pdtFechaIngreso, @pdtFechaFinal, @pnExcluirSabados, @pnExcluirDomingos)
		else
			set @lnFeriados = 0
		
		/*Calcula los días de la acción*/
		set @lnTiempo = $$COMPANIA$$.cn_WorkingDays(@pdtFechaIngreso, @pdtFechaFinal, @pnExcluirSabados, @pnExcluirDomingos) - @lnFeriados
	end
	
	/*El empleado entró y salió durante el período*/
	else
	begin
		set @lnTiempo = DATEDIFF(DAY, @pdtFechaIngreso, @pdtFechaSalida)
		
		/*Calcula los días feriados sólo si es necesario, cuando los parámetros pbExcluirSabados y pbExcluirDomingos son falsos quiere decir días naturales*/
		if ( @pnExcluirSabados = 1 OR @pnExcluirDomingos = 1 )
			set @lnFeriados = $$COMPANIA$$.cn_FeriadosEntreFechas(@pdtFechaIngreso, @pdtFechaSalida, @pnExcluirSabados, @pnExcluirDomingos)
		else
			set @lnFeriados = 0
			
		/*Calcula los días de la acción*/
		set @lnTiempo = $$COMPANIA$$.cn_WorkingDays(@pdtFechaIngreso, @pdtFechaSalida, @pnExcluirSabados, @pnExcluirDomingos) - @lnFeriados
	end
	
	/*Realiza la conversion de acuerdo a la medida indicasa*/
	if (@pnMedida = 'HORAS')
		set @lnTiempo = @lnTiempo * 8 

	return @lnTiempo
END;




CREATE FUNCTION $$COMPANIA$$.CN_OBTIENETOTALHORAS
(	
	@pdtFechaInicial datetime,
	@pdtFechaFinal datetime	
)
returns decimal(28,8)
as
begin

	declare @ldtFecha as datetime
	declare @lnResultado as decimal(28,8) set @lnResultado = 0
	
	set @ldtFecha = CAST(CAST(DATEPART(year, @pdtFechaInicial) AS varchar) + '/' +
					CAST(DATEPART(month, @pdtFechaInicial) AS varchar) + '/' + 
					CAST(DATEPART(day, @pdtFechaInicial) as varchar) + ' ' +
					CAST(DATEPART(hour, @pdtFechaFinal) as varchar) + ':' + 
					CAST(DATEPART(minute, @pdtFechaFinal) as varchar) + ':' + 
					CAST(DATEPART(second, @pdtFechaFinal) as varchar) AS datetime)
	
	Set @lnResultado = DATEDIFF ( HOUR , @pdtFechaInicial, @ldtFecha )
	
	return @lnResultado
end;





CREATE FUNCTION $$COMPANIA$$.CN_HORASLABORADAS 
(	
	@psEmpleado varchar(20), 
	@pdtFechaInicioNomina datetime,
	@pdtFechaFinalNomina datetime,
	@psConcepto varchar(20),
	@psHorario varchar(50),
	@pnLimiteHoras int,
	@pnLimiteDias int,
	@pnSemanaNatural int,
	@pnDiasCalculo int,
	@pnPeriodo int
)
returns decimal(28,8)
as
begin

	declare @lnDiaHorario as int set @lnDiaHorario = 0
	declare @ldtMarcaHoraInicio as datetime 
	declare @ldtMarcaHoraFinal as datetime
	declare @ldtHorarioFechaInicio as datetime 
	declare @ldtHorarioFechaFinal as datetime
	
	declare @ldtFechaComparacion as datetime
	declare @ldtMarcaHoraAnt as datetime 
	
	declare @ldtFechaInicioNominaTmp datetime
	declare @ldtFechaFinalNominaTmp datetime
	declare @ldtFechaInicioNomina datetime
	declare @ldtFechaFinalNomina datetime
	
	declare @lnCumpleRango as decimal(28,8) set @lnCumpleRango = 0
	declare @lnContDiasLimite as decimal(28,8) set @lnContDiasLimite = 0
	declare @lnDentroNomina as decimal(28,8) set @lnDentroNomina = 0
	declare @lnFueraNomina as decimal(28,8) set @lnFueraNomina = 0
	declare @lnResultado as decimal(28,8) set @lnResultado = 0
	declare @lnFila as decimal(28,8) set @lnFila = 0
	declare @lnContador as int set @lnContador = 0
	
	set @ldtFechaInicioNomina = @pdtFechaInicioNomina
	set @ldtFechaFinalNomina = @pdtFechaFinalNomina
	
	while (@lnContador < @pnDiasCalculo)
		begin
			-- Obtiene los horarios asociados los conceptos indicados.
			declare horario_cursor cursor for
					select 	dia, hora_inicio, hora_final
					from 	$$Compania$$.horario_concepto
					where	horario = @psHorario
					and		concepto in (@psConcepto)
					order by 1,2,3
			
			--Obtiene las marcas de reloj entre los rangos de fechas indicados, incluyente para la fecha inicio y excluyente para la fecha fin.			
			declare marcas_cursor cursor for
					select 	distinct fch_hora_entrada, fch_hora_salida
					from	$$Compania$$.marca_reloj
					where	empleado = @psEmpleado
					and		(  ( ( fch_hora_entrada  >= @ldtFechaInicioNomina) and ( fch_hora_entrada  < @ldtFechaFinalNomina) )
							or ( ( fch_hora_salida  >= @ldtFechaInicioNomina)  and ( fch_hora_salida  < @ldtFechaFinalNomina) ) 
							)
					order by 1
	

			-- abre cursor de marcars
			Open marcas_cursor
	
			-- ciclo que recorre las marcas
			fetch next from marcas_cursor into @ldtMarcaHoraInicio,@ldtMarcaHoraFinal
			while @@fetch_status = 0
			begin
				set @ldtFechaInicioNominaTmp = @ldtMarcaHoraInicio
				set @ldtFechaFinalNominaTmp = @ldtMarcaHoraFinal
				
				-- abre cursor de horarios
				Open horario_cursor
				
				-- ciclo que recorre los horarios
				fetch next from horario_cursor into @lnDiaHorario, @ldtHorarioFechaInicio, @ldtHorarioFechaFinal
				while @@fetch_status = 0
				begin
					set @ldtFechaComparacion = CAST(CAST(DATEPART(year, @ldtHorarioFechaInicio) AS varchar) + '/' +
											   CAST(DATEPART(month, @ldtHorarioFechaInicio) AS varchar) + '/' + 
											   CAST(DATEPART(day, @ldtHorarioFechaInicio) as varchar) + ' ' +
											   CAST(DATEPART(hour, @ldtMarcaHoraFinal) as varchar) + ':' + 
											   CAST(DATEPART(minute, @ldtMarcaHoraFinal) as varchar) + ':' + 
											   CAST(DATEPART(second, @ldtMarcaHoraFinal) as varchar) AS datetime)
												  
					--Verifica si la marca se encuentra o no en el horario de horas extra.
					if ( DATEPART(DW,@ldtMarcaHoraInicio) = @lnDiaHorario AND @ldtFechaComparacion > @ldtHorarioFechaInicio )
					begin
						set @lnCumpleRango = 1
						if (@ldtMarcaHoraInicio <> @ldtMarcaHoraAnt OR @lnContDiasLimite = 0)
							set @lnContDiasLimite = @lnContDiasLimite + 1
							
						--Almacena la marca anterior
						set @ldtMarcaHoraAnt = @ldtMarcaHoraInicio
					end
					else
						set @lnCumpleRango = 0
					
					-- Si cumple con el rango calcula las horas extra.
					if (@lnCumpleRango = 1)
					begin
						--Si el límite de días no se ha excedido
						if (@lnContDiasLimite > @pnLimiteDias)
						begin
							--Compara la fecha inicio de la marca
							set @ldtFechaComparacion = CAST(CAST(DATEPART(year, @ldtHorarioFechaInicio) AS varchar) + '/' +
													   CAST(DATEPART(month, @ldtHorarioFechaInicio) AS varchar) + '/' + 
													   CAST(DATEPART(day, @ldtHorarioFechaInicio) as varchar) + ' ' +
													   CAST(DATEPART(hour, @ldtMarcaHoraInicio) as varchar) + ':' + 
													   CAST(DATEPART(minute, @ldtMarcaHoraInicio) as varchar) + ':' + 
													   CAST(DATEPART(second, @ldtMarcaHoraInicio) as varchar) AS datetime)
							
							if (@ldtFechaComparacion < @ldtHorarioFechaInicio)
								set @ldtMarcaHoraInicio = @ldtHorarioFechaInicio
							
							set @ldtFechaComparacion = CAST(CAST(DATEPART(year, @ldtHorarioFechaFinal) AS varchar) + '/' +
													   CAST(DATEPART(month, @ldtHorarioFechaFinal) AS varchar) + '/' + 
													   CAST(DATEPART(day, @ldtHorarioFechaFinal) as varchar) + ' ' +
													   CAST(DATEPART(hour, @ldtMarcaHoraFinal) as varchar) + ':' + 
													   CAST(DATEPART(minute, @ldtMarcaHoraFinal) as varchar) + ':' + 
													   CAST(DATEPART(second, @ldtMarcaHoraFinal) as varchar) AS datetime)
											           
							If (@ldtFechaComparacion > @ldtHorarioFechaFinal)
								set @ldtMarcaHoraFinal = @ldtHorarioFechaFinal
								
							set @lnResultado =  @lnResultado + $$Compania$$.cn_ObtieneTotalHoras(@ldtMarcaHoraInicio, @ldtMarcaHoraFinal)
							--Si se trata de una semana natural
							if (@pnSemanaNatural = 1)
							begin
								if (@ldtFechaInicioNomina > @ldtFechaInicioNominaTmp OR @ldtFechaFinalNomina < @ldtFechaFinalNominaTmp)
									Set @lnFueraNomina = @lnFueraNomina + $$Compania$$.cn_ObtieneTotalHoras(@ldtMarcaHoraInicio, @ldtMarcaHoraFinal)
								else
									Set @lnDentroNomina = @lnDentroNomina + $$Compania$$.cn_ObtieneTotalHoras(@ldtMarcaHoraInicio, @ldtMarcaHoraFinal)
							end

							end
					end

					set @ldtMarcaHoraInicio = @ldtFechaInicioNominaTmp
					set @ldtMarcaHoraFinal = @ldtFechaFinalNominaTmp
					set @lnFila = @lnFila + 1

					fetch next from horario_cursor into @lnDiaHorario, @ldtHorarioFechaInicio, @ldtHorarioFechaFinal
				end
				
				-- cierra cursor horarios
				Close horario_cursor
				
				set @lnFila = 0
				fetch next from marcas_cursor into @ldtMarcaHoraInicio,@ldtMarcaHoraFinal
			end

			--Si hay un límite de horas se las resta sino las reporta todas.
			if( @pnLimiteHoras > 0)
			begin
				if (@lnResultado > @pnLimiteHoras)
				begin
					set @lnResultado = @lnResultado - @pnLimiteHoras
					
					--Si se trata de una semana natural
					if (@pnSemanaNatural = 1)
					begin
						if (@lnFueraNomina > 0)
						begin
							if (@lnResultado < 0)
								Set @lnResultado = @lnDentroNomina + @lnResultado
							else
							begin
								if (@lnFueraNomina - @pnLimiteHoras > 0)
									set @lnResultado = @lnDentroNomina
								else
								begin
									set @lnResultado = @lnFueraNomina - @pnLimiteHoras
									set @lnResultado = @lnDentroNomina + @lnResultado
								end
							end
						end
					end
				end
				else
					Set @lnResultado = 0
			end


			-- cierra cursor
			Close marcas_cursor
			deallocate horario_cursor
			deallocate marcas_cursor
			
			set @ldtFechaInicioNomina = @ldtFechaFinalNomina
			set @ldtFechaFinalNomina = @ldtFechaFinalNomina + @pnPeriodo
			
			set @lnContador = @lnContador + 1
		end
	
	return @lnResultado
end;





CREATE FUNCTION $$COMPANIA$$.CN_ACUMULADOACCPERS 
( 
  @pdtFechaInicioNomina datetime, 
  @pdtFechaFinalNomina datetime,
  @pdtFechaRige datetime, 
  @pdtFechaVence datetime,
  @pnLimiteInferior int,
  @pnLimiteSuperior int,
  @pnNatural int,
  @pnExcluirSabados int,
  @pnExcluirDomingos int
  
 )
returns decimal(28,8)
as
begin

  declare @lnFeriados as decimal(28,8) set @lnFeriados = 0
  declare @lnFeriadosTotal as decimal(28,8) set @lnFeriadosTotal = 0
  declare @lnResultado as decimal(28,8) set @lnResultado = 0
  declare @lnResultadoTotal as decimal(28,8) set @lnResultadoTotal = 0
  declare @lnLimiteInferior as decimal(28,8) set @lnLimiteInferior = @pnLimiteInferior
  declare @lnLimiteSuperior as decimal(28,8) set @lnLimiteSuperior = @pnLimiteSuperior
  declare @lnDiasLimites as decimal(28,8) set @lnDiasLimites = 0
  declare @lnAnno as int set @lnAnno = 0
  declare @lnAjustar as decimal(28,8) set @lnAjustar = 0
  declare @lnValidarLimiteInferior as decimal(28,8) set @lnValidarLimiteInferior = 0
  declare @lnValidarLimiteSuperior as decimal(28,8) set @lnValidarLimiteSuperior = 0
  declare @lnAjustarLimiteInferior as decimal(28,8) set @lnAjustarLimiteInferior = 0
  declare @ldtFechaRigePeriodo as datetime
  declare @ldtFechaVencePeriodo as datetime
  declare @ldtFecha as datetime
  
  
  set @lnValidarLimiteSuperior = 1
  if(@pnLimiteInferior = 1) 
   set @lnValidarLimiteInferior = 0
  else
   set @lnValidarLimiteInferior = 1
  
  /*Si límite superior es cero, le asigna una constante suficientemente alta*/
  if(@pnLimiteSuperior is null or @pnLimiteSuperior = 0)
   begin
    set @pnLimiteSuperior = 100000
    set @lnValidarLimiteSuperior = 0
   end
  if(@pnLimiteInferior is null or @pnLimiteInferior = 0)
   begin
    set @pnLimiteInferior = 1
    set @lnValidarLimiteInferior = 0
   end

  /*Verifica el día inicio de la acción que corresponda al período*/
  if(@pdtFechaRige > @pdtFechaInicioNomina)
   Set @ldtFechaRigePeriodo = @pdtFechaRige
  else
   Set @ldtFechaRigePeriodo = @pdtFechaInicioNomina

  /*Verifica el día final de la acción que corresponda al período*/
  If (@pdtFechaVence is null OR @pdtFechaVence > @pdtFechaFinalNomina)
   Set @ldtFechaVencePeriodo = @pdtFechaFinalNomina
  Else
   Set @ldtFechaVencePeriodo = @pdtFechaVence

  
  /*Si el cálculo es NATURAL, significa que se toma la cantidad de días que tenga cada mes (se mantiene el cálculo original)*/
  if(@pnNatural = 1)
  begin
   /*Calcula los días feriados sólo si es necesario, cuando los parámetros pbExcluirSabados y pbExcluirDomingos son falsos quiere decir días naturales*/
   if ( @pnExcluirSabados = 1 OR @pnExcluirDomingos = 1 )
    begin
     set @lnFeriados = $$COMPANIA$$.cn_FeriadosEntreFechas( @ldtFechaRigePeriodo, @ldtFechaVencePeriodo, @pnExcluirSabados, @pnExcluirDomingos )
     
     /*Si la fecha rige de la acción es menor a la fecha inicial de la nómina, calcula esos días anteriores a la nómina actual*/
     if (@pdtFechaRige < @pdtFechaInicioNomina)
      set @lnFeriadosTotal = $$COMPANIA$$.cn_FeriadosEntreFechas( @pdtFechaRige, @pdtFechaInicioNomina - 1, @pnExcluirSabados, @pnExcluirDomingos )
     else
      set @lnFeriadosTotal = 0
    end
   
   /*Calcula los días de la acción*/
   set @lnResultado = $$COMPANIA$$.cn_WorkingDays( @ldtFechaRigePeriodo, @ldtFechaVencePeriodo, @pnExcluirSabados, @pnExcluirDomingos ) - @lnFeriados
   
   /*Si la fecha rige de la acción es menor a la fecha inicial de la nómina, calcula esos días anteriores a la nómina actual*/
   if (@pdtFechaRige < @pdtFechaInicioNomina)
    set @lnResultadoTotal = $$COMPANIA$$.cn_WorkingDays( @pdtFechaRige, @pdtFechaInicioNomina - 1, @pnExcluirSabados, @pnExcluirDomingos ) - @lnFeriadosTotal
   else
    set @lnResultadoTotal = 0
   
   /*Elimina los días que caen fuera de los límites*/
   /*Si el límite superior es diferente de 100000 (el default cuando no se definió), es porque hay que considerar ese límite y ajustar los días a retornar*/
   if (@pnLimiteSuperior != 100000)
    begin
     /*Si la fecha rige de la acción es menor a la fecha inicial de la nómina, actualiza los límites para asegurar que tomen los días apropiados*/
     if (@pdtFechaRige < @pdtFechaInicioNomina)
      begin
       /*Para ajustar los límites, se engaña al sistema con el límite inferior igual al último día hábil del periodo anterior*/
       if(@lnLimiteInferior < @lnResultadoTotal)
        begin
         set @lnLimiteInferior = @lnResultadoTotal
         set @lnAjustarLimiteInferior = 1
        end
       set @lnResultado = @lnResultado + @lnResultadoTotal
      end
     
     if (@lnResultado >= @lnLimiteInferior)
      begin
       if(@lnLimiteInferior > 1)
        set @lnDiasLimites = @lnLimiteInferior
       else
        set @lnDiasLimites = 0
        
       if(@lnResultado > @lnLimiteSuperior)
        set @lnDiasLimites = @lnDiasLimites + ( @lnResultado - @lnLimiteSuperior )
        
       if (@lnValidarLimiteInferior = 0)
        begin
         set @lnResultado = @lnResultado - @lnDiasLimites
         if(@pdtFechaRige = ( @pdtFechaInicioNomina - 1 ))
          set @lnResultado = @lnResultado - 1
        end
       else
        begin
         if(@lnAjustarLimiteInferior = 1)
          set @lnResultado = @lnResultado - @lnDiasLimites 
         else
          set @lnResultado = @lnResultado - @lnDiasLimites + 1
        end
      end
     else
      set @lnResultado = 0
    end
   
   /*Si la cantidad de días de la acción anteriores al inicio de la nómina es menor al límite inferior, entonces hay que ajustar los días a retornar*/
   else if (@lnResultadoTotal < @lnLimiteInferior)
    set @lnResultado = @lnResultado - ( @lnLimiteInferior - @lnResultadoTotal - 1 )
    
   /*Si el resultado fue negativo, se pone en cero*/
   if(@lnResultado < 0)
    set @lnResultado = 0

  end
  /*Si el cálculo es CONTABLE, significa que se excluyen los días 31 días de los meses que los tienen, y para febrero se toman 30 días en total*/
  else
  begin
   Set @lnAjustar = 0
   Set @lnAnno = DATEPART(year,@ldtFechaRigePeriodo)
   
   /* Año a año se verifica cuántos días deben sumarse o restarse para cumplir con meses de 30 días*/
   while (@lnAnno <= DATEPART(year,@ldtFechaVencePeriodo))
   begin
    /*Se valida si hay que rebajar el 31 de enero*/
    set @ldtFecha = CAST(CAST(@lnAnno AS varchar) + '/01/31' AS datetime) 
    if(@ldtFecha >= @ldtFechaRigePeriodo AND @ldtFecha <= @ldtFechaVencePeriodo)
     set @lnAjustar = @lnAjustar - 1
     
    /*Se valida si hay que aumentar días por el mes de febrero valida si es bisiesto*/
    if ( (@lnAnno % 400 = 0 ) OR (@lnAnno % 4 = 0 )) 
       begin
     set @ldtFecha = CAST(CAST(@lnAnno AS varchar) + '/02/29' AS datetime) 
        if(@ldtFecha >= @ldtFechaRigePeriodo AND @ldtFecha <= @ldtFechaVencePeriodo)
              set @lnAjustar = @lnAjustar + 1
       end
    else
       begin
     set @ldtFecha = CAST(CAST(@lnAnno AS varchar) + '/02/28' AS datetime)
       if(@ldtFecha >= @ldtFechaRigePeriodo AND @ldtFecha <= @ldtFechaVencePeriodo)
              set @lnAjustar = @lnAjustar + 2
       end

    /*Se valida si hay que rebajar el 31 de marzo*/
    set @ldtFecha = CAST(CAST(@lnAnno AS varchar) + '/03/31' AS datetime) 
    if(@ldtFecha >= @ldtFechaRigePeriodo AND @ldtFecha <= @ldtFechaVencePeriodo)
     set @lnAjustar = @lnAjustar - 1
     
    /*Se valida si hay que rebajar el 31 de mayo*/
    set @ldtFecha = CAST(CAST(@lnAnno AS varchar) + '/05/31' AS datetime) 
    if(@ldtFecha >= @ldtFechaRigePeriodo AND @ldtFecha <= @ldtFechaVencePeriodo)
     set @lnAjustar = @lnAjustar - 1
     
    /*Se valida si hay que rebajar el 31 de julio*/
    set @ldtFecha = CAST(CAST(@lnAnno AS varchar) + '/07/31' AS datetime) 
    if(@ldtFecha >= @ldtFechaRigePeriodo AND @ldtFecha <= @ldtFechaVencePeriodo)
     set @lnAjustar = @lnAjustar - 1
     
    /*Se valida si hay que rebajar el 31 de agosto*/
    set @ldtFecha = CAST(CAST(@lnAnno AS varchar) + '/08/31' AS datetime) 
    if(@ldtFecha >= @ldtFechaRigePeriodo AND @ldtFecha <= @ldtFechaVencePeriodo)
     set @lnAjustar = @lnAjustar - 1
     
    /*Se valida si hay que rebajar el 31 octubre agosto*/
    set @ldtFecha = CAST(CAST(@lnAnno AS varchar) + '/10/31' AS datetime) 
    if(@ldtFecha >= @ldtFechaRigePeriodo AND @ldtFecha <= @ldtFechaVencePeriodo)
     set @lnAjustar = @lnAjustar - 1
     
    /*Se valida si hay que rebajar el 31 diciembre agosto*/
    set @ldtFecha = CAST(CAST(@lnAnno AS varchar) + '/12/31' AS datetime) 
    if(@ldtFecha >= @ldtFechaRigePeriodo AND @ldtFecha <= @ldtFechaVencePeriodo)
     set @lnAjustar = @lnAjustar - 1
    
    /*Aumenta el año*/
    Set @lnAnno = DATEPART(year,@ldtFechaRigePeriodo) + 1
   end 
   
   /*Calcula los días de la acción*/
   set @lnResultado = $$COMPANIA$$.cn_WorkingDays(@ldtFechaRigePeriodo, @ldtFechaVencePeriodo, @pnExcluirSabados, @pnExcluirDomingos )
   
   /*Si la fecha rige de la acción es menor a la fecha inicial de la nómina, calcula esos días anteriores a la nómina actual*/
   if (@pdtFechaRige < @pdtFechaInicioNomina)
    set @lnResultadoTotal = $$COMPANIA$$.cn_WorkingDays( @pdtFechaRige, @pdtFechaInicioNomina - 1, @pnExcluirSabados, @pnExcluirDomingos )
   else
    Set @lnResultadoTotal = 0

   /*Elimina los días que caen fuera de los límites*/
   /*Si el límite superior es diferente de 100000 (el default cuando no se definió), es porque hay que considerar ese límite y ajustar los días a retornar*/
   if (@pnLimiteSuperior != 100000)
    begin
     /*Si la fecha rige de la acción es menor a la fecha inicial de la nómina, actualiza los límites para asegurar que tomen los días apropiados*/
     if (@pdtFechaRige < @pdtFechaInicioNomina)
      begin
       /*Para ajustar los límites, se engaña al sistema con el límite inferior igual al último día hábil del periodo anterior*/
       if(@lnLimiteInferior < @lnResultadoTotal)
        begin
         set @lnLimiteInferior = @lnResultadoTotal
         set @lnAjustarLimiteInferior = 1
        end
       set @lnResultado = @lnResultado + @lnResultadoTotal
      end
     
     if (@lnResultado >= @lnLimiteInferior)
      begin
       if(@lnLimiteInferior > 1)
        set @lnDiasLimites = @lnLimiteInferior
       else
        set @lnDiasLimites = 0
        
       if(@lnResultado > @lnLimiteSuperior)
        set @lnDiasLimites = @lnDiasLimites + ( @lnResultado - @lnLimiteSuperior )
        
       if (@lnValidarLimiteInferior = 0)
        begin
         set @lnResultado = @lnResultado - @lnDiasLimites
         if(@pdtFechaRige = ( @pdtFechaInicioNomina - 1 ))
          set @lnResultado = @lnResultado - 1
        end
       else
        begin
         if(@lnAjustarLimiteInferior = 1)
          set @lnResultado = @lnResultado - @lnDiasLimites 
         else
          set @lnResultado = @lnResultado - @lnDiasLimites + 1
        end
      end 
     else
      set @lnResultado = 0
    end
   /*Si la cantidad de días de la acción anteriores al inicio de la nómina es menor al límite inferior, entonces hay que ajustar los días a retornar*/
   else if (@lnResultadoTotal < @lnLimiteInferior)
    set @lnResultado = @lnResultado - ( @lnLimiteInferior - @lnResultadoTotal - 1 )
    
   /*Si el resultado fue negativo, se pone en cero*/
   if(@lnResultado < 0)
    set @lnResultado = 0
    
   Set @lnResultado = @lnResultado + @lnAjustar
  end
  return @lnResultado 
 end;




CREATE PROCEDURE $$COMPANIA$$.CN_APLICARSALDO
(@pnNumeroAccion  INT,
 @psNomina        NVARCHAR(4),
 @pnNumeroNomina  SMALLINT,
 @pnSaldo         DECIMAL(28, 8),
 @psTipoAccion    VARCHAR(4),
 @pnEliminarSaldo INT,
 @pnEsAjuste      INT
)
AS
     DECLARE @lnConsecutivo AS DECIMAL(28, 8)
     SET @lnConsecutivo = 0
     BEGIN
         IF(@pnEsAjuste = 1)
             BEGIN

/*Elimina los registros anteriores del tipo de acción para el empleado*/


                 IF(@pnEliminarSaldo = 1)
                     BEGIN
                         DELETE FROM $$COMPANIA$$.AJUSTE_ACC_SALDO
                         WHERE nomina = @psNomina
                               AND numero_nomina = @pnNumeroNomina
                               AND numero_accion IN
                         (
                             SELECT numero_accion
                             FROM $$COMPANIA$$.empleado_acc_per
                             WHERE tipo_accion = @psTipoAccion
                                   AND saldo > 0
                         )
                 END
 
 

/*Obtiene el siguiente consecutivo del chequeo*/

                 SELECT @lnConsecutivo = ISNULL(MAX(consecutivo), 0) + 1
                 FROM $$COMPANIA$$.empleado_acc_saldo
 
 

/*Inserta el saldo*/


                 INSERT INTO $$COMPANIA$$.AJUSTE_ACC_SALDO
                 (consecutivo,
                  numero_accion,
                  nomina,
                  numero_nomina,
                  dias_aplicados
                 )
                 VALUES
                 (@lnConsecutivo,
                  @pnNumeroAccion,
                  @psNomina,
                  @pnNumeroNomina,
                  @pnSaldo
                 )
         END
             ELSE
             BEGIN
                 IF(@pnEliminarSaldo = 1)
                     BEGIN
                         DELETE FROM $$COMPANIA$$.empleado_acc_saldo
                         WHERE nomina = @psNomina
                               AND numero_nomina = @pnNumeroNomina
                               AND numero_accion IN
                         (
                             SELECT numero_accion
                             FROM $$COMPANIA$$.empleado_acc_per
                             WHERE tipo_accion = @psTipoAccion
                                   AND saldo > 0
                         )
                 END
 
 

/*Obtiene el siguiente consecutivo del chequeo*/

                 SELECT @lnConsecutivo = ISNULL(MAX(consecutivo), 0) + 1
                 FROM $$COMPANIA$$.empleado_acc_saldo
 
 

/*Inserta el saldo*/


                 INSERT INTO $$COMPANIA$$.empleado_acc_saldo
                 (consecutivo,
                  numero_accion,
                  nomina,
                  numero_nomina,
                  liquidacion,
                  dias_aplicados
                 )
                 VALUES
                 (@lnConsecutivo,
                  @pnNumeroAccion,
                  @psNomina,
                  @pnNumeroNomina,
                  NULL,
                  @pnSaldo
                 )
         END
     END;





create function $$COMPANIA$$.cn_SalarioPromedio 
(	
	@pdtFechaInicioR1 datetime, 
	@pdtFechaFinR1 datetime,
	@pdtFechaInicioR2 datetime, 
	@pdtFechaFinR2 datetime,
	@pdtFechaIngreso datetime,
	@pnSalarioReferencia decimal(28,8)
)
returns decimal(28,8)
as
begin

	declare @lnResultado as decimal(28,8) set @lnResultado = 0
	declare @lnSalarioInicial as decimal(28,8) set @lnSalarioInicial = 0
	declare @lnSalario as decimal(28,8) set @lnSalario = 0
	declare @ldtFechaRigeInicial as datetime
	declare @ldtFechaRige as datetime
	declare @lnPonderado as decimal(28,8) set @lnPonderado = 0
	
	
	--Si la fecha inicial es menor a la fecha de ingreso del empleado se coloca como fecha inicial la fecha de ingreso del empleado
	if (@pdtFechaInicioR1  < @pdtFechaIngreso)
		set @pdtFechaInicioR1 = @pdtFechaIngreso

	-- Si  la fecha final es menor a la fecha de ingreso del empleado no se calcula salario promedio, se regresa el salario de referencia del empleado
	if (@pdtFechaFinR2 < @pdtFechaIngreso)
		Set @lnResultado = @pnSalarioReferencia
	else
	begin
		-- Calcula la accion inicial del empleado
		declare accion_cursor cursor for
		select	salario_promedio, fecha_rige
		from	$$COMPANIA$$.empleado_acc_per eap, 
				$$COMPANIA$$.tipo_accion ta 
		where	eap.tipo_accion = ta.tipo_accion
		and		eap.empleado = '194127'
		and     (	tipo_accion_predef = 4 OR tipo_accion_predef = 10 OR tipo_accion_predef = 1 
				 OR tipo_accion_predef  =  5 OR tipo_accion_predef = 6 )
		and		estado_accion = 'S'
		and		fecha_rige = (
								select	max( fecha_rige )
								from	$$COMPANIA$$.empleado_acc_per eap2, 
									$$COMPANIA$$.tipo_accion ta2
								where	eap2.tipo_accion = ta2.tipo_accion
								and	eap2.empleado = eap.empleado
								and     (ta2.tipo_accion_predef = 4 OR ta2.tipo_accion_predef = 10 OR ta2.tipo_accion_predef = 1 
									  OR ta2.tipo_accion_predef  =  5 OR ta2.tipo_accion_predef = 6 )
								and	eap2.estado_accion = 'S'
								AND	eap2.fecha_rige <=  @pdtFechaInicioR1 
								AND	eap2.salario_promedio > 0 )
								
		
		-- abre cursor
		Open accion_cursor
		
		-- ciclo que recorre la accion
		fetch next from accion_cursor into @lnSalarioInicial, @ldtFechaRigeInicial
		
		If (@lnSalarioInicial is not null)
		begin
		while @@fetch_status = 0
		begin
		
			-- Calcula la accion inicial del empleado
			declare accion2_cursor cursor for
			select	salario_promedio, fecha_rige
			from	$$COMPANIA$$.empleado_acc_per eap, 
					$$COMPANIA$$.tipo_accion ta 
			where	eap.tipo_accion = ta.tipo_accion
			and		eap.empleado = '194127'
			and     (	ta.tipo_accion_predef = 4 OR ta.tipo_accion_predef = 10 OR ta.tipo_accion_predef = 1 
					 OR ta.tipo_accion_predef  =  5 OR ta.tipo_accion_predef = 6 )
			and		estado_accion = 'S'
			and		eap.fecha_rige >  @pdtFechaInicioR1 
			and		eap.fecha_rige <=  @pdtFechaFinR2 
			and		eap.salario_promedio > 0
			
			--Calcula el primer valor
			set @ldtFechaRigeInicial = @pdtFechaInicioR1

			
			-- abre cursor
			Open accion2_cursor
			
			-- ciclo que recorre la accion
			fetch next from accion2_cursor into @lnSalario, @ldtFechaRige
			while @@fetch_status = 0
			begin
				set @lnPonderado = @lnPonderado + DATEDIFF(DAY, @ldtFechaRigeInicial, @ldtFechaRige) * @lnSalarioInicial
				set @ldtFechaRigeInicial = @ldtFechaRige
				set @lnSalarioInicial = @lnSalario
				fetch next from accion2_cursor into @lnSalario, @ldtFechaRige
			end
			
			-- cierra cursor
			Close accion2_cursor
			deallocate accion2_cursor
			
			--Calcula el ultimo valor
			Set @lnPonderado = @lnPonderado + ( DATEDIFF(DAY, @ldtFechaRigeInicial, @pdtFechaFinR2 ) + 1)  * @lnSalarioInicial

			--Calcula el salario ponderado
			Set @lnPonderado = @lnPonderado / DATEDIFF(DAY, @pdtFechaInicioR1, @pdtFechaFinR2 ) + 1
			fetch next from accion_cursor into @lnSalarioInicial, @ldtFechaRigeInicial
			
		end
		
		set @lnResultado = @lnPonderado
		
		-- cierra cursor
		Close accion_cursor
		deallocate accion_cursor

		end
	
		if(@lnResultado <= 0)
			set @lnResultado = @pnSalarioReferencia
	end
	
	return @lnResultado 
end;




CREATE PROCEDURE $$COMPANIA$$.CN_PERIODOSCUMPLIDOSVAC
(
	@psNomina varchar(4), 
	@pnNumeroNomina smallint,
	@psEmpleado varchar(20),
	@pnCantidadDias decimal(28,8)
)
as
begin
	declare @lsRegimenVacacional as varchar(12)
	declare @lnPeriodos as decimal(28,8) set  @lnPeriodos = 0
	declare @lnAnno as decimal(28,8) set  @lnAnno = 0
	declare @lnConsecutivo as decimal(28,8) set  @lnConsecutivo = 0
    
    	--Obtiene el regimen vacacional del empleado
    	select @lsRegimenVacacional = regimen_vacacional FROM $$COMPANIA$$.empleado_vacacion where empleado = @psEmpleado
	
    	--Elimina las marcas de nómina y número de nómina para las capas de saldo de vacaciones
    	UPDATE	$$COMPANIA$$.empleado_saldo_vac 
    	SET	nomina = NULL,
		numero_nomina = NULL,
            	liquidacion = NULL 
    	WHERE   empleado = @psEmpleado 
    	AND     nomina = @psNomina 
    	AND     numero_nomina = @pnNumeroNomina
    	AND	liquidacion IS NULL
                
	-- Obtiene el Select para las capas de saldos del empleado con saldo cero
	declare capa_cursor cursor for
		select 	anno, consecutivo
		from 	$$COMPANIA$$.empleado_saldo_vac 
		where	empleado = @psEmpleado
		AND	regimen_vacacional = @lsRegimenVacacional
		AND	acumulado >= @pnCantidadDias
		AND	nomina IS NULL
		AND 	numero_nomina IS NULL
		AND	liquidacion IS NULL
			
			
    	-- abre cursor
	Open capa_cursor
	
	-- ciclo que recorre las capas
	fetch next from capa_cursor into @lnAnno, @lnConsecutivo
	while @@fetch_status = 0
	begin
		--Marca la capa de saldos con número de nómina y nómina ó número de liquidación de empleados
		UPDATE	$$COMPANIA$$.empleado_saldo_vac 
		SET		nomina = @psNomina,
				numero_nomina = @pnNumeroNomina,
				liquidacion = NULL
		WHERE	consecutivo = @lnConsecutivo
		AND		empleado = @psEmpleado
		
		set @lnPeriodos = @lnPeriodos + 1
		fetch next from capa_cursor into @lnAnno, @lnConsecutivo
	end
    
    	-- cierra cursor
	Close capa_cursor
	deallocate capa_cursor
	
    	select @lnPeriodos
end;




CREATE FUNCTION $$COMPANIA$$.CN_APLICARREDONDEO
( 
  @pNumero float, 
  @pFactor decimal(28,8)
)
returns decimal(28,8)
as
begin

  declare @lnResultado as float set @lnResultado = 0
  declare @lnDecimals as  decimal(28,8) set @lnDecimals = 0
  
  if(@pFactor > 0)
   begin
    if(@pNumero < 0) 
     begin
      set @lnDecimals = (@pNumero / @pFactor - 0.50) - ROUND( cast(@pNumero / @pFactor as decimal(28,8)) - 0.50, 0, 1 )
      set @lnResultado = ROUND( @pNumero / @pFactor - 0.50, 0, 1 ) * @pFactor
     end
    else
     begin
      set @lnDecimals = (@pNumero / @pFactor + 0.50) - ROUND( cast(@pNumero / @pFactor as decimal(28,8)) + 0.50, 0, 1 )
      set @lnResultado = ROUND( @pNumero / @pFactor + 0.50, 0, 1 ) * @pFactor
     end
   end
  else
   set @lnResultado = @pNumero
   return @lnResultado  
 end;




CREATE FUNCTION $$COMPANIA$$.CN_ADDXMONTHS 
(	
	@pdtFecha datetime, 
	@pnMeses int
)
returns datetime
as
begin

	declare @lnDia as int set @lnDia = 0
	declare @lnMes as int set @lnMes = 0
	declare @lnAno as int set @lnAno = 0
	declare @ldtNuevaFecha as datetime

	set @lnDia = DAY(@pdtFecha)
    	set @lnMes = MONTH(@pdtFecha)
    	set @lnAno = YEAR(@pdtFecha)          
   
    if (@pnMeses > 0)
		begin
			set @lnAno = @lnAno + (@pnMeses / 12)
			set @lnMes = @lnMes + (@pnMeses % 12)
			if (@lnMes > 12)
				begin
					set @lnAno = @lnAno + (@lnMes / 12)
					set @lnMes = @lnMes % 12
				end
		end
	else
        begin
            set @pnMeses = -@pnMeses
            set @lnAno = @lnAno - (@pnMeses / 12)
            set @lnMes = @lnMes - (@pnMeses % 12)
            if (@lnMes < 1)
				begin
					set @lnAno = @lnAno - 1
					set @lnMes = 12 + @lnMes
				end
        end
		

    --Obtiene el último día del mes
    set @ldtNuevaFecha = DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@pdtFecha)+1,0)) 
    
    --si es una fecha de fin de mes devolver una fecha de fin de mes
    if (DAY(@ldtNuevaFecha) = @lnDia)
		begin
			set @ldtNuevaFecha = CAST(CAST(@lnAno AS varchar) + '/' + CAST(@lnMes AS varchar) + '/' + CAST(1 as varchar) AS datetime)
			--Retorna el último día del mes
			return DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@ldtNuevaFecha)+1,0))
		end	
		
	
	
    --haga una fecha con el mismo dia, asegurese de que sea una fecha valida sino mande la fecha de fin de mes
    if (IsDate(CAST(@lnAno AS varchar) + '/' + CAST(@lnMes AS varchar) + '/' + CAST(@lnDia as varchar)) = 0)
		begin
			set @ldtNuevaFecha = CAST(CAST(@lnAno AS varchar) + '/' + CAST(@lnMes AS varchar) + '/' + CAST(1 as varchar) AS datetime)
			--Retorna el último día del mes
			return DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@ldtNuevaFecha)+1,0))
		end
    set @ldtNuevaFecha = CAST(CAST(@lnAno AS varchar) + '/' + CAST(@lnMes AS varchar) + '/' + CAST(@lnDia as varchar) AS datetime)

    return @ldtNuevaFecha
end;





CREATE FUNCTION $$COMPANIA$$.CN_RUTC_CALCULARCONCEPTO
(	
	@psNomina varchar(4), 
	@pnNumeroNomina int,
	@pdtFechaInicioNomina datetime,
	@pdtFechaFinNomina datetime,
	@pdtFechaPagoNomina datetime,
	@psEmpleado varchar(20),
	@psConcepto varchar(20),
	@psCentroCosto varchar(25),
	@pnCantidad int,
	@pnMonto int
)
returns decimal(28,8)
as
begin
	return 0
end;


CREATE FUNCTION $$COMPANIA$$.CN_ROUNDBASE
(	
	@pnNumero int,
	@pnBase int,
	@pnLimite int
)
returns decimal(28,8)
as
begin
	declare	@lnLongitudLimite as  int set @lnLongitudLimite = 0
	declare	@lnArgumentoLimite as  int set @lnArgumentoLimite = 0
	declare @lnResultado as decimal(28,8) set @lnResultado = 0
	
	-- Obtiene el número de dígitos del limite
	set @lnLongitudLimite = len(cast(@pnLimite as varchar))
	
	-- Obtiene la parte del argumento para comparar con el límite
	set @lnArgumentoLimite = right(cast(@pnNumero as varchar), @lnLongitudLimite)
	
	-- Se compara para saber si debe sumar o restar la base
	if(@lnArgumentoLimite <= @pnLimite)
		set @lnResultado = ( @pnNumero - @lnArgumentoLimite )
	else
		set @lnResultado = ( @pnNumero - @lnArgumentoLimite ) + @pnBase
	
	if(@lnResultado < 0)
		set @lnResultado = 0
		
	return @lnResultado
end;




CREATE FUNCTION $$COMPANIA$$.CN_ObtenerAdminCotizante (@ParamEmpleado as varchar(20), @ParamConcepto as varchar(10), @ParamFechaFinNomina as datetime)
RETURNS nvarchar(10)
AS
BEGIN 
	DECLARE @VarAdministradoraFiltro varchar(10) = NULL
	DECLARE @VarAdministradora varchar(10) = NULL
	DECLARE @VarFechaIngreso datetime
	DECLARE @VarFechaSalida datetime

	DECLARE AdminCotCursor CURSOR FOR
	SELECT 	ADMINISTRADORA, FECHA_INGRESO, FECHA_SALIDA
	FROM 	$$COMPANIA$$.ADMIN_COTIZANTE
	WHERE 	empleado = @ParamEmpleado
	AND 	administradora IN ( SELECT ADMINISTRADORA FROM $$COMPANIA$$.ADMIN_CONCEPTO WHERE CONCEPTO = @ParamConcepto)
	ORDER BY FECHA_INGRESO 

	OPEN AdminCotCursor

	FETCH NEXT FROM AdminCotCursor
	INTO @VarAdministradora, @VarFechaIngreso, @VarFechaSalida

	WHILE @@FETCH_STATUS = 0 AND @VarAdministradoraFiltro IS NULL
	BEGIN
		IF @VarFechaSalida is NULL AND @VarFechaIngreso > @ParamFechaFinNomina
			SET @VarAdministradoraFiltro = @VarAdministradora
		ELSE IF @VarFechaIngreso <= @ParamFechaFinNomina AND @VarFechaSalida >= @ParamFechaFinNomina
			SET @VarAdministradoraFiltro = @VarAdministradora

		FETCH NEXT FROM AdminCotCursor
		INTO @VarAdministradora, @VarFechaIngreso, @VarFechaSalida
	END

	CLOSE AdminCotCursor
	DEALLOCATE AdminCotCursor

	RETURN @VarAdministradoraFiltro
END;


CREATE FUNCTION $$COMPANIA$$.cn_ValidaAniversario
(	
	@pdtFechaAniversario datetime, 
	@pdtFechaInicial datetime,
	@pdtFechaFinal datetime
)
returns int
as
begin

	/*Si la fecha de aniversario es el 29 de febrero el el año de la fecha inicial no es bisiesto ajusta la fecha al 28 de febrero*/
	if ( YEAR(@pdtFechaInicial) % 400 <> 0 ) AND (YEAR(@pdtFechaInicial) % 4 <> 0 ) AND (MONTH(@pdtFechaAniversario) = 2) AND (DAY(@pdtFechaAniversario) = 29)
		set @pdtFechaAniversario = @pdtFechaAniversario - 1

	/*Trae el aniversario al año en que se está validando el rango*/
	declare @ldtFechaAnivActual as datetime set @ldtFechaAnivActual = CAST(CAST(DATEPART(year,@pdtFechaInicial) AS varchar) + '/' + 
																	  CAST(DATEPART(month,@pdtFechaAniversario) AS varchar) + '/' + 
																	  CAST(DATEPART(day,@pdtFechaAniversario) as varchar) AS datetime) 

	/*Si la fecha de aniversario está dentro del rango significa que es el primer año por lo que no es aniversario*/
	If ( @pdtFechaInicial <= @pdtFechaAniversario ) AND ( @pdtFechaAniversario <= @pdtFechaFinal )
		return 0
    	/*Si la fecha aniversario es mayor a la fecha final no aplica*/
	else if DATEPART(YEAR, @pdtFechaAniversario ) > DATEPART(YEAR, @pdtFechaFinal )
		return 0
	else
		begin
			If ( @pdtFechaInicial <= @ldtFechaAnivActual ) AND ( @ldtFechaAnivActual <= @pdtFechaFinal )
				return 1
			else
				return 0
		end
	return 0
end;


CREATE FUNCTION $$COMPANIA$$.NOM_CFDI_EMP_XML (@EMPLEADO VARCHAR(20))
 RETURNS XML
 AS
 BEGIN
 DECLARE @XMLEMP XML
 SET @XMLEMP = (
  SELECT
  E.NOMBRE AS NOMBRE,
  ISNULL(E.NIT, 'CAMPO EN BLANCO') AS RFC
  FROM $$COMPANIA$$.EMPLEADO E 
  WHERE E.EMPLEADO = @EMPLEADO
  FOR XML RAW ('RECEPTOR'), ELEMENTS)
 RETURN @XMLEMP
 END;
 


CREATE FUNCTION $$COMPANIA$$.NOM_CFDI_NOM_XML (@NOMINA VARCHAR(4))
 RETURNS XML
 AS
 BEGIN
 DECLARE @XMLNOM XML
 SET @XMLNOM = (
  SELECT
  N.NOMINA AS NOMINA,
  N.MONEDA AS MONEDA,
  ISNULL(N.NUMSERIE, 'CAMPO EN BLANCO') AS NUMERO_SERIE
  FROM $$COMPANIA$$.NOMINA N 
  WHERE N.NOMINA = @NOMINA
  FOR XML RAW ('NOMINA'), ELEMENTS)
 RETURN @XMLNOM
 END;
 
 
 
 CREATE FUNCTION $$COMPANIA$$.NOM_CFDI_MONHIST_XML (@NOMINA VARCHAR(4))
 RETURNS XML
 AS
 BEGIN
 DECLARE @XMLMH XML
 SET @XMLMH = (
  SELECT
  MH.MONEDA AS MONEDA,
  MH.MONTO AS MONTO
  FROM $$COMPANIA$$.MONEDA_HIST MH 
  INNER JOIN $$COMPANIA$$.NOMINA N
  ON MH.MONEDA = N.MONEDA
  WHERE N.NOMINA = @NOMINA
  FOR XML RAW ('MONEDA_HISTORICO'), ELEMENTS)
 RETURN @XMLMH
 END;
 
 
 
 CREATE FUNCTION $$COMPANIA$$.NOMINA_CFDI_XML (@NOMINA   VARCHAR(4), 
	@EMPLEADO VARCHAR(20)) 
RETURNS XML 
AS 
  BEGIN 
      RETURN 
        (SELECT $$COMPANIA$$.NOM_CFDI_EMP_XML (@EMPLEADO), 
                $$COMPANIA$$.NOM_CFDI_NOM_XML (@NOMINA), 
                $$COMPANIA$$.NOM_CFDI_MONHIST_XML (@NOMINA) 
         FOR XML RAW('DOCUMENTO')) 
  END;


CREATE FUNCTION $$COMPANIA$$.COMPANIA_XML (@compania VARCHAR(10))
 RETURNS XML 
 AS
 BEGIN
 
 DECLARE @XMLCOMPANIA XML
 SET @XMLCOMPANIA = (
  SELECT con.CONJUNTO, con.NIT, con.NOMBRE, con.UBICACION, con.DIREC1, con.DIREC2, con.DIREC3, con.COD_POSTAL, con.TELEFONO, con.EMAIL_DOC_ELECTRONICO, 
      con.PAIS, con.GLN, nit.RAZON_SOCIAL, nit.ALIAS, glo.IMPUESTO1_DESC, glo.IMPUESTO2_DESC, ISNULL(con.DIRECCION_PAG_WEB,'CAMPO EN BLANCO') DIRECCION_PAG_WEB,
      (SELECT ISNULL(SUBSTRING(valor,0,11),'0000-00-00') + 'T00:00:00' FROM $$COMPANIA$$.GLOBALES WHERE MODULO = 'AS' AND nombre = 'EDI_FRESOLUCION') FECHA_RESOLUCION_CR,
      (SELECT valor FROM $$COMPANIA$$.GLOBALES WHERE MODULO = 'AS' AND nombre = 'EDI_NRESOLUCION') NUMERO_RESOLUCION_CR,
      gf.COND_PAGO_CONTAD,
      gf.PRECIOS_DEC    
  FROM ERPADMIN.CONJUNTO con, $$COMPANIA$$.NIT nit, $$COMPANIA$$.GLOBALES_AS glo, $$COMPANIA$$.GLOBALES_FA gf
   WHERE con.CONJUNTO = @compania AND nit.NIT = con.NIT
  FOR XML RAW ('COMPANIA'), ELEMENTS)
 RETURN @XMLCOMPANIA
 END;


CREATE VIEW $$COMPANIA$$.V_DEDUCCIONES_NOMINA AS
SELECT	$$COMPANIA$$.EMPLEADO_CONC_NOMI.EMPLEADO, 
	$$COMPANIA$$.EMPLEADO_CONC_NOMI.CONCEPTO, 
	$$COMPANIA$$.CONCEPTO.DESCRIPCION, 
	$$COMPANIA$$.CONCEPTO.TIPO_CONCEPTO, 
	$$COMPANIA$$.EMPLEADO_CONC_NOMI.NOMINA,
	$$COMPANIA$$.EMPLEADO_CONC_NOMI.NUMERO_NOMINA, 
	$$COMPANIA$$.EMPLEADO_CONC_NOMI.TOTAL
FROM	$$COMPANIA$$.EMPLEADO_CONC_NOMI INNER JOIN
	$$COMPANIA$$.CONCEPTO 
ON 	$$COMPANIA$$.EMPLEADO_CONC_NOMI.CONCEPTO = $$COMPANIA$$.CONCEPTO.CONCEPTO
WHERE	($$COMPANIA$$.CONCEPTO.TIPO_CONCEPTO LIKE 'D') 
AND 	($$COMPANIA$$.EMPLEADO_CONC_NOMI.TOTAL <> 0);


CREATE VIEW $$COMPANIA$$.V_HORASNOMINA AS
SELECT	$$COMPANIA$$.EMPLEADO_CONC_NOMI.EMPLEADO, 
	$$COMPANIA$$.EMPLEADO_CONC_NOMI.CONCEPTO, 
	$$COMPANIA$$.CONCEPTO.DESCRIPCION, 
	$$COMPANIA$$.EMPLEADO_CONC_NOMI.NOMINA, 
	$$COMPANIA$$.EMPLEADO_CONC_NOMI.NUMERO_NOMINA, 
	$$COMPANIA$$.EMPLEADO_CONC_NOMI.TOTAL
FROM	$$COMPANIA$$.EMPLEADO_CONC_NOMI 
LEFT OUTER JOIN	$$COMPANIA$$.CONCEPTO 
ON 	$$COMPANIA$$.EMPLEADO_CONC_NOMI.CONCEPTO = $$COMPANIA$$.CONCEPTO.CONCEPTO
WHERE	($$COMPANIA$$.EMPLEADO_CONC_NOMI.CONCEPTO = 'S004') 
AND	($$COMPANIA$$.EMPLEADO_CONC_NOMI.TOTAL > 0) 
OR	($$COMPANIA$$.EMPLEADO_CONC_NOMI.CONCEPTO = 'S020') 
OR	($$COMPANIA$$.EMPLEADO_CONC_NOMI.CONCEPTO = 'S021') 
OR	($$COMPANIA$$.EMPLEADO_CONC_NOMI.CONCEPTO = 'S022') 
OR	($$COMPANIA$$.EMPLEADO_CONC_NOMI.CONCEPTO = 'S023') 
OR	($$COMPANIA$$.EMPLEADO_CONC_NOMI.CONCEPTO = 'S024') 
OR	($$COMPANIA$$.EMPLEADO_CONC_NOMI.CONCEPTO = 'S025') 
OR	($$COMPANIA$$.EMPLEADO_CONC_NOMI.CONCEPTO = 'S026') 
OR	($$COMPANIA$$.EMPLEADO_CONC_NOMI.CONCEPTO = 'S027') 
OR	($$COMPANIA$$.EMPLEADO_CONC_NOMI.CONCEPTO = 'S028');

CREATE VIEW $$COMPANIA$$.V_LIBROVACACION AS
SELECT	EMPLEADO, 
	NOMBRE, 
	ESTADO_EMPLEADO, 
	ACTIVO, 
	FECHA_INGRESO, 
	DEPARTAMENTO, 
	PUESTO, 
	CENTRO_COSTO, 
	NIT, 
	VACS_PENDIENTES, 
	VACS_ULT_CALCULO, 
	SALARIO_REFERENCIA
FROM	$$COMPANIA$$.EMPLEADO;


CREATE VIEW $$COMPANIA$$.V_ULTIMASVAC AS
SELECT	EMPLEADO, MAX(FECHA) AS FECHA, TIPO_ACCION, TIPO_AUSENCIA
FROM	$$COMPANIA$$.EMPLEADO_ACC_PER
GROUP BY 	EMPLEADO, TIPO_ACCION, TIPO_AUSENCIA
HAVING	(TIPO_ACCION = 'VACG') ;


CREATE VIEW $$COMPANIA$$.V_ULTIMASVACDI AS
SELECT	EMPLEADO, 
	MAX(FECHA) AS FECHA, 
	TIPO_ACCION, 
	TIPO_AUSENCIA
FROM	$$COMPANIA$$.EMPLEADO_ACC_PER
GROUP BY	EMPLEADO, TIPO_ACCION, TIPO_AUSENCIA
HAVING	(TIPO_ACCION = 'VACD');

CREATE VIEW $$COMPANIA$$.V_VACACIONES AS
SELECT        $$COMPANIA$$.V_ULTIMASVAC.EMPLEADO, 
	$$COMPANIA$$.EMPLEADO.ESTADO_EMPLEADO, 
	$$COMPANIA$$.EMPLEADO.FECHA_INGRESO, 
	$$COMPANIA$$.EMPLEADO.VACS_PENDIENTES, 
	$$COMPANIA$$.EMPLEADO_CONC_NOMI.NOMINA, 
	$$COMPANIA$$.EMPLEADO_CONC_NOMI.NUMERO_NOMINA, 
	$$COMPANIA$$.EMPLEADO_CONC_NOMI.CONCEPTO, 
	$$COMPANIA$$.EMPLEADO_CONC_NOMI.TOTAL, 
	$$COMPANIA$$.EMPLEADO_ACC_PER.FECHA, 
	$$COMPANIA$$.EMPLEADO_ACC_PER.FECHA_RIGE, 
	$$COMPANIA$$.EMPLEADO_ACC_PER.FECHA_VENCE, 
	$$COMPANIA$$.EMPLEADO_ACC_PER.DIAS_ACCION
FROM	$$COMPANIA$$.EMPLEADO 
INNER JOIN	$$COMPANIA$$.EMPLEADO_ACC_PER 
ON	$$COMPANIA$$.EMPLEADO.EMPLEADO = $$COMPANIA$$.EMPLEADO_ACC_PER.EMPLEADO 
RIGHT OUTER JOIN	$$COMPANIA$$.V_ULTIMASVAC 
ON 	$$COMPANIA$$.EMPLEADO_ACC_PER.EMPLEADO = $$COMPANIA$$.V_ULTIMASVAC.EMPLEADO 
AND 	$$COMPANIA$$.EMPLEADO_ACC_PER.FECHA = $$COMPANIA$$.V_ULTIMASVAC.FECHA 
AND	$$COMPANIA$$.EMPLEADO_ACC_PER.TIPO_ACCION = $$COMPANIA$$.V_ULTIMASVAC.TIPO_ACCION 
RIGHT OUTER JOIN	$$COMPANIA$$.EMPLEADO_CONC_NOMI 
ON 	$$COMPANIA$$.EMPLEADO.EMPLEADO = $$COMPANIA$$.EMPLEADO_CONC_NOMI.EMPLEADO;


CREATE PROCEDURE $$COMPANIA$$.AcumuladoConceptos
(@EMPLEADO AS VARCHAR(100), @FECHAINICIAL AS DATETIME, @FECHAFINAL AS DATETIME, @FECHAMIN AS DATETIME, @CONCEPTOS AS VARCHAR(MAX), @LIQUIDACION AS VARCHAR(MAX),  @VALOR AS DECIMAL(28,8) OUTPUT ) 
/*RETURNS DECIMAL(28,8)*/
AS 
BEGIN
DECLARE @SQL NVARCHAR(MAX)
DECLARE @VALUE DECIMAL(28,8)
DECLARE @VAL DECIMAL(28,8)
DECLARE @VALUE2 DECIMAL(28,8)
DECLARE @VAL2 DECIMAL(28,8)

IF @LIQUIDACION = 'N'
BEGIN
SET @SQL = 'DECLARE @MONTO AS DECIMAL(28,8) '

  SET @SQL = @SQL + ' SELECT @MONTO = SUM(ecn.total)
FROM $$COMPANIA$$.empleado_conc_nomi ecn,$$COMPANIA$$.concepto c,$$COMPANIA$$.nomina_historico nh
WHERE ecn.concepto = c.concepto
      AND ecn.nomina =  nh.nomina
      AND ecn.numero_nomina = nh.numero_nomina
      AND ecn.empleado = ''' + @EMPLEADO +  '''
      AND nh.periodo >=  ''' + CONVERT(NVARCHAR(75),@FECHAINICIAL, 111) + '''
      AND nh.periodo <= DATEADD(MS, -1, DATEADD(D, 1, CONVERT(DATETIME2, ''' + CONVERT(NVARCHAR(75),@FECHAFINAL, 111) + ''' )) )
      AND nh.fecha_aprobacion <> ''' + CONVERT(NVARCHAR(75),@FECHAMIN, 111) + '''
      AND nh.fecha_aplicacion IS NOT NULL AND c.concepto IN (' + @CONCEPTOS +
	  ' ) AND  ( c.concepto  = c.concepto   ) '
     
	 SET @SQL = @SQL + ' SELECT @VALUE = ISNULL(@MONTO,0) '

	 EXECUTE SP_EXECUTESQL @SQL, N'@VALUE DECIMAL(28,8) OUTPUT', @VALUE = @VAL OUTPUT
	 SET @VALOR = @VAL
	 END
IF @LIQUIDACION = 'S'
BEGIN
SET @SQL = 'DECLARE @MONTO AS DECIMAL(28,8) '

  SET @SQL = @SQL + ' SELECT @MONTO = SUM(ecn.total)
FROM $$COMPANIA$$.empleado_conc_nomi ecn,$$COMPANIA$$.concepto c,$$COMPANIA$$.nomina_historico nh
WHERE ecn.concepto = c.concepto
      AND ecn.nomina =  nh.nomina
      AND ecn.numero_nomina = nh.numero_nomina
      AND ecn.empleado = ''' + @EMPLEADO +  '''
      AND nh.periodo >=  ''' + CONVERT(NVARCHAR(75),@FECHAINICIAL, 111) + '''
      AND nh.periodo <= DATEADD(MS, -1, DATEADD(D, 1, CONVERT(DATETIME2, ''' + CONVERT(NVARCHAR(75),@FECHAFINAL, 111) + ''' )) )
      AND nh.fecha_aprobacion <> ''' + CONVERT(NVARCHAR(75),@FECHAMIN, 111) + '''
      AND nh.fecha_aplicacion IS NOT NULL AND c.concepto IN (' + @CONCEPTOS +
	  ' ) AND  ( c.concepto  = c.concepto   ) '
     
	 SET @SQL = @SQL + ' SELECT @VALUE = ISNULL(@MONTO,0) '

	 EXECUTE SP_EXECUTESQL @SQL, N'@VALUE DECIMAL(28,8) OUTPUT', @VALUE = @VAL OUTPUT
	 /*SET @VALOR = @VAL*/

  SET @SQL = 'DECLARE @MONTOLIQ AS DECIMAL(28,8) '
  SET @SQL = @SQL + ' SELECT @MONTOLIQ = SUM( lc.total_calculado )
 FROM $$COMPANIA$$.empleado e,$$COMPANIA$$.liquidacion l,$$COMPANIA$$.concepto c,$$COMPANIA$$.liquidacion_concep lc
WHERE e.empleado = ''' + @EMPLEADO +  '''
	  AND e.empleado = l.empleado
      AND l.liquidacion = lc.liquidacion
      AND lc.concepto = c.concepto
	  AND ( l.estado_liquidac = ''L'' OR l.estado_liquidac = ''G'' )
      AND l.fecha_retiro_pago >=  ''' + CONVERT(NVARCHAR(75),@FECHAINICIAL, 111) + '''
      AND l.fecha_retiro_pago <= DATEADD(MS, -1, DATEADD(D, 1, CONVERT(DATETIME2, ''' + CONVERT(NVARCHAR(75),@FECHAFINAL, 111) + ''' )) )
      AND c.concepto IN (' + @CONCEPTOS +
	  ' ) AND  ( c.concepto  = c.concepto   ) '

	  SET @SQL = @SQL + ' SELECT @VALUE2 = ISNULL(@MONTOLIQ,0) '

	 EXECUTE SP_EXECUTESQL @SQL, N'@VALUE2 DECIMAL(28,8) OUTPUT', @VALUE2 = @VAL2 OUTPUT
	 SET @VALOR = @VAL + @VAL2
	 END

	 END;


CREATE PROCEDURE $$COMPANIA$$.ConsultaCNME
 (
   @FECHAINICIAL as DATETIME,
   @FECHAFINAL as DATETIME,
   @FECHAMIN AS DATETIME,
   @INGRESOSBRUTOS AS VARCHAR(MAX),
   @DEDUCCIONESBRUTOS AS VARCHAR(MAX),
   @CESANTIAS AS VARCHAR(MAX),
   @GASTOSREP AS VARCHAR(MAX),
   @JUBILACION AS VARCHAR(MAX),
   @OTROSINGRESOS AS VARCHAR(MAX),
   @TOTALBRUTOS AS VARCHAR(MAX),
   @OBLSALUD AS VARCHAR(MAX),
   @OBLPENSION AS VARCHAR(MAX),
   @VOLPENSION AS VARCHAR(MAX),
   @RETENCION AS VARCHAR(MAX),
   @USUARIO AS VARCHAR(MAX),
   @EMPLEADOLIKE AS NVARCHAR(MAX),
   @NOMINALIKE AS NVARCHAR(MAX),
   @CENTROCOSTOLIKE AS NVARCHAR(MAX),
   @DEPARTAMENTOLIKE AS NVARCHAR(MAX),
   @ESTADOLIKE AS NVARCHAR(MAX),
   @UBICACIONLIKE AS NVARCHAR(MAX),
   @FECHAINGRESOINICIAL AS DATETIME,
   @FECHAINGRESOFINAL AS DATETIME,
   @FECHASALIDAINICIAL AS DATETIME,
   @FECHASALIDAFINAL AS DATETIME,
   @EMPPOSTERIORES AS NVARCHAR(MAX),
   @LIQUIDACIONES AS NVARCHAR(MAX)
   )
 /*RETURNS DECIMAL(28,8)*/
 AS 
 BEGIN
 
 DECLARE @TIPO_DOCUMENTO varchar(max), 
     @NIT varchar(max), 
 	@PRIMER_APELLIDO varchar(max), 
 	@SEGUNDO_APELLIDO varchar(max), 
 	@PRIMER_NOMBRE varchar(max),  
     @SEGUNDO_NOMBRE varchar(max), 
 	@DIRECCION varchar(max), 
 	@DEPARTAMENTO varchar(max), 
 	@MUNICIPIO varchar(max), 
 	@PAIS varchar(max), 
 	@CORREO varchar(max), 
     @FECHAINICIALT datetime, 
 	@FECHAFINALT datetime, 
 	@FECHAEXP datetime, 
 	@DEPTORET varchar(max), 
 	@MUNRET varchar(max), 
 	@ENTIDADES int, 
 	@INGRESOSSALARIALES decimal(28,8),
 	@DEDUCCIONESSALARIALES decimal(28,8),
 	@CESANTIAST decimal(28,8), 
 	@GASTOSREPT decimal(28,8), 
 	@JUBILACIONT decimal(28,8), 
 	@OTROSINGRESOST decimal(28,8), 
 	@TOTALBRUTOST decimal(28,8),
 	@OBLSALUDT decimal(28,8), 
 	@OBLPENSIONT decimal(28,8), 
 	@VOLPENSIONT decimal(28,8), 
 	@RETENCIONT decimal(28,8),
 	@EMPLEADO AS VARCHAR(100),
 	@VALOR AS DECIMAL(28,8),
 	@SQL AS NVARCHAR(MAX),
 	@TABLA AS NVARCHAR(MAX),
 	@BLANCO AS NVARCHAR(MAX)
 
 	SET @BLANCO = ''''''
 	SET @TABLA = 'TEMP' + @USUARIO
 
 SET @SQL = '
 create table ' + @TABLA + '
 (
 	TIPO_DOCUMENTO varchar(max), 
 	NIT varchar(max), 
 	PRIMER_APELLIDO varchar(max), 
 	SEGUNDO_APELLIDO varchar(max), 
 	PRIMER_NOMBRE varchar(max),  
     SEGUNDO_NOMBRE varchar(max),  
     FECHAINICIAL datetime, 
 	FECHAFINAL datetime, 
 	FECHAEXP datetime, 
 	DEPTORET varchar(max), 
 	MUNRET varchar(max), 
 	ENTIDADES int, 
 	INGRESOSSALARIALES decimal(28,8),
 	DEDUCCIONESSALARIALES decimal(28,8),
 	CENSATIAS decimal(28,8), 
 	GASTOSREP decimal(28,8), 
 	JUBILACION decimal(28,8), 
 	OTROSINGRESOS decimal(28,8), 
 	TOTALBRUTOS decimal(28,8),
 	OBLSALUD decimal(28,8), 
 	OBLPENSION decimal(28,8), 
 	VOLPENSION decimal(28,8), 
 	RETENCION decimal(28,8)
 ) '
 
 EXEC SP_EXECUTESQL @SQL
 SET @SQL = ''
 
 SET @SQL = 'DECLARE CNME CURSOR FOR '
 SET @SQL = @SQL + 'SELECT  i.TIPO_DOCUMENTO, i.NIT, i.PRIMER_APELLIDO, i.SEGUNDO_APELLIDO, i.PRIMER_NOMBRE,  
         i.SEGUNDO_NOMBRE,
 		ERPADMIN.SF_GETDATE() FECHAINICIAL, ERPADMIN.SF_GETDATE() FECHAFINAL, ERPADMIN.SF_GETDATE() FECHAEXP, '''' DEPTORET, '''' MUNRET, 0 ENTIDADES,
 		0 INGRESOSSALARIALES,
 		0 DEDUCCIONESSALARIALES,
 		0 CENSATIAS, 
 		0 GASTOSREP, 
 		0 JUBILACION, 
 		0 OTROSINGRESOS, 
 		0 TOTALBRUTOS,
 		0 OBLSALUD, 
 		0 OBLPENSION, 
 		0 VOLPENSION, 
 		0 RETENCION,
 		e.EMPLEADO
                             FROM 	$$COMPANIA$$.empleado e left join $$COMPANIA$$.NIT i ON e.NIT = i.NIT '
 							SET @SQL = @SQL + ' WHERE	( ( e.fecha_salida = CONVERT(DATETIME,''' + CONVERT(NVARCHAR,@FECHAMIN) + ''', 111) ) OR (e.fecha_salida IS NULL ) OR  
                             	( e.fecha_salida >= CONVERT(DATETIME,''' + CONVERT(NVARCHAR,@FECHAINICIAL) + ''', 111) )) '
 
 							/*DATEADD(MS, -1, DATEADD(D, 1, CONVERT(DATETIME2, @d)))*/
 
 							IF(@EMPPOSTERIORES = 'S')
 							SET @SQL = @SQL + ' AND	e.fecha_ingreso <= DATEADD(MS, -1, DATEADD(D, 1, CONVERT(DATETIME2,''' +  CONVERT(NVARCHAR,@FECHAFINAL) + ''')) ) '
 							IF (@EMPLEADOLIKE IS NOT NULL) AND (@EMPLEADOLIKE != @BLANCO)
 							SET @SQL = @SQL + ' AND (E.EMPLEADO IN ( ' + @EMPLEADOLIKE + ' ) ) '	
 							IF (@NOMINALIKE IS NOT NULL) AND (@NOMINALIKE != @BLANCO)
 							SET @SQL = @SQL + ' AND (E.NOMINA IN ( ' + @NOMINALIKE + ' ) ) '
 							IF (@CENTROCOSTOLIKE IS NOT NULL) AND (@CENTROCOSTOLIKE != @BLANCO)
 							SET @SQL = @SQL + ' AND (E.CENTRO_COSTO IN ( ' + @CENTROCOSTOLIKE + ' ) ) '
 							IF (@DEPARTAMENTOLIKE IS NOT NULL) AND (@DEPARTAMENTOLIKE != @BLANCO)
 							SET @SQL = @SQL + ' AND (E.DEPARTAMENTO IN ( ' + @DEPARTAMENTOLIKE + ' ) ) '
 							IF (@ESTADOLIKE IS NOT NULL) AND (@ESTADOLIKE != @BLANCO)
 							SET @SQL = @SQL + ' AND (E.ESTADO_EMPLEADO IN ( ' + @ESTADOLIKE + ') ) '
 							IF (@UBICACIONLIKE IS NOT NULL) AND (@UBICACIONLIKE != @BLANCO)
 							SET @SQL = @SQL + ' AND (E.UBICACION IN ( ' + @UBICACIONLIKE + ') ) '
 							IF (@FECHAINGRESOINICIAL IS NOT NULL) AND (@FECHAINGRESOINICIAL != '1980-01-01 00:00:00.000')
 							SET @SQL = @SQL + ' AND e.fecha_ingreso >= CONVERT(DATETIME,''' + CONVERT(NVARCHAR,@FECHAINGRESOINICIAL) + ''', 111) '
 							IF (@FECHAINGRESOFINAL IS NOT NULL) AND (@FECHAINGRESOFINAL != '1980-01-01 00:00:00.000')
 							SET @SQL = @SQL + ' AND e.fecha_ingreso <= CONVERT(DATETIME,''' + CONVERT(NVARCHAR,@FECHAINGRESOFINAL) + ''', 111) '
 							IF (@FECHASALIDAINICIAL IS NOT NULL) AND (@FECHASALIDAINICIAL != '1980-01-01 00:00:00.000')
 							SET @SQL = @SQL + ' AND e.fecha_salida >= CONVERT(DATETIME,''' + CONVERT(NVARCHAR,@FECHASALIDAINICIAL) + ''', 111) '
 							IF (@FECHASALIDAFINAL IS NOT NULL) AND (@FECHASALIDAFINAL != '1980-01-01 00:00:00.000')
 							SET @SQL = @SQL + ' AND e.fecha_salida >= CONVERT(DATETIME,''' + CONVERT(NVARCHAR,@FECHASALIDAFINAL) + ''', 111) '
 
 
 							 
 							SET @SQL = @SQL + ' group by  i.TIPO_DOCUMENTO, i.Nit,   
                                i.PRIMER_APELLIDO, i.SEGUNDO_APELLIDO, i.PRIMER_NOMBRE, i.SEGUNDO_NOMBRE,   
                                e.EMPLEADO '
 
 EXEC SP_EXECUTESQL @SQL
 SET @SQL = ''
 
 OPEN CNME
 FETCH NEXT FROM CNME INTO @TIPO_DOCUMENTO ,@NIT , @PRIMER_APELLIDO , @SEGUNDO_APELLIDO, 
 	@PRIMER_NOMBRE  ,   @SEGUNDO_NOMBRE /*,@DIRECCION  ,@DEPARTAMENTO  ,@MUNICIPIO ,
 	@PAIS ,@CORREO */ ,@FECHAINICIALT  ,@FECHAFINALT,  @FECHAEXP , @DEPTORET , 
 	@MUNRET , @ENTIDADES,  
 	@INGRESOSSALARIALES ,@DEDUCCIONESSALARIALES ,@CESANTIAST , @GASTOSREPT , @JUBILACIONT , @OTROSINGRESOST , 
 	@TOTALBRUTOST ,@OBLSALUDT , @OBLPENSIONT , @VOLPENSIONT , @RETENCIONT, @EMPLEADO 
 
 while @@FETCH_STATUS = 0
 begin
 
 /*INGRESOS SALARIALES*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @INGRESOSBRUTOS, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @INGRESOSSALARIALES = @VALOR
 /*DEDUCCIONES SALARIALES*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @DEDUCCIONESBRUTOS, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @DEDUCCIONESSALARIALES = @VALOR
 SET @INGRESOSSALARIALES = ( @INGRESOSSALARIALES - @DEDUCCIONESSALARIALES)
 /*CESANTIAS*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @CESANTIAS, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @CESANTIAST = @VALOR
 /*GASTOSREP*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @GASTOSREP, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @GASTOSREPT = @VALOR
 /*JUBILACION*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @JUBILACION, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @JUBILACIONT = @VALOR
 /*OTROSINGRESOS*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @OTROSINGRESOS, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @OTROSINGRESOST = @VALOR
 /*TOTALBRUTOS*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @TOTALBRUTOS, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @TOTALBRUTOST = @VALOR
 /*OBLSALUD*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @OBLSALUD, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @OBLSALUDT = @VALOR
 /*OBLPENSION*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @OBLPENSION, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @OBLPENSIONT = @VALOR
 /*VOLPENSION*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @VOLPENSION, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @VOLPENSIONT = @VALOR
 /*RETENCION*/
 EXEC $$COMPANIA$$.AcumuladoConceptos @EMPLEADO, @FECHAINICIAL, @FECHAFINAL, @FECHAMIN, @RETENCION, @LIQUIDACIONES, @VALOR OUTPUT 
 SET @RETENCIONT = @VALOR
 
 IF @TIPO_DOCUMENTO IS NULL
 SET @TIPO_DOCUMENTO = ''
 IF @NIT IS NULL
 SET @NIT = ''
 IF @PRIMER_APELLIDO IS NULL
 SET @PRIMER_APELLIDO = ''
 IF @SEGUNDO_APELLIDO IS NULL
 SET @SEGUNDO_APELLIDO = ''
 IF @PRIMER_NOMBRE IS NULL
 SET @PRIMER_NOMBRE = ''
 IF @SEGUNDO_NOMBRE IS NULL
 SET @SEGUNDO_NOMBRE = ''
 /*IF @DIRECCION IS NULL
 SET @DIRECCION = ''
 IF @DEPARTAMENTO IS NULL
 SET @DEPARTAMENTO = ''
 IF @MUNICIPIO IS NULL
 SET @MUNICIPIO = ''
 IF @PAIS IS NULL
 SET @PAIS = ''
 IF @CORREO IS NULL
 SET @CORREO = ''
 IF @DEPTORET IS NULL
 SET @DEPTORET = ''
 IF @MUNRET IS NULL
 SET @MUNRET = ''*/
 
 SET @SQL = ' insert into ' + @TABLA + '
 (
 	TIPO_DOCUMENTO, 
 	NIT, 
 	PRIMER_APELLIDO, 
 	SEGUNDO_APELLIDO, 
 	PRIMER_NOMBRE,  
     SEGUNDO_NOMBRE, 
     FECHAINICIAL, 
 	FECHAFINAL , 
 	FECHAEXP , 
 	DEPTORET, 
 	MUNRET , 
 	ENTIDADES, 
 	INGRESOSSALARIALES,
 	DEDUCCIONESSALARIALES,
 	CENSATIAS , 
 	GASTOSREP, 
 	JUBILACION, 
 	OTROSINGRESOS, 
 	TOTALBRUTOS,
 	OBLSALUD, 
 	OBLPENSION, 
 	VOLPENSION, 
 	RETENCION
 )
 VALUES
 ( ' + '''' + CONVERT(NVARCHAR,@TIPO_DOCUMENTO) + '''' + ','
 	+ '''' +CONVERT(NVARCHAR,@NIT)+ '''' + ','
 	+ '''' +CONVERT(NVARCHAR,@PRIMER_APELLIDO)+ '''' + ',' 
 	+ '''' +CONVERT(NVARCHAR,@SEGUNDO_APELLIDO)+ '''' + ',' 
 	+ '''' +CONVERT(NVARCHAR,@PRIMER_NOMBRE)+ '''' + ','   
 	+ '''' +CONVERT(NVARCHAR,@SEGUNDO_NOMBRE)+ '''' + ','
 	/*+ '''' +CONVERT(NVARCHAR,@DIRECCION)+ '''' + ','
 	+ '''' +CONVERT(NVARCHAR,@DEPARTAMENTO)+ '''' + ','
 	+ '''' +CONVERT(NVARCHAR,@MUNICIPIO) + '''' + ','
 	+ '''' +CONVERT(NVARCHAR,@PAIS)+ '''' + ','
 	+ '''' +CONVERT(NVARCHAR,@CORREO)+ '''' + ','*/
 	+ '''1980-01-01''' + ','
 	+ '''1980-01-01''' + ',' 
 	+ '''1980-01-01''' + ',' 
 	+ '''' +CONVERT(NVARCHAR,@DEPTORET)+ '''' + ','
 	+ '''' +CONVERT(NVARCHAR,@MUNRET)+ '''' + ',' 
 	+ CONVERT(NVARCHAR,@ENTIDADES) + ','  
 	+ CONVERT(NVARCHAR,@INGRESOSSALARIALES) + ','
 	+ CONVERT(NVARCHAR,@DEDUCCIONESSALARIALES) + ','
 	+ CONVERT(NVARCHAR,@CESANTIAST) + ',' 
 	+ CONVERT(NVARCHAR,@GASTOSREPT) + ',' 
 	+ CONVERT(NVARCHAR,@JUBILACIONT) + ',' 
 	+ CONVERT(NVARCHAR,@OTROSINGRESOST) + ',' 
 	+ CONVERT(NVARCHAR,@TOTALBRUTOST) + ','
 	+ CONVERT(NVARCHAR,@OBLSALUDT) + ',' 
 	+ CONVERT(NVARCHAR,@OBLPENSIONT) + ',' 
 	+ CONVERT(NVARCHAR,@VOLPENSIONT) + ',' 
 	+ CONVERT(NVARCHAR,@RETENCIONT) + '		
 ) '
 
 EXEC SP_EXECUTESQL @SQL
 
 fetch next from CNME into @TIPO_DOCUMENTO ,@NIT , @PRIMER_APELLIDO , @SEGUNDO_APELLIDO, 
 	@PRIMER_NOMBRE  ,   @SEGUNDO_NOMBRE /*,@DIRECCION  ,@DEPARTAMENTO  ,@MUNICIPIO ,
 	@PAIS ,@CORREO */ ,@FECHAINICIALT  ,@FECHAFINALT,  @FECHAEXP , @DEPTORET , 
 	@MUNRET , @ENTIDADES,  
 	@INGRESOSSALARIALES ,@DEDUCCIONESSALARIALES ,@CESANTIAST , @GASTOSREPT , @JUBILACIONT , @OTROSINGRESOST , 
 	@TOTALBRUTOST ,@OBLSALUDT , @OBLPENSIONT , @VOLPENSIONT , @RETENCIONT, @EMPLEADO		
 END
 CLOSE CNME
 DEALLOCATE CNME
END;

CREATE PROCEDURE $$COMPANIA$$.ReporteValesDespensa
(@CptValesDespensa VARCHAR(MAX),
@CodigoNominaIni VARCHAR(4),
@CodigoNominaFin VARCHAR(4),
@NumeroNominaIni INT,
@NumeroNominaFin INT, 
@FechaDesde DATETIME, 
@FechaHasta DATETIME, 
@NumeroTarjeta VARCHAR(MAX)
)
AS

BEGIN

	DECLARE @sqlConsulta varchar(MAX)
	DECLARE @strSQLWhereQuery varchar(MAX)
	DECLARE @strSQLGroupQuery VARCHAR(MAX)


	set @sqlConsulta = '
	SELECT	empleado.empleado, empleado_nomi_neto.nomina, empleado_nomi_neto.numero_nomina, nomina_historico.fecha_pago, nomina_historico.numero_nomina, 
			nomina.descripcion, empleado_conc_nomi.concepto, empleado_conc_nomi.total, empleado_nomi_neto.empleado, empleado.nombre, 
			CASE ''' + @NumeroTarjeta + '''
				WHEN ''RUBRO6'' THEN empleado.rubro6 WHEN ''RUBRO7'' THEN empleado.rubro7 WHEN ''RUBRO8'' THEN empleado.rubro8
				WHEN ''RUBRO9'' THEN empleado.rubro9 WHEN ''RUBRO10'' THEN empleado.rubro10 WHEN ''RUBRO11'' THEN empleado.rubro11
				WHEN ''RUBRO12'' THEN empleado.rubro12 WHEN ''RUBRO13'' THEN empleado.rubro13 WHEN ''RUBRO14'' THEN empleado.rubro14
				WHEN ''RUBRO15'' THEN empleado.rubro15 WHEN ''RUBRO16'' THEN empleado.rubro16 WHEN ''RUBRO17'' THEN empleado.rubro17
				WHEN ''RUBRO18'' THEN empleado.rubro18 WHEN ''RUBRO19'' THEN empleado.rubro19 WHEN ''RUBRO20'' THEN empleado.rubro20
				WHEN ''RUBRO21'' THEN empleado.rubro21 WHEN ''RUBRO22'' THEN empleado.rubro22 WHEN ''RUBRO23'' THEN empleado.rubro23
				WHEN ''RUBRO24'' THEN empleado.rubro24 WHEN ''RUBRO25'' THEN empleado.rubro25 
				ELSE (SELECT adic.VALOR FROM $$COMPANIA$$.adicionalempleado Adic WHERE adic.EMPLEADO = empleado.empleado AND adic.ADICIONAL = ''' + @NumeroTarjeta + ''')
			END NumeroTarjeta
	FROM   $$COMPANIA$$.empleado_nomi_neto EMPLEADO_NOMI_NETO 
          INNER JOIN $$COMPANIA$$.empleado EMPLEADO 
                  ON empleado_nomi_neto.empleado = empleado.empleado
         INNER JOIN $$COMPANIA$$.nomina_historico NOMINA_HISTORICO 
                 ON  empleado_nomi_neto.nomina = nomina_historico.nomina  
                    AND  empleado_nomi_neto.numero_nomina = nomina_historico.numero_nomina 
        INNER JOIN $$COMPANIA$$.nomina NOMINA 
                ON empleado_nomi_neto.nomina = nomina.nomina
       INNER JOIN $$COMPANIA$$.empleado_conc_nomi EMPLEADO_CONC_NOMI 
               ON  empleado_nomi_neto.empleado = empleado_conc_nomi.empleado 
			   AND empleado_conc_nomi.total > 0 
			   AND empleado_conc_nomi.concepto IN(''' + @CptValesDespensa + ''')
       AND  empleado_nomi_neto.nomina = empleado_conc_nomi.nomina 
                  AND  empleado_nomi_neto.numero_nomina = empleado_conc_nomi.numero_nomina '
					    

	IF @CodigoNominaIni != '' OR @CodigoNominaFin != ''
	BEGIN
		IF @CodigoNominaIni != ''AND @CodigoNominaFin != ''
		BEGIN
			SET @strSQLWhereQuery = ' WHERE empleado_nomi_neto.NOMINA BETWEEN ''' + @CodigoNominaIni + ''' AND ''' + @CodigoNominaFin + ''''
		END

		IF @CodigoNominaIni != '' AND @CodigoNominaFin = ''
		BEGIN
			SET @strSQLWhereQuery = ' WHERE empleado_nomi_neto.NOMINA >= ''' + @CodigoNominaIni + ''''
		END

		IF @CodigoNominaIni = '' AND @CodigoNominaFin != ''
		BEGIN
			SET @strSQLWhereQuery = ' WHERE empleado_nomi_neto.NOMINA <= ''' + @CodigoNominaFin + ''''
		END
	END

	IF @NumeroNominaIni != '' OR @NumeroNominaFin != ''
	BEGIN
		IF @NumeroNominaIni != '' AND @NumeroNominaFin != ''
		BEGIN
			IF @strSQLWhereQuery = '' OR @strSQLWhereQuery IS NULL
				SET @strSQLWhereQuery = ' WHERE empleado_nomi_neto.NUMERO_NOMINA BETWEEN ' + CAST(@NumeroNominaIni AS VARCHAR) + ' AND ' + CAST(@NumeroNominaFin AS VARCHAR)
			ELSE
				SET @strSQLWhereQuery = @strSQLWhereQuery + ' AND empleado_nomi_neto.NUMERO_NOMINA BETWEEN ' + CAST(@NumeroNominaIni AS VARCHAR) + ' AND ' + CAST(@NumeroNominaFin AS VARCHAR)
		END

		IF @NumeroNominaIni != '' AND @NumeroNominaFin = ''
		BEGIN
			IF @strSQLWhereQuery = '' OR @strSQLWhereQuery IS NULL
				SET @strSQLWhereQuery = ' WHERE empleado_nomi_neto.NUMERO_NOMINA >= ' + CAST(@NumeroNominaIni AS VARCHAR)
			ELSE
				SET @strSQLWhereQuery = @strSQLWhereQuery + ' AND empleado_nomi_neto.NUMERO_NOMINA >= ' + CAST(@NumeroNominaIni AS VARCHAR)
			
		END

		IF @NumeroNominaIni = '' AND @NumeroNominaFin != ''
		BEGIN
			IF @strSQLWhereQuery = '' OR @strSQLWhereQuery IS NULL
				SET @strSQLWhereQuery = ' WHERE empleado_nomi_neto.NUMERO_NOMINA <= ' + CAST(@NumeroNominaFin AS VARCHAR)
			ELSE
				SET @strSQLWhereQuery = @strSQLWhereQuery + ' AND empleado_nomi_neto.NUMERO_NOMINA <= ' + CAST(@NumeroNominaFin AS VARCHAR)
		END
	END


	IF (@FechaDesde != '' AND @FechaDesde != '1800/01/01' AND @FechaDesde != '1900/01/01' ) OR (@FechaHasta != '' AND @FechaHasta != '1800/01/01' AND @FechaHasta != '1900/01/01')
	BEGIN
		
		IF @FechaDesde != '' AND @FechaDesde != '1800/01/01' AND @FechaDesde != '1900/01/01' 
		BEGIN
			IF @strSQLWhereQuery = '' OR @strSQLWhereQuery IS NULL
				SET @strSQLWhereQuery = ' WHERE NOMINA_HISTORICO.fecha_fin >= ''' + CONVERT(VARCHAR, @FechaDesde, 121) + ''''
			ELSE
				SET @strSQLWhereQuery = @strSQLWhereQuery + ' AND NOMINA_HISTORICO.fecha_fin >= ''' + CONVERT(VARCHAR, @FechaDesde, 121) + ''''
		END

		IF @FechaHasta != '' AND @FechaHasta != '1800/01/01' AND @FechaHasta != '1900/01/01'
		BEGIN
			IF @strSQLWhereQuery = '' OR @strSQLWhereQuery IS NULL
				SET @strSQLWhereQuery = ' WHERE NOMINA_HISTORICO.fecha_fin <= ''' + CONVERT(VARCHAR, @FechaHasta, 121) + ''''
			ELSE
				SET @strSQLWhereQuery = @strSQLWhereQuery + ' AND NOMINA_HISTORICO.fecha_fin <= ''' + CONVERT(VARCHAR, @FechaHasta, 121) + ''''
		END
	END

	SET @strSQLGroupQuery = ' ORDER  BY empleado.empleado '

	EXEC (@sqlConsulta + @strSQLWhereQuery + @strSQLGroupQuery)

END;

CREATE PROCEDURE $$COMPANIA$$.ReporteFondoAhorroPeriodo
( @CptDiasPagados VARCHAR(20) , 
@CptDiasRestados VARCHAR(20), 
@CptDelPatrono VARCHAR(MAX) , 
@CptDelEmpleado VARCHAR(MAX), 
@CodigoNominaIni VARCHAR(4) , 
@CodigoNominaFin VARCHAR(4), 
@NumeroNominaIni INT, 
@NumeroNominaFin INT, 
@FechaDesde DATETIME, 
@FechaHasta DATETIME, 
@EmpleadoIni VARCHAR(20), 
@EmpleadoFin VARCHAR(20))

AS
BEGIN

DECLARE @strSQLQuery VARCHAR(MAX)
DECLARE @strSQLWhereQuery VARCHAR(MAX)
DECLARE @strSQLGroupQuery VARCHAR(MAX)


SET @strSQLQuery = '
SELECT Totales.EMPLEADO, Totales.nombre, SUM( ISNULL(Totales.TotalEmpleado, 0)) TotalEmpleado, SUM(ISNULL( Totales.TotalPatrono, 0)) TotalPatrono,
	(SUM(ISNULL( Totales.TotalDiasPagados, 0)) -SUM( ISNULL( Totales.TotalDiasARestar, 0))) TotalDiasPagados,
	SUM( ISNULL(Totales.TotalEmpleado, 0)) + SUM(ISNULL( Totales.TotalPatrono, 0)) TotalAhorro
FROM (
	SELECT ecn.concepto, ecn.nomina, ecn.numero_nomina, ecn.empleado, ecn.consecutivo, 
	ecn.total TotalEmpleado, 0 TotalPatrono, 0 TotalDiasPagados, 0 TotalDiasARestar
	, nh.fecha_inicio, nh.fecha_fin, e.nombre
	FROM $$COMPANIA$$.empleado_conc_nomi ecn, $$COMPANIA$$.nomina_historico nh, $$COMPANIA$$.EMPLEADO e
	WHERE ecn.total > 0
	AND ecn.concepto IN (''' + @CptDelEmpleado + ''')
	AND ecn.empleado = e.empleado
	AND nh.nomina = ecn.nomina
	AND nh.numero_nomina = ecn.numero_nomina


UNION ALL SELECT ecn.concepto, ecn.nomina, ecn.numero_nomina, ecn.empleado, ecn.consecutivo, 
0 TotalEmpleado, ecn.total TotalPatrono, 0 TotalDiasPagados, 0 TotalDiasARestar, 
nh.fecha_inicio, nh.fecha_fin, e.nombre
	FROM $$COMPANIA$$.empleado_conc_nomi ecn, $$COMPANIA$$.nomina_historico nh, $$COMPANIA$$.EMPLEADO e
	WHERE ecn.total > 0
	AND ecn.concepto IN (''' + @CptDelPatrono + ''')
	AND ecn.empleado = e.empleado
	AND nh.nomina = ecn.nomina
	AND nh.numero_nomina = ecn.numero_nomina


UNION ALL SELECT ecn.concepto, ecn.nomina, ecn.numero_nomina, ecn.empleado, ecn.consecutivo, 
0 TotalEmpleado, 0 TotalPatrono, ecn.total TotalDiasPagados, 0 TotalDiasARestar, 
nh.fecha_inicio, nh.fecha_fin, e.nombre
	FROM $$COMPANIA$$.empleado_conc_nomi ecn, $$COMPANIA$$.nomina_historico nh, $$COMPANIA$$.EMPLEADO e
	WHERE ecn.total > 0
	AND ecn.concepto IN (''' + @CptDiasPagados + ''')
	AND ecn.empleado = e.empleado
	AND nh.nomina = ecn.nomina
	AND nh.numero_nomina = ecn.numero_nomina


UNION ALL SELECT ecn.concepto, ecn.nomina, ecn.numero_nomina, ecn.empleado, ecn.consecutivo, 
0 TotalEmpleado, 0 TotalPatrono, 0 TotalDiasPagados, ecn.total TotalDiasARestar, 
nh.fecha_inicio, nh.fecha_fin, e.nombre
	FROM $$COMPANIA$$.empleado_conc_nomi ecn, $$COMPANIA$$.nomina_historico nh, $$COMPANIA$$.EMPLEADO e
	WHERE ecn.total > 0
	AND ecn.concepto IN (''' + @CptDiasRestados + ''')
	AND ecn.empleado = e.empleado
	AND nh.nomina = ecn.nomina
	AND nh.numero_nomina = ecn.numero_nomina) Totales'

IF @CodigoNominaIni != '' OR @CodigoNominaFin != ''
BEGIN
	IF @CodigoNominaIni != ''AND @CodigoNominaFin != ''
	BEGIN
		SET @strSQLWhereQuery = ' WHERE totales.NOMINA BETWEEN ''' + @CodigoNominaIni + ''' AND ''' + @CodigoNominaFin + ''''
	END

	IF @CodigoNominaIni != '' AND @CodigoNominaFin = ''
	BEGIN
		SET @strSQLWhereQuery = ' WHERE totales.NOMINA >= ''' + @CodigoNominaIni + ''''
	END

	IF @CodigoNominaIni = '' AND @CodigoNominaFin != ''
	BEGIN
		SET @strSQLWhereQuery = ' WHERE totales.NOMINA <= ''' + @CodigoNominaFin + ''''
	END
END

IF @NumeroNominaIni != '' OR @NumeroNominaFin != ''
BEGIN
	IF @NumeroNominaIni != '' AND @NumeroNominaFin != ''
	BEGIN
		IF @strSQLWhereQuery = '' OR @strSQLWhereQuery IS NULL
			SET @strSQLWhereQuery = ' WHERE totales.NUMERO_NOMINA BETWEEN ' + CAST(@NumeroNominaIni AS VARCHAR) + ' AND ' + CAST(@NumeroNominaFin AS VARCHAR)
		ELSE
			SET @strSQLWhereQuery = @strSQLWhereQuery + ' AND totales.NUMERO_NOMINA BETWEEN ' + CAST(@NumeroNominaIni AS VARCHAR) + ' AND ' + CAST(@NumeroNominaFin AS VARCHAR)
	END

	IF @NumeroNominaIni != '' AND @NumeroNominaFin = ''
	BEGIN
		IF @strSQLWhereQuery = '' OR @strSQLWhereQuery IS NULL
			SET @strSQLWhereQuery = ' WHERE totales.NUMERO_NOMINA >= ' + CAST(@NumeroNominaIni AS VARCHAR)
		ELSE
			SET @strSQLWhereQuery = @strSQLWhereQuery + ' AND totales.NUMERO_NOMINA >= ' + CAST(@NumeroNominaIni AS VARCHAR)
			
	END

	IF @NumeroNominaIni = '' AND @NumeroNominaFin != ''
	BEGIN
		IF @strSQLWhereQuery = '' OR @strSQLWhereQuery IS NULL
			SET @strSQLWhereQuery = ' WHERE totales.NUMERO_NOMINA <= ' + CAST(@NumeroNominaFin AS VARCHAR)
		ELSE
			SET @strSQLWhereQuery = @strSQLWhereQuery + ' AND totales.NUMERO_NOMINA <= ' + CAST(@NumeroNominaFin AS VARCHAR)
	END
END


IF (@FechaDesde != '' AND @FechaDesde != '1800/01/01' AND @FechaDesde != '1900/01/01' ) OR (@FechaHasta != '' AND @FechaHasta != '1800/01/01' AND @FechaHasta != '1900/01/01')
BEGIN
	IF @FechaDesde != '' AND @FechaDesde != '1800/01/01' AND @FechaDesde != '1900/01/01' 
	BEGIN
		IF @strSQLWhereQuery = '' OR @strSQLWhereQuery IS NULL
			SET @strSQLWhereQuery = ' WHERE totales.fecha_fin >= ''' + CONVERT(VARCHAR, @FechaDesde, 121) + ''''
		ELSE
			SET @strSQLWhereQuery = @strSQLWhereQuery + ' AND totales.fecha_fin >= ''' + CONVERT(VARCHAR, @FechaDesde, 121) + ''''
	END

	IF @FechaHasta != '' AND @FechaHasta != '1800/01/01' AND @FechaHasta != '1900/01/01'
	BEGIN
		IF @strSQLWhereQuery = '' OR @strSQLWhereQuery IS NULL
			SET @strSQLWhereQuery = ' WHERE totales.fecha_fin <= ''' + CONVERT(VARCHAR, @FechaHasta, 121) + ''''
		ELSE
			SET @strSQLWhereQuery = @strSQLWhereQuery + ' AND totales.fecha_fin <= ''' + CONVERT(VARCHAR, @FechaHasta, 121) + ''''
	END
END

IF @EmpleadoIni != '' OR @EmpleadoFin != ''
BEGIN
	IF @EmpleadoIni != '' AND @EmpleadoFin != ''
	BEGIN
		IF @strSQLWhereQuery = '' OR @strSQLWhereQuery IS NULL
			SET @strSQLWhereQuery = ' WHERE totales.EMPLEADO BETWEEN ''' + @EmpleadoIni + ''' AND ''' + @EmpleadoFin +''''
		ELSE
			SET @strSQLWhereQuery = @strSQLWhereQuery + ' AND totales.EMPLEADO BETWEEN ''' + @EmpleadoIni + ''' AND ''' + @EmpleadoFin + ''''
	END

	IF @EmpleadoIni != '' AND @EmpleadoFin = ''
	BEGIN
		IF @strSQLWhereQuery = '' OR @strSQLWhereQuery IS NULL
			SET @strSQLWhereQuery = ' WHERE totales.EMPLEADO >= ''' + @EmpleadoIni + ''''
		ELSE
			SET @strSQLWhereQuery = @strSQLWhereQuery + ''' AND totales.EMPLEADO >= ''' + @EmpleadoIni + ''''
			
	END

	IF @EmpleadoIni = '' AND @EmpleadoFin != ''
	BEGIN
		IF @strSQLWhereQuery = '' OR @strSQLWhereQuery IS NULL
			SET @strSQLWhereQuery = ' WHERE totales.EMPLEADO <= ''' + @EmpleadoFin + ''''
		ELSE
			SET @strSQLWhereQuery = @strSQLWhereQuery + ' AND totales.EMPLEADO <= ''' + @EmpleadoFin + ''''
	END
END

SET @strSQLGroupQuery = ' GROUP BY totales.EMPLEADO, totales.nombre'

EXEC (@strSQLQuery + @strSQLWhereQuery + @strSQLGroupQuery)

END;


CREATE PROCEDURE $$COMPANIA$$.ReporteFondoAhorroAnual
(	@CptDelEmpleado VARCHAR(MAX)
	,@CptDelPatrono VARCHAR(MAX)
	,@CptPrestamos VARCHAR(MAX)
	,@CptFiniquitos VARCHAR(MAX)
	,@CptIntDescPrestamos VARCHAR(20)
	,@CptInteresPrestamos VARCHAR(20)
	,@CptInteresGanado VARCHAR(20)
	,@CodigoNominaIni VARCHAR(4)
	,@CodigoNominaFin VARCHAR(4)
	,@NumeroNominaIni INT
	,@NumeroNominaFin INT
	,@FechaDesde DATETIME
	,@FechaHasta DATETIME
	,@EmpleadoIni VARCHAR(20)
	,@EmpleadoFin VARCHAR(20))
AS
BEGIN

	DECLARE @sqlConsulta varchar(MAX)
	DECLARE @strSQLWhereQuery varchar(MAX)
	DECLARE @strSQLGroupQuery VARCHAR(MAX)


	SET @sqlConsulta = ''
	SET @strSQLWhereQuery = ''
	SET @strSQLGroupQuery = ''

	SET @sqlConsulta = '
		SELECT totales.fecha_inicio, totales.fecha_fin, totales.periodo, totales.concepto, totales.nomina, totales.numero_nomina, totales.empleado, 
	totales.nombre, totales.activo, 
			ISNULL(totales.TotalEmpleado, 0) TotalEmpleado, ISNULL(totales.TotalPatrono, 0) TotalPatrono, 
			ISNULL(totales.TotalPrestamos, 0) TotalPrestamos, ISNULL(totales.TotalFiniquitos, 0) TotalFiniquitos,
			ISNULL(totales.TotalIntDescPrestamos, 0) IntDescPrestamos, 
			ISNULL(totales.TotalInteresPrestamos, 0) InteresPrestamos,ISNULL(totales.TotalInteresesGanados, 0) InteresesGanados
	FROM (
	SELECT nh.fecha_fin, nh.fecha_inicio, ecn.concepto, nh.periodo, nh.nomina, nh.numero_nomina, ecn.empleado, e.nombre, e.activo, 
	ecn.Total TotalEmpleado, 0 TotalPatrono, 0 TotalPrestamos, 0 TotalFiniquitos , 0 TotalIntDescPrestamos , 
	0 TotalInteresPrestamos,0 TotalInteresesGanados
	FROM $$COMPANIA$$.empleado_conc_nomi ecn,  $$COMPANIA$$.nomina_historico nh, $$COMPANIA$$.EMPLEADO e
	WHERE ecn.total > 0
	AND ecn.concepto IN(''' + @CptDelEmpleado + ''')
	AND ecn.empleado = e.empleado
	AND nh.nomina = ecn.nomina
	AND nh.numero_nomina = ecn.numero_nomina
	UNION ALL
	SELECT nh.fecha_fin, nh.fecha_inicio, ecn.concepto, nh.periodo, nh.nomina, nh.numero_nomina, ecn.empleado, e.nombre, e.activo, 
	0 TotalEmpleado, ecn.TOTAL TotalPatrono, 0 TotalPrestamos, 0 TotalFiniquitos , 0 TotalIntDescPrestamos , 
	0 TotalInteresPrestamos,0 TotalInteresesGanados
	FROM $$COMPANIA$$.empleado_conc_nomi ecn,  $$COMPANIA$$.nomina_historico nh, $$COMPANIA$$.EMPLEADO e
	WHERE ecn.total > 0
	AND ecn.concepto IN(''' + @CptDelPatrono + ''')
	AND ecn.empleado = e.empleado
	AND nh.nomina = ecn.nomina
	AND nh.numero_nomina = ecn.numero_nomina
	UNION ALL
	SELECT nh.fecha_fin, nh.fecha_inicio, ecn.concepto, nh.periodo, nh.nomina, nh.numero_nomina, ecn.empleado, e.nombre, e.activo, 
	0 TotalEmpleado, 0 TotalPatrono, ecn.TOTAL TotalPrestamos, 0 TotalFiniquitos , 0 TotalIntDescPrestamos , 
	0 TotalInteresPrestamos,0 TotalInteresesGanados
	FROM $$COMPANIA$$.empleado_conc_nomi ecn,  $$COMPANIA$$.nomina_historico nh, $$COMPANIA$$.EMPLEADO e
	WHERE ecn.total > 0
	AND ecn.concepto IN(''' +@CptPrestamos + ''')
	AND ecn.empleado = e.empleado
	AND nh.nomina = ecn.nomina
	AND nh.numero_nomina = ecn.numero_nomina
	UNION ALL
	SELECT nh.fecha_fin, nh.fecha_inicio, ecn.concepto, nh.periodo, nh.nomina, nh.numero_nomina, ecn.empleado, e.nombre, e.activo, 
	0 TotalEmpleado, 0 TotalPatrono, 0 TotalPrestamos, ecn.TOTAL TotalFiniquitos , 0 TotalIntDescPrestamos , 
	0 TotalInteresPrestamos,0 TotalInteresesGanados
	FROM $$COMPANIA$$.empleado_conc_nomi ecn,  $$COMPANIA$$.nomina_historico nh, $$COMPANIA$$.EMPLEADO e
	WHERE ecn.total > 0
	AND ecn.concepto IN(''' + @CptFiniquitos + ''')
	AND ecn.empleado = e.empleado
	AND nh.nomina = ecn.nomina
	AND nh.numero_nomina = ecn.numero_nomina
	UNION ALL
	SELECT nh.fecha_fin, nh.fecha_inicio, ecn.concepto, nh.periodo, nh.nomina, nh.numero_nomina, ecn.empleado, e.nombre, e.activo, 
	0 TotalEmpleado, 0 TotalPatrono, 0 TotalPrestamos, 0 TotalFiniquitos , ecn.TOTAL TotalIntDescPrestamos , 
	0 TotalInteresPrestamos,0 TotalInteresesGanados
	FROM $$COMPANIA$$.empleado_conc_nomi ecn,  $$COMPANIA$$.nomina_historico nh, $$COMPANIA$$.EMPLEADO e
	WHERE ecn.total > 0
	AND ecn.concepto IN(''' + @CptIntDescPrestamos + ''')
	AND ecn.empleado = e.empleado
	AND nh.nomina = ecn.nomina
	AND nh.numero_nomina = ecn.numero_nomina
	UNION ALL
	SELECT nh.fecha_fin, nh.fecha_inicio, ecn.concepto, nh.periodo, nh.nomina, nh.numero_nomina, ecn.empleado, e.nombre, e.activo, 
	0 TotalEmpleado, 0 TotalPatrono, 0 TotalPrestamos, 0 TotalFiniquitos , 0 TotalIntDescPrestamos , 
	ecn.TOTAL TotalInteresPrestamos,0 TotalInteresesGanados
	FROM $$COMPANIA$$.empleado_conc_nomi ecn,  $$COMPANIA$$.nomina_historico nh, $$COMPANIA$$.EMPLEADO e
	WHERE ecn.total > 0
	AND ecn.concepto IN(''' + @CptInteresPrestamos + ''')
	AND ecn.empleado = e.empleado
	AND nh.nomina = ecn.nomina
	AND nh.numero_nomina = ecn.numero_nomina
	UNION ALL
	SELECT nh.fecha_fin, nh.fecha_inicio, ecn.concepto, nh.periodo, nh.nomina, nh.numero_nomina, ecn.empleado, e.nombre, e.activo, 
	0 TotalEmpleado, 0 TotalPatrono, 0 TotalPrestamos, 0 TotalFiniquitos , 0 TotalIntDescPrestamos , 
	0 TotalInteresPrestamos,ecn.TOTAL TotalInteresesGanados
	FROM $$COMPANIA$$.empleado_conc_nomi ecn,  $$COMPANIA$$.nomina_historico nh, $$COMPANIA$$.EMPLEADO e
	WHERE ecn.total > 0
	AND ecn.concepto IN(''' + @CptInteresGanado + ''')
	AND ecn.empleado = e.empleado
	AND nh.nomina = ecn.nomina
	AND nh.numero_nomina = ecn.numero_nomina ) totales
	'

	IF @CodigoNominaIni != '' OR @CodigoNominaFin != ''
	BEGIN
		IF @CodigoNominaIni != ''AND @CodigoNominaFin != ''
		BEGIN
			SET @strSQLWhereQuery = ' WHERE totales.NOMINA BETWEEN ''' + @CodigoNominaIni + ''' AND ''' + @CodigoNominaFin + ''''
		END

		IF @CodigoNominaIni != '' AND @CodigoNominaFin = ''
		BEGIN
			SET @strSQLWhereQuery = ' WHERE totales.NOMINA >= ''' + @CodigoNominaIni + ''''
		END

		IF @CodigoNominaIni = '' AND @CodigoNominaFin != ''
		BEGIN
			SET @strSQLWhereQuery = ' WHERE totales.NOMINA <= ''' + @CodigoNominaFin + ''''
		END
	END

	IF @NumeroNominaIni != '' OR @NumeroNominaFin != ''
	BEGIN
		IF @NumeroNominaIni != '' AND @NumeroNominaFin != ''
		BEGIN
			IF @strSQLWhereQuery = ''
				SET @strSQLWhereQuery = ' WHERE totales.NUMERO_NOMINA BETWEEN ' + CAST(@NumeroNominaIni AS VARCHAR) + ' AND ' + CAST(@NumeroNominaFin AS VARCHAR)
			ELSE
				SET @strSQLWhereQuery = @strSQLWhereQuery + ' AND totales.NUMERO_NOMINA BETWEEN ' + CAST(@NumeroNominaIni AS VARCHAR) + ' AND ' + CAST(@NumeroNominaFin AS VARCHAR)
		END

		IF @NumeroNominaIni != '' AND @NumeroNominaFin = ''
		BEGIN
			IF @strSQLWhereQuery = ''
				SET @strSQLWhereQuery = ' WHERE totales.NUMERO_NOMINA >= ' + CAST(@NumeroNominaIni AS VARCHAR)
			ELSE
				SET @strSQLWhereQuery = @strSQLWhereQuery + ' AND totales.NUMERO_NOMINA >= ' + CAST(@NumeroNominaIni AS VARCHAR)
			
		END

		IF @NumeroNominaIni = '' AND @NumeroNominaFin != ''
		BEGIN
			IF @strSQLWhereQuery = ''
				SET @strSQLWhereQuery = ' WHERE totales.NUMERO_NOMINA <= ' + CAST(@NumeroNominaFin AS VARCHAR)
			ELSE
				SET @strSQLWhereQuery = @strSQLWhereQuery + ' AND totales.NUMERO_NOMINA <= ' + CAST(@NumeroNominaFin AS VARCHAR)
		END
	END


	IF (@FechaDesde != '' AND @FechaDesde != '1800/01/01' AND @FechaDesde != '1900/01/01' ) OR (@FechaHasta != '' AND @FechaHasta != '1800/01/01' AND @FechaHasta != '1900/01/01')
	BEGIN
		IF @FechaDesde != '' AND @FechaDesde != '1800/01/01' AND @FechaDesde != '1900/01/01' 
		BEGIN
			IF @strSQLWhereQuery = ''
				SET @strSQLWhereQuery = ' WHERE totales.fecha_fin >= ''' + CONVERT(VARCHAR, @FechaDesde, 121) + ''''
			ELSE
				SET @strSQLWhereQuery = @strSQLWhereQuery + ' AND totales.fecha_fin >= ''' + CONVERT(VARCHAR, @FechaDesde, 121) + ''''
		END

		IF @FechaHasta != '' AND @FechaHasta != '1800/01/01' AND @FechaHasta != '1900/01/01'
		BEGIN
			IF @strSQLWhereQuery = ''
				SET @strSQLWhereQuery = ' WHERE totales.fecha_fin <= ''' + CONVERT(VARCHAR, @FechaHasta, 121) + ''''
			ELSE
				SET @strSQLWhereQuery = @strSQLWhereQuery + ' AND totales.fecha_fin <= ''' + CONVERT(VARCHAR, @FechaHasta, 121) + ''''
		END
	END

	IF @EmpleadoIni != '' OR @EmpleadoFin != ''
	BEGIN
		IF @EmpleadoIni != '' AND @EmpleadoFin != ''
		BEGIN
			IF @strSQLWhereQuery = ''
				SET @strSQLWhereQuery = ' WHERE totales.EMPLEADO BETWEEN ''' + @EmpleadoIni + ''' AND ''' + @EmpleadoFin +''''
			ELSE
				SET @strSQLWhereQuery = @strSQLWhereQuery + ' AND totales.EMPLEADO BETWEEN ''' + @EmpleadoIni + ''' AND ''' + @EmpleadoFin + ''''
		END

		IF @EmpleadoIni != '' AND @EmpleadoFin = ''
		BEGIN
			IF @strSQLWhereQuery = ''
				SET @strSQLWhereQuery = ' WHERE totales.EMPLEADO >= ''' + @EmpleadoIni + ''''
			ELSE
				SET @strSQLWhereQuery = @strSQLWhereQuery + ''' AND totales.EMPLEADO >= ''' + @EmpleadoIni + ''''
			
		END

		IF @EmpleadoIni = '' AND @EmpleadoFin != ''
		BEGIN
			IF @strSQLWhereQuery = ''
				SET @strSQLWhereQuery = ' WHERE totales.EMPLEADO <= ''' + @EmpleadoFin + ''''
			ELSE
				SET @strSQLWhereQuery = @strSQLWhereQuery + ' AND totales.EMPLEADO <= ''' + @EmpleadoFin + ''''
		END
	END

	SET @strSQLGroupQuery = ' ORDER  BY totales.EMPLEADO, totales.CONCEPTO '

	EXEC (@sqlConsulta + @strSQLWhereQuery + @strSQLGroupQuery)

END;

