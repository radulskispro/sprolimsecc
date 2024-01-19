interface /SPROLIMS/IN_BADI_SOL_CHANGE
  public .


  interfaces IF_BADI_INTERFACE .

  methods CONVERT
    importing
      !IV_SOLICITATION_ID type QMNUM
    exporting
      !EV_ORDER_ID type AUFNR
      !EV_ERROR type FLAG
      !ET_RETURN type BAPIRET2_T .
endinterface.
