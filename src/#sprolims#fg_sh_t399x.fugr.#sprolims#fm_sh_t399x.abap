FUNCTION /sprolims/fm_sh_t399x.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  TABLES
*"      SHLP_TAB TYPE  SHLP_DESCR_TAB_T
*"      RECORD_TAB STRUCTURE  SEAHLPRES
*"  CHANGING
*"     REFERENCE(SHLP) TYPE  SHLP_DESCR_T
*"     REFERENCE(CALLCONTROL) LIKE  DDSHF4CTRL STRUCTURE  DDSHF4CTRL
*"----------------------------------------------------------------------

  TYPES:  BEGIN OF ly_t399x,
            mandt    type mandt,
            werks    TYPE t399x-werks,
            auart    TYPE t399x-werks,
            pruefart TYPE t399x-pruefart,
          END OF ly_t399x.

  DATA: lw_t399x TYPE t399x.

  FIELD-SYMBOLS: <fs_t399x> TYPE any.

  LOOP AT record_tab ASSIGNING <fs_t399x>.

    CLEAR lw_t399x.
    lw_t399x = <fs_t399x>.

    IF lw_t399x-pruefart IS INITIAL.
      DELETE record_tab INDEX sy-tabix.
    ENDIF.

  ENDLOOP.

ENDFUNCTION.
