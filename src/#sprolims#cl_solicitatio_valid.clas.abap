class /SPROLIMS/CL_SOLICITATIO_VALID definition
  public
  final
  create public .

public section.

  data SOLICITATION type /SPROLIMS/TT_SOL_TO_QMEL .
  data CAMPO type /SPROLIMS/DE_CAMPO .
  data TALHAO type /SPROLIMS/DE_TALHAO .
  data FAZENDA type /SPROLIMS/DE_FAZENDA .
  data CULTIVAR_CAMPO type /SPROLIMS/DE_CULTIVAR_CAMPO .
  data CULTIVAR type /SPROLIMS/DE_CULTIVAR .
  data LOG type ref to /SPROPROD/CL_LOG .
  data LABORATORY type TPLNR .

  methods CONSTRUCTOR
    importing
      value(IV_SOLICITATION) type /SPROLIMS/TT_SOL_TO_QMEL optional .
  methods _HAS_PEPS
    raising
      /SPROLIMS/CX_SOLICITATION .
  methods _HAS_CATEGORY
    importing
      value(IV_CATEGORY) type STRING
    raising
      /SPROLIMS/CX_SOLICITATION .
  methods _HAS_USER_AUTH
    importing
      value(IV_SOLICITATION_ID) type QMNUM optional
      value(IV_PROCESS) type STRING
    raising
      /SPROLIMS/CX_SOLICITATION .
protected section.
private section.
ENDCLASS.



CLASS /SPROLIMS/CL_SOLICITATIO_VALID IMPLEMENTATION.


  METHOD constructor.

    DESCRIBE TABLE iv_solicitation LINES DATA(lv_rows).
    IF lv_rows = 1.
      solicitation        = iv_solicitation.
      campo               = solicitation[ 1 ]-campo.
      talhao              = solicitation[ 1 ]-talhao.
      fazenda             = solicitation[ 1 ]-fazenda.
      cultivar_campo      = solicitation[ 1 ]-cultivar_campo.
      cultivar            = solicitation[ 1 ]-cultivar.
      laboratory          = solicitation[ 1 ]-laboratory.
    ENDIF.

  ENDMETHOD.


  METHOD _HAS_CATEGORY.

    SELECT SINGLE *
      FROM /sprolims/cdscso
      INTO @DATA(ls_cultivar)
      WHERE catalog_description EQ @iv_category
        AND code_description EQ @cultivar.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE e004(/sprolims/sol) WITH cultivar INTO DATA(lv_dummy).
      rex /sprolims/cx_solicitation.
    ENDIF.

  ENDMETHOD.


  METHOD _has_peps.
    "campo
    IF campo IS INITIAL.
      RETURN.
    ENDIF.
    SELECT SINGLE  *
      FROM /sprolims/cdsapf
      INTO @DATA(ls_element_pep)
      WHERE planting_field EQ @campo.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE e001(/sprolims/sol) WITH campo INTO DATA(lv_dummy).
      rex /sprolims/cx_solicitation.
    ENDIF.

    "talhao
    IF talhao IS INITIAL.
      MESSAGE e000(/sprolims/sol) WITH campo fazenda INTO lv_dummy.
      rex /sprolims/cx_solicitation.
    ENDIF.
    IF ls_element_pep-planting_field_part NE talhao.
      MESSAGE e000(/sprolims/sol) WITH campo talhao INTO lv_dummy.
      rex /sprolims/cx_solicitation.
    ENDIF.

    "fazenda
    IF fazenda IS INITIAL.
      MESSAGE e000(/sprolims/sol) WITH campo fazenda INTO lv_dummy.
      rex /sprolims/cx_solicitation.
    ENDIF.
    IF ls_element_pep-farm NE fazenda.
      MESSAGE e000(/sprolims/sol) WITH campo fazenda INTO lv_dummy.
      rex /sprolims/cx_solicitation.
    ENDIF.

    "especie
    IF cultivar_campo IS INITIAL.
      MESSAGE e001(/sprolims/sol) WITH campo cultivar_campo INTO lv_dummy.
      rex /sprolims/cx_solicitation.
    ENDIF.
    IF ls_element_pep-cultivate NE cultivar_campo.
      MESSAGE e001(/sprolims/sol) WITH 'Cultivar Campo' cultivar_campo INTO lv_dummy.
      rex /sprolims/cx_solicitation.
    ENDIF.

  ENDMETHOD.


  METHOD _has_user_auth.
    IF iv_solicitation_id IS NOT INITIAL.
      SELECT SINGLE * FROM /sprolims/cdssol
        INTO @DATA(lw_solicitation)
       WHERE solicitation_id = @iv_solicitation_id.

      SELECT SINGLE *
        FROM /sprolims/t_user
        INTO @DATA(lw_user)
       WHERE uname = @sy-uname
         AND werks = @lw_solicitation-laboratory
         AND application = @iv_process.
      IF sy-subrc IS NOT INITIAL.
        MESSAGE e005(/sprolims/sol) WITH sy-uname lw_solicitation-laboratory INTO DATA(lv_dummy).
        rex /sprolims/cx_solicitation.
      ENDIF.
    ENDIF.

    IF iv_solicitation_id IS INITIAL AND laboratory IS NOT INITIAL.
      SELECT SINGLE *
        FROM /sprolims/t_user
        INTO @lw_user
       WHERE uname = @sy-uname
         AND werks = @laboratory
         AND application = @iv_process.
      IF sy-subrc IS NOT INITIAL.
        MESSAGE e005(/sprolims/sol) WITH sy-uname laboratory INTO lv_dummy.
        rex /sprolims/cx_solicitation.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
