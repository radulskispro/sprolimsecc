*&---------------------------------------------------------------------*
*& Include          ZRQM_ENTRADA_RESULTADO_TAB_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Include          ZIFI_EMISSAO_RECIBOS_C01
*&---------------------------------------------------------------------*
**********************************************************************
** Classe Internas - Definição                                      **
**********************************************************************
CLASS lcl_event_handler DEFINITION.

  PUBLIC SECTION.

    METHODS:
      on_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id
                  e_column_id
                  es_row_no,

      handle_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object e_interactive,

      handle_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed ,

      handle_user_command FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,

      on_f4 FOR EVENT onf4 OF cl_gui_alv_grid
        IMPORTING sender
                  e_fieldname
                  e_fieldvalue
                  es_row_no
                  er_event_data
                  et_bad_cells
                  e_display,

      data_change FOR EVENT data_changed
        OF cl_gui_alv_grid
        IMPORTING er_data_changed
                  e_onf4.


ENDCLASS.                    "lcl_event_handler DEFINITION

**********************************************************************
** Classe Internas - Implementação                                  **
**********************************************************************
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD on_f4.

    TYPES: BEGIN OF ys_sh,
             otgrp       TYPE /sprolims/tccodp-otgrp,
             descr_otgrp TYPE /sprolims/tccode-descr_otgrp,
             oteil       TYPE /sprolims/tccodp-oteil,
             descr_oteil TYPE /sprolims/tccodp-descr_oteil,
           END OF ys_sh.

    DATA: lt_ret TYPE TABLE OF ddshretval,
          lt_sh  TYPE TABLE OF ys_sh,
          ls_sh  TYPE ys_sh,
          lt_map TYPE TABLE OF dselc,
          ls_map TYPE dselc.

    DATA: lv_aufnr TYPE aufnr,
          lv_vornr TYPE vornr.

    FIELD-SYMBOLS: <fs_field>    TYPE any.

    CLEAR: lt_sh.

    READ TABLE <ft_alv> ASSIGNING <fw_alv> INDEX es_row_no-row_id.
    IF sy-subrc = 0.

      ASSIGN COMPONENT 'AUFNR' OF STRUCTURE <fw_alv> TO <fs_field>.
      IF  <fs_field> IS ASSIGNED.

        lv_aufnr = <fs_field>.

      ENDIF.

      ASSIGN COMPONENT 'VORNR' OF STRUCTURE <fw_alv> TO <fs_field>.
      IF  <fs_field> IS ASSIGNED.

        lv_vornr = <fs_field>.

      ENDIF.

      SORT t_charac_data BY order_id order_step_id control_unit_position position.

      READ TABLE t_charac_data INTO DATA(lw_charac_data) WITH KEY order_id = lv_aufnr
                                                                  order_step_id = lv_vornr
                                                                  fieldname = e_fieldname.
      IF sy-subrc = 0.

        SELECT  katalogart, codegruppe , code , kurztext
          FROM  qpct
          INTO TABLE @lt_sh
          WHERE katalogart  = @lw_charac_data-katalgart1 AND
                codegruppe  = @lw_charac_data-auswmenge1 AND
                sprache     = @sy-langu.

        ls_map-fldname = 'F0003'.
        ls_map-dyfldname = 'QPCT-CODE'.
        APPEND ls_map TO lt_map.

        CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
          EXPORTING
            retfield        = 'CODE'
            value_org       = 'S'
          TABLES
            value_tab       = lt_sh
            dynpfld_mapping = lt_map
            return_tab      = lt_ret
          EXCEPTIONS
            parameter_error = 1
            no_values_found = 2
            OTHERS          = 3.

        IF sy-subrc = 0.

          READ TABLE lt_ret INTO DATA(lw_ret) INDEX 1.
          IF sy-subrc = 0.

            ASSIGN COMPONENT e_fieldname OF STRUCTURE <fw_alv> TO <fs_field>.
            IF  <fs_field> IS ASSIGNED.

              <fs_field> = lw_ret-fieldval.

              DATA:lw_row_id TYPE lvc_s_row,
                   lw_col_id TYPE lvc_s_col,
                   lw_row_no TYPE lvc_s_roid.

*     Guarda posição do cursor
              CALL METHOD o_grid->get_current_cell
                IMPORTING
                  es_row_id = lw_row_id
                  es_col_id = lw_col_id
                  es_row_no = lw_row_no.

              CALL METHOD o_grid->refresh_table_display.

