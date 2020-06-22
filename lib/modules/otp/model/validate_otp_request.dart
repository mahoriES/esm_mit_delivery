class ValidateOTPRequest {
  String phone;
  String token;
  String thirdPartyId;

  ValidateOTPRequest({this.phone, this.token, this.thirdPartyId});

  ValidateOTPRequest.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    token = json['token'];
    thirdPartyId = json['third_party_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['token'] = this.token;
    data['third_party_id'] = this.thirdPartyId;
    return data;
  }
}
