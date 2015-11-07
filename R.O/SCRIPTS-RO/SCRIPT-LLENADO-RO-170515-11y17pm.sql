




--------------------------------------------------------------------------------
-- EVENTOS (PARA EL TRIGGER DE LA BITACORA)
--------------------------------------------------------------------------------
INSERT INTO EVENTOS_TABLE VALUES(
      SYSDATE,
      'PRUEBA',
      (SELECT REF(U) FROM USUARIOS_TABLE U
        WHERE NOMBRE = 'ADMIN')
);
-- VERIFICAR 
SELECT * FROM EVENTOS_TABLE;

--------------------------------------------------------------------------------
-- ARTICULO ESTADOS
--------------------------------------------------------------------------------
INSERT INTO ARTICULOESTADOS VALUES('ACTIVO');
INSERT INTO ARTICULOESTADOS VALUES('INACTIVO');
-- VERIFICAR
SELECT * FROM ARTICULOESTADOS;

--------------------------------------------------------------------------------
-- PERMISOS
--------------------------------------------------------------------------------
INSERT INTO PERMISOS_TABLE VALUES('TODOS');
INSERT INTO PERMISOS_TABLE VALUES('LEER');
-- VERIFICAR
SELECT * FROM PERMISOS_TABLE;

--------------------------------------------------------------------------------
-- USUARIOS
--------------------------------------------------------------------------------
INSERT INTO USUARIOS_TABLE VALUES('ADMIN', 'ADMIN',
cast(multiset
      (SELECT REF(P) FROM PERMISOS_TABLE P
        where DESCRIPCION = 'TODOS')
      AS LISTAPERMISOS)
);
-- VERIFICAR
SELECT * FROM USUARIOS_TABLE;
 
-- PERMISOS ADICIONALES A UN USUARIO
INSERT INTO TABLE (SELECT LISTA_PERMISOS FROM USUARIOS_TABLE where NOMBRE = 'ADMIN') VALUES
((
      (SELECT REF(P) FROM PERMISOS_TABLE P
        WHERE DESCRIPCION = 'LEER')
      )
);
 
-- VERIFICAR QUE EL USUARIO TENGA LOS PERMISOS
SELECT * FROM TABLE (SELECT LISTA_PERMISOS from USUARIOS_TABLE where NOMBRE = 'ADMIN');
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- FAMILIAS
--------------------------------------------------------------------------------
INSERT INTO FAMILIAS_TABLE VALUES('CPU',10);
INSERT INTO FAMILIAS_TABLE VALUES('MONITORES',30);
INSERT INTO FAMILIAS_TABLE VALUES('IMPRESORAS',40);
-- VERIFICAR
SELECT * FROM FAMILIAS_TABLE;

--------------------------------------------------------------------------------
-- MARCAS
--------------------------------------------------------------------------------
INSERT INTO MARCAS_TABLE VALUES ('HP');
INSERT INTO MARCAS_TABLE VALUES ('LENOVO');
INSERT INTO MARCAS_TABLE VALUES ('MICROSOFT');
INSERT INTO MARCAS_TABLE VALUES ('EPSON');
INSERT INTO MARCAS_TABLE VALUES ('INTEL');
INSERT INTO MARCAS_TABLE VALUES ('SAMSUNG');
INSERT INTO MARCAS_TABLE VALUES ('DELL');
INSERT INTO MARCAS_TABLE VALUES ('POLLITO'); 
 -- VERIFICAR
SELECT * FROM MARCAS_TABLE;
-----------------------------------------------------------------------
--------------------------------------------------------------------------------
-- UNIDADES_MEDIDAS_TABLE
 --------------------------------------------------------------------------------
INSERT INTO UNIDADES_MEDIDAS_TABLE VALUES('UN');
INSERT INTO UNIDADES_MEDIDAS_TABLE VALUES('HR');
 -- VERIFICAR
