class DropImage {
  double lat;
  double lon;
  List<DropImages> dropImages;

  DropImage({this.lat, this.lon, this.dropImages});

  DropImage.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
    if (json['drop_images'] != null) {
      dropImages = new List<DropImages>();
      json['drop_images'].forEach((v) {
        dropImages.add(new DropImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    if (this.dropImages != null) {
      data['drop_images'] = this.dropImages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DropImages {
  String photoId;

  DropImages({this.photoId});

  DropImages.fromJson(Map<String, dynamic> json) {
    photoId = json['photo_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo_id'] = this.photoId;
    return data;
  }
}