*     Recupera posição do cursor
              CALL METHOD o_grid->set_current_cell_via_id
                EXPORTING
                  is_row_id    = lw_row_id
                  is_column_id = lw_col_id
                  is_row_no    = lw_row_no.

            ENDIF.

          ENDIF.

        ENDIF.

      ENDIF.

    ENDIF.

    er_event_data->m_event_handled = 'X'.

  ENDMETHOD.

  METHOD data_change.

  ENDMETHOD.                    "data_changed

  METHOD on_hotspot_click.

  ENDMETHOD.                    "on_hotspot_click

  METHOD handle_data_changed .

    DATA : ls_mod_cell    TYPE lvc_s_modi,
           lv_value       TYPE string,
           lv_value_out   TYPE n,
           lv_valor_total TYPE wrbtr,
           lv_row_id      TYPE lvc_s_modi-row_id,
           lv_htype       TYPE dd01v-datatype.


    IF sy-ucomm = 'SALVAR'.

      SORT er_data_changed->mt_mod_cells BY row_id .

      LOOP AT er_data_changed->mt_mod_cells INTO ls_mod_cell.

        CALL METHOD er_data_changed->get_cell_value
          EXPORTING
            i_row_id    = ls_mod_cell-row_id
            i_fieldname = ls_mod_cell-fieldname
          IMPORTING
            e_value     = lv_value.

        TRY .

            REPLACE ',' IN lv_value WITH '.'.

            lv_valor_total = lv_value / 1 .

          CATCH cx_root.

*            message

*            CALL METHOD er_data_changed->modify_cell
*              EXPORTING
*                i_row_id    = ls_mod_cell-row_id
*                i_fieldname = ls_mod_cell-fieldname
*                i_value     = ''.
*
*            lv_row_id = ls_mod_cell-row_id.

        ENDTRY.

      ENDLOOP .

      CLEAR lv_row_id.

*      CALL METHOD o_grid->refresh_table_display.

    ENDIF.

  ENDMETHOD.

  METHOD handle_toolbar.

    DATA toolbar_wa TYPE stb_button.

    CLEAR toolbar_wa.
    MOVE 3 TO toolbar_wa-butn_type.
    APPEND toolbar_wa TO e_object->mt_toolbar.

    CLEAR toolbar_wa.
    MOVE: 'MARCAR'              TO toolbar_wa-function,
          icon_select_all       TO toolbar_wa-icon,
          'Marcar Todos'        TO toolbar_wa-quickinfo,
          'Marcar Todos'        TO toolbar_wa-text.
    APPEND toolbar_wa TO e_object->mt_toolbar.

    CLEAR toolbar_wa.
    MOVE 3 TO toolbar_wa-butn_type.
    APPEND toolbar_wa TO e_object->mt_toolbar.

    CLEAR toolbar_wa.
    MOVE: 'DESMARCAR'         TO toolbar_wa-function,
          icon_deselect_all   TO toolbar_wa-icon,
          'Desmarcar Todos'   TO toolbar_wa-quickinfo,
          'Desmarcar Todos'   TO toolbar_wa-text.
    APPEND toolbar_wa TO e_object->mt_toolbar.

    CLEAR toolbar_wa.
    MOVE 3 TO toolbar_wa-butn_type.
    APPEND toolbar_wa TO e_object->mt_toolbar.

    CLEAR toolbar_wa.
    MOVE: 'DEFEITO'               TO toolbar_wa-function,
          icon_new_task  TO toolbar_wa-icon,
          'Registrar Defeito'   TO toolbar_wa-quickinfo,
          'Registrar Defeito'   TO toolbar_wa-text.
    APPEND toolbar_wa          TO e_object->mt_toolbar.

    CLEAR toolbar_wa.
    MOVE: 'SALVAR'   TO toolbar_wa-function,
          icon_system_save   TO toolbar_wa-icon,
          'Gravar Resultados'   TO toolbar_wa-quickinfo,
          'Gravar Resultados'   TO toolbar_wa-text.
    APPEND toolbar_wa TO e_object->mt_toolbar.

  ENDMETHOD.      "handle_command_grid

  METHOD handle_user_command.

    DATA: lw_log TYPE bal_s_log.

    DATA: es_row_id TYPE lvc_s_row,
          es_col_id TYPE lvc_s_col,
          es_row_no TYPE lvc_s_roid.

    FIELD-SYMBOLS: <fs_field>    TYPE any.

    DATA: lv_have_null    TYPE flag,
          lv_have_results TYPE flag.

