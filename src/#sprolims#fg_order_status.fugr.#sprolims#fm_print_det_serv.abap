FUNCTION /sprolims/fm_print_det_serv.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IW_GW_PRINT_DET_SERV) TYPE  /SPROLIMS/ST_GW_PRINT_DET_SERV
*"  EXPORTING
*"     VALUE(EW_GW_PRINT_DET_SERV) TYPE  /SPROLIMS/ST_GW_PRINT_DET_SERV
*"     VALUE(EW_RETURN) TYPE  BAPIRET2
*"----------------------------------------------------------------------

  DATA: o_handle TYPE REF TO /sprolims/badi_print_label.

  TRY .

      GET BADI o_handle.

      CALL BADI o_handle->print_label
        CHANGING
          iw_print_label = iw_gw_print_det_serv.

    CATCH cx_badi_not_implemented INTO DATA(lo_exception).

  ENDTRY.


*  DATA: lw_qals     LIKE  qals,
*        lw_qapo     LIKE  qapo,
*        lw_afrud_rm LIKE  afrud,
*        lw_afrud_st LIKE  afrud,
*        lw_qalt     LIKE  qalt,
*        lw_qave     LIKE  qave,
*        lw_qapp     LIKE  qapp,
*        lw_kzneu    LIKE  qdwl-flag.
*
*  DATA: lt_qamkr TYPE TABLE OF qamkr.
*
*  IF iw_gw_print_det_serv IS NOT INITIAL.
*
*    lw_qals-aufnr     = iw_gw_print_det_serv-aufnr.
*    lw_qals-werk      = iw_gw_print_det_serv-werk.
*    lw_qals-ktextmat  = iw_gw_print_det_serv-ktextmat.
*    lw_qapo-vornr     = iw_gw_print_det_serv-vornr.
*
*    CALL FUNCTION 'EXIT_SAPLQAPP_002'
*      EXPORTING
*        i_qals      = lw_qals
*        i_qapo      = lw_qapo
*        i_afrud_rm  = lw_afrud_rm
*        i_afrud_st  = lw_afrud_st
*        i_qalt      = lw_qalt
*        i_qave      = lw_qave
*        i_qapp      = lw_qapp
*        i_kzneu     = lw_kzneu
*      TABLES
*        t_qamkr_tab = lt_qamkr.
*
*  ENDIF.

ENDFUNCTION.
