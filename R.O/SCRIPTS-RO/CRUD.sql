-------------------------------------------------------------------------------------------------
------------------------ARTICULOS-----------------------------------------------------------
-------------------------------------------------------------------------------------------------

---CREAR ARTICULO---------
CREATE OR REPLACE PROCEDURE SP_INSERTARARTICULO (V_CODIGO IN  VARCHAR,V_DESCRIPCION IN  VARCHAR,V_MARCA IN  VARCHAR,V_FAMILIA IN  VARCHAR,
                                                V_CANTIDAD IN  NUMBER,V_CANTMAXIMA IN  NUMBER,V_CANTMINIMA IN  NUMBER,V_PRECIO IN  NUMBER) 
IS
BEGIN    
   INSERT INTO ARTICULOS_TABLE 
   VALUES(V_CODIGO,V_DESCRIPCION,
(SELECT REF(P1) FROM UNIDADES_MEDIDAS_TABLE P1
        where DESCRIPCION = 'UN'),
      (SELECT REF(P2) FROM MARCAS_TABLE P2
        where DESCRIPCION = V_MARCA),
        SYSDATE, 
        (SELECT REF(P3) FROM FAMILIAS_TABLE P3
        where DESCRIPCION = V_FAMILIA),
        (SELECT REF(P4) FROM ARTICULOESTADOS P4
        where DESCRIPCION = 'ACTIVO'),V_CANTIDAD,V_CANTMAXIMA,V_CANTMINIMA,V_PRECIO,SYSDATE,LISTAARTICULOS(),
        (SELECT REF(P5) FROM USUARIOS_TABLE P5
        where NOMBRE = 'ADMIN')
);
EXCEPTION
WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20001, 'ERROR!, INTENTA DE NUEVO');
END;
/
-------------------------------------------------------------------------------------------------
--MODIFICAR ARTICULO
CREATE OR REPLACE PROCEDURE SP_MODIFICARARTICULO (V_CODIGO IN  VARCHAR,V_PRECIO IN  NUMBER) 
IS    
BEGIN    
UPDATE ARTICULOS_TABLE 
SET PRECIOMERCDOLARES = V_PRECIO,
    FECHAACTPRECIO = SYSDATE
WHERE CODIGO = V_CODIGO;
EXCEPTION
WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20001, 'ERROR!, INTENTA DE NUEVO');
END;
/
-----------------------------------------------------------------------------------------------
--ELIMINAR ARTICULO
CREATE OR REPLACE PROCEDURE SP_ELIMINARARTICULO (V_CODIGO IN  VARCHAR) 
IS    
BEGIN    
DELETE FROM ARTICULOS_TABLE 
WHERE CODIGO = V_CODIGO;
EXCEPTION
WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20001, 'ERROR!, INTENTA DE NUEVO');
END;
/
-----------------------------------------------------------------------------------------------




-------------------------------------------------------------------------------------------------
------------------------COMPONENTES--------------------------------------------------------------
-------------------------------------------------------------------------------------------------

---CREAR COMPONENTE---------

-- COMPONENTES ADICIONALES A UN ARTICULO

CREATE OR REPLACE PROCEDURE SP_INSERTARCOMPONENTE (V_CODIGOART IN  VARCHAR,V_CODIGOCOMP IN  VARCHAR) 
IS
BEGIN    
INSERT INTO TABLE (SELECT LISTA_COMPONENTES FROM ARTICULOS_TABLE where CODIGO = V_CODIGOART) VALUES
((
      (SELECT REF(A) FROM ARTICULOS_TABLE A
        WHERE CODIGO = V_CODIGOCOMP)
      )
);
EXCEPTION
WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20001, 'ERROR!, INTENTA DE NUEVO');   
END; 
/
-----------------------------------------------------------------------------------------------
---MODIFICAR COMPONENTE---------
--NO SE HACE PUES SOLO ES NECESARIO ACTUALIZAR EL PRECIO DEL ARTICULO, YA QUE ES UNA REFERENCIA

-----------------------------------------------------------------------------------------------
---ELIMINAR COMPONENTE---------
CREATE OR REPLACE PROCEDURE SP_ELIMINARCOMPONENTE (V_CODIGOART IN  VARCHAR,V_CODIGOCOMP IN  VARCHAR) 
IS
BEGIN

DELETE FROM TABLE(SELECT LISTA_COMPONENTES FROM ARTICULOS_TABLE WHERE CODIGO = V_CODIGOART) WHERE 
(SELECT DEREF(ARTICULO).CODIGO AS COD FROM TABLE (SELECT LISTA_COMPONENTES FROM ARTICULOS_TABLE WHERE CODIGO = V_CODIGOART)) = V_CODIGOCOMP;
EXCEPTION
WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20001, 'ERROR!, INTENTA DE NUEVO');
END; 
/


