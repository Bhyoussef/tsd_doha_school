class MessageSent {
  String? name;
  String? fileName;
  String? message;
  String? managerId;
  String? receiver;
  String? date;
  String? model;
  int? id;
  String? uploadFile;

  MessageSent({
    this.name,
    this.fileName,
    this.message,
    this.managerId,
    this.receiver,
    this.date,
    this.model,
    this.id,
    this.uploadFile,
  });

  MessageSent.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    fileName = json['file_name'].toString();
    message = json['message'];
    //managerId = json['manager_id'] as String?;
    receiver = json['receiver'];
    date = json['date'];
    model = json['model'];
    id = json['id'];
    //uploadFile = json['upload_file'] as String?; // Updated type to String
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['file_name'] = fileName;
    data['message'] = message;
    data['manager_id'] = managerId;
    data['receiver'] = receiver;
    data['date'] = date;
    data['model'] = model;
    data['id'] = id;
    //data['upload_file'] = uploadFile;
    return data;
  }
}
