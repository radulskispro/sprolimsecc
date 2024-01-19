@AbapCatalog.sqlViewName: '/SPROLIMS/CDSRTZ'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Relatório - Resultados - Tetrazólio'
define view /SPROLIMS/CDS_C_REL_TZ
  as select from qmel as solicitacao
  
  association [1] to /SPROLIMS/CDS_A_QMSM_QPCT                   as grupoanalise           on  grupoanalise.qmnum = solicitacao.qmnum  
 
  association [1] to qpct                     as tipoanalise            on  tipoanalise.codegruppe = solicitacao.qmgrp
                                                                        and tipoanalise.code       = solicitacao.qmcod
                                                                        and tipoanalise.sprache    = 'P'
                                                                        and tipoanalise.katalogart = solicitacao.qmkat


  association [1] to /SPROLIMS/CDS_A_PRODUCER as produtor               on  produtor.objnr = solicitacao.objnr

  association [1] to /SPROLIMS/CDS_A_RES_TZ   as resultados             on  resultados.aufnr = solicitacao.aufnr

  association [1] to /sprolims/tb_cf1         as sol_type_configuration on  sol_type_configuration.werks    =  resultados.centro
                                                                        and sol_type_configuration.cut_date <= solicitacao.erdat
                                                                        and sol_type_configuration.qmart    =  solicitacao.qmart

{
  key solicitacao.qmnum                                                   as solicitation_id,
      solicitacao.qmtxt                                                   as solicitation_description,
      solicitacao.aufnr                                                   as order_id,
      concat( concat( tipoanalise.kurztext, '-' ), grupoanalise.kurztext  ) as tipo_analise,
      solicitacao.datacoleta,
      solicitacao.erdat,
      solicitacao.qmart,
      solicitacao.prod_charg                                              as prod_charg,
      solicitacao.talhao,
      solicitacao.cultivar,
      solicitacao.peneira,
      solicitacao.order_service,
      solicitacao.qmtxt,
      solicitacao.faixa_umidade,
      produtor.nome_produtor,
      resultados[inner].prueflos                                          as batch_number,
      resultados.sample_number,
      resultados.aufnr,
      resultados.centro,
      resultados.vigor,
      resultados.vorglfnr,
      resultados.merknr,
      resultados.probenr,
      resultados.pruefbemkt,
      resultados.viavel,
      resultados.dm_4_5,
      resultados.dm_6_8,
      resultados.dm_1_8,
      resultados.du_4_5,
      resultados.du_6_8,
      resultados.du_1_8,
      resultados.dp_4_5,
      resultados.dp_6_8,
      resultados.dp_1_8,
      resultados.dn_1,
      resultados.dn_2,
      resultados.dn_3,
      resultados.dn_3r,
      resultados.dn_sd,
      resultados.outras_sementes,
      resultados.grau_umidade,
      resultados.sementes_esverdeadas,
      resultados.mancha_purpura

}
