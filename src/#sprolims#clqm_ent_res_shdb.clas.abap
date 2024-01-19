class /SPROLIMS/CLQM_ENT_RES_SHDB definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF y_defeitos,
             fegrp     TYPE qcgrfehler,
             fecod     TYPE  qcodefhlr,
             anzfehler TYPE  qanzfehl4,
           END OF y_defeitos .
  types:
    yt_defeitos TYPE TABLE OF y_defeitos WITH DEFAULT KEY .
  types:
    BEGIN OF y_dados_sumario,
        position TYPE n LENGTH 2,
        value    TYPE qaqee-sumplus,
        defeitos TYPE yt_defeitos,
      END OF y_dados_sumario .
  types:
    yt_dados_sumario TYPE TABLE OF y_dados_sumario WITH DEFAULT KEY .
  types:
*    types:  begin of y_tipo_tolerancia,
*            position TYPE n LENGTH 2,
*            value    TYPE qaqee-sumplus,
*            end of y_tipo_tolerancia.
*    TYPES:
*      yt_tipo_tolerancia TYPE TABLE OF y_tipo_tolerancia WITH DEFAULT KEY .
    BEGIN OF y_dados_unidade,
        position TYPE n LENGTH 2,
        value    TYPE qaqee-sumplus,
        defeitos TYPE yt_defeitos,
        tipo_tolerancia type qaqee-sumplus,
      END OF y_dados_unidade .
  types:
    yt_dados_unidade TYPE TABLE OF y_dados_unidade WITH DEFAULT KEY .
  types:
    BEGIN OF y_unidades_controle,
             unidade        TYPE i,
             dados_unidades TYPE yt_dados_unidade,
           END OF y_unidades_controle .
  types:
    yt_unidades_controle TYPE TABLE OF y_unidades_controle  WITH DEFAULT KEY .
  types:
    BEGIN OF y_entrada,
        prueflos          TYPE qplos,
        vornr             TYPE qaqee-vornr,
        tplnr             TYPE qappd-tplnr,
        dados             TYPE yt_dados_sumario,
        unidades_controle TYPE yt_unidades_controle,
      END OF y_entrada .
  types:
    yt_entrada TYPE TABLE OF y_entrada WITH DEFAULT KEY .
  types:
    yt_bdc TYPE TABLE OF bdcdata WITH DEFAULT KEY .

  methods CONSTRUCTOR
    importing
      !IW_ENTRADA type Y_ENTRADA .
  methods GET_BCD
    returning
      value(RT_BDC) type YT_BDC .
  methods GET_DATE_HOUR
    exporting
      !EV_DATE type CHAR10
      !EV_HOUR type CHAR8
      !EV_DATLO type SY-DATLO
      !EV_TIMLO type SY-TIMLO .
protected section.
private section.

  data W_ENTRADA type Y_ENTRADA .
  data T_BDC type YT_BDC .
  data V_DATE type CHAR10 .
  data V_HOUR type CHAR8 .
  data V_DATLO type SY-DATLO .
  data V_TIMLO type SY-TIMLO .

  methods SET_DYNPRO
    importing
      !IV_SCREEN type ANY
      !IV_FIELD type ANY
      !IV_VALUE type ANY .
  methods SET_DATE_HOUR .
ENDCLASS.



