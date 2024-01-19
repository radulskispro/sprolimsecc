class /SPROLIMS/CL_TETRAZOLIUM_VALID definition
  public
  final
  create public .

public section.

  data INSPECTION_LOT type QPLOS .
  data WORK_CENTER type ARBPL .
  data LOG type ref to /SPROPROD/CL_LOG .

  methods CONSTRUCTOR
    importing
      !IV_INSPECTION_LOT type QPLOS optional
      !IV_WORK_CENTER type /SPROLIMS/CDSAOS-WORK_CENTER optional .
  methods _HAS_DU
    raising
      /SPROLIMS/CX_TETRAZOLIUM .
  methods _HAS_CHARAC_BY_WORK_CENTER
    raising
      /SPROLIMS/CX_TETRAZOLIUM .
  methods _HAS_DAMAGE
    raising
      /SPROLIMS/CX_TETRAZOLIUM .
  methods GET_DATA_CHARAC .
  methods RAISE_EXCEPTION_CUSTOM
    importing
      !IV_ID type SY-MSGID
      !IV_NUMBER type SY-MSGNO
      !IV_V1 type ANY optional
      !IV_V2 type ANY optional
      !IV_V3 type ANY optional
      !IV_V4 type ANY optional
      !IV_MESSAGE type ANY
    raising
      /SPROLIMS/CX_TETRAZOLIUM .
protected section.
PRIVATE SECTION.

  TYPES:
    BEGIN OF y_charac_data,
      prueflos              TYPE /sprolims/cdsao2-prueflos,
      vorglfnr              TYPE /sprolims/cdsao2-vorglfnr,
      merknr                TYPE /sprolims/cdsao2-merknr,
      verwmerkm             TYPE /sprolims/cdsao2-verwmerkm,
      kurztext              TYPE /sprolims/cdsao2-kurztext,
      sollstpumf            TYPE /sprolims/cdsao2-sollstpumf,
      inspspecrecordingtype TYPE /sprolims/cdsao2-inspspecrecordingtype,
      formel1               TYPE /sprolims/cdsao2-formel1,
      katalgart1            TYPE /sprolims/cdsao2-katalgart1,
      auswmenge1            TYPE /sprolims/cdsao2-auswmenge1,
      katalgart2            TYPE /sprolims/cdsao2-katalgart2,
      auswmenge2            TYPE /sprolims/cdsao2-auswmenge2,
      order_id              TYPE /sprolims/cdsao2-order_id,
      order_step_id         TYPE /sprolims/cdsao2-order_step_id,
      step_description      TYPE /sprolims/cdsao2-step_description,
      work_center           TYPE /sprolims/cdsao2-work_center,
      order_step_plant      TYPE /sprolims/cdsao2-order_step_plant,
      tplnr                 TYPE /sprolims/cdsao2-tplnr,
*--------campos que não serão selecionados no select, mas que para facilitar já estão na tabela
      fieldname             TYPE lvc_fname,
      position              TYPE n LENGTH 2,
      control_unit_position TYPE i,
      value                 TYPE n LENGTH 3,
    END OF y_charac_data .

  DATA charac_data TYPE TABLE OF y_charac_data .
ENDCLASS.



CLASS /SPROLIMS/CL_TETRAZOLIUM_VALID IMPLEMENTATION.


  method CONSTRUCTOR.
    inspection_lot = iv_inspection_lot.
    work_center    = iv_work_center.

    get_data_charac( ).

    log ?= /sproprod/cl_log=>factory( object = '/SPROLIMS/' subobject = '/TETRAZOLIUM/' id = | VALIDATE_TETRAZOLIUM{ iv_inspection_lot } |   ).

  endmethod.


  METHOD get_data_charac.
    IF charac_data IS INITIAL.
      SELECT ord_opr_char~prueflos  , ord_opr_char~vorglfnr     , ord_opr_char~merknr , ord_opr_char~verwmerkm ,
                 ord_opr_char~kurztext  , ord_opr_char~sollstpumf   , ord_opr_char~inspspecrecordingtype,
                 ord_opr_char~formel1   , ord_opr_char~katalgart1   , ord_opr_char~auswmenge1,
                 ord_opr_char~katalgart2, ord_opr_char~auswmenge2,
                 ord_opr_char~order_id  , ord_opr_char~order_step_id,
                 ord_opr_char~step_description, ord_opr_char~work_center, ord_opr_char~order_step_plant,
                 ord_opr_char~tplnr
            FROM  /sprolims/cdsao2 AS ord_opr_char
            INTO TABLE @charac_data
            WHERE ord_opr_char~batch_number  = @inspection_lot AND
                  ord_opr_char~work_center   = @work_center AND
                  ord_opr_char~has_du        = ''.

      SORT charac_data BY prueflos vorglfnr merknr.
    ENDIF.
  ENDMETHOD.


  METHOD raise_exception_custom.
