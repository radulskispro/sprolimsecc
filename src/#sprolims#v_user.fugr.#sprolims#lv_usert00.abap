*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /SPROLIMS/V_USER................................*
TABLES: /SPROLIMS/V_USER, */SPROLIMS/V_USER. "view work areas
CONTROLS: TCTRL_/SPROLIMS/V_USER
TYPE TABLEVIEW USING SCREEN '0999'.
DATA: BEGIN OF STATUS_/SPROLIMS/V_USER. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_/SPROLIMS/V_USER.
* Table for entries selected to show on screen
DATA: BEGIN OF /SPROLIMS/V_USER_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/V_USER.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/V_USER_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF /SPROLIMS/V_USER_TOTAL OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/V_USER.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/V_USER_TOTAL.

*.........table declarations:.................................*
TABLES: /SPROLIMS/T_USER               .