-----------------------------------------------------------------------------------------------
---LISTAR COMPONENTES DE UN ARTICULO---------
CREATE OR REPLACE PROCEDURE SP_LISTARCMPONENTES (V_CODIGOART IN  VARCHAR) 
AS
CURSOR CURSOR_COMPONENTES IS
SELECT 
  DEREF(ARTICULO).CODIGO COD
FROM TABLE (SELECT LISTA_COMPONENTES FROM ARTICULOS_TABLE WHERE CODIGO = V_CODIGOART);
BEGIN
  FOR I IN CURSOR_COMPONENTES
  LOOP
    DBMS_OUTPUT.PUT_LINE(I.COD);
  END LOOP;
EXCEPTION
WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20001, 'ERROR!, INTENTA DE NUEVO');
END; 
/

-------------------------------------------------------------------------------------------------
------------------------COTIZACIONES-------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
---INSERTAR COTIZACION---------
CREATE OR REPLACE PROCEDURE SP_INSERTARCOTIZACION(
  V_NUMERO                      IN NUMBER,
  V_EMPRESA                     IN NUMBER,
  V_CONDICIONPAGO               IN VARCHAR,
  V_CONDICIONVENTA              IN VARCHAR, 
  V_VIGENCIA                    IN VARCHAR, 
  V_OBSERVACIONES               IN VARCHAR, 
  V_MONEDA1                     IN VARCHAR, 
  V_CODESTADOCOTIZ              IN VARCHAR
   )
   
IS
 
BEGIN

INSERT INTO COTIZACION_TABLE VALUES
(
  V_NUMERO,
  SYSDATE,
  (SELECT REF(ET) FROM EMPRESAS_TABLE ET where CEDULAJURIDICA = V_EMPRESA),
  V_CONDICIONPAGO,
  V_CONDICIONVENTA,
  V_VIGENCIA,
  V_OBSERVACIONES,
  (SELECT REF(MT) FROM MONEDAS_TABLE MT where DESCRIPCION = V_MONEDA1),
  (SELECT REF(ECT) FROM ESTADOS_COTIZACIONES_TABLE ECT where DESCRIPCION = V_CODESTADOCOTIZ),
  SYSDATE,
  LISTAARTICULOS()
);
EXCEPTION
WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20001, 'ERROR!, INTENTA DE NUEVO');
END;
/

-----------------------------------------------------------------------------------------------
---ELIMINAR COTIZACION---------
CREATE OR REPLACE PROCEDURE SP_ELIMINARCOTIZACION(
  V_NUMERO  IN NUMBER
   )
IS
BEGIN
  DELETE FROM COTIZACION_TABLE WHERE NUMERO = V_NUMERO;
EXCEPTION
WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20001, 'ERROR!, INTENTA DE NUEVO');
END;
/


-------------------------------------------------------------------------------------------------
------------------------FACTURAS-----------------------------------------------------------------
-------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------
---INSERTAR FACTURA---------
CREATE OR REPLACE PROCEDURE SP_INSERTARFACTURA (
  V_CODIGO IN  NUMBER,
  V_USUARIO IN  VARCHAR
  ) 
IS
BEGIN

INSERT INTO FACTURAS_TABLE VALUES (
  V_CODIGO,
  SYSDATE, 
  SYSDATE,
  LISTALINEASFACTURA(),
  (SELECT REF(U) FROM USUARIOS_TABLE U where NOMBRE = V_USUARIO)
);

EXCEPTION
WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20001, 'ERROR!, INTENTA DE NUEVO');
END; 
/

-----------------------------------------------------------------------------------------------
---INSERTAR LINEA EN UNA FACTURA---------
CREATE OR REPLACE PROCEDURE SP_INSERTARLINEAFACTURA (
  V_CODFACTURA IN  NUMBER,
  V_CODARTICULO IN  VARCHAR,
  V_PRECIO IN NUMBER,
  V_CANTIDAD IN NUMBER
  ) 
IS
BEGIN

INSERT INTO TABLE (SELECT LISTA_LINEASFACTURA FROM FACTURAS_TABLE WHERE CODIGO = V_CODFACTURA) VALUES 
(
  LINEAFACTURA_TYPE
  (
    (SELECT REF(P) FROM ARTICULOS_TABLE P where CODIGO = V_CODARTICULO),
    V_PRECIO,
    V_CANTIDAD
    )
);
UPDATE FACTURAS_TABLE SET FECCOMPRA = SYSDATE WHERE CODIGO = V_CODFACTURA;

EXCEPTION
WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20001, 'ERROR!, INTENTA DE NUEVO');
END; 
/




-- --------------------------------------------------------------------------------------
-- PROYECCIONES
-- --------------------------------------------------------------------------------------




