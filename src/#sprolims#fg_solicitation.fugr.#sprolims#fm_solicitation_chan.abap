FUNCTION /sprolims/fm_solicitation_chan.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_SOLICITATION_ID) TYPE  QMNUM
*"     VALUE(IV_NUM_AMOSTRA) TYPE  /SPROCSEM/DE_NUM_AMOSTRA OPTIONAL
*"  EXPORTING
*"     VALUE(EV_ERROR) TYPE  FLAG
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"     VALUE(EV_ORDER_ID) TYPE  AUFNR
*"     VALUE(EV_ERROR_MESSAGE) TYPE  STRING
*"----------------------------------------------------------------------

  DATA badi_solicitation_change TYPE REF TO /sprolims/badi_interface_solic.
  DATA lv_tj30t TYPE tj30t-estat.
  DATA lv_stsma TYPE tq80-stsma.
  DATA lv_qmart TYPE qmel-qmart.
  DATA lw_return    TYPE bapiret2.

  "{LCPG
  DATA(log) = /sproprod/cl_log=>factory( object = '/SPROLIMS/' subobject = '/SOLICITATION/' id = | CONVERT_{ iv_solicitation_id } |   ).
  TRY.
      DATA(lo_validate) = NEW /sprolims/cl_solicitatio_valid(  ).
      lo_validate->_has_user_auth( iv_solicitation_id = iv_solicitation_id iv_process = 'COCKPITREC' ).
    CATCH /sprolims/cx_solicitation INTO DATA(lx_error).
      DATA(message) = lx_error->get_text( ).
      et_return = VALUE #( ( type = 'E' message = message ) ).
      ev_error = 'X'.
      ev_error_message = message.
      log->add( msg = message ).
      COMMIT WORK."salvar log
      RETURN.
  ENDTRY.
  "LCPG}

  v_num_amostra = iv_num_amostra.

  TRY.

      GET BADI badi_solicitation_change.

      CALL BADI badi_solicitation_change->convert
        EXPORTING
          iv_solicitation_id = iv_solicitation_id
        IMPORTING
          ev_order_id        = ev_order_id
          et_return          = et_return
          ev_error           = ev_error.
    CATCH cx_root.
      ev_error = 'X'.
  ENDTRY.
  "LCPG{ Task 20959
  READ TABLE et_return WITH KEY type = 'E' TRANSPORTING NO FIELDS.
  IF sy-subrc = 0 OR ev_error EQ 'X'.
    ev_error = 'X'.
    DATA(msg) = | Conversão da solicitação { iv_solicitation_id } não realizada. |.
    log->add( msg = msg ).
    lw_return-id = iv_solicitation_id.
    lw_return-message = msg.
    APPEND lw_return TO et_return.
    COMMIT WORK."salvar log
    RETURN.
  ENDIF."LCPG} Task 20959
  "LCPGV01{
  SELECT SINGLE qmart
    FROM qmel
    INTO lv_qmart
    WHERE qmnum = iv_solicitation_id.

  SELECT SINGLE stsma
    FROM tq80
    INTO lv_stsma
    WHERE qmart = lv_qmart.

  SELECT SINGLE estat
    FROM tj30t
    INTO lv_tj30t
    WHERE txt04 = 'EXEC'
    AND spras = 'P'
    AND stsma = lv_stsma.
  "}

*ACV01{
  DATA: lw_solic_status TYPE  /sprolims/st_gw_sol_sts_update.

  lw_solic_status-objnr = iv_solicitation_id.
  lw_solic_status-stat  = lv_tj30t. "LCPGV01

  CLEAR et_return.

  CALL FUNCTION '/SPROLIMS/FM_SOLIC_STS_CREATE'
    EXPORTING
      iw_solic_status = lw_solic_status
    IMPORTING
      et_return       = et_return.

  READ TABLE et_return WITH KEY type = 'E' TRANSPORTING NO FIELDS.
  IF sy-subrc = 0.
    ev_error = 'X'.
    log->add( msg =  | Conversão da solicitação { iv_solicitation_id } não realizada. (/SPROLIMS/FM_SOLIC_STS_CREATE) |  ).
    COMMIT WORK."salvar log
    RETURN.
  ENDIF.
  log->add( msg =  | Conversão da solicitação { iv_solicitation_id } realizada com sucesso. |  msgty = 'I'  ).
  log->save( ).
*ACV01}



ENDFUNCTION.
