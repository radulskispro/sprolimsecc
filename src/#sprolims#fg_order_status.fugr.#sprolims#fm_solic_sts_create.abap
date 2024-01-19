FUNCTION /sprolims/fm_solic_sts_create.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IW_SOLIC_STATUS) TYPE  /SPROLIMS/ST_GW_SOL_STS_UPDATE
*"  EXPORTING
*"     VALUE(EW_SOLIC_STATUS) TYPE  /SPROLIMS/ST_GW_SOL_STS_UPDATE
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------


  DATA: lw_usr_status TYPE bapi2080_notusrstati,
        lw_return     LIKE LINE OF et_return.

  DATA: lv_systemstatus LIKE  bapi2080_notadt-systatus,
        lv_userstatus   LIKE  bapi2080_notadt-usrstatus,
        lv_number       TYPE  bapi2080_nothdre-notif_no.

  IF iw_solic_status IS NOT INITIAL.

    CLEAR lw_usr_status.

    IF iw_solic_status-txt04 IS NOT INITIAL.

      lw_usr_status-status_ext  = iw_solic_status-txt04.

    ELSEIF iw_solic_status-stat IS NOT INITIAL.

      lw_usr_status-status_int  = iw_solic_status-stat.

    ENDIF.

    lw_usr_status-langu       = sy-langu.
    lv_number                 = |{ iw_solic_status-objnr ALPHA = IN }|.

    CALL FUNCTION 'BAPI_ALM_NOTIF_CHANGEUSRSTAT'
      EXPORTING
        number       = lv_number
        usr_status   = lw_usr_status
        set_inactive = iw_solic_status-inact
      IMPORTING
        systemstatus = lv_systemstatus
        userstatus   = lv_userstatus
      TABLES
        return       = et_return.

    IF sy-subrc = 0.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' .

      IF sy-subrc = 0.

        ew_solic_status = iw_solic_status.

        lw_return-type        = 'S'.
        lw_return-id          = '/SPROLIMS/MC_STATUS'.
        lw_return-number      = '001'.
        lw_return-message_v1  = lw_return-message_v2  = lw_return-message_v3  = lw_return-message_v4  = ''.

        MESSAGE ID '/SPROLIMS/MC_STATUS' TYPE 'S' NUMBER '001'
          WITH   '' '' '' ''
          INTO   lw_return-message.

        APPEND lw_return TO et_return.

      ENDIF.

    ENDIF.

  ENDIF.

ENDFUNCTION.
