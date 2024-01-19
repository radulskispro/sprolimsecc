*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /SPROLIMS/VCCODP................................*
TABLES: /SPROLIMS/VCCODP, */SPROLIMS/VCCODP. "view work areas
CONTROLS: TCTRL_/SPROLIMS/VCCODP
TYPE TABLEVIEW USING SCREEN '9000'.
DATA: BEGIN OF STATUS_/SPROLIMS/VCCODP. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_/SPROLIMS/VCCODP.
* Table for entries selected to show on screen
DATA: BEGIN OF /SPROLIMS/VCCODP_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VCCODP.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VCCODP_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF /SPROLIMS/VCCODP_TOTAL OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VCCODP.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VCCODP_TOTAL.

*.........table declarations:.................................*
TABLES: /SPROLIMS/TCCODE               .
TABLES: /SPROLIMS/TCCODP               .
