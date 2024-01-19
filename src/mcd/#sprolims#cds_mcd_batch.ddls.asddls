@AbapCatalog.sqlViewName: '/SPROLIMS/CDSMBA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Matchcode for Batch'
define view
  /SPROLIMS/CDS_MCD_BATCH
  as
  // *****************************************************************************
  // SPRO IT Solutions
  // Developer: SPR_VIEIRAA - Allan Costa Vieira
  // *****************************************************************************
  select distinct from mcha             as batch

    right outer join   /sprolims/tb_cf1 as order_type_configuration
      on order_type_configuration.werks = batch.werks

  {
    key batch.matnr as material,
    key batch.charg as batch
  }
