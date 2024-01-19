FUNCTION /sprolims/fm_collect_delete.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_COLLECT_ID) TYPE  WARPL
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: lt_jest_aux TYPE TABLE OF jest,
        lt_jest_ins TYPE TABLE OF jest_upd,
        lt_jest_upd TYPE TABLE OF jest_upd,
        lt_jsto_upd TYPE TABLE OF jsto_upd,
        lt_jsto_ins TYPE TABLE OF jsto,
        lt_obj_del  TYPE TABLE OF onr00.

  DATA: lw_jest_aux TYPE jest_upd,
        lw_jest_ins TYPE jest_upd,
        lw_return   TYPE bapiret2.

  DATA: lv_itcode TYPE cdtcode,
        lv_error  TYPE string.

  " CHECK AUTH
  CALL FUNCTION '/SPROLIMS/FM_COLLECT_CH_AU'
    EXPORTING
      iv_collect_id = iv_collect_id
    IMPORTING
      et_return     = et_return
      ev_error      = lv_error.

   IF lv_error EQ 'Y'.
    return.
  ENDIF.

  "CHECK EDIT
  CALL FUNCTION '/SPROLIMS/FM_COLLECT_CH_ED'
    EXPORTING
      iv_collect_id = iv_collect_id
    IMPORTING
      et_return     = et_return
      ev_error      = lv_error.


  IF lv_error EQ 'Y'.
    return.
  ENDIF.

  SELECT SINGLE *
    FROM mpla
    INTO @DATA(lw_mpla)
    WHERE  warpl =  @iv_collect_id.

  lw_jest_ins-objnr = lw_mpla-objnr.
  lw_jest_ins-stat  = 'I0076'.
  lw_jest_ins-chgnr = '001'.

  APPEND lw_jest_ins TO lt_jest_ins.
  CLEAR lw_jest_ins.

  lv_itcode = lw_mpla-objnr.

  CALL FUNCTION 'STATUS_UPDATE'
    EXPORTING
      i_tcode  = lv_itcode
    TABLES
      jest_ins = lt_jest_ins
      jest_upd = lt_jest_upd
      jsto_ins = lt_jsto_ins
      jsto_upd = lt_jsto_upd
      obj_del  = lt_obj_del.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

ENDFUNCTION.
