*----------------------------------------------------------------------*
***INCLUDE /SPROLIMS/LFG_TETRAZOLIUMF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form ZF_FILL_SHDB
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_fill_shdb USING pw_result_tetraz TYPE /sprolims/st_gw_result_tetraz.

  DATA: lo_entrada TYPE REF TO /sprolims/cl_result_rec_shdb.

  DATA: lv_aufnr                       TYPE aufnr,
        lv_vornr                       TYPE vornr,
        lv_unidade_controle_repeticoes TYPE i.

  DATA: lw_entrada           TYPE /sprolims/cl_result_rec_shdb=>y_entrada,
        lw_dados_sumario     TYPE /sprolims/cl_result_rec_shdb=>y_dados_sumario,
        lw_unidades_controle TYPE /sprolims/cl_result_rec_shdb=>y_unidades_controle,
        lw_dados_unidade     TYPE /sprolims/cl_result_rec_shdb=>y_dados_unidade,
        lw_defeitos          TYPE /sprolims/cl_result_rec_shdb=>y_defeitos.

  IF t_charac_data IS NOT INITIAL.

    SELECT *
      FROM /sprolims/tdc
      INTO TABLE @DATA(lt_tdc)
      FOR ALL ENTRIES IN @t_charac_data
      WHERE werks       = @t_charac_data-order_step_plant AND
            work_center = @t_charac_data-work_center AND
            verwmerkm   = @t_charac_data-verwmerkm.

  ENDIF.


  lw_dados_sumario-observacoes = pw_result_tetraz-observacoes.

  LOOP AT t_charac_data INTO DATA(lw_charac_data) WHERE work_center = 'TZ'.

    lw_entrada-prueflos = lw_charac_data-prueflos.
    lw_entrada-vornr    = lw_charac_data-order_step_id.

    IF lw_charac_data-tplnr IS NOT INITIAL.

      lw_entrada-tplnr = lw_charac_data-tplnr.

    ELSE.

      lw_entrada-tplnr = lw_charac_data-order_step_plant.

    ENDIF.

    READ TABLE lt_tdc INTO DATA(lw_tdc) WITH KEY work_center = lw_charac_data-work_center
                                                 verwmerkm   = lw_charac_data-verwmerkm.
    IF sy-subrc = 0.

      lw_dados_sumario-position =  lw_charac_data-position.

      CASE lw_tdc-fill_field.

        WHEN 'DM_1_8'.
          lw_dados_sumario-value = pw_result_tetraz-dm_1_8.
        WHEN 'DM_4_5'.
          lw_dados_sumario-value = pw_result_tetraz-dm_4_5.
        WHEN 'DM_6_8'.
          lw_dados_sumario-value = pw_result_tetraz-dm_6_8.
        WHEN 'DU_1_8'.
          lw_dados_sumario-value = pw_result_tetraz-du_1_8.
        WHEN 'DU_4_5'.
          lw_dados_sumario-value = pw_result_tetraz-du_4_5.
        WHEN 'DU_6_8'.
          lw_dados_sumario-value = pw_result_tetraz-du_6_8.
        WHEN 'DP_1_8'.
          lw_dados_sumario-value = pw_result_tetraz-dp_1_8.
        WHEN 'DP_4_5'.
          lw_dados_sumario-value = pw_result_tetraz-dp_4_5.
        WHEN 'DP_6_8'.
          lw_dados_sumario-value = pw_result_tetraz-dp_6_8.
        WHEN 'DURAS'.
          lw_dados_sumario-value = pw_result_tetraz-duras.
        WHEN 'ANORMAIS'.
          lw_dados_sumario-value = pw_result_tetraz-anormais.
        WHEN 'VIGOR'.
          lw_dados_sumario-value = pw_result_tetraz-vigor.
        WHEN 'VIAVEIS'.
          lw_dados_sumario-value = pw_result_tetraz-viaveis.
        WHEN 'DN_1'.
          lw_dados_sumario-value = pw_result_tetraz-dn_1.
        WHEN 'DN_2'.
          lw_dados_sumario-value = pw_result_tetraz-dn_2.
        WHEN 'DN_3'.
          lw_dados_sumario-value = pw_result_tetraz-dn_3.
        WHEN 'DN_3R'.
          lw_dados_sumario-value = pw_result_tetraz-dn_3r.
        WHEN 'MP'.
          lw_dados_sumario-value = pw_result_tetraz-mp.
        WHEN 'SE'.
          lw_dados_sumario-value = pw_result_tetraz-se.

      ENDCASE.


      APPEND lw_dados_sumario TO lw_entrada-dados.
      CLEAR lw_dados_sumario.

    ENDIF.

  ENDLOOP.

  CREATE OBJECT lo_entrada
    EXPORTING
      iw_entrada = lw_entrada.

  DATA(lt_bdc_return) = lo_entrada->get_bcd( ).

  PERFORM zf_call_shdb USING lt_bdc_return.

  CLEAR lw_entrada.
  CLEAR lt_bdc_return.

