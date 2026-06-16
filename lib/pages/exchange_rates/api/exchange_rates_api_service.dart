import 'package:dio/dio.dart';
import 'package:exchange_customer/core/networking/api_constans.dart';
import 'package:exchange_customer/pages/exchange_rates/model/exchange_rate_response_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
part 'exchange_rates_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ExchangeRatesApiService {
  factory ExchangeRatesApiService(Dio dio, {String baseUrl}) =
      _ExchangeRatesApiService;

  @GET(ApiConstants.exchangeRates)
  Future<ExchangeRateResponseModel> getExchangeRates();
}
