import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/colors.dart';
import 'package:esamudaayapp/utilities/sizeconfig.dart';
import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    if (arguments != null) print("from_account ${arguments['fromAccount']}");

    final Map<String, Locale> locales = {
      "English": Locale('en', 'US'),
      "हिंदी": Locale('hi', 'IN'),
      "ಕನ್ನಡ": Locale('ka', 'IN'),
      "தமிழ்": Locale('ta', 'IN'),
      "తెలుగు": Locale('te', 'IN'),
    };
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
        onInit: (store) {},
        model: _ViewModel(),
        builder: (context, snapshot) {
          return Scaffold(
            body: Column(
              children: [
                // Rectangle 1560
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(color: AppColors.icColors),
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

                ListView.builder(
                  itemCount: locales.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => ListTile(
                    tileColor:
                        context.locale == locales[locales.keys.elementAt(index)]
                            ? AppColors.icColors
                            : Colors.white,
                    title: Text(
                      locales.keys.elementAt(index),
                      style: TextStyle(
                        color: context.locale ==
                                locales[locales.keys.elementAt(index)]
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                        fontStyle: FontStyle.normal,
                        fontSize: 20.toFont,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: context.locale ==
                              locales[locales.keys.elementAt(index)]
                          ? Colors.white
                          : Colors.black,
                    ),
                    onTap: () {
                      context.locale = locales[locales.keys.elementAt(index)];
                      snapshot.navigateToPhoneNumberPage((arguments != null)
                          ? arguments['fromAccount']
                          : false);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
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
