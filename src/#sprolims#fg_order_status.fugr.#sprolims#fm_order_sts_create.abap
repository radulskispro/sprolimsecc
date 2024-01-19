FUNCTION /sprolims/fm_order_sts_create.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IW_ORDER_STATUS) TYPE  /SPROLIMS/ST_GW_ORD_STS_UPDATE
*"  EXPORTING
*"     VALUE(EW_ORDER_STATUS) TYPE  /SPROLIMS/ST_GW_ORD_STS_UPDATE
*"     VALUE(EW_RETURN) LIKE  BAPIRET2 STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------

  DATA: lv_stonr TYPE tj30-stonr.

  IF iw_order_status IS NOT INITIAL.

    CALL FUNCTION 'STATUS_CHANGE_EXTERN'
      EXPORTING
        client              = sy-mandt
        objnr               = iw_order_status-objnr
        user_status         = iw_order_status-stat
        set_inact           = iw_order_status-inact
        set_chgkz           = iw_order_status-chgkz
        no_check            = iw_order_status-no_check
      IMPORTING
        stonr               = lv_stonr
      EXCEPTIONS
        object_not_found    = 1
        status_inconsistent = 2
        status_not_allowed  = 3
        OTHERS              = 4.

    IF sy-subrc = 0.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        IMPORTING
          return = ew_return.

      IF sy-subrc = 0.
        ew_order_status = iw_order_status.

        ew_return-type        = 'S'.
        ew_return-id          = '/SPROLIMS/MC_STATUS'.
        ew_return-number      = '001'.
        ew_return-message_v1  = ''.
        ew_return-message_v2  = ''.
        ew_return-message_v3  = ''.
        ew_return-message_v4  = ''.

        MESSAGE ID '/SPROLIMS/MC_STATUS' TYPE 'S' NUMBER '001'
          WITH   '' '' '' ''
          INTO   ew_return-message.

      ENDIF.

    ELSE.

      ew_return-id          = sy-msgid.
      ew_return-type        = sy-msgty.
      ew_return-number      = sy-msgno.
      ew_return-message_v1  = sy-msgv1.
      ew_return-message_v2  = sy-msgv2.
      ew_return-message_v3  = sy-msgv3.
      ew_return-message_v4  = sy-msgv4.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH   sy-msgv1
               sy-msgv2
               sy-msgv3
               sy-msgv4
        INTO   ew_return-message.
    ENDIF.

  ENDIF.

ENDFUNCTION.
