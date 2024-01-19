*&---------------------------------------------------------------------*
*& Include /SPROLIMS/IC_IPRM0003_F01
*&---------------------------------------------------------------------*
FORM f_move_data_to_screen  USING   pv_kostl
                                    pv_aber
                                    pv_lib
                                    pv_repet
                                    pv_plan
                                    pv_werks
                                    pv_lab
                                    pv_qlosmenge
                                    pv_qlosmengeh
                                    pv_gebindetyp
                                    pv_otgrp
                                    pv_oteil
                                    pv_req_legais
                                    pv_analise
                                    pv_codeanalise
                                    pv_qmgrp
                                    pv_qmcod
                                    pv_metodologia
                                    pv_codemetodologia.

  ASSIGN ('(SAPLIWP3)IMPOS-/SPROLIMS/KOSTL') TO FIELD-SYMBOL(<lf_kostl>).
  IF ( <lf_kostl> IS ASSIGNED ).
    <lf_kostl> = pv_kostl.
  ENDIF.

  ASSIGN ('(SAPLIWP3)IMPOS-/SPROLIMS/ABER') TO FIELD-SYMBOL(<lf_aber>).
  IF ( <lf_aber> IS ASSIGNED ).
    <lf_aber> = pv_aber.
  ENDIF.

  ASSIGN ('(SAPLIWP3)IMPOS-/SPROLIMS/LIB') TO FIELD-SYMBOL(<lf_lib>).
  IF ( <lf_lib> IS ASSIGNED ).
    <lf_lib> = pv_lib.
  ENDIF.

  ASSIGN ('(SAPLIWP3)IMPOS-/SPROLIMS/REPET') TO FIELD-SYMBOL(<lf_repet>).
  IF ( <lf_repet> IS ASSIGNED ).
    <lf_repet> = pv_repet.
  ENDIF.

  ASSIGN ('(SAPLIWP3)IMPOS-/SPROLIMS/PLAN') TO FIELD-SYMBOL(<lf_plan>).
  IF ( <lf_plan> IS ASSIGNED ).
    <lf_plan> = pv_plan.
  ENDIF.

  ASSIGN ('(SAPLIWP3)IMPOS-/SPROLIMS/WERKS') TO FIELD-SYMBOL(<lf_werks>).
  IF ( <lf_werks> IS ASSIGNED ).
    <lf_werks> = pv_werks.
  ENDIF.

  ASSIGN ('(SAPLIWP3)IMPOS-/SPROLIMS/LAB') TO FIELD-SYMBOL(<lf_lab>).
  IF ( <lf_lab> IS ASSIGNED ).
    <lf_lab> = pv_lab.
  ENDIF.

  ASSIGN ('(SAPLIWP3)IMPOS-/SPROLIMS/QLOSMENGE') TO FIELD-SYMBOL(<lf_qlosmenge>).
  IF ( <lf_qlosmenge> IS ASSIGNED ).
    <lf_qlosmenge> = pv_qlosmenge.
  ENDIF.

  ASSIGN ('(SAPLIWP3)IMPOS-/SPROLIMS/QLOSMENGEH') TO FIELD-SYMBOL(<lf_qlosmengeh>).
  IF ( <lf_qlosmengeh> IS ASSIGNED ).
    <lf_qlosmengeh> = pv_qlosmengeh.
  ENDIF.

  ASSIGN ('(SAPLIWP3)IMPOS-/SPROLIMS/GEBINDETYP') TO FIELD-SYMBOL(<lf_gebindetyp>).
  IF ( <lf_gebindetyp> IS ASSIGNED ).
    <lf_gebindetyp> = pv_gebindetyp.
  ENDIF.

  ASSIGN ('(SAPLIWP3)IMPOS-/SPROLIMS/OTGRP') TO FIELD-SYMBOL(<lf_otgrp>).
  IF ( <lf_otgrp> IS ASSIGNED ).
    <lf_otgrp> = pv_otgrp.
  ENDIF.

  ASSIGN ('(SAPLIWP3)IMPOS-/SPROLIMS/OTEIL') TO FIELD-SYMBOL(<lf_oteil>).
  IF ( <lf_oteil> IS ASSIGNED ).
    <lf_oteil> = pv_oteil.
  ENDIF.

  ASSIGN ('(SAPLIWP3)IMPOS-/SPROLIMS/REQ_LEGAIS') TO FIELD-SYMBOL(<lf_req_legais>).
  IF ( <lf_req_legais> IS ASSIGNED ).
    <lf_req_legais> = pv_req_legais.
  ENDIF.

  ASSIGN ('(SAPLIWP3)IMPOS-/SPROLIMS/ANALISE') TO FIELD-SYMBOL(<lf_analise>).
  IF ( <lf_analise> IS ASSIGNED ).
    <lf_analise> = pv_analise.
  ENDIF.

  ASSIGN ('(SAPLIWP3)IMPOS-/SPROLIMS/CODEANALISE') TO FIELD-SYMBOL(<lf_codeanalise>).
  IF ( <lf_codeanalise> IS ASSIGNED ).
    <lf_codeanalise> = pv_codeanalise.
  ENDIF.

  ASSIGN ('(SAPLIWP3)IMPOS-/SPROLIMS/QMGRP') TO FIELD-SYMBOL(<lf_qmgrp>).
  IF ( <lf_qmgrp> IS ASSIGNED ).
    <lf_qmgrp> = pv_qmgrp.
  ENDIF.

  ASSIGN ('(SAPLIWP3)IMPOS-/SPROLIMS/QMCOD') TO FIELD-SYMBOL(<lf_qmcod>).
  IF ( <lf_qmcod> IS ASSIGNED ).
    <lf_qmcod> = pv_qmcod.
  ENDIF.

  ASSIGN ('(SAPLIWP3)IMPOS-/SPROLIMS/METODOLOGIA') TO FIELD-SYMBOL(<lf_metodologia>).
  IF ( <lf_metodologia> IS ASSIGNED ).
    <lf_metodologia> = pv_metodologia.
  ENDIF.

  ASSIGN ('(SAPLIWP3)IMPOS-/SPROLIMS/CODEMETODOLOGIA') TO FIELD-SYMBOL(<lf_codemetodologia>).
  IF ( <lf_codemetodologia> IS ASSIGNED ).
    <lf_codemetodologia> = pv_codemetodologia.
  ENDIF.