SELECT * FROM UNIDADES_MEDIDAS_TABLE;
-- ---------------------------------------------------------
--------------------------------------------------------------------------------
-- ESTADOS COTIZACIONES
--------------------------------------------------------------------------------
INSERT INTO ESTADOS_COTIZACIONES_TABLE VALUES('VIGENTE');
INSERT INTO ESTADOS_COTIZACIONES_TABLE VALUES('ANULADA');
INSERT INTO ESTADOS_COTIZACIONES_TABLE VALUES('VENCIDA');
INSERT INTO ESTADOS_COTIZACIONES_TABLE VALUES('CON FACTURA');
-- VERIFICAR
SELECT * FROM ESTADOS_COTIZACIONES_TABLE;

-------------------------------------------------------------------------------
-- MONEDAS
------------------------------------------------------------------------------
-- MONEDAS
INSERT INTO MONEDAS_TABLE VALUES('DOLAR');
INSERT INTO MONEDAS_TABLE VALUES('COLON');
INSERT INTO MONEDAS_TABLE VALUES('YEN');
INSERT INTO MONEDAS_TABLE VALUES('PESO');
-- VERIFICAR
SELECT * FROM MONEDAS_TABLE;

-------------------------------------------------------------------------
-- ARTICULOS TABLE
INSERT INTO ARTICULOS_TABLE VALUES('FP110','FUENTE DE PODER 110V',
(SELECT REF(P1) FROM UNIDADES_MEDIDAS_TABLE P1
        where DESCRIPCION = 'UN'),
      (SELECT REF(P2) FROM MARCAS_TABLE P2
        where DESCRIPCION = 'POLLITO'),
        SYSDATE, 
        (SELECT REF(P3) FROM FAMILIAS_TABLE P3
        where DESCRIPCION = 'CPU'),
        (SELECT REF(P4) FROM ARTICULOESTADOS P4
        where DESCRIPCION = 'ACTIVO'),5,10,2,200,SYSDATE,LISTAARTICULOS(),
        (SELECT REF(P5) FROM USUARIOS_TABLE P5
        where NOMBRE = 'ADMIN')
);
 
INSERT INTO ARTICULOS_TABLE VALUES('MOLED26','MONITOR LED 26 PULGADAS',
(SELECT REF(P1) FROM UNIDADES_MEDIDAS_TABLE P1
        where DESCRIPCION = 'UN'),
      (SELECT REF(P2) FROM MARCAS_TABLE P2
        where DESCRIPCION = 'SAMSUNG'),
        SYSDATE, 
        (SELECT REF(P3) FROM FAMILIAS_TABLE P3
        where DESCRIPCION = 'MONITORES'),
        (SELECT REF(P4) FROM ARTICULOESTADOS P4
        where DESCRIPCION = 'ACTIVO'),4,11,3,400,SYSDATE,LISTAARTICULOS(),
        (SELECT REF(P5) FROM USUARIOS_TABLE P5
        where NOMBRE = 'ADMIN')
);
 
INSERT INTO ARTICULOS_TABLE VALUES('ITW3250','IMPRESORA INYECCION TINTA WIRELESS',
(SELECT REF(P1) FROM UNIDADES_MEDIDAS_TABLE P1
        where DESCRIPCION = 'UN'),
      (SELECT REF(P2) FROM MARCAS_TABLE P2
        where DESCRIPCION = 'HP'),
        SYSDATE, 
        (SELECT REF(P3) FROM FAMILIAS_TABLE P3
        where DESCRIPCION = 'IMPRESORAS'),
        (SELECT REF(P4) FROM ARTICULOESTADOS P4
        where DESCRIPCION = 'ACTIVO'),2,8,1,300,SYSDATE,LISTAARTICULOS(),
        (SELECT REF(P5) FROM USUARIOS_TABLE P5
        where NOMBRE = 'ADMIN')
);
------------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- EMPRESAS
--------------------------------------------------------------------------------
INSERT INTO EMPRESAS_TABLE VALUES(12345,'PROVEEDOR',DIRECCION_TYPE('COSTA RICA','CARTAGO','CARTAGO','50100','TEC','LAB'),LISTACONTACTOS());
INSERT INTO EMPRESAS_TABLE VALUES(54321,'CLIENTE',DIRECCION_TYPE('COSTA RICA','CARTAGO','CARTAGO','50100','TEC','LAB'),LISTACONTACTOS());
-- VERIFICAR
SELECT * FROM EMPRESAS_TABLE;


