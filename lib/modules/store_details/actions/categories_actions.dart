import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/home/models/category_response.dart';
import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/modules/store_details/models/categories_models.dart';
import 'package:esamudaayapp/redux/actions/general_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/URLs.dart';
import 'package:esamudaayapp/utilities/api_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GetCategoriesDetailsAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url:
            "api/v1/businesses/${state.productState.selectedMerchand.businessId}/catalog/categories",
        params: {"": ""},
        requestType: RequestType.get);
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      var responseModel = CategoryResponse.fromJson(response.data);

      return state.copyWith(
          productState: state.productState.copyWith(
        categories: responseModel.categories,
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

class GetCategoriesAction extends ReduxAction<AppState> {
  final String merchantId;

  GetCategoriesAction({this.merchantId});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.getCategories,
        params: {"merchantID": merchantId},
        requestType: RequestType.post);
    if (response.data['statusCode'] == 200) {
      GetCategoriesResponse responseModel =
          GetCategoriesResponse.fromJson(response.data);
//      Merchants merchants = Merchants();
//      merchants = state.productState.selectedMerchand;
//      merchants.categories = responseModel.categories;
//      return state.copyWith(
//          productState:
//              state.productState.copyWith(selectedMerchant: merchants));
    } else {
      Fluttertoast.showToast(msg: response.data['status']);
    }

    return state.copyWith(authState: state.authState.copyWith());
  }

  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
}

class GetOrderDetailsAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.getOrderDetails +
            '${state.homePageState.selectedOrder.requestId}',
        params: {"": ""},
        requestType: RequestType.get);
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      var responseModel = OrderRequest.fromJson(response.data);
      return state.copyWith(
          homePageState:
              state.homePageState.copyWith(selectedOrder: responseModel));
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

class UploadImageAction extends ReduxAction<AppState> {
  final File imageFile;

  UploadImageAction({this.imageFile});
  @override
  FutureOr<AppState> reduce() async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(ApiURL.imageUpload);

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
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
