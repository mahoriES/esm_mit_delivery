class AddFCMTokenRequest {
  String fcmToken;
  String tokenType;

  AddFCMTokenRequest({this.fcmToken, this.tokenType});

  AddFCMTokenRequest.fromJson(Map<String, dynamic> json) {
    fcmToken = json['fcm_token'];
    tokenType = json['token_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fcm_token'] = this.fcmToken;
    data['token_type'] = this.tokenType;
    return data;
  }
}
