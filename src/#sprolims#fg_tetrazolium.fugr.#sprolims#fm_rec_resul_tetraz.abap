FUNCTION /sprolims/fm_rec_resul_tetraz.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IW_RESULT_TETRAZ) TYPE  /SPROLIMS/ST_GW_RESULT_TETRAZ
*"  EXPORTING
*"     VALUE(EW_RETURN) TYPE  BAPIRET2
*"----------------------------------------------------------------------


  DATA: lv_index     TYPE c LENGTH 2,
        lv_fieldname TYPE lvc_fname.

  DATA: lr_work_center TYPE RANGE OF /sprolims/cdsaos-work_center,
        lw_work_center LIKE LINE OF lr_work_center,
        lv_prueflos    TYPE /sprolims/cdsao2-prueflos,
        lv_vorglfnr    TYPE /sprolims/cdsao2-vorglfnr,
        lv_position    TYPE n LENGTH 2.

  DATA(log) = /sproprod/cl_log=>factory( object = '/SPROLIMS/' subobject = '/TETRAZOLIUM/' id = | CREATE_TETRAZOLIUM{ iw_result_tetraz-inspection_lot } |   ).

  lw_work_center-option = 'EQ'.
  lw_work_center-sign   = 'I'.
  lw_work_center-low = 'TZ'.
  APPEND lw_work_center TO lr_work_center.

*{LCPG
  TRY.
      DATA(lo_validate) = NEW /sprolims/cl_tetrazolium_valid( iv_inspection_lot =  iw_result_tetraz-inspection_lot iv_work_center = lw_work_center-low ).
      lo_validate->_has_du( ).
      lo_validate->_has_charac_by_work_center( ).
      lo_validate->_has_damage( ).
    CATCH /sprolims/cx_tetrazolium INTO DATA(lx_error).
      ew_return-message = lx_error->get_text( ).
      ew_return-type =  'E'.
      RETURN.
  ENDTRY.
*LCPG}

*  lw_work_center-low = 'MP'.
*  APPEND lw_work_center TO lr_work_center.
*
*  lw_work_center-low = 'SE'.
*  APPEND lw_work_center TO lr_work_center.

  SELECT  ordem_oper~order_id , ordem_oper~solicitation , ordem_oper~batch_number,
          ordem_oper~order_step_id , ordem_oper~order_step_plant , ordem_oper~work_center
    FROM  /sprolims/cdsaos AS ordem_oper
    INTO TABLE @t_operac_data
    WHERE ordem_oper~batch_number  = @iw_result_tetraz-inspection_lot AND
          ordem_oper~work_center   IN @lr_work_center
    ORDER BY ordem_oper~order_id , ordem_oper~order_step_id.

  IF t_operac_data IS NOT INITIAL.

    SELECT ord_opr_char~prueflos  , ord_opr_char~vorglfnr     , ord_opr_char~merknr , ord_opr_char~verwmerkm ,
           ord_opr_char~kurztext  , ord_opr_char~sollstpumf   , ord_opr_char~inspspecrecordingtype,
           ord_opr_char~formel1   , ord_opr_char~katalgart1   , ord_opr_char~auswmenge1,
           ord_opr_char~katalgart2, ord_opr_char~auswmenge2,
           ord_opr_char~order_id  , ord_opr_char~order_step_id,
           ord_opr_char~step_description, ord_opr_char~work_center, ord_opr_char~order_step_plant,
           ord_opr_char~tplnr
      FROM  /sprolims/cdsao2 AS ord_opr_char
      INTO TABLE @t_charac_data_full
      WHERE ord_opr_char~batch_number  = @iw_result_tetraz-inspection_lot AND
            ord_opr_char~work_center   IN @lr_work_center AND
            ord_opr_char~has_du        = ''.

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

    LOOP AT lt_caracteristicas_aux1 ASSIGNING FIELD-SYMBOL(<fs_caracteristicas_aux>).

      CONCATENATE <fs_caracteristicas_aux>-vorglfnr
                  <fs_caracteristicas_aux>-verwmerkm
                  INTO lv_fieldname.

      IF <fs_caracteristicas_aux>-inspspecrecordingtype IS INITIAL.

        <fs_caracteristicas_aux>-sollstpumf = 1.

        READ TABLE t_charac_data ASSIGNING FIELD-SYMBOL(<fs_ch_dt>) WITH KEY prueflos   = <fs_caracteristicas_aux>-prueflos
                                                                             vorglfnr   = <fs_caracteristicas_aux>-vorglfnr
                                                                             merknr     = <fs_caracteristicas_aux>-merknr
                                                                             verwmerkm  = <fs_caracteristicas_aux>-verwmerkm.
        IF sy-subrc = 0.

          <fs_ch_dt>-fieldname = lv_fieldname.

        ENDIF.

        <fs_caracteristicas_aux>-fieldname = lv_fieldname.

      ELSE.

        DO <fs_caracteristicas_aux>-sollstpumf TIMES.

          lv_index = sy-index.
          DATA(lv_kurztext) = <fs_caracteristicas_aux>-kurztext.

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

  ENDIF.

  log->add( msg = t_charac_data msgty = 'W'  ).

  PERFORM zf_fill_shdb USING iw_result_tetraz.


ENDFUNCTION.
