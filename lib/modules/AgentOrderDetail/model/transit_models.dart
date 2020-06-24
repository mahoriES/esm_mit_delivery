import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/model/drop_image.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/model/pick_image.dart';

class TransitDetails {
  int transitId;
  String status;
  PickupPnt pickupPnt;
  PickupPnt dropPnt;
  PickupAddress pickupAddress;
  PickupAddress dropAddress;
  String created;
  String completed;
  int distance;
  List<PickupImages> pickupImages;
  List<DropImages> dropImages;
  Order order;

  TransitDetails(
      {this.transitId,
      this.status,
      this.pickupPnt,
      this.dropPnt,
      this.pickupAddress,
      this.dropAddress,
      this.created,
      this.completed,
      this.distance,
      this.pickupImages,
      this.dropImages,
      this.order});

  TransitDetails.fromJson(Map<String, dynamic> json) {
    transitId = json['transit_id'];
    status = json['status'];
    pickupPnt = json['pickup_pnt'] != null
        ? new PickupPnt.fromJson(json['pickup_pnt'])
        : null;
    dropPnt = json['drop_pnt'] != null
        ? new PickupPnt.fromJson(json['drop_pnt'])
        : null;
    pickupAddress = json['pickup_address'] != null
        ? new PickupAddress.fromJson(json['pickup_address'])
        : null;
    dropAddress = json['drop_address'] != null
        ? new PickupAddress.fromJson(json['drop_address'])
        : null;
    created = json['created'];
    completed = json['completed'];
    distance = json['distance'];
    if (json['pickup_images'] != null) {
      pickupImages = new List<PickupImages>();
      json['pickup_images'].forEach((v) {
        pickupImages.add(new PickupImages.fromJson(v));
      });
    }
    if (json['drop_images'] != null) {
      dropImages = new List<DropImages>();
      json['drop_images'].forEach((v) {
        dropImages.add(new DropImages.fromJson(v));
      });
    }
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transit_id'] = this.transitId;
    data['status'] = this.status;
    if (this.pickupPnt != null) {
      data['pickup_pnt'] = this.pickupPnt.toJson();
    }
    if (this.dropPnt != null) {
      data['drop_pnt'] = this.dropPnt.toJson();
    }
    if (this.pickupAddress != null) {
      data['pickup_address'] = this.pickupAddress.toJson();
    }
    if (this.dropAddress != null) {
      data['drop_address'] = this.dropAddress.toJson();
    }
    data['created'] = this.created;
    data['completed'] = this.completed;
    data['distance'] = this.distance;
    if (this.pickupImages != null) {
      data['pickup_images'] = this.pickupImages.map((v) => v.toJson()).toList();
    }
    if (this.dropImages != null) {
      data['drop_images'] = this.dropImages.map((v) => v.toJson()).toList();
    }
    if (this.order != null) {
      data['order'] = this.order.toJson();
    }
    return data;
  }
}

class PickupPnt {
  double lon;
  double lat;

  PickupPnt({this.lon, this.lat});

  PickupPnt.fromJson(Map<String, dynamic> json) {
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

class PickupAddress {
  GeoAddr geoAddr;
  String addressId;
  String addressName;
  PickupPnt locationPoint;
  String prettyAddress;

  PickupAddress(
      {this.geoAddr,
      this.addressId,
      this.addressName,
      this.locationPoint,
      this.prettyAddress});

  PickupAddress.fromJson(Map<String, dynamic> json) {
    geoAddr = json['geo_addr'] != null
        ? new GeoAddr.fromJson(json['geo_addr'])
        : null;
    addressId = json['address_id'];
    addressName = json['address_name'];
    locationPoint = json['location_point'] != null
        ? new PickupPnt.fromJson(json['location_point'])
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

  GeoAddr({this.city, this.pincode});

  GeoAddr.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    return data;
  }
}

class Order {
  String orderId;
  String orderShortNumber;
  String orderStatus;
  int itemTotal;
  int otherCharges;
  int orderTotal;
  int deliveryCharges;
  List<BusinessImages> businessImages;
  String businessName;
  String clusterName;
  String customerName;
  String customerNote;
  List<String> businessPhones;
  List<String> customerPhones;
  List<OrderItems> orderItems;

  Order(
      {this.orderId,
      this.orderShortNumber,
      this.orderStatus,
      this.itemTotal,
      this.otherCharges,
      this.orderTotal,
      this.deliveryCharges,
      this.businessImages,
      this.businessName,
      this.clusterName,
      this.customerName,
      this.customerNote,
      this.businessPhones,
      this.customerPhones,
      this.orderItems});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderShortNumber = json['order_short_number'];
    orderStatus = json['order_status'];
    itemTotal = json['item_total'];
    otherCharges = json['other_charges'];
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
    customerNote = json['customer_note'];
    businessPhones = json['business_phones'].cast<String>();
    customerPhones = json['customer_phones'].cast<String>();
    if (json['order_items'] != null) {
      orderItems = new List<OrderItems>();
      json['order_items'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['order_short_number'] = this.orderShortNumber;
    data['order_status'] = this.orderStatus;
    data['item_total'] = this.itemTotal;
    data['other_charges'] = this.otherCharges;
    data['order_total'] = this.orderTotal;
    data['delivery_charges'] = this.deliveryCharges;
    if (this.businessImages != null) {
      data['business_images'] =
          this.businessImages.map((v) => v.toJson()).toList();
    }
    data['business_name'] = this.businessName;
    data['cluster_name'] = this.clusterName;
    data['customer_name'] = this.customerName;
    data['customer_note'] = this.customerNote;
    data['business_phones'] = this.businessPhones;
    data['customer_phones'] = this.customerPhones;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems.map((v) => v.toJson()).toList();
    }
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
