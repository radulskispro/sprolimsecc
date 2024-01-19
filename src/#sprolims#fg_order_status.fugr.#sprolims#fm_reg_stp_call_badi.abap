FUNCTION /sprolims/fm_reg_stp_call_badi.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     REFERENCE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: lt_detail_return TYPE TABLE OF bapi_alm_return.

  DATA: lw_return      LIKE LINE OF et_return.

  SORT t_timetickets BY orderid operation work_cntr.

  DELETE ADJACENT DUPLICATES FROM t_timetickets COMPARING orderid operation work_cntr.

  CALL FUNCTION 'BAPI_ALM_CONF_CREATE'
    IMPORTING
      return        = lw_return
    TABLES
      timetickets   = t_timetickets
      detail_return = lt_detail_return.

  IF lw_return-type = 'E'.

    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK' .

  ELSE.

    TRY.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

        CLEAR t_goodsmvt_item.

      CATCH cx_root INTO DATA(lo_root).

    ENDTRY.

  ENDIF.

  LOOP AT lt_detail_return INTO DATA(lw_detail_return).

    READ TABLE t_timetickets INTO DATA(lw_timetickets_return) INDEX sy-tabix.

    IF lw_detail_return-type <> 'E'.

      IF lw_timetickets_return-complete <> 'X'.

        lw_return-type        = 'S'.
        lw_return-id          = '/SPROLIMS/MC_REGIS'.
        lw_return-number      = '004'.
        lw_return-message_v1  = lw_timetickets_return-orderid.
        lw_return-message_v2  = lw_timetickets_return-operation.
        lw_return-message_v3  = ''.
        lw_return-message_v4  = ''.

        MESSAGE ID '/SPROLIMS/MC_REGIS' TYPE 'S' NUMBER '004'
          WITH   lw_timetickets_return-orderid
                 lw_timetickets_return-operation
                 ''
                 ''
          INTO   lw_return-message.

      ELSE.

        lw_return-type        = 'S'.
        lw_return-id          = '/SPROLIMS/MC_REGIS'.
        lw_return-number      = '005'.
        lw_return-message_v1  = lw_timetickets_return-orderid.
        lw_return-message_v2  = lw_timetickets_return-operation.
        lw_return-message_v3  = ''.
        lw_return-message_v4  = ''.

        MESSAGE ID '/SPROLIMS/MC_REGIS' TYPE 'S' NUMBER '005'
          WITH   lw_timetickets_return-orderid
                 lw_timetickets_return-operation
                 ''
                 ''
          INTO   lw_return-message.

      ENDIF.

      APPEND lw_return TO et_return.

    ELSE.

      MOVE-CORRESPONDING lw_detail_return TO lw_return.

      lw_return-id      = lw_detail_return-message_id.
      lw_return-number  = lw_detail_return-message_number.
      lw_return-log_no  = lw_detail_return-log_number.

      APPEND lw_return TO et_return.

    ENDIF.

  ENDLOOP.


ENDFUNCTION.
