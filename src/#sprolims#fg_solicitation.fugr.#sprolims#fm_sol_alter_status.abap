FUNCTION /sprolims/fm_sol_alter_status.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_SOLICITATION_ID) TYPE  QMNUM
*"     VALUE(IV_INACTIVE) TYPE  CHAR1
*"     VALUE(IV_STATUS) TYPE  CHAR6
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA: lw_usr_status TYPE bapi2080_notusrstati,
        lw_return     LIKE LINE OF et_return.

  DATA: lv_systemstatus LIKE  bapi2080_notadt-systatus,
        lv_userstatus   LIKE  bapi2080_notadt-usrstatus,
        lv_number       TYPE  bapi2080_nothdre-notif_no.

  lw_usr_status-status_int  = iv_status.
  lw_usr_status-langu       = sy-langu.
  lv_number                 = |{ iv_solicitation_id ALPHA = IN }|.

  CALL FUNCTION 'BAPI_ALM_NOTIF_CHANGEUSRSTAT'
    EXPORTING
      number       = lv_number
      usr_status   = lw_usr_status
      set_inactive = iv_inactive
    IMPORTING
      systemstatus = lv_systemstatus
      userstatus   = lv_userstatus
    TABLES
      return       = et_return.

  IF sy-subrc = 0.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' .

    SELECT  SINGLE *
      FROM qmel
      INTO @DATA(lw_qmel)
      WHERE qmnum = @iv_solicitation_id.

      CALL FUNCTION '/SPROLIMS/FM_STATUS_UPDATE'
        EXPORTING
            IV_OBJNR = LW_QMEL-OBJNR
            IV_STATUS = 'I0076'
        IMPORTING
            ET_RETURN = ET_RETURN.
            endif.

    ENDFUNCTION.
