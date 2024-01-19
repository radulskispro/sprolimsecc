*&---------------------------------------------------------------------*
*& Include /SPROLIMS/IC_ZXWO2U03_IW31
*&---------------------------------------------------------------------*

TABLES: rc27x,
        rc271,
        rc27i,
        tca11.

DATA:
  BEGIN OF resb_bt OCCURS 0.
    INCLUDE STRUCTURE resbb.
  DATA:
    indold     LIKE sy-tabix,
    no_req_upd LIKE sy-datar,
  END OF resb_bt,

  BEGIN OF ctr_buf OCCURS 0.
    INCLUDE STRUCTURE rc27i.
    DATA:  object LIKE rclst-object,
    aktyp  LIKE rc27s-aktyp,
    posnr  LIKE resb-posnr,
    matnr  LIKE resb-matnr,
    matxt  LIKE resbd-matxt,
    rspos  LIKE resbd-rspos,
  END OF ctr_buf,

  BEGIN OF itab OCCURS 1000.
    INCLUDE STRUCTURE sfc_itab.
  DATA: END OF itab.

TYPES:
  BEGIN OF ty_afvg.
    INCLUDE STRUCTURE afvgb.
    TYPES: indold LIKE sy-tabix,
  END OF ty_afvg,

  BEGIN OF ty_qmsm.
    INCLUDE STRUCTURE qmsm.
    TYPES: metod TYPE /sprolims/tmatan-metod,
  END OF ty_qmsm,

  BEGIN OF ty_listas,
    lista TYPE /sprolims/tmatan-lt_conf,
    seq   TYPE i,
  END OF ty_listas.

DATA: lr_carac TYPE RANGE OF /sprolims/tmatan-carac.

DATA: lt_afvg            TYPE TABLE OF ty_afvg,
      lt_itab            TYPE TABLE OF sfc_itab,
      lt_qmsm            TYPE TABLE OF ty_qmsm,
      lt_qmsm_aux        TYPE TABLE OF ty_qmsm,
      lt_plko            TYPE TABLE OF plko,
      lt_plpo            TYPE TABLE OF plpo,
      lt_plmz            TYPE TABLE OF plmz,
      lt_mch1            TYPE TABLE OF mch1,
      lt_mchb            TYPE TABLE OF mchb,
      lt_class           TYPE TABLE OF sclass,
      lt_objectdata      TYPE TABLE OF clobjdat,
      lt_tmatan          TYPE TABLE OF /sprolims/tmatan,
      lt_tmatan_aux      TYPE TABLE OF /sprolims/tmatan,
      lt_listas          TYPE TABLE OF ty_listas,
      lt_return          TYPE TABLE OF bapiret2,
      lt_lst_ctr         TYPE TABLE OF rclsc,
      lt_lst             TYPE TABLE OF rclst,
      lt_allocvaluesnum  TYPE TABLE OF bapi1003_alloc_values_num,
      lt_allocvalueschar TYPE TABLE OF bapi1003_alloc_values_char,
      lt_allocvaluescurr TYPE TABLE OF bapi1003_alloc_values_curr,
      lt_bapireturn      TYPE TABLE OF bapiret2,
      lt_esterilizacao   TYPE TABLE OF /sprolims/tb_cf5.

DATA: lw_tca11  TYPE tca11,
      lw_rc27i  TYPE rc27i,
      lw_params TYPE hds_str_rng_fieldname,
      lw_qmel   TYPE qmel,
      lw_qmih   TYPE qmih,
      lw_listas TYPE ty_listas,
      lw_resb   LIKE LINE OF resb_bt,
      lw_itab   LIKE LINE OF itab,
      lw_carac  LIKE LINE OF lr_carac.

DATA: lv_entries   TYPE sy-tabix,
      lv_lstnr     TYPE rclst-lstnr,
      lv_dummy     TYPE sy-subrc,
      lv_objkey    TYPE bapi1003_key-object,
      lv_objectkey LIKE  bapi1003_key-object,
      lv_classnum  TYPE bapi1003_key-classnum,
      lv_classtype LIKE  bapi1003_key-classtype,
      lv_caract    TYPE bapi1003_alloc_values_char-charact,
      lv_carac_crp TYPE /sprolims/tmatan-descr,
      lv_batch     TYPE bapibatchkey-batch,
      lv_class     TYPE /sprolims/tccara-class.

