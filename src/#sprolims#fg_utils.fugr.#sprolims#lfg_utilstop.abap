FUNCTION-POOL /SPROLIMS/FG_UTILS.           "MESSAGE-ID ..

DATA: v_done            TYPE abap_bool,
      v_batch           TYPE bapibatchkey-batch,
      vg_werks_org      TYPE t001w-werks,
      vg_dep_org        TYPE lgort_d,
      vg_werks          TYPE werks_d,
      vg_dep_prod       TYPE lgort_d,
      vg_bukrs          TYPE t001-bukrs,
      w_batchattributes TYPE bapibatchatt,
      t_return          TYPE bapiret2_t.

* INCLUDE /SPROLIMS/LFG_UTILSD...            " Local class definition
