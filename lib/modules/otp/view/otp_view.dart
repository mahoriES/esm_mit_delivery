import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/login/actions/login_actions.dart';
import 'package:esamudaayapp/modules/otp/action/otp_action.dart';
import 'package:esamudaayapp/modules/otp/model/validate_otp_request.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  Timer _timer;
  int _start = 30;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
          onInit: (store) {
            startTimer();
//                store.dispatch(GetLocationAction());
//                store.dispatch(GetCartFromLocal());
          },
          model: _ViewModel(),
          builder: (context, snapshot) {
            return ModalProgressHUD(
              inAsyncCall: snapshot.loadingStatus == LoadingStatus.loading,
              child: Scaffold(
                  appBar: AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      brightness: Brightness.light,
                      leading: new IconButton(
                        icon: new Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      )),
                  body: Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Hero(
                              tag: "#image",
                              child: Image.asset(
                                  'assets/images/app_main_icon.png'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Hero(
                                tag: '#text',
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Text(
                                          tr('screen_otp.hint_text') +
                                              " " +
                                              snapshot.phoneNumber,
                                          style: const TextStyle(
                                              color: const Color(0xff868b8e),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Avenir",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 14.0),
                                          textAlign: TextAlign.center)
                                      .tr(),
                                ),
                              ),
                            ),
                            //phone number
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: OTPField(
                                length: 6,
                                width: MediaQuery.of(context).size.width,
                                textFieldAlignment:
                                    MainAxisAlignment.spaceAround,
//                            fieldWidth: 50,
                                fieldStyle: FieldStyle.underline,
                                style: TextStyle(fontSize: 17),
                                onChanged: (pin) {
                                  snapshot
                                      .updateOtpEnterStatus(pin.length == 6);
                                },
                                onCompleted: (pin) async {
                                  print("Completed: " + pin);
                                  snapshot
                                      .updateOtpEnterStatus(pin.length == 6);

                                  snapshot.updateValidationRequest(
                                      ValidateOTPRequest(
                                          token: pin,
                                          phone: snapshot.phoneNumber));
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: _start == 0
                                  ? Material(
                                      type: MaterialType.transparency,
                                      child: InkWell(
                                        onTap: () {
                                          snapshot.resendOtpRequest();
                                          _start = 30;
                                          startTimer();
                                        },
                                        child: Text('screen_otp.resend_otp',
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff3795d1),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Avenir",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 14.0),
                                                textAlign: TextAlign.left)
                                            .tr(),
                                      ),
                                    )
                                  : Text(
                                          tr('screen_otp.resend_text') +
                                              ' $_start ' +
                                              tr('screen_otp.sec.'),
                                          style: const TextStyle(
                                              color: const Color(0xff3795d1),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Avenir",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 14.0),
                                          textAlign: TextAlign.left)
                                      .tr(),
                            ),
                            // Group 230
                            Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                onTap: () async {
                                  if (snapshot.otpEntered) {
                                    snapshot.verifyOTP(ValidateOTPRequest(
                                      phone: snapshot.phoneNumber,
                                    ));
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: tr(
                                            'screen_otp.error.plz_verify_otp'));
                                  }
                                },
                                child: Hero(
                                  tag: '#getOtp',
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
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
                                                            Radius.circular(
                                                                100)),
                                                    gradient: LinearGradient(
                                                        begin: Alignment(
                                                            0.023085936903953545,
                                                            0.5),
                                                        end: Alignment(0.980859398841858, 0.5),
                                                        colors: [
                                                          const Color(
                                                              0xff00dab2),
                                                          const Color(
                                                              0xff3a90d3),
                                                          const Color(
                                                              0xff3a90d3)
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
                                                child: Text('screen_otp.verify',
                                                        style: const TextStyle(
                                                            color: const Color(
                                                                0xffffffff),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                "Avenir",
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 16.0),
                                                        textAlign:
                                                            TextAlign.center)
                                                    .tr()),
                                          )
                                        ])),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                          ]),
                    ),
                  )),
            ); // OTP
          }),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();
  Function(ValidateOTPRequest) verifyOTP;
  Function(ValidateOTPRequest) updateValidationRequest;
  Function() resendOtpRequest;
  String phoneNumber;
  bool otpEntered;
  LoadingStatus loadingStatus;
  Function(bool) updateOtpEnterStatus;
  _ViewModel.build(
      {this.verifyOTP,
      this.loadingStatus,
      this.otpEntered,
      this.updateOtpEnterStatus,
      this.updateValidationRequest,
      this.phoneNumber,
      this.resendOtpRequest})
      : super(equals: [otpEntered, loadingStatus]);

  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
        loadingStatus: state.authState.loadingStatus,
        verifyOTP: (request) {
          dispatch(ValidateOtpAction(isSignUp: state.authState.isSignUp));
        },
        otpEntered: state.authState.isOtpEntered,
        updateOtpEnterStatus: (newValue) {
          dispatch(OTPAction(isValid: newValue));
        },
        updateValidationRequest: (request) {
          dispatch(UpdateValidationRequest(request: request));
        },
        resendOtpRequest: () {
          dispatch(GetOtpAction(
              request: state.authState.getOtpRequest, fromResend: true));
        },
        phoneNumber: state.authState.getOtpRequest.phone);
  }
}
