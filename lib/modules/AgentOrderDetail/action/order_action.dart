import 'dart:async';
import 'dart:io';
import 'package:async_redux/async_redux.dart';
import 'package:dio/dio.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/AgentHome/action/AgentAction.dart';
import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/model/drop_image.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/model/pick_image.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/model/transit_models.dart';
import 'package:esamudaayapp/redux/actions/general_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/URLs.dart';
import 'package:esamudaayapp/utilities/api_manager.dart';
import 'package:esamudaayapp/utilities/user_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

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
      var responseModel = TransitDetails.fromJson(response.data);
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
            '/${state.homePageState.selectedOrder.transitId}',
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

class AcceptOrderAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
      url: ApiURL.getOrderDetails +
          '${state.homePageState.selectedOrder.requestId}',
      params: {},
      requestType: RequestType.post,
    );
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else if (response.status == ResponseStatus.success200) {
      var responseModel = TransitDetails.fromJson(response.data);
      // disptach these events to refresh the orders list
      dispatch(GetAgentOrderList(filter: OrderStatusStrings.accepted));
      dispatch(GetAgentOrderList(filter: OrderStatusStrings.pending));

      return state.copyWith(
        homePageState:
            state.homePageState.copyWith(selectedOrder: responseModel),
      );
    }
    return null;
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
    print('********** pick order action');

    var response = await APIManager.shared.request(
      url: ApiURL.getOrderDetails +
          '${state.homePageState.selectedOrder.requestId}/pick',
      params: {"lat": 0.0, "lon": 0.0}, //pickImage?.toJson(),
      requestType: RequestType.post,
    );
    print('********** pick order action response => $response');
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      // await UserManager.saveOrderProgressStatus(status: true);
      var responseModel = TransitDetails.fromJson(response.data);
      // disptach these events to refresh the orders list
      dispatch(GetAgentOrderList(filter: OrderStatusStrings.accepted));
      dispatch(GetAgentTransitOrderList(filter: OrderStatusStrings.picked));

      return state.copyWith(
        homePageState:
            state.homePageState.copyWith(selectedOrder: responseModel),
      );
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
    print(
        "drop order action => ${state.homePageState.selectedOrder.transitId}");
    var response = await APIManager.shared.request(
      url: ApiURL.getTransitIdURL +
          '/${state.homePageState.selectedOrder.transitId}/drop',
      params: {"lat": 0.0, "lon": 0.0},
      requestType: RequestType.post,
    );
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      var responseModel = TransitDetails.fromJson(response.data);
      // disptach these events to refresh the orders list
      dispatch(GetAgentTransitOrderList(filter: OrderStatusStrings.picked));
      dispatch(GetAgentTransitOrderList(filter: OrderStatusStrings.dropped));

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
      params: {},
      requestType: RequestType.delete,
    );
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      var responseModel = TransitDetails.fromJson(response.data);
      // disptach these events to refresh the orders list
      dispatch(GetAgentOrderList(filter: OrderStatusStrings.pending));
      return state.copyWith(
        homePageState:
            state.homePageState.copyWith(selectedOrder: responseModel),
      );
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
  final List<ImageResponse> existingImages;

  UploadImageAction(this.imageFile, this.existingImages);

  @override
  FutureOr<AppState> reduce() async {
    String token = await UserManager.getToken();
    if (token != null) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      FormData formData = new FormData.fromMap(
        {
          "file": new MultipartFile(
            stream,
            length,
            filename: basename(imageFile.path),
          )
        },
      );

      var response = await APIManager.shared.request(
        url: ApiURL.imageUpload,
        params: formData,
        requestType: RequestType.post,
      );

      if (response.status == ResponseStatus.error404)
        throw UserException(response.data['message']);
      else if (response.status == ResponseStatus.error500)
        throw UserException('Something went wrong');
      else {
        ImageResponse _imageResponse = ImageResponse.fromJson(response.data);
        dispatch(UpdateOrderImagesAction(existingImages..add(_imageResponse)));
      }
    } else {
      throw Exception('Auth Failed');
    }
    return null;
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

class UpdateOrderImagesAction extends ReduxAction<AppState> {
  final List<ImageResponse> imageResponse;
  UpdateOrderImagesAction(this.imageResponse);

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
      url: ApiURL.putImageInOrder +
          '${state.homePageState.selectedOrder.transitId}/images',
      params: {
        "images": List.generate(
            imageResponse.length, (index) => imageResponse[index].toJson())
      },
      requestType: RequestType.put,
    );
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      var responseModel = TransitDetails.fromJson(response.data);

      return state.copyWith(
        homePageState:
            state.homePageState.copyWith(selectedOrder: responseModel),
      );
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
