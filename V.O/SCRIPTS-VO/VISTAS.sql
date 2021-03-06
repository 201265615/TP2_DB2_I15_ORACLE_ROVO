-- Generado por Oracle SQL Developer Data Modeler 4.0.2.840
--   en:        2015-05-18 07:50:17 CST
--   sitio:      Oracle Database 12c
--   tipo:      Oracle Database 12c


CREATE OR REPLACE VIEW ARTICULOS_TABLE_VIEW  OF ARTICULO_TYPE
WITH OBJECT IDENTIFIER (CODIGO)
 AS SELECT
    E.CODIGO
   , E.DESCRIPCION
   , ((
      (SELECT REF(P) FROM UNIDADES_MEDIDAS_TABLE_VIEW P
        where DESCRIPCION = E.UNDMEDIDA)
      ))
   , ((
      (SELECT REF(P) FROM MARCAS_TABLE_VIEW P
        where DESCRIPCION = E.CODMARCA)
      ))
   , E.FECHAREGISTRO
   , ((
      (SELECT REF(P) FROM FAMILIAS_TABLE_VIEW P
        where DESCRIPCION = E.CODFAMILIA)
      ))
   , ((
      (SELECT REF(P) FROM ARTICULOESTADOS_TABLE_VIEW P
        where DESCRIPCION = E.CODESTARTICULO)
      ))
   , E.CANTIDAD
   , E.CANTMAXIMA
   , E.CANTMINIMA
   , E.PRECIOMERCDOLARES
   , E.FECHAACTPRECIO
   , (NULL)
   , ((
      (SELECT REF(P) FROM USUARIOS_TABLE_VIEW P
        where DESCRIPCION = E.CODUSERREGISTRO )
      ))
 FROM 
    ARTICULOS_TABLE E;


-------
INSERT INTO ARTICULOS_TABLE_VIEW(
CODIGO,
DESCRIPCION,
UNDMEDIDA,
CODMARCA,
FECHAREGISTRO,
CODFAMILIA,
CODESTARTICULO,
CANTIDAD,
CANTMAXIMA,
CANTMINIMA,
PRECIOMERCDOLARES,
FECHAACTPRECIO,
CODUSERREGISTRO)
VALUES('PBA01','ARTICULO PRUEBA','UN','HP',SYSDATE,'CPU','ACTIVO',10,30,2,200,SYSDATE,'ADMIN');



INSERT INTO MARCAS_TABLE_VIEW VALUES('HP');
INSERT INTO FAMILIAS_TABLE_VIEW VALUES('CPU',10);
INSERT INTO ARTICULOESTADOS_TABLE_VIEW VALUES('ACTIVO');
INSERT INTO UNIDADES_MEDIDAS_TABLE_VIEW VALUES('UN');

SELECT * FROM UNIDADES_MEDIDAS_TABLE_VIEW;


COMMIT;

CREATE OR REPLACE VIEW ARTICULOESTADOS_TABLE_VIEW  OF ARTICULOESTADO_TYPE
WITH OBJECT IDENTIFIER (DESCRIPCION)
 AS SELECT
  E.DESCRIPCION
FROM ARTICULOESTADOS E;


CREATE OR REPLACE VIEW COTIZACION_HISTO_TABLE_VIEW ( NUMERO
   , FECHAREGISTRO
   , EMPRESA
   , CONDICIONPAGO
   , CONDICIONVENTA
   , VIGENCIA
   , OBSERVACIONES
   , MONEDA1
   , CODESTADOCOTIZ
   , FECHA )
 AS SELECT
    NUMERO
   , FECHAREGISTRO
   , EMPRESA
   , CONDICIONPAGO
   , CONDICIONVENTA
   , VIGENCIA
   , OBSERVACIONES
   , MONEDA1
   , CODESTADOCOTIZ
   , FECHA
 FROM 
    COTIZACION_HISTO_TABLE ;





CREATE OR REPLACE VIEW COTIZACION_TABLE_VIEW ( NUMERO
   , FECHAREGISTRO
   , EMPRESA
   , CONDICIONPAGO
   , CONDICIONVENTA
   , VIGENCIA
   , OBSERVACIONES
   , MONEDA1
   , CODESTADOCOTIZ
   , FECHA )
 AS SELECT
    NUMERO
   , FECHAREGISTRO
   , EMPRESA
   , CONDICIONPAGO
   , CONDICIONVENTA
   , VIGENCIA
   , OBSERVACIONES
   , MONEDA1
   , CODESTADOCOTIZ
   , FECHA
 FROM 
    COTIZACION_TABLE ;





CREATE OR REPLACE VIEW EMPRESAS_TABLE_VIEW OF EMPRESA_TYPE
WITH OBJECT IDENTIFIER (CEDULAJURIDICA)
 AS SELECT
    E.CEDULAJURIDICA
   , E.NOMBRECOMERCIAL
   , NULL
   , NULL
 FROM 
    EMPRESAS_TABLE E;





