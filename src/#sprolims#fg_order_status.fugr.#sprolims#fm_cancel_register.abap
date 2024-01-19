FUNCTION /sprolims/fm_cancel_register.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IW_CANC_REGISTER) TYPE  /SPROLIMS/ST_GW_CANC_REGISTER
*"  EXPORTING
*"     VALUE(EW_CANC_REGISTER) TYPE  /SPROLIMS/ST_GW_CANC_REGISTER
*"     VALUE(EW_RETURN) TYPE  BAPIRET2
*"----------------------------------------------------------------------

  DATA: lv_wait     LIKE  bapita-wait VALUE '1'.

  IF iw_canc_register IS NOT INITIAL.

    SELECT confirmation_number, confirmation_number_item UP TO 1 rows
      FROM /sprolims/cdsors
      INTO @DATA(lw_cdsors)
      WHERE order_id      = @iw_canc_register-orderid AND
            order_step_id = @iw_canc_register-operation.
    ENDSELECT.

    IF lw_cdsors IS NOT INITIAL.

      CALL FUNCTION 'BAPI_ALM_CONF_CANCEL'
        EXPORTING
          confirmation        = lw_cdsors-confirmation_number
          confirmationcounter = lw_cdsors-confirmation_number_item
        IMPORTING
          return              = ew_return.

      IF ew_return-type <> 'E'.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = lv_wait.

        IF sy-subrc = 0.

          ew_canc_register = iw_canc_register.

          ew_return-type        = 'S'.
          ew_return-id          = '/SPROLIMS/MC_REGIS'.
          ew_return-number      = '008'.
          ew_return-message_v1  = iw_canc_register-orderid.
          ew_return-message_v2  = iw_canc_register-operation.
          ew_return-message_v3  = ''.
          ew_return-message_v4  = ''.

          MESSAGE ID '/SPROLIMS/MC_REGIS' TYPE 'S' NUMBER '008'
            WITH   iw_canc_register-orderid
                   iw_canc_register-operation
                   ''
                   ''
            INTO   ew_return-message.

        ENDIF.

*      ELSE.
*
*        ew_return-type        = 'E'.
*        ew_return-id          = '/SPROLIMS/MC_REGIS'.
*        ew_return-number      = '009'.
*        ew_return-message_v1  = iw_canc_register-orderid.
*        ew_return-message_v2  = iw_canc_register-operation.
*        ew_return-message_v3  = ''.
*        ew_return-message_v4  = ''.
*
*        MESSAGE ID '/SPROLIMS/MC_REGIS' TYPE 'E' NUMBER '009'
*          WITH   iw_canc_register-orderid
*                 iw_canc_register-operation
*                 ''
*                 ''
*          INTO   ew_return-message.

      ENDIF.
    ENDIF.
  ENDIF.

  WAIT UP TO 2 SECONDS.

ENDFUNCTION.
