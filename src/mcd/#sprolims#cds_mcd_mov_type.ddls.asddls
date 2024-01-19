@AbapCatalog.sqlViewName: '/SPROLIMS/CDSMMT'
@Analytics.dataExtraction.enabled: true
//@Analytics.dataCategory: #FACTS
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Matchcode for Movement Type'
define view /SPROLIMS/CDS_MCD_MOV_TYPE 
as 
// *****************************************************************************
// SPRO IT Solutions
// Developer: SPR_VIEIRAA - Allan Costa Vieira
// ***************************************************************************** 
    select from t157h as movement_types      
{
    key movement_types.bwart as movement_type_id,
        movement_types.sobkz as special_stock_indicator,
        movement_types.htext as movement_text
}where  movement_types.tcode    = 'IW41' and
        movement_types.spras    = 'P'
