*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /SPROLIMS/VCCATG................................*
TABLES: /SPROLIMS/VCCATG, */SPROLIMS/VCCATG. "view work areas
CONTROLS: TCTRL_/SPROLIMS/VCCATG
TYPE TABLEVIEW USING SCREEN '9000'.
DATA: BEGIN OF STATUS_/SPROLIMS/VCCATG. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_/SPROLIMS/VCCATG.
* Table for entries selected to show on screen
DATA: BEGIN OF /SPROLIMS/VCCATG_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VCCATG.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VCCATG_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF /SPROLIMS/VCCATG_TOTAL OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VCCATG.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VCCATG_TOTAL.

*.........table declarations:.................................*
TABLES: /SPROLIMS/TCCATG               .
