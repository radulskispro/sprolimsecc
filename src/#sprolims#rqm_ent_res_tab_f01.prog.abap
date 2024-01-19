*&---------------------------------------------------------------------*
*& Include          ZRQM_ENTRADA_RESULTADO_TAB_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& FORM ZF_GET_OPER_CHAR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_get_oper_char .

  DATA: lw_charac LIKE LINE OF t_charac.

  DATA: lv_index     TYPE c LENGTH 2,
        lv_fieldname TYPE lvc_fname.

  DATA: lv_prueflos  TYPE /sprolims/cds_sqm_c_ord_op_cha-prueflos,
        lv_vorglfnr  TYPE /sprolims/cds_sqm_c_ord_op_cha-vorglfnr,
        lv_verwmerkm TYPE /sprolims/cds_sqm_c_ord_op_cha-verwmerkm,
        lv_position  TYPE n LENGTH 2.

  SELECT  ordem_oper~order_id , ordem_oper~solicitation , ordem_oper~batch_number,
          ordem_oper~order_step_id , ordem_oper~order_step_plant , ordem_oper~work_center,
          ordem_oper~production_batch_number , ordem_oper~sample_number
    FROM  /sprolims/zcdsqr AS ordem_oper
    INTO TABLE @t_operac_data
    WHERE ordem_oper~order_id      IN @s_orde AND
          ordem_oper~order_step_id IN @s_oper AND
          ordem_oper~work_center   IN @s_wkce AND
          ordem_oper~plant         IN @s_cent AND
          ordem_oper~sample_number IN @s_samp
    ORDER BY ordem_oper~order_id , ordem_oper~order_step_id.

  IF t_operac_data IS NOT INITIAL.

    SELECT ord_opr_char~prueflos  , ord_opr_char~vorglfnr     , ord_opr_char~merknr , ord_opr_char~verwmerkm ,
           ord_opr_char~kurztext  , ord_opr_char~sollstpumf   , ord_opr_char~inspspecrecordingtype,
           ord_opr_char~formel1   , ord_opr_char~katalgart1   , ord_opr_char~auswmenge1,
           ord_opr_char~katalgart2, ord_opr_char~auswmenge2,
           ord_opr_char~order_id  , ord_opr_char~order_step_id,
           ord_opr_char~step_description, ord_opr_char~work_center, ord_opr_char~order_step_plant,
           ord_opr_char~tplnr,
          ord_opr_char~production_batch_number , ord_opr_char~sample_number
      FROM  /sprolims/cds_sqm_c_ord_op_cha AS ord_opr_char
      INTO TABLE @t_charac_data_full
      WHERE ord_opr_char~order_id             IN @s_orde AND
            ord_opr_char~order_step_id        IN @s_oper AND
            ord_opr_char~erstelldat           IN @s_data AND
            ord_opr_char~work_center          IN @s_wkce AND
            ord_opr_char~plant                IN @s_cent AND
            ord_opr_char~sample_number        IN @s_samp AND
            ord_opr_char~has_du               = ''.

    "Define a posição da caracteristica na hora de ser gravada
    SORT t_charac_data_full BY prueflos vorglfnr merknr.
    LOOP AT t_charac_data_full INTO DATA(lw_charac_data_full).

      IF ( lv_prueflos IS INITIAL AND
           lv_vorglfnr IS INITIAL ) OR
         ( lv_prueflos <> lw_charac_data_full-prueflos ) OR
         ( lv_vorglfnr <> lw_charac_data_full-vorglfnr ).

        lv_position = 1.

      ELSE.

        lv_position = lv_position + 1.

      ENDIF.

      lv_prueflos = lw_charac_data_full-prueflos.
      lv_vorglfnr = lw_charac_data_full-vorglfnr.

      IF lw_charac_data_full-formel1 IS INITIAL.

        lw_charac_data_full-position = lv_position.

        APPEND lw_charac_data_full TO t_charac_data.

      ENDIF.

    ENDLOOP.


    "Garante que somente as operações achadas no segundo select serão utlizadas
    LOOP AT t_operac_data INTO DATA(lw_operac_data).
      DATA(lv_index_aux) = sy-tabix.

      READ TABLE t_charac_data INTO DATA(lw_charac_data) WITH KEY order_id      = lw_operac_data-order_id
                                                                  order_step_id = lw_operac_data-order_step_id.
      IF sy-subrc <> 0.

        DELETE t_operac_data INDEX lv_index_aux.

      ENDIF.

    ENDLOOP.

    DATA(lt_caracteristicas_aux1) = t_charac_data.
    DATA(lt_caracteristicas_aux2) = t_charac_data.
    CLEAR lt_caracteristicas_aux2.

    "Busca quais casos possuem repetição (não unidade de controle)

    CLEAR: lv_prueflos , lv_vorglfnr , lv_verwmerkm.


    DATA: lv_controle_repeticoes  TYPE i,
          lv_index_repeticoes     TYPE n,
          lv_fieldname_repeticoes TYPE lvc_fname.
    DATA(lt_caracter_aux_repet) = lt_caracteristicas_aux1.
    CLEAR lt_caracter_aux_repet.

    LOOP AT lt_caracteristicas_aux1 ASSIGNING FIELD-SYMBOL(<fs_caracter_aux_repet>).

      CONCATENATE <fs_caracter_aux_repet>-vorglfnr
                  <fs_caracter_aux_repet>-verwmerkm
                  INTO lv_fieldname_repeticoes.

      "lv_controle_repeticoes = 1.

      LOOP AT lt_caracteristicas_aux1 TRANSPORTING NO FIELDS WHERE  prueflos = <fs_caracter_aux_repet>-prueflos AND
                                                                  vorglfnr = <fs_caracter_aux_repet>-vorglfnr AND
                                                                  verwmerkm = <fs_caracter_aux_repet>-verwmerkm.
        lv_controle_repeticoes = lv_controle_repeticoes + 1.

      ENDLOOP.

      IF lv_controle_repeticoes > 1.

        IF (  lv_prueflos IS INITIAL AND
              lv_vorglfnr IS INITIAL AND
              lv_verwmerkm IS INITIAL ) OR
            ( lv_prueflos   <> <fs_caracter_aux_repet>-prueflos ) OR
            ( lv_vorglfnr   <> <fs_caracter_aux_repet>-vorglfnr ) OR
            ( lv_verwmerkm  <> <fs_caracter_aux_repet>-verwmerkm ).

          lv_index_repeticoes = 1.

          CLEAR: lv_controle_repeticoes, lv_prueflos , lv_vorglfnr , lv_verwmerkm.

        ELSE.

          lv_index_repeticoes = lv_index_repeticoes + 1.

        ENDIF.


        DATA(lv_kurztext_rept) = <fs_caracter_aux_repet>-kurztext.

        CONCATENATE <fs_caracter_aux_repet>-kurztext '(' lv_index_repeticoes ')' INTO  <fs_caracter_aux_repet>-kurztext.
        CONCATENATE lv_fieldname_repeticoes '-' lv_index_repeticoes INTO <fs_caracter_aux_repet>-fieldname.

        APPEND <fs_caracter_aux_repet> TO lt_caracter_aux_repet.

        lv_prueflos   = <fs_caracter_aux_repet>-prueflos .
        lv_vorglfnr   = <fs_caracter_aux_repet>-vorglfnr .
        lv_verwmerkm  = <fs_caracter_aux_repet>-verwmerkm.

      ELSE.

        CLEAR: lv_controle_repeticoes, lv_prueflos , lv_vorglfnr , lv_verwmerkm , lv_fieldname.

      ENDIF.

    ENDLOOP.

    "Define o nome interno da coluna e o nome externo quando é necessário haver repetições ou unidades de controle

    LOOP AT lt_caracteristicas_aux1 ASSIGNING FIELD-SYMBOL(<fs_caracteristicas_aux>).

      CONCATENATE <fs_caracteristicas_aux>-vorglfnr
                  <fs_caracteristicas_aux>-verwmerkm
                  INTO lv_fieldname.

      DATA(lv_kurztext) = <fs_caracteristicas_aux>-kurztext.

      IF  <fs_caracteristicas_aux>-inspspecrecordingtype IS INITIAL OR "Não possui unidade de controle
        ( <fs_caracteristicas_aux>-inspspecrecordingtype IS NOT INITIAL AND
          <fs_caracteristicas_aux>-sollstpumf = 1 ).

        <fs_caracteristicas_aux>-sollstpumf = 1.

        READ TABLE lt_caracter_aux_repet ASSIGNING <fs_caracter_aux_repet> WITH KEY prueflos   = <fs_caracteristicas_aux>-prueflos
                                                                                    vorglfnr   = <fs_caracteristicas_aux>-vorglfnr
                                                                                    merknr     = <fs_caracteristicas_aux>-merknr
                                                                                    verwmerkm  = <fs_caracteristicas_aux>-verwmerkm
                                                                                    fieldname  = <fs_caracteristicas_aux>-fieldname.
        IF sy-subrc = 0.

          lv_fieldname = <fs_caracter_aux_repet>-fieldname.
          lv_kurztext  = <fs_caracter_aux_repet>-kurztext.

        ENDIF.

        READ TABLE t_charac_data ASSIGNING FIELD-SYMBOL(<fs_ch_dt>) WITH KEY prueflos   = <fs_caracteristicas_aux>-prueflos
                                                                             vorglfnr   = <fs_caracteristicas_aux>-vorglfnr
                                                                             merknr     = <fs_caracteristicas_aux>-merknr
                                                                             verwmerkm  = <fs_caracteristicas_aux>-verwmerkm.
        IF sy-subrc = 0.

          <fs_ch_dt>-fieldname = lv_fieldname.
          <fs_ch_dt>-kurztext  = lv_kurztext.

        ENDIF.

        <fs_caracteristicas_aux>-fieldname = lv_fieldname.

      ELSE. "Possui unidade de controle

        DO <fs_caracteristicas_aux>-sollstpumf TIMES.

          lv_index = sy-index.
          lv_kurztext = <fs_caracteristicas_aux>-kurztext.

          CONCATENATE <fs_caracteristicas_aux>-kurztext '(' lv_index ')' INTO  <fs_caracteristicas_aux>-kurztext.
          CONCATENATE lv_fieldname '-' lv_index INTO <fs_caracteristicas_aux>-fieldname.
          <fs_caracteristicas_aux>-control_unit_position = lv_index.

          APPEND <fs_caracteristicas_aux> TO lt_caracteristicas_aux2.

          <fs_caracteristicas_aux>-kurztext = lv_kurztext.

        ENDDO.

        CLEAR <fs_caracteristicas_aux>.

      ENDIF.

    ENDLOOP.

    APPEND LINES OF lt_caracteristicas_aux2 TO lt_caracteristicas_aux1 .
    APPEND LINES OF lt_caracteristicas_aux2 TO t_charac_data.

    SORT lt_caracteristicas_aux1 BY verwmerkm fieldname prueflos.
    DELETE ADJACENT DUPLICATES FROM lt_caracteristicas_aux1 COMPARING verwmerkm fieldname.
    DELETE lt_caracteristicas_aux1 WHERE prueflos IS INITIAL.

    SORT lt_caracteristicas_aux1 BY prueflos vorglfnr merknr verwmerkm control_unit_position  .

    LOOP AT lt_caracteristicas_aux1 INTO DATA(lw_caracteristicas_aux).


      lw_charac-vorglfnr              = lw_caracteristicas_aux-vorglfnr.
      lw_charac-merknr                = lw_caracteristicas_aux-merknr.
      lw_charac-kurztext              = lw_caracteristicas_aux-kurztext.
      lw_charac-control_unit_position = lw_caracteristicas_aux-control_unit_position.
      lw_charac-verwmerkm             = lw_caracteristicas_aux-verwmerkm.
      lw_charac-fieldname             = lw_caracteristicas_aux-fieldname.

      IF lw_caracteristicas_aux-katalgart1 IS NOT INITIAL.

        lw_charac-has_f4 = 'X'.

      ELSE.

        lw_charac-has_f4 = ''.

      ENDIF.

      APPEND lw_charac TO t_charac.

    ENDLOOP.

    SORT t_charac BY fieldname.

    DELETE ADJACENT DUPLICATES FROM t_charac COMPARING fieldname.

    SORT t_charac BY vorglfnr control_unit_position merknr verwmerkm .

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      FORM ZF_GET_TABLE_STRUCTURE
*&---------------------------------------------------------------------*
*       Get structure of an SAP table
*----------------------------------------------------------------------*
FORM zf_get_table_structure.

  DATA: lo_ref_table_descr TYPE REF TO cl_abap_structdescr.
  DATA: lt_tabdescr TYPE abap_compdescr_tab,
        lw_tabdescr TYPE abap_compdescr.
  DATA: lv_lin             TYPE sy-tfill.

