FUNCTION /sprolims/fm_collect_check.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IV_COLLECT_ID) TYPE  WARPL
*"  EXPORTING
*"     REFERENCE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------


  DATA: lt_jest_aux TYPE TABLE OF jest,
        lt_jest_ins TYPE TABLE OF jest_upd.

  DATA: lw_jest_aux TYPE jest_upd,
        lw_jest_ins TYPE jest_upd,
        lw_return   TYPE bapiret2.

  SELECT SINGLE *
    FROM afih
    INTO @DATA(lw_afih)
    WHERE warpl = @iv_collect_id.

  SELECT SINGLE *
    FROM aufk
    INTO @DATA(lw_aufk)
    WHERE aufnr = @lw_afih-aufnr AND phas0 = @abap_true AND phas1 = @abap_true.

  IF lw_aufk IS NOT INITIAL.
    lw_return-id      = 'SPROLIMS'.
    lw_return-number  = '001'.
    lw_return-type    = 'E'.
    lw_return-message = 'Existem solicitações em aberto para esta coleta. Eliminar antes da exclusão.'.

    APPEND lw_return TO et_return.
    CLEAR lw_return.
    RETURN.
  ENDIF.

  SELECT * UP TO 1 ROWS "#EC CI_NOORDER
    FROM qmih
    INTO @DATA(lw_qmih)
    WHERE warpl = @iv_collect_id.
  ENDSELECT.

  SELECT SINGLE *
    FROM qmel
    INTO @DATA(lw_qmel)
    WHERE qmnum = @lw_qmih-qmnum.

  SELECT *
    FROM jest
    INTO TABLE @DATA(lt_jest)
    WHERE objnr = @lw_qmel-objnr AND inact = 'NULL'.

  IF lt_jest IS NOT INITIAL.
    lw_return-id      = 'SPROLIMS'.
    lw_return-number  = '001'.
    lw_return-type    = 'E'.
    lw_return-message = 'Existem solicitações em aberto para esta coleta. Eliminar antes da exclusão.'.

    APPEND lw_return TO et_return.
    CLEAR lw_return.
    RETURN.
  ENDIF.



ENDFUNCTION.
