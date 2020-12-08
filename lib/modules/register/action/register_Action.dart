import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/models/User.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/accounts/action/account_action.dart';
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
      if (authResponse.agent == null) {
        Fluttertoast.showToast(msg: tr("error_messages.signup_error"));
        dispatch(LogoutAction());
      } else {
        await UserManager.saveToken(token: authResponse.agent.token);

        var user = User(
          id: authResponse.agent.data.userProfile.userId,
          firstName: authResponse.agent.data.profileName,
          phone: authResponse.agent.data.userProfile.phone,
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
    }
    return null;
  }

  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
}
