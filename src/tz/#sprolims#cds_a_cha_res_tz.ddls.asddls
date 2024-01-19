@AbapCatalog.sqlViewName: '/SPROLIMS/CDSCRT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Auxiliar - Characteristic Result - TZ'
define view
  /SPROLIMS/CDS_A_CHA_RES_TZ
  as
  // *****************************************************************************
  // SPRO IT Solutions
  // Developer: SPR_VIEIRAA - Allan Costa Vieira
  // *****************************************************************************
  select distinct from       qasr                           as qasr

    inner join      /SPROLIMS/CDS_A_QASR_M_PROBENR as max_probenr
      on  max_probenr.prueflos = qasr.prueflos
      and max_probenr.probenr  = qasr.probenr
      
    inner join crhd as crhd
    on  crhd.arbpl = 'TZ'

    inner join qals as qals
    on  qals.prueflos = qasr.prueflos

    inner join afvc as afvc
    on  afvc.aufpl = qals.aufpl
    and afvc.arbid = crhd.objid
    
    inner join qasr                    as qasr_2
    on qasr.vorglfnr = afvc.aplzl
    
    
    inner join      /sprolims/tdc                  as tz_custom
          on tz_custom.werks = qals.werk
        
    inner join      qamv                           as qamv
      on  qamv.verwmerkm = tz_custom.verwmerkm
      and qamv.prueflos = qasr.prueflos
      and qamv.vorglfnr = afvc.aplzl
      and qamv.merknr   = qasr.merknr

    left outer join qpct                           as qpct_qasr
      on  qpct_qasr.katalogart = qasr.katalgart1
      and qpct_qasr.codegruppe = qasr.gruppe1
      and qpct_qasr.code       = qasr.code1
      and qpct_qasr.version    = qasr.version1
      and qpct_qasr.sprache    = 'P'
      
   {
    key qasr.prueflos,
    key qasr.vorglfnr,
    key qasr.merknr,
    qasr.probenr,
    qasr.pruefbemkt,
    tz_custom.werks,
    tz_custom.caract,
    tz_custom.work_center,
    qamv.verwmerkm,    
    qasr.attribut,
    fltp_to_dec( qasr.mittelwert as abap.dec(10,0) )  as result_value,
    qpct_qasr.kurztext
  } //group by qasr.prueflos, qasr.vorglfnr, qasr.merknr, qamv.verwmerkm, tz_custom.werks, tz_custom.caract, tz_custom.work_center, qasr.attribut, qasr.mittelwert, qpct_qasr.kurztext
//union select from qase as qase
//
//    inner join qamv as qamv
//     on qamv.prueflos   = qase.prueflos and
//        qamv.vorglfnr   = qase.vorglfnr and
//        qamv.merknr     = qase.merknr
//
//    inner join /sprolims/tdc as tz_custom
//     on tz_custom.verwmerkm = qamv.verwmerkm
//
//  left outer join qpct as qpct_qase
//    on  qpct_qase.katalogart = qase.katalgart1
//    and qpct_qase.codegruppe = qase.gruppe1
//    and qpct_qase.code       = qase.code1
//    and qpct_qase.version    = qase.version1
//    and qpct_qase.sprache    = 'P'
//  {
//    key qase.prueflos,
//    key qase.vorglfnr,
//    key qase.merknr,
//    key max(qase.probenr) as probenr,
//    qamv.verwmerkm,
//    tz_custom.werks,
//    tz_custom.caract,
//    tz_custom.work_center,
//    qase.attribut,
//    fltp_to_dec( qase.messwert as abap.dec(10,0) ) as result_value,
//    qpct_qase.kurztext
//  }group by qase.prueflos, qase.vorglfnr, qase.merknr, qamv.verwmerkm, tz_custom.werks, tz_custom.caract, tz_custom.work_center, qase.attribut, qase.messwert, qpct_qase.kurztext
