class ApiConstants {
  static const String apiBaseUrl =
      "https://shamcash.runasp.net/currency-exchange-api/api/";

  // Auth
  static const String signin = "User/Auth/login";

  // Exchange Rates
  static const String exchangeRates = "User/ExchangeRate";
  static const String exchangeRateUpdate = "User/ExchangeRate";

  // Currencies
  static const String currencies = "User/Currency";

  static const String exchangeRequests = "User/ExchangeRequest";
  static const String getExchangeRequests = "User/ExchangeRequest/my-requests";
  // Notifications
  static const String allNotifications = "User/Notification/my-notifications";
  static const String unreadNotifications = "User/Notification/unread-count";
  // static const String markReadNotifications = "User/Notification/mark-all-read";

  // Exchange Requests
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
