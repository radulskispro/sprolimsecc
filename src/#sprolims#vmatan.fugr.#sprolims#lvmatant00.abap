*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /SPROLIMS/VMATAN................................*
TABLES: /SPROLIMS/VMATAN, */SPROLIMS/VMATAN. "view work areas
CONTROLS: TCTRL_/SPROLIMS/VMATAN
TYPE TABLEVIEW USING SCREEN '0999'.
DATA: BEGIN OF STATUS_/SPROLIMS/VMATAN. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_/SPROLIMS/VMATAN.
* Table for entries selected to show on screen
DATA: BEGIN OF /SPROLIMS/VMATAN_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VMATAN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VMATAN_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF /SPROLIMS/VMATAN_TOTAL OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VMATAN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VMATAN_TOTAL.

*.........table declarations:.................................*
TABLES: /SPROLIMS/TMATAN               .