create or replace PROCEDURE SP_OBTENERTC (
    PFECHA IN DATE,
    PRESULTADO OUT NUMBER
) IS
BEGIN
    -- OBTENER EL TIPO DE CAMBIO DE LA TABLA DE TIPOS DE CAMBIO
    -- HACIENDO USO DE LA FECHA
    SELECT 
      TC.MONTO INTO PRESULTADO
    FROM TIPOS_CAMBIO_TABLE TC
    WHERE TO_DATE(TC.FECHA, 'dd/MM/yy') = TO_DATE(PFECHA, 'dd/MM/yy');
    DBMS_OUTPUT.put_line(PRESULTADO);
END;


/

create or replace PROCEDURE SP_PROYECCIONTC1MES (
	PNUMVALREALES IN NUMBER,	-- CANTIDAD DE MESES QUE SE TOMAN EN CUENTA PARA PROYECTAR EL TC
	PDATE IN DATE,				-- FECHA DEL MES A PARTIR DEL CUAL SE QUIERE CALCULAR EL TC
	-- SOLO SON NECESARIOS PARA EL INSERT DE LA TABLA
	PDESCMONEDA1 IN VARCHAR2,
	PDESCMONEDA2 IN VARCHAR2,
	PNEXTTC OUT NUMBER
) IS
  CURTC NUMBER(17,2);     -- VALOR DEL TC DE LA FECHA (DIA)
  TC0 NUMBER(17,2);       -- VARIABLE DE CONTROL DE MONTO DE TIPO DE CAMBIO (MININUENDO)
  TC1 NUMBER(17,2);       -- VARIABLE DE CONTROL DE MONTO DE TIPO DE CAMBIO (SUSTRAENDO)
  DIFF NUMBER(17,2);      -- VARIABLE DE CONTROL DE MONTO (DIFERENCIA ENTRE MONTOS DE 2 MESES CONSECUTIVOS)
  NEWFECHA DATE;          -- NUEVA FECHA DE DONDE OBTENER EL MONTO DEL TIPO DE CAMBIO
  CONTA NUMBER(10);       -- CONTROL DEL BUCLE
BEGIN
-- INICIALIZA VARIABLES
	TC0 := 0.0;
	TC1 := 0.0;
	DIFF := 0.0;
	CONTA := 0;

  -- OBTENER EL TIPO DE CAMBIO DEL MES
  SP_OBTENERTC(PDATE, CURTC);
  
  
  -- BUCLE DE RECORRIDO EN LA TABLA TC SEGUN EL NUMERO DE VALORES REALES
  WHILE (CONTA < PNUMVALREALES)
  LOOP
    -- OBTIENE EL TIPO DE CAMBIO DEL MES ANTERIOR
    SELECT 
      ADD_MONTHS(PDATE,- CONTA) INTO NEWFECHA 
    FROM DUAL;
    SP_OBTENERTC(NEWFECHA,TC0);
	
    -- OBTIENE EL TIPO DE CAMBIO DEL MES ANTERIOR
    SELECT 
      ADD_MONTHS(PDATE,- (CONTA+1)) INTO NEWFECHA 
    FROM DUAL;
    SP_OBTENERTC(NEWFECHA,TC1);
	
    -- CALCULA DIFERENCIAS
    DIFF := DIFF + (TC0 - TC1);
    CONTA := CONTA + 1;
  END LOOP;
  
  -- CALCULA EL PROMEDIO
  DIFF := (DIFF / PNUMVALREALES);
  
  -- CALCULA EL NUEVO TIPO DE CAMBIO 
  PNEXTTC := (CURTC + DIFF);
  
  -- INCREMENTA LA FECHA EN 1 MES
  SELECT 
    ADD_MONTHS(PDATE, 1) INTO NEWFECHA 
  FROM DUAL;
  
  -- INSERTAR EN LA TABLA DE TIPOS DE CAMBIO
  INSERT INTO TIPOS_CAMBIO_TABLE VALUES(
	NEWFECHA,
	(SELECT REF(MT) FROM MONEDAS_TABLE MT where MT.DESCRIPCION = PDESCMONEDA1),
	(SELECT REF(MT) FROM MONEDAS_TABLE MT where MT.DESCRIPCION = PDESCMONEDA2),
	PNEXTTC,
	(SELECT REF(ETCT) FROM ESTADOS_TIPO_CAMBIO_TABLE ETCT where ETCT.NOMBRE = 'P')
  );
END;

/


create or replace PROCEDURE SP_PROYECCIONTCNMESES (
	PDATESTART IN DATE,
	PNUMMESES IN NUMBER,
	PNUMVALREALES IN NUMBER
) IS
	CONTA NUMBER(10);
	PMONTO NUMBER(17,2);
	NEWFECHA DATE;
