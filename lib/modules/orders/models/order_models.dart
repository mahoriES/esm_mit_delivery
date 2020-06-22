import 'package:esamudaayapp/modules/cart/models/cart_model.dart';
import 'package:esamudaayapp/modules/home/models/merchant_response.dart';

class GetOrderListRequest {
  String phoneNumber;

  GetOrderListRequest({this.phoneNumber});

  GetOrderListRequest.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}

class GetOrderListResponse {
  List<Orders> orders;
  int statusCode;
  String status;

  GetOrderListResponse({this.orders, this.statusCode, this.status});

  GetOrderListResponse.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = new List<Orders>();
      json['orders'].forEach((v) {
        orders.add(new Orders.fromJson(v));
      });
    } else {
      orders = [];
    }
    statusCode = json['statusCode'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orders != null) {
      data['orders'] = this.orders.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = this.statusCode;
    data['status'] = this.status;
    return data;
  }
}

class Orders {
  Cart cart;
  String customerID;
  String customerPhoneNumber;
  String merchantID;
  String displayPicture;
  String shopName;
  String cardViewLine2;
  String transactionID;
  String placedAt;
  String status;
  String paymentType;
  Map serviceSpecificData;
  String lastUpdatedTimeStamp;
  double totalOrderCost;
  Holders holder;
  bool codPaymentCompleted;
  List<Holders> holders;
  List<ItemsEnhanced> itemsNotAvailable;
  bool customerMarkedOfflinePaymentComplete;
  String completedTime;
  Address address;

  Orders(
      {this.cart,
      this.customerID,
      this.customerPhoneNumber,
      this.merchantID,
      this.address,
      this.displayPicture,
      this.shopName,
      this.cardViewLine2,
      this.transactionID,
      this.placedAt,
      this.status,
      this.paymentType,
      this.serviceSpecificData,
      this.lastUpdatedTimeStamp,
      this.totalOrderCost,
      this.holder,
      this.codPaymentCompleted,
      this.holders,
      this.itemsNotAvailable,
      this.customerMarkedOfflinePaymentComplete,
      this.completedTime});

  Orders.fromJson(Map<String, dynamic> json) {
    cart = json['cart'] != null ? new Cart.fromJson(json['cart']) : null;
    customerID = json['customerID'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    customerPhoneNumber = json['customerPhoneNumber'];
    merchantID = json['merchantID'];
    displayPicture = json['displayPicture'];
    shopName = json['shopName'];
    cardViewLine2 = json['cardViewLine2'];
    transactionID = json['transactionID'];
    placedAt = json['placedAt'];
    status = json['status'];
    paymentType = json['paymentType'];
    serviceSpecificData = json['serviceSpecificData'];
    lastUpdatedTimeStamp = json['lastUpdatedTimeStamp'];
    totalOrderCost = double.parse(json['totalOrderCost'].toString());
    holder =
        json['holder'] != null ? new Holders.fromJson(json['holder']) : null;
    codPaymentCompleted = json['codPaymentCompleted'];
    if (json['holders'] != null) {
      holders = new List<Holders>();
      json['holders'].forEach((v) {
        holders.add(new Holders.fromJson(v));
      });
    }
    if (json['itemsNotAvailable'] != null) {
      itemsNotAvailable = new List<ItemsEnhanced>();
      json['itemsNotAvailable'].forEach((v) {
        itemsNotAvailable.add(new ItemsEnhanced.fromJson(v));
      });
    }
    customerMarkedOfflinePaymentComplete =
        json['customerMarkedOfflinePaymentComplete'];
    completedTime = json['completedTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cart != null) {
      data['cart'] = this.cart.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    data['customerID'] = this.customerID;
    data['customerPhoneNumber'] = this.customerPhoneNumber;
    data['merchantID'] = this.merchantID;
    data['displayPicture'] = this.displayPicture;
    data['shopName'] = this.shopName;
    data['cardViewLine2'] = this.cardViewLine2;
    data['transactionID'] = this.transactionID;
    data['placedAt'] = this.placedAt;
    data['status'] = this.status;
    data['paymentType'] = this.paymentType;
    if (this.serviceSpecificData != null) {
      data['serviceSpecificData'] = this.serviceSpecificData;
    }
    data['lastUpdatedTimeStamp'] = this.lastUpdatedTimeStamp;
    data['totalOrderCost'] = this.totalOrderCost;
    if (this.holder != null) {
      data['holder'] = this.holder.toJson();
    }
    data['codPaymentCompleted'] = this.codPaymentCompleted;
    if (this.holders != null) {
      data['holders'] = this.holders.map((v) => v.toJson()).toList();
    }
    if (this.itemsNotAvailable != null) {
      data['itemsNotAvailable'] =
          this.itemsNotAvailable.map((v) => v.toJson()).toList();
    }
    data['customerMarkedOfflinePaymentComplete'] =
        this.customerMarkedOfflinePaymentComplete;
    data['completedTime'] = this.completedTime;
    return data;
  }
}

class Holders {
  String phoneNumber;
  String holder;
  String orderPickUpTime;
  Null orderDropOffTime;

  Holders(
      {this.phoneNumber,
      this.holder,
      this.orderPickUpTime,
      this.orderDropOffTime});

  Holders.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    holder = json['holder'];
    orderPickUpTime = json['orderPickUpTime'];
    orderDropOffTime = json['orderDropOffTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    data['holder'] = this.holder;
    data['orderPickUpTime'] = this.orderPickUpTime;
    data['orderDropOffTime'] = this.orderDropOffTime;
    return data;
  }
}

class AddReviewRequest {
  String reviewCandidate;
  String reviewCandidateID;
  String reviewerTye;
  String reviewerID;
  int rating;
  String comments;

  AddReviewRequest(
      {this.reviewCandidate,
      this.reviewCandidateID,
      this.reviewerTye,
      this.reviewerID,
      this.rating,
      this.comments});

  AddReviewRequest.fromJson(Map<String, dynamic> json) {
    reviewCandidate = json['reviewCandidate'];
    reviewCandidateID = json['reviewCandidateID'];
    reviewerTye = json['reviewerTye'];
    reviewerID = json['reviewerID'];
    rating = json['rating'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reviewCandidate'] = this.reviewCandidate;
    data['reviewCandidateID'] = this.reviewCandidateID;
    data['reviewerTye'] = this.reviewerTye;
    data['reviewerID'] = this.reviewerID;
    data['rating'] = this.rating;
    data['comments'] = this.comments;
    return data;
  }
}

class UpdateOrderRequest {
  String phoneNumber;
  List<Orders> orders;
  String comments;
  String oldStatus;

  UpdateOrderRequest(
      {this.phoneNumber, this.orders, this.comments, this.oldStatus});

  UpdateOrderRequest.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    if (json['orders'] != null) {
      orders = new List<Orders>();
      json['orders'].forEach((v) {
        orders.add(new Orders.fromJson(v));
      });
    }
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    if (this.orders != null) {
      data['orders'] = this.orders.map((v) => v.toJson()).toList();
    }
    data['comments'] = this.comments;
    print(data);
    return data;
  }
}
