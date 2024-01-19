*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /SPROLIMS/VREPFO................................*
TABLES: /SPROLIMS/VREPFO, */SPROLIMS/VREPFO. "view work areas
CONTROLS: TCTRL_/SPROLIMS/VREPFO
TYPE TABLEVIEW USING SCREEN '0999'.
DATA: BEGIN OF STATUS_/SPROLIMS/VREPFO. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_/SPROLIMS/VREPFO.
* Table for entries selected to show on screen
DATA: BEGIN OF /SPROLIMS/VREPFO_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VREPFO.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VREPFO_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF /SPROLIMS/VREPFO_TOTAL OCCURS 0010.
INCLUDE STRUCTURE /SPROLIMS/VREPFO.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /SPROLIMS/VREPFO_TOTAL.

*.........table declarations:.................................*
TABLES: /SPROLIMS/TREPFO               .
