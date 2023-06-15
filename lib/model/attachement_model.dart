class Attachment {
  String? fileName;
  String? datas;

  Attachment({ this.fileName, this.datas});

  Attachment.fromJson(Map<String, dynamic> json) {
    fileName = json['file_name'];
    datas = json['datas'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file_name'] = this.fileName;
    data['datas'] = this.datas;
    return data;
  }
}
