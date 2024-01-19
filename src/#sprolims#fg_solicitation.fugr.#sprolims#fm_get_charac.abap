FUNCTION /sprolims/fm_get_charac.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_BATCH) TYPE  CHARG_D OPTIONAL
*"     VALUE(IV_BAUTL) TYPE  BAUTL
*"     VALUE(IV_WERK) TYPE  /SPROLIMS/DE_WERK
*"     VALUE(IV_DESCR_OTKAT) TYPE  /SPROLIMS/DE_DESCR_OTKAT
*"  EXPORTING
*"     VALUE(EV_CHAR_VALUE) TYPE  ATWRT30
*"----------------------------------------------------------------------
  DATA: lv_objectkey   LIKE  bapi1003_key-object,
        lv_objecttable LIKE  bapi1003_key-objecttable,
        lv_classtype   LIKE  bapi1003_key-classtype.

  DATA: lt_allocvaluesnum  TYPE TABLE OF bapi1003_alloc_values_num,
        lt_allocvalueschar TYPE TABLE OF bapi1003_alloc_values_char,
        lt_allocvaluescurr TYPE TABLE OF bapi1003_alloc_values_curr,
        lt_return          TYPE TABLE OF bapiret2.

  TRANSLATE iv_descr_otkat TO UPPER CASE.

  IF iv_descr_otkat <> 'REPRESENTATIVIDADE'.
    DATA(log) = /sproprod/cl_log=>factory( object = '/SPROLIMS/' subobject = '/SOLICITATION/' id = | GET CHARAC { iv_descr_otkat } |   ).

    SELECT SINGLE otkat
      FROM /sprolims/tccatg
      INTO @DATA(lv_id_cat)
      WHERE descr_otkat = @iv_descr_otkat.
    IF sy-subrc IS NOT INITIAL.
      log->add( msg = | Not found  { iv_descr_otkat } /sprolims/tccatg |  ).
    ENDIF.

    SELECT SINGLE class , carac
      FROM /sprolims/tccara
      INTO @DATA(lw_tccara)
       WHERE otkat = @lv_id_cat
        AND werks = @iv_werk.
    IF sy-subrc IS NOT INITIAL.
      log->add( msg = | Not found  otkat: { lv_id_cat } werks: { iv_werk } /sprolims/tccara |  ).
    ENDIF.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = iv_bautl
      IMPORTING
        output       = iv_bautl
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.

    SELECT SINGLE klart
      FROM klah
      INTO @DATA(lv_klart)
      WHERE class = @lw_tccara-class.
    IF sy-subrc IS NOT INITIAL.
      log->add( msg = | Not found  otkat: { lv_id_cat } werks: { iv_werk } /sprolims/tccara |  ).
    ENDIF.

    IF lv_klart = '023'.

      CONCATENATE iv_bautl iv_batch INTO lv_objectkey.

      lv_objecttable  = 'MCH1'.
      lv_classtype     = lv_klart.

    ELSEIF lv_klart = '001'.

      lv_objectkey    = iv_bautl.

      lv_objecttable  = 'MARA'.
      lv_classtype     = lv_klart.

    ENDIF.

    CALL FUNCTION 'BAPI_OBJCL_GETDETAIL'
      EXPORTING
        objectkey        = lv_objectkey
        objecttable      = lv_objecttable
        classnum         = lw_tccara-class
        classtype        = lv_classtype
        keydate          = sy-datum
        unvaluated_chars = 'X'
        language         = sy-langu
      TABLES
        allocvaluesnum   = lt_allocvaluesnum
        allocvalueschar  = lt_allocvalueschar
        allocvaluescurr  = lt_allocvaluescurr
        return           = lt_return.

    READ TABLE lt_return WITH KEY type  = 'E' TRANSPORTING NO FIELDS.
    IF sy-subrc IS INITIAL.
      log->add( lt_return ).
      RETURN.
    ENDIF.

    READ TABLE lt_allocvalueschar INTO DATA(lw_allocvalueschar) WITH KEY charact = lw_tccara-carac.
    IF sy-subrc = 0.

      ev_char_value = lw_allocvalueschar-value_neutral.

    ENDIF.

    log->add( msg = | Objectkey { lv_objectkey } | msgty = 'I' ).
    log->add( msg = | Objecttable { lv_objecttable } | msgty = 'I' ).
    log->add( msg = | Classtype { lv_classtype } | msgty = 'I' ).
    log->add( msg = lt_return msgty = 'I' ).
    log->add( msg = lt_allocvalueschar  msgty = 'I' ).
    COMMIT WORK. "save log

  ELSE.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = iv_bautl
      IMPORTING
        output       = iv_bautl
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.

    SELECT SINGLE *
      FROM /sprolims/cds_a_representativ
      INTO @DATA(lw_representatividade)
      WHERE charg = @iv_batch AND
            matnr = @iv_bautl AND
            werks = @iv_werk.

    ev_char_value = lw_representatividade-erfmg.

    SHIFT ev_char_value LEFT DELETING LEADING space.

    CONCATENATE ev_char_value lw_representatividade-erfme INTO ev_char_value SEPARATED BY space.

    DATA(log_representatividade) = /sproprod/cl_log=>factory( object = '/SPROLIMS/' subobject = '/SOLICITATION/' id = | GET CHARAC { iv_descr_otkat } |   ).
    log_representatividade->add( msg = | Batch { iv_batch } | msgty = 'I' ).
    log_representatividade->add( msg = | Bautl { iv_bautl } | msgty = 'I' ).
    log_representatividade->add( msg = | Werks { iv_werk } | msgty = 'I' ).
    log_representatividade->add( msg = lw_representatividade msgty = 'I' ).
    COMMIT WORK. " save log
  ENDIF.


ENDFUNCTION.
