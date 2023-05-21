class Authentificate {
  String? jsonrpc;
  int? id;
  Result? result;

  Authentificate({this.jsonrpc, this.id, this.result});

  Authentificate.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    id = json['id'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jsonrpc'] = this.jsonrpc;
    data['id'] = this.id;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? username;
  UserContext? userContext;
  int? uid;
  String? userMobileName;
  String? image;
  String? db;
  int? companyId;
  String? sessionId;
  String? companyMobileName;

  Result(
      {this.username,
        this.userContext,
        this.uid,
        this.userMobileName,
        this.image,
        this.db,
        this.companyId,
        this.sessionId,
        this.companyMobileName});

  Result.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    userContext = json['user_context'] != null
        ? new UserContext.fromJson(json['user_context'])
        : null;
    uid = json['uid'];
    userMobileName = json['user_mobile_name'];
    image = json['image'];
    db = json['db'];
    companyId = json['company_id'];
    sessionId = json['session_id'];
    companyMobileName = json['company_mobile_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    if (this.userContext != null) {
      data['user_context'] = this.userContext!.toJson();
    }
    data['uid'] = this.uid;
    data['user_mobile_name'] = this.userMobileName;
    data['image'] = this.image;
    data['db'] = this.db;
    data['company_id'] = this.companyId;
    data['session_id'] = this.sessionId;
    data['company_mobile_name'] = this.companyMobileName;
    return data;
  }
}

class UserContext {
  String? lang;
  String? tz;
  int? uid;

  UserContext({this.lang, this.tz, this.uid});

  UserContext.fromJson(Map<String, dynamic> json) {
    lang = json['lang'];
    tz = json['tz'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lang'] = this.lang;
    data['tz'] = this.tz;
    data['uid'] = this.uid;
    return data;
  }
}