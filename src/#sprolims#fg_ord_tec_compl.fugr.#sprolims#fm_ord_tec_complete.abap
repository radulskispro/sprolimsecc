FUNCTION /sprolims/fm_ord_tec_complete.
*"--------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_QALS) LIKE  QALS STRUCTURE  QALS
*"     VALUE(I_QAVE) LIKE  QAVE STRUCTURE  QAVE
*"     REFERENCE(I_QAPO) TYPE  QAPO OPTIONAL
*"  EXPORTING
*"     VALUE(E_SUBRC) LIKE  SY-SUBRC
*"  TABLES
*"      E_PROTOCOL STRUCTURE  RQEVP
*"--------------------------------------------------------------------

  CALL FUNCTION 'QFOA_ORDER_TECHNICAL_COMPLETE'
    EXPORTING
      i_qals     = i_qals
      i_qave     = i_qave
      i_qapo     = i_qapo
    IMPORTING
      e_subrc    = e_subrc
    TABLES
      e_protocol = e_protocol.


  DATA: lw_solic_status TYPE  /sprolims/st_gw_sol_sts_update.

  IF sy-subrc = 0.

    SELECT SINGLE qmnum
      FROM qmel
      INTO @DATA(lv_qmnum)
      WHERE aufnr = @i_qals-aufnr.

    IF sy-subrc = 0.

      lw_solic_status-objnr = lv_qmnum.
      lw_solic_status-stat  = 'E0017'.

      CALL FUNCTION '/SPROLIMS/FM_SOLIC_STS_CREATE'
        EXPORTING
          iw_solic_status = lw_solic_status.

    ENDIF.

  ENDIF.

ENDFUNCTION.
