@AbapCatalog.sqlViewName: '/SPROLIMS/CDSPRP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Aux. Join Info PRPS_PRHI'
define view /SPROLIMS/CDS_A_PRPS_PRHI 
as select from prps as prps 
inner join prhi as prhi
on prps.pspnr = prhi.posnr
{
    prps.pspnr,
    prps.posid,
    prps.post1,
    prps.psphi,
    prps.stufe,
    prhi.down,
    prhi.up
}
