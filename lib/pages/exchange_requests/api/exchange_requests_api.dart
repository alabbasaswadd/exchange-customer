import 'package:exchange_customer/core/constants/base_api.dart';
import 'package:exchange_customer/core/networking/api_result.dart';
import 'package:exchange_customer/pages/exchange_requests/api/exchange_requests_api_service.dart';
import 'package:exchange_customer/pages/exchange_requests/model/create_exchange_request_model.dart';
import 'package:exchange_customer/pages/exchange_requests/model/exchange_request_model.dart';
import 'package:exchange_customer/pages/exchange_requests/model/exchange_request_request_model.dart';
import 'package:exchange_customer/pages/exchange_requests/model/exchange_request_response_model.dart';

class ExchangeRequestsApi extends BaseApi {
  final ExchangeRequestsApiService _service;

  ExchangeRequestsApi(this._service);

  Future<ApiResult<ExchangeRequestResponseModel>> createRequest(
    CreateExchangeRequestModel data,
  ) => execute(request: () => _service.createExchangeRequest(data));

  Future<ApiResult<List<ExchangeRequestModel>>> getRequests() => execute(
    request: () async {
      final response = await _service.getExchangeRequests();
      return response.data ?? [];
    },
  );

  Future<ApiResult<ExchangeRequestResponseModel>> updateRequest(
    String id,
    ExchangeRequestRequestModel data,
  ) => execute(
    request: () async {
      return await _service.updateExchangeRequest(id, data);
    },
  );

  // Future<ApiResult<bool>> rejectRequest(String id) => execute(
  //       request: () async {
  //         await _service.rejectRequest(id);
  //         return true;
  //       },
  //     );

  // Future<ApiResult<bool>> suspendRequest(String id) => execute(
  //       request: () async {
  //         await _service.suspendRequest(id);
  //         return true;
  //       },
  //     );
}
