FUNCTION /sprolims/fm_status_update.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IV_STATUS) TYPE  CHAR6
*"     REFERENCE(IV_OBJNR) TYPE  QMOBJNR
*"  EXPORTING
*"     REFERENCE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA: lt_jest_ins TYPE TABLE OF jest_upd,
        lt_jest_upd TYPE TABLE OF jest_upd,
        lt_jsto_upd TYPE TABLE OF jsto_upd,
        lt_jsto_ins TYPE TABLE OF jsto,
        lt_obj_del  TYPE TABLE OF onr00.

  DATA: lw_jest_aux TYPE jest_upd,
        lw_jest_ins TYPE jest_upd,
        lw_return   TYPE bapiret2.

  DATA: lv_itcode TYPE cdtcode,
        lv_error  TYPE string.

  lw_jest_ins-objnr = iv_objnr.
  lw_jest_ins-stat  = iv_status.
  lw_jest_ins-chgnr = '001'.

  APPEND lw_jest_ins TO lt_jest_ins.
  CLEAR lw_jest_ins.

  lv_itcode =  iv_objnr.

  CALL FUNCTION 'STATUS_UPDATE'
    EXPORTING
      i_tcode  = lv_itcode
    TABLES
      jest_ins = lt_jest_ins
      jest_upd = lt_jest_upd
      jsto_ins = lt_jsto_ins
      jsto_upd = lt_jsto_upd
      obj_del  = lt_obj_del.

   IF sy-subrc = 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
  ELSE.
      lw_return-id      = 'SPROLIMS'.
      lw_return-number  = '001'.
      lw_return-type    = 'E'.
      lw_return-message = 'Erro ao tentar atulizar status'.

      APPEND lw_return TO et_return.
      CLEAR lw_return.

    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  ENDIF.



ENDFUNCTION.
