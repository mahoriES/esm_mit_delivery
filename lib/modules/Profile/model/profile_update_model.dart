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

class UpdateProfileResponse {
  Data data;
  String token;
  String role;

  UpdateProfileResponse({this.data, this.token, this.role});

  UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    token = json['token'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['token'] = this.token;
    data['role'] = this.role;
    return data;
  }
}

class Data {
  UserProfile userProfile;
  ProfilePic profilePic;
  String profileName;
  String created;
  String modified;
  bool isSuspended;

  Data(
      {this.userProfile,
      this.profilePic,
      this.profileName,
      this.created,
      this.modified,
      this.isSuspended});

  Data.fromJson(Map<String, dynamic> json) {
    userProfile = json['user_profile'] != null
        ? new UserProfile.fromJson(json['user_profile'])
        : null;
    profilePic = json['profile_pic'] != null
        ? new ProfilePic.fromJson(json['profile_pic'])
        : null;
    profileName = json['profile_name'];
    created = json['created'];
    modified = json['modified'];
    isSuspended = json['is_suspended'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userProfile != null) {
      data['user_profile'] = this.userProfile.toJson();
    }
    if (this.profilePic != null) {
      data['profile_pic'] = this.profilePic.toJson();
    }
    data['profile_name'] = this.profileName;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['is_suspended'] = this.isSuspended;
    return data;
  }
}

class UserProfile {
  String phone;
  bool isActive;
  String userId;

  UserProfile({this.phone, this.isActive, this.userId});

  UserProfile.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    isActive = json['is_active'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['is_active'] = this.isActive;
    data['user_id'] = this.userId;
    return data;
  }
}

class ProfilePic {
  ProfilePic.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
