import 'dart:async';
import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/modules/AgentHome/view/my_home.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/view/order_detail.dart';
import 'package:esamudaayapp/modules/Profile/views/profile_view.dart';
import 'package:esamudaayapp/modules/accounts/views/accounts_view.dart';
import 'package:esamudaayapp/modules/login/actions/login_actions.dart';
import 'package:esamudaayapp/modules/login/views/login_View.dart';
import 'package:esamudaayapp/presentations/alert.dart';
import 'package:esamudaayapp/presentations/check_user_widget.dart';
import 'package:esamudaayapp/presentations/splash_screen.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/store.dart';
import 'package:esamudaayapp/utilities/push_notification.dart';
import 'package:esamudaayapp/utilities/sizeconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'modules/language/view/language_view.dart';
import 'modules/otp/view/otp_view.dart';
import 'services/crashylitics_delegate.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NavigateAction.setNavigatorKey(navigatorKey);
  runZonedGuarded(
    () async {
      runApp(EasyLocalization(
        child: MyAppBase(),
        supportedLocales: [
          Locale('en', 'US'),
          Locale('hi', 'IN'),
          Locale('ka', 'IN'),
          Locale('te', 'IN'),
          Locale('ta', 'IN')
        ],
        path: 'assets/languages',
      ));
    },
    (Object error, StackTrace stackTrace) {
      debugPrint(
          '********************************************** ${error.toString()}');
      debugPrint('********************************************** $stackTrace');

      /// Whenever an error occurs, call the `recordError` function. This sends
      /// Dart errors to crashlytics

      CrashlyticsDelegate.recordError(error, stackTrace);
    },
  );
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
    PushNotificationsManager().init();
    CrashlyticsDelegate.initializeCrashlytics();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SizeConfig().init(context);
    return StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        onInit: (store) {
          store.dispatch(CheckTokenAction());
//          store.dispatch(GetCartFromLocal());
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
      child: Center(child: Image.asset('assets/images/splash.png')),
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
          "/myHomeView": (BuildContext context) => new MyHomeView(),
          "/AccountsView": (BuildContext context) => AccountsView(),
          "/orderDetail": (BuildContext context) => OrderDetailScreen(),
          "/SMAlertView": (BuildContext context) => SMAlertView(),
          "/profile": (BuildContext context) => ProfileView(),
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
      child: Center(
          child: Hero(
              tag: "#image", child: Image.asset('assets/images/splash.png'))),
    );
  }

  void navigationPageHome() {
    Navigator.of(context).pushReplacementNamed('/loginView');
  }

  void navigationPageWel() {
    Navigator.of(context).pushReplacementNamed('/language');
  }
}
