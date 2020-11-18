import 'dart:async';
import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/model/transit_models.dart';
import 'package:esamudaayapp/redux/actions/general_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/URLs.dart';
import 'package:esamudaayapp/utilities/api_manager.dart';

class UpdateSelectedOrder extends ReduxAction<AppState> {
  final TransitDetails selectedOrder;

  UpdateSelectedOrder({this.selectedOrder});
  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
        homePageState:
            state.homePageState.copyWith(selectedOrder: selectedOrder));
  }
}

class UpdateSelectedTabAction extends ReduxAction<AppState> {
  final index;
  UpdateSelectedTabAction(this.index);

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
        homePageState: state.homePageState.copyWith(currentIndex: index));
  }
}

class GetAgentOrderList extends ReduxAction<AppState> {
  final String filter;
  final String url;

  GetAgentOrderList({this.filter, this.url});
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
      url: ApiURL.getAgentOrderListURL,
      params: {"filter": filter},
      requestType: RequestType.get,
    );
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      var responseModel = OrderResponse.fromJson(response.data);
      if (url != null) {
        var pastOrders = state.homePageState.ordersList[filter].results;
        var currentOrders = responseModel.results;
        responseModel.results = pastOrders + currentOrders;
      }
      return state.copyWith(
          homePageState: state.homePageState.copyWith(
        orderList: {
          OrderStatusStrings.pending: filter == OrderStatusStrings.pending
              ? responseModel
              : state.homePageState.ordersList[OrderStatusStrings.pending],
          OrderStatusStrings.accepted: filter == OrderStatusStrings.accepted
              ? responseModel
              : state.homePageState.ordersList[OrderStatusStrings.accepted],
          OrderStatusStrings.picked: filter == OrderStatusStrings.picked
              ? responseModel
              : state.homePageState.ordersList[OrderStatusStrings.picked],
          OrderStatusStrings.dropped: filter == OrderStatusStrings.dropped
              ? responseModel
              : state.homePageState.ordersList[OrderStatusStrings.dropped],
        },
      ));
    }
  }

  @override
  FutureOr<void> before() {
    dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
    super.after();
  }
}

class GetAgentTransitOrderList extends ReduxAction<AppState> {
  final String filter;
  final String url;

  GetAgentTransitOrderList({this.filter, this.url});
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
      url: url != null ? url : ApiURL.getTransitIdURL,
      params: {"filter": filter},
      requestType: RequestType.get,
    );
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      var responseModel = OrderResponse.fromJson(response.data);
      if (url != null) {
        var pastOrders = state.homePageState.ordersList[filter].results;
        var currentOrders = responseModel.results;
        responseModel.results = pastOrders + currentOrders;
      }

      return state.copyWith(
          homePageState: state.homePageState.copyWith(
        orderList: {
          OrderStatusStrings.pending: filter == OrderStatusStrings.pending
              ? responseModel
              : state.homePageState.ordersList[OrderStatusStrings.pending],
          OrderStatusStrings.accepted: filter == OrderStatusStrings.accepted
              ? responseModel
              : state.homePageState.ordersList[OrderStatusStrings.accepted],
          OrderStatusStrings.picked: filter == OrderStatusStrings.picked
              ? responseModel
              : state.homePageState.ordersList[OrderStatusStrings.picked],
          OrderStatusStrings.dropped: filter == OrderStatusStrings.dropped
              ? responseModel
              : state.homePageState.ordersList[OrderStatusStrings.dropped],
        },
      ));
    }
  }

  @override
  FutureOr<void> before() {
    dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));
    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
    super.after();
  }
}
