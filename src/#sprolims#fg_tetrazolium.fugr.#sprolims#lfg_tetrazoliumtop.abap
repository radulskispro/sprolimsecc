FUNCTION-POOL /sprolims/fg_tetrazolium.     "MESSAGE-ID ..

* INCLUDE /SPROLIMS/LFG_TETRAZOLIUMD...      " Local class definition

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
         order_id         TYPE /sprolims/cdsaos-order_id,
         solicitation     TYPE /sprolims/cdsaos-solicitation,
         batch_number     TYPE /sprolims/cdsaos-batch_number,
         order_step_id    TYPE /sprolims/cdsaos-order_step_id,
         order_step_plant TYPE /sprolims/cdsaos-order_step_plant,
         work_center      TYPE /sprolims/cdsaos-work_center,
       END OF y_operac_data.

DATA: t_operac_data TYPE TABLE OF y_operac_data.

TYPES: BEGIN OF y_charac_data,
         prueflos              TYPE /sprolims/cdsao2-prueflos,
         vorglfnr              TYPE /sprolims/cdsao2-vorglfnr,
         merknr                TYPE /sprolims/cdsao2-merknr,
         verwmerkm             TYPE /sprolims/cdsao2-verwmerkm,
         kurztext              TYPE /sprolims/cdsao2-kurztext,
         sollstpumf            TYPE /sprolims/cdsao2-sollstpumf,
         inspspecrecordingtype TYPE /sprolims/cdsao2-inspspecrecordingtype,
         formel1               TYPE /sprolims/cdsao2-formel1,
         katalgart1            TYPE /sprolims/cdsao2-katalgart1,
         auswmenge1            TYPE /sprolims/cdsao2-auswmenge1,
         katalgart2            TYPE /sprolims/cdsao2-katalgart2,
         auswmenge2            TYPE /sprolims/cdsao2-auswmenge2,
         order_id              TYPE /sprolims/cdsao2-order_id,
         order_step_id         TYPE /sprolims/cdsao2-order_step_id,
         step_description      TYPE /sprolims/cdsao2-step_description,
         work_center           TYPE /sprolims/cdsao2-work_center,
         order_step_plant      TYPE /sprolims/cdsao2-order_step_plant,
         tplnr                 TYPE /sprolims/cdsao2-tplnr,
*--------campos que não serão selecionados no select, mas que para facilitar já estão na tabela
         fieldname             TYPE lvc_fname,
         position              TYPE n LENGTH 2,
         control_unit_position TYPE i,
         value                 TYPE n LENGTH 3,
       END OF y_charac_data.

DATA: t_charac_data      TYPE TABLE OF y_charac_data,
      t_charac_data_full TYPE TABLE OF y_charac_data.

DATA: lw_charac LIKE LINE OF t_charac.
