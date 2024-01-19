@AbapCatalog.sqlViewName: '/SPROLIMS/CDSOTZ'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Join Order, Step and Charac for TZ'
define view /SPROLIMS/CDS_ORD_STP_CHAR_TZ 
as select from    /SPROLIMS/CDS_ORDER_HEADER    as ordem

    inner join      /SPROLIMS/CDS_ORDER_STEP      as operacao
      on ordem.order_id = operacao.order_id

    inner join      qamv                          as caracteristica
      on  caracteristica.prueflos = ordem.batch_number
      and caracteristica.vorglfnr = operacao.step_numerator

    left outer join qmih                          as aviso
      on ordem.solicitation = aviso.qmnum
      
    left outer join qmel                          as qualidade
      on ordem.solicitation = qualidade.qmnum

    left outer join iloa                          as localizacao
      on aviso.iloan = localizacao.iloan

    left outer join /SPROLIMS/CDS_A_REPRESENTATIV as representatividade
      on  representatividade.matnr = aviso.bautl
      and representatividade.werks = qualidade.werk
      and representatividade.charg = qualidade.prod_charg
      and representatividade.aufnr = qualidade.prod_aufnr

    left outer join /SPROLIMS/CDS_C_ERP_USER_INFO as user_info
      on caracteristica.aenderer = user_info.erp_user

  association [1] to qave as du
    on du.prueflos = caracteristica.prueflos

  {
    key ordem.order_id,
    key operacao.order_step_id,
    key caracteristica.vorglfnr,
    key caracteristica.merknr,
    key caracteristica.verwmerkm,
    ordem.solicitation,
    ordem.batch_number,
    ordem.plant,
    operacao.step_description,
    operacao.order_step_plant,
    operacao.work_center,
    caracteristica.prueflos,
    caracteristica.kurztext,
    caracteristica.sollstpumf,
    caracteristica.erstelldat,
    caracteristica.formel1,
    caracteristica.katalgart1,
    caracteristica.auswmenge1,
    caracteristica.katalgart2,
    caracteristica.auswmenge2,
    case when du.prueflos = caracteristica.prueflos then 'X' else '' end as has_du,
    caracteristica.aenderer,
    user_info.full_name,
    localizacao.tplnr,
    representatividade.erfme as unidade_repres,
    representatividade.erfmg as valor_reprs

  }
  where
    operacao.work_center = 'TZ'
