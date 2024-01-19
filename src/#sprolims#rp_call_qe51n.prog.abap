*&---------------------------------------------------------------------*
*& Report /SPROLIMS/RP_CALL_QE51N
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /sprolims/rp_call_qe51n.

DATA: BEGIN OF t_bdc OCCURS 0.
        INCLUDE STRUCTURE bdcdata.
      DATA: END OF t_bdc.

DATA: BEGIN OF tl_msg_bdc OCCURS 0.
        INCLUDE STRUCTURE bdcmsgcoll.
      DATA: END OF tl_msg_bdc.

DATA: wl_options_bdc TYPE ctu_params.

PARAMETERS: p_pruef TYPE qplos.

IF p_pruef IS NOT INITIAL.
  SET PARAMETER ID 'QLS' FIELD p_pruef.
  SET PARAMETER ID 'QLS_QE51N' FIELD p_pruef.
ENDIF.

wl_options_bdc-dismode  = 'E'.
wl_options_bdc-updmode  = 'L'.
wl_options_bdc-racommit = 'X'.

PERFORM f_dynpro  USING:
          'X'          'SAPLQEES'             '0500',
          ' '          'BDC_OKCODE'           '=CRET'.

CALL TRANSACTION 'QE51N'  WITH AUTHORITY-CHECK
                          USING t_bdc
                          OPTIONS FROM wl_options_bdc
                          MESSAGES INTO tl_msg_bdc.


*&---------------------------------------------------------------------*
*&      Form  F_DYNPRO
*&---------------------------------------------------------------------*
FORM f_dynpro  USING    p_screen
                        p_field
                        p_value1.

  IF  p_screen IS NOT INITIAL.
    t_bdc-dynbegin = 'X'.
    t_bdc-program  = p_field.
    t_bdc-dynpro   = p_value1.
  ELSE.
    t_bdc-fnam = p_field.
    t_bdc-fval = p_value1.
  ENDIF.

  APPEND t_bdc.
  CLEAR t_bdc.

ENDFORM.
