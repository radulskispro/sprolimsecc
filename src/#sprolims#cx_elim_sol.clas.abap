class /SPROLIMS/CX_ELIM_SOL definition
  public
  inheriting from CX_STATIC_CHECK
  create public .

public section.

  constants HAS_BAS type SOTR_CONC value '4201AC1FE9091EDC8CB65521E3880CEE' ##NO_TEXT.
  constants NO_BATCH_NUMBER_FOUND type SOTR_CONC value '4201AC1FE9091EDC8CB65521E3884CEE' ##NO_TEXT.
  constants BUSINESS_COMPLETION type SOTR_CONC value '4201AC1FE9091EDC8CB65521E388CCEE' ##NO_TEXT.
  constants SET_DEFINITIVE_SAMPLE type SOTR_CONC value '4201AC1FE9091EDC8CB65521E3898CEE' ##NO_TEXT.
  constants SET_USAGE_DECISION type SOTR_CONC value '4201AC1FE9091EDC8CB65521E3896CEE' ##NO_TEXT.
  constants ERASE_SAMPLE_NUMBER type SOTR_CONC value '4201AC1FE9091EDC8CB65521E3894CEE' ##NO_TEXT.
  constants NO_ORDER_OBJNR_FOUND type SOTR_CONC value '4201AC1FE9091EDC8CB65521E3892CEE' ##NO_TEXT.
  constants ELIMINATE_ORDER type SOTR_CONC value '4201AC1FE9091EDC8CB65521E3890CEE' ##NO_TEXT.
  constants ELIMINATE_BATCH_NUMBER type SOTR_CONC value '4201AC1FE9091EDC8CB65521E388ECEE' ##NO_TEXT.
  constants CHANGE_USR_STAT type SOTR_CONC value '4201AC1FE9091EDC8CB65521E3888CEE' ##NO_TEXT.
  constants ELIMINATE_SOL type SOTR_CONC value '4201AC1FE9091EDC8CB65521E388ACEE' ##NO_TEXT.
  constants NO_ORDER_FOUND type SOTR_CONC value '4201AC1FE9091EDC8CB65521E3882CEE' ##NO_TEXT.
  constants NO_SOLICITATION_FOUND type SOTR_CONC value '4201AC1FE9091EDC8CB65521E3886CEE' ##NO_TEXT.
  constants HAS_DU type SOTR_CONC value '4201AC1FE9091EDC8B895E889EB64CEE' ##NO_TEXT.

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional .
protected section.
private section.
ENDCLASS.



CLASS /SPROLIMS/CX_ELIM_SOL IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
  endmethod.
ENDCLASS.