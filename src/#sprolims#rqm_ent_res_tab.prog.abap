*&---------------------------------------------------------------------*
*& Report ZRQM_ENTRADA_RESULTADO_TAB
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /sprolims/rqm_ent_res_tab.

INCLUDE /SPROLIMS/RQM_ENT_RES_TAB_TOP.
*INCLUDE /SPROLIMS/ZRQM_ENT_RES_TAB_TOP.
*INCLUDE zrqm_entrada_resultado_tab_top.

INCLUDE /SPROLIMS/RQM_ENT_RES_TAB_S01.
*INCLUDE /SPROLIMS/ZRQM_ENT_RES_TAB_S01.
*INCLUDE zrqm_entrada_resultado_tab_s01.

INCLUDE /SPROLIMS/RQM_ENT_RES_TAB_C01.
*INCLUDE /SPROLIMS/ZRQM_ENT_RES_TAB_C01.
*INCLUDE zrqm_entrada_resultado_tab_c01.

INCLUDE /SPROLIMS/RQM_ENT_RES_TAB_F01.
*INCLUDE /SPROLIMS/ZRQM_ENT_RES_TAB_F01.
*INCLUDE zrqm_entrada_resultado_tab_f01.

INCLUDE /SPROLIMS/RQM_ENT_RES_TAB_O01.
*INCLUDE /SPROLIMS/ZRQM_ENT_RES_TAB_O01.
*INCLUDE zrqm_entrada_resultado_tab_o01.

INCLUDE /SPROLIMS/RQM_ENT_RES_TAB_I01.
*INCLUDE /SPROLIMS/ZRQM_ENT_RES_TAB_I01.
*INCLUDE zrqm_entrada_resultado_tab_i01.

START-OF-SELECTION.

  PERFORM:  zf_get_oper_char,
            zf_get_table_structure,     "Create dynamic table structure.
            zf_create_itab_dynamically, "Create dynamic internal table
            zf_get_data.                "Fill the data into dynamic internal table

END-OF-SELECTION.

  PERFORM zf_display_alv_report.

  CALL SCREEN 9000.
