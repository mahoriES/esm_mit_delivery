import 'package:esamudaayapp/modules/home/models/merchant_response.dart';

class GetCategoriesResponse {
  String merchantID;
  List<Categories> categories;
  int statusCode;
  String status;

  GetCategoriesResponse(
      {this.merchantID, this.categories, this.statusCode, this.status});

  GetCategoriesResponse.fromJson(Map<String, dynamic> json) {
    merchantID = json['merchantID'];
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    statusCode = json['statusCode'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['merchantID'] = this.merchantID;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = this.statusCode;
    data['status'] = this.status;
    return data;
  }
}

// merchantID
