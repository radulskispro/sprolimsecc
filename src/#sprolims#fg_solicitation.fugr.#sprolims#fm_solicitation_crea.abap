FUNCTION /sprolims/fm_solicitation_crea.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_DATA) TYPE  STRING
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"     VALUE(EV_SOLICITATION_ID) TYPE  QMNUM
*"     VALUE(EV_ERROR) TYPE  STRING
*"     VALUE(EV_ERROR_MESSAGE) TYPE  STRING
*"----------------------------------------------------------------------
************************************************************************
*                          CREATE                                      *
************************************************************************
* Identification: LCPG                                             	   *
* Programmer    : Luiz Carlos Pedroso Gomes                            *
* Company       : SPRO it solutions                                    *
* Date          : 03.03.2020                                           *
* Description   : criar solicitação                                    *
************************************************************************

  DATA: lt_sol_to_qmel    TYPE          /sprolims/tt_sol_to_qmel,
        "lt_partners     TYPE TABLE OF /sprolims/tt_sol_partner,
        lt_analysis       TYPE TABLE OF /sprolims/tt_sol_analysis,
        lt_task           TYPE TABLE OF bapi2080_nottaski,
        lt_partner        TYPE TABLE OF bapi2080_notpartnri,
        lt_item           TYPE TABLE OF bapi2080_notitemi,
        lt_long_text      TYPE TABLE OF bapi2080_notfulltxti,
        lt_notifpartnr_qm TYPE STANDARD TABLE OF bapi2078_notpartnri,
        lt_extensionin    TYPE bapiparex_t.

  DATA: lv_type                  TYPE bapi2080-notif_type,
        lw_partner               TYPE bapi2080_notpartnri,
        lw_header                TYPE bapi2080_nothdri,
        lw_item                  TYPE bapi2080_notitemi,
        lw_task                  TYPE bapi2080_nottaski,
        lw_long_text             TYPE bapi2080_notfulltxti,
        lw_bapi_te_qmel          TYPE bapi_te_qmel,
        lw_notifheader_export_qm TYPE bapi2080_nothdre,
        lw_notifheader_import_qm TYPE bapi2080_nothdre.

  DATA: lv_code_group      TYPE c LENGTH 1,
        lv_partner_convert TYPE parvw.


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
      lo_validate->_has_user_auth( iv_process = 'SOL.ANALIS' ).
    CATCH /sprolims/cx_solicitation INTO DATA(lx_error).
      DATA(message) = lx_error->get_text( ).
      et_return = VALUE #( ( type = 'E' message = message ) ).
      ev_error = 'X'.
      ev_error_message = message.
      RETURN.
  ENDTRY.
  "LCPG}

  lv_type               = lt_sol_to_qmel[ 1 ]-solicitation_type.
  IF lv_type IS INITIAL.

    SELECT SINGLE qmart
      FROM /sprolims/tb_cf1
      INTO lv_type.

  ENDIF.
