import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/accounts/model/recommend_request.dart';
import 'package:esamudaayapp/redux/actions/general_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/redux/states/auth_state.dart';
import 'package:esamudaayapp/redux/states/home_page_state.dart';
import 'package:esamudaayapp/redux/states/product_state.dart';
import 'package:esamudaayapp/repository/cart_datasourse.dart';
import 'package:esamudaayapp/utilities/URLs.dart';
import 'package:esamudaayapp/utilities/api_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LogoutAction extends ReduxAction<AppState> {
  LogoutAction();

  @override
  FutureOr<AppState> reduce() async {
//    var response = await APIManager.shared.request(
//        url: ApiURL.logoutURL, requestType: RequestType.post, params: {});
//
//    if (response.data['statusCode'] == 200) {
//      await CartDataSource.deleteAllMerchants();
//      await CartDataSource.deleteAll();
//      dispatch(NavigateAction.pushNamedAndRemoveAll('/loginView'));
//    } else {
//      Fluttertoast.showToast(msg: response.data['status']);
//      //throw UserException(response.data['status']);
//    }
    await CartDataSource.deleteAllMerchants();
    await CartDataSource.deleteAll();

    return state.copyWith(
        authState: AuthState.initial(),
        isLoading: false,
        productState: ProductState.initial(),
        homePageState: HomePageState.initial());
  }

  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
}

class RecommendAction extends ReduxAction<AppState> {
  final RecommendedShopRequest request;

  RecommendAction({this.request});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.recommendStoreURL,
        params: request.toJson(),
        requestType: RequestType.post);

    if (response.data['statusCode'] == 200) {
      Fluttertoast.showToast(
          msg: "Successfully recommended ${request.storeName} ");
      dispatch(NavigateAction.pop());
    } else {
      Fluttertoast.showToast(msg: response.data['status']);
      //throw UserException(response.data['status']);
    }

    return state.copyWith(authState: state.authState.copyWith());
  }

  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
}
