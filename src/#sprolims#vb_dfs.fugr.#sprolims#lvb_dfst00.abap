*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /SPROLIMS/VB_DFS................................*
TABLES: /SPROLIMS/VB_DFS, */SPROLIMS/VB_DFS. "view work areas
CONTROLS: TCTRL_/SPROLIMS/VB_DFS
TYPE TABLEVIEW USING SCREEN '0999'.
DATA: BEGIN OF STATUS_/SPROLIMS/VB_DFS. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_/SPROLIMS/VB_DFS.
* Table for entries selected to show on screen
DATA: BEGIN OF /SPROLIMS/VB_DFS_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VB_DFS.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VB_DFS_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF /SPROLIMS/VB_DFS_TOTAL OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VB_DFS.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VB_DFS_TOTAL.

*.........table declarations:.................................*
TABLES: /SPROLIMS/TB_DFS               .