--------------------------------------------------------------------------------
-- COTIZACION
--------------------------------------------------------------------------------
 
INSERT INTO COTIZACION_TABLE VALUES(
  5,
  SYSDATE,
  (SELECT REF(ET) FROM EMPRESAS_TABLE ET where CEDULAJURIDICA = '12345'),
  'COND PAGO',
  'COND VENTA',
  'VIGENCIA PRUEBA',
  'OBS PRU',
  (SELECT REF(MT) FROM MONEDAS_TABLE MT where DESCRIPCION = 'DOLAR'),
  (SELECT REF(ECT) FROM ESTADOS_COTIZACIONES_TABLE ECT where DESCRIPCION = 'VIGENTE'),
  SYSDATE,
  (
    LISTAARTICULOS(
      REF_ARTICULO_TYPE(
          (SELECT REF(P) FROM ARTICULOS_TABLE P
            where CODIGO = 'MOLED26')
        ),
      REF_ARTICULO_TYPE(
          (SELECT REF(P) FROM ARTICULOS_TABLE P
            where CODIGO = 'ITW3250')
        )
      )
  )
);
 
INSERT INTO COTIZACION_TABLE VALUES(
  6,
  SYSDATE,
  (SELECT REF(ET) FROM EMPRESAS_TABLE ET where CEDULAJURIDICA = '54321'),
  'COND PAGO',
  'COND VENTA',
  'VIGENCIA PRUEBA',
  'OBS PRU',
  (SELECT REF(MT) FROM MONEDAS_TABLE MT where DESCRIPCION = 'DOLAR'),
  (SELECT REF(ECT) FROM ESTADOS_COTIZACIONES_TABLE ECT where DESCRIPCION = 'VIGENTE'),
  SYSDATE,
  (
    LISTAARTICULOS(
      REF_ARTICULO_TYPE(
          (SELECT REF(P) FROM ARTICULOS_TABLE P
            where CODIGO = 'FP110')
        ),
      REF_ARTICULO_TYPE(
          (SELECT REF(P) FROM ARTICULOS_TABLE P
            where CODIGO = 'TEC1')
        )
      )
  )
);
-- VERIFICAR
SELECT * FROM COTIZACION_TABLE;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- ARTICULO ESTADOS TIPO CAMBIO
--------------------------------------------------------------------------------
INSERT INTO ESTADOS_TIPO_CAMBIO_TABLE VALUES('P');
INSERT INTO ESTADOS_TIPO_CAMBIO_TABLE VALUES('R');
 
-- VERIFICAR
SELECT * FROM ESTADOS_TIPO_CAMBIO_TABLE;

