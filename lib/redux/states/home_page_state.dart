import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/home/models/merchant_response.dart';
import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/modules/register/model/register_request_model.dart';
import 'package:meta/meta.dart';

class HomePageState {
  final LoadingStatus loadingStatus;
  final List<OrderRequest> orders;
  final String homePageLoadedDate;
  final int currentIndex;
  final List<Photo> banners;
  final OrderRequest selectedOrder;

  HomePageState(
      {@required this.selectedOrder,
      @required this.currentIndex,
      @required this.loadingStatus,
      @required this.orders,
      @required this.homePageLoadedDate,
      @required this.banners});

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
      selectedOrder: OrderRequest(),
      loadingStatus: LoadingStatus.success,
      orders: [],
      homePageLoadedDate: "0",
      currentIndex: 0,
      banners: <Photo>[],
    );
  }

  HomePageState copyWith({
    LoadingStatus loadingStatus,
    List<OrderRequest> orders,
    List<Photo> banners,
    int currentIndex,
    String homePageLoadedDate,
    OrderRequest selectedOrder,
  }) {
    return new HomePageState(
        selectedOrder: selectedOrder ?? this.selectedOrder,
        currentIndex: currentIndex ?? this.currentIndex,
        loadingStatus: loadingStatus ?? this.loadingStatus,
        orders: orders ?? this.orders,
        homePageLoadedDate: homePageLoadedDate ?? this.homePageLoadedDate,
        banners: banners ?? this.banners);
  }
}
