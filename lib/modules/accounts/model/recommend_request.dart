class RecommendedShopRequest {
  String phoneNumber;
  String storeName;
  String storeAddress;
  String storePhoneNumber;
  String latitude;
  String longitude;

  RecommendedShopRequest(
      {this.phoneNumber,
      this.storeName,
      this.storeAddress,
      this.storePhoneNumber,
      this.latitude,
      this.longitude});

  RecommendedShopRequest.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    storeName = json['storeName'];
    storeAddress = json['storeAddress'];
    storePhoneNumber = json['storePhoneNumber'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    data['storeName'] = this.storeName;
    data['storeAddress'] = this.storeAddress;
    data['storePhoneNumber'] = this.storePhoneNumber;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
