@AbapCatalog.sqlViewName: '/SPROLIMS/CDSPKG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Tipo de acondicionamento'


@VDM.viewType: #CONSUMPTION

@OData.entitySet.name: 'PackingTypeSet'

define view /SPROLIMS/CDS_MCD_TYPE_PKG 
as select from tq42t as sample {
   key sample.gebindetyp as sample, 
    sample.kurztext as sample_description
}
