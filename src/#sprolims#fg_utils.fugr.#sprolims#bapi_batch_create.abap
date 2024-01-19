FUNCTION /SPROLIMS/BAPI_BATCH_CREATE.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(MATERIAL) LIKE  BAPIBATCHKEY-MATERIAL
*"     VALUE(BATCH) LIKE  BAPIBATCHKEY-BATCH OPTIONAL
*"     VALUE(PLANT) LIKE  BAPIBATCHKEY-PLANT OPTIONAL
*"     VALUE(BATCHATTRIBUTES) LIKE  BAPIBATCHATT STRUCTURE
*"        BAPIBATCHATT OPTIONAL
*"     VALUE(BATCHCONTROLFIELDS) LIKE  BAPIBATCHCTRL STRUCTURE
*"        BAPIBATCHCTRL OPTIONAL
*"     VALUE(BATCHSTORAGELOCATION) LIKE  BAPIBATCHSTOLOC-STGE_LOC
*"       OPTIONAL
*"     VALUE(INTERNALNUMBERCOM) LIKE  BAPIBNCOM STRUCTURE  BAPIBNCOM
*"       OPTIONAL
*"     VALUE(EXTENSION1) LIKE  BAPIBNCOMZ STRUCTURE  BAPIBNCOMZ
*"       OPTIONAL
*"     VALUE(MATERIAL_EVG) TYPE  BAPIMGVMATNR OPTIONAL
*"  EXPORTING
*"     VALUE(BATCH) LIKE  BAPIBATCHKEY-BATCH
*"     VALUE(BATCHATTRIBUTES) LIKE  BAPIBATCHATT STRUCTURE
*"        BAPIBATCHATT
*"  TABLES
*"      RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------

 v_done  = abap_false.
  v_batch = batch.

  w_batchattributes = batchattributes.

  CALL FUNCTION 'BAPI_BATCH_CREATE' STARTING NEW TASK 'EX1'
    DESTINATION 'NONE' PERFORMING f_result_bapi ON END OF TASK
    EXPORTING
      material             = material
      batch                = batch
      plant                = plant
      batchattributes      = batchattributes
      batchcontrolfields   = batchcontrolfields
      batchstoragelocation = batchstoragelocation
      internalnumbercom    = internalnumbercom
      extension1           = extension1
      material_evg         = material_evg.

  WAIT UNTIL v_done = abap_true.

  batch = v_batch.
  batchattributes = w_batchattributes.
  return[] = t_return.

  IF line_exists( return[ type = 'E' ] ).

  ELSE.
*    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
  ENDIF.
ENDFUNCTION.

FORM f_result_bapi USING task.

  RECEIVE RESULTS FROM FUNCTION 'BAPI_BATCH_CREATE'
    IMPORTING
      batch = v_batch
      batchattributes = w_batchattributes
    TABLES
      return = t_return.

  v_done = abap_true.

ENDFORM.
