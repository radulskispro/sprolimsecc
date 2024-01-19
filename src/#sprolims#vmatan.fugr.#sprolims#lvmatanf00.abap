*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: /SPROLIMS/VMATAN................................*
FORM GET_DATA_/SPROLIMS/VMATAN.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM /SPROLIMS/TMATAN WHERE
(VIM_WHERETAB) .
    CLEAR /SPROLIMS/VMATAN .
/SPROLIMS/VMATAN-MANDT =
/SPROLIMS/TMATAN-MANDT .
/SPROLIMS/VMATAN-WERKS =
/SPROLIMS/TMATAN-WERKS .
/SPROLIMS/VMATAN-CODEGRUPPE =
/SPROLIMS/TMATAN-CODEGRUPPE .
/SPROLIMS/VMATAN-CARAC =
/SPROLIMS/TMATAN-CARAC .
/SPROLIMS/VMATAN-DESCR =
/SPROLIMS/TMATAN-DESCR .
/SPROLIMS/VMATAN-METOD =
/SPROLIMS/TMATAN-METOD .
/SPROLIMS/VMATAN-GEBINDETYP =
/SPROLIMS/TMATAN-GEBINDETYP .
/SPROLIMS/VMATAN-LT_CONF =
/SPROLIMS/TMATAN-LT_CONF .
/SPROLIMS/VMATAN-LT_PREP =
/SPROLIMS/TMATAN-LT_PREP .
/SPROLIMS/VMATAN-LT_INOC =
/SPROLIMS/TMATAN-LT_INOC .
/SPROLIMS/VMATAN-LT_ANALISE_I =
/SPROLIMS/TMATAN-LT_ANALISE_I .
/SPROLIMS/VMATAN-LT_ANALISE_E =
/SPROLIMS/TMATAN-LT_ANALISE_E .
/SPROLIMS/VMATAN-COMB =
/SPROLIMS/TMATAN-COMB .
/SPROLIMS/VMATAN-LT_COMBINADA =
/SPROLIMS/TMATAN-LT_COMBINADA .
/SPROLIMS/VMATAN-LT_INOC_COMB =
/SPROLIMS/TMATAN-LT_INOC_COMB .
<VIM_TOTAL_STRUC> = /SPROLIMS/VMATAN.
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
FORM DB_UPD_/SPROLIMS/VMATAN .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO /SPROLIMS/VMATAN.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_/SPROLIMS/VMATAN-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM /SPROLIMS/TMATAN WHERE
  WERKS = /SPROLIMS/VMATAN-WERKS AND
  CODEGRUPPE = /SPROLIMS/VMATAN-CODEGRUPPE AND
  CARAC = /SPROLIMS/VMATAN-CARAC AND
  DESCR = /SPROLIMS/VMATAN-DESCR AND
  METOD = /SPROLIMS/VMATAN-METOD .
    IF SY-SUBRC = 0.
    DELETE /SPROLIMS/TMATAN .
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
  SELECT SINGLE FOR UPDATE * FROM /SPROLIMS/TMATAN WHERE
  WERKS = /SPROLIMS/VMATAN-WERKS AND
  CODEGRUPPE = /SPROLIMS/VMATAN-CODEGRUPPE AND
  CARAC = /SPROLIMS/VMATAN-CARAC AND
  DESCR = /SPROLIMS/VMATAN-DESCR AND
  METOD = /SPROLIMS/VMATAN-METOD .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR /SPROLIMS/TMATAN.
    ENDIF.
