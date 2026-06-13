import 'package:exchange_customer/core/constants/base_api.dart';
import 'package:exchange_customer/core/networking/api_result.dart';
import 'package:exchange_customer/pages/currencies/api/currency_api_service.dart';
import 'package:exchange_customer/pages/currencies/model/currency_model.dart';
import 'package:exchange_customer/pages/currencies/model/currency_request_model.dart';

class CurrenciesApi extends BaseApi {
  final CurrenciesApiService _service;

  CurrenciesApi(this._service);

  Future<ApiResult<List<CurrencyModel>>> getCurrencies() => execute(
    request: () async {
      final res = await _service.getCurrencies();
      if (res.succeeded == true && res.data != null) {
        return res.data!.whereType<CurrencyModel>().toList();
      }
      throw Exception(res.error?.message ?? 'فشل جلب العملات');
    },
  );

  Future<ApiResult<CurrencyModel>> addCurrency(CurrencyRequestModel request) =>
      execute(
        request: () async {
          final res = await _service.addCurrency(request);
          if (res.succeeded == true &&
              res.data != null &&
              res.data!.isNotEmpty) {
            return res.data!.first!;
          }
          throw Exception(res.error?.message ?? 'فشل إضافة العملة');
        },
      );

  Future<ApiResult<CurrencyModel>> updateCurrency(
    String id,
    CurrencyRequestModel request,
  ) => execute(
    request: () async {
      final res = await _service.updateCurrency(id, request);
      if (res.succeeded == true && res.data != null && res.data!.isNotEmpty) {
        return res.data!.first!;
      }
      throw Exception(res.error?.message ?? 'فشل تحديث العملة');
    },
  );

  Future<ApiResult<bool>> deleteCurrency(String id) => execute(
    request: () async {
      final res = await _service.deleteCurrency(id);
      if (res.succeeded == true) return true;
      throw Exception(res.error?.message ?? 'فشل حذف العملة');
    },
  );
}
