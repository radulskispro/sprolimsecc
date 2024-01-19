@AbapCatalog.sqlViewName: '/SPROLIMS/CDSMUN'
@Analytics.dataExtraction.enabled: true
//@Analytics.dataCategory: #FACTS
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Matchcode for Measurement Unit'
define view
  /SPROLIMS/CDS_MCD_UNIT
  as
  // *****************************************************************************
  // SPRO IT Solutions
  // Developer: SPR_VIEIRAA - Allan Costa Vieira
  // *****************************************************************************
  select distinct from nsdm_e_marc      as plant_material

    right outer join   /sprolims/tb_cf1 as order_type_configuration
      on order_type_configuration.werks = plant_material.werks

    inner join         marm             as material_plant
      on material_plant.matnr = plant_material.matnr

    inner join         t006a            as measurement_unit
      on  measurement_unit.msehi = material_plant.meinh
      and measurement_unit.spras = 'P'

  {
    key material_plant.matnr            as material,
    key measurement_unit.mseh3          as unit,
    measurement_unit.msehl          as unit_text
  }