--------------------------------------------------------------------------------
-- LISTA_PRECIOS_TABLE
--------------------------------------------------------------------------------
SELECT * FROM LISTAS_PRECIOS_TABLE;
INSERT INTO LISTAS_PRECIOS_TABLE VALUES(
  'SECTOR PUBLICO',
  90,
  70,
  60,
  (
    LISTAARTICULOS(
      REF_ARTICULO_TYPE(
          (SELECT REF(P) FROM ARTICULOS_TABLE P
            where CODIGO = 'FP110')
        ),
      REF_ARTICULO_TYPE(
          (SELECT REF(P) FROM ARTICULOS_TABLE P
            where CODIGO = 'TEC1')
        )
      )
  )
);
INSERT INTO LISTAS_PRECIOS_TABLE VALUES(
  'CLIENTE CONTADO',
  40,
  30,
  20,
  (
    LISTAARTICULOS(
      REF_ARTICULO_TYPE(
          (SELECT REF(P) FROM ARTICULOS_TABLE P
            where CODIGO = 'MOLED26')
        ),
      REF_ARTICULO_TYPE(
          (SELECT REF(P) FROM ARTICULOS_TABLE P
            where CODIGO = 'CASE110V')
        )
      )
  )
);
INSERT INTO LISTAS_PRECIOS_TABLE VALUES(
  'CLIENTE CREDITO',
  20,
  10,
  10,
  (
    LISTAARTICULOS(
      REF_ARTICULO_TYPE(
          (SELECT REF(P) FROM ARTICULOS_TABLE P
            where CODIGO = 'ITW3250')
        ),
      REF_ARTICULO_TYPE(
          (SELECT REF(P) FROM ARTICULOS_TABLE P
            where CODIGO = 'TEC1')
        )
      )
  )
);
 
-- ==============================================

-----------------------------------------------------------------------------------------------
--TABLE TIPOS CAMBIO
INSERT INTO TIPOS_CAMBIO_TABLE VALUES(
      SYSDATE - 1,
      (SELECT REF(P1) FROM MONEDAS_TABLE P1
        where DESCRIPCION = 'DOLAR'),
      (SELECT REF(P2) FROM MONEDAS_TABLE P2
        where DESCRIPCION = 'COLON'),
        539,
        (SELECT REF(P3) FROM ESTADOS_TIPO_CAMBIO_TABLE P3
        where NOMBRE = 'R')
);
 
INSERT INTO TIPOS_CAMBIO_TABLE VALUES(
      SYSDATE - 2,
      (SELECT REF(P1) FROM MONEDAS_TABLE P1
        where DESCRIPCION = 'COLON'),
      (SELECT REF(P2) FROM MONEDAS_TABLE P2
        where DESCRIPCION = 'DOLAR'),
        526   ,
        (SELECT REF(P3) FROM ESTADOS_TIPO_CAMBIO_TABLE P3
        where NOMBRE = 'R')
);
 
INSERT INTO TIPOS_CAMBIO_TABLE VALUES(
      SYSDATE - 3,
      (SELECT REF(P1) FROM MONEDAS_TABLE P1
        where DESCRIPCION = 'COLON'),
      (SELECT REF(P2) FROM MONEDAS_TABLE P2
        where DESCRIPCION = 'DOLAR'),
        515   ,
        (SELECT REF(P3) FROM ESTADOS_TIPO_CAMBIO_TABLE P3
        where NOMBRE = 'R')
);

INSERT INTO TIPOS_CAMBIO_TABLE VALUES(
      SYSDATE - 4,
      (SELECT REF(P1) FROM MONEDAS_TABLE P1
        where DESCRIPCION = 'COLON'),
      (SELECT REF(P2) FROM MONEDAS_TABLE P2
        where DESCRIPCION = 'DOLAR'),
        510   ,
        (SELECT REF(P3) FROM ESTADOS_TIPO_CAMBIO_TABLE P3
        where NOMBRE = 'R')
);

INSERT INTO TIPOS_CAMBIO_TABLE VALUES(
      SYSDATE - 5,
      (SELECT REF(P1) FROM MONEDAS_TABLE P1
        where DESCRIPCION = 'COLON'),
      (SELECT REF(P2) FROM MONEDAS_TABLE P2
        where DESCRIPCION = 'DOLAR'),
        500   ,
        (SELECT REF(P3) FROM ESTADOS_TIPO_CAMBIO_TABLE P3
        where NOMBRE = 'R')
);

INSERT INTO TIPOS_CAMBIO_TABLE VALUES(
      SYSDATE - 6,
      (SELECT REF(P1) FROM MONEDAS_TABLE P1
        where DESCRIPCION = 'COLON'),
      (SELECT REF(P2) FROM MONEDAS_TABLE P2
        where DESCRIPCION = 'DOLAR'),
        505   ,
        (SELECT REF(P3) FROM ESTADOS_TIPO_CAMBIO_TABLE P3
        where NOMBRE = 'R')
);

