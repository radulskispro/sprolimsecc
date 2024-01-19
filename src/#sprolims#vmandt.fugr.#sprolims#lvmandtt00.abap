*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /SPROLIMS/VMANDT................................*
TABLES: /SPROLIMS/VMANDT, */SPROLIMS/VMANDT. "view work areas
CONTROLS: TCTRL_/SPROLIMS/VMANDT
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_/SPROLIMS/VMANDT. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_/SPROLIMS/VMANDT.
* Table for entries selected to show on screen
DATA: BEGIN OF /SPROLIMS/VMANDT_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VMANDT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VMANDT_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF /SPROLIMS/VMANDT_TOTAL OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VMANDT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VMANDT_TOTAL.

*.........table declarations:.................................*
TABLES: /SPROLIMS/TMANDT               .
