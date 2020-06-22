import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';

class UpdateSelectedOrder extends ReduxAction<AppState> {
  final OrderRequest selectedOrder;

  UpdateSelectedOrder({this.selectedOrder});
  @override
  FutureOr<AppState> reduce() {
    // TODO: implement reduce
    return state.copyWith(
        homePageState:
            state.homePageState.copyWith(selectedOrder: selectedOrder));
  }
}
