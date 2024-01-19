@AbapCatalog.sqlViewName: '/SPROLIMS/CDSCOS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Centro de custos'

@VDM.viewType: #CONSUMPTION

@OData.entitySet.name: 'CenterCostsSet'


define view
  /SPROLIMS/CDS_A_CENTER_COST
  as select from csks as center_cost

    inner join   cskt as center_cost_text
      on  center_cost.datbi      = center_cost_text.datbi
      and center_cost.kostl      = center_cost_text.kostl
      and center_cost.kokrs      = center_cost_text.kokrs
      and center_cost_text.spras = 'P'

  {
    key center_cost.kokrs as area,
    key center_cost.kostl as center,
    key center_cost.datbi as validate_date_end,
    center_cost_text.ktext as description

  }
//where
//        center_cost_text.spras = $session.system_language and
// center_cost_text.mandt = $session.client
