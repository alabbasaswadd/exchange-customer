import 'package:dio/dio.dart';
import 'package:exchange_customer/core/networking/api_constans.dart';
import 'package:exchange_customer/pages/exchange_requests/model/create_exchange_request_model.dart';
import 'package:exchange_customer/pages/exchange_requests/model/exchange_request_list_response_model.dart';
import 'package:exchange_customer/pages/exchange_requests/model/exchange_request_request_model.dart';
import 'package:exchange_customer/pages/exchange_requests/model/exchange_request_response_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'exchange_requests_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ExchangeRequestsApiService {
  factory ExchangeRequestsApiService(Dio dio, {String baseUrl}) =
      _ExchangeRequestsApiService;

  @GET(ApiConstants.getExchangeRequests)
  Future<ExchangeRequestListResponseModel> getExchangeRequests();

  @POST(ApiConstants.exchangeRequests)
  Future<ExchangeRequestResponseModel> createExchangeRequest(
    @Body() CreateExchangeRequestModel data,
  );

  @PUT('${ApiConstants.exchangeRequests}/{id}/status')
  Future<ExchangeRequestResponseModel> updateExchangeRequestStatus(
    @Path('id') String id,
    @Body() ExchangeRequestRequestModel data,
  );

  @PUT('${ApiConstants.exchangeRequests}/{id}')
  Future<ExchangeRequestResponseModel> updateExchangeRequest(
    @Path('id') String id,
    @Body() ExchangeRequestRequestModel request,
  );

  @DELETE('${ApiConstants.exchangeRequests}/{id}')
  Future<ExchangeRequestResponseModel> deleteExchangeRequest(
    @Path('id') String id,
  );
}
