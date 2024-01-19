*&---------------------------------------------------------------------*
*&  Include  /SPROLIMS/IC_ZXQQMI10_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  GET_KURZTEXT  INPUT
*&---------------------------------------------------------------------*
MODULE get_kurztext INPUT.

  SELECT SINGLE kurztext
    FROM qpgt
    INTO qpgt-kurztext
     WHERE katalogart  = qmel-/sprolims/otkat
       AND codegruppe  = qmel-/sprolims/otgrp
       AND sprache     = sy-langu.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  GET_KURZTEXT_CAT  INPUT
*&---------------------------------------------------------------------*
MODULE get_kurztext_cat INPUT.

  SELECT SINGLE kurztext
    FROM qpgt
    INTO tx_kurztext_cat
     WHERE katalogart  = qmel-otkat_categ
       AND codegruppe  = qmel-otgrp_categ
       AND sprache     = sy-langu.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  GET_TEXT_TANQUE  INPUT
*&---------------------------------------------------------------------*
MODULE get_text_tanque INPUT.

  SELECT SINGLE eqktx
    FROM eqkt
    INTO tx_text_tanque
     WHERE equnr = qmel-tanque_dest
       AND spras = sy-langu.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  GET_AUFNR_CHARG  INPUT
*&---------------------------------------------------------------------*
MODULE get_text_local INPUT.

  SELECT SINGLE pltxt
    FROM iflotx
    INTO tx_text_local
     WHERE tplnr = qmel-local_coleta
       AND spras = sy-langu.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  GET_AUFNR_CHARG  INPUT
*&---------------------------------------------------------------------*
MODULE get_aufnr_charg INPUT.

  IF qmel-werk IS NOT INITIAL.

    IF  qmel-prod_aufnr IS NOT INITIAL AND
        qmel-prod_charg IS INITIAL.

      SELECT SINGLE charg
        FROM afpo
        INTO qmel-prod_charg
        WHERE aufnr = qmel-prod_aufnr
          AND dwerk = qmel-werk.

    ELSEIF  qmel-prod_aufnr IS INITIAL AND
            qmel-prod_charg IS NOT INITIAL.

      SELECT SINGLE aufnr
        FROM afpo
        INTO qmel-prod_aufnr
        WHERE charg = qmel-prod_charg
          AND dwerk = qmel-werk.

    ENDIF.

  ENDIF.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  GET_KURZTEXT_GEBINDETYP  INPUT
*&---------------------------------------------------------------------*
MODULE get_kurztext_gebindetyp INPUT.

  SELECT SINGLE kurztext
    FROM tq42t
    INTO tq42t-kurztext
    WHERE gebindetyp = qmel-gebindetyp
    AND sprache = sy-langu.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  GET_KTEXT_KOSTL  INPUT