* fill the data into fieldcatlog of static field
  PERFORM zf_build_fieldcatalog USING t_fieldcat.

* Return structure of the table.
  lo_ref_table_descr ?= cl_abap_typedescr=>describe_by_data( t_column ).
  lt_tabdescr[] = lo_ref_table_descr->components[].

* get no of lines..
  DESCRIBE TABLE t_fieldcat LINES lv_lin .

  w_fieldcat-col_pos = lv_lin.

* fill dynamic field into fields cate.
  READ TABLE lt_tabdescr INTO lw_tabdescr INDEX 1.
  IF sy-subrc = 0.

    LOOP AT t_charac INTO DATA(lw_charac).

      w_fieldcat-fieldname = lw_charac-fieldname.
      w_fieldcat-coltext   = lw_charac-kurztext.
      w_fieldcat-col_pos   = w_fieldcat-col_pos + 1  .
      w_fieldcat-inttype   = lw_tabdescr-type_kind.
      w_fieldcat-intlen    = lw_tabdescr-length.
      w_fieldcat-f4availabl = lw_charac-has_f4.

      APPEND  w_fieldcat TO  t_fieldcat.

    ENDLOOP.

  ENDIF.

ENDFORM.                    "get_table_structure

*&---------------------------------------------------------------------*
*&      FORM ZF_CREATE_ITAB_DYNAMICALLY
*&---------------------------------------------------------------------*
*       Create internal table dynamically
*----------------------------------------------------------------------*
FORM zf_create_itab_dynamically.

* Create dynamic internal table and assign to Field-Symbol
  CLEAR w_fieldcat.

*move fields from T_FIELDCAT into T_FIELDCAT_1.
  t_fieldcat_1 = t_fieldcat.

* Use ref table CALENDAR_TYPE and ref field 'COLTAB'
  w_fieldcat-fieldname = 'CELLCOLOR'.
  w_fieldcat-ref_table = 'CALENDAR_TYPE'.
  w_fieldcat-ref_field = 'COLTAB'.
  APPEND w_fieldcat TO t_fieldcat.
  CLEAR w_fieldcat.

  w_fieldcat-fieldname = 'CELLSTYLE'.
  w_fieldcat-ref_table = '/SPROLIMS/STQM_ALV_CELLSTYL'.
  w_fieldcat-ref_field = 'CELLSTYLE'.
  APPEND w_fieldcat TO t_fieldcat.

*Create a dynamic table with t_fieldcat.
* and Use t_fieldcat_1 to display ALV.
  CALL METHOD cl_alv_table_create=>create_dynamic_table
    EXPORTING
      it_fieldcatalog = t_fieldcat
    IMPORTING
      ep_table        = dyn_table.

  ASSIGN dyn_table->* TO <ft_alv>.
* Create dynamic work area and assign to Field Symbol
  CREATE DATA dyn_line LIKE LINE OF <ft_alv> .
  ASSIGN dyn_line->* TO <fw_alv> .

ENDFORM.                    "create_itab_dynamically
*&---------------------------------------------------------------------*
*&      FORM ZF_GET_DATA
*&---------------------------------------------------------------------*
*       Populate dynamic itab
*----------------------------------------------------------------------*
FORM zf_get_data.

  FIELD-SYMBOLS: <fs_field>    TYPE any,
                 <fs_color>    TYPE lvc_t_scol,
                 <fs_style>    TYPE lvc_t_styl,
                 <fs_fieldcat> TYPE lvc_s_fcat.

  DATA: it_cellcolor TYPE lvc_t_scol,
        it_cellstyle TYPE lvc_t_styl.

  LOOP AT t_operac_data INTO DATA(lw_operac_data).

    ASSIGN COMPONENT 'AUFNR' OF STRUCTURE <fw_alv> TO <fs_field>.
    IF <fs_field> IS ASSIGNED.

      <fs_field> = lw_operac_data-order_id.

    ENDIF.

    ASSIGN COMPONENT 'PRUEFLOS' OF STRUCTURE <fw_alv> TO <fs_field>.
    IF <fs_field> IS ASSIGNED.

      <fs_field> = lw_operac_data-batch_number.

    ENDIF.

    ASSIGN COMPONENT 'VORNR' OF STRUCTURE <fw_alv> TO <fs_field>.
    IF <fs_field> IS ASSIGNED.

      <fs_field> = lw_operac_data-order_step_id.

    ENDIF.

    ASSIGN COMPONENT 'WORK_CENTER' OF STRUCTURE <fw_alv> TO <fs_field>.
    IF <fs_field> IS ASSIGNED.

      <fs_field> = lw_operac_data-work_center.

    ENDIF.

    ASSIGN COMPONENT 'SAMPLE_NUMBER' OF STRUCTURE <fw_alv> TO <fs_field>.
    IF <fs_field> IS ASSIGNED.

      <fs_field> = lw_operac_data-sample_number.

    ENDIF.

    ASSIGN COMPONENT 'PRODUCTION_BATCH_NUMBER' OF STRUCTURE <fw_alv> TO <fs_field>.
    IF <fs_field> IS ASSIGNED.

      <fs_field> = lw_operac_data-production_batch_number.

    ENDIF.

    LOOP AT t_fieldcat ASSIGNING <fs_fieldcat>.

