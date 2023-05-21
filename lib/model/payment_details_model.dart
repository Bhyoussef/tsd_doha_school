class PaymentDetails {
  int? idLine;
  String? studentId;
  double? priceUnit;
  String? period;
  String? currency;
  String? year;
  String? stateYear;
  String? type;
  String? groupId;

  PaymentDetails(
      {this.idLine,
        this.studentId,
        this.priceUnit,
        this.period,
        this.currency,
        this.year,
        this.stateYear,
        this.type,
        this.groupId});

  PaymentDetails.fromJson(Map<String, dynamic> json) {
    idLine = json['id_line'];
    studentId = json['student_id'];
    priceUnit = json['price_unit'];
    period = json['period'];
    currency = json['currency'];
    year = json['year'];
    stateYear = json['state_year'];
    type = json['Type'];
    groupId = json['group_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_line'] = this.idLine;
    data['student_id'] = this.studentId;
    data['price_unit'] = this.priceUnit;
    data['period'] = this.period;
    data['currency'] = this.currency;
    data['year'] = this.year;
    data['state_year'] = this.stateYear;
    data['Type'] = this.type;
    data['group_id'] = this.groupId;
    return data;
  }
}
