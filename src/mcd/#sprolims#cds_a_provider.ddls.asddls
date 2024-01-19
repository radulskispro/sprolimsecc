@AbapCatalog.sqlViewName: '/SPROLIMS/CDSPRO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Fornecedor'


@VDM.viewType: #CONSUMPTION

@OData.entitySet.name: 'ProviderSet'




define view
  /SPROLIMS/CDS_A_PROVIDER

  as select from lfa1 as supplier

  {
    key    supplier.lifnr as number_provider,
    supplier.name1 as name

  }
