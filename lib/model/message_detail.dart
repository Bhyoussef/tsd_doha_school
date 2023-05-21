class MessageDetail {
  String? body;
  String? recordName;
  List<int>? voteUserIds;
  String? writeDate;
  String? date;
  String? model;
  List<int>? attachmentIds;
  String? type;
  int? id;
  AuthorId? authorId;
  int? resId;

  MessageDetail(
      {this.body,
        this.recordName,
        this.voteUserIds,
        this.writeDate,
        this.date,
        this.model,
        this.attachmentIds,
        this.type,
        this.id,
        this.authorId,
        this.resId});

  MessageDetail.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    recordName = json['record_name'];
    voteUserIds = json['vote_user_ids'].cast<int>();
    writeDate = json['write_date'];
    date = json['date'];
    model = json['model'];
    attachmentIds = json['attachment_ids'].cast<int>();
    type = json['type'];
    id = json['id'];
    authorId = json['author_id'] != null
        ? new AuthorId.fromJson(json['author_id'])
        : null;
    resId = json['res_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body'] = this.body;
    data['record_name'] = this.recordName;
    data['vote_user_ids'] = this.voteUserIds;
    data['write_date'] = this.writeDate;
    data['date'] = this.date;
    data['model'] = this.model;
    data['attachment_ids'] = this.attachmentIds;
    data['type'] = this.type;
    data['id'] = this.id;

    if (this.authorId != null) {
      data['author_id'] = this.authorId!.toJson();
    }
    data['res_id'] = this.resId;
    return data;
  }
}

class SubtypeId {
  String? name;
  int? id;

  SubtypeId({this.name, this.id});

  SubtypeId.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}

class AuthorId {
  String? image;
  String? name;
  int? id;

  AuthorId({this.image, this.name, this.id});

  AuthorId.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}