INSERT INTO TIPOS_CAMBIO_TABLE VALUES(
      SYSDATE - 7,
      (SELECT REF(P1) FROM MONEDAS_TABLE P1
        where DESCRIPCION = 'COLON'),
      (SELECT REF(P2) FROM MONEDAS_TABLE P2
        where DESCRIPCION = 'DOLAR'),
        498   ,
        (SELECT REF(P3) FROM ESTADOS_TIPO_CAMBIO_TABLE P3
        where NOMBRE = 'R')
);
 
---------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- INDICES ECONOMICOS
--------------------------------------------------------------------------------
INSERT INTO INDICES_ECONOMICOS_TABLE VALUES (
        'COLON - DOLAR',
        3,
        1, 
        FAMILIA_TYPE('CPU',10),
        (cast(multiset(SELECT REF(P) FROM TIPOS_CAMBIO_TABLE P where MONEDA_A = (SELECT REF(U) FROM MONEDAS_TABLE U WHERE DESCRIPCION = 'DOLAR'))AS LISTATIPOCAMBIOS)));
 
INSERT INTO INDICES_ECONOMICOS_TABLE VALUES (
        'DOLAR - COLON',
        3,
        1, 
        FAMILIA_TYPE('CPU',10),
        (cast(multiset(SELECT REF(P) FROM TIPOS_CAMBIO_TABLE P where MONEDA_A = (SELECT REF(U) FROM MONEDAS_TABLE U WHERE DESCRIPCION = 'COLON'))AS LISTATIPOCAMBIOS)));
 
-- VERIFICAR
SELECT * FROM INDICES_ECONOMICOS_TABLE;

--------------------------------------------------------------------------------
-- FACTURAS
--------------------------------------------------------------------------------
 
INSERT INTO FACTURAS_TABLE VALUES (
  3,
  SYSDATE, 
  SYSDATE,
  (
    LISTALINEASFACTURA(
      LINEAFACTURA_TYPE((
          SELECT REF(P) FROM ARTICULOS_TABLE P
            where CODIGO = 'FP110'
        ),20,10)
      )
  ),
  (SELECT REF(U) FROM USUARIOS_TABLE U where NOMBRE = 'ADMIN')
);
 
INSERT INTO FACTURAS_TABLE VALUES (
  4,
  SYSDATE, 
  SYSDATE,
  (
    LISTALINEASFACTURA(
      LINEAFACTURA_TYPE((
          SELECT REF(P) FROM ARTICULOS_TABLE P
            where CODIGO = 'FP110'
        ),100,10),
        LINEAFACTURA_TYPE((
          SELECT REF(P) FROM ARTICULOS_TABLE P
            where CODIGO = 'MOLED26'
        ),110,7),
        LINEAFACTURA_TYPE((
          SELECT REF(P) FROM ARTICULOS_TABLE P
            where CODIGO = 'ITW3250'
        ),120,15)
      )
  ),
  (SELECT REF(U) FROM USUARIOS_TABLE U where NOMBRE = 'ADMIN')
);
 
INSERT INTO FACTURAS_TABLE VALUES (
  5,
  SYSDATE, 
  SYSDATE,
  (
    LISTALINEASFACTURA(
      LINEAFACTURA_TYPE((
          SELECT REF(P) FROM ARTICULOS_TABLE P
            where CODIGO = 'MOLED26'
        ),100,14),
        LINEAFACTURA_TYPE((
          SELECT REF(P) FROM ARTICULOS_TABLE P
            where CODIGO = 'ITW3250'
        ),120,22)
      )
  ),
  (SELECT REF(U) FROM USUARIOS_TABLE U where NOMBRE = 'ADMIN')
);
 
SELECT * FROM FACTURAS_TABLE;

 
-- ============================================== 



COMMIT;

 
 