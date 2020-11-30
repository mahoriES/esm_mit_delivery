import 'dart:io';

const tokenKey = 'token';
const userKey = 'user';
const addressKey = 'address';
const skipKey = "skip";
const inProgress = "inProgress";
const fcmToken = "fcm";
const orderIdKey = 'orderId';

//Errors
const emailError = "Email is not valid.";
const mobileNumberError = 'Mobile number is not valid.';
const firstNameError = 'Username is not valid.';
const lastNameError = 'Username is not valid.';
const errorMessage = "Enter a valid value.";

const password_error = "OTP should be at least 6 symbols long.";
const password_match_error = "Passwords are not match.";
const code_error = "Code is not valid.";

// URL's

const developmentURL = "http://api.freshnet.me";
const liveURL = "https://sewer-viewer.com";
const baseURL = developmentURL;
const generateOtp = "";

const countryCode = "+91";
const appName = "Fish";

const thirdPartyId = "5d730376-72ed-478c-8d5e-1a3a6aee9815";

class StringConstants {
  static final mapsUrl = (double lat, double lon) => Platform.isIOS
      ? 'https://maps.apple.com/?sll=$lat,$lon'
      : "https://www.google.com/maps/dir/?api=1&destination=$lat,$lon&dir_action=navigate";
  static final contactUrl = (String number) => "tel://$number";
}
