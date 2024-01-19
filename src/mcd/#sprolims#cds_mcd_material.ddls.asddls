@AbapCatalog.sqlViewName: '/SPROLIMS/CDSMMA'
@Analytics.dataExtraction.enabled: true
//@Analytics.dataCategory: #FACTS
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Matchcode for Material'

@VDM.viewType: #CONSUMPTION

@OData.entitySet.name: 'MaterialSet'

define view
  /SPROLIMS/CDS_MCD_MATERIAL
  as
  // *****************************************************************************
  // SPRO IT Solutions
  // Developer: SPR_VIEIRAA - Allan Costa Vieira
  // *****************************************************************************
  select distinct from nsdm_e_marc      as plant_material

   // right outer join   /sprolims/tb_cf1 as order_type_configuration
     // on order_type_configuration.werks = plant_material.werks

    inner join         makt             as material_description
      on  material_description.matnr = plant_material.matnr
      and material_description.spras = 'P'

    left outer join    mara             as material_general_data
      on material_general_data.matnr = plant_material.matnr

  {
    key plant_material.matnr        as material,
    material_description.maktx      as material_description,
    material_general_data.xchpf     as obligatory_batch,
    plant_material.werks            as center
  }
