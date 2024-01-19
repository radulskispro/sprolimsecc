@AbapCatalog.sqlViewName: '/SPROLIMS/CDSPRC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Auxiliar - Produtor Cooperado'
define view
  /SPROLIMS/CDS_A_PRODUCER
  as select from ihpa   as produtor

    inner join   but000 as name
      on name.partner = produtor.parnr
  {
    produtor.objnr,
    concat(name.name_first, concat(' ',name.name_last)) as nome_produtor
  }
  where
    produtor.parvw = 'PR'
