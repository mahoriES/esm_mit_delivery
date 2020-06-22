//class AuthResponse {
//  int statusCode;
//  String status;
//  Customer customer;
//
//  AuthResponse({this.statusCode, this.status, this.customer});
//
//  AuthResponse.fromJson(Map<String, dynamic> json) {
//    statusCode = json['statusCode'];
//    status = json['status'];
//    customer = json['customer'] != null
//        ? new Customer.fromJson(json['customer'])
//        : null;
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['statusCode'] = this.statusCode;
//    data['status'] = this.status;
//    if (this.customer != null) {
//      data['customer'] = this.customer.toJson();
//    }
//    return data;
//  }
//}
class AuthResponse {
  String token;
  User user;

  AuthResponse({this.token, this.user});

  AuthResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  String phone;
  bool isActive;
  String userId;

  User({this.phone, this.isActive, this.userId});

  User.fromJson(Map<String, dynamic> json) {
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

class Customer {
  String name;
  String clusterID;
  String phoneNumber;
  Wallet wallet;
  String profileLastUpdatedTS;
  String personType;
  String lastLoginAt;
  List<LoginSessions> loginSessions;
  List<Null> orders;
  HotTransactions hotTransactions;
  String clusterGroup;
  String customerID;
  List<Addresses> addresses;
  bool otpVerified;

  Customer(
      {this.name,
      this.clusterID,
      this.phoneNumber,
      this.wallet,
      this.profileLastUpdatedTS,
      this.personType,
      this.lastLoginAt,
      this.loginSessions,
      this.orders,
      this.hotTransactions,
      this.clusterGroup,
      this.customerID,
      this.addresses,
      this.otpVerified});

  Customer.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    clusterID = json['clusterID'];
    phoneNumber = json['phoneNumber'];
    wallet =
        json['wallet'] != null ? new Wallet.fromJson(json['wallet']) : null;
    profileLastUpdatedTS = json['profileLastUpdatedTS'];
    personType = json['personType'];
    lastLoginAt = json['lastLoginAt'];
    if (json['loginSessions'] != null) {
      loginSessions = new List<LoginSessions>();
      json['loginSessions'].forEach((v) {
        loginSessions.add(new LoginSessions.fromJson(v));
      });
    }
//    if (json['orders'] != null) {
//      orders = new List<Null>();
//      json['orders'].forEach((v) { orders.add(new Null.fromJson(v)); });
//    }
    hotTransactions = json['hotTransactions'] != null
        ? new HotTransactions.fromJson(json['hotTransactions'])
        : null;
    clusterGroup = json['clusterGroup'];
    customerID = json['customerID'];
    if (json['addresses'] != null) {
      addresses = new List<Addresses>();
      json['addresses'].forEach((v) {
        addresses.add(new Addresses.fromJson(v));
      });
    }
    otpVerified = json['otpVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['clusterID'] = this.clusterID;
    data['phoneNumber'] = this.phoneNumber;
    if (this.wallet != null) {
      data['wallet'] = this.wallet.toJson();
    }
    data['profileLastUpdatedTS'] = this.profileLastUpdatedTS;
    data['personType'] = this.personType;
    data['lastLoginAt'] = this.lastLoginAt;
    if (this.loginSessions != null) {
      data['loginSessions'] =
          this.loginSessions.map((v) => v.toJson()).toList();
    }
    if (this.orders != null) {
//      data['orders'] = this.orders.map((v) => v.toJson()).toList();
    }
    if (this.hotTransactions != null) {
      data['hotTransactions'] = this.hotTransactions.toJson();
    }
    data['clusterGroup'] = this.clusterGroup;
    data['customerID'] = this.customerID;
    if (this.addresses != null) {
      data['addresses'] = this.addresses.map((v) => v.toJson()).toList();
    }
    data['otpVerified'] = this.otpVerified;
    return data;
  }
}

class Wallet {
  String ownerID;
  String defaultCurrencyCode;
  List transactions;
  double balance;
  double balanceLowerLimit;
  double balanceUpperLimit;
  String lastUpdatedTimeStamp;

  Wallet(
      {this.ownerID,
      this.defaultCurrencyCode,
      this.transactions,
      this.balance,
      this.balanceLowerLimit,
      this.balanceUpperLimit,
      this.lastUpdatedTimeStamp});

  Wallet.fromJson(Map<String, dynamic> json) {
    ownerID = json['ownerID'];
    defaultCurrencyCode = json['defaultCurrencyCode'];
//    if (json['transactions'] != null) {
//      transactions = new List<Null>();
//      json['transactions'].forEach((v) { transactions.add(new Null.fromJson(v)); });
//    }
    balance = json['balance'];
    balanceLowerLimit = json['balanceLowerLimit'];
    balanceUpperLimit = json['balanceUpperLimit'];
    lastUpdatedTimeStamp = json['lastUpdatedTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ownerID'] = this.ownerID;
    data['defaultCurrencyCode'] = this.defaultCurrencyCode;
    if (this.transactions != null) {
      data['transactions'] = this.transactions.map((v) => v.toJson()).toList();
    }
    data['balance'] = this.balance;
    data['balanceLowerLimit'] = this.balanceLowerLimit;
    data['balanceUpperLimit'] = this.balanceUpperLimit;
    data['lastUpdatedTimeStamp'] = this.lastUpdatedTimeStamp;
    return data;
  }
}

class LoginSessions {
  SessionKey sessionKey;
  String userID;
  String userType;
  String source;
  String id;
  int maxInactiveInterval;
  int lastAccessedTime;

  LoginSessions(
      {this.sessionKey,
      this.userID,
      this.userType,
      this.source,
      this.id,
      this.maxInactiveInterval,
      this.lastAccessedTime});

  LoginSessions.fromJson(Map<String, dynamic> json) {
    sessionKey = json['sessionKey'] != null
        ? new SessionKey.fromJson(json['sessionKey'])
        : null;
    userID = json['userID'];
    userType = json['userType'];
    source = json['source'];
    id = json['id'];
    maxInactiveInterval = json['maxInactiveInterval'];
    lastAccessedTime = json['lastAccessedTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sessionKey != null) {
      data['sessionKey'] = this.sessionKey.toJson();
    }
    data['userID'] = this.userID;
    data['userType'] = this.userType;
    data['source'] = this.source;
    data['id'] = this.id;
    data['maxInactiveInterval'] = this.maxInactiveInterval;
    data['lastAccessedTime'] = this.lastAccessedTime;
    return data;
  }
}

class SessionKey {
  String value;
  String generationTS;
  Null lastAccessedTS;
  String expiryTS;
  int maxInactiveInterval;
  int usageCount;
  int usageLimit;

  SessionKey(
      {this.value,
      this.generationTS,
      this.lastAccessedTS,
      this.expiryTS,
      this.maxInactiveInterval,
      this.usageCount,
      this.usageLimit});

  SessionKey.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    generationTS = json['generationTS'];
    lastAccessedTS = json['lastAccessedTS'];
    expiryTS = json['expiryTS'];
    maxInactiveInterval = json['maxInactiveInterval'];
    usageCount = json['usageCount'];
    usageLimit = json['usage_limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['generationTS'] = this.generationTS;
    data['lastAccessedTS'] = this.lastAccessedTS;
    data['expiryTS'] = this.expiryTS;
    data['maxInactiveInterval'] = this.maxInactiveInterval;
    data['usageCount'] = this.usageCount;
    data['usage_limit'] = this.usageLimit;
    return data;
  }
}

class HotTransactions {
//  HotTransactions({});

  HotTransactions.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class Addresses {
  List tags;
  String addressLine1;
  String formattedAddress;
//  bool default;

  Addresses({this.tags, this.addressLine1, this.formattedAddress});

  Addresses.fromJson(Map<String, dynamic> json) {
//if (json['tags'] != null) {
//tags = new List<Null>();
//json['tags'].forEach((v) { tags.add(new Null.fromJson(v)); });
//}
    addressLine1 = json['addressLine1'];
    formattedAddress = json['formattedAddress'];
//default = json['default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tags != null) {
      data['tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    data['addressLine1'] = this.addressLine1;
    data['formattedAddress'] = this.formattedAddress;
//  data['default'] = this.default;
    return data;
  }
}

class SignupResponse {
  String token;
  SignedUser user;

  SignupResponse({this.token, this.user});

  SignupResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new SignedUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class SignedUser {
  String phone;
  bool isActive;
  String userId;

  SignedUser({this.phone, this.isActive, this.userId});

  SignedUser.fromJson(Map<String, dynamic> json) {
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
