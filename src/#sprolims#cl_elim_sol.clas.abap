class /SPROLIMS/CL_ELIM_SOL definition
  public
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IV_SOLICITATION type QMNUM
    raising
      /SPROLIMS/CX_ELIM_SOL .
  methods ELIMINATE_SOLICITATION
    raising
      /SPROLIMS/CX_ELIM_SOL .
  methods GET_NUM_AMOSTRA
    returning
      value(RV_NUM_AMOSTRA) type /SPROCSEM/DE_NUM_AMOSTRA .
protected section.
private section.

  data V_AUFNR type AUFNR .
  data V_PRUEFLOS type QPLOS .
  data V_QMNUM type QMNUM .
  data V_OBJNR type QMOBJNR .
  data V_AMOSTRA_DEFINITIVA type /SPROLIMS/DE_AMOSTRA_DEF .
  data V_WERKS type WERKS_D .
  data V_NUM_AMOSTRA type /SPROCSEM/DE_NUM_AMOSTRA .
  data V_ORDER_OBJNR type J_OBJNR .

  methods CHANGE_USER_STATUS
    raising
      /SPROLIMS/CX_ELIM_SOL .
  methods CHECK_FOR_BAS
    raising
      /SPROLIMS/CX_ELIM_SOL .
  methods CHECK_FOR_DU
    returning
      value(HAS_DU) type FLAG .
  methods CHECK_FOR_RESULTS
    returning
      value(HAS_RESULTS) type FLAG .
  methods ELIMINATE_BATCH_NUMBER
    raising
      /SPROLIMS/CX_ELIM_SOL .
  methods ERASE_SAMPLE_NUMBER
    raising
      /SPROLIMS/CX_ELIM_SOL .
  methods REVERSE_USAGE_DECISION
    raising
      /SPROLIMS/CX_ELIM_SOL .
  methods SET_BUSINESS_COMPLETION
    raising
      /SPROLIMS/CX_ELIM_SOL .
  methods ERASE_DEFINITIVE_SAMPLE
    raising
      /SPROLIMS/CX_ELIM_SOL .
  methods SET_ORDER_FOR_ELIMINATION
    raising
      /SPROLIMS/CX_ELIM_SOL .
  methods SET_SOL_FOR_ELIMINATION
    raising
      /SPROLIMS/CX_ELIM_SOL .
  methods SET_USAGE_DECISION
    raising
      /SPROLIMS/CX_ELIM_SOL .
ENDCLASS.



CLASS /SPROLIMS/CL_ELIM_SOL IMPLEMENTATION.


  METHOD change_user_status.

    DATA: lt_return TYPE TABLE OF bapiret2.

    DATA: lv_usr_status TYPE  bapi2080_notusrstati.

    lv_usr_status-status_int = 'E0002'.

    CALL FUNCTION 'BAPI_ALM_NOTIF_CHANGEUSRSTAT'
      EXPORTING
        number     = v_qmnum
        usr_status = lv_usr_status
*       SET_INACTIVE       = ' '
*       TESTRUN    = ' '
*     IMPORTING
*       SYSTEMSTATUS       =
*       USERSTATUS =
      TABLES
        return     = lt_return.

    IF sy-subrc = 0 or
       NOT line_exists( lt_return[ type = 'E' ] ) .

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' .

    ELSE.

      RAISE EXCEPTION TYPE /sprolims/cx_elim_sol
        EXPORTING
          textid = /sprolims/cx_elim_sol=>change_usr_stat.

    ENDIF.

  ENDMETHOD.


  METHOD check_for_bas.

    SELECT SINGLE *
      FROM /sprocsem/tbbsem
      INTO @DATA(lw_tbbsem)
      WHERE zcpqm_prueflos = @v_prueflos.

    IF sy-subrc = 0.

      RAISE EXCEPTION TYPE /sprolims/cx_elim_sol
        EXPORTING
          textid = /sprolims/cx_elim_sol=>has_bas.

    ENDIF.

  ENDMETHOD.


  method CHECK_FOR_DU.

    select single *
      from qave
      into @data(lw_qave)
      where prueflos = @v_prueflos and
            vcode    <> ''.

    IF sy-subrc = 0.

      has_du = 'X'.

    ENDIF.

  endmethod.


  METHOD check_for_results.

    SELECT *
      FROM qase
      INTO TABLE @DATA(lt_qase)
      WHERE prueflos = @v_prueflos.

    SELECT *
      FROM qasr
      INTO TABLE @DATA(lt_qasr)
      WHERE prueflos = @v_prueflos.

    SELECT *
      FROM qamr
      INTO TABLE @DATA(lt_qamr)
      WHERE prueflos = @v_prueflos.


    IF  lt_qase IS NOT INITIAL OR
        lt_qasr IS NOT INITIAL OR
        lt_qamr IS NOT INITIAL .

      has_results = 'X'.

    ENDIF.

  ENDMETHOD.


  METHOD constructor.

    SELECT SINGLE *
      FROM /sprolims/cdssol
      INTO @DATA(lw_cdssol)
      WHERE solicitation_id = @iv_solicitation.

    IF sy-subrc = 0.

