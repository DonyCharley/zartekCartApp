class ItemList {
  String iTEMNAME;
  String iTEMID;
  String uNITID;
  String uNITNAME;
  String uNITCODE;
  String rEORDERLEVEL;
  String sALERATE;
  String cURRENTSTOCK;
  int qty = 0;

  ItemList(
      {this.iTEMNAME,
      this.iTEMID,
      this.uNITID,
      this.uNITNAME,
      this.uNITCODE,
      this.rEORDERLEVEL,
      this.sALERATE,
      this.cURRENTSTOCK});

  ItemList.fromJson(Map<String, dynamic> json) {
    iTEMNAME = json['ITEM_NAME'];
    iTEMID = json['ITEM_ID'];
    uNITID = json['UNIT_ID'];
    uNITNAME = json['UNIT_NAME'];
    uNITCODE = json['UNIT_CODE'];
    rEORDERLEVEL = json['REORDER_LEVEL'];
    sALERATE = json['SALE_RATE'];
    cURRENTSTOCK = json['CURRENT_STOCK'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ITEM_NAME'] = this.iTEMNAME;
    data['ITEM_ID'] = this.iTEMID;
    data['UNIT_ID'] = this.uNITID;
    data['UNIT_NAME'] = this.uNITNAME;
    data['UNIT_CODE'] = this.uNITCODE;
    data['REORDER_LEVEL'] = this.rEORDERLEVEL;
    data['SALE_RATE'] = this.sALERATE;
    data['CURRENT_STOCK'] = this.cURRENTSTOCK;
    return data;
  }
}