**     Guarda posição do cursor
    CALL METHOD o_grid->get_current_cell
      IMPORTING
        es_row_id = es_row_id
        es_col_id = es_col_id
        es_row_no = es_row_no.

    CASE e_ucomm.

      WHEN 'SALVAR'.

        READ TABLE <ft_alv> TRANSPORTING NO FIELDS WITH KEY ('MARK') = abap_true.
        IF sy-subrc <> 0.

          MESSAGE 'Selecionar ao menos uma linha' TYPE 'I' . " DISPLAY LIKE 'W'.

        ELSE.

          LOOP AT <ft_alv> ASSIGNING <fw_alv>.

            ASSIGN COMPONENT 'MARK' OF STRUCTURE <fw_alv> TO <fs_field>.
            IF  <fs_field> IS ASSIGNED AND
                <fs_field> = 'X'.

              PERFORM zf_check_if_lines_have_null USING lv_have_null.

              IF lv_have_null IS NOT INITIAL.
                EXIT.
              ENDIF.

            ENDIF.

          ENDLOOP.

          LOOP AT <ft_alv> ASSIGNING <fw_alv>.

            ASSIGN COMPONENT 'MARK' OF STRUCTURE <fw_alv> TO <fs_field>.
            IF  <fs_field> IS ASSIGNED AND
                <fs_field> = 'X'.

              PERFORM zf_check_if_lines_have_result USING lv_have_results.

              IF lv_have_results IS NOT INITIAL.

                DATA: lv_popup_return TYPE n LENGTH 1.

                CALL FUNCTION 'POPUP_TO_CONFIRM'
                  EXPORTING
                    titlebar              = 'Confirmação'
                    text_question         = 'Uma das etapas selecionadas já possui resultado. Deseja continuar?'
                    text_button_1         = 'Sim'
                    text_button_2         = 'Não'
                    default_button        = '2'
                    display_cancel_button = ''
                  IMPORTING
                    answer                = lv_popup_return " to hold the FM's return value
                  EXCEPTIONS
                    text_not_found        = 1
                    OTHERS                = 2.

                IF sy-subrc <> 0.
                  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
                ENDIF.

                IF lv_popup_return EQ '1'.

                  CLEAR: lv_have_results.
                  EXIT.

                ELSEIF lv_popup_return EQ '2'.

                  EXIT.

                ENDIF.

              ENDIF.

            ENDIF.

          ENDLOOP.

          IF  lv_have_null IS INITIAL AND
              lv_have_results IS INITIAL.

            lw_log-object = 'ZQM'.
            lw_log-subobject = 'ENT_RES'.
            lw_log-alprog = sy-repid.

            CALL FUNCTION 'BAL_LOG_CREATE'
              EXPORTING
                i_s_log                 = lw_log
              IMPORTING
                e_log_handle            = v_log_handle
              EXCEPTIONS
                log_header_inconsistent = 1
                OTHERS                  = 2.

            LOOP AT <ft_alv> ASSIGNING <fw_alv>.

              ASSIGN COMPONENT 'MARK' OF STRUCTURE <fw_alv> TO <fs_field>.
              IF  <fs_field> IS ASSIGNED AND
                  <fs_field> = 'X'.

                PERFORM zf_get_values_from_line.

              ENDIF.

            ENDLOOP.


            PERFORM zf_check_if_saved.

            CALL FUNCTION 'BAL_DB_SAVE'
              EXPORTING
                i_save_all       = abap_true
              EXCEPTIONS
                log_not_found    = 1
                save_not_allowed = 2
                numbering_error  = 3
                OTHERS           = 4.

            CALL FUNCTION 'C14Z_MESSAGES_SHOW_AS_POPUP'
              TABLES
                i_message_tab = t_message_tab.

            CLEAR: s_data[] , s_oper[] , s_orde[], s_cent[], s_wkce[].
            CLEAR: s_data , s_oper , s_orde, s_cent, s_wkce.
            CLEAR: t_charac , t_charac_data , t_charac_data_full , t_column , t_defects , t_defects_dialog.
            CLEAR: t_exclude , t_fieldcat , t_fieldcat_1.
            CLEAR: t_message_tab.
            CLEAR: lv_have_null.

            LEAVE TO SCREEN 0.

          ENDIF.

          CLEAR lv_have_null.

        ENDIF.

