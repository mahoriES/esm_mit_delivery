import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/login/actions/login_actions.dart';
import 'package:esamudaayapp/modules/login/model/get_otp_request.dart';
import 'package:esamudaayapp/utilities/custom_widgets.dart';
import 'package:esamudaayapp/utilities/global.dart' as globals;
import 'package:esamudaayapp/utilities/stringConstants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:regexed_validator/regexed_validator.dart';

import '../../../redux/states/app_state.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String fcmToken = "";
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  fcm() {
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) {
        print('onLaunch called');
        return null;
      },
      onResume: (Map<String, dynamic> message) {
        print('onResume called');
        return null;
      },
      onMessage: (Map<String, dynamic> message) {
        print('onMessage called');
        return null;
      },
    );
    _firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
      sound: true,
      badge: true,
      alert: true,
    ));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print('Hello');
    });
    _firebaseMessaging.getToken().then((token) {
      print('Hello token');
      globals.deviceToken = token;
      print(token); // Print the Token in Console
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fcm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
          model: _ViewModel(),
          builder: (context, snapshot) {
            return // OTP

                ModalProgressHUD(
              inAsyncCall: snapshot.loadingStatus == LoadingStatus.loading,
              child: Scaffold(
                  body: Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width,
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(
                              flex: 2,
                            ),
                            Hero(
                              tag: "#image",
                              child: Image.asset(
                                  'assets/images/app_main_icon.png'),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Row(
                                children: <Widget>[
                                  AnimatedSwitcher(
                                    transitionBuilder: (Widget child,
                                            Animation<double> animation) =>
                                        ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    ),
                                    duration: const Duration(milliseconds: 200),
                                    child: snapshot.isSignUp
                                        ? Text("screen_phone.sign_up",
                                                key: ValueKey(1),
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff797979),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Avenir",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 18.0),
                                                textAlign: TextAlign.left)
                                            .tr()
                                        : Text("screen_phone.login",
                                                key: ValueKey(2),
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff797979),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Avenir",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 18.0),
                                                textAlign: TextAlign.left)
                                            .tr(),
                                  ),
                                ],
                              ),
                            ),
                            //phone number
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0, bottom: 29, left: 10, right: 10),
                              child: TextInputBG(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        child: Form(
                                          child: TextFormField(
                                              validator: (value) {
                                                if (value.length == 0)
                                                  return null;
                                                if (value.length < 10 ||
                                                    !validator.phone(value)) {
                                                  return tr(
                                                      'screen_phone.valid_phone_error_message');
                                                }
                                                return null;
                                              },
                                              autovalidate: true,
                                              controller: phoneController,
                                              keyboardType: TextInputType.phone,
                                              decoration: InputDecoration(
                                                hintText: tr(
                                                    'screen_phone.hint_text'),
                                                errorText: snapshot
                                                        .isPhoneNumberValid
                                                    ? null
                                                    : tr(
                                                        'screen_phone.valid_phone_error_message'),
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                              ),
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff1a1a1a),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Avenir",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14.0),
                                              textAlign: TextAlign.center),
                                          key: _formKey,
                                        ),
                                      ),
                                      Icon(
                                        Icons.phone_android,
                                        color: Colors.blueAccent,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Group 230
                            InkWell(
                              onTap: () {
                                if (validator.phone(phoneController.text) &&
                                    phoneController.text.length == 10) {
                                  snapshot.getOtpAction(GenerateOTPRequest(
                                      phone: "+91" + phoneController.text,
                                      third_party_id: thirdPartyId,
                                      isSignUp: snapshot.isSignUp));
                                } else {}
                              },
                              child: Hero(
                                tag: '#getOtp',
                                child: Material(
                                  type: MaterialType.transparency,
                                  elevation: 6.0,
                                  color: Colors.transparent,
                                  child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      height: 60,
                                      child: Stack(children: [
                                        // Rectangle 10
                                        PositionedDirectional(
                                          top: 0,
                                          start: 0,
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.2,
                                              height: 52,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(100)),
                                                  gradient: LinearGradient(
                                                      begin: Alignment(
                                                          0.023085936903953545,
                                                          0.5),
                                                      end: Alignment(
                                                          0.980859398841858,
                                                          0.5),
                                                      colors: [
                                                        const Color(0xff00dab2),
                                                        const Color(0xff3a90d3),
                                                        const Color(0xff3a90d3)
                                                      ]))),
                                        ),
                                        // Get OTP
                                        PositionedDirectional(
                                          top: 16.000030517578125,
                                          start: 0,
                                          child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.2,
                                              height: 22,
                                              child: Text(
                                                      'screen_phone.get_otp',
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xffffffff),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Avenir",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 16.0),
                                                      textAlign:
                                                          TextAlign.center)
                                                  .tr()),
                                        )
                                      ])),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Spacer(
                              flex: 3,
                            ),
                            Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                onTap: () {
                                  snapshot.updateIsSignUp(!snapshot.isSignUp);
                                },
                                child: // Already have an account? Login here
                                    RichText(
                                        text: TextSpan(children: [
                                  TextSpan(
                                      style: const TextStyle(
                                          color: const Color(0xff1a1a1a),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Avenir",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                      text: snapshot.isSignUp
                                          ? tr("screen_phone.already_customer")
                                          : tr("screen_phone.new_user")),
                                  TextSpan(
                                      style: const TextStyle(
                                          color: const Color(0xff5091cd),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Avenir",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                      text: snapshot.isSignUp
                                          ? tr("screen_phone.login_here")
                                          : tr("screen_phone.register_now"))
                                ])),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            )
                          ]),
                    ),
                  ),
                ),
              )),
            );
          }),
    );
  }

  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();
  Function navigateToOTPPage;
  Function updatePushToken;
  LoadingStatus loadingStatus;
  Function(GenerateOTPRequest request) getOtpAction;
  bool isPhoneNumberValid;

  Function(bool isSignup) updateIsSignUp;
  bool isSignUp;
  _ViewModel.build(
      {this.navigateToOTPPage,
      this.isPhoneNumberValid,
      this.getOtpAction,
      this.isSignUp,
      this.loadingStatus,
      this.updateIsSignUp,
      this.updatePushToken})
      : super(equals: [loadingStatus, isSignUp]);

  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
        loadingStatus: state.authState.loadingStatus,
        navigateToOTPPage: () {
          dispatch(NavigateAction.pushNamed('/otpScreen'));
        },
        isPhoneNumberValid: state.authState.isPhoneNumberValid,
        getOtpAction: (request) {
          dispatch(GetOtpAction(request: request, fromResend: false));
        },
        updateIsSignUp: (isSignUp) {
          dispatch(UpdateIsSignUpAction(isSignUp: isSignUp));
        },
        updatePushToken: (token) {
          globals.deviceToken = token;
        },
        isSignUp: state.authState.isSignUp);
  }
}
