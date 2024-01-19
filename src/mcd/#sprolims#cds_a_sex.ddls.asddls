@AbapCatalog.sqlViewName: '/SPROLIMS/CDSSEX'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Sexo'

@VDM.viewType: #CONSUMPTION

@OData.entitySet.name: 'SexSet'


define view
  /SPROLIMS/CDS_A_SEX
  as select from dd07t
  {
    key domvalue_l as sex,
    ddtext as description
  }
  where
        domname    = '/SPROLM/DO_SEX'
    and ddlanguage = 'P'
