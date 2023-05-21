class Book {
  String? academic;
  int? rang;
  List<Attachments>? attachments;
  double? average;
  String? period;
  String? Class;

  Book(
      {this.academic,
      this.rang,
      this.attachments,
      this.average,
      this.period,
      this.Class});

  Book.fromJson(Map<String, dynamic> json) {
    academic = json['academic'];
    rang = json['rang'];
    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(new Attachments.fromJson(v));
      });
    }
    average = json['average'];
    period = json['period'];
    Class = json['class'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['academic'] = this.academic;
    data['rang'] = this.rang;
    if (this.attachments != null) {
      data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    }
    data['average'] = this.average;
    data['period'] = this.period;
    data['class'] = this.Class;
    return data;
  }
}

class Attachments {
  String? fileName;
  int? id;

  Attachments({this.fileName, this.id});

  Attachments.fromJson(Map<String, dynamic> json) {
    fileName = json['file_name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file_name'] = this.fileName;
    data['id'] = this.id;
    return data;
  }
}
