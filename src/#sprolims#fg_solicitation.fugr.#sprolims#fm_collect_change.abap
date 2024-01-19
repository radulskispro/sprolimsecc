FUNCTION /sprolims/fm_collect_change.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_DATA) TYPE  STRING
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: lt_col_to_mpla TYPE          /sprolims/tt_col_to_mpla,
        lt_analysis    TYPE TABLE OF /sprolims/tt_sol_analysis,
        lt_items       TYPE TABLE OF  mplan_mpos,
        lt_cycles      TYPE TABLE OF  mplan_mmpt.

  DATA: lw_item          TYPE mplan_mpos,
        lw_header        TYPE mplan_mpla,
        lw_cycles        TYPE mplan_mmpt,
        lw_header_update TYPE mplan_mpla_update.

  data:  lv_error  TYPE string.

  /ui2/cl_json=>deserialize(
    EXPORTING
      json        = iv_data
      pretty_name = /ui2/cl_json=>pretty_mode-none
    CHANGING
      data        = lt_col_to_mpla ).

  " CHECK AUTH
  CALL FUNCTION '/SPROLIMS/FM_COLLECT_CH_AU'
    EXPORTING
      iv_collect_id = lt_col_to_mpla[ 1 ]-collect_id
    IMPORTING
      et_return     = et_return
      ev_error      = lv_error.

  IF lv_error EQ 'Y'.
    RETURN.
  ENDIF.

  "CHECK EDIT
  CALL FUNCTION '/SPROLIMS/FM_COLLECT_CH_ED'
    EXPORTING
      iv_collect_id = lt_col_to_mpla[ 1 ]-collect_id
    IMPORTING
      et_return     = et_return
      ev_error      = lv_error.


  IF lv_error EQ 'Y'.
    RETURN.
  ENDIF.

  DATA(lv_packing)   = lt_col_to_mpla[ 1 ]-packing.
  DATA(lv_requester) = lt_col_to_mpla[ 1 ]-requester.

  SELECT SINGLE *
    FROM /sprolims/tb_cf1
    INTO @DATA(lw_tb_cf1).

  SELECT SINGLE *
     FROM t399w
     INTO @DATA(lw_t399w)
   WHERE mptyp = @lw_tb_cf1-mptyp.

  "header
  lw_header-topos        = lt_col_to_mpla[ 1 ]-tolerancy_max.
  lw_header-toneg        = lt_col_to_mpla[ 1 ]-tolerancy_min.
  lw_header-stadt        = lt_col_to_mpla[ 1 ]-date_start.
  lw_header-mpla_upd     = 'X'.
  lw_header-warpl        = lt_col_to_mpla[ 1 ]-collect_id.
  lw_header_update-topos = 'X'.
  lw_header_update-toneg = 'X'.
  lw_header_update-stadt = 'X'.
  lw_header_update-warpl = lt_col_to_mpla[ 1 ]-collect_id.


  "items

  "MPOS-WARPL=MPLA-WARPL e retornar o campo MPOS-WAPOS
  DATA(lv_warpl) = lt_col_to_mpla[ 1 ]-collect_id.
  SELECT SINGLE *
    FROM mpos
    INTO @DATA(lw_mpos)
    WHERE warpl = @lv_warpl.

  lw_item-/sprolims/kostl             = lw_mpos-/sprolims/kostl.
  lw_item-/sprolims/aber              = lw_mpos-/sprolims/aber.
  lw_item-/sprolims/gebindetyp        = lw_mpos-/sprolims/gebindetyp.
  lw_item-/sprolims/lab               = lw_mpos-/sprolims/lab.
  lw_item-/sprolims/lib               = lw_mpos-/sprolims/lib.
  lw_item-/sprolims/locale_collect    = lw_mpos-/sprolims/locale_collect.
  lw_item-/sprolims/oteil             = lw_mpos-/sprolims/oteil.
  lw_item-/sprolims/otgrp             = lw_mpos-/sprolims/otgrp.
  lw_item-/sprolims/plan              = lw_mpos-/sprolims/plan.
  lw_item-/sprolims/qmcod             = lw_mpos-/sprolims/qmcod.
  lw_item-/sprolims/qmgrp             = lw_mpos-/sprolims/qmgrp.
  lw_item-/sprolims/repet             = lw_mpos-/sprolims/repet.
  lw_item-/sprolims/req_legais        = lw_mpos-/sprolims/req_legais.
  lw_item-/sprolims/werks             = lw_mpos-/sprolims/werks.

  lw_item-/sprolims/analise         = lt_col_to_mpla[ 1 ]-analise.
  lw_item-/sprolims/qlosmenge       = lt_col_to_mpla[ 1 ]-qty.
  lw_item-/sprolims/qlosmengeh      = lt_col_to_mpla[ 1 ]-unit.

  IF lt_col_to_mpla[ 1 ]-analysis[ 1 ] IS NOT INITIAL.
    lw_item-/sprolims/codemetodologia = lt_col_to_mpla[ 1 ]-analysis[ 1 ]-code_group_met.
    lw_item-/sprolims/metodologia     = lt_col_to_mpla[ 1 ]-analysis[ 1 ]-code_met.
    lw_item-/sprolims/codeanalise     = lt_col_to_mpla[ 1 ]-analysis[ 1 ]-code_group.

  ELSE.
    lw_item-/sprolims/codemetodologia = space.
    lw_item-/sprolims/metodologia     = space.
    lw_item-/sprolims/codeanalise     = space.

  ENDIF.
  lw_item-wppos    = '0001'.
  lw_item-warpl    = lt_col_to_mpla[ 1 ]-collect_id.
  lw_item-action   = 'C'. " C de Change
  lw_item-wapos    = lw_mpos-wapos.

  APPEND lw_item TO lt_items.
  CLEAR lw_item.

  "cycles
  lw_cycles-zykl1   = lt_col_to_mpla[ 1 ]-frequency.
  lw_cycles-warpl   = lt_col_to_mpla[ 1 ]-collect_id.
  lw_cycles-nummer = '01'.
  lw_cycles-zeieh  = 'TAG'.
  lw_cycles-action = 'C'. " C de Change

  APPEND lw_cycles TO lt_cycles.
  CLEAR lw_cycles.


  CALL FUNCTION 'MPLAN_CHANGE'
    EXPORTING
      header        = lw_header "MPLAN_MPLA
      header_update = lw_header_update
    TABLES
      items         = lt_items  "STRUCTURE  MPLAN_MPOS OPTIONAL
      cycles        = lt_cycles "STRUCTURE  MPLAN_MMPT OPTIONAL
      return        = et_return.


  IF sy-subrc = 0 AND
     NOT line_exists( et_return[ type = 'E' ] ).
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
  ELSE.

    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  ENDIF.

ENDFUNCTION.
