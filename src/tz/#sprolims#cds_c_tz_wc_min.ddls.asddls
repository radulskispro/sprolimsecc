@AbapCatalog.sqlViewName: '/SPROLIMS/CDSTWM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Aux App TZ - Workcenter'
define view /SPROLIMS/CDS_A_TZ_WC_MIN 
as select from /SPROLIMS/CDS_ORD_STP_CHAR_TZ {
    order_id,
    solicitation,
   batch_number,
   min(merknr) as merknr,
   work_center,
   full_name
}where work_center = 'TZ'
group by order_id,
    solicitation,
   batch_number,
   work_center,
   full_name
