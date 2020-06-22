class GenerateOTPRequest {
  String phone;
  String third_party_id;
  bool isSignUp;

  GenerateOTPRequest({this.isSignUp, this.phone, this.third_party_id});

  GenerateOTPRequest.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    third_party_id = json['third_party_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['third_party_id'] = this.third_party_id;
    return data;
  }
}