**MP
*
*  LOOP AT t_charac_data INTO lw_charac_data WHERE work_center = 'MP'.
*
*    lw_entrada-prueflos = lw_charac_data-prueflos.
*    lw_entrada-vornr    = lw_charac_data-order_step_id.
*
*    IF lw_charac_data-tplnr IS NOT INITIAL.
*
*      lw_entrada-tplnr = lw_charac_data-tplnr.
*
*    ELSE.
*
*      lw_entrada-tplnr = lw_charac_data-order_step_plant.
*
*    ENDIF.
*
*    READ TABLE lt_tdc INTO lw_tdc WITH KEY work_center = lw_charac_data-work_center
*                                                 verwmerkm   = lw_charac_data-verwmerkm.
*    IF sy-subrc = 0.
*
*      lw_dados_sumario-position =  lw_charac_data-position.
*
*      CASE lw_tdc-fill_field.
*
*        WHEN 'MP'.
*          lw_dados_sumario-value = pw_result_tetraz-mp.
*
*      ENDCASE.
*
*
*      APPEND lw_dados_sumario TO lw_entrada-dados.
*      CLEAR lw_dados_sumario.
*
*    ENDIF.
*
*  ENDLOOP.
*
*  IF lw_entrada IS NOT INITIAL.
*
*    CREATE OBJECT lo_entrada
*      EXPORTING
*        iw_entrada = lw_entrada.
*
*    lt_bdc_return = lo_entrada->get_bcd( ).
*
*    PERFORM zf_call_shdb USING lt_bdc_return.
*
*  ENDIF.
*
*  CLEAR lw_entrada.
*  CLEAR lt_bdc_return.
*
**SE
*
*  LOOP AT t_charac_data INTO lw_charac_data WHERE work_center = 'SE'.
*
*    lw_entrada-prueflos = lw_charac_data-prueflos.
*    lw_entrada-vornr    = lw_charac_data-order_step_id.
*
*    IF lw_charac_data-tplnr IS NOT INITIAL.
*
*      lw_entrada-tplnr = lw_charac_data-tplnr.
*
*    ELSE.
*
*      lw_entrada-tplnr = lw_charac_data-order_step_plant.
*
*    ENDIF.
*
*    READ TABLE lt_tdc INTO lw_tdc WITH KEY work_center = lw_charac_data-work_center
*                                                 verwmerkm   = lw_charac_data-verwmerkm.
*    IF sy-subrc = 0.
*
*      lw_dados_sumario-position =  lw_charac_data-position.
*
*      CASE lw_tdc-fill_field.
*
*        WHEN 'SE'.
*          lw_dados_sumario-value = pw_result_tetraz-mp.
*
*      ENDCASE.
*
*
*      APPEND lw_dados_sumario TO lw_entrada-dados.
*      CLEAR lw_dados_sumario.
*
*    ENDIF.
*
*  ENDLOOP.
*
*  IF lw_entrada IS NOT INITIAL.
*
*    CREATE OBJECT lo_entrada
*      EXPORTING
*        iw_entrada = lw_entrada.
*
*    lt_bdc_return = lo_entrada->get_bcd( ).
*
*    PERFORM zf_call_shdb USING lt_bdc_return.
*  ENDIF.
*
*  CLEAR lw_entrada.
*  CLEAR lt_bdc_return.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_call_shdb
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_BDC_RETURN
*&---------------------------------------------------------------------*
FORM zf_call_shdb  USING    p_lt_bdc_return TYPE /sprolims/cl_result_rec_shdb=>yt_bdc.

  DATA: BEGIN OF lt_bdc OCCURS 0.
          INCLUDE STRUCTURE bdcdata.
        DATA: END OF lt_bdc.

  DATA: BEGIN OF lt_msg_bdc OCCURS 0.
          INCLUDE STRUCTURE bdcmsgcoll.
        DATA: END OF lt_msg_bdc.

  DATA: lw_options_bdc TYPE ctu_params.

  lt_bdc[] = p_lt_bdc_return[].

  lw_options_bdc-dismode = 'S'.
  lw_options_bdc-updmode = 'A'.
  lw_options_bdc-defsize = 'X'.

  CALL TRANSACTION 'QE20' USING lt_bdc
                          OPTIONS FROM lw_options_bdc
                          MESSAGES INTO lt_msg_bdc.

*  CALL TRANSACTION 'QE20' USING lt_bdc MODE 'A'.



  COMMIT WORK AND WAIT.

ENDFORM.
