@AbapCatalog.sqlViewName: '/SPROLIMS/CDSMST'
@Analytics.dataExtraction.enabled: true
//@Analytics.dataCategory: #FACTS
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Matchcode for Storage'
define view
  /SPROLIMS/CDS_MCD_STORAGE
  as
  // *****************************************************************************
  // SPRO IT Solutions
  // Developer: SPR_VIEIRAA - Allan Costa Vieira
  // *****************************************************************************
  select distinct from nsdm_e_mard      as storage_locations

    right outer join   /sprolims/tb_cf1 as order_type_configuration
      on order_type_configuration.werks = storage_locations.werks
  {
    key storage_locations.matnr as material,
    key storage_locations.lgort as storage_id
  }
  where
    storage_locations.labst <> 0
