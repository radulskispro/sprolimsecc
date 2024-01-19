@AbapCatalog.sqlViewName: '/SPROLIMS/CDSPLT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Solicitante'


@VDM.viewType: #CONSUMPTION

@OData.entitySet.name: 'Requester'


define view /SPROLIMS/CDS_A_PLANT 

as select from t001w {
    key t001w.werks as center,
    t001w.name1 as name
    
}
