import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/model/transit_models.dart';
import 'package:esamudaayapp/modules/register/model/register_request_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

class HomePageState {
  final LoadingStatus loadingStatus;
  final List<TransitDetails> orders;
  final String homePageLoadedDate;
  final int currentIndex;
  final List<Photo> banners;
  final TransitDetails selectedOrder;
  final TransitDetails transitDetails;

  final Placemark currentLocation;

  HomePageState(
      {@required this.selectedOrder,
      @required this.transitDetails,
      @required this.currentIndex,
      @required this.loadingStatus,
      @required this.orders,
      @required this.homePageLoadedDate,
      @required this.banners,
      @required this.currentLocation});

//  static HomePageState fromJson(dynamic json) =>
//      HomePageState(homePageLoadedDate: json["homePageLoadedDate"]);
//
//  dynamic toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['homePageLoadedDate'] = this.homePageLoadedDate;
//    return data;
//  }

  factory HomePageState.initial() {
    return new HomePageState(
      currentLocation: null,
      transitDetails: null,
      selectedOrder: TransitDetails(),
      loadingStatus: LoadingStatus.success,
      orders: [],
      homePageLoadedDate: "0",
      currentIndex: 0,
      banners: <Photo>[],
    );
  }

  HomePageState copyWith(
      {LoadingStatus loadingStatus,
      List<TransitDetails> orders,
      List<Photo> banners,
      int currentIndex,
      String homePageLoadedDate,
      TransitDetails selectedOrder,
      Placemark currentLocation,
      TransitDetails transitDetails}) {
    return new HomePageState(
        currentLocation: currentLocation ?? this.currentLocation,
        transitDetails: transitDetails ?? this.transitDetails,
        selectedOrder: selectedOrder ?? this.selectedOrder,
        currentIndex: currentIndex ?? this.currentIndex,
        loadingStatus: loadingStatus ?? this.loadingStatus,
        orders: orders ?? this.orders,
        homePageLoadedDate: homePageLoadedDate ?? this.homePageLoadedDate,
        banners: banners ?? this.banners);
  }
}