*Dynamic editable
      ASSIGN COMPONENT 'CELLSTYLE' OF STRUCTURE <fw_alv> TO <fs_style>.

      CASE <fs_fieldcat>-fieldname.
        WHEN 'MARK'.

          PERFORM zf_editable_cell  USING <fs_fieldcat>-fieldname
                                      CHANGING it_cellstyle.

        WHEN 'AUFNR' OR 'PRUEFLOS' OR 'VORNR' OR 'WORK_CENTER' OR 'SAMPLE_NUMBER' OR 'PRODUCTION_BATCH_NUMBER'.

          PERFORM zf_not_editable_cell  USING <fs_fieldcat>-fieldname
                                    CHANGING it_cellstyle.

        WHEN OTHERS.


*          READ TABLE t_charac_data INTO DATA(lw_charac_data) WITH KEY kurztext      = <fs_fieldcat>-coltext
          READ TABLE t_charac_data INTO DATA(lw_charac_data) WITH KEY fieldname      = <fs_fieldcat>-fieldname
                                                                      order_id       = lw_operac_data-order_id
                                                                      order_step_id  = lw_operac_data-order_step_id.
          IF sy-subrc = 0.

            PERFORM zf_editable_cell  USING <fs_fieldcat>-fieldname
                                      CHANGING it_cellstyle.

            PERFORM zf_check_if_cell_calculated USING <fs_fieldcat>-fieldname
                                                 lw_charac_data-verwmerkm
                                                 lw_charac_data-order_step_plant
                                                 lw_charac_data-order_id
                                                 lw_charac_data-order_step_id
                                           CHANGING it_cellstyle.

          ELSE.

            PERFORM zf_not_editable_cell  USING <fs_fieldcat>-fieldname
                                    CHANGING it_cellstyle.

          ENDIF.

      ENDCASE.

      <fs_style> = it_cellstyle.

    ENDLOOP.

    APPEND <fw_alv> TO <ft_alv>.

    CLEAR it_cellstyle.

  ENDLOOP.

ENDFORM.                    "get_data

**&---------------------------------------------------------------------*
**&      FORM ZF_MODIFY_CELL_COLOR
**&---------------------------------------------------------------------*
**      -->P_FIELDNAME   text
**      -->PT_CELLCOLOR  text
**----------------------------------------------------------------------*
*FORM zf_modify_cell_color   USING     p_fieldname   TYPE lvc_fname
*                            CHANGING  pt_cellcolor  TYPE table.
*
*  DATA: lw_cellcolor TYPE lvc_s_scol,
*        lv_date      TYPE datum,
*        day_p        TYPE p.
*
*  IF p_fieldname+8(2) = '_R'.
*    lv_date =  p_fieldname+8(2).
*  ELSE.
*    lv_date =  p_fieldname.
*  ENDIF.
*
*  day_p = lv_date  MOD 7.
*
*  IF day_p > 1.
*    day_p = day_p - 1.
*  ELSE.
*    day_p = day_p + 6.
*  ENDIF.
*
*  IF day_p = 6 OR day_p = 7.
*    IF p_fieldname+8(2) = '_R'.
*      lw_cellcolor-color-col = 7.       " Red.
*      lw_cellcolor-color-int = 0.
*      lw_cellcolor-color-inv = 0.
*    ELSE.
*      lw_cellcolor-color-col = 7.       " Red.
*      lw_cellcolor-color-int = 1.
*      lw_cellcolor-color-inv = 1.
*    ENDIF.
*    lw_cellcolor-fname = p_fieldname.
*    APPEND lw_cellcolor TO pt_cellcolor.
*
*  ELSE.
*    CLEAR lw_cellcolor.
*  ENDIF.
*
*  IF p_fieldname+0(8) = sy-datum.
*
*    lw_cellcolor-fname = p_fieldname.
*    lw_cellcolor-color-col = 3.       " Red.
*    lw_cellcolor-color-int = 1.
*    lw_cellcolor-color-inv = 1.
*    APPEND lw_cellcolor TO pt_cellcolor.
*    CONCATENATE p_fieldname '_R' INTO  lw_cellcolor-fname .
*    lw_cellcolor-color-col = 3.       " Red.
*    lw_cellcolor-color-int = 1.
*    lw_cellcolor-color-inv = 1.
*    APPEND lw_cellcolor TO pt_cellcolor.
*  ENDIF.
*
*ENDFORM.                    " MODIFY_CELL_COLOR

*&---------------------------------------------------------------------*
*&      FORM ZF_BUILD_FIELDCATALOG
*&---------------------------------------------------------------------*
*       Build Fieldcatalog for ALV Report, using SAP table structure
*----------------------------------------------------------------------*
FORM zf_build_fieldcatalog USING p_it_fieldcat  TYPE lvc_t_fcat.

** ALV Function module to build field catalog from SAP table structure

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
*     I_BUFFER_ACTIVE        =
      i_structure_name       = '/SPROLIMS/STQM_ALV_ENT_RES'
      i_client_never_display = 'X'
      i_bypassing_buffer     = 'X'
*     I_INTERNAL_TABNAME     =
    CHANGING
      ct_fieldcat            = p_it_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  LOOP AT p_it_fieldcat ASSIGNING FIELD-SYMBOL(<fs_fieldcat>).
    CASE <fs_fieldcat>-fieldname.
      WHEN 'MARK'.
        <fs_fieldcat>-reptext   = 'Sel'.
        <fs_fieldcat>-checkbox  = 'X'.
        <fs_fieldcat>-fix_column = 'X'.
      WHEN OTHERS.
        <fs_fieldcat>-fix_column = 'X'.
    ENDCASE.
  ENDLOOP.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    " BUILD_FIELDCATALOG

*&---------------------------------------------------------------------*
*&      FORM ZF_DISPLAY_ALV_REPORT
*&---------------------------------------------------------------------*
*       Display report using ALV grid
*----------------------------------------------------------------------*
FORM zf_display_alv_report.

  PERFORM zf_check_if_has_results.

  PERFORM zf_exclude_toolbar.

  CREATE OBJECT o_container
    EXPORTING
      container_name = 'ALV'.

  CREATE OBJECT o_grid
    EXPORTING
      i_parent = o_container.

*   Cria objeto event handler.
  CREATE OBJECT o_handler.

*   Registra evento
  SET HANDLER: o_handler->on_hotspot_click    FOR o_grid,
               o_handler->handle_toolbar      FOR o_grid,
               o_handler->handle_user_command FOR o_grid,
               o_handler->handle_data_changed FOR o_grid,
               o_handler->on_f4               FOR o_grid.

  w_layout-col_opt     = 'X'.
  w_layout-cwidth_opt  = 'X'.
  w_layout-sel_mode    = 'B'.
  w_layout-no_rowmark  = 'X'.
  w_layout-ctab_fname  = 'CELLCOLOR'.
  w_layout-stylefname  = 'CELLSTYLE'.

  DATA: lt_f4 TYPE lvc_t_f4,
        lw_f4 LIKE LINE OF lt_f4.

  DATA(lt_charac_aux) = t_charac.
  SORT lt_charac_aux BY fieldname.

  LOOP AT lt_charac_aux INTO DATA(lw_charac) WHERE has_f4 = 'X'.

    lw_f4-fieldname   = lw_charac-fieldname.
    lw_f4-register    = 'X' .
    lw_f4-getbefore   = 'X' .
    lw_f4-chngeafter  = 'X'.

    READ TABLE lt_f4 TRANSPORTING NO FIELDS WITH TABLE KEY fieldname = lw_f4-fieldname.
    IF sy-subrc <> 0.

      APPEND lw_f4 TO lt_f4 .

    ENDIF.

  ENDLOOP.

  CALL METHOD o_grid->register_f4_for_fields
    EXPORTING
      it_f4 = lt_f4[].

  w_variant-report = sy-repid.

  CALL METHOD o_grid->set_table_for_first_display
    EXPORTING
      is_variant           = gv_variant
      i_save               = 'A'
      i_default            = 'X'
      is_layout            = w_layout
      it_toolbar_excluding = t_exclude
    CHANGING
      it_fieldcatalog      = t_fieldcat_1
      it_outtab            = <ft_alv>.

