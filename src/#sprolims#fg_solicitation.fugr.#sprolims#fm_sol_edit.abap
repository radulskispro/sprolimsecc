FUNCTION /sprolims/fm_sol_edit.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_DATA) TYPE  STRING
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"     VALUE(EV_SOLICITATION_ID) TYPE  QMNUM
*"----------------------------------------------------------------------
  DATA: lt_sol_to_qmel    TYPE          /sprolims/tt_sol_to_qmel,
        lt_analysis       TYPE TABLE OF /sprolims/tt_sol_analysis,
        lt_task           TYPE TABLE OF bapi2080_nottaski,
        lt_task_x         TYPE TABLE OF bapi2080_nottaski_x,
        lt_partner        TYPE TABLE OF bapi2080_notpartnri,
        lt_partner_old    TYPE TABLE OF bapi2080_notpartnre,
        lt_partner_x      TYPE TABLE OF bapi2080_notpartnri_x,
        lt_item           TYPE TABLE OF bapi2080_notitemi,
        lt_item_x         TYPE TABLE OF bapi2080_notitemi_x,
        lt_long_text      TYPE TABLE OF bapi2080_notfulltxti,
        lt_notifpartnr_qm TYPE STANDARD TABLE OF bapi2078_notpartnri,
        lt_extensionin    TYPE bapiparex_t,
        lt_extensionout   TYPE bapiparex_t.

  DATA: lv_type                  TYPE bapi2080-notif_type,
        lw_partner               TYPE bapi2080_notpartnri,
        "lw_partner_old           TYPE BAPI2080_NOTPARTNRE,
        lw_partner_x             TYPE bapi2080_notpartnri_x,
        lw_header                TYPE bapi2080_nothdri,
        lw_header_x              TYPE bapi2080_nothdri_x,
        lw_item                  TYPE bapi2080_notitemi,
        lw_item_x                TYPE bapi2080_notitemi_x,
        lw_task                  TYPE bapi2080_nottaski,
        lw_task_x                TYPE bapi2080_nottaski_x,
        lw_long_text             TYPE bapi2080_notfulltxti,
        lw_bapi_te_qmel          TYPE bapi_te_qmel,
        lw_notifheader_export_qm TYPE bapi2080_nothdre,
        lw_notifheader_import_qm TYPE bapi2080_nothdre.

  DATA: lv_code_group          TYPE c LENGTH 1,
        lv_partner_convert     TYPE parvw,
        lv_partner_convert_old TYPE parvw,
        lv_is_old              TYPE abap_bool.

  /ui2/cl_json=>deserialize(
  EXPORTING
    json        = iv_data
    pretty_name = /ui2/cl_json=>pretty_mode-none
  CHANGING
    data        = lt_sol_to_qmel ).

  "{LCPG
  TRY.
      DATA(lo_validate) = NEW /sprolims/cl_solicitatio_valid( iv_solicitation = lt_sol_to_qmel ).
      lo_validate->_has_peps( ).
      lo_validate->_has_category( 'CULTIVAR' ).
    CATCH /sprolims/cx_solicitation INTO DATA(lx_error).
      DATA(message) = lx_error->get_text( ).
      et_return = VALUE #( ( type = 'E' message = message ) ).
      RETURN.
  ENDTRY.
  "LCPG}

  CALL FUNCTION 'BAPI_ALM_NOTIF_GET_DETAIL'
    EXPORTING
      number       = lt_sol_to_qmel[ 1 ]-solicitation_id
*     clear_buffer =
*    IMPORTING
*     notifheader_export =
*     notifhdtext  =
*     maintactytype      =
    TABLES
*     notlongtxt   =
*     notitem      =
*     notifcaus    =
*     notifactv    =
*     notiftask    =
      notifpartnr  = lt_partner_old
