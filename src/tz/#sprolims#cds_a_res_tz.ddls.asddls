@AbapCatalog.sqlViewName: '/SPROLIMS/CDSART'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Auxiliar - Resultados Tetrazólio'
define view
  /SPROLIMS/CDS_A_RES_TZ
  as select from    qals                       as lote_controle

    inner join      /SPROLIMS/CDS_A_CHA_RES_TZ as vigor
      on  vigor.prueflos = lote_controle.prueflos
      and vigor.werks    = lote_controle.werk
      and vigor.caract   = 'V1'

    left outer join /SPROLIMS/CDS_A_CHA_RES_TZ as viavel
      on  viavel.prueflos = lote_controle.prueflos
      and viavel.werks    = lote_controle.werk
      and viavel.caract   = 'V2'

    left outer join /SPROLIMS/CDS_A_CHA_RES_TZ as dm_4_5
      on  dm_4_5.prueflos = lote_controle.prueflos
      and dm_4_5.werks    = lote_controle.werk
      and dm_4_5.caract   = 'V3'

    left outer join /SPROLIMS/CDS_A_CHA_RES_TZ as dm_6_8
      on  dm_6_8.prueflos = lote_controle.prueflos
      and dm_6_8.werks    = lote_controle.werk
      and dm_6_8.caract   = 'V4'

    left outer join /SPROLIMS/CDS_A_CHA_RES_TZ as dm_1_8
      on  dm_1_8.prueflos = lote_controle.prueflos
      and dm_1_8.werks    = lote_controle.werk
      and dm_1_8.caract   = 'V5'

    left outer join /SPROLIMS/CDS_A_CHA_RES_TZ as du_4_5
      on  du_4_5.prueflos = lote_controle.prueflos
      and du_4_5.werks    = lote_controle.werk
      and du_4_5.caract   = 'V6'

    left outer join /SPROLIMS/CDS_A_CHA_RES_TZ as du_6_8
      on  du_6_8.prueflos = lote_controle.prueflos
      and du_6_8.werks    = lote_controle.werk
      and du_6_8.caract   = 'V7'

    left outer join /SPROLIMS/CDS_A_CHA_RES_TZ as du_1_8
      on  du_1_8.prueflos = lote_controle.prueflos
      and du_1_8.werks    = lote_controle.werk
      and du_1_8.caract   = 'V8'

    left outer join /SPROLIMS/CDS_A_CHA_RES_TZ as dp_4_5
      on  dp_4_5.prueflos = lote_controle.prueflos
      and dp_4_5.werks    = lote_controle.werk
      and dp_4_5.caract   = 'V9'

    left outer join /SPROLIMS/CDS_A_CHA_RES_TZ as dp_6_8
      on  dp_6_8.prueflos = lote_controle.prueflos
      and dp_6_8.werks    = lote_controle.werk
      and dp_6_8.caract   = 'V10'

    left outer join /SPROLIMS/CDS_A_CHA_RES_TZ as dp_1_8
      on  dp_1_8.prueflos = lote_controle.prueflos
      and dp_1_8.werks    = lote_controle.werk
      and dp_1_8.caract   = 'V11'

    left outer join /SPROLIMS/CDS_A_CHA_RES_TZ as dn_1
      on  dn_1.prueflos = lote_controle.prueflos
      and dn_1.werks    = lote_controle.werk
      and dn_1.caract   = 'V12'

    left outer join /SPROLIMS/CDS_A_CHA_RES_TZ as dn_2
      on  dn_2.prueflos = lote_controle.prueflos
      and dn_2.werks    = lote_controle.werk
      and dn_2.caract   = 'V13'

    left outer join /SPROLIMS/CDS_A_CHA_RES_TZ as dn_3
      on  dn_3.prueflos = lote_controle.prueflos
      and dn_3.werks    = lote_controle.werk
      and dn_3.caract   = 'V14'

    left outer join /SPROLIMS/CDS_A_CHA_RES_TZ as dn_3r
      on  dn_3r.prueflos = lote_controle.prueflos
      and dn_3r.werks    = lote_controle.werk
      and dn_3r.caract   = 'V15'

    left outer join /SPROLIMS/CDS_A_CHA_RES_TZ as dn_sd
      on  dn_sd.prueflos = lote_controle.prueflos
      and dn_sd.werks    = lote_controle.werk
      and dn_sd.caract   = 'V16'

    left outer join /SPROLIMS/CDS_A_CHA_RES_TZ as outras_sementes
      on  outras_sementes.prueflos = lote_controle.prueflos
      and outras_sementes.werks    = lote_controle.werk
      and outras_sementes.caract   = 'V17'

    left outer join /SPROLIMS/CDS_A_CHA_RES_TZ as grau_umidade
      on  grau_umidade.prueflos = lote_controle.prueflos
      and grau_umidade.werks    = lote_controle.werk
      and grau_umidade.caract   = 'V18'

    left outer join /SPROLIMS/CDS_A_CHA_RES_TZ as sementes_esverdeadas
      on  sementes_esverdeadas.prueflos = lote_controle.prueflos
      and sementes_esverdeadas.werks    = lote_controle.werk
      and sementes_esverdeadas.caract   = 'V19'
      
    left outer join /SPROLIMS/CDS_A_CHA_RES_TZ as mancha_purpura
      on  mancha_purpura.prueflos = lote_controle.prueflos
      and mancha_purpura.werks    = lote_controle.werk
      and mancha_purpura.caract   = 'V20'  

  {
    lote_controle.prueflos,
    lote_controle.aufnr,
    right(lote_controle.num_amostra, 4) as sample_number,
    lote_controle.werk as centro,
    vigor.result_value as vigor,
    viavel.result_value as viavel,
    dm_4_5.result_value as dm_4_5,
    dm_6_8.result_value as dm_6_8,
    dm_1_8.result_value as dm_1_8,
    dm_1_8.vorglfnr,
    dm_1_8.merknr,
    dm_1_8.probenr,
    dm_1_8.pruefbemkt,
    du_4_5.result_value as du_4_5,
    du_6_8.result_value as du_6_8,
    du_1_8.result_value as du_1_8,
    dp_4_5.result_value as dp_4_5,
    dp_6_8.result_value as dp_6_8,
    dp_1_8.result_value as dp_1_8,
    dn_1.result_value as dn_1,
    dn_2.result_value as dn_2,
    dn_3.result_value as dn_3,
    dn_3r.result_value as dn_3r,
    dn_sd.result_value as dn_sd,
    outras_sementes.result_value as outras_sementes,
    grau_umidade.result_value as grau_umidade,
    sementes_esverdeadas.result_value as sementes_esverdeadas,
    mancha_purpura.result_value as mancha_purpura

  }
