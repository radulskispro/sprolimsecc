FUNCTION /sprolims/fm_sh_metod.
*"--------------------------------------------------------------------
*"*"Interface local:
*"  TABLES
*"      SHLP_TAB TYPE  SHLP_DESCT
*"      RECORD_TAB STRUCTURE  SEAHLPRES
*"  CHANGING
*"     REFERENCE(SHLP) TYPE  SHLP_DESCR
*"     REFERENCE(CALLCONTROL) TYPE  DDSHF4CTRL
*"--------------------------------------------------------------------


  DATA: lr_codegruppe TYPE RANGE OF qpgr-codegruppe,
        lr_kurztext   TYPE RANGE OF qpgt-kurztext,
        lr_katalogart TYPE RANGE OF qpgt-katalogart.

  DATA: lw_codegruppe LIKE LINE OF lr_codegruppe,
        lw_kurztext   LIKE LINE OF lr_kurztext,
        lw_katalogart LIKE LINE OF lr_katalogart.

  DATA: lv_metod TYPE char12.

  IF callcontrol-step = 'SELECT' OR
     callcontrol-step = 'DISP'.

    CLEAR record_tab[].

    LOOP AT shlp-selopt INTO DATA(lw_selopt).

      CASE lw_selopt-shlpfield.
        WHEN 'CODEGRUPPE'.
          CLEAR lw_codegruppe.
          MOVE-CORRESPONDING lw_selopt TO lw_codegruppe.
          APPEND lw_codegruppe TO lr_codegruppe.
        WHEN 'KURZTEXT'.
          CLEAR lw_kurztext.
          MOVE-CORRESPONDING lw_selopt TO lw_kurztext.
          APPEND lw_kurztext TO lr_kurztext.
        WHEN 'KATALOGART'.
          CLEAR lw_katalogart.
          MOVE-CORRESPONDING lw_selopt TO lw_katalogart.
          APPEND lw_katalogart TO lr_katalogart.
      ENDCASE.

    ENDLOOP.

    SELECT *
      FROM /sprolims/tb_cf1
      INTO TABLE @DATA(lt_cf1).

    CHECK sy-subrc = 0.

    SELECT *
      FROM tq80
      INTO TABLE @DATA(lt_tq80)
      FOR ALL ENTRIES IN @lt_cf1
      WHERE qmart = @lt_cf1-qmart.

    CHECK sy-subrc = 0.

    SELECT *
      FROM qpcd
      INTO TABLE @DATA(lt_qpcd)
      FOR ALL ENTRIES IN @lt_tq80
      WHERE katalogart  = @lt_tq80-makat.

    CHECK sy-subrc = 0.

    SELECT *
      FROM qpct
      INTO TABLE @DATA(lt_qpct)
       FOR ALL ENTRIES IN @lt_qpcd
     WHERE katalogart = @lt_qpcd-katalogart
       AND codegruppe = @lt_qpcd-codegruppe
       AND kurztext  IN @lr_kurztext
       AND sprache    = @sy-langu.

    SELECT *
      FROM qpgt
      INTO TABLE @DATA(lt_qpgt)
      FOR ALL ENTRIES IN @lt_qpcd
     WHERE katalogart = @lt_qpcd-katalogart
       AND codegruppe = @lt_qpcd-codegruppe
       AND kurztext  IN @lr_kurztext
       AND sprache    = @sy-langu.

    LOOP AT lt_qpcd INTO DATA(lw_qpcd).
      READ TABLE lt_qpct INTO DATA(lw_qpct) WITH KEY katalogart = lw_qpcd-katalogart
                                                     codegruppe = lw_qpcd-codegruppe
                                                     code       = lw_qpcd-code.

      READ TABLE lt_qpgt INTO DATA(lw_qpgt) WITH KEY katalogart = lw_qpcd-katalogart
                                                     codegruppe = lw_qpcd-codegruppe.

      CLEAR lv_metod.

      CONCATENATE lw_qpcd-codegruppe lw_qpcd-code INTO lv_metod.

      CONCATENATE lv_metod lw_qpcd-katalogart lw_qpcd-codegruppe lw_qpcd-code lw_qpgt-kurztext lw_qpct-kurztext INTO record_tab-string RESPECTING BLANKS.

      APPEND record_tab.

    ENDLOOP.

  ENDIF.


ENDFUNCTION.