*     return       =
      extensionout = lt_extensionout.
  lv_type               = lt_sol_to_qmel[ 1 ]-solicitation_type.
  IF lv_type IS INITIAL.

    SELECT SINGLE qmart
      FROM /sprolims/tb_cf1
      INTO lv_type.

  ENDIF.
  lw_header-funct_loc     = lt_sol_to_qmel[ 1 ]-locale_collect.
  lw_header_x-funct_loc   = 'X'.
  lw_header-assembly      = lt_sol_to_qmel[ 1 ]-material.
  lw_header_x-assembly    = 'X'.
  lw_header-short_text    = lt_sol_to_qmel[ 1 ]-solicitation_description.
  lw_header_x-short_text  = 'X'.
  lw_header-code_group    = lt_sol_to_qmel[ 1 ]-analyse_type.
  lw_header_x-code_group  = 'X'.
  lw_header-coding        = lt_sol_to_qmel[ 1 ]-analyse.
  lw_header_x-coding      = 'X'.

  LOOP AT lt_sol_to_qmel[ 1 ]-partner  INTO DATA(lw_partner_new).
    lv_is_old = abap_false.

    CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
      EXPORTING
        input  = lw_partner_new-role
      IMPORTING
        output = lv_partner_convert.

    LOOP AT lt_partner_old INTO DATA(lw_partner_old).

      CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
        EXPORTING
          input  = lw_partner_old-partn_role
        IMPORTING
          output = lv_partner_convert_old.

*      IF lw_partner_new-partner = lw_partner_old-partner.
      lw_partner-partn_role           = lv_partner_convert.
      lw_partner-partn_role_old       = lv_partner_convert_old.
      lw_partner-partner              = lw_partner_new-partner.
      lw_partner-partner_old          = lw_partner_old-partner.
      lw_partner_x-partner_old        = 'X'.
      lw_partner_x-partn_role_old     = 'X'.
      lw_partner_x-partn_role  = 'X'.
      lw_partner_x-partner     = 'X'.
*        lv_is_old = abap_true.
*        CONTINUE.
*      ENDIF.
    ENDLOOP.

