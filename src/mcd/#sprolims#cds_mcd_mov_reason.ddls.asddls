@AbapCatalog.sqlViewName: '/SPROLIMS/CDSMMR'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Matchcode for Movement Motive'
define view /SPROLIMS/CDS_MCD_MOV_REASON 
as
// *****************************************************************************
// SPRO IT Solutions
// Developer: SPR_VIEIRAA - Allan Costa Vieira
// *****************************************************************************   
select distinct from t157d as movement_reason 

    inner join  t157e as movement_reason_text
    on  movement_reason_text.bwart = movement_reason.bwart and
        movement_reason_text.grund = movement_reason.grund and
        movement_reason_text.spras = 'P'
{
    key movement_reason.bwart as movement_type_id,
    key movement_reason.grund as movement_reason_id,
        movement_reason_text.grtxt as reason_text
}
