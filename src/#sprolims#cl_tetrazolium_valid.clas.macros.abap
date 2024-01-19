*"* use this source file for any macro definitions you need
*"* in the implementation part of the class
DEFINE rex.
  RAISE EXCEPTION TYPE &1
    EXPORTING
      textid = VALUE #(
        msgid = sy-msgid
        msgno = sy-msgno
        attr1 = sy-msgv1
        attr2 = sy-msgv2
        attr3 = sy-msgv3
        attr4 = sy-msgv4
      ).
END-OF-DEFINITION.
