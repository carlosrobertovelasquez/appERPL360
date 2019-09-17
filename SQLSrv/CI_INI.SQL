
INSERT INTO unidad_de_medida( unidad_medida, descripcion )
VALUES( 'UND', 'Unidad' )
go

INSERT INTO ARTICULO_CUENTA( ARTICULO_CUENTA, DESCRIPCION )
VALUES( 'ND', 'No definida' )
go

INSERT INTO articulo
( articulo, descripcion, tipo, origen_corp, peso_neto, peso_bruto,
volumen, bultos, articulo_cuenta, unidad_almacen, unidad_empaque, 
unidad_venta, factor_empaque, factor_venta, existencia_minima, existencia_maxima,
punto_de_reorden, costo_fiscal, costo_comparativo, costo_prom_loc, costo_prom_dol,
costo_std_loc, costo_std_dol, costo_ult_loc, costo_ult_dol, ultima_salida,
ultimo_movimiento, ultimo_ingreso, ultimo_inventario, impuesto,
clase_abc, frecuencia_conteo, codigo_barras_vent, codigo_barras_invt, activo,
usa_lotes, obliga_cuarentena, min_vida_compra, min_vida_consumo, min_vida_venta,
articulo_del_prov, orden_minima, plazo_reabast, 
lote_multiplo, vida_util_prom, dias_cuarentena, precio_base_local, precio_base_dolar,utilizado_manufact,usa_numeros_serie,perecedero )
VALUES(
'ND','No definido','F','T',1,1,1,1,'ND','UND','UND','UND',
1,1,0,0,0,'S','P',0,0,0,0,0,0,'1980-01-01','1980-01-01',
'1980-01-01','1980-01-01','ND','A',0,'ND','ND','N','N','N',0,0,0,'ND',0,0,0,0,0,0,0,'N','N','N' )
go


INSERT INTO lote( lote, articulo, lote_del_proveedor,
fecha_entrada, fecha_vencimiento, fecha_cuarentena, cantidad_ingresada,
estado, tipo_ingreso,ultimo_ingreso ) 
VALUES ( 'ND', 'ND', 'ND','1980-01-01','1980-01-01','1980-01-01', 0, 'V', 'P',0 )
go

INSERT INTO localizacion( bodega, localizacion, descripcion, volumen, peso_maximo )
SELECT bodega, 'ND', 'No definida', 0, 0
from bodega
go

Insert Into ajuste_config (ajuste_config, descripcion, ajuste_base, Activa, Ingreso)
	Values ('~RR~','Reservación','R','S','A')
go 
Insert Into ajuste_config (ajuste_config, descripcion, ajuste_base, Activa, Ingreso)
	Values ('~VV~','Venta','V','S','A')
go 
Insert Into ajuste_config (ajuste_config, descripcion, ajuste_base, Activa, Ingreso)
	Values ('~CC~','Consumo','C','S','A')
go 
Insert Into ajuste_config (ajuste_config, descripcion, ajuste_base, Activa, Ingreso)
	Values ('~OO~','Compra','O','S','A')
go 
Insert Into ajuste_config (ajuste_config, descripcion, ajuste_base, Activa, Ingreso)
	Values ('~PP~','Producción','P','S','A')
go 
Insert Into ajuste_config (ajuste_config, descripcion, ajuste_base, Activa, Ingreso)
	Values ('~EE~','Ensamble','E','S','E')
go 
Insert Into ajuste_config (ajuste_config, descripcion, ajuste_base, Activa, Ingreso)
	Values ('~FF~','Físico','F','S','E')
go 
Insert Into ajuste_config (ajuste_config, descripcion, ajuste_base, Activa, Ingreso)
	Values ('~MM~','Misceláneo','M','S','E')
go 
Insert Into ajuste_config (ajuste_config, descripcion, ajuste_base, Activa, Ingreso)
	Values ('~TT~','Traspaso','T','S','E')
go 
Insert Into ajuste_config (ajuste_config, descripcion, ajuste_base, Activa, Ingreso)
	Values ('~AA~','Aprobación','A','S','A')
