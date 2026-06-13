import 'package:exchange_customer/core/constants/base_api.dart';
import 'package:exchange_customer/core/networking/api_result.dart';
import 'package:exchange_customer/pages/exchange_rates/api/exchange_rates_api_service.dart';
import 'package:exchange_customer/pages/exchange_rates/model/exchange_rate_model.dart';

class ExchangeRatesApi extends BaseApi {
  final ExchangeRatesApiService _service;

  ExchangeRatesApi(this._service);

  Future<ApiResult<List<ExchangeRateModel>>> getRates() =>
      execute(request: () => _service.getExchangeRates());
}
