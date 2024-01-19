*&---------------------------------------------------------------------*
*& Include          ZRQM_ENTRADA_RESULTADO_TAB_TOP
*&---------------------------------------------------------------------*

TABLES: aufk, afvc, qamv, crhd, /SPROLIMS/ZCDSQR.

TYPES: BEGIN OF y_charac,
         vorglfnr              TYPE qamv-vorglfnr,
         merknr                TYPE qamv-merknr,
         verwmerkm             TYPE qamv-verwmerkm,
         control_unit_position TYPE i,
         fieldname             TYPE  lvc_fname,
         kurztext              TYPE qamv-kurztext,
         has_f4                TYPE flag,
       END OF y_charac.

DATA: t_charac TYPE TABLE OF y_charac.

TYPES: BEGIN OF y_operac_data,
         order_id                TYPE /SPROLIMS/ZCDSQR-order_id,
         solicitation            TYPE /SPROLIMS/ZCDSQR-solicitation,
         batch_number            TYPE /SPROLIMS/ZCDSQR-batch_number,
         order_step_id           TYPE /SPROLIMS/ZCDSQR-order_step_id,
         order_step_plant        TYPE /SPROLIMS/ZCDSQR-order_step_plant,
         work_center             TYPE /SPROLIMS/ZCDSQR-work_center,
         production_batch_number TYPE /SPROLIMS/ZCDSQR-production_batch_number,
         sample_number           TYPE /SPROLIMS/ZCDSQR-sample_number,
       END OF y_operac_data.

DATA: t_operac_data TYPE TABLE OF y_operac_data.

TYPES: BEGIN OF y_charac_data,
         prueflos                TYPE /SPROLIMS/ZCDCR-prueflos,
         vorglfnr                TYPE /SPROLIMS/ZCDCR-vorglfnr,
         merknr                  TYPE /SPROLIMS/ZCDCR-merknr,
         verwmerkm               TYPE /SPROLIMS/ZCDCR-verwmerkm,
         kurztext                TYPE /SPROLIMS/ZCDCR-kurztext,
         sollstpumf              TYPE /SPROLIMS/ZCDCR-sollstpumf,
         inspspecrecordingtype   TYPE /SPROLIMS/ZCDCR-inspspecrecordingtype,
         formel1                 TYPE /SPROLIMS/ZCDCR-formel1,
         katalgart1              TYPE /SPROLIMS/ZCDCR-katalgart1,
         auswmenge1              TYPE /SPROLIMS/ZCDCR-auswmenge1,
         katalgart2              TYPE /SPROLIMS/ZCDCR-katalgart2,
         auswmenge2              TYPE /SPROLIMS/ZCDCR-auswmenge2,
         order_id                TYPE /SPROLIMS/ZCDCR-order_id,
         order_step_id           TYPE /SPROLIMS/ZCDCR-order_step_id,
         step_description        TYPE /SPROLIMS/ZCDCR-step_description,
         work_center             TYPE /SPROLIMS/ZCDCR-work_center,
         order_step_plant        TYPE /SPROLIMS/ZCDCR-order_step_plant,
         tplnr                   TYPE /SPROLIMS/ZCDCR-tplnr,
         production_batch_number TYPE /SPROLIMS/ZCDCR-production_batch_number,
         sample_number           TYPE /SPROLIMS/ZCDCR-sample_number,
*--------campos que não serão selecionados no select, mas que para facilitar já estão na tabela
         fieldname               TYPE lvc_fname,
         position                TYPE n LENGTH 2,
         control_unit_position   TYPE i,
       END OF y_charac_data.

TYPES: BEGIN OF y_check_commit,
         aufnr TYPE aufnr,
         vornr TYPE vornr,
         date  TYPE qpruefdatv,
         hour  TYPE qpruefztv,
       END OF y_check_commit.

DATA: t_charac_data         TYPE TABLE OF y_charac_data,
      t_charac_data_full    TYPE TABLE OF y_charac_data,
      t_results             TYPE TABLE OF qasr,
      t_message_tab         TYPE esp1_message_tab_type,
      t_message_has_results TYPE esp1_message_tab_type,
      t_check_commit        TYPE TABLE OF y_check_commit,
      t_tccde               TYPE TABLE OF /sprocsem/tccde.

**********************************************************************
** ALV
**********************************************************************
DATA: t_fieldcat   TYPE lvc_t_fcat,
      t_fieldcat_1 TYPE lvc_t_fcat,
      t_sort       TYPE lvc_t_sort,
      t_exclude    TYPE ui_functions.

DATA: w_exclude  TYPE ui_func,
      w_variant  TYPE disvariant,
      w_layout   TYPE lvc_s_layo,
      w_fieldcat LIKE LINE OF t_fieldcat,
      w_sort     LIKE LINE OF t_sort.

DATA: o_container TYPE REF TO cl_gui_custom_container,
      o_grid      TYPE REF TO cl_gui_alv_grid.

**********************************************************************
** ALV - Subscreen
**********************************************************************


DATA: t_defects TYPE TABLE OF /SPROLIMS/STQM_ALV_ENT_RES_DEF.
DATA: t_defects_dialog TYPE TABLE OF /SPROLIMS/STQM_ALV_ENT_RES_DEF.

DATA: o_dialogbox_cont TYPE REF TO cl_gui_dialogbox_container,
      o_dialogbox_grid TYPE REF TO cl_gui_alv_grid.

DATA: v_dialogbox_status TYPE c.


DATA: t_dialogbox_fieldcat  TYPE lvc_t_fcat.

DATA: o_fcat_dialogbox TYPE REF TO cl_salv_table,
      o_aggr_dialogbox TYPE REF TO cl_salv_aggregations,
      o_cols_dialogbox TYPE REF TO cl_salv_columns_table.

DATA: w_dialogbox_layout     TYPE lvc_s_layo.

DATA: v_prueflos TYPE qmel-prueflos.

**********************************************************************
** Tabela Dinâmica
**********************************************************************

FIELD-SYMBOLS: <ft_alv> TYPE STANDARD TABLE,
               <fw_alv> TYPE any.

DATA: dyn_table TYPE REF TO data,
      dyn_line  TYPE REF TO data,
      ok_code   TYPE sy-ucomm.

TYPES: BEGIN OF y_column,
         result TYPE c LENGTH 15,
       END OF y_column.

DATA: t_column TYPE y_column.

DATA:   gt_rsparams  TYPE TABLE OF rsparams.

**********************************************************************
** ALV Variant
**********************************************************************
DATA  gv_repname          LIKE sy-repid.
DATA  gv_x_variant        LIKE disvariant.
DATA  gv_exit(1)          TYPE c.
DATA  gv_save(1)          TYPE c.
DATA  gv_variant          LIKE disvariant.

**********************************************************************
**  Log
**********************************************************************
DATA: v_log_handle TYPE  balloghndl.
