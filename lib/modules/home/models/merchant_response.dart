import 'package:esamudaayapp/modules/register/model/register_request_model.dart';

class MerchantSearchResponse {
  List<Merchants> merchants;
  int statusCode;
  String status;

  MerchantSearchResponse({this.merchants, this.statusCode, this.status});

  MerchantSearchResponse.fromJson(Map<String, dynamic> json) {
    if (json['merchants'] != null) {
      merchants = new List<Merchants>();
      json['merchants'].forEach((v) {
        merchants.add(new Merchants.fromJson(v));
      });
    } else {
      merchants = [];
    }
    statusCode = json['statusCode'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.merchants != null) {
      data['merchants'] = this.merchants.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = this.statusCode;
    data['status'] = this.status;
    return data;
  }
}

class GetBusinessesResponse {
  int count;
  List<Business> results;

  GetBusinessesResponse({this.count, this.results});

  GetBusinessesResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['results'] != null) {
      results = new List<Business>();
      json['results'].forEach((v) {
        results.add(new Business.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Business {
  String businessId;
  String businessName;
  bool isOpen;
  AddressNew address;
  String description;
//  Timing timing;
  List<Photo> images;
  List<String> phones;
  bool hasDelivery;

  Business(
      {this.businessId,
      this.businessName,
      this.isOpen,
      this.address,
      this.description,
//      this.timing,
      this.images,
      this.phones,
      this.hasDelivery});

  Business.fromJson(Map<String, dynamic> json) {
    businessId = json['business_id'];
    businessName = json['business_name'];
    description = json['description'];
    isOpen = json['is_open'];
    address = json['address'] != null
        ? new AddressNew.fromJson(json['address'])
        : null;
//    timing =
//        json['timing'] != null ? new Timing.fromJson(json['timing']) : null;
    if (json['images'] != null) {
      images = new List<Photo>();
      json['images'].forEach((v) {
        images.add(new Photo.fromJson(v));
      });
    }
    phones = json['phones'] != null ? json['phones'].cast<String>() : [];
    hasDelivery = json['has_delivery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    data['business_name'] = this.businessName;
    data['description'] = this.description;
    data['is_open'] = this.isOpen;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
//    if (this.timing != null) {
//      data['timing'] = this.timing.toJson();
//    }
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    data['phones'] = this.phones;
    data['has_delivery'] = this.hasDelivery;
    return data;
  }
}

class AddressNew {
  String prettyAddress;
  LocationPoint locationPoint;

  AddressNew({this.prettyAddress, this.locationPoint});

  AddressNew.fromJson(Map<String, dynamic> json) {
    prettyAddress = json['pretty_address'];
    locationPoint = json['location_point'] != null
        ? new LocationPoint.fromJson(json['location_point'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pretty_address'] = this.prettyAddress;
    if (this.locationPoint != null) {
      data['location_point'] = this.locationPoint.toJson();
    }
    return data;
  }
}

class LocationPoint {
  double lon;
  double lat;

  LocationPoint({this.lon, this.lat});

  LocationPoint.fromJson(Map<String, dynamic> json) {
    lon = json['lon'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lon'] = this.lon;
    data['lat'] = this.lat;
    return data;
  }
}

class MerchantLocal {
  String shopName;
  String displayPicture;
  String cardViewLine2;
  String flag;
  String merchantID;
  String address1;
  String address2;
  MerchantLocal(
      {this.shopName,
      this.displayPicture,
      this.cardViewLine2,
      this.address1,
      this.address2,
      this.flag,
      this.merchantID});

  MerchantLocal.fromJson(Map<String, dynamic> json) {
    shopName = json['shopName'];
    displayPicture = json['displayPicture'];
    cardViewLine2 = json['cardViewLine2'];
    flag = json['flag'];
    merchantID = json['merchantID'];
    address1 = json['address1'];
    address2 = json['address2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shopName'] = this.shopName;
    data['displayPicture'] = this.displayPicture;
    data['cardViewLine2'] = this.cardViewLine2;
    data['flag'] = this.flag;
    data['merchantID'] = this.merchantID;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    return data;
  }
}

class Merchants {
  Address address;
  String merchantID;
  List<String> secondaryPhoneNumbers;
  String openTime;
  String closeTime;
  String displayPicture;
  String shopName;
  String cardViewLine2;
  String ownerName;
  List<String> flags;
  String noticeToCustomers;
  List<String> servicesOffered;
  List<String> serviceSpecificData;
  List<Categories> categories;

  Merchants({
    this.address,
    this.merchantID,
    this.secondaryPhoneNumbers,
    this.openTime,
    this.closeTime,
    this.displayPicture,
    this.shopName,
    this.cardViewLine2,
    this.ownerName,
    this.flags,
    this.noticeToCustomers,
    this.servicesOffered,
    this.serviceSpecificData,
    this.categories,
  });

  Merchants.fromJson(Map<String, dynamic> json) {
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    merchantID = json['merchantID'];
    if (json['secondaryPhoneNumbers'] != null) {
      secondaryPhoneNumbers = json['secondaryPhoneNumbers'].cast<String>();
    }
    openTime = json['openTime'];
    closeTime = json['closeTime'];
    displayPicture = json['displayPicture'];
    shopName = json['shopName'];
    cardViewLine2 = json['cardViewLine2'];
    ownerName = json['ownerName'];
    if (json['flags'] != null) {
      flags = json['flags'].cast<String>();
    }
    noticeToCustomers = json['noticeToCustomers'];
    if (json['servicesOffered'] != null) {
      servicesOffered = json['servicesOffered'].cast<String>();
    } else {
      servicesOffered = [];
    }
    serviceSpecificData = json['serviceSpecificData'];
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['merchantID'] = this.merchantID;
    data['secondaryPhoneNumbers'] = this.secondaryPhoneNumbers;
    data['openTime'] = this.openTime;
    data['closeTime'] = this.closeTime;
    data['displayPicture'] = this.displayPicture;
    data['shopName'] = this.shopName;
    data['cardViewLine2'] = this.cardViewLine2;
    data['ownerName'] = this.ownerName;
    data['flags'] = this.flags;
    data['noticeToCustomers'] = this.noticeToCustomers;
    data['servicesOffered'] = this.servicesOffered;
    data['serviceSpecificData'] = this.serviceSpecificData;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Address {
  String addressLine1;
  String addressLine2;
  String latitude;
  String longitude;
  String name;
  String area;
  String formattedAddress;

  Address(
      {this.addressLine1,
      this.addressLine2,
      this.latitude,
      this.longitude,
      this.name,
      this.area,
      this.formattedAddress});

  Address.fromJson(Map<String, dynamic> json) {
    if (json['tags'] != null) {
      addressLine1 = json['addressLine1'];
      addressLine2 = json['addressLine2'];
      latitude = json['latitude'];
      longitude = json['longitude'];

      name = json['name'];
      area = json['area'];
      formattedAddress = json['formattedAddress'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;

    data['name'] = this.name;
    data['area'] = this.area;
    data['formattedAddress'] = this.formattedAddress;
    return data;
  }
}

class Categories {
  String id;
  String name;
  String description;
  String imageLink;

  Categories({this.id, this.name, this.description, this.imageLink});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageLink = json['imageLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['imageLink'] = this.imageLink;
    return data;
  }
}
