@AbapCatalog.sqlViewName: '/SPROLIMS/CDSINS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Local de instalação'

@VDM.viewType: #CONSUMPTION

@OData.entitySet.name: 'LocaleInstallSet'


define view
  /SPROLIMS/CDS_LOCALE_INST

  as select from     iflot            as locale_install

    right outer join /sprolims/tb_cf1 as order_type_configuration
      on order_type_configuration.werks = locale_install.iwerk

    inner join       iflotx           as locale_install_text
      on locale_install_text.tplnr = locale_install.tplnr
  {
    key locale_install_text.tplnr as locale,
    locale_install_text.pltxt     as name,
    locale_install.iwerk          as center
  }
  where
    locale_install_text.spras = 'P';