CREATE OR REPLACE VIEW ESTADOS_COTIZACIONES_VIEW OF COTIZACIONESTADO
WITH OBJECT IDENTIFIER (DESCRIPCION)
 AS SELECT
    E.DESCRIPCION
 FROM 
    ESTADOS_COTIZACIONES_TABLE E;





CREATE OR REPLACE VIEW ESTADOS_TIPO_CAMBIO_TABLE_VIEW OF ESTADOTIPOCAMBIO_TYPE
WITH OBJECT IDENTIFIER (NOMBRE)
 AS SELECT
    E.NOMBRE
 FROM 
    ESTADOS_TIPO_CAMBIO_TABLE E;




--PENDIENTE
CREATE OR REPLACE VIEW EVENTOS_TABLE_VIEW OF EVENTO_TYPE
WITH OBJECT IDENTIFIER (FECHA)
 AS SELECT
    E.FECHA
   , E.DESCRIPCION
   , USUARIO_TYPE()
 FROM 
    EVENTOS_TABLE E;





CREATE OR REPLACE VIEW FACTURAS_TABLE_VIEW ( CODIGO
   , FECCOMPRA
   , FECREGISTRO
   , CODUSERREGISTRO )
 AS SELECT
    CODIGO
   , FECCOMPRA
   , FECREGISTRO
   , CODUSERREGISTRO
 FROM 
    FACTURAS_TABLE ;





CREATE OR REPLACE VIEW FAMILIAS_TABLE_VIEW OF FAMILIA_TYPE
WITH OBJECT IDENTIFIER (DESCRIPCION)
 AS SELECT
    E.DESCRIPCION
   , E.PORCIMPACOMPRA
 FROM 
    FAMILIAS_TABLE E;




--PENDIENTE
CREATE OR REPLACE VIEW INDICES_ECONOMICOS_TABLE_VIEW  OF INDICEECONOMICO_TYPE
WITH OBJECT IDENTIFIER (DESCRIPCION)
 AS SELECT
    E.DESCRIPCION
 FROM 
    INDICES_ECONOMICOS_TABLE E;




--PENDIENTE
CREATE OR REPLACE VIEW LINEAS_FACTURA_TABLE_VIEW OF INDICEECONOMICO_TYPE
WITH OBJECT IDENTIFIER (DESCRIPCION)
 AS SELECT
    CODIGO
   , ARTICULO
   , PRECIO
   , CANTIDAD
 FROM 
    LINEAS_FACTURA_TABLE ;





CREATE OR REPLACE VIEW LISTAS_PRECIOS_TABLE_VIEW ( DESCRIPCION
   , GASTOADMIN
   , GASTOOTROS
   , UTILIDAD )
 AS SELECT
    DESCRIPCION
   , GASTOADMIN
   , GASTOOTROS
   , UTILIDAD
 FROM 
    LISTAS_PRECIOS_TABLE ;





CREATE OR REPLACE VIEW LISTA_ARTIC_COTIZACION_TABLE_VIEW ( NUMERO
   , CODIGO )
 AS SELECT
    NUMERO
   , CODIGO
 FROM 
    LISTA_ARTIC_COTIZACION_TABLE ;





CREATE OR REPLACE VIEW LISTA_COMPONENTES_TABLE_VIEW ( CODIGOARTIC
   , CODIGOCOMPO )
 AS SELECT
    CODIGOARTIC
   , CODIGOCOMPO
 FROM 
    LISTA_COMPONENTES_TABLE ;





CREATE OR REPLACE VIEW LISTA_CONTACTOS_TABLE_VIEW ( CEDULAJURIDICA
   , TIPOCONTACTO
   , DESCRIPCION )
 AS SELECT
    CEDULAJURIDICA
   , TIPOCONTACTO
   , DESCRIPCION
 FROM 
    LISTA_CONTACTOS_TABLE ;





CREATE OR REPLACE VIEW LISTA_PERMISOS_TABLE_VIEW ( NOMBRE
   , DESCRIPCION )
 AS SELECT
    NOMBRE
   , DESCRIPCION
 FROM 
    LISTA_PERMISOS_TABLE ;





CREATE OR REPLACE VIEW LISTA_PRECIOS_X_ARTICULOS_VIEW ( DESCRIPCION
   , CODIGO )
 AS SELECT
    DESCRIPCION
   , CODIGO
 FROM 
    LISTA_PRECIOS_X_ARTICULOS ;