*For Editable alv...
  CALL METHOD o_grid->set_ready_for_input
    EXPORTING
      i_ready_for_input = 1.

*SPRO(MC):8000031831, 41150-Fiori mensagem resultados ñ salvos {
  IF sp_perf IS INITIAL.
    CALL METHOD o_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified.
  ENDIF.
*SPRO(MC):8000031831, 41150-Fiori mensagem resultados ñ salvos }

ENDFORM.                    " DISPLAY_ALV_REPORT
*&---------------------------------------------------------------------*
*&      Form  ZF_EXCLUDE_TOOLBAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM zf_exclude_toolbar .

  w_exclude = cl_gui_alv_grid=>mc_fc_loc_append_row.
  APPEND w_exclude TO t_exclude.
  w_exclude = cl_gui_alv_grid=>mc_fc_loc_delete_row.
  APPEND w_exclude TO t_exclude.
  w_exclude = cl_gui_alv_grid=>mc_fc_loc_insert_row.
  APPEND w_exclude TO t_exclude.
  w_exclude = cl_gui_alv_grid=>mc_fc_loc_copy_row.
  APPEND w_exclude TO t_exclude.
  w_exclude = cl_gui_alv_grid=>mc_fc_print.
  APPEND w_exclude TO t_exclude.
  w_exclude = cl_gui_alv_grid=>mc_fc_loc_cut.
  APPEND w_exclude TO t_exclude.
  w_exclude = cl_gui_alv_grid=>mc_fc_loc_copy.
  APPEND w_exclude TO t_exclude.
  w_exclude = cl_gui_alv_grid=>mc_fc_loc_paste.
  APPEND w_exclude TO t_exclude.
  w_exclude = cl_gui_alv_grid=>mc_fc_loc_paste_new_row.
  APPEND w_exclude TO t_exclude.
  w_exclude = cl_gui_alv_grid=>mc_fc_print_prev.
  APPEND w_exclude TO t_exclude.
  w_exclude = cl_gui_alv_grid=>mc_fc_views.
  APPEND w_exclude TO t_exclude.
  w_exclude = cl_gui_alv_grid=>mc_fc_loc_undo.
  APPEND w_exclude TO t_exclude.
  w_exclude = cl_gui_alv_grid=>mc_fc_check.
  APPEND w_exclude TO t_exclude.
  w_exclude = cl_gui_alv_grid=>mc_fc_refresh.
  APPEND w_exclude TO t_exclude.

ENDFORM.                    " ZF_BARRA_FERRAMENTAS
*&---------------------------------------------------------------------*
*&      FORM ZF_EDITABLE_CELL
*&---------------------------------------------------------------------**      -->P_IT_CELLSTYLE  text
*----------------------------------------------------------------------*
FORM zf_editable_cell   USING     p_fieldname    TYPE lvc_fname
                        CHANGING  p_it_cellstyle TYPE lvc_t_styl.

  DATA : lw_cellstyle TYPE lvc_s_styl.

  lw_cellstyle-fieldname =  p_fieldname .
  lw_cellstyle-style     = cl_gui_alv_grid=>mc_style_enabled.
  INSERT lw_cellstyle INTO TABLE p_it_cellstyle.

ENDFORM.                    " EDITABLE_CELL

*&---------------------------------------------------------------------*
*&      FORM ZF_NOT_EDITABLE_CELL
*&---------------------------------------------------------------------**      -->P_IT_CELLSTYLE  text
*----------------------------------------------------------------------*
FORM zf_not_editable_cell   USING     p_fieldname    TYPE lvc_fname
                        CHANGING  p_it_cellstyle TYPE lvc_t_styl.

  DATA : lw_cellstyle TYPE lvc_s_styl.

  lw_cellstyle-fieldname =  p_fieldname .
  lw_cellstyle-style     = cl_gui_alv_grid=>mc_style_disabled.
  INSERT lw_cellstyle INTO TABLE p_it_cellstyle.

