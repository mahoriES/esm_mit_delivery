import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/Profile/model/profile_update_model.dart';
import 'package:esamudaayapp/modules/login/model/authentication_response.dart';
import 'package:esamudaayapp/redux/actions/general_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/URLs.dart';
import 'package:esamudaayapp/utilities/api_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateProfileAction extends ReduxAction<AppState> {
  final ProfileUpdateRequest request;

  UpdateProfileAction({this.request});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.profileUpdateURL,
        params: request.toJson(),
        requestType: RequestType.post);

    if (response.data['statusCode'] == 200) {
      AuthResponse authResponse = AuthResponse.fromJson(response.data);
//      UserManager.saveToken(token: authResponse.customer.customerID);
//      UserManager.saveUser(User(
//        id: authResponse.customer.customerID,
//        firstName: authResponse.customer.name,
//        address: authResponse.customer.addresses.isEmpty
//            ? ""
//            : authResponse.customer.addresses.first.addressLine1,
//        phone: authResponse.customer.phoneNumber,
//      )).then((onValue) {
//        store.dispatch(GetUserFromLocalStorageAction());
//      });
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
