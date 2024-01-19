FUNCTION /sprolims/fm_set_step_material.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IW_GW_STEP_MATERIALS) TYPE  /SPROLIMS/ST_GW_STEP_MATERIALS
*"  EXPORTING
*"     VALUE(EW_GW_STEP_MATERIALS) TYPE  /SPROLIMS/ST_GW_STEP_MATERIALS
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: lt_goodsmvt_item   TYPE TABLE OF bapi2017_gm_item_create.

  DATA: lw_goodsmvt_header LIKE  bapi2017_gm_head_01,
        lw_goodsmvt_code   LIKE  bapi2017_gm_code,
        lw_goodsmvt_item   LIKE LINE OF lt_goodsmvt_item,
        lw_return          LIKE LINE OF et_return.

  IF iw_gw_step_materials IS NOT INITIAL.

*    SELECT COUNT(*)
*      FROM /sprolims/cdsosm
*      WHERE order_id      = iw_gw_step_materials-orderid AND
*            order_step_id = iw_gw_step_materials-activity AND
*            material      = iw_gw_step_materials-material .
*
*    IF sy-subrc <> 0.

      lw_goodsmvt_header-pstng_date = sy-datum.
      lw_goodsmvt_header-doc_date   = sy-datum.
      lw_goodsmvt_header-pr_uname   = sy-uname.

      lw_goodsmvt_code-gm_code  = '03'.

      lw_goodsmvt_item-orderid        = iw_gw_step_materials-orderid.
      lw_goodsmvt_item-material       = iw_gw_step_materials-material.
      lw_goodsmvt_item-plant          = iw_gw_step_materials-plant.
      lw_goodsmvt_item-stge_loc       = iw_gw_step_materials-stge_loc.
      lw_goodsmvt_item-batch          = iw_gw_step_materials-batch.
      lw_goodsmvt_item-move_type      = iw_gw_step_materials-move_type.
      lw_goodsmvt_item-entry_qnt      = iw_gw_step_materials-entry_qnt.
      lw_goodsmvt_item-entry_uom      = iw_gw_step_materials-entry_uom.
      lw_goodsmvt_item-activity       = iw_gw_step_materials-activity.

      SELECT SINGLE isocode
        FROM t006
        INTO lw_goodsmvt_item-entry_uom_iso
        WHERE msehi = lw_goodsmvt_item-entry_uom.

      APPEND lw_goodsmvt_item TO t_goodsmvt_item.

*      CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
*        EXPORTING
*          goodsmvt_header = lw_goodsmvt_header
*          goodsmvt_code   = lw_goodsmvt_code
*        TABLES
*          goodsmvt_item   = lt_goodsmvt_item
*          return          = et_return.
*
*      READ TABLE et_return WITH KEY type = 'E' TRANSPORTING NO FIELDS.
*      IF sy-subrc <> 0.
*
*        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
*
*        IF sy-subrc = 0.
*
*          ew_gw_step_materials = iw_gw_step_materials.
*
*          lw_return-type        = 'S'.
*          lw_return-id          = '/SPROLIMS/MC_REGIS'.
*          lw_return-number      = '010'.
*          lw_return-message_v1  = lw_goodsmvt_item-orderid.
*          lw_return-message_v2  = lw_goodsmvt_item-activity.
*          lw_return-message_v3  = ''.
*          lw_return-message_v4  = ''.
*
*          MESSAGE ID '/SPROLIMS/MC_REGIS' TYPE 'S' NUMBER '010'
*            WITH   lw_goodsmvt_item-orderid
*                   lw_goodsmvt_item-activity
*                   ''
*                   ''
*            INTO   lw_return-message.
*
*          APPEND lw_return TO et_return.
*
*        ENDIF.
*
*      ENDIF.
*
*    ELSE.
*
*  CALL FUNCTION 'BAPI_ALM_CONF_CREATE'
**   EXPORTING
**     POST_WRONG_ENTRIES       = '0'
**     TESTRUN                  =
**   IMPORTING
**     RETURN                   =
*    TABLES
*      timetickets              =
**     DETAIL_RETURN            =
*            .
*
*    ENDIF.
  ENDIF.

ENDFUNCTION.