**     Recupera posição do cursor
*        CALL METHOD o_grid->set_current_cell_via_id
*          EXPORTING
*            is_row_id    = es_row_id
*            is_column_id = es_col_id
*            is_row_no    = es_row_no.

      WHEN 'DEFEITO'.

        PERFORM zf_display_defect_dialog_box USING es_row_id es_col_id es_row_no.

      WHEN 'MARCAR'.

        LOOP AT <ft_alv> ASSIGNING FIELD-SYMBOL(<fs_w_line>).

          ASSIGN COMPONENT 'MARK' OF STRUCTURE <fs_w_line> TO <fs_field>.
          IF <fs_field> IS ASSIGNED.

            <fs_field> = 'X'.

          ENDIF.

        ENDLOOP.

        CALL METHOD o_grid->refresh_table_display.
*SPRO(MC):8000031831, 41150-Fiori mensagem resultados ñ salvos {
        CALL METHOD cl_gui_cfw=>flush.
*SPRO(MC):8000031831, 41150-Fiori mensagem resultados ñ salvos }

      WHEN 'DESMARCAR'.

        LOOP AT <ft_alv> ASSIGNING <fs_w_line>.

          ASSIGN COMPONENT 'MARK' OF STRUCTURE <fs_w_line> TO <fs_field>.
          IF <fs_field> IS ASSIGNED.

            <fs_field> = ''.

          ENDIF.

        ENDLOOP.

        CALL METHOD o_grid->refresh_table_display.
*SPRO(MC):8000031831, 41150-Fiori mensagem resultados ñ salvos {
        CALL METHOD cl_gui_cfw=>flush.
*SPRO(MC):8000031831, 41150-Fiori mensagem resultados ñ salvos }

    ENDCASE.

  ENDMETHOD.      "handle_command_grid


ENDCLASS.                    "

DATA: o_handler    TYPE REF TO lcl_event_handler.

*----------------------------------------------------------------------*
*                   Classes - Definição                                *
*----------------------------------------------------------------------*
CLASS lcl_event_dialogbox DEFINITION.

  PUBLIC SECTION.

    METHODS:
*   Barra de Ferramentas
      handle_toolbar
        FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object e_interactive,

      handle_close
        FOR EVENT close OF cl_gui_dialogbox_container
        IMPORTING sender,

*   Eventos
      handle_user_command
        FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,

      on_f4 FOR EVENT onf4 OF cl_gui_alv_grid
        IMPORTING sender
                  e_fieldname
                  e_fieldvalue
                  es_row_no
                  er_event_data
                  et_bad_cells
                  e_display.

  PRIVATE SECTION.

ENDCLASS.                    "lcl_event_receiver DEFINITION

