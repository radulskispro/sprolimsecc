*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: /SPROLIMS/VB_CF7................................*
FORM GET_DATA_/SPROLIMS/VB_CF7.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM /SPROLIMS/TB_CF7 WHERE
(VIM_WHERETAB) .
    CLEAR /SPROLIMS/VB_CF7 .
/SPROLIMS/VB_CF7-MANDT =
/SPROLIMS/TB_CF7-MANDT .
/SPROLIMS/VB_CF7-WERKS =
/SPROLIMS/TB_CF7-WERKS .
/SPROLIMS/VB_CF7-BWART =
/SPROLIMS/TB_CF7-BWART .
/SPROLIMS/VB_CF7-BWART_REP1 =
/SPROLIMS/TB_CF7-BWART_REP1 .
/SPROLIMS/VB_CF7-BWART_REP2 =
/SPROLIMS/TB_CF7-BWART_REP2 .
<VIM_TOTAL_STRUC> = /SPROLIMS/VB_CF7.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_/SPROLIMS/VB_CF7 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO /SPROLIMS/VB_CF7.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_/SPROLIMS/VB_CF7-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM /SPROLIMS/TB_CF7 WHERE
  WERKS = /SPROLIMS/VB_CF7-WERKS .
    IF SY-SUBRC = 0.
    DELETE /SPROLIMS/TB_CF7 .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM /SPROLIMS/TB_CF7 WHERE
  WERKS = /SPROLIMS/VB_CF7-WERKS .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR /SPROLIMS/TB_CF7.
    ENDIF.
/SPROLIMS/TB_CF7-MANDT =
/SPROLIMS/VB_CF7-MANDT .
/SPROLIMS/TB_CF7-WERKS =
/SPROLIMS/VB_CF7-WERKS .
/SPROLIMS/TB_CF7-BWART =
/SPROLIMS/VB_CF7-BWART .
/SPROLIMS/TB_CF7-BWART_REP1 =
/SPROLIMS/VB_CF7-BWART_REP1 .
/SPROLIMS/TB_CF7-BWART_REP2 =
/SPROLIMS/VB_CF7-BWART_REP2 .
    IF SY-SUBRC = 0.
    UPDATE /SPROLIMS/TB_CF7 ##WARN_OK.
    ELSE.
    INSERT /SPROLIMS/TB_CF7 .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_/SPROLIMS/VB_CF7-UPD_FLAG,
STATUS_/SPROLIMS/VB_CF7-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_/SPROLIMS/VB_CF7.
  SELECT SINGLE * FROM /SPROLIMS/TB_CF7 WHERE
WERKS = /SPROLIMS/VB_CF7-WERKS .
/SPROLIMS/VB_CF7-MANDT =
/SPROLIMS/TB_CF7-MANDT .
/SPROLIMS/VB_CF7-WERKS =
/SPROLIMS/TB_CF7-WERKS .
/SPROLIMS/VB_CF7-BWART =
/SPROLIMS/TB_CF7-BWART .
/SPROLIMS/VB_CF7-BWART_REP1 =
/SPROLIMS/TB_CF7-BWART_REP1 .
/SPROLIMS/VB_CF7-BWART_REP2 =
/SPROLIMS/TB_CF7-BWART_REP2 .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_/SPROLIMS/VB_CF7 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE /SPROLIMS/VB_CF7-WERKS TO
/SPROLIMS/TB_CF7-WERKS .
MOVE /SPROLIMS/VB_CF7-MANDT TO
/SPROLIMS/TB_CF7-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = '/SPROLIMS/TB_CF7'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN /SPROLIMS/TB_CF7 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING '/SPROLIMS/TB_CF7'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
