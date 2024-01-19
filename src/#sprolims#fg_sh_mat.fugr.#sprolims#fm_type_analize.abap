FUNCTION /SPROLIMS/FM_TYPE_ANALIZE.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  TABLES
*"      SHLP_TAB TYPE  SHLP_DESCT
*"      RECORD_TAB STRUCTURE  SEAHLPRES
*"  CHANGING
*"     REFERENCE(SHLP) TYPE  SHLP_DESCR
*"     REFERENCE(CALLCONTROL) TYPE  DDSHF4CTRL
*"----------------------------------------------------------------------


  DATA: lv_analyse_type TYPE char12.

  IF callcontrol-step = 'SELECT' OR
     callcontrol-step = 'DISP'.

    CLEAR record_tab[].

    SELECT *
     FROM qpcd
     INTO TABLE @DATA(lt_qpcd)
    WHERE katalogart  = 'X'.

    SELECT *
        FROM qpct
        INTO TABLE @DATA(lt_qpct)
         FOR ALL ENTRIES IN @lt_qpcd
       WHERE katalogart = @lt_qpcd-katalogart
         AND codegruppe = @lt_qpcd-codegruppe
         AND sprache    = @sy-langu.

    LOOP AT lt_qpcd INTO DATA(lw_qpcd).
      READ TABLE lt_qpct INTO DATA(lw_qpct) WITH KEY katalogart   = lw_qpcd-katalogart
                                                       codegruppe = lw_qpcd-codegruppe
                                                       code       = lw_qpcd-code.
      CLEAR lv_analyse_type.

      CONCATENATE lw_qpcd-codegruppe lw_qpcd-code INTO lv_analyse_type.

      CONCATENATE lv_analyse_type lw_qpcd-katalogart lw_qpcd-codegruppe lw_qpcd-code lw_qpct-KURZTEXT INTO record_tab-string RESPECTING BLANKS.

      APPEND record_tab.

    ENDLOOP.

  ENDIF.





ENDFUNCTION.
