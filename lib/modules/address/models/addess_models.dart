class Address {
  String addressName;
  String prettyAddress;
  double lat;
  double lon;
  GeoAddr geoAddr;

  Address(
      {this.addressName, this.prettyAddress, this.lat, this.lon, this.geoAddr});

  Address.fromJson(Map<String, dynamic> json) {
    addressName = json['address_name'];
    prettyAddress = json['pretty_address'];
    lat = json['lat'];
    lon = json['lon'];
    geoAddr = json['geo_addr'] != null
        ? new GeoAddr.fromJson(json['geo_addr'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_name'] = this.addressName;
    data['pretty_address'] = this.prettyAddress;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    if (this.geoAddr != null) {
      data['geo_addr'] = this.geoAddr.toJson();
    }
    return data;
  }
}

class GeoAddr {
  String pincode;

  GeoAddr({this.pincode});

  GeoAddr.fromJson(Map<String, dynamic> json) {
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pincode'] = this.pincode;
    return data;
  }
}
