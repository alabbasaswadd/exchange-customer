import 'package:dio/dio.dart';
import 'package:exchange_customer/core/networking/api_constans.dart';
import 'package:exchange_customer/pages/auth/signin/model/signin_request_model.dart';
import 'package:exchange_customer/pages/auth/signin/model/signin_response_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'signin_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class SigninApiService {
  factory SigninApiService(Dio dio, {String baseUrl}) = _SigninApiService;

  @POST(ApiConstants.signin)
  Future<SigninResponseModel> signin(@Body() SigninRequestModel request);
}
