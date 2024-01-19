FUNCTION /sprolims/fm_sh_lista_tarefa.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  TABLES
*"      SHLP_TAB TYPE  SHLP_DESCT
*"      RECORD_TAB STRUCTURE  SEAHLPRES
*"  CHANGING
*"     REFERENCE(SHLP) TYPE  SHLP_DESCR
*"     REFERENCE(CALLCONTROL) TYPE  DDSHF4CTRL
*"----------------------------------------------------------------------


  DATA: lr_plnnr TYPE RANGE OF plko-plnnr,
        lr_plnal TYPE RANGE OF plko-plnal,
        lr_ktext TYPE RANGE OF plko-ktext.

  DATA: lw_plnnr LIKE LINE OF lr_plnnr,
        lw_plnal LIKE LINE OF lr_plnal,
        lw_ktext LIKE LINE OF lr_ktext.

  DATA: lv_lista TYPE /sprolims/de_ltconf.

  IF callcontrol-step = 'SELECT' OR
     callcontrol-step = 'DISP'.

    CLEAR record_tab[].

    LOOP AT shlp-selopt INTO DATA(lw_selopt).

      CASE lw_selopt-shlpfield.
        WHEN 'PLNNR'.
          CLEAR lw_plnnr.
          MOVE-CORRESPONDING lw_selopt TO lw_plnnr.
          APPEND lw_plnnr TO lr_plnnr.
        WHEN 'PLNAL'.
          CLEAR lw_plnal.
          MOVE-CORRESPONDING lw_selopt TO lw_plnal.
          APPEND lw_plnal TO lr_plnal.
      ENDCASE.

    ENDLOOP.

    SELECT *
      FROM plko
      INTO TABLE @DATA(lt_plko)
     WHERE plnnr IN @lr_plnnr
       AND plnal IN @lr_plnal
       AND plnty  = 'A'.

    LOOP AT lt_plko INTO DATA(lw_plko).

      CLEAR lv_lista.
      PACK lw_plko-plnnr TO lw_plko-plnnr.
      CONDENSE lw_plko-plnnr NO-GAPS.
      CONCATENATE lw_plko-plnnr lw_plko-plnal INTO lv_lista SEPARATED BY '/'.
      CONCATENATE lv_lista lw_plko-plnnr lw_plko-plnal lw_plko-ktext INTO record_tab-string RESPECTING BLANKS.

      APPEND record_tab.
    ENDLOOP.

  ENDIF.


ENDFUNCTION.
