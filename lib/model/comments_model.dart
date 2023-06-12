import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'attachement_model.dart';

class Comment {
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
  List<Attachment>? attachments;
  RxBool hasAttachments = false.obs;

  Comment({
    this.body,
    this.recordName,
    this.voteUserIds,
    this.writeDate,
    this.date,
    this.model,
    this.attachmentIds,
    this.type,
    this.id,
    this.authorId,
    this.resId,
    this.attachments,
  });

  Comment.fromJson(Map<String, dynamic> json) {
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
        ? AuthorId.fromJson(json['author_id'])
        : null;
    resId = json['res_id'];
    if (json['attachments'] != null) {
      attachments = List<Attachment>.from(
          json['attachments'].map((attachment) => Attachment.fromJson(attachment)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['body'] = body;
    data['record_name'] = recordName;
    data['vote_user_ids'] = voteUserIds;
    data['write_date'] = writeDate;
    data['date'] = date;
    data['model'] = model;
    data['attachment_ids'] = attachmentIds;
    data['type'] = type;
    data['id'] = id;
    if (authorId != null) {
      data['author_id'] = authorId!.toJson();
    }
    data['res_id'] = resId;
    if (attachments != null) {
      data['attachments'] = attachments!.map((attachment) => attachment.toJson()).toList();
    }
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}
