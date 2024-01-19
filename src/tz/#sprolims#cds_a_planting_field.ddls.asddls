@AbapCatalog.sqlViewName: '/SPROLIMS/CDSAPF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Campo e Talhão'

@VDM.viewType: #CONSUMPTION

@OData.entitySet.name: 'PlantingFieldSet'


define view /SPROLIMS/CDS_A_PLANTING_FIELD 
as select from /SPROLIMS/CDS_A_PRPS_PRHI as campo 

    inner join /SPROLIMS/CDS_A_PRPS_PRHI as talhao
    on talhao.pspnr = campo.up
    
    inner join /SPROLIMS/CDS_A_PRPS_PRHI as fazenda
    on fazenda.pspnr = talhao.up
    
    inner join /SPROLIMS/CDS_A_PRPS_PRHI as cultivar
    on cultivar.pspnr = fazenda.up
    
    inner join /sprolims/tb_cf8 as config
    on cultivar.psphi = config.safra_pep
    
    left outer join /SPROLIMS/CDS_A_PRPS_PRHI as safra
    on safra.pspnr = cultivar.up
    
    
{
        key campo.posid as planting_field, --campo    
        key talhao.posid as planting_field_part, --talhão
        key fazenda.posid as farm, --talhão
        key cultivar.posid as cultivate, --talhão
        key safra.posid as harvest, --talhão
        safra.psphi as num_seq_projeto,
        config.safra_pep,
        campo.post1 as planting_field_desc, --descrição campo
        talhao.post1 as planting_field_part_desc, --descriçao talhão
        fazenda.post1 as farm_desc, --descriçao fazenda
        cultivar.post1 as cultivatet_desc, --descriçao talhão
        safra.post1 as harvest_desc --descriçao fazenda
        
        
}where campo.down = '00000000'