ENDFORM.                    " EDITABLE_CELL
*&---------------------------------------------------------------------*
*& Form zf_check_if_lines_have_null
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> <FS_W_ALV>
*&---------------------------------------------------------------------*
FORM zf_check_if_lines_have_null USING lv_have_null TYPE flag.

  DATA: lo_entrada TYPE REF TO /sprolims/clqm_ent_res_shdb.

  FIELD-SYMBOLS: <fs_field>    TYPE any.

  DATA: lv_aufnr                       TYPE aufnr,
        lv_vornr                       TYPE vornr,
        lv_unidade_controle_repeticoes TYPE i,
        lv_tipo_tolerancia             TYPE qmaschine,
        lv_calculated_value            TYPE qaqee-sumplus,
        lv_is_calculated_field         TYPE flag.

  DATA: lw_entrada           TYPE /sprolims/clqm_ent_res_shdb=>y_entrada,
        lw_dados_sumario     TYPE /sprolims/clqm_ent_res_shdb=>y_dados_sumario,
        lw_unidades_controle TYPE /sprolims/clqm_ent_res_shdb=>y_unidades_controle,
        lw_dados_unidade     TYPE /sprolims/clqm_ent_res_shdb=>y_dados_unidade,
        lw_defeitos          TYPE /sprolims/clqm_ent_res_shdb=>y_defeitos.

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
                                                              BINARY SEARCH.
  IF sy-subrc = 0.

    LOOP AT t_charac_data INTO lw_charac_data WHERE order_id      = lv_aufnr AND
                                                    order_step_id = lv_vornr AND
                                                    control_unit_position = 0 AND
                                                    fieldname IS NOT INITIAL.

      ASSIGN COMPONENT lw_charac_data-fieldname OF STRUCTURE <fw_alv> TO <fs_field>.
      IF  <fs_field> IS ASSIGNED AND
              sy-subrc = 0.

        IF <fs_field> IS INITIAL.

          lv_have_null = 'X'.
          MESSAGE ID 'ZCMPM_SPROLIMS' TYPE 'I' NUMBER '010' DISPLAY LIKE 'E'.
          EXIT.

        ENDIF.
      ENDIF.

    ENDLOOP.

    IF lv_have_null <> 'X'.

      LOOP AT t_charac_data INTO lw_charac_data WHERE order_id      = lv_aufnr AND
                                                      order_step_id = lv_vornr AND
                                                      control_unit_position <> 0 AND
                                                      fieldname IS NOT INITIAL.

        lv_unidade_controle_repeticoes = lw_charac_data-sollstpumf.
        EXIT.

      ENDLOOP.

      IF lv_unidade_controle_repeticoes IS NOT INITIAL.

        DO lv_unidade_controle_repeticoes TIMES.

          DATA(lv_index_aux) = sy-index.

          lw_unidades_controle-unidade = lv_index_aux.

          LOOP AT t_charac_data INTO lw_charac_data WHERE order_id      = lv_aufnr AND
                                                          order_step_id = lv_vornr AND
                                                          control_unit_position = lw_unidades_controle-unidade AND
                                                          fieldname IS NOT INITIAL.

            ASSIGN COMPONENT lw_charac_data-fieldname OF STRUCTURE <fw_alv> TO <fs_field>.
            IF  <fs_field> IS ASSIGNED AND
                sy-subrc = 0.

              IF <fs_field> IS INITIAL.


                PERFORM zf_check_is_calculated_value USING   lw_charac_data-order_step_plant
                                                        lw_charac_data-verwmerkm
                                                        lw_charac_data-order_id
                                                        lw_charac_data-order_step_id
                                                        lw_unidades_controle-unidade
                                                        <fw_alv>
                                               CHANGING lv_is_calculated_field.
                IF lv_is_calculated_field IS INITIAL.
                  lv_have_null = 'X'.
                  MESSAGE ID 'ZCMPM_SPROLIMS' TYPE 'I' NUMBER '010' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.

              ENDIF.

              CLEAR: lv_is_calculated_field.

            ENDIF.

          ENDLOOP.

          IF lv_have_null = 'X'.

            EXIT.

          ENDIF.

        ENDDO.
      ENDIF.
    ENDIF.

  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_get_values_from_line
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> <FS_W_ALV>
*&---------------------------------------------------------------------*
FORM zf_get_values_from_line.

  DATA: lo_entrada TYPE REF TO /sprolims/clqm_ent_res_shdb.

  FIELD-SYMBOLS: <fs_field>    TYPE any.

  DATA: lv_aufnr                       TYPE aufnr,
        lv_vornr                       TYPE vornr,
        lv_unidade_controle_repeticoes TYPE i,
        lv_tipo_tolerancia             TYPE qmaschine,
        lv_calculated_value            TYPE qaqee-sumplus.

  DATA: lw_entrada           TYPE /sprolims/clqm_ent_res_shdb=>y_entrada,
        lw_dados_sumario     TYPE /sprolims/clqm_ent_res_shdb=>y_dados_sumario,
        lw_unidades_controle TYPE /sprolims/clqm_ent_res_shdb=>y_unidades_controle,
        lw_dados_unidade     TYPE /sprolims/clqm_ent_res_shdb=>y_dados_unidade,
        lw_defeitos          TYPE /sprolims/clqm_ent_res_shdb=>y_defeitos.

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
                                                              BINARY SEARCH.
  IF sy-subrc = 0.

    IF v_prueflos = lw_charac_data-prueflos.

      WAIT UP TO 1 SECONDS.

    ENDIF.

    lw_entrada-prueflos = lw_charac_data-prueflos.
    lw_entrada-vornr    = lw_charac_data-order_step_id.

    IF lw_charac_data-tplnr IS NOT INITIAL.

      lw_entrada-tplnr = lw_charac_data-tplnr.

    ELSE.

      lw_entrada-tplnr = lw_charac_data-order_step_plant.

    ENDIF.

    LOOP AT t_charac_data INTO lw_charac_data WHERE order_id      = lv_aufnr AND
                                                    order_step_id = lv_vornr AND
                                                    control_unit_position = 0 AND
                                                    fieldname IS NOT INITIAL.


      ASSIGN COMPONENT lw_charac_data-fieldname OF STRUCTURE <fw_alv> TO <fs_field>.
      IF  <fs_field> IS ASSIGNED AND
              sy-subrc = 0.

        lw_dados_sumario-position =  lw_charac_data-position.
        lw_dados_sumario-value = <fs_field>.

        LOOP AT t_defects INTO DATA(lw_defects) WHERE aufnr     = lw_charac_data-order_id AND
                                                      vornr     = lw_charac_data-order_step_id AND
                                                      fieldname = lw_charac_data-fieldname.

          lw_defeitos-fegrp     = lw_defects-fegrp.
          lw_defeitos-fecod     = lw_defects-fecod.
          lw_defeitos-anzfehler = lw_defects-anzfehler.
          APPEND lw_defeitos TO lw_dados_sumario-defeitos.

        ENDLOOP.

        APPEND lw_dados_sumario TO lw_entrada-dados.
        CLEAR lw_dados_sumario-defeitos.

      ENDIF.

    ENDLOOP.


    LOOP AT t_charac_data INTO lw_charac_data WHERE order_id      = lv_aufnr AND
                                                    order_step_id = lv_vornr AND
                                                    control_unit_position <> 0 AND
                                                    fieldname IS NOT INITIAL.

      lv_unidade_controle_repeticoes = lw_charac_data-sollstpumf.
      EXIT.

    ENDLOOP.

    IF lv_unidade_controle_repeticoes IS NOT INITIAL.

      DO lv_unidade_controle_repeticoes TIMES.

        DATA(lv_index_aux) = sy-index.

        lw_unidades_controle-unidade = lv_index_aux.

        LOOP AT t_charac_data INTO lw_charac_data WHERE order_id      = lv_aufnr AND
                                                        order_step_id = lv_vornr AND
                                                        control_unit_position = lw_unidades_controle-unidade AND
                                                        fieldname IS NOT INITIAL.

          ASSIGN COMPONENT lw_charac_data-fieldname OF STRUCTURE <fw_alv> TO <fs_field>.
          IF  <fs_field> IS ASSIGNED AND
              sy-subrc = 0.

            lw_dados_unidade-position =  lw_charac_data-position.
            lw_dados_unidade-value = <fs_field>.

            LOOP AT t_defects INTO lw_defects WHERE aufnr     = lw_charac_data-order_id AND
                                                    vornr     = lw_charac_data-order_step_id AND
                                                    fieldname = lw_charac_data-fieldname.


              lw_defeitos-fegrp     = lw_defects-fegrp.
              lw_defeitos-fecod     = lw_defects-fecod.
              lw_defeitos-anzfehler = lw_defects-anzfehler.
              APPEND lw_defeitos TO lw_dados_unidade-defeitos.

            ENDLOOP.

            PERFORM zf_get_tipo_tolerancia USING  lw_charac_data-order_step_plant
                                                  lw_charac_data-verwmerkm
                                                  lw_unidades_controle-unidade
                                           CHANGING lv_tipo_tolerancia.

            lw_dados_unidade-tipo_tolerancia = lv_tipo_tolerancia.

            IF lw_dados_unidade-value IS INITIAL.

              PERFORM zf_get_calculated_value USING   lw_charac_data-order_step_plant
                                                      lw_charac_data-verwmerkm
                                                      lw_charac_data-order_id
                                                      lw_charac_data-order_step_id
                                                      lw_unidades_controle-unidade
                                                      <fw_alv>
                                             CHANGING lv_calculated_value.
              IF lv_calculated_value IS NOT INITIAL.
                lw_dados_unidade-value = lv_calculated_value.
              ENDIF.
            ENDIF.

            APPEND lw_dados_unidade TO lw_unidades_controle-dados_unidades.

            CLEAR lw_dados_unidade-defeitos.
            CLEAR lv_tipo_tolerancia.
            CLEAR lv_calculated_value.

          ENDIF.

        ENDLOOP.

        APPEND lw_unidades_controle TO lw_entrada-unidades_controle.
        CLEAR lw_unidades_controle.

      ENDDO.
    ENDIF.

    v_prueflos = lw_entrada-prueflos.

  ENDIF.

  CREATE OBJECT lo_entrada
    EXPORTING
      iw_entrada = lw_entrada.

  DATA(lt_bdc_return) = lo_entrada->get_bcd( ).

  PERFORM zf_call_shdb USING lt_bdc_return lw_entrada-prueflos lw_entrada-vornr.

  lo_entrada->get_date_hour(
    IMPORTING
      ev_datlo =  DATA(lv_date)
      ev_timlo =  DATA(lv_hour)
  ).

  PERFORM zf_prepare_check_saved USING lv_aufnr lv_vornr lv_date lv_hour.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_check_if_saved
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> <FS_W_ALV>
*&---------------------------------------------------------------------*
FORM zf_check_if_saved.

  TYPES: BEGIN OF ly_correct_batch_sample,
           production_batch_number TYPE /sprolims/zcdcr-production_batch_number,
           sample_number           TYPE /sprolims/zcdcr-sample_number,
           kurztext                TYPE /sprolims/zcdcr-kurztext,
           type                    TYPE c,
         END OF ly_correct_batch_sample.

  DATA: lt_correct_batch_sample TYPE TABLE OF ly_correct_batch_sample,
        lw_correct_batch_sample LIKE LINE OF lt_correct_batch_sample.

  DATA: lw_msg TYPE  bal_s_msg.

  WAIT UP TO 3 SECONDS.

  DATA: lw_message_tab LIKE LINE OF t_message_tab.

  LOOP AT t_check_commit INTO DATA(lw_check_commit).

    DATA(lt_check_data) = t_charac_data.

    DELETE lt_check_data WHERE order_id <> lw_check_commit-aufnr OR order_step_id <> lw_check_commit-vornr.

    SORT lt_check_data BY prueflos vorglfnr merknr verwmerkm kurztext.

    DELETE ADJACENT DUPLICATES FROM lt_check_data COMPARING prueflos vorglfnr merknr verwmerkm .

    SELECT prueflos, vorglfnr, merknr
      FROM qasr
      INTO TABLE @DATA(lt_qasr)
      FOR ALL ENTRIES IN @lt_check_data
      WHERE prueflos    = @lt_check_data-prueflos AND
            vorglfnr    = @lt_check_data-vorglfnr AND
            merknr      = @lt_check_data-merknr AND
            pruefdatuv  = @lw_check_commit-date ."AND
