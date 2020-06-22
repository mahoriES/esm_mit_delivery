class ProfileUpdateRequest {
  String phoneNumber;
  String name;
  String email;
  String address;
  String latitude;
  String longitude;

  ProfileUpdateRequest(
      {this.phoneNumber,
      this.name,
      this.email,
      this.address,
      this.latitude,
      this.longitude});

  ProfileUpdateRequest.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    name = json['name'];
    email = json['email'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    data['name'] = this.name;
    data['email'] = this.email;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
