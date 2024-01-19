@AbapCatalog.sqlViewName: '/SPROLIMS/CDSMQP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Auxiliar - Max val field QASR-PROEBENR'
define view /SPROLIMS/CDS_A_QASR_M_PROBENR as select from qasr {
    prueflos,
    max(probenr) as probenr
}group by prueflos
