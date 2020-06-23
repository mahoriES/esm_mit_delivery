import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/User.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/Profile/model/profile_update_model.dart';
import 'package:esamudaayapp/modules/login/actions/login_actions.dart';
import 'package:esamudaayapp/modules/register/model/register_request_model.dart';
import 'package:esamudaayapp/redux/actions/general_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/URLs.dart';
import 'package:esamudaayapp/utilities/api_manager.dart';
import 'package:esamudaayapp/utilities/user_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateProfileAction extends ReduxAction<AppState> {
  final CustomerDetailsRequest request;

  UpdateProfileAction({this.request});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.profileUpdateURL,
        params: request.toJson(),
        requestType: RequestType.patch);

    if (response.status == ResponseStatus.success200) {
      UpdateProfileResponse authResponse =
          UpdateProfileResponse.fromJson(response.data);
      UserManager.saveToken(token: authResponse.token);
      UserManager.saveUser(User(
        id: authResponse.data.userProfile.userId,
        firstName: authResponse.data.profileName,
        phone: authResponse.data.userProfile.phone,
      )).then((onValue) {
        store.dispatch(GetUserFromLocalStorageAction());
      });
      dispatch(NavigateAction.pop());
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
      //throw UserException(response.data['status']);
    }
    return state.copyWith(authState: state.authState.copyWith());
  }

  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
}
