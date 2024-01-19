*&---------------------------------------------------------------------*
*& Include          /SPROLIMS/IC_ZXWOCU24_IW34
*&---------------------------------------------------------------------*


*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(CAUFVD_IMP) LIKE  CAUFVD STRUCTURE  CAUFVD
*"  TABLES
*"      PMDFU_TAB STRUCTURE  PMDFU OPTIONAL
*"      RIWOL_TAB STRUCTURE  RIWOL OPTIONAL
*"      COMP_TAB STRUCTURE  RESBDGET OPTIONAL
*"      OPR_TAB STRUCTURE  AFVGDGET OPTIONAL
*"  CHANGING
*"     REFERENCE(APROF) LIKE  TKB1A-APROF OPTIONAL
*"  EXCEPTIONS
*"      DO_NOT_BUILD_SETTLEMENTRULE
*"----------------------------------------------------------------------


DATA:  lw_pmdfu TYPE pmdfu.

FIELD-SYMBOLS: <lf_viqmel> TYPE viqmel.

SELECT SINGLE *
  FROM /sprolims/tb_cf6
  INTO @DATA(lw_cf6)
  WHERE werks = @caufvd_imp-werks AND
        auart = @caufvd_imp-auart.

IF sy-subrc IS INITIAL.

  ASSIGN ('(SAPLIQS0)VIQMEL') TO <lf_viqmel>.

  IF <lf_viqmel> IS ASSIGNED.
    TRY .
        CLEAR lw_pmdfu.

        lw_pmdfu-fdind = <lf_viqmel>-prod_kostl.
        lw_pmdfu-prozs = 100.
        lw_pmdfu-konty = lw_cf6-konty.
        lw_pmdfu-perbz = lw_cf6-perbz.

        APPEND lw_pmdfu TO pmdfu_tab.

      CATCH cx_sy_itab_line_not_found.
    ENDTRY.
  ENDIF.
ENDIF.
