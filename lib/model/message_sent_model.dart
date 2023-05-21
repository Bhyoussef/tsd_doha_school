import 'dart:io';

class MessageSent {
  String? name;
  String? fileName;
  String? message;
  String? managerId;
  String? receiver;
  String? date;
  String? model;
  int? id;
  File? uploadFile;

  MessageSent(
      {this.name,
        this.fileName,
        this.message,
        //this.managerId,
        this.receiver,
        this.date,
        this.model,
        this.id,
        this.uploadFile});

  MessageSent.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    fileName = json['file_name'].toString();
    message = json['message'];
    managerId = json['manager_id'].toString();
    receiver = json['receiver'];
    date = json['date'];
    model = json['model'];
    id = json['id'];
    uploadFile = json['upload_file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['file_name'] = this.fileName;
    data['message'] = this.message;
    data['manager_id'] = this.managerId.toString();
    data['receiver'] = this.receiver;
    data['date'] = this.date;
    data['model'] = this.model;
    data['id'] = this.id;
    data['upload_file'] = this.uploadFile;
    return data;
  }
}
