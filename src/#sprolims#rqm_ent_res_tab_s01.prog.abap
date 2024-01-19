*&---------------------------------------------------------------------*
*& Include          ZRQM_ENTRADA_RESULTADO_TAB_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-s01.
  SELECT-OPTIONS: s_data FOR qamv-erstelldat OBLIGATORY,
                  s_cent FOR aufk-werks NO INTERVALS OBLIGATORY,
                  s_orde FOR aufk-aufnr NO INTERVALS MATCHCODE OBJECT /SPROLIMS/HQM_ORDEM,
                  s_oper FOR afvc-vornr NO INTERVALS,
                  s_wkce FOR crhd-arbpl NO INTERVALS MATCHCODE OBJECT /SPROLIMS/HQM_CENTRO_TRAB,
                  s_samp FOR /SPROLIMS/ZCDSQR-sample_number NO INTERVALS MATCHCODE OBJECT /SPROLIMS/HQM_AMOSTRA .
SELECTION-SCREEN END OF BLOCK b1.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-s02.
  PARAMETERS: sp_vari LIKE disvariant-variant.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-s03.
  PARAMETERS: sp_perf type flag DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b3.

INITIALIZATION.

  gv_repname = sy-repid.

* Initialize ALV Layout variant
  PERFORM f_initialize_variant.

FORM f_initialize_variant .

  CLEAR gv_variant.
  gv_save           = 'X'.
  gv_variant-report = gv_repname.
  gv_x_variant      = gv_variant.

  CALL FUNCTION 'REUSE_ALV_VARIANT_DEFAULT_GET'
    EXPORTING
      i_save     = gv_save
    CHANGING
      cs_variant = gv_x_variant
    EXCEPTIONS
      not_found  = 2.

  IF sy-subrc = 0.

    sp_vari = gv_x_variant-variant.

  ENDIF.

ENDFORM.                    " f_initialize_variant

AT SELECTION-SCREEN ON VALUE-REQUEST FOR sp_vari.
  PERFORM f_f4_for_variant.

FORM f_f4_for_variant .
  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant = gv_variant
      i_save     = gv_save
    IMPORTING
      e_exit     = gv_exit
      es_variant = gv_x_variant
    EXCEPTIONS
      not_found  = 2.

  IF sy-subrc = 2.
    MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    IF gv_exit = space.
      sp_vari = gv_x_variant-variant.
    ENDIF.
  ENDIF.

ENDFORM.                    " f_f4_for_variant

AT SELECTION-SCREEN.

*  Validating selection screen fields
  PERFORM f_at_selection_screen.

FORM f_at_selection_screen .

* ALV Layout variant
  IF NOT sp_vari IS INITIAL.

    MOVE gv_variant TO gv_x_variant.
    MOVE sp_vari    TO gv_x_variant-variant.

    CALL FUNCTION 'REUSE_ALV_VARIANT_EXISTENCE'
      EXPORTING
        i_save     = gv_save
      CHANGING
        cs_variant = gv_x_variant.
    gv_variant = gv_x_variant.

  ELSE.

    PERFORM f_initialize_variant.

  ENDIF.
ENDFORM.
