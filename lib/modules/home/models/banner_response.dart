class BannersResponse {
  List<String> banners;
  int statusCode;
  String status;

  BannersResponse({this.banners, this.statusCode, this.status});

  BannersResponse.fromJson(Map<String, dynamic> json) {
    banners = json['banners'].cast<String>();
    statusCode = json['statusCode'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banners'] = this.banners;
    data['statusCode'] = this.statusCode;
    data['status'] = this.status;
    return data;
  }
}
