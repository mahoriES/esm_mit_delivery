import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/model/transit_models.dart';
import 'package:meta/meta.dart';

class HomePageState {
  final LoadingStatus loadingStatus;
  // final List<TransitDetails> orders;
  // final String homePageLoadedDate;
  final int currentIndex;
  // final List<Photo> banners;
  final TransitDetails selectedOrder;
  // final TransitDetails transitDetails;
  Map<String, OrderResponse> ordersList;

  // final Placemark currentLocation;

  HomePageState({
    @required this.selectedOrder,
    // @required this.response,
    // @required this.transitDetails,
    @required this.currentIndex,
    @required this.loadingStatus,
    @required this.ordersList,
    // @required this.orders,
    // @required this.homePageLoadedDate,
    // @required this.banners,
    // @required this.currentLocation,
  });

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
      // currentLocation: null,
      // transitDetails: null,
      selectedOrder: TransitDetails(),
      loadingStatus: LoadingStatus.success,
      // orders: [],
      // homePageLoadedDate: "0",
      currentIndex: 0,
      // banners: <Photo>[],
      ordersList: {},
    );
  }

  HomePageState copyWith({
    LoadingStatus loadingStatus,
    // List<TransitDetails> orders,
    // OrderResponse response,
    // List<Photo> banners,
    int currentIndex,
    // String homePageLoadedDate,
    TransitDetails selectedOrder,
    Map<String, OrderResponse> orderList,
    // Placemark currentLocation,
    // TransitDetails transitDetails,
  }) {
    return new HomePageState(
      // response: response ?? this.response,
      // currentLocation: currentLocation ?? this.currentLocation,
      // transitDetails: transitDetails ?? this.transitDetails,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      currentIndex: currentIndex ?? this.currentIndex,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      ordersList: orderList ?? this.ordersList,
      // orders: orders ?? this.orders,
      // homePageLoadedDate: homePageLoadedDate ?? this.homePageLoadedDate,
      // banners: banners ?? this.banners,
    );
  }
}
