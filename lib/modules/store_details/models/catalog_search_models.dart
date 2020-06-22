class CatalogSearchRequest {
  String merchantID;
  List<String> categoryIDs;

  CatalogSearchRequest({this.merchantID, this.categoryIDs});

  CatalogSearchRequest.fromJson(Map<String, dynamic> json) {
    merchantID = json['merchantID'];
    categoryIDs = json['categoryIDs'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.merchantID != null) {
      data['merchantID'] = this.merchantID;
    }
    if (this.categoryIDs != null) {
      data['categoryIDs'] = this.categoryIDs;
    }
    return data;
  }
}

class CatalogSearchResponse {
  List<Catalog> catalog;
  int statusCode;
  String status;
  List<Products> products;

  CatalogSearchResponse(
      {this.catalog, this.statusCode, this.status, this.products});

  CatalogSearchResponse.fromJson(Map<String, dynamic> json) {
    if (json['catalog'] != null) {
      catalog = new List<Catalog>();
      json['catalog'].forEach((v) {
        catalog.add(new Catalog.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
    statusCode = json['statusCode'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.catalog != null) {
      data['catalog'] = this.catalog.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = this.statusCode;
    data['status'] = this.status;
    return data;
  }
}

class Catalog {
  String type;
  String id;
  String name;
  List<Products> products;

  Catalog({this.type, this.id, this.name, this.products});

  Catalog.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    name = json['name'];
    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String entryID;
  List<String> parentIDs;
  String merchantID;
  String entryName;
  String description;
  String entryType;
  Product product;

  Products(
      {this.entryID,
      this.parentIDs,
      this.merchantID,
      this.entryName,
      this.description,
      this.entryType,
      this.product});

  Products.fromJson(Map<String, dynamic> json) {
    entryID = json['entryID'];
    parentIDs = json['parentIDs'].cast<String>();
    merchantID = json['merchantID'];
    entryName = json['entryName'];
    description = json['description'];
    entryType = json['entryType'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entryID'] = this.entryID;
    data['parentIDs'] = this.parentIDs;
    data['merchantID'] = this.merchantID;
    data['entryName'] = this.entryName;
    data['description'] = this.description;
    data['entryType'] = this.entryType;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}

class Product {
  String service;
//  Specs specs;
  String name;
  double price;
  String category;
  String id;
  String skuSize;
  String imageLink;
  String restockingAt;
  int count;

  Product(
      {this.service,
      this.name,
      this.price,
      this.category,
      this.id,
      this.imageLink,
      this.restockingAt,
      this.count,
      this.skuSize});

  Product.fromJson(Map<String, dynamic> json) {
    skuSize = json['skuSize'];
//    specs = json['specs'] != null ? new Specs.fromJson(json['specs']) : null;
    name = json['name'];
    price = json['price'];
//    category = json['category'];
    id = json['id'];
    imageLink = json['imageLink'];
    restockingAt = json['restockingAt'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['service'] = this.service;
//    if (this.specs != null) {
//      data['specs'] = this.specs.toJson();
//    }
    data['name'] = this.name;
    data['price'] = this.price;
//    data['category'] = this.category;
    data['id'] = this.id;
    data['imageLink'] = this.imageLink;
    data['restockingAt'] = this.restockingAt;
    data['count'] = this.count;
    return data;
  }
}
