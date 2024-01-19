@AbapCatalog.sqlViewName: '/SPROLIMS/MATSOL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Material Solicitante'
define view
  /SPROLIMS/CDS_MCD_MAT_SOL
  as select from nsdm_e_marc as material

    inner join   makt        as material_description
      on  material.matnr             = material_description.matnr
      and material_description.spras = 'P'
  {
    key  material.matnr as material,
    material_description.maktx as material_description

  }