*            pruefzeitv  = @lw_check_commit-hour.

    LOOP AT lt_check_data INTO DATA(lw_check_data).

      READ TABLE lt_qasr WITH KEY prueflos = lw_check_data-prueflos
                                  vorglfnr = lw_check_data-vorglfnr
                                  merknr   = lw_check_data-merknr
                                  TRANSPORTING NO FIELDS.

      IF sy-subrc = 0.

        lw_correct_batch_sample-type                    = 'S'.
        lw_correct_batch_sample-production_batch_number = lw_check_data-production_batch_number.
        lw_correct_batch_sample-sample_number           = |{ lw_check_data-sample_number ALPHA = OUT }|.
        lw_correct_batch_sample-kurztext                = lw_check_data-kurztext.

      ELSE.


        lw_correct_batch_sample-type                    = 'E'.
        lw_correct_batch_sample-production_batch_number = lw_check_data-production_batch_number.
        lw_correct_batch_sample-sample_number           = lw_check_data-sample_number.
        lw_correct_batch_sample-kurztext                = lw_check_data-kurztext.

      ENDIF.

      APPEND lw_correct_batch_sample TO lt_correct_batch_sample.

    ENDLOOP.

    LOOP AT lt_correct_batch_sample INTO lw_correct_batch_sample.

      lw_msg-msgid = 'ZCMPM_SPROLIMS'.
      lw_msg-msgty = lw_correct_batch_sample-type.
      lw_msg-msgno = '009'.
      lw_msg-msgv1 = lw_correct_batch_sample-production_batch_number.
      lw_msg-msgv2 = lw_correct_batch_sample-sample_number.
      lw_msg-msgv3 = lw_correct_batch_sample-kurztext.

      CALL FUNCTION 'BAL_LOG_MSG_ADD'
        EXPORTING
          i_log_handle     = v_log_handle
          i_s_msg          = lw_msg
        EXCEPTIONS
          log_not_found    = 1
          msg_inconsistent = 2
          log_is_full      = 3
          OTHERS           = 4.

    ENDLOOP.

    SORT lt_check_data BY production_batch_number sample_number.
    DELETE ADJACENT DUPLICATES FROM lt_check_data COMPARING production_batch_number sample_number.

    LOOP AT lt_check_data INTO lw_check_data.
      READ TABLE lt_correct_batch_sample WITH KEY  production_batch_number = lw_check_data-production_batch_number
                                                   sample_number =  lw_check_data-sample_number
                                                   type = 'E'
                                                   TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.

        lw_message_tab-msgid = 'ZCMPM_SPROLIMS'.
        lw_message_tab-msgno = '004'.
        lw_message_tab-msgty = 'E'.
        lw_message_tab-msgv1 = lw_check_data-production_batch_number.
        lw_message_tab-msgv2 = |{ lw_check_data-sample_number ALPHA = OUT }|.

      ELSE.

        lw_message_tab-msgid = 'ZCMPM_SPROLIMS'.
        lw_message_tab-msgno = '003'.
        lw_message_tab-msgty = 'S'.
        lw_message_tab-msgv1 = lw_check_data-production_batch_number.
        lw_message_tab-msgv2 = |{ lw_check_data-sample_number ALPHA = OUT }|.

      ENDIF.

      APPEND lw_message_tab TO t_message_tab.
    ENDLOOP.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_call_shdb
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_BDC_RETURN
*&---------------------------------------------------------------------*
FORM zf_call_shdb  USING    p_lt_bdc_return TYPE /sprolims/clqm_ent_res_shdb=>yt_bdc
                            pv_prueflos          TYPE qplos
                            pv_vornr             TYPE qaqee-vornr.

  DATA: BEGIN OF lt_bdc OCCURS 0.
          INCLUDE STRUCTURE bdcdata.
        DATA: END OF lt_bdc.

  DATA: BEGIN OF lt_msg_bdc OCCURS 0.
          INCLUDE STRUCTURE bdcmsgcoll.
        DATA: END OF lt_msg_bdc.

  DATA: lw_options_bdc TYPE ctu_params.

  DATA: lw_msg TYPE  bal_s_msg.


  "Log - Inicio

  lw_msg-msgid = 'ZCMPM_SPROLIMS'.
  lw_msg-msgty = 'I'.
  lw_msg-msgno = '005'.
  lw_msg-msgv1 = pv_prueflos.
  lw_msg-msgv2 = pv_vornr.

  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle     = v_log_handle
      i_s_msg          = lw_msg
    EXCEPTIONS
      log_not_found    = 1
      msg_inconsistent = 2
      log_is_full      = 3
      OTHERS           = 4.

  lt_bdc[] = p_lt_bdc_return[].

  lw_options_bdc-dismode = 'S'.
  lw_options_bdc-updmode = 'A'.
  lw_options_bdc-defsize = 'X'.

  CALL TRANSACTION 'QE20' USING lt_bdc
                          OPTIONS FROM lw_options_bdc
                          MESSAGES INTO lt_msg_bdc.

  READ TABLE lt_msg_bdc INTO DATA(lw_msg_bdc) WITH KEY msgtyp = 'E' .
  IF sy-subrc = 0.

    lw_msg-msgid = 'ZCMPM_SPROLIMS'.
    lw_msg-msgty = 'E'.
    lw_msg-msgno = '007'.
    lw_msg-msgv1 = pv_prueflos.
    lw_msg-msgv2 = pv_vornr.

    CALL FUNCTION 'BAL_LOG_MSG_ADD'
      EXPORTING
        i_log_handle     = v_log_handle
        i_s_msg          = lw_msg
      EXCEPTIONS
        log_not_found    = 1
        msg_inconsistent = 2
        log_is_full      = 3
        OTHERS           = 4.

    lw_msg-msgid = lw_msg_bdc-msgid.
    lw_msg-msgty = lw_msg_bdc-msgtyp.
    lw_msg-msgno = lw_msg_bdc-msgnr.
    lw_msg-msgv1 = lw_msg_bdc-msgv1.
    lw_msg-msgv2 = lw_msg_bdc-msgv2.
    lw_msg-msgv3 = lw_msg_bdc-msgv3.
    lw_msg-msgv4 = lw_msg_bdc-msgv4.

    CALL FUNCTION 'BAL_LOG_MSG_ADD'
      EXPORTING
        i_log_handle     = v_log_handle
        i_s_msg          = lw_msg
      EXCEPTIONS
        log_not_found    = 1
        msg_inconsistent = 2
        log_is_full      = 3
        OTHERS           = 4.

  ELSE.

    READ TABLE lt_msg_bdc  INTO lw_msg_bdc WITH KEY msgtyp = 'W'.
    IF sy-subrc = 0.

      lw_msg-msgid = 'ZCMPM_SPROLIMS'.
      lw_msg-msgty = 'W'.
      lw_msg-msgno = '008'.
      lw_msg-msgv1 = pv_prueflos.
      lw_msg-msgv2 = pv_vornr.

      CALL FUNCTION 'BAL_LOG_MSG_ADD'
        EXPORTING
          i_log_handle     = v_log_handle
          i_s_msg          = lw_msg
        EXCEPTIONS
          log_not_found    = 1
          msg_inconsistent = 2
          log_is_full      = 3
          OTHERS           = 4.

      lw_msg-msgid = lw_msg_bdc-msgid.
      lw_msg-msgty = lw_msg_bdc-msgtyp.
      lw_msg-msgno = lw_msg_bdc-msgnr.
      lw_msg-msgv1 = lw_msg_bdc-msgv1.
      lw_msg-msgv2 = lw_msg_bdc-msgv2.
      lw_msg-msgv3 = lw_msg_bdc-msgv3.
      lw_msg-msgv4 = lw_msg_bdc-msgv4.

      CALL FUNCTION 'BAL_LOG_MSG_ADD'
        EXPORTING
          i_log_handle     = v_log_handle
          i_s_msg          = lw_msg
        EXCEPTIONS
          log_not_found    = 1
          msg_inconsistent = 2
          log_is_full      = 3
          OTHERS           = 4.

    ELSE.

      lw_msg-msgid = 'ZCMPM_SPROLIMS'.
      lw_msg-msgty = 'S'.
      lw_msg-msgno = '006'.
      lw_msg-msgv1 = pv_prueflos.
      lw_msg-msgv2 = pv_vornr.

      CALL FUNCTION 'BAL_LOG_MSG_ADD'
        EXPORTING
          i_log_handle     = v_log_handle
          i_s_msg          = lw_msg
        EXCEPTIONS
          log_not_found    = 1
          msg_inconsistent = 2
          log_is_full      = 3
          OTHERS           = 4.

    ENDIF.
  ENDIF.

  COMMIT WORK AND WAIT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_display_defect_dialog_box
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ES_ROW_ID
*&      --> ES_COL_ID
*&      --> ES_ROW_NO
*&---------------------------------------------------------------------*
FORM zf_display_defect_dialog_box  USING    p_es_row_id
                                            p_es_col_id
                                            p_es_row_no.

  DATA: lw_defects     LIKE LINE OF t_defects_dialog.

  DATA: lv_erro TYPE c.

  PERFORM zf_get_defects_dialog USING     p_es_row_id
                                          p_es_col_id
                                          p_es_row_no
                                CHANGING  lv_erro.

  CHECK lv_erro IS INITIAL.

  IF v_dialogbox_status IS INITIAL.

    CREATE OBJECT o_dialogbox_cont
      EXPORTING
        top      = 50
        left     = 160
        lifetime = cntl_lifetime_dynpro
        caption  = 'Defeitos'
        width    = 700
        height   = 200.

    CREATE OBJECT o_dialogbox_grid
      EXPORTING
        i_parent = o_dialogbox_cont.

    CREATE OBJECT o_event_dialogbox.

    SET HANDLER:  o_event_dialogbox->handle_close   FOR o_dialogbox_cont .

    SET HANDLER:  o_event_dialogbox->handle_toolbar      FOR o_dialogbox_grid,
                  o_event_dialogbox->handle_user_command FOR o_dialogbox_grid,
                  o_event_dialogbox->on_f4               FOR o_dialogbox_grid.

    w_dialogbox_layout-sel_mode    = 'B'.
    w_dialogbox_layout-no_rowmark  = 'X'.
    w_dialogbox_layout-grid_title = space.

    FREE: t_dialogbox_fieldcat,
          o_fcat_dialogbox,
          o_aggr_dialogbox,
          o_cols_dialogbox.

    FIELD-SYMBOLS: <fs_fcat> LIKE LINE OF t_dialogbox_fieldcat.

    TRY.

        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = o_fcat_dialogbox
          CHANGING
            t_table      = t_defects_dialog.

      CATCH cx_salv_msg INTO DATA(cx_salv).

        MESSAGE cx_salv TYPE 'E'.

    ENDTRY.

    CHECK o_fcat_dialogbox IS BOUND.

    o_cols_dialogbox = o_fcat_dialogbox->get_columns( ).

    CHECK o_cols_dialogbox IS BOUND.

    o_aggr_dialogbox = o_fcat_dialogbox->get_aggregations( ).

    t_dialogbox_fieldcat = cl_salv_controller_metadata=>get_lvc_fieldcatalog( r_columns = o_cols_dialogbox
                                                                              r_aggregations = o_aggr_dialogbox ).

    LOOP AT t_dialogbox_fieldcat ASSIGNING FIELD-SYMBOL(<fs_dialogbox_fieldcat>).

      CASE <fs_dialogbox_fieldcat>-fieldname.

        WHEN 'AUFNR' OR 'VORNR' OR 'KURZTEXT'.

        WHEN 'FIELDNAME' OR 'KATALGART2' OR 'FEGRP'.

          <fs_dialogbox_fieldcat>-no_out = 'X'.

        WHEN 'FECOD' OR 'ANZFEHLER'.

          <fs_dialogbox_fieldcat>-edit = 'X'.

          IF <fs_dialogbox_fieldcat>-fieldname = 'FECOD'.

            <fs_dialogbox_fieldcat>-f4availabl = 'X'.

          ENDIF.

      ENDCASE.

    ENDLOOP.

    DATA: lt_f4 TYPE lvc_t_f4,
          lw_f4 LIKE LINE OF lt_f4.

    lw_f4-fieldname   = 'FECOD'.
    lw_f4-register    = 'X' .
    lw_f4-getbefore   = 'X' .
    lw_f4-chngeafter  = 'X'.

    APPEND lw_f4 TO lt_f4 .


    CALL METHOD o_dialogbox_grid->register_f4_for_fields
      EXPORTING
        it_f4 = lt_f4[].

    CALL METHOD o_dialogbox_grid->set_table_for_first_display
      EXPORTING
        i_structure_name = '/SPROLIMS/STQM_ALV_ENT_RES_DEF'
        is_layout        = w_dialogbox_layout
      CHANGING
        it_outtab        = t_defects_dialog
        it_fieldcatalog  = t_dialogbox_fieldcat.

  ELSE.

    CALL METHOD o_dialogbox_cont->set_visible
      EXPORTING
        visible = 'X'.

    CALL METHOD o_dialogbox_grid->refresh_table_display.

  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_get_defects_dialog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_ES_ROW_ID
