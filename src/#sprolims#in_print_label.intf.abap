interface /SPROLIMS/IN_PRINT_LABEL
  public .


  interfaces IF_BADI_INTERFACE .

  methods PRINT_LABEL
    changing
      !IW_PRINT_LABEL type /SPROLIMS/ST_GW_PRINT_DET_SERV .
endinterface.
