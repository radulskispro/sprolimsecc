FUNCTION /sprolims/fm_collect_create.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_DATA) TYPE  STRING
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"     VALUE(EV_COLLECT_ID) TYPE  WARPL
*"----------------------------------------------------------------------
************************************************************************
*                          CREATE                                      *
************************************************************************
* Identification: LCPG                                             	   *
* Programmer    : Luiz Carlos Pedroso Gomes                            *
* Company       : SPRO it solutions                                    *
* Date          : 19.03.2020                                           *
* Description   : criar coleta                                 *
************************************************************************

  DATA: lt_col_to_mpla TYPE          /sprolims/tt_col_to_mpla,
        lt_analysis    TYPE TABLE OF /sprolims/tt_sol_analysis,
        lt_items       TYPE TABLE OF  mplan_mpos,
        lt_cycles      TYPE TABLE OF  mplan_mmpt.

  DATA: lw_item   TYPE mplan_mpos,
        lw_header TYPE mplan_mpla,
        lw_cycles TYPE mplan_mmpt.

  DATA: lv_wptxt  TYPE wptxt.


  /ui2/cl_json=>deserialize(
    EXPORTING
      json        = iv_data
      pretty_name = /ui2/cl_json=>pretty_mode-none
    CHANGING
      data        = lt_col_to_mpla ).


  DATA(lv_packing)   = lt_col_to_mpla[ 1 ]-packing.
  DATA(lv_requester) = lt_col_to_mpla[ 1 ]-requester.

  SELECT SINGLE *
    FROM /sprolims/tb_cf1
    INTO @DATA(lw_tb_cf1).

  "header
  SELECT SINGLE *
      FROM tq42t
      INTO @DATA(lw_tq42t)
      WHERE gebindetyp = @lv_packing AND sprache = 'P'.

  DATA(lv_analise_txt)  = 'Análise'.
  DATA(lv_separa)       = '-'.
  CONCATENATE  lv_analise_txt lv_requester lw_tq42t-kurztext INTO lv_wptxt  SEPARATED BY lv_separa.

  lw_header-ersdt = sy-datum.
  lw_header-wptxt = lv_wptxt.
  lw_header-abrho = lw_tb_cf1-abrho.
  lw_header-anzps = '0001'.
  lw_header-topos = lt_col_to_mpla[ 1 ]-tolerancy_max.
  lw_header-toneg = lt_col_to_mpla[ 1 ]-tolerancy_min.
  lw_header-sfakt = '1'.
  lw_header-horiz = lw_tb_cf1-horiz.
  lw_header-mptyp = lw_tb_cf1-mptyp.
  lw_header-hunit = 'TAG'.
  lw_header-stadt = lt_col_to_mpla[ 1 ]-date_start.

  "items
  DATA(lv_center_work) = lt_col_to_mpla[ 1 ]-work_center.
  SELECT SINGLE *
      FROM crhd
      INTO @DATA(lw_crhd)
      WHERE arbpl = @lv_center_work.

  SELECT SINGLE *
      FROM t399w
      INTO @DATA(lw_t399w)
    WHERE mptyp = @lw_tb_cf1-mptyp.

  lw_item-wppos                     = '0001'.
  lw_item-pstxt                     = lv_wptxt.
  lw_item-equnr                     = lt_col_to_mpla[ 1 ]-equipament.
  lw_item-ersdt                     = sy-datum.
  lw_item-status                    = 'P'.
  lw_item-objty                     = lw_crhd-objty.
  lw_item-gewrk                     = lw_crhd-objid.
  lw_item-iwerk                     = lw_crhd-werks.
  "lw_item-iloan                     = ''.
  lw_item-bautl                     = lt_col_to_mpla[ 1 ]-material.
  lw_item-apfkt                     = '1'.
  lw_item-scrrenty                  = lw_t399w-screenty.
  lw_item-tplnr                     = lt_col_to_mpla[ 1 ]-locale_collect.
  lw_item-/sprolims/req_legais      = lt_col_to_mpla[ 1 ]-accept_req_legais.
  lw_item-/sprolims/werks           = lt_col_to_mpla[ 1 ]-requester.
  lw_item-/sprolims/analise         = lt_col_to_mpla[ 1 ]-analise.
  lw_item-/sprolims/lab             = lt_col_to_mpla[ 1 ]-laboratory.
  lw_item-/sprolims/qlosmenge       = lt_col_to_mpla[ 1 ]-qty.
  lw_item-/sprolims/qlosmengeh      = lt_col_to_mpla[ 1 ]-unit.
  lw_item-/sprolims/gebindetyp      = lt_col_to_mpla[ 1 ]-packing.
  lw_item-mityp                     = lw_tb_cf1-mptyp.

  IF lt_col_to_mpla[ 1 ]-analysis[ 1 ] IS NOT INITIAL.
    lw_item-/sprolims/codemetodologia = lt_col_to_mpla[ 1 ]-analysis[ 1 ]-code_group_met.
    lw_item-/sprolims/metodologia     = lt_col_to_mpla[ 1 ]-analysis[ 1 ]-code_met.
    lw_item-/sprolims/codeanalise     = lt_col_to_mpla[ 1 ]-analysis[ 1 ]-code_group.
  ENDIF.

  IF lt_col_to_mpla[ 1 ]-accounting = 'OR'."contabilizacao tipo ordem
    lw_item-/sprolims/plan  = lt_col_to_mpla[ 1 ]-order_plan.
    lw_item-/sprolims/repet = lt_col_to_mpla[ 1 ]-order_repet.
    lw_item-/sprolims/aber  = lt_col_to_mpla[ 1 ]-order_aber.
    lw_item-/sprolims/lib   = lt_col_to_mpla[ 1 ]-order_lib.
  ENDIF.

  IF lt_col_to_mpla[ 1 ]-accounting = 'CC'. "contabilizacao tipo centro de custo
    lw_item-/sprolims/kostl = lt_col_to_mpla[ 1 ]-cost_center.
  ENDIF.

  lw_item-qmart = lw_tb_cf1-qmart.

  APPEND lw_item TO lt_items.
  CLEAR lw_item.


  "cycles
  lw_cycles-nummer = '01'.
  lw_cycles-zykl1  = lt_col_to_mpla[ 1 ]-frequency.
  lw_cycles-zeieh  = 'TAG'.

  APPEND lw_cycles TO lt_cycles.
  CLEAR lw_cycles.


  CALL FUNCTION 'MPLAN_CREATE'
    EXPORTING
      header = lw_header "MPLAN_MPLA
    IMPORTING
      number = ev_collect_id
    TABLES
      items  = lt_items  "STRUCTURE  MPLAN_MPOS OPTIONAL
      cycles = lt_cycles "STRUCTURE  MPLAN_MMPT OPTIONAL
      return = et_return.


  IF sy-subrc = 0 AND
      NOT line_exists( et_return[ type = 'E' ] ).
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
  ELSE.

    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

  ENDIF.

ENDFUNCTION.
