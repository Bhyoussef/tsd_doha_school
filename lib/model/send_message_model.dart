class SendMessage {
  String? date;
  String? displayName;
  List<int>? attachmentIds;
  List<String>? attachmentName;
  String? authorId;
  String? message;
  int? id;

  SendMessage(
      {this.date,
        this.displayName,
        this.attachmentIds,
        this.attachmentName,
        this.authorId,
        this.message,
        this.id});

  SendMessage.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    displayName = json['display_name'];
    attachmentIds = json['attachment_ids'].cast<int>();
    attachmentName = json['attachment_name'].cast<String>();
    authorId = json['author_id'];
    message = json['message'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['display_name'] = this.displayName;
    data['attachment_ids'] = this.attachmentIds;
    data['attachment_name'] = this.attachmentName;
    data['author_id'] = this.authorId;
    data['message'] = this.message;
    data['id'] = this.id;
    return data;
  }
}
