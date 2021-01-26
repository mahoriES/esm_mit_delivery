import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/model/transit_models.dart';

class OrderStatusStrings {
  static const String pending = "PENDING";
  static const String accepted = "ACCEPTED";
  static const String picked = "PICKED";
  static const String dropped = "DROPPED";
  static const String orderCompleted = "COMPLETED";
  static const String rejected = "REJECTED";
}

class OrderResponse {
  int count;
  String next;
  String previous;
  List<TransitDetails> results;

  OrderResponse({this.count, this.next, this.previous, this.results});

  OrderResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = new List<TransitDetails>();
      json['results'].forEach((v) {
        results.add(new TransitDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderRequest {
  String status;
  Order order;
  int requestId;

  OrderRequest({this.status, this.order, this.requestId});

  OrderRequest.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
    requestId = json['request_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.order != null) {
      data['order'] = this.order.toJson();
    }
    data['request_id'] = this.requestId;
    return data;
  }
}

class Order {
  String orderId;
  String orderShortNumber;
  String orderStatus;
  int orderTotal;
  int deliveryCharges;
  List<BusinessImages> businessImages;
  String businessName;
  String clusterName;
  String customerName;
  List<String> businessPhones;
  List<String> customerPhones;
  DeliveryAddress pickupAddress;
  DeliveryAddress deliveryAddress;
  String created;
  List<OrderItems> orderItems;
  PaymentInfo paymentInfo;

  Order(
      {this.orderId,
      this.orderShortNumber,
      this.orderStatus,
      this.orderTotal,
      this.deliveryCharges,
      this.businessImages,
      this.businessName,
      this.clusterName,
      this.customerName,
      this.businessPhones,
      this.customerPhones,
      this.pickupAddress,
      this.deliveryAddress,
      this.orderItems,
      this.created,
      this.paymentInfo});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderShortNumber = json['order_short_number'];
    orderStatus = json['order_status'];
    orderTotal = json['order_total'];
    deliveryCharges = json['delivery_charges'];
    if (json['business_images'] != null) {
      businessImages = new List<BusinessImages>();
      json['business_images'].forEach((v) {
        businessImages.add(new BusinessImages.fromJson(v));
      });
    }
    businessName = json['business_name'];
    clusterName = json['cluster_name'];
    customerName = json['customer_name'];
    businessPhones = json['business_phones'] != null
        ? json['business_phones'].cast<String>()
        : [];
    customerPhones = json['customer_phones'] != null
        ? json['customer_phones'].cast<String>()
        : [];
    if (json['order_items'] != null) {
      orderItems = new List<OrderItems>();
      json['order_items'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
    pickupAddress = json['pickup_address'] != null
        ? new DeliveryAddress.fromJson(json['pickup_address'])
        : null;

    deliveryAddress = json['delivery_address'] != null
        ? new DeliveryAddress.fromJson(json['delivery_address'])
        : null;
    created = json['created'];
    paymentInfo = json['payment_info'] != null
        ? new PaymentInfo.fromJson(json['payment_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['order_short_number'] = this.orderShortNumber;
    data['order_status'] = this.orderStatus;
    data['order_total'] = this.orderTotal;
    data['delivery_charges'] = this.deliveryCharges;
    if (this.businessImages != null) {
      data['business_images'] =
          this.businessImages.map((v) => v.toJson()).toList();
    }
    data['business_name'] = this.businessName;
    data['cluster_name'] = this.clusterName;
    data['customer_name'] = this.customerName;
    data['business_phones'] = this.businessPhones;
    data['customer_phones'] = this.customerPhones;
    data['order_items'] = this.orderItems.map((v) => v.toJson()).toList();
    if (this.pickupAddress != null) {
      data['pickup_address'] = this.pickupAddress.toJson();
    }
    if (this.deliveryAddress != null) {
      data['delivery_address'] = this.deliveryAddress.toJson();
    }
    data['created'] = this.created;
    if (this.paymentInfo != null) {
      data['payment_info'] = this.paymentInfo.toJson();
    }
    return data;
  }

  bool get isPaymentDone {
    return this.paymentInfo?.status == PaymentStatus.APPROVED ||
        this.paymentInfo?.status == PaymentStatus.SUCCESS;
  }

  double get orderTotalInRupees => (this.orderTotal ?? 0) / 100;

  String get dPaymentString {
    return isPaymentDone
        ? tr("payment_status.done",
            args: [orderTotalInRupees.toStringAsFixed(2), dPaymentMethod])
        : this.paymentInfo.status == PaymentStatus.REFUNDED
            ? tr("payment_status.refunded")
            : this.paymentInfo.status == PaymentStatus.INITIATED
                ? tr("payment_status.initiated")
                : this.paymentInfo.status == PaymentStatus.REJECTED
                    ? tr("payment_status.rejected")
                    : tr("payment_status.pending");
  }

  String get dPaymentMethod {
    return this.paymentInfo?.via ?? "";
  }
}

class DeliveryAddress {
  GeoAddr geoAddr;
  String addressId;
  String addressName;
  LocationPoint locationPoint;
  String prettyAddress;

  DeliveryAddress(
      {this.geoAddr,
      this.addressId,
      this.addressName,
      this.locationPoint,
      this.prettyAddress});

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    geoAddr = json['geo_addr'] != null
        ? new GeoAddr.fromJson(json['geo_addr'])
        : null;
    addressId = json['address_id'];
    addressName = json['address_name'];
    locationPoint = json['location_point'] != null
        ? new LocationPoint.fromJson(json['location_point'])
        : null;
    prettyAddress = json['pretty_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.geoAddr != null) {
      data['geo_addr'] = this.geoAddr.toJson();
    }
    data['address_id'] = this.addressId;
    data['address_name'] = this.addressName;
    if (this.locationPoint != null) {
      data['location_point'] = this.locationPoint.toJson();
    }
    data['pretty_address'] = this.prettyAddress;
    return data;
  }
}

class GeoAddr {
  String city;
  String pincode;
  String landmark;
  String house;

  GeoAddr({this.city, this.pincode, this.landmark, this.house});

  GeoAddr.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    pincode = json['pincode'];
    landmark = json['landmark'];
    house = json['house'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['landmark'] = this.landmark;
    data['house'] = this.house;
    return data;
  }
}

class LocationPoint {
  double lat;
  double lon;

  LocationPoint({this.lat, this.lon});

  LocationPoint.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    return data;
  }
}

class OrderItems {
  int skuId;
  int quantity;
  int unitPrice;
  String productName;
  String skuCode;
  List<Images> images;
  String unitName;
  VariationOption variationOption;
  SkuCharges skuCharges;

  OrderItems(
      {this.skuId,
      this.quantity,
      this.unitPrice,
      this.productName,
      this.skuCode,
      this.images,
      this.unitName,
      this.variationOption,
      this.skuCharges});

  OrderItems.fromJson(Map<String, dynamic> json) {
    skuId = json['sku_id'];
    quantity = json['quantity'];
    unitPrice = json['unit_price'];
    productName = json['product_name'];
    skuCode = json['sku_code'];
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    unitName = json['unit_name'];
    variationOption = json['variation_option'] != null
        ? new VariationOption.fromJson(json['variation_option'])
        : null;
    skuCharges = json['sku_charges'] != null
        ? new SkuCharges.fromJson(json['sku_charges'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sku_id'] = this.skuId;
    data['quantity'] = this.quantity;
    data['unit_price'] = this.unitPrice;
    data['product_name'] = this.productName;
    data['sku_code'] = this.skuCode;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    data['unit_name'] = this.unitName;
    if (this.variationOption != null) {
      data['variation_option'] = this.variationOption.toJson();
    }
    if (this.skuCharges != null) {
      data['sku_charges'] = this.skuCharges.toJson();
    }
    return data;
  }
}

class VariationOption {
  String size;

  VariationOption({this.size});

  VariationOption.fromJson(Map<String, dynamic> json) {
    size = json['Size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Size'] = this.size;
    return data;
  }
}

class SkuCharges {
  int packing;
  int service;

  SkuCharges({this.packing, this.service});

  SkuCharges.fromJson(Map<String, dynamic> json) {
    packing = json['Packing'];
    service = json['Service'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Packing'] = this.packing;
    data['Service'] = this.service;
    return data;
  }
}

class Images {
  String photoId;
  String photoUrl;
  String contentType;

  Images({this.photoId, this.photoUrl, this.contentType});

  Images.fromJson(Map<String, dynamic> json) {
    photoId = json['photo_id'];
    photoUrl = json['photo_url'];
    contentType = json['content_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo_id'] = this.photoId;
    data['photo_url'] = this.photoUrl;
    data['content_type'] = this.contentType;
    return data;
  }
}

class BusinessImages {
  String photoId;
  String photoUrl;
  String contentType;

  BusinessImages({this.photoId, this.photoUrl, this.contentType});

  BusinessImages.fromJson(Map<String, dynamic> json) {
    photoId = json['photo_id'];
    photoUrl = json['photo_url'];
    contentType = json['content_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo_id'] = this.photoId;
    data['photo_url'] = this.photoUrl;
    data['content_type'] = this.contentType;
    return data;
  }
}

class PaymentInfo {
  String upi;
  String status;
  String dt;
  int amount;
  String via;

  PaymentInfo({
    this.upi,
    this.status,
    this.dt,
    this.amount,
    this.via,
  });

  PaymentInfo.fromJson(Map<String, dynamic> json) {
    upi = json['upi'];
    status = json['status'];
    dt = json['dt'];
    amount = json['amount'];
    via = json['via'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['upi'] = this.upi;
    data['status'] = this.status;
    data['dt'] = this.dt;
    data['amount'] = this.amount;
    data['via'] = this.via;
    return data;
  }
}

class PaymentStatus {
  static const PENDING = 'PENDING';
  static const SUCCESS = 'SUCCESS';
  static const FAIL = 'FAIL';
  static const REFUNDED = 'REFUNDED';

  //  Old Statuses:
  static const INITIATED = 'INITIATED';
  static const APPROVED = 'APPROVED';
  static const REJECTED = 'REJECTED';
}
