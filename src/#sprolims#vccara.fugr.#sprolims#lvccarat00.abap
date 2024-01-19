*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /SPROLIMS/VCCARA................................*
TABLES: /SPROLIMS/VCCARA, */SPROLIMS/VCCARA. "view work areas
CONTROLS: TCTRL_/SPROLIMS/VCCARA
TYPE TABLEVIEW USING SCREEN '9000'.
DATA: BEGIN OF STATUS_/SPROLIMS/VCCARA. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_/SPROLIMS/VCCARA.
* Table for entries selected to show on screen
DATA: BEGIN OF /SPROLIMS/VCCARA_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VCCARA.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VCCARA_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF /SPROLIMS/VCCARA_TOTAL OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VCCARA.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VCCARA_TOTAL.

*.........table declarations:.................................*
TABLES: /SPROLIMS/TCCARA               .
