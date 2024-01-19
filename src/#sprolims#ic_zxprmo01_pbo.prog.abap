*&---------------------------------------------------------------------*
*& Include /SPROLIMS/IC_ZXPRMO01_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  PERFORM f_move_data_from_screen
      CHANGING
          /sprolims/mpos_fields-/sprolims/kostl
          /sprolims/mpos_fields-/sprolims/aber
          /sprolims/mpos_fields-/sprolims/lib
          /sprolims/mpos_fields-/sprolims/repet
          /sprolims/mpos_fields-/sprolims/plan
          /sprolims/mpos_fields-/sprolims/werks
          /sprolims/mpos_fields-/sprolims/lab
          /sprolims/mpos_fields-/sprolims/qlosmenge
          /sprolims/mpos_fields-/sprolims/qlosmengeh
          /sprolims/mpos_fields-/sprolims/gebindetyp
          /sprolims/mpos_fields-/sprolims/otgrp
          /sprolims/mpos_fields-/sprolims/oteil
          /sprolims/mpos_fields-/sprolims/req_legais
          /sprolims/mpos_fields-/sprolims/analise
          /sprolims/mpos_fields-/sprolims/codeanalise
          /sprolims/mpos_fields-/sprolims/qmgrp
          /sprolims/mpos_fields-/sprolims/qmcod
          /sprolims/mpos_fields-/sprolims/metodologia
          /sprolims/mpos_fields-/sprolims/codemetodologia.

ENDMODULE.
