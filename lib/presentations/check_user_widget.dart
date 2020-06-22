import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/modules/login/actions/login_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:flutter/cupertino.dart';

class CheckUser extends StatelessWidget {
  final Function(BuildContext context, bool isLoggedIn) builder;

  CheckUser({Key key, @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
      distinct: true,
      onInit: (store) {
        store.dispatch(CheckTokenAction());
      },
      converter: (Store<AppState> store) => store.state.authState.isLoggedIn,
      builder: builder,
    );
  }
}

class CheckUserLoginSkipped extends StatelessWidget {
  final Function(BuildContext context, bool isLoggedIn) builder;

  CheckUserLoginSkipped({Key key, @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
      onInit: (store) {
//        store.dispatch(CheckLoginSkippedAction());
      },
      converter: (Store<AppState> store) =>
          store.state.authState.isLoginSkipped,
      builder: builder,
    );
  }
}