*    iv_message.
*    RAISE EXCEPTION TYPE /sprolims/cx_tetrazolium
*      EXPORTING
*        msgid = sy-msgid
*        msgno = sy-msgno
*        attr1 = sy-msgv1
*        attr2 = sy-msgv2
*        attr3 = sy-msgv3
*        attr4 = sy-msgv4.
  ENDMETHOD.


  METHOD _has_charac_by_work_center.
    IF lines( charac_data ) EQ 0.
      MESSAGE e003(/sprolims/tetra) WITH inspection_lot work_center  INTO sy-msgli.
      log->add( ).
      COMMIT WORK.
      rex /sprolims/cx_tetrazolium.
    ENDIF.

    SELECT *
     FROM /sprolims/tdc
     INTO TABLE @DATA(lt_tdc)
     FOR ALL ENTRIES IN @charac_data
     WHERE werks       = @charac_data-order_step_plant AND
           work_center = @charac_data-work_center AND
           verwmerkm   = @charac_data-verwmerkm.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE e002(/sprolims/tetra) INTO sy-msgli.
      log->add( ).
      COMMIT WORK.
      rex /sprolims/cx_tetrazolium.
    ENDIF.

    log->add( msg = 'Characs OK' msgty = 'I'  ).
  ENDMETHOD.


  METHOD _has_damage.
    DATA: lo_rtti_struc TYPE REF TO cl_abap_structdescr.
    DATA: lt_components TYPE cl_abap_structdescr=>component_table.

    SELECT *
      FROM /sprolims/tdc
      INTO TABLE @DATA(lt_tdc)
      FOR ALL ENTRIES IN @charac_data
      WHERE werks       = @charac_data-order_step_plant AND
            work_center = @charac_data-work_center AND
            verwmerkm   = @charac_data-verwmerkm.
    IF lines( lt_tdc ) NE lines( charac_data ).
    ENDIF.

    lo_rtti_struc ?= cl_abap_structdescr=>describe_by_name('/SPROLIMS/ST_GW_RESULT_TETRAZ').
    lt_components = lo_rtti_struc->get_components( ).

    LOOP AT charac_data INTO DATA(lw_charac_data) WHERE work_center = 'TZ'.
      READ TABLE lt_tdc INTO DATA(lw_tdc) WITH KEY work_center = lw_charac_data-work_center
                                               verwmerkm   = lw_charac_data-verwmerkm.

      TRY.
          DATA(lw_component) = lt_components[ name = lw_tdc-fill_field ] .
        CATCH cx_sy_itab_line_not_found.
          MESSAGE e001(/sprolims/tetra) WITH lw_tdc-fill_field INTO sy-msgli. "Feature &1 not found. Check the characters. available.
          log->add( ).
          COMMIT WORK.
          rex /sprolims/cx_tetrazolium.
      ENDTRY.
    ENDLOOP.

    log->add( msg = 'Danos OK' msgty = 'I'  ).

  ENDMETHOD.


  METHOD _has_du.
    TYPES: BEGIN OF ly_qave,
             prueflos   TYPE qave-prueflos,
             vbewertung TYPE qave-vbewertung,
             vcode      TYPE qave-vcode,
           END OF ly_qave.

    DATA lw_qave      TYPE ly_qave.

    SELECT SINGLE prueflos, vbewertung, vcode
    FROM qave
    INTO @lw_qave
    WHERE prueflos = @inspection_lot.
    IF sy-subrc IS INITIAL.
      IF lw_qave-vcode IS NOT INITIAL.
        MESSAGE e000(/sprolims/tetra) WITH inspection_lot INTO sy-msgli.
        log->add( ).
        COMMIT WORK.
        rex /sprolims/cx_tetrazolium.
      ENDIF.
    ENDIF.

    log->add( msg = 'Lote SEM DU' msgty = 'I'  ).

  ENDMETHOD.
ENDCLASS.