*&---------------------------------------------------------------------*
MODULE get_ktext_kostl INPUT.

  SELECT SINGLE ktext
    FROM cskt
    INTO cskt-ktext
    WHERE kostl = qmel-prod_kostl
    AND spras = sy-langu.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALUE_REQUEST_OTEIL  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE value_request_oteil INPUT.

  TYPES: BEGIN OF ys_sh,
           otgrp       TYPE /sprolims/tccodp-otgrp,
           descr_otgrp TYPE /sprolims/tccode-descr_otgrp,
           oteil       TYPE /sprolims/tccodp-oteil,
           descr_oteil TYPE /sprolims/tccodp-descr_oteil,
         END OF ys_sh.

  DATA: lt_sh  TYPE TABLE OF ys_sh,
        ls_sh  TYPE ys_sh,
        lt_map TYPE TABLE OF dselc,
        ls_map TYPE dselc.

  CLEAR: lt_sh.

  SELECT  ccode~otgrp, ccode~descr_otgrp,
          ccodp~oteil, ccodp~descr_oteil
    FROM  /sprolims/tccodp AS ccodp
            LEFT JOIN
          /sprolims/tccode AS ccode
              ON  ccode~otgrp = ccodp~otgrp
    INTO TABLE @lt_sh
    WHERE ccode~otkat = '2'.

  CLEAR lt_map.

  CLEAR ls_map.
  ls_map-fldname = 'F0001'.
  ls_map-dyfldname = 'QMEL-/SPROLIMS/OTGRP'.
  APPEND ls_map TO lt_map.


  CLEAR ls_map.
  ls_map-fldname = 'F0003'.
  ls_map-dyfldname = 'QMEL-/SPROLIMS/OTEIL'.
  APPEND ls_map TO lt_map.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'OTGRP'
      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = 'QMEL-/SPROLIMS/OTGRP'
      value_org       = 'S'
    TABLES
      value_tab       = lt_sh
      dynpfld_mapping = lt_map
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALUE_REQUEST_CATEG  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE value_request_categ INPUT.

  CLEAR: lt_sh.

  SELECT  ccode~otgrp, ccode~descr_otgrp,
          ccodp~oteil, ccodp~descr_oteil
    FROM  /sprolims/tccodp AS ccodp
            LEFT JOIN
          /sprolims/tccode AS ccode
              ON  ccode~otgrp = ccodp~otgrp
    INTO TABLE @lt_sh
    WHERE ccode~otkat = '1'.

  CLEAR lt_map.

  CLEAR ls_map.
  ls_map-fldname = 'F0001'.
  ls_map-dyfldname = 'QMEL-OTGRP_CATEG'.
  APPEND ls_map TO lt_map.



  CLEAR ls_map.
  ls_map-fldname = 'F0003'.
  ls_map-dyfldname = 'QMEL-OTEIL_CATEG'.
  APPEND ls_map TO lt_map.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'OTGRP'
      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = 'QMEL-OTGRP_CATEG'
      value_org       = 'S'
    TABLES
      value_tab       = lt_sh
      dynpfld_mapping = lt_map
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALUE_REQUEST_CICLO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE value_request_ciclo INPUT.

  SELECT cycnr
    FROM /sprolm/tb_cycle
    INTO TABLE @DATA(tl_cicle)
    WHERE werks = @qmel-werk.

  DATA: lt_return TYPE TABLE OF ddshretval.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = '/SPROLM/DE_CYCNR'
      window_title    = 'Ciclo'
      value_org       = 'S'
    TABLES
      value_tab       = tl_cicle
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  IF ( sy-subrc IS INITIAL AND lt_return[] IS NOT INITIAL ).

    READ TABLE lt_return INTO DATA(lw_return) INDEX 1.
    IF ( sy-subrc IS INITIAL ).
      qmel-ciclo = lw_return-fieldval.
    ENDIF.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALUE_REQUEST_SEXO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE value_request_sexo INPUT.

*  SELECT gesch, txt40
*    FROM /spmeat/tslp_axt
*    INTO TABLE @DATA(tl_tslp_axt)
*   WHERE spras = @sy-langu.

  TYPES: BEGIN OF ly_tslp_axt,
           gesch TYPE qmel-sexo,
           spras TYPE spras,
           txt40 TYPE  txt40,
         END OF ly_tslp_axt.

  DATA: lt_returns  TYPE TABLE OF ddshretval,
        tl_tslp_axt TYPE TABLE OF ly_tslp_axt.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'GESCH'
      window_title    = 'Sexo'
      value_org       = 'S'
    TABLES
      value_tab       = tl_tslp_axt
      return_tab      = lt_returns
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  IF ( sy-subrc IS INITIAL AND lt_returns[] IS NOT INITIAL ).

    READ TABLE lt_returns INTO DATA(lw_returns) INDEX 1.
    IF ( sy-subrc IS INITIAL ).
      qmel-sexo = lw_returns-fieldval.
    ENDIF.

  ENDIF.
ENDMODULE.