*&      --> P_ES_COL_ID
*&      --> P_ES_ROW_NO
*&---------------------------------------------------------------------*
FORM zf_get_defects_dialog  USING    p_es_row_id
                                         p_es_col_id
                                         p_es_row_no
                                CHANGING p_erro.

  DATA: lv_aufnr TYPE aufnr,
        lv_vornr TYPE vornr.

  FIELD-SYMBOLS: <fs_field>    TYPE any.

  IF  p_es_row_id IS INITIAL OR
      p_es_col_id IS INITIAL.

    p_erro = 'X'.
    MESSAGE 'Selecionar uma célula' TYPE 'I' DISPLAY LIKE 'W'.
    RETURN.

  ENDIF.


  READ TABLE <ft_alv> ASSIGNING <fw_alv> INDEX p_es_row_id.
  IF sy-subrc = 0.

    ASSIGN COMPONENT 'AUFNR' OF STRUCTURE <fw_alv> TO <fs_field>.
    IF  <fs_field> IS ASSIGNED.

      lv_aufnr = <fs_field>.

    ENDIF.

    ASSIGN COMPONENT 'VORNR' OF STRUCTURE <fw_alv> TO <fs_field>.
    IF  <fs_field> IS ASSIGNED.

      lv_vornr = <fs_field>.

    ENDIF.

    READ TABLE t_charac_data INTO DATA(lw_charac_data)
                             WITH KEY order_id      = lv_aufnr
                                      order_step_id = lv_vornr
                                      fieldname     = p_es_col_id.
    IF sy-subrc = 0.

      IF  lw_charac_data-katalgart2 IS INITIAL AND
          lw_charac_data-auswmenge2 IS INITIAL.

        p_erro = 'X'.
        MESSAGE 'Não é possível apontar erro para essa característica' TYPE 'I' DISPLAY LIKE 'W'.
        RETURN.

      ELSE.


        CLEAR t_defects_dialog.

        LOOP AT t_defects INTO DATA(lw_defects) WHERE aufnr     = lv_aufnr AND
                                                      vornr     = lv_vornr AND
                                                      fieldname     = p_es_col_id.

          APPEND lw_defects TO t_defects_dialog.

        ENDLOOP.

        CLEAR lw_defects.

        lw_defects-aufnr      = lv_aufnr.
        lw_defects-vornr      = lv_vornr.
        lw_defects-kurztext   = lw_charac_data-kurztext.
        lw_defects-fieldname  = lw_charac_data-fieldname.
        lw_defects-katalgart2 = lw_charac_data-katalgart2.
        lw_defects-fegrp      = lw_charac_data-auswmenge2.

        DATA(lv_lines) = lines( t_defects_dialog ).

        DO 15 - lv_lines TIMES.

          APPEND lw_defects TO t_defects_dialog.

        ENDDO.

      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_get_tipo_tolerancia
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LW_CHARAC_DATA_VERWMERKM
*&      --> LW_DADOS_UNIDADE_VALUE
*&      <-- LV_TIPO_TOLERANCIA
*&---------------------------------------------------------------------*
FORM zf_get_tipo_tolerancia  USING    pv_centro
                                      pv_verwmerkm
                                      pv_unidade_value
                             CHANGING pv_tipo_tolerancia.

  DATA: lv_unidade_value TYPE n LENGTH 2.

  lv_unidade_value = pv_unidade_value.

  SELECT padrao UP TO 1 ROWS
    FROM /sprocsem/tccmct
    INTO pv_tipo_tolerancia
    WHERE qpmk_werks  = pv_centro AND
          verwmerkm   = pv_verwmerkm AND
          rep_inicial <= lv_unidade_value AND
          rep_final   >= lv_unidade_value
    ORDER BY pmtversion.
  ENDSELECT.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_prepare_check_saved
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_DATE
*&      --> LV_HOUR
*&---------------------------------------------------------------------*
FORM zf_prepare_check_saved  USING    p_lv_aufnr
                               p_lv_vornr
                               p_lv_date
                               p_lv_hour.

  DATA: lw_check_commit LIKE LINE OF t_check_commit.

  lw_check_commit-aufnr = p_lv_aufnr.
  lw_check_commit-vornr = p_lv_vornr.
  lw_check_commit-date = p_lv_date.
  lw_check_commit-hour = p_lv_hour.


  APPEND lw_check_commit TO t_check_commit.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_check_if_cell_calculated
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LW_CHARAC_DATA_VERWMERKM
*&      --> LW_CHARAC_DATA_ORDER_ID
*&      --> LW_CHARAC_DATA_ORDER_STEP_ID
*&      <-- IT_CELLSTYLE
*&---------------------------------------------------------------------*
FORM zf_check_if_cell_calculated  USING    p_fieldname
                                      p_lw_charac_data_verwmerkm
                                      p_lw_charac_data_plant
                                      p_lw_charac_data_order_id
                                      p_lw_charac_data_order_step_id
                             CHANGING p_it_cellstyle TYPE lvc_t_styl.

  DATA: lv_do_not_change TYPE flag.

  DATA : lw_cellstyle TYPE lvc_s_styl.


  IF t_tccde IS INITIAL.

    SELECT *
      FROM /sprocsem/tccde
      INTO TABLE t_tccde.

    SORT t_tccde BY qpmk_werks verwmerkm.

  ENDIF.

  READ TABLE t_tccde INTO DATA(lw_tccde) WITH KEY qpmk_werks  = p_lw_charac_data_plant
                                                  verwmerkm   = p_lw_charac_data_verwmerkm
                                                  BINARY SEARCH.
  IF sy-subrc = 0.

    LOOP AT t_tccde INTO lw_tccde WHERE qpmk_werks  = p_lw_charac_data_plant AND
                                        verwmerkm   = p_lw_charac_data_verwmerkm.

      READ TABLE t_charac_data TRANSPORTING NO FIELDS WITH KEY  verwmerkm         = lw_tccde-verwmerkm_p
                                                                order_step_plant  = p_lw_charac_data_plant
                                                                order_id          = p_lw_charac_data_order_id
                                                                order_step_id     = p_lw_charac_data_order_step_id.
      IF sy-subrc <> 0.

        lv_do_not_change = 'X'.

      ENDIF.

    ENDLOOP.

    IF lv_do_not_change IS INITIAL.

      READ TABLE p_it_cellstyle ASSIGNING FIELD-SYMBOL(<fs_cellstyle>) WITH KEY fieldname = p_fieldname.
      IF sy-subrc = 0.
        <fs_cellstyle>-style     = cl_gui_alv_grid=>mc_style_disabled.
      ENDIF.

    ENDIF.

  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_get_calculated_value
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LW_CHARAC_DATA_VERWMERKM
*&      --> LW_DADOS_UNIDADE_VALUE
*&      <-- LV_TIPO_TOLERANCIA
*&---------------------------------------------------------------------*
FORM zf_get_calculated_value  USING   pv_centro
                                      pv_verwmerkm
                                      pv_order_id
                                      pv_order_step_id
                                      pv_unidade_value
                                      pw_alv
                             CHANGING pv_calculated_value.

  FIELD-SYMBOLS: <fs_field>    TYPE any.


  IF t_tccde IS INITIAL.

    SELECT *
      FROM /sprocsem/tccde
      INTO TABLE t_tccde.

    SORT t_tccde BY qpmk_werks verwmerkm.

  ENDIF.

  READ TABLE t_tccde INTO DATA(lw_tccde) WITH KEY qpmk_werks  = pv_centro
                                                  verwmerkm   = pv_verwmerkm
                                                  BINARY SEARCH.
  IF sy-subrc = 0.

    LOOP AT t_tccde INTO lw_tccde WHERE qpmk_werks  = pv_centro AND
                                        verwmerkm   = pv_verwmerkm.

      READ TABLE t_charac_data INTO DATA(lw_charac_data)  WITH KEY  verwmerkm             = lw_tccde-verwmerkm_p
                                                                    order_step_plant      = pv_centro
                                                                    order_id              = pv_order_id
                                                                    order_step_id         = pv_order_step_id
                                                                    control_unit_position = pv_unidade_value.
      IF sy-subrc = 0.

        ASSIGN COMPONENT lw_charac_data-fieldname OF STRUCTURE pw_alv TO <fs_field>.
        IF  <fs_field> IS ASSIGNED AND
            sy-subrc = 0.

          pv_calculated_value = pv_calculated_value + <fs_field>.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_check_is_calculated_value
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LW_CHARAC_DATA_VERWMERKM
*&      --> LW_DADOS_UNIDADE_VALUE
*&      <-- LV_TIPO_TOLERANCIA
*&---------------------------------------------------------------------*
FORM zf_check_is_calculated_value  USING   pv_centro
                                      pv_verwmerkm
                                      pv_order_id
                                      pv_order_step_id
                                      pv_unidade_value
                                      pw_alv
                             CHANGING pv_flag.

  FIELD-SYMBOLS: <fs_field>    TYPE any.


  IF t_tccde IS INITIAL.

    SELECT *
      FROM /sprocsem/tccde
      INTO TABLE t_tccde.

    SORT t_tccde BY qpmk_werks verwmerkm.

  ENDIF.

  READ TABLE t_tccde INTO DATA(lw_tccde) WITH KEY qpmk_werks  = pv_centro
                                                  verwmerkm   = pv_verwmerkm
                                                  BINARY SEARCH.
  IF sy-subrc = 0.

    LOOP AT t_tccde INTO lw_tccde WHERE qpmk_werks  = pv_centro AND
                                        verwmerkm   = pv_verwmerkm.

      READ TABLE t_charac_data INTO DATA(lw_charac_data)  WITH KEY  verwmerkm             = lw_tccde-verwmerkm_p
                                                                    order_step_plant      = pv_centro
                                                                    order_id              = pv_order_id
                                                                    order_step_id         = pv_order_step_id
                                                                    control_unit_position = pv_unidade_value.
      IF sy-subrc = 0.

        ASSIGN COMPONENT lw_charac_data-fieldname OF STRUCTURE pw_alv TO <fs_field>.
        IF  <fs_field> IS ASSIGNED AND
            sy-subrc = 0.

          pv_flag = 'X'.
          EXIT.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_check_if_has_results
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> <FS_W_ALV>
*&---------------------------------------------------------------------*
FORM zf_check_if_has_results.

  TYPES: BEGIN OF ly_has_results,
           prueflos    TYPE y_charac_data-prueflos,
           work_center TYPE y_charac_data-work_center,
           type        TYPE c,
         END OF ly_has_results.

  DATA: lt_has_results TYPE TABLE OF ly_has_results,
        lw_has_results LIKE LINE OF lt_has_results.

  DATA: lw_msg TYPE  bal_s_msg.

  DATA: lw_message_tab LIKE LINE OF t_message_has_results.

  DATA(lt_charac_data_aux) = t_charac_data.

  SORT lt_charac_data_aux BY prueflos vorglfnr.
  DELETE ADJACENT DUPLICATES FROM lt_charac_data_aux COMPARING prueflos vorglfnr.

  SELECT *
    FROM qasr
    INTO TABLE @t_results
    FOR ALL ENTRIES IN @lt_charac_data_aux
    WHERE prueflos    = @lt_charac_data_aux-prueflos AND
          vorglfnr    = @lt_charac_data_aux-vorglfnr .

  LOOP AT lt_charac_data_aux INTO DATA(lw_check_data).

    READ TABLE t_results WITH KEY prueflos = lw_check_data-prueflos
                                vorglfnr = lw_check_data-vorglfnr TRANSPORTING NO FIELDS.

    IF sy-subrc = 0.

      lw_has_results-type           = 'W'.
      lw_has_results-prueflos       = lw_check_data-prueflos.
      lw_has_results-work_center    = lw_check_data-work_center.

      APPEND lw_has_results TO lt_has_results.

    ENDIF.

  ENDLOOP.

  LOOP AT lt_has_results INTO lw_has_results.


    lw_message_tab-msgid = 'ZCMPM_SPROLIMS'.
    lw_message_tab-msgno = '011'.
    lw_message_tab-msgty = lw_has_results-type.
    lw_message_tab-msgv1 = lw_has_results-prueflos.
    lw_message_tab-msgv2 = lw_has_results-work_center.
    lw_message_tab-lineno = lw_message_tab-lineno + 1.

    APPEND lw_message_tab TO t_message_has_results.

  ENDLOOP.


  IF t_message_has_results IS NOT INITIAL.

    CALL FUNCTION 'C14Z_MESSAGES_SHOW_AS_POPUP'
      TABLES
        i_message_tab = t_message_has_results.

    CLEAR t_message_has_results.

  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_check_if_lines_have_result
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_HAVE_RESULTS
*&---------------------------------------------------------------------*
FORM zf_check_if_lines_have_result  USING    p_lv_have_results.

  DATA: lo_entrada TYPE REF TO /sprolims/clqm_ent_res_shdb.

  FIELD-SYMBOLS: <fs_field>    TYPE any.

  DATA: lv_aufnr TYPE aufnr,
        lv_vornr TYPE vornr.


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
                                                              BINARY SEARCH.
  IF sy-subrc = 0.

    READ TABLE t_results WITH KEY prueflos = lw_charac_data-prueflos
                                  vorglfnr = lw_charac_data-vorglfnr TRANSPORTING NO FIELDS.

    IF sy-subrc = 0.

      p_lv_have_results = 'X'.
      EXIT.

    ENDIF.


  ENDIF.


ENDFORM.