ENDFORM.

FORM f_move_data_from_screen   CHANGING pv_kostl
                                        pv_aber
                                        pv_lib
                                        pv_repet
                                        pv_plan
                                        pv_werks
                                        pv_lab
                                        pv_qlosmenge
                                        pv_qlosmengeh
                                        pv_gebindetyp
                                        pv_otgrp
                                        pv_oteil
                                        pv_req_legais
                                        pv_analise
                                        pv_codeanalise
                                        pv_qmgrp
                                        pv_qmcod
                                        pv_metodologia
                                        pv_codemetodologia.

  FIELD-SYMBOLS:
    <fs_rmipm> TYPE rmipm,
    <fs_aux>   TYPE any.

  ASSIGN ('(SAPLIWP3)RMIPM') TO <fs_aux>.
  IF ( <fs_aux> IS ASSIGNED ).
    ASSIGN <fs_aux> TO <fs_rmipm> CASTING.
    IF ( <fs_rmipm> IS ASSIGNED ).

      pv_kostl            = <fs_rmipm>-/sprolims/kostl .
      pv_aber             = <fs_rmipm>-/sprolims/aber .
      pv_lib              = <fs_rmipm>-/sprolims/lib .
      pv_repet            = <fs_rmipm>-/sprolims/repet .
      pv_plan             = <fs_rmipm>-/sprolims/plan .
      pv_werks            = <fs_rmipm>-/sprolims/werks .
      pv_lab              = <fs_rmipm>-/sprolims/lab .
      pv_qlosmenge        = <fs_rmipm>-/sprolims/qlosmenge .
      pv_qlosmengeh       = <fs_rmipm>-/sprolims/qlosmengeh .
      pv_gebindetyp       = <fs_rmipm>-/sprolims/gebindetyp .
      pv_otgrp            = <fs_rmipm>-/sprolims/otgrp .
      pv_oteil            = <fs_rmipm>-/sprolims/oteil .
      pv_req_legais       = <fs_rmipm>-/sprolims/req_legais .
      pv_analise          = <fs_rmipm>-/sprolims/analise .
      pv_codeanalise      = <fs_rmipm>-/sprolims/codeanalise .
      pv_qmgrp            = <fs_rmipm>-/sprolims/qmgrp .
      pv_qmcod            = <fs_rmipm>-/sprolims/qmcod .
      pv_metodologia      = <fs_rmipm>-/sprolims/metodologia .
      pv_codemetodologia  = <fs_rmipm>-/sprolims/codemetodologia .

    ENDIF.
  ENDIF.

*  IF ( pv_rec_hours IS NOT INITIAL ).
*    CLEAR pv_n_rec_hours.
*  ENDIF.

ENDFORM.
