@AbapCatalog.sqlViewName: '/SPROLIMS/CDSLAB'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Laboratório'

@VDM.viewType: #CONSUMPTION

@OData.entitySet.name: 'LaboratorySet'

define view /SPROLIMS/CDS_A_LABORATORY 
as select from iflotx {
    key iflotx.tplnr as location,
    iflotx.pltxt as description
    
} where iflotx.spras = 'P';
