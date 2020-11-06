import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/accounts/action/account_action.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AccountsView extends StatefulWidget {
  @override
  _AccountsViewState createState() => _AccountsViewState();
}

class _AccountsViewState extends State<AccountsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          tr('screen_account.title'),
          style: const TextStyle(
            color: const Color(0xff000000),
            fontWeight: FontWeight.w500,
            fontFamily: "Avenir",
            fontStyle: FontStyle.normal,
            fontSize: 20.0,
          ),
        ),
      ),
      body: StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        builder: (context, snapshot) {
          return Column(
            children: <Widget>[
              ListTile(
                onTap: () {
                  snapshot.navigateLanguage();
                },
                leading: Image.asset("assets/images/Group_240.png"),
                title: Text('screen_account.language',
                        style: const TextStyle(
                            color: const Color(0xff3c3c3c),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Avenir",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
                        textAlign: TextAlign.left)
                    .tr(),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
              ListTile(
                onTap: () {
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text("E-samudaay"),
                        content: Text('screen_account.alert_data').tr(),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(tr('screen_account.cancel')),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child:
                                Text(tr('screen_account.logout'.toLowerCase())),
                            onPressed: () async {
                              snapshot.logout();
                            },
                          )
                        ],
                      ));
                },
                leading: Image.asset("assets/images/power.png"),
                title: Text('screen_account.logout',
                        style: const TextStyle(
                            color: const Color(0xff3c3c3c),
                            fontWeight: FontWeight.w400,
                            fontFamily: "CircularStd-Book",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
                        textAlign: TextAlign.left)
                    .tr(),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
              Spacer(),
              Container(
                height: 100,
                child: Center(
                  child: Text("Version 1.0 Build 1",
                      style: const TextStyle(
                          color: const Color(0xff848282),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();
  LoadingStatus loadingStatus;
  Function navigateLanguage;
  Function logout;

  _ViewModel.build({
    this.loadingStatus,
    this.logout,
    this.navigateLanguage,
  }) : super(equals: [loadingStatus]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      loadingStatus: state.authState.loadingStatus,
      logout: () {
        dispatch(LogoutAction());
      },
      navigateLanguage: () {
        dispatch(NavigateAction.pushNamed(
          "/language",
          arguments: {"fromAccount": true},
        ));
      },
    );
  }
}
