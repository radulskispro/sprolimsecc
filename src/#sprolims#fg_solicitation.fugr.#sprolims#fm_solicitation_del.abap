FUNCTION /sprolims/fm_solicitation_del.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_SOLICITATION_ID) TYPE  QMNUM
*"  EXPORTING
*"     VALUE(EV_ERROR) TYPE  FLAG
*"     VALUE(EW_RETURN) TYPE  BAPIRET2
*"     VALUE(EV_NUM_AMOSTRA) TYPE  /SPROCSEM/DE_NUM_AMOSTRA
*"----------------------------------------------------------------------

  DATA: ol_eliminate_sol TYPE REF TO /sprolims/cl_elim_sol.


  TRY.
      CREATE OBJECT ol_eliminate_sol
        EXPORTING
          iv_solicitation = iv_solicitation_id.

      ol_eliminate_sol->eliminate_solicitation( ).

      ev_num_amostra = ol_eliminate_sol->get_num_amostra( ).


    CATCH /sprolims/cx_elim_sol INTO DATA(lo_exception).

      ev_error = 'X'.

      ew_return-type = 'E'.
      ew_return-message = lo_exception->get_text( ).

  ENDTRY.


ENDFUNCTION.