go 
Insert Into ajuste_config (ajuste_config, descripcion, ajuste_base, Activa, Ingreso)
	Values ('~NN~','Vencimiento','N','S','A')
go 
Insert Into ajuste_config (ajuste_config, descripcion, ajuste_base, Activa, Ingreso)
	Values ('~SS~','Costo','S','S','E')
go 
Insert Into ajuste_config (ajuste_config, descripcion, ajuste_base, Activa, Ingreso)
	Values ('~II~','Remisión','I','S','A')
go 

insert into ajuste_config (ajuste_config, descripcion, ajuste_base, activa, ingreso) values ('~LL~','Traslado (2F)','I','S','E')
go

insert into ajuste_subtipo (ajuste_config, subtipo) values ('~LL~','D')
go

insert into ajuste_subtipo (ajuste_config, subtipo) values ('~LL~','R')
go

insert into ajuste_subtipo (ajuste_config, subtipo) values ('~LL~','V')
go

insert into ajuste_subtipo (ajuste_config, subtipo) values ('~LL~','C')
go

insert into ajuste_subtipo (ajuste_config, subtipo) values ('~MM~','I')
go

insert into ajuste_subtipo (ajuste_config, subtipo) values ('~II~','D')
go

insert into ajuste_subtipo (ajuste_config, subtipo) values ('~II~','R')
go

insert into ajuste_subtipo (ajuste_config, subtipo) values ('~II~','V')
go

insert into ajuste_subtipo (ajuste_config, subtipo) values ('~II~','C')
go

insert into ajuste_subtipo (ajuste_config, subtipo) values ('~TT~','I')
go



Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~CC~','C')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~CC~','D')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~CC~','I')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~CC~','R')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~CC~','V')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~FF~','C')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~FF~','D')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~FF~','I')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~FF~','V')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~MM~','C')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~MM~','D')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~MM~','R')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~MM~','V')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~NN~','C')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~NN~','D')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~NN~','R')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~OO~','C')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~OO~','D')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~PP~','C')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~PP~','D')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~SS~','F')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~SS~','P')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~TT~','C')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~TT~','D')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~TT~','R')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~TT~','V')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~VV~','D')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~VV~','I')
go 
Insert Into ajuste_subTipo (ajuste_config, subtipo) Values ('~VV~','R')
go 


Insert Into ajuste_subsubTipo (ajuste_config, subsubtipo) Values ('~CC~','D')
go 
Insert Into ajuste_subsubTipo (ajuste_config, subsubtipo) Values ('~CC~','G')
go 
Insert Into ajuste_subsubTipo (ajuste_config, subsubtipo) Values ('~CC~','N')
go 
Insert Into ajuste_subsubTipo (ajuste_config, subsubtipo) Values ('~CC~','R')
go 
Insert Into ajuste_subsubTipo (ajuste_config, subsubtipo) Values ('~NN~','A')
go 
Insert Into ajuste_subsubTipo (ajuste_config, subsubtipo) Values ('~NN~','V')
go 
Insert Into ajuste_subsubTipo (ajuste_config, subsubtipo) Values ('~NN~','Z')
go 
Insert Into ajuste_subsubTipo (ajuste_config, subsubtipo) Values ('~OO~','I')
go 
Insert Into ajuste_subsubTipo (ajuste_config, subsubtipo) Values ('~OO~','L')
go 
Insert Into ajuste_subsubTipo (ajuste_config, subsubtipo) Values ('~PP~','Q')
go 
Insert Into ajuste_subsubTipo (ajuste_config, subsubtipo) Values ('~PP~','S')
go 
Insert Into ajuste_subsubTipo (ajuste_config, subsubtipo) Values ('~SS~','P')
go 
Insert Into ajuste_subsubTipo (ajuste_config, subsubtipo) Values ('~SS~','T')
go 
Insert Into ajuste_subsubTipo (ajuste_config, subsubtipo) Values ('~VV~','E')
go 
Insert Into ajuste_subsubTipo (ajuste_config, subsubtipo) Values ('~VV~','L')
go 


