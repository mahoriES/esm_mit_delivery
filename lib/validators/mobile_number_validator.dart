import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:flutter/cupertino.dart';

class MobileNumberValidator extends StatelessWidget {
  final Function(BuildContext context, bool isEmailValid) builder;

  const MobileNumberValidator({Key key, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
        converter: (Store<AppState> store) =>
            true, //isMobileNumberValid(store.state),
        builder: builder);
  }
}

class PasswordValidator extends StatelessWidget {
  final Function(BuildContext context, bool isEmailValid) builder;

  const PasswordValidator({Key key, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
        converter: (Store<AppState> store) =>
            true, //isPasswordValid(store.state),
        builder: builder);
  }
}

class FirstNameValidator extends StatelessWidget {
  final Function(BuildContext context, bool isNameValid) builder;

  const FirstNameValidator({Key key, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
        converter: (Store<AppState> store) =>
            true, //isFirstNameValid(store.state),
        builder: builder);
  }
}

class SecondNameValidator extends StatelessWidget {
  final Function(BuildContext context, bool isNameValid) builder;

  const SecondNameValidator({Key key, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
        converter: (Store<AppState> store) =>
            true, //isSecondNameValid(store.state),
        builder: builder);
  }
}

class EmailValidator extends StatelessWidget {
  final Function(BuildContext context, bool isNameValid) builder;

  const EmailValidator({Key key, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
        converter: (Store<AppState> store) => true, //isEmailValid(store.state),
        builder: builder);
  }
}
