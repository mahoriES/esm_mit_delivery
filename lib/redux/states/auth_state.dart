import 'package:esamudaayapp/models/User.dart';
import 'package:esamudaayapp/models/api_response_handler.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/login/model/get_otp_request.dart';
import 'package:esamudaayapp/modules/otp/model/validate_otp_request.dart';
import 'package:esamudaayapp/modules/register/model/register_request_model.dart';
import 'package:flutter/foundation.dart';

class AuthState {
  final String deviceToken;
  final LoadingStatus loadingStatus;
  final GenerateOTPRequest getOtpRequest;
  final ValidateOTPRequest validateOTPRequest;
  final CustomerDetailsRequest updateCustomerDetailsRequest;
  final String token;
  final bool isLoggedIn;
  final bool isLoginSkipped;
  final User user;
  final bool isPhoneNumberValid;
  final bool isOtpEntered;
  final bool isSignUp;

  AuthState(
      {@required this.getOtpRequest,
      @required this.isOtpEntered,
      @required this.isPhoneNumberValid,
      @required this.user,
      @required this.isLoginSkipped,
      @required this.loadingStatus,
      @required this.token,
      @required this.isLoggedIn,
      @required this.validateOTPRequest,
      @required this.isSignUp,
      @required this.updateCustomerDetailsRequest,
      @required this.deviceToken});

  factory AuthState.initial() {
    return new AuthState(
      token: "",
      isLoggedIn: false,
      loadingStatus: LoadingStatus.success,
      isLoginSkipped: false,
      user: null,
      isPhoneNumberValid: true,
      isOtpEntered: false,
      getOtpRequest: null,
      validateOTPRequest: null,
      updateCustomerDetailsRequest: null,
      isSignUp: false,
      deviceToken: "",
    );
  }

  AuthState copyWith(
      {User user,
      LoadingStatus loadingStatus,
      String mobileNumber,
      bool emailError,
      bool mobileNumberError,
      String emailErrorMessage,
      String passwordErrorMessage,
      String token,
      bool isLoggedIn,
      bool showAlert,
      bool isLoginSkipped,
      String apiErrorMessage,
      APIResponseHandlerModel apiResponseHandler,
      bool isFirstNameValid,
      bool isSecondNameValid,
      bool isPhoneNumberValid,
      bool isOtpEntered,
      GenerateOTPRequest getOtpRequest,
      ValidateOTPRequest validateOTPRequest,
      CustomerDetailsRequest updateCustomerDetailsRequest,
      bool isSignUp,
      String deviceToken}) {
    return new AuthState(
        deviceToken: token,
        user: user ?? this.user,
        isLoginSkipped: isLoginSkipped ?? this.isLoginSkipped,
        loadingStatus: loadingStatus ?? this.loadingStatus,
        token: token ?? this.token,
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        isPhoneNumberValid: isPhoneNumberValid ?? this.isPhoneNumberValid,
        isOtpEntered: isOtpEntered ?? this.isOtpEntered,
        getOtpRequest: getOtpRequest ?? this.getOtpRequest,
        validateOTPRequest: validateOTPRequest ?? this.validateOTPRequest,
        updateCustomerDetailsRequest:
            updateCustomerDetailsRequest ?? this.updateCustomerDetailsRequest,
        isSignUp: isSignUp ?? this.isSignUp);
  }
}
