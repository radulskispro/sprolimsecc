*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /SPROLIMS/VB_CAT................................*
TABLES: /SPROLIMS/VB_CAT, */SPROLIMS/VB_CAT. "view work areas
CONTROLS: TCTRL_/SPROLIMS/VB_CAT
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_/SPROLIMS/VB_CAT. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_/SPROLIMS/VB_CAT.
* Table for entries selected to show on screen
DATA: BEGIN OF /SPROLIMS/VB_CAT_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VB_CAT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VB_CAT_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF /SPROLIMS/VB_CAT_TOTAL OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VB_CAT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VB_CAT_TOTAL.

*.........table declarations:.................................*
TABLES: /SPROLIMS/TB_CAT               .
