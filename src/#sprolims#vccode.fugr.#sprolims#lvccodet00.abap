*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /SPROLIMS/VCCODE................................*
TABLES: /SPROLIMS/VCCODE, */SPROLIMS/VCCODE. "view work areas
CONTROLS: TCTRL_/SPROLIMS/VCCODE
TYPE TABLEVIEW USING SCREEN '9000'.
DATA: BEGIN OF STATUS_/SPROLIMS/VCCODE. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_/SPROLIMS/VCCODE.
* Table for entries selected to show on screen
DATA: BEGIN OF /SPROLIMS/VCCODE_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VCCODE.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VCCODE_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF /SPROLIMS/VCCODE_TOTAL OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VCCODE.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VCCODE_TOTAL.

*.........table declarations:.................................*
TABLES: /SPROLIMS/TCCODE               .
