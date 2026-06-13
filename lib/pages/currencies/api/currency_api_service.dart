import 'package:dio/dio.dart';
import 'package:exchange_customer/core/networking/api_constans.dart';
import 'package:exchange_customer/pages/currencies/model/currency_request_model.dart';
import 'package:exchange_customer/pages/currencies/model/currency_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'currency_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class CurrenciesApiService {
  factory CurrenciesApiService(Dio dio, {String baseUrl}) =
      _CurrenciesApiService;

  @GET(ApiConstants.currencies)
  Future<CurrencyResponseModel> getCurrencies();

  @POST(ApiConstants.currencies)
  Future<CurrencyResponseModel> addCurrency(
    @Body() CurrencyRequestModel request,
  );

  @PUT('${ApiConstants.currencies}/{id}')
  Future<CurrencyResponseModel> updateCurrency(
    @Path('id') String id,
    @Body() CurrencyRequestModel request,
  );

  @DELETE('${ApiConstants.currencies}/{id}')
  Future<CurrencyResponseModel> deleteCurrency(@Path('id') String id);
}
