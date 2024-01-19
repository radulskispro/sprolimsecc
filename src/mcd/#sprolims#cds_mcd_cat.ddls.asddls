@AbapCatalog.sqlViewName: '/SPROLIMS/CDSCAT'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Categoria'
define view
  /SPROLIMS/CDS_MCD_CAT
  as select from qmel as solicitation

    inner join   qpgt as code_group
      on  code_group.katalogart = solicitation.otkat_categ
      and code_group.codegruppe = solicitation.otgrp_categ

  {
    key code_group.katalogart as category,
    code_group.codegruppe as category_description

  }
