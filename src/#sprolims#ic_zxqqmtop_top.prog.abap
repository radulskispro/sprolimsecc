*&---------------------------------------------------------------------*
*&  Include  /SPROLIMS/IC_ZXQQMTOP_TOP
*&---------------------------------------------------------------------*
TABLES: qmel,
        qpgt,
        tq42t,
        cskt.

DATA: tx_kurztext_cat TYPE qpgt-kurztext,
      tx_text_tanque  TYPE ktx01,
      tx_text_local   TYPE pltxt.

DATA: v_aktyp         TYPE akttyp.
