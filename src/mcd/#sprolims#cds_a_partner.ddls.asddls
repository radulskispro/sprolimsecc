@AbapCatalog.sqlViewName: '/SPROLIMS/CDSPTN'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parceiros'

@VDM.viewType: #CONSUMPTION

@OData.entitySet.name: 'PartnersQMSet'



define view /SPROLIMS/CDS_A_PARTNER 
as select from tq80 as notify

    inner join tpaer as partner_definition
    on partner_definition.pargr = notify.pargr
    
    
    inner join tpart as partner    
    on partner.parvw = partner_definition.parvw and
       partner.spras = 'P'
    
 {
   key partner.parvw as function,
       partner.vtext as name,
       partner.parvw as number_partner
} where notify.qmart = 'ZB';
