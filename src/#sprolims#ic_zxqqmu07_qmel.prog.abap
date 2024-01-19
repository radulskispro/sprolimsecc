*&---------------------------------------------------------------------*
*&  Include  /SPROLIMS/IC_ZXQQMU07_QMEL
*&---------------------------------------------------------------------*
qmel-/sprolims/otkat  = viqmel-/sprolims/otkat.
qmel-/sprolims/otgrp  = viqmel-/sprolims/otgrp.
qmel-/sprolims/oteil  = viqmel-/sprolims/oteil.
qmel-datacoleta       = viqmel-datacoleta.
qmel-horacoleta       = viqmel-horacoleta.
qmel-temperatura      = viqmel-temperatura.
qmel-mseh6            = viqmel-mseh6.
qmel-gebindetyp       = viqmel-gebindetyp.
qmel-prod_aufnr       = viqmel-prod_aufnr.
qmel-prod_charg       = viqmel-prod_charg.
qmel-prod_kostl       = viqmel-prod_kostl.
qmel-werk             = viqmel-werk.
qmel-temp_receb       = viqmel-temp_receb.
qmel-temp_receb_meins = viqmel-temp_receb_meins.
qmel-tanque_dest      = viqmel-tanque_dest.
qmel-local_coleta     = viqmel-local_coleta.

SELECT SINGLE kurztext
  FROM qpgt
  INTO qpgt-kurztext
  WHERE katalogart = qmel-/sprolims/otkat AND
        codegruppe = qmel-/sprolims/otgrp AND
        sprache    = sy-langu.

SELECT SINGLE kurztext
  FROM tq42t
  INTO tq42t-kurztext
  WHERE gebindetyp = qmel-gebindetyp AND
        sprache = sy-langu.

SELECT SINGLE ktext
  FROM cskt
  INTO cskt-ktext
  WHERE kostl = qmel-prod_kostl AND
        spras = sy-langu.

qmel-estab_sif   = viqmel-estab_sif.
qmel-lacre       = viqmel-lacre.
qmel-req_legais  = viqmel-req_legais.
qmel-otkat_categ = viqmel-otkat_categ.
qmel-otgrp_categ = viqmel-otgrp_categ.
qmel-oteil_categ = viqmel-oteil_categ.

SELECT SINGLE kurztext
  FROM qpgt
  INTO tx_kurztext_cat
  WHERE katalogart = qmel-otkat_categ AND
        codegruppe = qmel-otgrp_categ AND
        sprache    = sy-langu.

qmel-formcol  = viqmel-formcol.
qmel-ciclo    = viqmel-ciclo.
qmel-sexo     = viqmel-sexo.
qmel-cama     = viqmel-cama.
qmel-linhagem = viqmel-linhagem.
qmel-safra    = viqmel-safra.

v_aktyp = i_aktyp.

IF i_aktyp = 'H'.

  IF qmel-datacoleta IS INITIAL.
    qmel-datacoleta  = sy-datum.
  ENDIF.
  IF qmel-horacoleta IS INITIAL.
    qmel-horacoleta  = sy-uzeit.
  ENDIF.

  qmel-quan_env_unit = viqmel-quan_env_unit.
  qmel-quan_env = viqmel-quan_env.

ENDIF.

qmel-amostra_definitiva = viqmel-amostra_definitiva.
qmel-peneira            = viqmel-peneira.
qmel-cultivar           = viqmel-cultivar.
qmel-especie            = viqmel-especie.
qmel-categoria          = viqmel-categoria.
qmel-inf_result         = viqmel-inf_result.
qmel-sem_tratada        = viqmel-sem_tratada.
qmel-representatividade_kg = viqmel-representatividade_kg.
qmel-representatividade_bb = viqmel-representatividade_bb.
qmel-campo              = viqmel-campo.
qmel-talhao             = viqmel-talhao.
qmel-fazenda            = viqmel-fazenda.
qmel-cultivar_campo     = viqmel-cultivar_campo.
qmel-observacao_long    = viqmel-observacao_long.
qmel-tipo_coleta        = viqmel-tipo_coleta.
