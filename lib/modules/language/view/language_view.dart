import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  final bool fromAccount = false;
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    if (arguments != null) print("from_account ${arguments['fromAccount']}");

    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
          onInit: (store) {},
          model: _ViewModel(),
          builder: (context, snapshot) {
            return Scaffold(
              body: Column(children: [
                // Rectangle 1560
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(color: const Color(0xff2e82c3)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 48.0),
                      child: Text('screen_language.title',
                              style: const TextStyle(
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Avenir",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 24.0),
                              textAlign: TextAlign.left)
                          .tr(),
                    ),
                  ),
                ),
                // Choose your Preferred Language

                ListTile(
                  title: Text("English",
                      style: const TextStyle(
                          color: const Color(0xff2e2e2e),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.normal,
                          fontSize: 20.0),
                      textAlign: TextAlign.left),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    EasyLocalization.of(context).locale = Locale('en', 'US');
                    snapshot.navigateToPhoneNumberPage(
                        (arguments != null) ? arguments['fromAccount'] : false);
                  },
                ),

                // English

                // മലയാളം
                ListTile(
                  title: Text("മലയാളം",
                      style: const TextStyle(
                          color: const Color(0xff2e2e2e),
                          fontWeight: FontWeight.w300,
                          fontFamily: "Gotham",
                          fontStyle: FontStyle.normal,
                          fontSize: 20.0),
                      textAlign: TextAlign.left),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    EasyLocalization.of(context).locale = Locale('ml', 'IN');
                    snapshot.navigateToPhoneNumberPage(
                        (arguments != null) ? arguments['fromAccount'] : false);
                  },
                ),
                // ಕನ್ನಡ
                ListTile(
                  title: Text("ಕನ್ನಡ",
                      style: const TextStyle(
                          color: const Color(0xff2e2e2e),
                          fontWeight: FontWeight.w300,
                          fontFamily: "Gotham",
                          fontStyle: FontStyle.normal,
                          fontSize: 20.0),
                      textAlign: TextAlign.left),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    EasyLocalization.of(context).locale = Locale('ka', 'IN');
                    snapshot.navigateToPhoneNumberPage(
                        (arguments != null) ? arguments['fromAccount'] : false);
                  },
                ),
              ]),
            );
          }),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();
  Function(bool fromAccount) navigateToPhoneNumberPage;
  _ViewModel.build({
    this.navigateToPhoneNumberPage,
  }) : super(equals: []);

  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
      navigateToPhoneNumberPage: (value) {
        value
            ? dispatch(NavigateAction.pop())
            : dispatch(NavigateAction.pushNamed('/loginView'));
      },
    );
  }
}
