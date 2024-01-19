*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /SPROLIMS/VB_CF2................................*
TABLES: /SPROLIMS/VB_CF2, */SPROLIMS/VB_CF2. "view work areas
CONTROLS: TCTRL_/SPROLIMS/VB_CF2
TYPE TABLEVIEW USING SCREEN '0999'.
DATA: BEGIN OF STATUS_/SPROLIMS/VB_CF2. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_/SPROLIMS/VB_CF2.
* Table for entries selected to show on screen
DATA: BEGIN OF /SPROLIMS/VB_CF2_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VB_CF2.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VB_CF2_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF /SPROLIMS/VB_CF2_TOTAL OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VB_CF2.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VB_CF2_TOTAL.

*.........table declarations:.................................*
TABLES: /SPROLIMS/TB_CF2               .