CLASS /SPROLIMS/CLQM_ENT_RES_SHDB IMPLEMENTATION.


  method CONSTRUCTOR.

    w_entrada = iw_entrada.

    me->set_date_hour( ).

  endmethod.


  METHOD GET_BCD.

    DATA: lv_index_charc                TYPE n LENGTH 2,
          lv_index_defeito              TYPE n LENGTH 2,
          lv_field                      TYPE bdc_prog,
          lv_correct_screen_comparision TYPE n LENGTH 2 VALUE '08'.



    set_dynpro( iv_screen =  'X' iv_field  = 'SAPMQEEA'       iv_value  = '0100' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_OKCODE'     iv_value  = '=ENT0' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'QALS-PRUEFLOS'  iv_value  = w_entrada-prueflos ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'QAQEE-VORNR'    iv_value  = w_entrada-vornr ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR'     iv_value  = 'SAPLQAPP                                0100PRUEFPUNKT' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_CURSOR'     iv_value  = 'QAPPD-TPLNR' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'QAPPD-TPLNR'    iv_value  = w_entrada-tplnr ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'QAPPD-USERD1'    iv_value  = v_date ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'QAPPD-USERT1'    iv_value  = v_hour ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'QAQEE-PRUEFDATUV'    iv_value  = v_date ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'QAQEE-PRUEFZEITV'    iv_value  = v_hour ).


    LOOP AT w_entrada-dados ASSIGNING FIELD-SYMBOL(<fs_dados>).

      lv_index_charc = <fs_dados>-position.
      lv_index_charc = |{ lv_index_charc ALPHA = IN }|.

      set_dynpro( iv_screen =  'X' iv_field  = 'SAPLQEEM'   iv_value  = '1110' ).

      CLEAR lv_field.
      CONCATENATE 'QAQEE-SUMPLUS(' lv_index_charc ')' INTO lv_field.
      set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_CURSOR' iv_value  = lv_field ).

      CLEAR lv_field.
      CONCATENATE 'QAQEE-SUMPLUS(' lv_index_charc ')' INTO lv_field.
      set_dynpro( iv_screen =  ' ' iv_field  = lv_field     iv_value  = <fs_dados>-value ).

      LOOP AT <fs_dados>-defeitos ASSIGNING FIELD-SYMBOL(<fs_defeitos>).

        lv_index_defeito = sy-tabix.
        lv_index_defeito = |{ lv_index_defeito ALPHA = IN }|.

        AT FIRST.

          set_dynpro( iv_screen =  'X' iv_field  = 'SAPLQEEM'   iv_value  = '1110' ).

          CLEAR lv_field.
          CONCATENATE 'QAQEE-SUMPLUS(' lv_index_charc ')' INTO lv_field.
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_CURSOR' iv_value  = lv_field ).

          CLEAR lv_field.
          CONCATENATE '=FMER-0' lv_index_charc INTO lv_field.
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_OKCODE' iv_value  = lv_field ).

          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                5000PIC_GRO_EE' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLSEXM                                0200BADI_SUBSCR_5000' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                0202SUB_EE_DATEN' ).

          set_dynpro( iv_screen =  'X' iv_field  = 'SAPLQFFE'   iv_value  = '3000' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_OKCODE' iv_value  = '=XBAS' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQFFE                                4000SUB_ITEM_OVERVIEW' ).

        ENDAT.

        CLEAR lv_field.
        CONCATENATE 'QFAAI-FEGRP(' lv_index_defeito ')' INTO lv_field.
        set_dynpro( iv_screen =  ' ' iv_field  = lv_field     iv_value  = <fs_defeitos>-fegrp ).

        CLEAR lv_field.
        CONCATENATE 'QFAAI-FECOD(' lv_index_defeito ')' INTO lv_field.
        set_dynpro( iv_screen =  ' ' iv_field  = lv_field     iv_value  = <fs_defeitos>-fecod ).

        CLEAR lv_field.
        CONCATENATE 'QFAAI-ANZFEHLER(' lv_index_defeito ')' INTO lv_field.
        set_dynpro( iv_screen =  ' ' iv_field  = lv_field     iv_value  = <fs_defeitos>-anzfehler ).

      ENDLOOP.

    ENDLOOP.

    IF w_entrada-unidades_controle IS NOT INITIAL.

      LOOP AT w_entrada-unidades_controle[ 1 ]-dados_unidades TRANSPORTING NO FIELDS WHERE position > lv_correct_screen_comparision.

        DATA(lv_screen_correction) = 'X'.
        EXIT.

      ENDLOOP.

      IF lv_screen_correction IS INITIAL.

        LOOP AT w_entrada-unidades_controle  ASSIGNING FIELD-SYMBOL(<fs_unidades_controle>).

          AT FIRST.

            set_dynpro( iv_screen =  'X' iv_field  = 'SAPLQEEM'   iv_value  = '1110' ).
            set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_OKCODE' iv_value  = '=SIPR' ).
            set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR'    iv_value  = 'SAPLQEEM                                5000PIC_GRO_EE' ).
            set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLSEXM                                0200BADI_SUBSCR_5000' ).
            set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                0202SUB_EE_DATEN' ).
            set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                5300SUB_EE_FCODE' ).

          ENDAT.


          set_dynpro( iv_screen =  'X' iv_field  = 'SAPLQEEM'   iv_value  = '1110' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_OKCODE' iv_value  = '=APRF' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR'    iv_value  = 'SAPLQEEM                                5000PIC_GRO_EE' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLSEXM                                0200BADI_SUBSCR_5000' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                0202SUB_EE_DATEN' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                5300SUB_EE_FCODE' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'QAQEE-SERIALNR'    iv_value  = <fs_unidades_controle>-unidade ).

          LOOP AT <fs_unidades_controle>-dados_unidades ASSIGNING FIELD-SYMBOL(<fs_dados_unidades>).

            lv_index_charc = <fs_dados_unidades>-position.
            lv_index_charc = |{ lv_index_charc ALPHA = IN }|.

            CLEAR lv_field.
            CONCATENATE 'QAQEE-EINFELDPRF(' lv_index_charc ')' INTO lv_field.
            set_dynpro( iv_screen =  ' ' iv_field  = lv_field     iv_value  = <fs_dados_unidades>-value ).

            IF <fs_dados_unidades>-tipo_tolerancia IS NOT INITIAL.
              CLEAR lv_field.
              CONCATENATE 'QAQEE-MASCHINE(' lv_index_charc ')' INTO lv_field.
              set_dynpro( iv_screen =  ' ' iv_field  = lv_field     iv_value  = <fs_dados_unidades>-tipo_tolerancia ).
            ENDIF.

          ENDLOOP.

          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                5300SUB_EE_FCODE' ).

        ENDLOOP.

      ELSE.

        LOOP AT w_entrada-unidades_controle  ASSIGNING <fs_unidades_controle>.

          AT FIRST.

            set_dynpro( iv_screen =  'X' iv_field  = 'SAPLQEEM'   iv_value  = '1110' ).
            set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_OKCODE' iv_value  = '=SIPR' ).
            set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                5000PIC_GRO_EE' ).
            set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLSEXM                                0200BADI_SUBSCR_5000' ).
            set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                0202SUB_EE_DATEN' ).
            set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                5300SUB_EE_FCODE' ).

          ENDAT.


          set_dynpro( iv_screen =  'X' iv_field  = 'SAPLQEEM'   iv_value  = '1110' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_OKCODE' iv_value  = '=ENT0' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                5000PIC_GRO_EE' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLSEXM                                0200BADI_SUBSCR_5000' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                0202SUB_EE_DATEN' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                5300SUB_EE_FCODE' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'QAQEE-SERIALNR'    iv_value  = <fs_unidades_controle>-unidade ).

          LOOP AT <fs_unidades_controle>-dados_unidades ASSIGNING <fs_dados_unidades>.

            IF <fs_dados_unidades>-position < '09'.

              lv_index_charc = <fs_dados_unidades>-position.
              lv_index_charc = |{ lv_index_charc ALPHA = IN }|.

              CLEAR lv_field.
              CONCATENATE 'QAQEE-EINFELDPRF(' lv_index_charc ')' INTO lv_field.
              set_dynpro( iv_screen =  ' ' iv_field  = lv_field     iv_value  = <fs_dados_unidades>-value ).

              IF <fs_dados_unidades>-tipo_tolerancia IS NOT INITIAL.
                CLEAR lv_field.
                CONCATENATE 'QAQEE-MASCHINE(' lv_index_charc ')' INTO lv_field.
                set_dynpro( iv_screen =  ' ' iv_field  = lv_field     iv_value  = <fs_dados_unidades>-tipo_tolerancia ).
              ENDIF.

            ELSEIF <fs_dados_unidades>-position = '09'.

              set_dynpro( iv_screen =  'X' iv_field  = 'SAPLQEEM'   iv_value  = '1110' ).
              set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_OKCODE' iv_value  = '=P+' ).
              set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                5000PIC_GRO_EE' ).
              set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLSEXM                                0200BADI_SUBSCR_5000' ).
              set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                0202SUB_EE_DATEN' ).
              set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                5300SUB_EE_FCODE' ).

              set_dynpro( iv_screen =  'X' iv_field  = 'SAPLQEEM'   iv_value  = '1110' ).
              set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_OKCODE' iv_value  = '=ENT0' ).
              set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                5000PIC_GRO_EE' ).
              set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLSEXM                                0200BADI_SUBSCR_5000' ).
              set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                0202SUB_EE_DATEN' ).
              set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                5300SUB_EE_FCODE' ).

              lv_index_charc = <fs_dados_unidades>-position - 8.
              lv_index_charc = |{ lv_index_charc ALPHA = IN }|.

              CLEAR lv_field.
              CONCATENATE 'QAQEE-EINFELDPRF(' lv_index_charc ')' INTO lv_field.
              set_dynpro( iv_screen =  ' ' iv_field  = lv_field     iv_value  = <fs_dados_unidades>-value ).

              IF <fs_dados_unidades>-tipo_tolerancia IS NOT INITIAL.
                CLEAR lv_field.
                CONCATENATE 'QAQEE-MASCHINE(' lv_index_charc ')' INTO lv_field.
                set_dynpro( iv_screen =  ' ' iv_field  = lv_field     iv_value  = <fs_dados_unidades>-tipo_tolerancia ).
              ENDIF.



            ELSEIF <fs_dados_unidades>-position > '09'.

              lv_index_charc = <fs_dados_unidades>-position - 8.
              lv_index_charc = |{ lv_index_charc ALPHA = IN }|.

              CLEAR lv_field.
              CONCATENATE 'QAQEE-EINFELDPRF(' lv_index_charc ')' INTO lv_field.
              set_dynpro( iv_screen =  ' ' iv_field  = lv_field     iv_value  = <fs_dados_unidades>-value ).

              IF <fs_dados_unidades>-tipo_tolerancia IS NOT INITIAL.
                CLEAR lv_field.
                CONCATENATE 'QAQEE-MASCHINE(' lv_index_charc ')' INTO lv_field.
                set_dynpro( iv_screen =  ' ' iv_field  = lv_field     iv_value  = <fs_dados_unidades>-tipo_tolerancia ).
              ENDIF.


            ENDIF.

          ENDLOOP.

          set_dynpro( iv_screen =  'X' iv_field  = 'SAPLQEEM'   iv_value  = '1110' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_OKCODE' iv_value  = '=APRF' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                5000PIC_GRO_EE' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLSEXM                                0200BADI_SUBSCR_5000' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                0202SUB_EE_DATEN' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                5300SUB_EE_FCODE' ).
*          set_dynpro( iv_screen =  ' ' iv_field  = 'QAQEE-SERIALNR'   iv_value  = <fs_unidades_controle>-unidade ).

          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                5300SUB_EE_FCODE' ).

        ENDLOOP.

      ENDIF.

    ENDIF.

    set_dynpro( iv_screen =  'X' iv_field  = 'SAPLQEEM'   iv_value  = '1110' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_OKCODE' iv_value  = '=MKAL' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR'    iv_value  = 'SAPLQEEM                                5000PIC_GRO_EE' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLSEXM                                0200BADI_SUBSCR_5000' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                0202SUB_EE_DATEN' ).

    set_dynpro( iv_screen =  'X' iv_field  = 'SAPLQEEM'   iv_value  = '1110' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_OKCODE' iv_value  = '=BEWE' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR'    iv_value  = 'SAPLQEEM                                5000PIC_GRO_EE' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLSEXM                                0200BADI_SUBSCR_5000' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                0202SUB_EE_DATEN' ).

    set_dynpro( iv_screen =  'X' iv_field  = 'SAPLQEEM'   iv_value  = '1110' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_OKCODE' iv_value  = '=ABSL' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                5000PIC_GRO_EE' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLSEXM                                0200BADI_SUBSCR_5000' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                0202SUB_EE_DATEN' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                5300SUB_EE_FCODE' ).

    set_dynpro( iv_screen =  'X' iv_field  = 'SAPLQEEM'   iv_value  = '1110' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_OKCODE' iv_value  = '=BU' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                5000PIC_GRO_EE' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLSEXM                                0200BADI_SUBSCR_5000' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                0202SUB_EE_DATEN' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                5300SUB_EE_FCODE' ).

    set_dynpro( iv_screen =  'X' iv_field  = 'SAPLQAPP'   iv_value  = '0300' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_CURSOR' iv_value  = 'QAPPW-TXTPPBEW' ).
    set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_OKCODE' iv_value  = '=ENTE' ).

    LOOP AT t_bdc ASSIGNING FIELD-SYMBOL(<fs_bdc>) WHERE  fnam CS 'QFAAI-ANZFEHLER(' OR
                                                          fnam EQ 'QAQEE-SERIALNR'.

      WRITE <fs_bdc>-fval TO <fs_bdc>-fval.
      SHIFT <fs_bdc>-fval LEFT DELETING LEADING ''.

    ENDLOOP.

    rt_bdc = t_bdc.

* Defeitos Unidades de Controle
*LOOP AT <fs_dados_unidades>-defeitos ASSIGNING <fs_defeitos>.
*
*          lv_index_defeito = sy-tabix.
*          lv_index_defeito = |{ lv_index_defeito ALPHA = IN }|.
*
*          AT FIRST.
*
*            set_dynpro( iv_screen =  'X' iv_field  = 'SAPLQEEM'   iv_value  = '1110' ).
*            CLEAR lv_field.
*            CONCATENATE '=FMER-0' lv_index_charc INTO lv_field.
*            set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_OKCODE' iv_value  = lv_field ).
*
*            set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                5000PIC_GRO_EE' ).
*            set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLSEXM                                0200BADI_SUBSCR_5000' ).
*            set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                0202SUB_EE_DATEN' ).
*
*            set_dynpro( iv_screen =  'X' iv_field  = 'SAPLQFFE'   iv_value  = '3000' ).
*            set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_OKCODE' iv_value  = '=XBAS' ).
*            set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQFFE                                4000SUB_ITEM_OVERVIEW' ).
*
*          ENDAT.
*
*          CLEAR lv_field.
*          CONCATENATE 'QFAAI-FEGRP(' lv_index_defeito ')' INTO lv_field.
*          set_dynpro( iv_screen =  ' ' iv_field  = lv_field     iv_value  = <fs_defeitos>-fegrp ).
*
*          CLEAR lv_field.
*          CONCATENATE 'QFAAI-FECOD(' lv_index_defeito ')' INTO lv_field.
*          set_dynpro( iv_screen =  ' ' iv_field  = lv_field     iv_value  = <fs_defeitos>-fecod ).
*
*          CLEAR lv_field.
*          CONCATENATE 'QFAAI-ANZFEHLER(' lv_index_defeito ')' INTO lv_field.
*          set_dynpro( iv_screen =  ' ' iv_field  = lv_field     iv_value  = <fs_defeitos>-anzfehler ).
*
*        ENDLOOP.


  ENDMETHOD.


  method GET_DATE_HOUR.

    ev_date = v_date.
    ev_hour = v_hour.
    ev_datlo = v_datlo.
    ev_timlo = v_timlo.

  endmethod.


  METHOD SET_DATE_HOUR.

    CONCATENATE sy-datlo+6(2) '.' sy-datlo+4(2) '.' sy-datlo(4) INTO v_date.
    CONCATENATE sy-timlo(2) ':' sy-timlo+2(2) ':' sy-timlo+4(2) INTO v_hour.

    v_datlo = sy-datlo.
    v_timlo = sy-timlo.

  ENDMETHOD.


  METHOD SET_DYNPRO.

    DATA: lw_bdc TYPE bdcdata.

    DATA: lv_screen	TYPE flag,
          lv_field  TYPE bdc_prog,
          lv_value  TYPE bdc_fval.

    lv_screen = iv_screen.
    lv_field = iv_field.
    lv_value = iv_value.

    IF  lv_screen IS NOT INITIAL.
      lw_bdc-dynbegin = 'X'.
      lw_bdc-program  = lv_field.
      lw_bdc-dynpro   = lv_value.
    ELSE.
      lw_bdc-fnam = lv_field.
      lw_bdc-fval = lv_value.
    ENDIF.

    APPEND lw_bdc TO t_bdc.


  ENDMETHOD.
ENDCLASS.
