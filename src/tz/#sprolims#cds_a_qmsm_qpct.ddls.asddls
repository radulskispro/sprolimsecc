@AbapCatalog.sqlViewName: '/SPROLIMS/CDSQQT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Associação da Tabela QPCT com a QMSM'
define view /SPROLIMS/CDS_A_QMSM_QPCT  as select from qmsm as grupoanalise inner join qpct as metodologia on  metodologia.codegruppe = grupoanalise.mngrp
                                                                        and metodologia.code       = grupoanalise.mncod
                                                                        and metodologia.sprache    = 'P'
                                                                        and metodologia.katalogart = grupoanalise.mnkat
{

grupoanalise.qmnum,
metodologia.kurztext

}



