class SendMessage {
  List<String>? attachmentName;
  String? displayName;
  List<String>? attachmentIds;
  String? date;
  String? authorId;
  String? message;
  int? id;

  SendMessage(
      {this.attachmentName,
        this.displayName,
        this.attachmentIds,
        this.date,
        this.authorId,
        this.message,
        this.id});

  SendMessage.fromJson(Map<String, dynamic> json) {
    attachmentName = json['attachment_name'].cast<String>();
    displayName = json['display_name'];
    attachmentIds = json['attachment_ids'].cast<String>();
    date = json['date'];
    authorId = json['author_id'];
    message = json['message'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attachment_name'] = this.attachmentName;
    data['display_name'] = this.displayName;
    data['attachment_ids'] = this.attachmentIds;
    data['date'] = this.date;
    data['author_id'] = this.authorId;
    data['message'] = this.message;
    data['id'] = this.id;
    return data;
  }
}
