class ApiURL {
  static const eSamudayDevelopmentURL = "https://api.test.esamudaay.com/";
  static const liveURL = "https://api.esamudaay.com/";

  // change baseURL to liveURL for PROD mode.
  static const baseURL = eSamudayDevelopmentURL;

  static const generateOTPUrl = "api/v1/auth/token/";
  static const generateOtpRegisterUrl = "api/v1/auth/user/";
  static const updateCustomerDetails = "api/v1/auth/profiles";
  static const addressUrl = "api/v1/addresses/";
  static const recommendStoreURL = "Customer/v4/recommendAStore";
  static const profileUpdateURL = "api/v1/auth/profiles";
  static const getOrderDetails = "/api/v1/delivery/requests/";
  static const addFCMTokenUrl = "api/v1/notifications/mobile/tokens";
  static const getAgentOrderListURL = "api/v1/delivery/requests";
  static const imageUpload = baseURL + "api/v1/media/photo/";
  static const getTransitIdURL = "api/v1/delivery/transits";
  static const putImageInOrder = "/api/v1/delivery/transits/";
}