DATA: lr_param TYPE hds_tab_rng_fieldname,
      lr_auart TYPE rseloption,
      lr_lista TYPE rseloption.


FIELD-SYMBOLS: <fs_afvg_bt>  LIKE lt_afvg,
               <fs_affl_bt>  TYPE ANY TABLE,
               <fs_resb>     TYPE ANY TABLE,
               <fs_ctr_buf>  TYPE ANY TABLE,
               <fs_itab>     TYPE ANY TABLE,
               <fs_plmz>     LIKE lt_plmz,
               <fs_no_popup> TYPE char01,
               <fs_lst>      LIKE lt_lst,
               <fs_lst_ctr>  LIKE lt_lst_ctr.

DATA(lw_caufvd) = header_imp.

IF sy-tcode = 'IW31' OR sy-tcode = 'IW34'.

  SELECT COUNT( * )
    FROM /sprolims/tb_cf1
    WHERE werks = lw_caufvd-werks AND
          auart = lw_caufvd-auart.

  CHECK sy-subrc = 0.

  ASSIGN ('(SAPLCOBO)AFVG_BT[]') TO <fs_afvg_bt>.
  ASSIGN ('(SAPLCOBS)AFFL_BT[]') TO <fs_affl_bt>.

  IF <fs_afvg_bt> IS ASSIGNED
    AND <fs_affl_bt> IS ASSIGNED.

    IF lines( <fs_afvg_bt> ) = 1.

      ASSIGN ('(SAPLCOSD)GV_POPUP_NOT_REQ') TO <fs_no_popup>.
      IF <fs_no_popup> IS NOT ASSIGNED.

        CALL FUNCTION 'CO_SD_TRANSFER_TL_COMP_PM'
          EXPORTING
            i_caufvd = lw_caufvd.

        ASSIGN ('(SAPLCOSD)GV_POPUP_NOT_REQ') TO <fs_no_popup>.

      ENDIF.

      IF <fs_no_popup> IS ASSIGNED.
        <fs_no_popup> = abap_true.
      ENDIF.

      SELECT *
        FROM qmsm
        INTO TABLE lt_qmsm
        WHERE qmnum = lw_caufvd-qmnum.

      SELECT *
        FROM qmsm
        INTO TABLE lt_qmsm
        WHERE qmnum = lw_caufvd-qmnum.

      SELECT SINGLE *
        FROM qmel
        INTO lw_qmel
        WHERE qmnum = lw_caufvd-qmnum.

      SELECT SINGLE *
        FROM qmih
        INTO lw_qmih
        WHERE qmnum = lw_caufvd-qmnum.

      LOOP AT lt_qmsm ASSIGNING FIELD-SYMBOL(<fs_qmsm>).
        <fs_qmsm>-metod =  <fs_qmsm>-mngrp && <fs_qmsm>-mncod.
      ENDLOOP.

      CONCATENATE lw_qmel-qmgrp lw_qmel-qmcod INTO DATA(lv_codegruppe).

      SELECT SINGLE class
        FROM /sprolims/tccara
        INTO lv_class
        WHERE otkat = '1' AND
              werks = lw_caufvd-werks.

      IF sy-subrc IS INITIAL.

        IF  lw_qmih-bautl IS NOT INITIAL AND
            lw_qmel-prod_charg  IS NOT INITIAL.

          CONCATENATE lw_qmih-bautl lw_qmel-prod_charg INTO lv_objectkey.

          lv_classnum = lv_class.

          CALL FUNCTION 'BAPI_OBJCL_GETDETAIL' "#EC CI_USAGE_OK[2438131]
            EXPORTING
              objectkey        = lv_objectkey
              objecttable      = 'MCH1'
              classnum         = lv_classnum
              classtype        = '023'
              unvaluated_chars = 'X'
            TABLES
              allocvaluesnum   = lt_allocvaluesnum
              allocvalueschar  = lt_allocvalueschar
              allocvaluescurr  = lt_allocvaluescurr
              return           = lt_return.

          IF lt_allocvalueschar IS NOT INITIAL.

            LOOP AT lt_allocvalueschar INTO DATA(lw_allocvalueschar).

              lw_carac-sign = 'I'.
              lw_carac-option = 'EQ'.
              lw_carac-low = lw_allocvalueschar-value_char.
              APPEND lw_carac TO lr_carac.

            ENDLOOP.

            SELECT *
              FROM /sprolims/tmatan
              INTO TABLE lt_tmatan
               FOR ALL ENTRIES IN lt_qmsm
             WHERE codegruppe = lv_codegruppe
               AND carac      IN lr_carac
               AND werks      = lw_caufvd-werks
               AND metod      = lt_qmsm-metod
               AND gebindetyp = lw_qmel-gebindetyp.

            lt_tmatan_aux = lt_tmatan.
            DELETE lt_tmatan_aux WHERE comb IS INITIAL.

            IF lt_tmatan_aux IS NOT INITIAL.

              SELECT *
                FROM qmsm
                INTO TABLE lt_qmsm_aux
                FOR ALL ENTRIES IN lt_tmatan_aux
               WHERE qmnum = lw_caufvd-qmnum
                 AND mngrp = lt_tmatan_aux-comb(8)
                 AND mncod = lt_tmatan_aux-comb+8(4).

            ENDIF.

            LOOP AT lt_tmatan ASSIGNING FIELD-SYMBOL(<fs_tmatan>).

              IF <fs_tmatan>-comb IS NOT INITIAL.

                READ TABLE lt_qmsm_aux INTO DATA(lw_qmsm_aux) WITH KEY mngrp = <fs_tmatan>-comb(8)
                                                                       mncod = <fs_tmatan>-comb+8(4).
                IF sy-subrc = 0 AND
                  <fs_tmatan>-lt_combinada IS NOT INITIAL AND
                  <fs_tmatan>-lt_inoc_comb IS NOT INITIAL.

                  <fs_tmatan>-lt_prep = <fs_tmatan>-lt_combinada.
                  <fs_tmatan>-lt_inoc = <fs_tmatan>-lt_inoc_comb.

                ENDIF.
              ENDIF.

              DO 13 TIMES.

                IF sy-index > 7 AND "Só pega as colunas com lista de tarefa
                   sy-index <> 13 . "Não deve pegar a coluna COMB
                  lw_listas-seq   = lw_listas-seq + 1.
                  ASSIGN COMPONENT sy-index OF STRUCTURE <fs_tmatan> TO FIELD-SYMBOL(<fs_field>).
                  READ TABLE lt_listas WITH KEY lista = <fs_field> TRANSPORTING NO FIELDS.
                  IF sy-subrc <> 0.
                    lw_listas-lista = <fs_field>.
                    APPEND lw_listas TO lt_listas.
                  ENDIF.
                ENDIF.

              ENDDO.

              CLEAR lw_listas.

            ENDLOOP.
          ENDIF.
        ENDIF.

        SORT lt_listas BY seq.
        DATA(lv_len) = lines( lt_listas ).

        SELECT *
          FROM /sprolims/tb_cf5
          INTO TABLE lt_esterilizacao
          WHERE bukrs = header_imp-bukrs AND
                werks = header_imp-werks AND
                auart = header_imp-auart.

        IF lt_esterilizacao IS NOT INITIAL.

          READ TABLE lt_listas INTO lw_listas INDEX lv_len.
          IF sy-subrc = 0.

            lw_listas-seq   = lw_listas-seq + 1.
            LOOP AT lt_esterilizacao INTO DATA(lw_esterilizacao).
              lw_listas-lista = lw_esterilizacao-lt_esterilizacao.
              APPEND lw_listas TO lt_listas.
            ENDLOOP.
          ENDIF.

        ENDIF.

        LOOP AT lt_listas INTO lw_listas.

          SPLIT lw_listas-lista AT '/' INTO lw_caufvd-plnnr lw_caufvd-plnal.

          lw_caufvd-plnnr = |{ lw_caufvd-plnnr ALPHA = IN }|.
          lw_caufvd-plnal = |{ lw_caufvd-plnal ALPHA = IN }|.

          SELECT SINGLE plnty
            FROM plko
            INTO lw_caufvd-plnty
            WHERE plnnr = lw_caufvd-plnnr AND
                  plnal = lw_caufvd-plnal AND
                  plnty  = 'A'.

          CALL FUNCTION 'CO_SD_ROUTING_EXPLOSION'
            EXPORTING
              caufvd_exp    = lw_caufvd
            IMPORTING
              caufvd_imp    = lw_caufvd
            EXCEPTIONS
              no_operation  = 01
              no_include    = 02
              esc_selection = 03.

          IF sy-subrc IS INITIAL.
            PERFORM caufv_upd(saplcobh) USING lw_caufvd.

            PERFORM text_copy_multi(saplcosd).
          ENDIF.

