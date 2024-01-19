FUNCTION /sprolims/fm_conf_cancel.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IW_GW_CONF_CANCEL) TYPE  /SPROLIMS/ST_GW_CONF_CANCEL
*"  EXPORTING
*"     VALUE(EW_RETURN) TYPE  BAPIRET2
*"     VALUE(EW_GW_CONF_CANCEL) TYPE  /SPROLIMS/ST_GW_CONF_CANCEL
*"----------------------------------------------------------------------

  DATA: lv_conf_cnt LIKE iw_gw_conf_cancel-conf_cnt,
        lv_wait     LIKE  bapita-wait VALUE '1'.

  ew_gw_conf_cancel = iw_gw_conf_cancel.

  IF iw_gw_conf_cancel-initial IS INITIAL.

    SELECT SINGLE MAX( rmzhl )
      FROM afru
      INTO lv_conf_cnt
      WHERE rueck = iw_gw_conf_cancel-conf_no AND
            stokz = '' AND
            stzhl = ''.

  ELSE.

    SELECT SINGLE MIN( rmzhl )
      FROM afru
      INTO lv_conf_cnt
      WHERE rueck = iw_gw_conf_cancel-conf_no AND
            stokz = '' AND
            stzhl = ''.
  ENDIF.

  CALL FUNCTION 'BAPI_ALM_CONF_CANCEL'
    EXPORTING
      confirmation        = iw_gw_conf_cancel-conf_no
      confirmationcounter = lv_conf_cnt
    IMPORTING
      return              = ew_return
      locked              = ew_gw_conf_cancel-locked
      created_conf_no     = ew_gw_conf_cancel-conf_no
      created_conf_count  = ew_gw_conf_cancel-conf_cnt.

  IF ew_return-type <> 'E'.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = lv_wait.

    IF sy-subrc = 0.
      ew_gw_conf_cancel = iw_gw_conf_cancel.
    ENDIF.
  ENDIF.

  WAIT UP TO 2 SECONDS.

ENDFUNCTION.
