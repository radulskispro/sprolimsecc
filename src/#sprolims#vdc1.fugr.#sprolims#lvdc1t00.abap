*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /SPROLIMS/VDC...................................*
TABLES: /SPROLIMS/VDC, */SPROLIMS/VDC. "view work areas
CONTROLS: TCTRL_/SPROLIMS/VDC
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_/SPROLIMS/VDC. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_/SPROLIMS/VDC.
* Table for entries selected to show on screen
DATA: BEGIN OF /SPROLIMS/VDC_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VDC.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VDC_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF /SPROLIMS/VDC_TOTAL OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VDC.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VDC_TOTAL.

*.........table declarations:.................................*
TABLES: /SPROLIMS/TDC                  .