CREATE OR REPLACE VIEW LISTA_TIPOCAMBIOS_TABLE_VIEW ( FECHA
   , MONEDA_A
   , MONEDA_B
   , MONTO
   , ESTADO
   , INDICEECONOMICO )
 AS SELECT
    FECHA
   , MONEDA_A
   , MONEDA_B
   , MONTO
   , ESTADO
   , INDICEECONOMICO
 FROM 
    LISTA_TIPOCAMBIOS_TABLE ;





CREATE OR REPLACE VIEW MARCAS_TABLE_VIEW  OF MARCA_TYPE
WITH OBJECT IDENTIFIER (DESCRIPCION) 
 AS SELECT
    E.DESCRIPCION
 FROM 
    MARCAS_TABLE E;





CREATE OR REPLACE VIEW MONEDAS_TABLE_VIEW  OF MONEDA_TYPE
WITH OBJECT IDENTIFIER (DESCRIPCION) 
 AS SELECT
    E.DESCRIPCION
 FROM 
    MONEDAS_TABLE E;




CREATE OR REPLACE VIEW PERMISOS_TABLE_VIEW OF PERMISO_TYPE
WITH OBJECT IDENTIFIER (DESCRIPCION) 
  AS SELECT
    P.DESCRIPCION 
  FROM PERMISOS_TABLE P;




CREATE OR REPLACE VIEW PROYECCIONES_TABLE_VIEW ( FECHA
   , ARTICULO
   , LISTAPRECIO
   , TIPOCAMBIOPROYECT
   , PRECIOMERCDOLARESPROYECT )
 AS SELECT
    FECHA
   , ARTICULO
   , LISTAPRECIO
   , TIPOCAMBIOPROYECT
   , PRECIOMERCDOLARESPROYECT
 FROM 
    PROYECCIONES_TABLE ;





CREATE OR REPLACE VIEW TIPOCONTACTO_TABLE_VIEW OF TIPOCONTACTO_TYPE
WITH OBJECT IDENTIFIER (NOMBRE) 
 AS SELECT
    E.NOMBRE
 FROM 
    TIPOCONTACTO_TABLE E;




--PENDIENTE
CREATE OR REPLACE VIEW TIPOS_CAMBIO_TABLE_VIEW OF TIPOCAMBIO_TYPE
WITH OBJECT IDENTIFIER (FECHA) 
 AS SELECT
    E.FECHA
   , NULL
   , NULL
   , E.MONTO
   , NULL
 FROM 
    TIPOS_CAMBIO_TABLE E;





CREATE OR REPLACE VIEW UNIDADES_MEDIDAS_TABLE_VIEW OF UNIDADMEDIDA_TYPE
WITH OBJECT IDENTIFIER (DESCRIPCION) 
 AS SELECT
    E.DESCRIPCION
 FROM 
    UNIDADES_MEDIDAS_TABLE E;



--ESTE SI FUNCIONA Y SI INSERTA CORRECTAMENTE
CREATE OR REPLACE VIEW USUARIOS_TABLE_VIEW OF USUARIO_TYPE
WITH OBJECT IDENTIFIER (NOMBRE) 
  AS SELECT
    P.NOMBRE,
    P.CLAVE,
    LISTAPERMISOS(
      REF_PERMISO_TYPE((SELECT REF(E) FROM PERMISOS_TABLE_VIEW E
        where DESCRIPCION = 'TODOS')),
      REF_PERMISO_TYPE((SELECT REF(E) FROM PERMISOS_TABLE_VIEW E
        where DESCRIPCION = 'LEER'))
    )
  FROM USUARIOS_TABLE P;
  
  
  --TAMBIEN FUNCIONA
CREATE OR REPLACE VIEW USUARIOS_TABLE_VIEW OF USUARIO_TYPE
WITH OBJECT IDENTIFIER (NOMBRE) 
  AS SELECT
    P.NOMBRE,
    P.CLAVE,
    (LISTAPERMISOS())
  FROM USUARIOS_TABLE P;
  
  
  
INSERT INTO PERMISOS_TABLE_VIEW VALUES('TODOS');
INSERT INTO PERMISOS_TABLE_VIEW VALUES('LEER');


INSERT INTO USUARIOS_TABLE_VIEW(NOMBRE,CLAVE) VALUES('ADMIN', 'ADMIN');

INSERT INTO TABLE(SELECT (LISTA_PERMISOS) FROM USUARIOS_TABLE_VIEW WHERE NOMBRE = 'ADMIN') VALUES ('LEER')



DELETE FROM USUARIOS_TABLE_VIEW;
SELECT * FROM USUARIOS_TABLE_VIEW;
COMMIT;

-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             0
-- CREATE INDEX                             0
-- ALTER TABLE                              0
-- CREATE VIEW                             26
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        1
-- CREATE USER                              2
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- TSDP POLICY                              0
-- 
-- ERRORS                                   1
-- WARNINGS                                 0