* refresh dialog tables
          CALL FUNCTION 'CO_DT_DTAB_DEL'.

* Create new ITAB
          CALL FUNCTION 'CO_IT_SET_FLG_ITAB_NEW'.

* Read order header
          PERFORM read_caufv_ind(saplcobh) USING  lw_caufvd-aufnr
                                                  rc27i-index_plko
                                                  lv_dummy.

* Fill TCA11 (Object selection for object overviews)
          CLEAR: lw_tca11.
          lw_tca11-flg_alt = abap_true.

* Create dialog table for order header
          CALL FUNCTION 'CO_DT_DTAB_CREATE'
            EXPORTING
              aufnr_imp     = lw_caufvd-aufnr
              object_status = lw_tca11
              rc27i_imp     = rc27i
              selection     = rc271
            IMPORTING
              entries       = rc27x-entries
              lstnr         = rc27x-lstnr.

        ENDLOOP.

        IF <fs_no_popup> IS ASSIGNED.
          <fs_no_popup> = abap_false.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDIF.
ENDIF.

IF sy-tcode = 'IW31' OR sy-tcode = 'IW34' OR sy-tcode = 'IW32'.

  IF lt_esterilizacao IS NOT INITIAL.

    ASSIGN ('(SAPLCOBC)RESB_BT[]') TO <fs_resb>.
    ASSIGN ('(SAPLCOIT)ITAB[]') TO <fs_itab>.

    CHECK <fs_itab> IS ASSIGNED.

    resb_bt[] = <fs_resb>.
    itab[] = <fs_itab>.

    READ TABLE resb_bt[] WITH KEY charg = ''
                                  shkzg = 'H' TRANSPORTING NO FIELDS.

    IF sy-subrc = 0.

      SELECT *
        FROM mchb
        INTO TABLE lt_mchb
         FOR ALL ENTRIES IN resb_bt[]
       WHERE matnr = resb_bt-matnr.

      IF sy-subrc = 0.

        SELECT *
          FROM mch1
          INTO TABLE lt_mch1
           FOR ALL ENTRIES IN lt_mchb
         WHERE matnr = lt_mchb-matnr
           AND charg = lt_mchb-charg.

      ENDIF.

      SORT lt_mch1 BY matnr hsdat ASCENDING.

      LOOP AT resb_bt[] ASSIGNING FIELD-SYMBOL(<fs_resb_line>) .

        IF <fs_resb_line>-charg IS INITIAL AND <fs_resb_line>-shkzg = 'H'.

          LOOP AT lt_mch1 INTO DATA(lw_mch1) WHERE matnr = <fs_resb_line>-matnr.

            DELETE lt_mchb WHERE clabs IS INITIAL.

            READ TABLE lt_mchb ASSIGNING FIELD-SYMBOL(<fs_mchb>) WITH KEY matnr = lw_mch1-matnr
                                                                          charg = lw_mch1-charg.
            IF sy-subrc = 0.
              IF <fs_mchb>-clabs >= <fs_resb_line>-bdmng.
                <fs_resb_line>-charg = lw_mch1-charg.
                <fs_mchb>-clabs = <fs_mchb>-clabs - <fs_resb_line>-bdmng.
              ELSE.
                lw_resb = <fs_resb_line>.
                lw_resb-bdmng     = <fs_resb_line>-bdmng = <fs_resb_line>-bdmng - <fs_mchb>-clabs.
                lw_resb-rspos     = lines( resb_bt[] ) + 1.
                lw_resb-xfehl     = ''.
                lw_resb-posnr     = lw_resb-rspos * 10.
                UNPACK lw_resb-posnr TO lw_resb-posnr.
                lw_resb-stlnr     = ''.
                lw_resb-stlkn     = 0.
                lw_resb-stpoz     = 0.
                lw_resb-sortf     = ''.
                lw_resb-objnr     = 'TM0000000001OK'.
                lw_resb-flgat     = 0.
                lw_resb-funct     = 'S10'.
                lw_resb-stlal     = ''.
                lw_resb-stvkn     = 0.
                lw_resb-prio_urg  = 99.
                lw_resb-prio_req  = 255.
                lw_resb-creadat   = 0.
                lw_resb-creaby    = ''.
                lw_resb-changeby  = ''.
                lw_resb-changedat = 0.
                lw_resb-vbkz      = 'I'.
                lw_resb-kzadd     = ''.
                lw_resb-lgortmat  = lw_resb-lgort.
                lw_resb-seqtype   = 0.
                lw_resb-xchar     = 'X'.
                lw_resb-ident     = ''.
                APPEND lw_resb TO resb_bt.

                READ TABLE itab INTO lw_itab WITH KEY rspos = <fs_resb_line>-rspos.
                LOOP AT itab INTO DATA(lw_itab_aux) WHERE vornr = lw_itab-vornr
                                                      AND xposn <> space.
                  DATA(lv_index) = sy-tabix.
                ENDLOOP.
                lv_index = lv_index + 1.
                lw_itab-xposn = lw_resb-posnr.
                lw_itab-posnr = lw_resb-posnr.
                lw_itab-rspos = lw_resb-rspos.
                lw_itab-index_plmz = lw_resb-rspos.
                PACK lw_itab-index_plmz TO lw_itab-index_plmz.
                lw_itab-projn = ''.
                lw_itab-bedzl = ''.
                lw_itab-datub = ''.
                lw_itab-vplnkn = ''.
                lw_itab-bknt1 = ''.
                lw_itab-bknt2 = ''.
                lw_itab-objnr = ''.
                INSERT lw_itab INTO itab INDEX lv_index.

                <fs_resb_line>-charg = lw_mch1-charg.
                <fs_resb_line>-bdmng = <fs_mchb>-clabs.
                CLEAR <fs_mchb>-clabs.
              ENDIF.
              EXIT.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDLOOP.

      <fs_resb> = resb_bt[].
      <fs_itab> = itab[].

    ENDIF.

  ENDIF.


  IF lt_esterilizacao IS NOT INITIAL.

    ASSIGN ('(SAPLCOBC)RESB_BT[]') TO <fs_resb>.

    resb_bt[] = <fs_resb>.

    READ TABLE resb_bt[] WITH KEY charg = ''
                                  shkzg = 'S' INTO DATA(lw_resb_bt).

    IF sy-subrc = 0.

      DATA(resb_bt_aux) = resb_bt[].
      DELETE resb_bt_aux WHERE charg = ''.
      READ TABLE resb_bt_aux[] WITH KEY shkzg = 'S' INTO DATA(lw_batch).

      IF lw_batch IS INITIAL.

        CALL FUNCTION '/SPROLIMS/BAPI_BATCH_CREATE'
          EXPORTING
            material = CONV matnr18( lw_resb_bt-matnr )
            plant    = lw_resb_bt-werks
          IMPORTING
            batch    = lv_batch
          TABLES
            return   = lt_return.

      ELSE.

        lv_batch = lw_batch-charg.
        CLEAR lw_batch.

      ENDIF.

      IF line_exists( lt_return[ type = 'E' ] ).

      ELSE.
        LOOP AT resb_bt ASSIGNING <fs_resb_line>.
          IF <fs_resb_line>-charg IS INITIAL AND <fs_resb_line>-shkzg = 'S'.
            IF <fs_resb_line>-matnr <> lw_resb_bt-matnr.
              CALL FUNCTION '/SPROLIMS/BAPI_BATCH_CREATE'
                EXPORTING
                  material = CONV matnr18( <fs_resb_line>-matnr )
                  batch    = lv_batch
                  plant    = lw_resb_bt-werks
                TABLES
                  return   = lt_return.
            ENDIF.
            <fs_resb_line>-charg = lv_batch.
          ENDIF.
        ENDLOOP.

        <fs_resb> = resb_bt[].
      ENDIF.

    ENDIF.

  ENDIF.

ENDIF.
