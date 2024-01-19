*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /SPROLIMS/VB_CF8................................*
TABLES: /SPROLIMS/VB_CF8, */SPROLIMS/VB_CF8. "view work areas
CONTROLS: TCTRL_/SPROLIMS/VB_CF8
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_/SPROLIMS/VB_CF8. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_/SPROLIMS/VB_CF8.
* Table for entries selected to show on screen
DATA: BEGIN OF /SPROLIMS/VB_CF8_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VB_CF8.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VB_CF8_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF /SPROLIMS/VB_CF8_TOTAL OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VB_CF8.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VB_CF8_TOTAL.

*.........table declarations:.................................*
TABLES: /SPROLIMS/TB_CF8               .