/SPROLIMS/TMATAN-MANDT =
/SPROLIMS/VMATAN-MANDT .
/SPROLIMS/TMATAN-WERKS =
/SPROLIMS/VMATAN-WERKS .
/SPROLIMS/TMATAN-CODEGRUPPE =
/SPROLIMS/VMATAN-CODEGRUPPE .
/SPROLIMS/TMATAN-CARAC =
/SPROLIMS/VMATAN-CARAC .
/SPROLIMS/TMATAN-DESCR =
/SPROLIMS/VMATAN-DESCR .
/SPROLIMS/TMATAN-METOD =
/SPROLIMS/VMATAN-METOD .
/SPROLIMS/TMATAN-GEBINDETYP =
/SPROLIMS/VMATAN-GEBINDETYP .
/SPROLIMS/TMATAN-LT_CONF =
/SPROLIMS/VMATAN-LT_CONF .
/SPROLIMS/TMATAN-LT_PREP =
/SPROLIMS/VMATAN-LT_PREP .
/SPROLIMS/TMATAN-LT_INOC =
/SPROLIMS/VMATAN-LT_INOC .
/SPROLIMS/TMATAN-LT_ANALISE_I =
/SPROLIMS/VMATAN-LT_ANALISE_I .
/SPROLIMS/TMATAN-LT_ANALISE_E =
/SPROLIMS/VMATAN-LT_ANALISE_E .
/SPROLIMS/TMATAN-COMB =
/SPROLIMS/VMATAN-COMB .
/SPROLIMS/TMATAN-LT_COMBINADA =
/SPROLIMS/VMATAN-LT_COMBINADA .
/SPROLIMS/TMATAN-LT_INOC_COMB =
/SPROLIMS/VMATAN-LT_INOC_COMB .
    IF SY-SUBRC = 0.
    UPDATE /SPROLIMS/TMATAN ##WARN_OK.
    ELSE.
    INSERT /SPROLIMS/TMATAN .
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
CLEAR: STATUS_/SPROLIMS/VMATAN-UPD_FLAG,
STATUS_/SPROLIMS/VMATAN-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_/SPROLIMS/VMATAN.
  SELECT SINGLE * FROM /SPROLIMS/TMATAN WHERE
WERKS = /SPROLIMS/VMATAN-WERKS AND
CODEGRUPPE = /SPROLIMS/VMATAN-CODEGRUPPE AND
CARAC = /SPROLIMS/VMATAN-CARAC AND
DESCR = /SPROLIMS/VMATAN-DESCR AND
METOD = /SPROLIMS/VMATAN-METOD .
/SPROLIMS/VMATAN-MANDT =
/SPROLIMS/TMATAN-MANDT .
/SPROLIMS/VMATAN-WERKS =
/SPROLIMS/TMATAN-WERKS .
/SPROLIMS/VMATAN-CODEGRUPPE =
/SPROLIMS/TMATAN-CODEGRUPPE .
/SPROLIMS/VMATAN-CARAC =
/SPROLIMS/TMATAN-CARAC .
/SPROLIMS/VMATAN-DESCR =
/SPROLIMS/TMATAN-DESCR .
/SPROLIMS/VMATAN-METOD =
/SPROLIMS/TMATAN-METOD .
/SPROLIMS/VMATAN-GEBINDETYP =
/SPROLIMS/TMATAN-GEBINDETYP .
/SPROLIMS/VMATAN-LT_CONF =
/SPROLIMS/TMATAN-LT_CONF .
/SPROLIMS/VMATAN-LT_PREP =
/SPROLIMS/TMATAN-LT_PREP .
/SPROLIMS/VMATAN-LT_INOC =
/SPROLIMS/TMATAN-LT_INOC .
/SPROLIMS/VMATAN-LT_ANALISE_I =
/SPROLIMS/TMATAN-LT_ANALISE_I .
/SPROLIMS/VMATAN-LT_ANALISE_E =
/SPROLIMS/TMATAN-LT_ANALISE_E .
/SPROLIMS/VMATAN-COMB =
/SPROLIMS/TMATAN-COMB .
/SPROLIMS/VMATAN-LT_COMBINADA =
/SPROLIMS/TMATAN-LT_COMBINADA .
/SPROLIMS/VMATAN-LT_INOC_COMB =
/SPROLIMS/TMATAN-LT_INOC_COMB .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_/SPROLIMS/VMATAN USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE /SPROLIMS/VMATAN-WERKS TO
/SPROLIMS/TMATAN-WERKS .
MOVE /SPROLIMS/VMATAN-CODEGRUPPE TO
/SPROLIMS/TMATAN-CODEGRUPPE .
MOVE /SPROLIMS/VMATAN-CARAC TO
/SPROLIMS/TMATAN-CARAC .
MOVE /SPROLIMS/VMATAN-DESCR TO
/SPROLIMS/TMATAN-DESCR .
MOVE /SPROLIMS/VMATAN-METOD TO
/SPROLIMS/TMATAN-METOD .
MOVE /SPROLIMS/VMATAN-MANDT TO
/SPROLIMS/TMATAN-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = '/SPROLIMS/TMATAN'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN /SPROLIMS/TMATAN TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING '/SPROLIMS/TMATAN'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*