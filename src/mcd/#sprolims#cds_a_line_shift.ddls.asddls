@AbapCatalog.sqlViewName: '/SPROLIMS/CDSLST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Linha e Turno'

@VDM.viewType: #CONSUMPTION

@OData.entitySet.name: 'LineShiftSet'


define view /SPROLIMS/CDS_A_LINE_SHIFT as select from /sprolims/tccodp as tccodp
left outer join /sprolims/tccode as tccode
    on tccode.otgrp = tccodp.otgrp {
    
    key tccode.otgrp as code_group,
    key tccodp.oteil as code,
        tccode.descr_otgrp as code_group_description,
        tccodp.descr_oteil as code_description 
    
}
where tccode.otkat = '2'
