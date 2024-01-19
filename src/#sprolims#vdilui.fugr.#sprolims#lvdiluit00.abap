*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /SPROLIMS/VDILUI................................*
TABLES: /SPROLIMS/VDILUI, */SPROLIMS/VDILUI. "view work areas
CONTROLS: TCTRL_/SPROLIMS/VDILUI
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_/SPROLIMS/VDILUI. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_/SPROLIMS/VDILUI.
* Table for entries selected to show on screen
DATA: BEGIN OF /SPROLIMS/VDILUI_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VDILUI.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VDILUI_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF /SPROLIMS/VDILUI_TOTAL OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VDILUI.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VDILUI_TOTAL.

*.........table declarations:.................................*
TABLES: /SPROLIMS/DILUIC               .
