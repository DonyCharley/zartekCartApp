class CartItemList {
  String cARTID;
  String cARTREFNO;
  String cARTDATE;
  String bRANCHID;
  String cOMPNAME;
  String cARTDTLSSLNO;
  String iTEMID;
  String iTEMNAME;
  String cARTQTY;
  String cARTUNITID;
  String uNITNAME;
  String uNITCODE;
  String cARTRATE;
  String iTEMTOTAL;

  CartItemList(
      {this.cARTID,
      this.cARTREFNO,
      this.cARTDATE,
      this.bRANCHID,
      this.cOMPNAME,
      this.cARTDTLSSLNO,
      this.iTEMID,
      this.iTEMNAME,
      this.cARTQTY,
      this.cARTUNITID,
      this.uNITNAME,
      this.uNITCODE,
      this.cARTRATE,
      this.iTEMTOTAL});

  CartItemList.fromJson(Map<String, dynamic> json) {
    cARTID = json['CART_ID'];
    cARTREFNO = json['CART_REF_NO'];
    cARTDATE = json['CART_DATE'];
    bRANCHID = json['BRANCH_ID'];
    cOMPNAME = json['COMP_NAME'];
    cARTDTLSSLNO = json['CART_DTLS_SLNO'];
    iTEMID = json['ITEM_ID'];
    iTEMNAME = json['ITEM_NAME'];
    cARTQTY = json['CART_QTY'];
    cARTUNITID = json['CART_UNIT_ID'];
    uNITNAME = json['UNIT_NAME'];
    uNITCODE = json['UNIT_CODE'];
    cARTRATE = json['CART_RATE'];
    iTEMTOTAL = json['ITEM_TOTAL'];
  }
}
