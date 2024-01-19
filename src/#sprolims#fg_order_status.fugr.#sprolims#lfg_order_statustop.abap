FUNCTION-POOL /sprolims/fg_order_status.    "MESSAGE-ID ..

* INCLUDE /SPROLIMS/LFG_ORDER_STATUSD...     " Local class definition

DATA: t_timetickets   TYPE TABLE OF bapi_alm_timeconfirmation,
      t_goodsmvt_item TYPE TABLE OF bapi2017_gm_item_create,
      t_return        TYPE  bapiret2_t.