BEGIN
	CONTA := 0;
	PMONTO := 0;
	WHILE (CONTA < PNUMMESES)
	LOOP
		-- INCREMENTA UN MES
		SELECT 
		  ADD_MONTHS(PDATESTART,CONTA) INTO NEWFECHA 
		FROM DUAL;
		
		-- CALCULA EL TC PARA ESE MES
		SP_PROYECCIONTC1MES(PNUMVALREALES, NEWFECHA, 'DOLAR', 'COLON', PMONTO);
		
		CONTA := CONTA + 1;
	END LOOP;
END;


/


create or replace PROCEDURE SP_PROYECCIONGENERAR (
	PDESCLISTAPRECIO IN VARCHAR2,
	PNUMMESES IN NUMBER,
	PRESP OUT VARCHAR2
) IS
    -- Define variables utilizadas para los calculos
    PORC1 number(3);
    PORC2 number(3);
    PORC3 number(3);
    SUMPORC NUMBER(3);
    SBTPORC NUMBER(17,2);
    ARTICULO REF ARTICULO_TYPE;
    ARTIC ARTICULO_TYPE;
	
    MONTOTC NUMBER(17,2);
    SBTPRECIOART NUMBER(17,2);
    TPRECIOART NUMBER(17,2);
    MES NUMBER(2);
    ANIO NUMBER(4);
    CONTA NUMBER(5);
    NEWFECHA DATE;
    FECHAACTUAL DATE;
    -- OBTENER LOS PRECIOS DE LOS ARTICULOS ASOCIADOS A LA LISTA DE PRECIOS 
    -- CURSOR DE PRECIO DE ARTICULOS
	CURSOR CURPRECIOARTIC IS
    SELECT ARTICULO FROM TABLE(
      SELECT
        LPT.LISTA_ARTICULOS
      FROM LISTAS_PRECIOS_TABLE LPT
      WHERE LPT.DESCRIPCION = PDESCLISTAPRECIO
    );
  
  

BEGIN

	-- OBTENER LOS PORCENTAJES DE LA LISTA DE PRECIO
	SELECT
		LPT.GASTOADMIN, LPT.GASTOOTROS, LPT.UTILIDAD INTO PORC1, PORC2, PORC3
	FROM LISTAS_PRECIOS_TABLE LPT
	WHERE LPT.DESCRIPCION = PDESCLISTAPRECIO;

    -- CALCULAR TOTAL DE PORCENTAJES
    SUMPORC := PORC1 + PORC2 + PORC3;
    SBTPORC := SUMPORC / 100;
    SBTPORC := SBTPORC + 1;
        CONTA := 0;

    -- PARA CADA ARTICULO EN EL CURSOR, CALCULAR SU PRECIO
    OPEN CURPRECIOARTIC;
    LOOP
      -- EXTRAE DATOS DEL ARTICULO
      FETCH CURPRECIOARTIC INTO ARTICULO;
      IF (CURPRECIOARTIC%FOUND) THEN
	  
        -- INICIALIZA CALCULO DE PRECIO PARA LA CANTIDAD DE MESES ESPECIFICADA
        FECHAACTUAL := SYSDATE;
        WHILE (CONTA < PNUMMESES)
        LOOP
          -- INCREMENTA UN MES
          --SELECT 
           NEWFECHA := ADD_MONTHS(sysdate,CONTA); --INTO NEWFECHA --////AQUI ESTA EL ERROR
         -- FROM DUAL;
          -- OBTENER EL MONTO DE TIPO DE CAMBIO PARA ESE MES
          SP_OBTENERTC(NEWFECHA, MONTOTC);
          -- CALCULAR SUBTOTAL DEL PRECIO DEL ARTICULO
          SELECT DEREF(ARTICULO) INTO ARTIC FROM DUAL;
          SBTPRECIOART := MONTOTC * ARTIC.PRECIOMERCDOLARES;
          -- CALCULAR TOTAL DEL PRECIO DEL ARTICULO (APLICA PORCENTAJES)
          TPRECIOART := SBTPRECIOART * (1 + SBTPORC);
          
         
			INSERT INTO PROYECCIONES_TABLE VALUES (
				NEWFECHA,
				ARTICULO,
				(SELECT REF(P) FROM LISTAS_PRECIOS_TABLE P WHERE P.DESCRIPCION = PDESCLISTAPRECIO),
				MONTOTC,
				TPRECIOART
			);
          -- SIGUE CON EL SIGUIENTE MES DEL MISMO ARTICULO
          CONTA := CONTA + 1;
        END LOOP;
      END IF;
	  
    EXIT WHEN CURPRECIOARTIC %NOTFOUND;
    END LOOP;

END;

-- --------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------

