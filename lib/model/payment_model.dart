class Payment {
  String? currency;
  String? totPaid;
  String? totUnpaid;

  Payment({this.currency, this.totPaid, this.totUnpaid});

  Payment.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    totPaid = json['tot_paid'];
    totUnpaid = json['tot_unpaid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency'] = this.currency;
    data['tot_paid'] = this.totPaid;
    data['tot_unpaid'] = this.totUnpaid;
    return data;
  }
}
