FUNCTION /sprolims/fm_register_step.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IW_REGISTER_STEP) TYPE  /SPROLIMS/ST_GW_REGISTER_STEP
*"  EXPORTING
*"     VALUE(EW_REGISTER_STEP) TYPE  /SPROLIMS/ST_GW_REGISTER_STEP
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: lt_timetickets TYPE TABLE OF bapi_alm_timeconfirmation,
        lt_return      TYPE  bapiret2_t.

  DATA: lw_timetickets LIKE LINE OF lt_timetickets,
        lw_return      LIKE LINE OF lt_return.

  DATA: lv_tzone           TYPE   tznzone,
        lv_wait            LIKE   bapita-wait VALUE '2',
        lv_registro_inicio TYPE   flag.

  CLEAR lt_return.

  DATA(lt_goodsmvt_item) = t_goodsmvt_item.
  DELETE lt_goodsmvt_item WHERE orderid <> iw_register_step-orderid.

  "Verifica se a requisição é de registro de início ou fim
  IF iw_register_step-complete <> 'X'.
    lv_registro_inicio = 'X'.
  ELSE.
    lv_registro_inicio = ''.
  ENDIF.

  "Busca valor da timezone
  SELECT SINGLE *
    FROM /sprolims/tb_cf1
    INTO @DATA(lw_cf1)
    WHERE werks =  @iw_register_step-plant.

  IF lw_cf1-tznzone IS NOT INITIAL.

    lv_tzone = lw_cf1-tznzone.

  ELSE.

    lv_tzone = 'BRAZIL'.

  ENDIF.

  "Verificações de existência de início e fim
  SELECT * UP TO 1 ROWS
    FROM /sprolims/cdsors
    INTO @DATA(lw_cdsors)
    WHERE order_id      = @iw_register_step-orderid AND
          order_step_id = @iw_register_step-operation.
  ENDSELECT.

  "Verifica se a etapa já não foi confirmada
  IF lw_cdsors-partial_final_confirmation = 'X' .

    lw_return-type        = 'E'.
    lw_return-id          = '/SPROLIMS/MC_REGIS'.
    lw_return-number      = '003'.
    lw_return-message_v1  = iw_register_step-orderid.
    lw_return-message_v2  = iw_register_step-operation.

    MESSAGE ID '/SPROLIMS/MC_REGIS' TYPE 'E' NUMBER '003' WITH   iw_register_step-orderid iw_register_step-operation '' '' INTO   lw_return-message.

    APPEND lw_return TO lt_return.
    CLEAR lw_return.

  ELSE.

    IF      lw_cdsors-confirmation_start_date IS INITIAL AND
            lv_registro_inicio = ''. "Para o registro de fim, verifica se a etapa já foi iniciada

      lw_return-type        = 'E'.
      lw_return-id          = '/SPROLIMS/MC_REGIS'.
      lw_return-number      = '006'.
      lw_return-message_v1  = iw_register_step-orderid.
      lw_return-message_v2  = iw_register_step-operation.

      MESSAGE ID '/SPROLIMS/MC_REGIS' TYPE 'E' NUMBER '006' WITH   iw_register_step-orderid iw_register_step-operation '' '' INTO   lw_return-message.

      APPEND lw_return TO lt_return.
      CLEAR lw_return.

    ELSEIF  lw_cdsors-confirmation_start_date IS NOT INITIAL AND
            lv_registro_inicio = 'X'. "Para o registro de início, verifica se a etapa já não foi iniciada

      lw_return-type        = 'E'.
      lw_return-id          = '/SPROLIMS/MC_REGIS'.
      lw_return-number      = '007'.
      lw_return-message_v1  = iw_register_step-orderid.
      lw_return-message_v2  = iw_register_step-operation.

      MESSAGE ID '/SPROLIMS/MC_REGIS' TYPE 'E' NUMBER '007' WITH   iw_register_step-orderid iw_register_step-operation '' '' INTO   lw_return-message.

      APPEND lw_return TO lt_return.
      CLEAR lw_return.

    ENDIF.

  ENDIF.

  IF lt_return IS INITIAL.

    IF lt_goodsmvt_item IS NOT INITIAL.

      TYPES: BEGIN OF y_goodsmvt_item_aux,
               material TYPE matnr,
               stge_loc TYPE bapi2017_gm_item_create-stge_loc,
               plant    TYPE bapi2017_gm_item_create-plant,
             END OF y_goodsmvt_item_aux,

             tt_goodsmvt_item_aux TYPE STANDARD TABLE OF y_goodsmvt_item_aux WITH DEFAULT KEY.

      DATA(lt_goodsmvt_item_aux) = VALUE tt_goodsmvt_item_aux(
                                          FOR wa IN lt_goodsmvt_item
                                            ( material = wa-material
                                              stge_loc = wa-stge_loc
                                              plant    = wa-plant ) ).

      "Verifica se lote e depósito da lista proposta de materiais estão preenchidos
      SELECT *
        FROM /sprolims/cds_mcd_material
        INTO TABLE @DATA(lt_cdsmcd)
        FOR ALL ENTRIES IN @lt_goodsmvt_item_aux
        WHERE material = @lt_goodsmvt_item_aux-material.

      SELECT *
        FROM mard
        INTO TABLE @DATA(lt_mard)
         FOR ALL ENTRIES IN @lt_goodsmvt_item_aux
        WHERE matnr  = @lt_goodsmvt_item_aux-material
          AND lgort  = @lt_goodsmvt_item_aux-stge_loc
          AND werks  = @lt_goodsmvt_item_aux-plant
          AND labst NE 0.

      LOOP AT lt_goodsmvt_item INTO DATA(lw_goodsmvt_item) WHERE entry_qnt <> 0.

        IF  lw_goodsmvt_item-stge_loc IS INITIAL.

          lw_return-type        = 'E'.
          lw_return-id          = '/SPROLIMS/MC_REGIS'.
          lw_return-number      = '002'.
          lw_return-message_v1  = iw_register_step-orderid.
          lw_return-message_v2  = iw_register_step-operation.
          lw_return-message_v3  = lw_goodsmvt_item-material.

          MESSAGE ID '/SPROLIMS/MC_REGIS' TYPE 'E' NUMBER '002' WITH   iw_register_step-orderid iw_register_step-operation lw_goodsmvt_item-material '' INTO   lw_return-message.

          APPEND lw_return TO lt_return.
          CLEAR lw_return.

        ENDIF.

        IF  lw_goodsmvt_item-batch IS INITIAL.

          READ TABLE lt_cdsmcd INTO DATA(lw_cdsmcd) WITH KEY material = lw_goodsmvt_item-material.

          IF lw_cdsmcd-obligatory_batch = 'X'.

            lw_return-type        = 'E'.
            lw_return-id          = '/SPROLIMS/MC_REGIS'.
            lw_return-number      = '001'.
            lw_return-message_v1  = iw_register_step-orderid.
            lw_return-message_v2  = iw_register_step-operation.
            lw_return-message_v3  = lw_goodsmvt_item-material.

            MESSAGE ID '/SPROLIMS/MC_REGIS' TYPE 'E' NUMBER '001' WITH   iw_register_step-orderid iw_register_step-operation lw_goodsmvt_item-material '' INTO   lw_return-message.

            APPEND lw_return TO lt_return.
            CLEAR lw_return.

          ENDIF.
        ENDIF.

        READ TABLE lt_mard INTO DATA(lw_mard) WITH KEY matnr  = lw_goodsmvt_item-material
                                                       lgort  = lw_goodsmvt_item-stge_loc
                                                       werks  = lw_goodsmvt_item-plant.

        IF sy-subrc <> 0.

          lw_return-type        = 'E'.
          lw_return-id          = '/SPROLIMS/MC_REGIS'.
          lw_return-number      = '011'.
          lw_return-message_v1  = lw_goodsmvt_item-material.
          lw_return-message_v2  = lw_goodsmvt_item-stge_loc.

          MESSAGE ID '/SPROLIMS/MC_REGIS' TYPE 'E' NUMBER '011' WITH lw_goodsmvt_item-material lw_goodsmvt_item-stge_loc INTO lw_return-message.

          APPEND lw_return TO lt_return.
          CLEAR lw_return.

        ENDIF.

      ENDLOOP.

      IF lt_return IS NOT INITIAL.

        APPEND LINES OF lt_return TO et_return.
        EXIT.

      ENDIF.

    ELSE.

      "Verifica se lote e depósito da lista proposta de materiais estão preenchidos
      SELECT *
        FROM /sprolims/cdsosm
        INTO TABLE @DATA(lt_cdsosm)
        WHERE order_id      = @iw_register_step-orderid AND
              order_step_id = @iw_register_step-operation.

      LOOP AT lt_cdsosm INTO DATA(lw_cdsosm) WHERE material IS NOT INITIAL.

        IF  lw_cdsosm-storage IS INITIAL.

          lw_return-type        = 'E'.
          lw_return-id          = '/SPROLIMS/MC_REGIS'.
          lw_return-number      = '002'.
          lw_return-message_v1  = iw_register_step-orderid.
          lw_return-message_v2  = iw_register_step-operation.
          lw_return-message_v3  = lw_cdsosm-material.

          MESSAGE ID '/SPROLIMS/MC_REGIS' TYPE 'E' NUMBER '002' WITH   iw_register_step-orderid iw_register_step-operation lw_cdsosm-material '' INTO   lw_return-message.

          APPEND lw_return TO lt_return.
          CLEAR lw_return.

        ENDIF.

        IF  lw_cdsosm-batch IS INITIAL AND
            lw_cdsosm-obligatory_batch = 'X'.

          lw_return-type        = 'E'.
          lw_return-id          = '/SPROLIMS/MC_REGIS'.
          lw_return-number      = '001'.
          lw_return-message_v1  = iw_register_step-orderid.
          lw_return-message_v2  = iw_register_step-operation.
          lw_return-message_v3  = lw_cdsosm-material.

          MESSAGE ID '/SPROLIMS/MC_REGIS' TYPE 'E' NUMBER '001' WITH   iw_register_step-orderid iw_register_step-operation lw_cdsosm-material '' INTO   lw_return-message.

          APPEND lw_return TO lt_return.
          CLEAR lw_return.

        ENDIF.

      ENDLOOP.
    ENDIF.

    IF lt_return IS INITIAL.

      IF  iw_register_step-conf_no IS INITIAL OR
          iw_register_step-conf_no  =  ''.
        lw_timetickets-conf_no          = '0000000000'.
      ELSE.
        lw_timetickets-conf_no          = iw_register_step-conf_no.
      ENDIF.
      lw_timetickets-orderid          = iw_register_step-orderid.
      lw_timetickets-operation        = iw_register_step-operation.
      lw_timetickets-plant            = iw_register_step-plant.
      lw_timetickets-work_cntr        = iw_register_step-work_cntr.
      lw_timetickets-act_work         = iw_register_step-act_work.
      lw_timetickets-un_work          = iw_register_step-un_work.
      lw_timetickets-act_type         = iw_register_step-act_type.
      lw_timetickets-fin_conf         = iw_register_step-fin_conf.
      lw_timetickets-complete         = iw_register_step-complete.
      lw_timetickets-clear_res        = iw_register_step-clear_res.

      IF iw_register_step-complete = 'X'.

        lw_timetickets-exec_start_date = lw_cdsors-confirmation_start_date.
        lw_timetickets-exec_start_time = lw_cdsors-confirmation_start_time.

      ELSE.

        CONVERT TIME STAMP iw_register_step-exec_start_datetime TIME ZONE lv_tzone
        INTO  DATE lw_timetickets-exec_start_date
              TIME lw_timetickets-exec_start_time.

      ENDIF.

      CONVERT TIME STAMP iw_register_step-exec_fin_datetime TIME ZONE lv_tzone
        INTO  DATE lw_timetickets-exec_fin_date
              TIME lw_timetickets-exec_fin_time.

      IF lw_timetickets-un_work IS NOT INITIAL.

        SELECT SINGLE isocode
          FROM t006
          INTO lw_timetickets-un_work_iso
          WHERE msehi = lw_timetickets-un_work.

      ENDIF.

      APPEND lw_timetickets TO t_timetickets.

      IF iw_register_step-last = 'X'. "Somente executa a BAPI na ultima iteração

        CALL FUNCTION '/SPROLIMS/FM_REG_STP_CALL_BADI'
          IMPORTING
            et_return = lt_return.

        APPEND LINES OF lt_return TO t_return.

      ENDIF.

    ELSEIF iw_register_step-last = 'X' AND t_timetickets IS NOT INITIAL. "Somente executa a BAPI na ultima iteração

      CALL FUNCTION '/SPROLIMS/FM_REG_STP_CALL_BADI'
        IMPORTING
          et_return = lt_return.

      APPEND LINES OF lt_return TO t_return.
    ENDIF.

  ELSEIF iw_register_step-last = 'X' AND t_timetickets IS NOT INITIAL. "Somente executa a BAPI na ultima iteração

    CALL FUNCTION '/SPROLIMS/FM_REG_STP_CALL_BADI'
      IMPORTING
        et_return = lt_return.

    APPEND LINES OF lt_return TO t_return.
  ENDIF.

  IF iw_register_step-last = 'X'.

    APPEND LINES OF lt_return TO t_return.
    APPEND LINES OF t_return  TO et_return.

    SORT et_return BY message.
    DELETE ADJACENT DUPLICATES FROM et_return COMPARING message.

  ELSE.

    APPEND LINES OF lt_return TO t_return.

  ENDIF.

*  CLEAR t_goodsmvt_item.
ENDFUNCTION.
