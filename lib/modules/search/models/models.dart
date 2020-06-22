class SearchRequest {
  String phoneNumber;
  String searchQuery;

  SearchRequest({this.phoneNumber, this.searchQuery});

  SearchRequest.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    searchQuery = json['searchQuery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    data['searchQuery'] = this.searchQuery;
    return data;
  }
}
