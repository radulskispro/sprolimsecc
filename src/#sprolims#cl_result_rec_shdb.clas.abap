class /SPROLIMS/CL_RESULT_REC_SHDB definition
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
        observacoes type c LENGTH 255,
      END OF y_dados_sumario .
  types:
    yt_dados_sumario TYPE TABLE OF y_dados_sumario WITH DEFAULT KEY .
  types:
    BEGIN OF y_dados_unidade,
        position TYPE n LENGTH 2,
        value    TYPE qaqee-sumplus,
        defeitos TYPE yt_defeitos,
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
protected section.
private section.

  data W_ENTRADA type Y_ENTRADA .
  data T_BDC type YT_BDC .

  methods SET_DYNPRO
    importing
      !IV_SCREEN type ANY
      !IV_FIELD type ANY
      !IV_VALUE type ANY .
ENDCLASS.



CLASS /SPROLIMS/CL_RESULT_REC_SHDB IMPLEMENTATION.


  METHOD constructor.

    w_entrada = iw_entrada.

  ENDMETHOD.


  METHOD get_bcd.

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


    LOOP AT w_entrada-dados ASSIGNING FIELD-SYMBOL(<fs_dados>).

      IF <fs_dados>-position < '10'.

        lv_index_charc = <fs_dados>-position.
        lv_index_charc = |{ lv_index_charc ALPHA = IN }|.

        set_dynpro( iv_screen =  'X' iv_field  = 'SAPLQEEM'   iv_value  = '1110' ).
        CLEAR lv_field.
        CONCATENATE 'QAQEE-SUMPLUS(' lv_index_charc ')' INTO lv_field.
        set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_CURSOR' iv_value  = lv_field ).

        CLEAR lv_field.
        CONCATENATE 'QAQEE-SUMPLUS(' lv_index_charc ')' INTO lv_field.
        set_dynpro( iv_screen =  ' ' iv_field  = lv_field     iv_value  = <fs_dados>-value ).


        IF <fs_dados>-observacoes IS NOT INITIAL.

          set_dynpro( iv_screen =  'X' iv_field  = 'SAPLQEEM'   iv_value  = '1110' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_CURSOR' iv_value  = 'QMICON-PBMMERKMAL(01)' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_OKCODE' iv_value  = '=PBEL-001' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                5000PIC_GRO_EE' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLSEXM                                0200BADI_SUBSCR_5000' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_SUBSCR' iv_value  = 'SAPLQEEM                                0202SUB_EE_DATEN' ).

          set_dynpro( iv_screen =  'X' iv_field  = 'SAPLSTXX'   iv_value  = '1100' ).

          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_OKCODE' iv_value  = '=TXBA' ).

          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_CURSOR' iv_value  = 'RSTXT-TXLINE(02)' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'RSTXT-TXLINE(02)'     iv_value  = <fs_dados>-observacoes(72) ).

          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_CURSOR' iv_value  = 'RSTXT-TXLINE(03)' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'RSTXT-TXLINE(03)'     iv_value  = <fs_dados>-observacoes+72(72) ).

          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_CURSOR' iv_value  = 'RSTXT-TXLINE(04)' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'RSTXT-TXLINE(04)'     iv_value  = <fs_dados>-observacoes+144(72) ).

          set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_CURSOR' iv_value  = 'RSTXT-TXLINE(05)' ).
          set_dynpro( iv_screen =  ' ' iv_field  = 'RSTXT-TXLINE(05)'     iv_value  = <fs_dados>-observacoes+216(39) ).

        ENDIF.

      ELSEIF <fs_dados>-position = '10'.

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

        lv_index_charc = <fs_dados>-position - 9.
        lv_index_charc = |{ lv_index_charc ALPHA = IN }|.

        set_dynpro( iv_screen =  'X' iv_field  = 'SAPLQEEM'   iv_value  = '1110' ).
        CLEAR lv_field.
        CONCATENATE 'QAQEE-SUMPLUS(' lv_index_charc ')' INTO lv_field.
        set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_CURSOR' iv_value  = lv_field ).

        CLEAR lv_field.
        CONCATENATE 'QAQEE-SUMPLUS(' lv_index_charc ')' INTO lv_field.
        set_dynpro( iv_screen =  ' ' iv_field  = lv_field     iv_value  = <fs_dados>-value ).

      ELSEIF <fs_dados>-position > '10'.

        lv_index_charc = <fs_dados>-position - 9.
        lv_index_charc = |{ lv_index_charc ALPHA = IN }|.

        set_dynpro( iv_screen =  'X' iv_field  = 'SAPLQEEM'   iv_value  = '1110' ).
        CLEAR lv_field.
        CONCATENATE 'QAQEE-SUMPLUS(' lv_index_charc ')' INTO lv_field.
        set_dynpro( iv_screen =  ' ' iv_field  = 'BDC_CURSOR' iv_value  = lv_field ).

        CLEAR lv_field.
        CONCATENATE 'QAQEE-SUMPLUS(' lv_index_charc ')' INTO lv_field.
        set_dynpro( iv_screen =  ' ' iv_field  = lv_field     iv_value  = <fs_dados>-value ).

      ENDIF.

    ENDLOOP.



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

  ENDMETHOD.


  METHOD set_dynpro.

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