*----------------------------------------------------------------------*
*                   Classes - Implementação                            *
*----------------------------------------------------------------------*
CLASS lcl_event_dialogbox IMPLEMENTATION.

  METHOD handle_toolbar.

    CLEAR e_object->mt_toolbar.

    DATA toolbar_wa TYPE stb_button.

    CLEAR toolbar_wa.
    MOVE 3 TO toolbar_wa-butn_type.
    APPEND toolbar_wa TO e_object->mt_toolbar.

    CLEAR toolbar_wa.
    MOVE: 'SALVAR'   TO toolbar_wa-function,
          icon_system_save   TO toolbar_wa-icon,
          'Gravar Defeitos'   TO toolbar_wa-quickinfo,
          'Gravar Defeitos'   TO toolbar_wa-text.
    APPEND toolbar_wa TO e_object->mt_toolbar.

  ENDMETHOD.

  METHOD on_f4.

    TYPES: BEGIN OF ys_sh,
             otgrp       TYPE /sprolims/tccodp-otgrp,
             descr_otgrp TYPE /sprolims/tccode-descr_otgrp,
             oteil       TYPE /sprolims/tccodp-oteil,
             descr_oteil TYPE /sprolims/tccodp-descr_oteil,
           END OF ys_sh.

    DATA: lt_ret TYPE TABLE OF ddshretval,
          lt_sh  TYPE TABLE OF ys_sh,
          ls_sh  TYPE ys_sh,
          lt_map TYPE TABLE OF dselc,
          ls_map TYPE dselc.

    DATA: lv_aufnr TYPE aufnr,
          lv_vornr TYPE vornr.

    FIELD-SYMBOLS: <fs_field>    TYPE any.

    CLEAR: lt_sh.

    READ TABLE <ft_alv> ASSIGNING <fw_alv> INDEX es_row_no-row_id.
    IF sy-subrc = 0.

      ASSIGN COMPONENT 'AUFNR' OF STRUCTURE <fw_alv> TO <fs_field>.
      IF  <fs_field> IS ASSIGNED.

        lv_aufnr = <fs_field>.

      ENDIF.

      ASSIGN COMPONENT 'VORNR' OF STRUCTURE <fw_alv> TO <fs_field>.
      IF  <fs_field> IS ASSIGNED.

        lv_vornr = <fs_field>.

      ENDIF.

      READ TABLE t_defects_dialog ASSIGNING FIELD-SYMBOL(<fs_defects_dialog>) INDEX es_row_no-row_id.
      IF sy-subrc = 0.

        SELECT  katalogart, codegruppe , code , kurztext
          FROM  qpct
          INTO TABLE @lt_sh
          WHERE katalogart  = @<fs_defects_dialog>-katalgart2 AND
                codegruppe  = @<fs_defects_dialog>-fegrp AND
                sprache     = @sy-langu.

        ls_map-fldname = 'F0003'.
        ls_map-dyfldname = 'QPCT-CODE'.
        APPEND ls_map TO lt_map.

        CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
          EXPORTING
            retfield        = 'CODE'
            value_org       = 'S'
          TABLES
            value_tab       = lt_sh
            dynpfld_mapping = lt_map
            return_tab      = lt_ret
          EXCEPTIONS
            parameter_error = 1
            no_values_found = 2
            OTHERS          = 3.

        IF sy-subrc = 0.

          READ TABLE lt_ret INTO DATA(lw_ret) INDEX 1.
          IF sy-subrc = 0.

            <fs_defects_dialog>-fecod = lw_ret-fieldval.

          ENDIF.

          DATA:lw_row_id TYPE lvc_s_row,
               lw_col_id TYPE lvc_s_col,
               lw_row_no TYPE lvc_s_roid.

*     Guarda posição do cursor
          CALL METHOD o_dialogbox_grid->get_current_cell
            IMPORTING
              es_row_id = lw_row_id
              es_col_id = lw_col_id
              es_row_no = lw_row_no.

          CALL METHOD o_dialogbox_grid->refresh_table_display.

*     Recupera posição do cursor
          CALL METHOD o_dialogbox_grid->set_current_cell_via_id
            EXPORTING
              is_row_id    = lw_row_id
              is_column_id = lw_col_id
              is_row_no    = lw_row_no.


        ENDIF.

      ENDIF.

    ENDIF.

    er_event_data->m_event_handled = 'X'.
  ENDMETHOD.

  METHOD handle_user_command.

    CASE e_ucomm.

      WHEN 'SALVAR'.

        LOOP AT t_defects_dialog INTO DATA(lw_defect_dialog) WHERE fecod IS NOT INITIAL.

          READ TABLE t_defects ASSIGNING FIELD-SYMBOL(<fs_defect_dialog>)
                              WITH KEY  aufnr     = lw_defect_dialog-aufnr
                                        vornr     = lw_defect_dialog-vornr
                                        fieldname = lw_defect_dialog-fieldname
                                        fegrp     = lw_defect_dialog-fegrp
                                        fecod     = lw_defect_dialog-fecod .

          IF sy-subrc = 0.

            <fs_defect_dialog> = lw_defect_dialog.

          ELSE.

            APPEND lw_defect_dialog TO t_defects.

          ENDIF.

        ENDLOOP.

        CALL METHOD o_dialogbox_cont->set_visible
          EXPORTING
            visible = space.

    ENDCASE.

  ENDMETHOD.                           "handle_user_command

  METHOD handle_close.

    CALL METHOD sender->set_visible
      EXPORTING
        visible = space.

  ENDMETHOD.                    "handle_close

ENDCLASS.                    "lcl_event_receiver IMPLEMENTATION

DATA: o_event_dialogbox          TYPE REF TO lcl_event_dialogbox.