*      IF lw_cdssol-order_id IS INITIAL.
*
*        RAISE EXCEPTION TYPE /sprolims/cx_elim_sol
*        EXPORTING
*          textid = /sprolims/cx_elim_sol=>no_order_found.
*
*      ENDIF.
*
*      IF lw_cdssol-batch_number IS INITIAL.
*
*        RAISE EXCEPTION TYPE /sprolims/cx_elim_sol
*        EXPORTING
*          textid = /sprolims/cx_elim_sol=>no_batch_number_found.
*
*      ENDIF.

      v_aufnr               = lw_cdssol-order_id.
      v_prueflos            = lw_cdssol-batch_number.
      v_qmnum               = lw_cdssol-solicitation_id.
      v_objnr               = lw_cdssol-solicitation_type.
      v_amostra_definitiva  = lw_cdssol-definitive_sample.
      v_werks               = lw_cdssol-laboratory.
      v_num_amostra         = lw_cdssol-sample_number.

      IF v_aufnr IS NOT INITIAL.

        SELECT SINGLE order_objnr
          FROM /sprolims/cdsorh
          INTO v_order_objnr
          WHERE order_id = v_aufnr.

      ENDIF.

    ELSE.

      RAISE EXCEPTION TYPE /sprolims/cx_elim_sol
        EXPORTING
          textid = /sprolims/cx_elim_sol=>no_solicitation_found.

    ENDIF.


  ENDMETHOD.


  METHOD eliminate_batch_number.

    CALL FUNCTION 'QPL1_LOT_ORDER_DELETE'
      EXPORTING
        i_prueflos         = v_prueflos
      EXCEPTIONS
        no_delete_possible = 1
        no_lot_found       = 2
        OTHERS             = 3.

    IF sy-subrc = 0.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

    ELSE.

      RAISE EXCEPTION TYPE /sprolims/cx_elim_sol
        EXPORTING
          textid = /sprolims/cx_elim_sol=>eliminate_batch_number.

    ENDIF.


  ENDMETHOD.


  METHOD eliminate_solicitation.

    DATA(lv_has_results) = me->check_for_results( ).

    IF lv_has_results = 'X'.

      DATA(lv_has_du) = me->check_for_du( ).
      IF lv_has_du = 'X'.

        TRY .

            me->check_for_bas( ).
            me->reverse_usage_decision( ).

          CATCH /sprolims/cx_elim_sol INTO DATA(lo_error).

            RAISE EXCEPTION lo_error.

        ENDTRY.

      ENDIF.

    ENDIF.

    TRY .

        me->change_user_status( ).
        me->set_sol_for_elimination( ).
        IF v_amostra_definitiva = 'X'.
          me->erase_definitive_sample( ).
        ENDIF.

        IF v_prueflos IS NOT INITIAL.

          IF lv_has_results = 'X'.

            me->erase_sample_number( ).
            me->set_usage_decision( ).


          ELSE.

            me->eliminate_batch_number( ).

          ENDIF.

        ENDIF.

        IF v_aufnr IS NOT INITIAL.

          me->set_business_completion( ).
          me->set_order_for_elimination( ).

        ENDIF.

      CATCH /sprolims/cx_elim_sol INTO lo_error.

        RAISE EXCEPTION lo_error.

    ENDTRY.

  ENDMETHOD.


  METHOD erase_definitive_sample.

    DATA: lt_extensionin  TYPE bapiparex_t,
          lt_extensionout TYPE bapiparex_t,
          lw_bapi_te_qmel TYPE bapi_te_qmel,
          lt_return       TYPE  bapiret2_t.

    CALL FUNCTION 'BAPI_ALM_NOTIF_GET_DETAIL'
      EXPORTING
        number       = v_qmnum
      TABLES
        extensionout = lt_extensionout.

    CLEAR lw_bapi_te_qmel.
    lw_bapi_te_qmel(240)  = lt_extensionout[ 1 ]-valuepart1.
    lw_bapi_te_qmel+240   = lt_extensionout[ 1 ]-valuepart2.

    CLEAR lw_bapi_te_qmel-amostra_definitiva.

    APPEND VALUE #( structure  = 'BAPI_TE_QMEL'
                   valuepart1 = lw_bapi_te_qmel(240)
                   valuepart2 = lw_bapi_te_qmel+240 ) TO lt_extensionin.

    CALL FUNCTION 'BAPI_ALM_NOTIF_DATA_MODIFY'
      EXPORTING
        number      = v_qmnum
      TABLES
        return      = lt_return
        extensionin = lt_extensionin.

    IF sy-subrc <> 0 or
       line_exists( lt_return[ type = 'E' ] ) .

      RAISE EXCEPTION TYPE /sprolims/cx_elim_sol
        EXPORTING
          textid = /sprolims/cx_elim_sol=>set_definitive_sample.

    ENDIF.

    CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE'
      EXPORTING
        number = v_qmnum
      TABLES
        return = lt_return.

    IF sy-subrc <> 0 or
       line_exists( lt_return[ type = 'E' ] ) .

      RAISE EXCEPTION TYPE /sprolims/cx_elim_sol
        EXPORTING
          textid = /sprolims/cx_elim_sol=>set_definitive_sample.

    ENDIF.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

  ENDMETHOD.


  METHOD erase_sample_number.

    DATA: lw_qals TYPE qals.

    SELECT SINGLE *
      FROM qals
      INTO lw_qals
      WHERE prueflos = v_prueflos.

    CLEAR lw_qals-num_amostra.

    CALL FUNCTION 'QPBU_LOT_UPDATE'
      EXPORTING
        qals_new = lw_qals.

    IF sy-subrc = 0.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

    ELSE.

      RAISE EXCEPTION TYPE /sprolims/cx_elim_sol
        EXPORTING
          textid = /sprolims/cx_elim_sol=>erase_sample_number.

    ENDIF.

  ENDMETHOD.


  METHOD get_num_amostra.

    rv_num_amostra = v_num_amostra.

  ENDMETHOD.


  METHOD REVERSE_USAGE_DECISION.

    RAISE EXCEPTION TYPE /sprolims/cx_elim_sol
      EXPORTING
        textid = /sprolims/cx_elim_sol=>has_du.

  ENDMETHOD.


  METHOD set_business_completion.
    DATA: lt_messages          TYPE  bal_t_msg,
          lt_return            TYPE TABLE OF  bapiret2,
          lw_return            TYPE bapiret2,
          lv_dfps_distribution TYPE  xfeld VALUE IS INITIAL.

    CALL FUNCTION 'IBAPI_ALM_ORDER_CLSD_SET'
      EXPORTING
        iv_orderid           = v_aufnr
        iv_dfps_distribution = lv_dfps_distribution
        iv_teco_ref_date     = sy-datum
        iv_teco_ref_time     = sy-uzeit
      TABLES
        et_messages          = lt_messages
        return               = lt_return.

    IF sy-subrc = 0 OR
       NOT line_exists( lt_return[ type = 'E' ] ) .

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait   = 'X'
        IMPORTING
          return = lw_return.

      WAIT UP TO 2 SECONDS.

    ELSE.

      RAISE EXCEPTION TYPE /sprolims/cx_elim_sol
        EXPORTING
          textid = /sprolims/cx_elim_sol=>business_completion.

    ENDIF.


  ENDMETHOD.


  METHOD set_order_for_elimination.

    DATA: lw_return TYPE  bapiret2.

    DATA: lt_status TYPE TABLE OF jstat,
          lw_status LIKE LINE OF lt_status.

    IF v_order_objnr IS NOT INITIAL.

      lw_status-stat = 'I0076'.
      APPEND lw_status TO lt_status.

      CALL FUNCTION 'STATUS_CHANGE_INTERN'
        EXPORTING
