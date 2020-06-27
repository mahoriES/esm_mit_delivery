import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/model/transit_models.dart';
import 'package:esamudaayapp/redux/actions/general_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/URLs.dart';
import 'package:esamudaayapp/utilities/api_manager.dart';
import 'package:esamudaayapp/utilities/location.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class UpdateSelectedOrder extends ReduxAction<AppState> {
  final TransitDetails selectedOrder;

  UpdateSelectedOrder({this.selectedOrder});
  @override
  FutureOr<AppState> reduce() {
    // TODO: implement reduce
    return state.copyWith(
        homePageState:
            state.homePageState.copyWith(selectedOrder: selectedOrder));
  }
}

class GetAgentOrderList extends ReduxAction<AppState> {
  final String filter;

  GetAgentOrderList({this.filter});
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.getAgentOrderListURL,
        params: {"filter": filter},
        requestType: RequestType.get);
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      var responseModel = OrderResponse.fromJson(response.data);
      return state.copyWith(
          homePageState:
              state.homePageState.copyWith(orders: responseModel.results));
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

  GetAgentTransitOrderList({this.filter});
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.getTransitIdURL,
        params: {"filter": filter},
        requestType: RequestType.get);
    if (response.status == ResponseStatus.error404)
      //throw UserException(response.data['message']);
      return null;
    else if (response.status == ResponseStatus.error500)
      return null;
//      throw UserException('Something went wrong');
    else {
      var responseModel = OrderResponse.fromJson(response.data);
      return state.copyWith(
          homePageState:
              state.homePageState.copyWith(orders: responseModel.results));
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

class GetLocationAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    LocationData currentLocation;

    var location = new Location();

    var _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    if (await location.hasPermission() == PermissionStatus.granted) {
      currentLocation = await location.getLocation();
      if (currentLocation != null) {
        List<Placemark> placeMark = await Geolocator().placemarkFromCoordinates(
            currentLocation.latitude, currentLocation.longitude);
        return state.copyWith(
            homePageState:
                state.homePageState.copyWith(currentLocation: placeMark.first));
      }
    } else {
      var status = await location.requestPermission();

      if (status == PermissionStatus.granted) {
        currentLocation = await location.getLocation();
        if (currentLocation != null) {
          List<Placemark> placeMark = await Geolocator()
              .placemarkFromCoordinates(
                  currentLocation.latitude, currentLocation.longitude);
          return state.copyWith(
              homePageState: state.homePageState
                  .copyWith(currentLocation: placeMark.first));
        } else {
          return null;
        }
      } else {
        Fluttertoast.showToast(
                msg: "Please enable location permission from phone settings")
            .whenComplete(() async {
          Future.delayed(Duration(seconds: 2)).then((value) => goToSettings());
        });
        return null;
      }
    }
    return null;
  }
}
