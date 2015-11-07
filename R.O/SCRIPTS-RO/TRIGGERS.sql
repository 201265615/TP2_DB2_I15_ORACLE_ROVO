-------------------------------------------------------------------------------------------------
------------------------COTIZACIONES-------------------------------------------------------------
-------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------
---GUARDA EN LA BITACORA DE COTIZACIONES
---ANTES DE ELIMINAR UNA COTIZACION
CREATE OR REPLACE TRIGGER BEF_DEL_ELIMINARCOTIZACION 
BEFORE DELETE ON COTIZACION_TABLE
FOR EACH ROW

DECLARE 
EMPRESA_OLD NUMBER(10);
ESTADOCOTIZACION_OLD VARCHAR(10);
MONEDA_OLD VARCHAR(10);
BEGIN
  

  SELECT CEDULAJURIDICA INTO EMPRESA_OLD FROM EMPRESAS_TABLE WHERE CEDULAJURIDICA = DEREF(:OLD.EMPRESA).CEDULAJURIDICA;
  
  SELECT DESCRIPCION INTO ESTADOCOTIZACION_OLD FROM ESTADOS_COTIZACIONES_TABLE WHERE DESCRIPCION = DEREF(:OLD.CODESTADOCOTIZ).DESCRIPCION;
  
  SELECT DESCRIPCION INTO MONEDA_OLD FROM MONEDAS_TABLE WHERE DESCRIPCION = DEREF(:OLD.MONEDA1).DESCRIPCION;
  

  INSERT INTO COTIZACION_HISTO_TABLE VALUES (
    :OLD.NUMERO,
    :OLD.FECHAREGISTRO,
    EMPRESA_OLD,
    :OLD.CONDICIONPAGO,
    :OLD.CONDICIONVENTA,
    :OLD.VIGENCIA,
    :OLD.OBSERVACIONES,
    MONEDA_OLD,
    ESTADOCOTIZACION_OLD,
    :OLD.FECHA
    );
                              
END;




-------------------------------------------------------------------------------------------------
------------------------FACTURAS-------------------------------------------------------------
-------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------
---ACTUALIZA PRECIOS Y CANTIDADES DE ARTICULOS
---DESPUES DE INSERTAR UNA LINEA EN UNA FACTURA
CREATE OR REPLACE TRIGGER PR2_AFT_INS_PFact_UpdIn_Artic AFTER INSERT OR UPDATE
ON FACTURAS_TABLE FOR EACH ROW

DECLARE 
     COD ARTICULO_TYPE;

BEGIN

    IF (:OLD.LISTA_LINEASFACTURA IS NOT NULL) THEN
        FOR i IN :OLD.LISTA_LINEASFACTURA.FIRST..:OLD.LISTA_LINEASFACTURA.LAST LOOP
       IF( :OLD.LISTA_LINEASFACTURA(i) IS NOT NULL) THEN  
       SELECT DEREF(:OLD.LISTA_LINEASFACTURA(i).ARTICULO) INTO COD FROM DUAL;
            UPDATE ARTICULOS_TABLE 
                SET CANTIDAD = CANTIDAD + :OLD.LISTA_LINEASFACTURA(i).CANTIDAD,
                      PRECIOMERCDOLARES = :OLD.LISTA_LINEASFACTURA(i).PRECIO,
                      FECHAACTPRECIO = SYSDATE
                      WHERE CODIGO = COD.CODIGO;
                      END IF;
                     
        END LOOP;
    END IF;
END;