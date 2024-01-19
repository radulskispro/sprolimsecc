FUNCTION /SPROLIMS/FM_SH_TWTB.
*"--------------------------------------------------------------------
*"*"Interface local:
*"  TABLES
*"      SHLP_TAB TYPE  SHLP_DESCT
*"      RECORD_TAB STRUCTURE  SEAHLPRES
*"  CHANGING
*"     REFERENCE(SHLP) TYPE  SHLP_DESCR
*"     REFERENCE(CALLCONTROL) TYPE  DDSHF4CTRL
*"--------------------------------------------------------------------


  DATA: lt_charact     TYPE TABLE OF bapi_char,
        lt_char_values TYPE TABLE OF bapi_char_values.

  DATA: lr_codegruppe TYPE RANGE OF qpgr-codegruppe,
        lr_kurztext   TYPE RANGE OF qpgt-kurztext.

  DATA: lw_codegruppe LIKE LINE OF lr_codegruppe,
        lw_kurztext   LIKE LINE OF lr_kurztext.

  IF callcontrol-step = 'SELECT' OR
     callcontrol-step = 'DISP'.

    CLEAR record_tab[].

    LOOP AT shlp-selopt INTO DATA(lw_selopt).

      CASE lw_selopt-shlpfield.
        WHEN 'DESCR'.
          CLEAR lw_codegruppe.
          MOVE-CORRESPONDING lw_selopt TO lw_codegruppe.
          APPEND lw_codegruppe TO lr_codegruppe.
      ENDCASE.

    ENDLOOP.

*    DATA(lt_param) = zclpp_meat_util=>is_cad_proc( EXPORTING i_zobjetos = 'ZFMQM_F4_ATWTB' ).
*    IF sy-subrc = 0.
*
*      READ TABLE lt_param INTO DATA(lw_param) INDEX 1.
*
*      CALL FUNCTION 'BAPI_CLASS_GET_CHARACTERISTICS'
*        EXPORTING
*          classnum        = CONV bapi_class_key-classnum( lw_param-zvalor )
*          classtype       = '001'
*        TABLES
*          characteristics = lt_charact
*          char_values     = lt_char_values.
*
*      LOOP AT lt_char_values INTO DATA(lw_char_val) WHERE name_char = lw_param-zvalorcomp.
*        record_tab-string = lw_char_val-descr_cval.
*        APPEND record_tab.
*      ENDLOOP.
*
*    ENDIF.

  ENDIF.
ENDFUNCTION.
