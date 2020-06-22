class User {
  String id;
  String firstName;
  String lastLogin;
  String email;
  String phone;
  String avatar;
  String userType;
  String address;

  User(
      {this.id,
      this.firstName,
      this.lastLogin,
      this.email,
      this.phone,
      this.avatar,
      this.userType,
      this.address});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastLogin = json['last_login'];
    email = json['email'];
    phone = json['phone'];
    avatar = json['avatar'];
    userType = json['user_type'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_login'] = this.lastLogin;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['avatar'] = this.avatar;
    data['user_type'] = this.userType;
    data['address'] = this.address;
    return data;
  }
}
