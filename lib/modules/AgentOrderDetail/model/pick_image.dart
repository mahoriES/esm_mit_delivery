class PickImage {
  double lat;
  double lon;
  List<PickupImages> pickupImages;

  PickImage({this.lat, this.lon, this.pickupImages});

  PickImage.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
    if (json['pickup_images'] != null) {
      pickupImages = new List<PickupImages>();
      json['pickup_images'].forEach((v) {
        pickupImages.add(new PickupImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    if (this.pickupImages != null) {
      data['pickup_images'] = this.pickupImages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PickupImages {
  String photoId;

  PickupImages({this.photoId});

  PickupImages.fromJson(Map<String, dynamic> json) {
    photoId = json['photo_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo_id'] = this.photoId;

    return data;
  }
}

class ImageResponse {
  String photoId;
  String photoUrl;
  String contentType;

  ImageResponse({this.photoId, this.photoUrl, this.contentType});

  ImageResponse.fromJson(Map<String, dynamic> json) {
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
