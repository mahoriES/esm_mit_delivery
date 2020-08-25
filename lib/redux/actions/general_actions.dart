import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';

class ChangeLoadingStatusAction extends ReduxAction<AppState> {
  final LoadingStatus loadingStatus;
  ChangeLoadingStatusAction(this.loadingStatus);

  @override
  AppState reduce() {
    // TODO: implement reduce
    return state.copyWith(
        authState: state.authState.copyWith(loadingStatus: loadingStatus));
  }
}
