*&---------------------------------------------------------------------*
*& Report  /SPROLIMS/IMG
*-----------------------------------------------------------------------
* Descrição: Chamada de menu de de IMG configurações produto SPROLIMS
* Autor....: SPR.VIEIRAA
* Data.....: 18/11/2019
*-----------------------------------------------------------------------
REPORT /sprolims/img.

CALL FUNCTION 'STREE_EXTERNAL_DISPLAY'
  EXPORTING
    structure_id = 'EE3264571E021ED885E63764A1EFC010'
    language     = sy-langu.
