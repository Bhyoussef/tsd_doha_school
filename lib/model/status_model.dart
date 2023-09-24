class StatusModel {
  int? id;
  String? gatewayName;
  int? status;
  String? rememberToken;
  String? createdAt;
  String? updatedAt;

  StatusModel(
      {this.id,
        this.gatewayName,
        this.status,
        this.rememberToken,
        this.createdAt,
        this.updatedAt});

  StatusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gatewayName = json['gateway_name'];
    status = json['status'];
    rememberToken = json['remember_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['gateway_name'] = this.gatewayName;
    data['status'] = this.status;
    data['remember_token'] = this.rememberToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
