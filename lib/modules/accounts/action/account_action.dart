import 'dart:async';
import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/redux/actions/general_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/redux/states/auth_state.dart';
import 'package:esamudaayapp/redux/states/home_page_state.dart';
import 'package:esamudaayapp/utilities/user_manager.dart';

class LogoutAction extends ReduxAction<AppState> {
  LogoutAction();

  @override
  FutureOr<AppState> reduce() async {
    await UserManager.deleteUser();
    dispatch(NavigateAction.pushNamedAndRemoveAll('/loginView'));
    return state.copyWith(
      authState: AuthState.initial(),
      isLoading: false,
      homePageState: HomePageState.initial(),
    );
  }

  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
}
