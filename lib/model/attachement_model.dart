class Attachment {
  //String? fileType;
  String? fileName;
  //String? type;
  String? datas;

  Attachment({ this.fileName, this.datas});

  Attachment.fromJson(Map<String, dynamic> json) {
    //fileType = json['file_type'];
    fileName = json['file_name'];
   // type = json['type'];
    datas = json['datas'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['file_type'] = this.fileType;
    data['file_name'] = this.fileName;
    //data['type'] = this.type;
    data['datas'] = this.datas;
    return data;
  }
}
