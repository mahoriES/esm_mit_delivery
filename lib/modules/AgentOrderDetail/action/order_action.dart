import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/model/drop_image.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/model/pick_image.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/model/transit_models.dart';
import 'package:esamudaayapp/redux/actions/general_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/URLs.dart';
import 'package:esamudaayapp/utilities/api_manager.dart';
import 'package:esamudaayapp/utilities/user_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

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

class GetTransitDetailsAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.getTransitIdURL +
            '${state.homePageState.selectedOrder.requestId}',
        params: {"": ""},
        requestType: RequestType.get);
    if (response.status == ResponseStatus.error404)
      //throw UserException(response.data['message']);
      return null;
    else if (response.status == ResponseStatus.error500)
      return null;
//      throw UserException('Something went wrong');
    else {
      var responseModel = TransitDetails.fromJson(response.data);
      return state.copyWith(
          homePageState:
              state.homePageState.copyWith(transitDetails: responseModel));
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

class AcceptOrderAction extends ReduxAction<AppState> {
  final ImageResponse imageResponse;
  AcceptOrderAction({this.imageResponse});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.getOrderDetails +
            '${state.homePageState.selectedOrder.requestId}',
        params: {"": ""},
        requestType: RequestType.post);
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      var responseModel = OrderRequest.fromJson(response.data);
      await UserManager.saveOrderProgressStatus(status: true);
      dispatch(PickOrderAction(
          pickImage: PickImage(
              lat: state.homePageState.currentLocation.position.latitude,
              lon: state.homePageState.currentLocation.position.longitude,
              pickupImages: [
            PickupImages(
                photoId:
                    imageResponse.photoId != null ? imageResponse.photoId : "")
          ])));
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

class PickOrderAction extends ReduxAction<AppState> {
  final PickImage pickImage;

  PickOrderAction({this.pickImage});
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.getOrderDetails +
            '${state.homePageState.selectedOrder.requestId}',
        params: pickImage.toJson(),
        requestType: RequestType.post);
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

class DropOrderAction extends ReduxAction<AppState> {
  final DropImage dropImage;

  DropOrderAction({this.dropImage});
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.getOrderDetails +
            '${state.homePageState.selectedOrder.requestId}',
        params: dropImage.toJson(),
        requestType: RequestType.post);
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

class RejectOrderAction extends ReduxAction<AppState> {
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
  final bool isPickUp;

  UploadImageAction({this.imageFile, this.isPickUp});
  @override
  FutureOr<AppState> reduce() async {
    String token = await UserManager.getToken();

    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(ApiURL.imageUpload);
    print(uri);

    var request = new http.MultipartRequest("POST", uri);
    if (token != null && token != "") {
      Map<String, String> headers = {"Authorization": "JWT $token"};
      request.headers.addAll(headers);
    }

    var multipartFile = new http.MultipartFile(
      'file',
      stream,
      length,
      filename: basename(imageFile.path),
    );
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);

    var response = await request.send();
    print(response.statusCode);
    if (isPickUp) {
      dispatch(AcceptOrderAction(imageResponse: ImageResponse()));
    } else {}
    Fluttertoast.showToast(
        msg: response.reasonPhrase != null ? response.reasonPhrase : "");
    response.stream.transform(utf8.decoder).listen((value) {
      print("value");
      print(value);
      final body = json.decode(value);
      print(body);
      ImageResponse imageResponse = ImageResponse.fromJson(body);

      if (isPickUp) {
        dispatch(AcceptOrderAction(imageResponse: imageResponse));
      } else {}
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