*    IF lv_is_old = abap_false.
*      lw_partner-partn_role     = lv_partner_convert.
*      lw_partner-partner        = lw_partner_new-partner.
*    ENDIF.


    APPEND lw_partner   TO lt_partner.
    APPEND lw_partner_x TO lt_partner_x.
    CLEAR lw_partner.
    CLEAR lw_partner_x.

  ENDLOOP.

  IF lt_sol_to_qmel[ 1 ]-laboratory IS NOT INITIAL.

    CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
      EXPORTING
        input  = 'FO'
      IMPORTING
        output = lv_partner_convert.

    lw_partner-partn_role           = lv_partner_convert.
    lw_partner-partner              = lt_sol_to_qmel[ 1 ]-laboratory.
    lw_partner-partn_role_old       = lv_partner_convert.
    lw_partner-partner_old          = lt_sol_to_qmel[ 1 ]-laboratory.
    lw_partner_x-partn_role         = 'X'.
    lw_partner_x-partner            = 'X'.
    lw_partner_x-partner_old        = 'X'.
    lw_partner_x-partn_role_old     = 'X'.

    APPEND lw_partner   TO lt_partner.
    APPEND lw_partner_x TO lt_partner_x.
    CLEAR lw_partner.
    CLEAR lw_partner_x.
  ENDIF.

  DATA(lv_analyisis_sy_tabix) = 1.


  LOOP AT lt_sol_to_qmel[ 1 ]-analysis INTO DATA(lv_analysis).


    READ TABLE lt_item WITH KEY dl_codegrp = lv_analysis-code_group TRANSPORTING NO FIELDS.

    IF sy-subrc IS NOT INITIAL AND lv_analysis-code_group IS NOT INITIAL.

      lw_item-item_key        = lv_analyisis_sy_tabix.
      lw_item_x-item_key      = 'X'.
      lw_item-item_sort_no    = lv_analyisis_sy_tabix.
      lw_item_x-item_sort_no  = 'X'.
      lw_item-dl_code         = lv_analysis-code.
      lw_item_x-dl_code       = 'X'.
      lw_item-dl_codegrp      = lv_analysis-code_group.
      lw_item_x-dl_codegrp    = 'X'.

      DATA(lv_metod_sy_tabix) = 1.

      LOOP AT lt_sol_to_qmel[ 1 ]-analysis INTO DATA(lv_metod).
        IF lv_metod-code_group_met IS NOT INITIAL .
          IF lv_metod-code_group_met EQ lv_analysis-code_group.

            lw_task-task_key       = lw_item-item_key.
            lw_task_x-task_key     = 'X'.
            lw_task-task_sort_no   = lv_metod_sy_tabix.
            lw_task_x-task_sort_no = 'X'.
            lw_task-task_codegrp   = lv_metod-code_group_met.
            lw_task_x-task_codegrp = 'X'.
            lw_task-task_code      = lv_metod-code_met.
            lw_task_x-task_code    = 'X'.
            lw_task-item_sort_no   = lw_item-item_key.
            lw_task_x-item_sort_no = 'X'.

            ADD 1 TO lv_metod_sy_tabix.

            APPEND lw_task TO lt_task.
            APPEND lw_task_x TO lt_task_x.
            CLEAR lw_task.
            CLEAR lw_task_x.
          ENDIF.
        ENDIF.

      ENDLOOP.

      ADD 1 TO lv_analyisis_sy_tabix.

      APPEND lw_item TO lt_item.
      APPEND lw_item_x TO lt_item_x.
      CLEAR lw_item.
      CLEAR lw_item_x.

    ENDIF.
  ENDLOOP.

  CLEAR lw_bapi_te_qmel.
  lw_bapi_te_qmel-notif_no            = ''.
  lw_bapi_te_qmel-otkat_categ         = ''.
  lw_bapi_te_qmel-otgrp_categ         = ''.
  lw_bapi_te_qmel-oteil_categ         = ''.
  lw_bapi_te_qmel-datacoleta          = lt_sol_to_qmel[ 1 ]-date_collect.
  lw_bapi_te_qmel-horacoleta          = lt_sol_to_qmel[ 1 ]-time_collect.
  lw_bapi_te_qmel-temperatura         = lt_sol_to_qmel[ 1 ]-temperatura.
  lw_bapi_te_qmel-mseh6               = lt_sol_to_qmel[ 1 ]-temp_unit.
  lw_bapi_te_qmel-gebindetyp          = lt_sol_to_qmel[ 1 ]-packing.
  lw_bapi_te_qmel-prod_aufnr          = lt_sol_to_qmel[ 1 ]-order_production.
  lw_bapi_te_qmel-prod_charg          = lt_sol_to_qmel[ 1 ]-batch.
  lw_bapi_te_qmel-prod_kostl          = lt_sol_to_qmel[ 1 ]-center_cost.
  lw_bapi_te_qmel-werk                = lt_sol_to_qmel[ 1 ]-requester.
  lw_bapi_te_qmel-temp_receb_meins    = lt_sol_to_qmel[ 1 ]-temp_receb_unit.
  lw_bapi_te_qmel-tanque_dest         = lt_sol_to_qmel[ 1 ]-tank_destin.
  lw_bapi_te_qmel-local_coleta        = lt_sol_to_qmel[ 1 ]-locale_collect.
  lw_bapi_te_qmel-estab_sif           = lt_sol_to_qmel[ 1 ]-sif.
  lw_bapi_te_qmel-lacre               = lt_sol_to_qmel[ 1 ]-seal.
  lw_bapi_te_qmel-req_legais          = lt_sol_to_qmel[ 1 ]-accept_requisits.
  lw_bapi_te_qmel-otkat_categ         = lt_sol_to_qmel[ 1 ]-category.
  lw_bapi_te_qmel-otgrp_categ         = lt_sol_to_qmel[ 1 ]-category_group.
  lw_bapi_te_qmel-oteil_categ         = lt_sol_to_qmel[ 1 ]-part_obj.
  lw_bapi_te_qmel-formcol             = lt_sol_to_qmel[ 1 ]-number_form_collect.
  lw_bapi_te_qmel-ciclo               = lt_sol_to_qmel[ 1 ]-cycle.
  lw_bapi_te_qmel-sexo                = lt_sol_to_qmel[ 1 ]-sex.
  lw_bapi_te_qmel-cama                = lt_sol_to_qmel[ 1 ]-cama.
  lw_bapi_te_qmel-linhagem            = lt_sol_to_qmel[ 1 ]-linage.
  lw_bapi_te_qmel-quan_env            = lt_sol_to_qmel[ 1 ]-quan_env.
  lw_bapi_te_qmel-quan_env_unit       = lt_sol_to_qmel[ 1 ]-quan_env_unit.
  lw_bapi_te_qmel-safra               = lt_sol_to_qmel[ 1 ]-ano_safra.
  lw_bapi_te_qmel-/sprolims/oteil     = lt_sol_to_qmel[ 1 ]-line_turn_code.
  lw_bapi_te_qmel-/sprolims/otgrp     = lt_sol_to_qmel[ 1 ]-line_turn.
  lw_bapi_te_qmel-amostra_definitiva  = lt_sol_to_qmel[ 1 ]-definitive_sample.
  lw_bapi_te_qmel-peneira             = lt_sol_to_qmel[ 1 ]-colander.
  lw_bapi_te_qmel-cultivar            = lt_sol_to_qmel[ 1 ]-cultivar.
  lw_bapi_te_qmel-especie             = lt_sol_to_qmel[ 1 ]-especie.
  lw_bapi_te_qmel-categoria           = lt_sol_to_qmel[ 1 ]-category_seeds.
  lw_bapi_te_qmel-inf_result          = lt_sol_to_qmel[ 1 ]-inf_result.
  lw_bapi_te_qmel-sem_tratada         = lt_sol_to_qmel[ 1 ]-sem_tratada.
  lw_bapi_te_qmel-faixa_umidade       = lt_sol_to_qmel[ 1 ]-faixa_umidade.
  lw_bapi_te_qmel-order_service       = lt_sol_to_qmel[ 1 ]-order_service.

  APPEND VALUE #( structure  = 'BAPI_TE_QMEL'
                 valuepart1 = lw_bapi_te_qmel(240)
                 valuepart2 = lw_bapi_te_qmel+240(240)
                 valuepart3 = lw_bapi_te_qmel+480 ) TO lt_extensionin.

  CALL FUNCTION 'BAPI_ALM_NOTIF_DATA_MODIFY'
    EXPORTING
      number             = lt_sol_to_qmel[ 1 ]-solicitation_id
      notifheader        = lw_header
      notifheader_x      = lw_header_x
    IMPORTING
      notifheader_export = lw_notifheader_export_qm
    TABLES
      notifitem          = lt_item
      notifitem_x        = lt_item_x
      notiftask          = lt_task
      notiftask_x        = lt_task_x
      notifpartnr        = lt_partner
      notifpartnr_x      = lt_partner_x
      return             = et_return
      extensionin        = lt_extensionin.

  READ TABLE et_return WITH KEY type  = 'E' TRANSPORTING NO FIELDS.
  IF sy-subrc IS INITIAL.
    RETURN.
  ENDIF.

  CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE'
    EXPORTING
      number      = lw_notifheader_export_qm-notif_no
    IMPORTING
      notifheader = lw_notifheader_import_qm
    TABLES
      return      = et_return.

  DATA(log) = /sproprod/cl_log=>factory( object = '/SPROLIMS/' subobject = '/SOLICITATION/' id = | EDIT_SOLICITATION { lw_notifheader_import_qm-notif_no } |   ).
  log->add( msg = lt_sol_to_qmel msgty = 'S' ).
  log->add( msg = lw_notifheader_import_qm msgty = 'S' ).

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = abap_true.

  ev_solicitation_id = lw_notifheader_import_qm-notif_no.

ENDFUNCTION.