*         CHECK_ONLY          = ' '
*         CLIENT = SY-MANDT
          objnr  = v_order_objnr
*         ZEILE  = ' '
*         SET_CHGKZ           =
*     IMPORTING
*         ERROR_OCCURRED      =
*         OBJECT_NOT_FOUND    =
*         STATUS_INCONSISTENT =
*         STATUS_NOT_ALLOWED  =
        TABLES
          status = lt_status.

      IF sy-subrc = 0.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait   = 'X'
          IMPORTING
            return = lw_return.

      ELSE.

        RAISE EXCEPTION TYPE /sprolims/cx_elim_sol
          EXPORTING
            textid = /sprolims/cx_elim_sol=>eliminate_order.

      ENDIF.


    ELSE.


      RAISE EXCEPTION TYPE /sprolims/cx_elim_sol
        EXPORTING
          textid = /sprolims/cx_elim_sol=>no_order_objnr_found.

    ENDIF.


  ENDMETHOD.


  METHOD set_sol_for_elimination.

    DATA: lt_status TYPE TABLE OF jstat,
          lw_status LIKE LINE OF lt_status.

    lw_status-stat = 'I0076'.
    APPEND lw_status TO lt_status.

    CALL FUNCTION 'STATUS_CHANGE_INTERN'
      EXPORTING
