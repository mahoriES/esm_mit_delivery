import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/modules/Profile/views/profile_view.dart';
import 'package:esamudaayapp/modules/accounts/views/accounts_view.dart';
import 'package:esamudaayapp/modules/cart/actions/cart_actions.dart';
import 'package:esamudaayapp/modules/cart/views/cart_view.dart';
import 'package:esamudaayapp/modules/home/views/my_home.dart';
import 'package:esamudaayapp/modules/login/actions/login_actions.dart';
import 'package:esamudaayapp/modules/login/views/login_View.dart';
import 'package:esamudaayapp/modules/orders/views/orders_View.dart';
import 'package:esamudaayapp/modules/accounts/views/recommended_shop.dart';
import 'package:esamudaayapp/modules/orders/views/support.dart';
import 'package:esamudaayapp/modules/register/view/register_view.dart';
import 'package:esamudaayapp/modules/search/views/Search_View.dart';
import 'package:esamudaayapp/modules/store_details/views/store_categories_details_view.dart';
import 'package:esamudaayapp/modules/store_details/views/store_product_listing_view.dart';
import 'package:esamudaayapp/presentations/alert.dart';
import 'package:esamudaayapp/presentations/check_user_widget.dart';
import 'package:esamudaayapp/presentations/splash_screen.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/store.dart';
import 'package:esamudaayapp/utilities/push_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modules/language/view/language_view.dart';
import 'modules/otp/view/otp_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  NavigateAction.setNavigatorKey(navigatorKey);

  runApp(EasyLocalization(
    child: MyAppBase(),
    supportedLocales: [
      Locale('en', 'US'),
      Locale('ka', 'IN'),
      Locale('ml', 'IN'),
    ],
    path: 'assets/languages',
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    PushNotificationsManager().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        onInit: (store) {
          store.dispatch(CheckTokenAction());
          store.dispatch(GetCartFromLocal());
          store.dispatch(GetUserFromLocalStorageAction());
        },
        builder: (context, snapshot) {
          return CustomSplashScreen(
            errorSplash: errorSplash(),
            backgroundColor: Colors.white,
            loadingSplash: loadingSplash(),
            seconds: 0,
            home: CheckUser(builder: (context, snapshot) {
              return snapshot
                  ? MyHomeView()
                  : CheckUserLoginSkipped(builder: (context, isLoginSkipped) {
                      return isLoginSkipped ? MyHomeView() : SplashScreen();
                    });
            }),
          );
        });
  }

  Widget errorSplash() {
    return Center(
      child: Text(
        "ERROR",
        style: TextStyle(fontSize: 25.0, color: Colors.red),
      ),
    );
  }

  Widget loadingSplash() {
    return Container(
      child: Center(child: Image.asset('assets/images/app_main_icon.png')),
    );
  }
}

class MyAppBase extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          EasyLocalization.of(context).delegate,
        ],
        supportedLocales: EasyLocalization.of(context).supportedLocales,
        locale: EasyLocalization.of(context).locale,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            primarySwatch: Colors.blue,
            fontFamily: "JTLeonor",
            appBarTheme: AppBarTheme(
//              color: FreshNetColors.green,
                )),
        home: UserExceptionDialog<AppState>(
          child: MyApp(),
          onShowUserExceptionDialog: (context, excpn) {
            print('sdas');
          },
        ),
        navigatorKey: navigatorKey,
        routes: <String, WidgetBuilder>{
          "/loginView": (BuildContext context) => new LoginView(),
          "/language": (BuildContext context) => new LanguageScreen(),
          "/otpScreen": (BuildContext context) => new OtpScreen(),
          "/mobileNumber": (BuildContext context) => new LoginView(),
          "/registration": (BuildContext context) => new Registration(),
          "/myHomeView": (BuildContext context) => new MyHomeView(),
          "/CartView": (BuildContext context) => CartView(),
          "/AccountsView": (BuildContext context) => AccountsView(),
          "/StoreDetailsView": (BuildContext context) => StoreDetailsView(),
          "/StoreProductListingView": (BuildContext context) =>
              StoreProductListingView(),
          "/ProductSearchView": (BuildContext context) => ProductSearchView(),
//          "/ManageAddresses": (BuildContext context) => ManageAddresses(),
          "/OrdersView": (BuildContext context) => OrdersView(),
          "/SMAlertView": (BuildContext context) => SMAlertView(),
          "/Support": (BuildContext context) => Support(),
          "/RecommendShop": (BuildContext context) => RecommendedShop(),
          "/profile": (BuildContext context) => ProfileView(),

//          "/SelectAddressView": (BuildContext context) => SelectAddressView()
        },
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  Function getAddressAndLoginStatus;

  _ViewModel();

  _ViewModel.build({this.getAddressAndLoginStatus});

  @override
  BaseModel fromStore() {
    return _ViewModel.build(getAddressAndLoginStatus: () {});
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');

    var _duration = new Duration(seconds: 3);

    if (firstTime != null && !firstTime) {
      // Not first time
      return new Timer(_duration, navigationPageHome);
    } else {
      // First time
      prefs.setBool('first_time', false);
      return new Timer(_duration, navigationPageWel);
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Center(child: Image.asset('assets/images/app_main_icon.png')),
    );
  }

  void navigationPageHome() {
    Navigator.of(context).pushReplacementNamed('/loginView');
  }

  void navigationPageWel() {
    Navigator.of(context).pushReplacementNamed('/language');
  }
}
