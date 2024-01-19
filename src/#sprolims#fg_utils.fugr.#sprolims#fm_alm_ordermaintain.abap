FUNCTION /SPROLIMS/FM_ALM_ORDERMAINTAIN.
*"--------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_MMSRV_EXTERNAL_MAINTENACE) TYPE  BAPI_FLAG OPTIONAL
*"  TABLES
*"      IT_METHODS STRUCTURE  BAPI_ALM_ORDER_METHOD
*"      IT_HEADER STRUCTURE  BAPI_ALM_ORDER_HEADERS_I OPTIONAL
*"      IT_HEADER_UP STRUCTURE  BAPI_ALM_ORDER_HEADERS_UP OPTIONAL
*"      IT_HEADER_SRV STRUCTURE  BAPI_ALM_ORDER_SRVDAT_E OPTIONAL
*"      IT_HEADER_SRV_UP STRUCTURE  BAPI_ALM_ORDER_SRVDAT_UP OPTIONAL
*"      IT_USERSTATUS STRUCTURE  BAPI_ALM_ORDER_USRSTAT OPTIONAL
*"      IT_PARTNER STRUCTURE  BAPI_ALM_ORDER_PARTN_MUL OPTIONAL
*"      IT_PARTNER_UP STRUCTURE  BAPI_ALM_ORDER_PARTN_MUL_UP OPTIONAL
*"      IT_OPERATION STRUCTURE  BAPI_ALM_ORDER_OPERATION OPTIONAL
*"      IT_OPERATION_UP STRUCTURE  BAPI_ALM_ORDER_OPERATION_UP
*"         OPTIONAL
*"      IT_RELATION STRUCTURE  BAPI_ALM_ORDER_RELATION OPTIONAL
*"      IT_RELATION_UP STRUCTURE  BAPI_ALM_ORDER_RELATION_UP OPTIONAL
*"      IT_COMPONENT STRUCTURE  BAPI_ALM_ORDER_COMPONENT OPTIONAL
*"      IT_COMPONENT_UP STRUCTURE  BAPI_ALM_ORDER_COMPONENT_UP
*"         OPTIONAL
*"      IT_OBJECTLIST STRUCTURE  BAPI_ALM_ORDER_OBJECTLIST OPTIONAL
*"      IT_OBJECTLIST_UP STRUCTURE  BAPI_ALM_ORDER_OLIST_UP OPTIONAL
*"      IT_OLIST_RELATION STRUCTURE  BAPI_ALM_OLIST_RELATION OPTIONAL
*"      IT_TEXT STRUCTURE  BAPI_ALM_TEXT OPTIONAL
*"      IT_TEXT_LINES STRUCTURE  BAPI_ALM_TEXT_LINES OPTIONAL
*"      IT_SRULE STRUCTURE  BAPI_ALM_ORDER_SRULE OPTIONAL
*"      IT_SRULE_UP STRUCTURE  BAPI_ALM_ORDER_SRULE_UP OPTIONAL
*"      IT_TASKLISTS STRUCTURE  BAPI_ALM_ORDER_TASKLISTS_I OPTIONAL
*"      EXTENSION_IN STRUCTURE  BAPIPAREX OPTIONAL
*"      RETURN STRUCTURE  BAPIRET2 OPTIONAL
*"      ET_NUMBERS STRUCTURE  BAPI_ALM_NUMBERS OPTIONAL
*"      IT_REFORDER_ITEM STRUCTURE  BAPI_REFORDER_ITEM_I OPTIONAL
*"      IT_REFORDER_ITEM_UP STRUCTURE  BAPI_REFORDER_ITEM_UP OPTIONAL
*"      IT_REFORDER_SERNO_OLIST_INS
*"  STRUCTURE  BAPI_REFORDER_SERNO_OLIST_I OPTIONAL
*"      IT_REFORDER_SERNO_OLIST_DEL
*"  STRUCTURE  BAPI_REFORDER_SERNO_OLIST_I OPTIONAL
*"      IT_PRT STRUCTURE  BAPI_ALM_ORDER_PRT_I OPTIONAL
*"      IT_PRT_UP STRUCTURE  BAPI_ALM_ORDER_PRT_UP OPTIONAL
*"      IT_REFORDER_OPERATION STRUCTURE  BAPI_REFORDER_OPERATION
*"         OPTIONAL
*"      IT_SERVICEOUTLINE STRUCTURE  BAPI_ALM_SRV_OUTLINE OPTIONAL
*"      IT_SERVICEOUTLINE_UP STRUCTURE  BAPI_ALM_SRV_OUTLINE_UP
*"         OPTIONAL
*"      IT_SERVICELINES STRUCTURE  BAPI_ALM_SRV_SERVICE_LINE OPTIONAL
*"      IT_SERVICELINES_UP STRUCTURE  BAPI_ALM_SRV_SERVICE_LINE_UP
*"         OPTIONAL
*"      IT_SERVICELIMIT STRUCTURE  BAPI_ALM_SRV_LIMIT_DATA OPTIONAL
*"      IT_SERVICELIMIT_UP STRUCTURE  BAPI_ALM_SRV_LIMIT_DATA_UP
*"         OPTIONAL
*"      IT_SERVICECONTRACTLIMITS
*"  STRUCTURE  BAPI_ALM_SRV_CONTRACT_LIMITS OPTIONAL
*"      IT_SERVICECONTRACTLIMITS_UP
*"  STRUCTURE  BAPI_ALM_SRV_CONTRACT_LIMITS_U OPTIONAL
*"      ET_NOTIFICATION_NUMBERS STRUCTURE  BAPI_ALM_NOTIF_NUMBERS
*"         OPTIONAL
*"      IT_PERMIT STRUCTURE  BAPI_ALM_ORDER_PERMIT OPTIONAL
*"      IT_PERMIT_UP STRUCTURE  BAPI_ALM_ORDER_PERMIT_UP OPTIONAL
*"      IT_PERMIT_ISSUE STRUCTURE  BAPI_ALM_ORDER_PERMITISSUE
*"         OPTIONAL
*"      IT_ESTIMATED_COSTS STRUCTURE  BAPI_ALM_ORDER_COSTS_EST_I
*"         OPTIONAL
*"      IT_HEADER_JVA STRUCTURE  BAPI_ALM_ORDER_JVA OPTIONAL
*"      IT_HEADER_JVA_UP STRUCTURE  BAPI_ALM_ORDER_JVA_UP OPTIONAL
*"--------------------------------------------------------------------
WAIT UP TO 4 SECONDS.

  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    EXPORTING
      iv_mmsrv_external_maintenace = iv_mmsrv_external_maintenace
    TABLES
      it_methods                   = it_methods
      it_header                    = it_header
      it_header_up                 = it_header_up
      it_header_srv                = it_header_srv
      it_header_srv_up             = it_header_srv_up
      it_userstatus                = it_userstatus
      it_partner                   = it_partner
      it_partner_up                = it_partner_up
      it_operation                 = it_operation
      it_operation_up              = it_operation_up
      it_relation                  = it_relation
      it_relation_up               = it_relation_up
      it_component                 = it_component
      it_component_up              = it_component_up
      it_objectlist                = it_objectlist
      it_objectlist_up             = it_objectlist_up
      it_olist_relation            = it_olist_relation
      it_text                      = it_text
      it_text_lines                = it_text_lines
      it_srule                     = it_srule
      it_srule_up                  = it_srule_up
      it_tasklists                 = it_tasklists
      extension_in                 = extension_in
      return                       = return
      et_numbers                   = et_numbers
      it_reforder_item             = it_reforder_item
      it_reforder_item_up          = it_reforder_item_up
      it_reforder_serno_olist_ins  = it_reforder_serno_olist_ins
      it_reforder_serno_olist_del  = it_reforder_serno_olist_del
      it_prt                       = it_prt
      it_prt_up                    = it_prt_up
      it_reforder_operation        = it_reforder_operation
      it_serviceoutline            = it_serviceoutline
      it_serviceoutline_up         = it_serviceoutline_up
      it_servicelines              = it_servicelines
      it_servicelines_up           = it_servicelines_up
      it_servicelimit              = it_servicelimit
      it_servicelimit_up           = it_servicelimit_up
      it_servicecontractlimits     = it_servicecontractlimits
      it_servicecontractlimits_up  = it_servicecontractlimits_up
      et_notification_numbers      = et_notification_numbers
      it_permit                    = it_permit
      it_permit_up                 = it_permit_up
      it_permit_issue              = it_permit_issue
      it_estimated_costs           = it_estimated_costs.

  IF line_exists( return[ type = 'E' ] ).

  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ENDIF.

ENDFUNCTION.