*       CHECK_ONLY          = ' '
*       CLIENT              = SY-MANDT
        objnr               = v_objnr
*       ZEILE               = ' '
*       SET_CHGKZ           =
*     IMPORTING
*       ERROR_OCCURRED      =
*       OBJECT_NOT_FOUND    =
*       STATUS_INCONSISTENT =
*       STATUS_NOT_ALLOWED  =
      TABLES
        status              = lt_status .

    IF sy-subrc = 0.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

    ELSE.

      RAISE EXCEPTION TYPE /sprolims/cx_elim_sol
        EXPORTING
          textid = /sprolims/cx_elim_sol=>ELIMINATE_SOL.

    ENDIF.
  ENDMETHOD.


  METHOD set_usage_decision.

    DATA: lw_ud_data        TYPE bapi2045ud,
          lw_return         TYPE bapireturn1,
          lw_ud_return_data TYPE  bapi2045ud_return,
          lw_stock_data     TYPE  bapi2045d_il2,
          lw_cwm_stock_data TYPE  /cwm/bapi2045d_il2.

    DATA: lt_system_status TYPE TABLE OF  bapi2045ss,
          lt_user_status   TYPE TABLE OF  bapi2045us.

    SELECT SINGLE *
      FROM /sprolims/tb_cf1
      INTO @DATA(lw_cf1)
      WHERE werks = @v_werks.

    lw_ud_data-insplot              = v_prueflos.
    lw_ud_data-ud_selected_set      = lw_cf1-ud_code_group.
    lw_ud_data-ud_plant             = v_werks.
    lw_ud_data-ud_code_group        = lw_cf1-ud_code_group.
    lw_ud_data-ud_code              = lw_cf1-ud_code.
    lw_ud_data-ud_recorded_by_user  = sy-uname.
    lw_ud_data-ud_recorded_on_date  = sy-datum.
    lw_ud_data-ud_recorded_at_time  = sy-uzeit.
    lw_ud_data-ud_force_completion  = 'X'.


    CALL FUNCTION 'BAPI_INSPLOT_SETUSAGEDECISION'
      EXPORTING
        number          = v_prueflos
        ud_data         = lw_ud_data
*       language        = sy-langu
        ud_mode         = 'D'
      IMPORTING
        ud_return_data  = lw_ud_return_data
        stock_data      = lw_stock_data
        return          = lw_return
        /cwm/stock_data = lw_cwm_stock_data
      TABLES
        system_status   = lt_system_status
        user_status     = lt_user_status.

    IF  sy-subrc = 0 OR
        lw_return-type = 'E'.

      DATA: lw_return_commit TYPE bapiret2.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait   = 'X'
        IMPORTING
          return = lw_return_commit.

      WAIT UP TO 2 SECONDS.

    ELSE.

      RAISE EXCEPTION TYPE /sprolims/cx_elim_sol
        EXPORTING
          textid = /sprolims/cx_elim_sol=>set_usage_decision.

    ENDIF.


  ENDMETHOD.
ENDCLASS.
