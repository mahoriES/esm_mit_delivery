import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/User.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/cart/actions/cart_actions.dart';
import 'package:esamudaayapp/modules/orders/models/order_models.dart';

import 'package:esamudaayapp/modules/orders/models/support_request_model.dart';

import 'package:esamudaayapp/redux/actions/general_actions.dart';

import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/repository/cart_datasourse.dart';
import 'package:esamudaayapp/utilities/URLs.dart';
import 'package:esamudaayapp/utilities/api_manager.dart';
import 'package:esamudaayapp/utilities/user_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GetOrderListAPIAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    User user = await UserManager.userDetails();
    var response = await APIManager.shared.request(
        url: ApiURL.getOrderListUrl,
        params: GetOrderListRequest(phoneNumber: user.phone).toJson(),
        requestType: RequestType.post);

    if (response.data['statusCode'] == 200) {
      GetOrderListResponse responseModel =
          GetOrderListResponse.fromJson(response.data);
      return state.copyWith(
          productState:
              state.productState.copyWith(getOrderListResponse: responseModel));
    } else {
      Fluttertoast.showToast(msg: response.data['status']);
    }
    return null;
  }

  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
}

class AddRatingAPIAction extends ReduxAction<AppState> {
  final AddReviewRequest request;

  AddRatingAPIAction({this.request});
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.reviewOrderURL,
        params: request.toJson(),
        requestType: RequestType.post);

    if (response.data['statusCode'] == 200) {
      dispatch(ChangeLoadingStatusAction(LoadingStatus.submitted));
    } else {
      Fluttertoast.showToast(msg: response.data['status']);
    }
    return null;
  }

  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.submitted));
}

class SupportAPIAction extends ReduxAction<AppState> {
  final SupportRequest request;

  SupportAPIAction({this.request});
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.supportURL,
        params: request.toJson(),
        requestType: RequestType.post);

    if (response.data['statusCode'] == 200) {
      Fluttertoast.showToast(
          msg:
              'Successfully raised an issue. Our support team will contact you shortly.');

      dispatch(ChangeLoadingStatusAction(LoadingStatus.submitted));
      dispatch(NavigateAction.pop());
    } else {
      Fluttertoast.showToast(msg: response.data['status']);
    }
    return null;
  }

  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.submitted));
}

class UpdateOrderAction extends ReduxAction<AppState> {
  final UpdateOrderRequest request;

  UpdateOrderAction({this.request});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.updateOrderUrl,
        params: request.toJson(),
        requestType: RequestType.post);

    if (response.data['statusCode'] == 200) {
      Fluttertoast.showToast(msg: response.data['status']);
      await CartDataSource.deleteAllMerchants();
      await CartDataSource.deleteAll();
      dispatch(GetCartFromLocal());
      dispatch(GetOrderListAPIAction());
    } else {
      request.orders[0].status = request.oldStatus;
      Fluttertoast.showToast(msg: response.data['status']);
    }
    return null;
  }

  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
}

class OrderSupportAction extends ReduxAction<AppState> {
  final String orderId;

  OrderSupportAction({this.orderId});

  @override
  FutureOr<AppState> reduce() {
    // TODO: implement reduce
    return state.copyWith(
        productState: state.productState.copyWith(supportOrder: orderId));
  }
}