*  lw_header-funct_loc   = lt_sol_to_qmel[ 1 ]-laboratory.
  lw_header-funct_loc   = lt_sol_to_qmel[ 1 ]-locale_collect.
  lw_header-assembly    = lt_sol_to_qmel[ 1 ]-material.
  lw_header-short_text  = lt_sol_to_qmel[ 1 ]-solicitation_description.
  lw_header-code_group  = lt_sol_to_qmel[ 1 ]-analyse_type.
  lw_header-coding      = lt_sol_to_qmel[ 1 ]-analyse.


  LOOP AT lt_sol_to_qmel[ 1 ]-partner  INTO DATA(lv_partner).

    CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
      EXPORTING
        input  = lv_partner-role
      IMPORTING
        output = lv_partner_convert.

    lw_partner-partn_role  = lv_partner_convert.
    lw_partner-partner     = lv_partner-partner.

    APPEND lw_partner TO lt_partner.
    CLEAR lw_partner.
  ENDLOOP.

  IF lt_sol_to_qmel[ 1 ]-laboratory IS NOT INITIAL.

    CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
      EXPORTING
        input  = 'FO'
      IMPORTING
        output = lv_partner_convert.

    lw_partner-partn_role  = lv_partner_convert.
    lw_partner-partner     = lt_sol_to_qmel[ 1 ]-laboratory.

    APPEND lw_partner TO lt_partner.
    CLEAR lw_partner.

  ENDIF.

  DATA(lv_analyisis_sy_tabix) = 1.


  LOOP AT lt_sol_to_qmel[ 1 ]-analysis INTO DATA(lv_analysis).


    READ TABLE lt_item WITH KEY dl_codegrp = lv_analysis-code_group TRANSPORTING NO FIELDS.

    IF sy-subrc IS NOT INITIAL AND lv_analysis-code_group IS NOT INITIAL.

      lw_item-item_key     = lv_analyisis_sy_tabix.
      lw_item-item_sort_no = lv_analyisis_sy_tabix.
      lw_item-dl_code      = lv_analysis-code.
      lw_item-dl_codegrp   = lv_analysis-code_group.

      DATA(lv_metod_sy_tabix) = 1.

      LOOP AT lt_sol_to_qmel[ 1 ]-analysis INTO DATA(lv_metod).
        IF lv_metod-code_group_met IS NOT INITIAL .
          IF lv_metod-code_group_met EQ lv_analysis-code_group.

            lw_task-task_key     = lw_item-item_key.
            lw_task-task_sort_no = lv_metod_sy_tabix.
            lw_task-task_codegrp = lv_metod-code_group_met.
            lw_task-task_code    = lv_metod-code_met.
            lw_task-item_sort_no = lw_item-item_key.

            ADD 1 TO lv_metod_sy_tabix.

            APPEND lw_task TO lt_task.
            CLEAR lw_task.
          ENDIF.
        ENDIF.

      ENDLOOP.

      ADD 1 TO lv_analyisis_sy_tabix.

      APPEND lw_item TO lt_item.
      CLEAR lw_item.

    ENDIF.
  ENDLOOP.

  lw_long_text-objtype     = 'QMEL'.
  lw_long_text-format_col = '*'.
  lw_long_text-text_line  = lt_sol_to_qmel[ 1 ]-observacao_sol.

  APPEND lw_long_text TO lt_long_text.
  CLEAR lw_long_text.

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
  lw_bapi_te_qmel-campo               = lt_sol_to_qmel[ 1 ]-campo.
  lw_bapi_te_qmel-talhao              = lt_sol_to_qmel[ 1 ]-talhao.
  lw_bapi_te_qmel-fazenda             = lt_sol_to_qmel[ 1 ]-fazenda.
  lw_bapi_te_qmel-cultivar_campo      = lt_sol_to_qmel[ 1 ]-cultivar_campo.
  lw_bapi_te_qmel-observacao_long     = lt_sol_to_qmel[ 1 ]-observacao_sol.
  lw_bapi_te_qmel-tipo_coleta         = lt_sol_to_qmel[ 1 ]-tipo_coleta.
  lw_bapi_te_qmel-faixa_umidade       = lt_sol_to_qmel[ 1 ]-faixa_umidade.
  lw_bapi_te_qmel-order_service       = lt_sol_to_qmel[ 1 ]-order_service.


  APPEND VALUE #( structure  = 'BAPI_TE_QMEL'
                  valuepart1 = lw_bapi_te_qmel(240)
                  valuepart2 = lw_bapi_te_qmel+240(240)
                  valuepart3 = lw_bapi_te_qmel+480 ) TO lt_extensionin.

  CALL FUNCTION 'BAPI_ALM_NOTIF_CREATE'
    EXPORTING
      notif_type         = lv_type
      notifheader        = lw_header
    IMPORTING
      notifheader_export = lw_notifheader_export_qm
    TABLES
      notitem            = lt_item
      notiftask          = lt_task
      notifpartnr        = lt_partner
      longtexts          = lt_long_text
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

  READ TABLE et_return WITH KEY type  = 'E' TRANSPORTING NO FIELDS.
  IF sy-subrc IS INITIAL.
    RETURN.
  ENDIF.

  DATA(log) = /sproprod/cl_log=>factory( object = '/SPROLIMS/' subobject = '/SOLICITATION/' id = | CREATE_SOLICITATION { lw_notifheader_import_qm-notif_no } |   ).
  log->add( msg = lt_sol_to_qmel msgty = 'S' ).
  log->add( msg = lw_notifheader_import_qm msgty = 'S' ).

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = abap_true.
  IF sy-subrc IS INITIAL.
    ev_solicitation_id =  lw_notifheader_import_qm-notif_no.
  ENDIF.


ENDFUNCTION.
