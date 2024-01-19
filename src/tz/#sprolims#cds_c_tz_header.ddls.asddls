@AbapCatalog.sqlViewName: '/SPROLIMS/CDSTZH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Tetrazolium App Report Header'


@VDM.viewType: #CONSUMPTION

@OData.entitySet.name: 'TZHeaderSet'

define view /SPROLIMS/CDS_C_TZ_HEADER 

as select from /SPROLIMS/CDS_A_TZ_WC_MIN  as tz

inner join /SPROLIMS/CDS_ORDER_HEADER as order_header
on tz.order_id = order_header.order_id

inner join /SPROLIMS/CDS_SOLICITATION as solicitation
on tz.solicitation = solicitation.solicitation_id

association[0..1] to /SPROLIMS/CDS_A_PLANTING_FIELD as planting_field
on solicitation.planting_field  = planting_field.planting_field and
   solicitation.cultivate_field = planting_field.cultivate 

association[0..1] to /SPROLIMS/CDS_A_PLANTING_FIELD as planting_field_part
on solicitation.planting_field_part = planting_field_part.planting_field_part and
   solicitation.planting_field      = planting_field_part.planting_field and
   solicitation.cultivate_field     = planting_field_part.cultivate 

association[0..1] to /SPROLIMS/CDS_A_PLANTING_FIELD as farm
on solicitation.farm                = farm.farm and
   solicitation.planting_field_part = farm.planting_field_part and
   solicitation.planting_field      = farm.planting_field and
   solicitation.cultivate_field     = farm.cultivate 

association[0..1] to /SPROLIMS/CDS_A_PLANTING_FIELD as cultivate_field
on solicitation.cultivate_field     = cultivate_field.cultivate and
   solicitation.farm                = cultivate_field.farm and
   solicitation.planting_field_part = cultivate_field.planting_field_part and
   solicitation.planting_field      = cultivate_field.planting_field

{
 key tz.order_id, --ordem
 tz.solicitation, --solicitaçao
 tz.batch_number, --lote de controle
 tz.full_name, --nome completo analista
 
 order_header.production_batch_number, --lote de produçao
 order_header.start_date, --data inicial
 order_header.end_date, --data final
 
 solicitation.sample_number, --numero de amostra
 solicitation.solicitation_description, 
 solicitation.cultivar, --cultivar
 solicitation.requester_name, --nome do solicitante
 
 solicitation.planting_field, --campo
 planting_field.planting_field_desc, --campo descrição
 
 solicitation.planting_field_part, --talhão
 planting_field_part.planting_field_part_desc, --talhão descrição
 
 solicitation.farm, --fazenda
 farm.farm_desc, --fazenda descrição
 
 solicitation.cultivate_field, --especie campo
 cultivate_field.cultivatet_desc, --especie descriçao
 
 solicitation.planting_collect_type   --tipo de coleta
}
