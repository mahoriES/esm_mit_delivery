import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/User.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/login/actions/login_actions.dart';
import 'package:esamudaayapp/modules/otp/action/otp_action.dart';
import 'package:esamudaayapp/modules/register/model/register_request_model.dart';
import 'package:esamudaayapp/redux/actions/general_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/URLs.dart';
import 'package:esamudaayapp/utilities/api_manager.dart';
import 'package:esamudaayapp/utilities/user_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GetUserDetailAction extends ReduxAction<AppState> {
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.updateCustomerDetails,
        params: {"": ""},
        requestType: RequestType.get);

    if (response.status == ResponseStatus.success200) {
      GetProfileResponse authResponse =
          GetProfileResponse.fromJson(response.data);
      if (authResponse.cUSTOMER == null) {
        dispatch(NavigateAction.pushNamed('/registration'));
      } else {
        await UserManager.saveToken(token: authResponse.cUSTOMER.token);

        var user = User(
          id: authResponse.cUSTOMER.data.userProfile.userId,
          firstName: authResponse.cUSTOMER.data.profileName,
//        address: authResponse.customer.addresses.isEmpty
//            ? ""
//            : authResponse.customer.addresses.first.addressLine1,
          phone: authResponse.cUSTOMER.data.userProfile.phone,
        );
        await UserManager.saveUser(user).then((onValue) {
          store.dispatch(GetUserFromLocalStorageAction());
        });
        dispatch(AddFCMTokenAction());
        dispatch(CheckTokenAction());
        store.dispatch(GetUserFromLocalStorageAction());
        dispatch(NavigateAction.pushNamedAndRemoveAll("/myHomeView"));
        return state.copyWith(authState: state.authState.copyWith(user: user));
      }
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
      //throw UserException(response.data['status']);
    }
    return null;
  }

  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
}

class AddUserDetailAction extends ReduxAction<AppState> {
  final CustomerDetailsRequest request;

  AddUserDetailAction({this.request});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.updateCustomerDetails,
        params: request.toJson(),
        requestType: RequestType.post);

    if (response.status == ResponseStatus.success200) {
      RegisterResponse authResponse = RegisterResponse.fromJson(response.data);
      await UserManager.saveToken(token: authResponse.token);

      var user = User(
        id: authResponse.data.userProfile.userId,
        firstName: authResponse.data.profileName,
//        address: authResponse.customer.addresses.isEmpty
//            ? ""
//            : authResponse.customer.addresses.first.addressLine1,
        phone: authResponse.data.userProfile.phone,
      );
      await UserManager.saveUser(user).then((onValue) {
        store.dispatch(GetUserFromLocalStorageAction());
      });
      dispatch(CheckTokenAction());
      store.dispatch(GetUserFromLocalStorageAction());
      dispatch(NavigateAction.pushNamedAndRemoveAll("/myHomeView"));
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
      //throw UserException(response.data['status']);
    }
    return state.copyWith(
        authState:
            state.authState.copyWith(updateCustomerDetailsRequest: request));
  }

  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
}
