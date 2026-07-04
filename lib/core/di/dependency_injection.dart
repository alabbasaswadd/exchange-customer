import 'package:exchange_customer/pages/auth/signin/api/signin_api.dart';
import 'package:exchange_customer/pages/auth/signin/api/signin_api_service.dart';
import 'package:exchange_customer/pages/auth/signin/cubit/signin_cubit.dart';
import 'package:exchange_customer/pages/currencies/api/currencies_api.dart';
import 'package:exchange_customer/pages/currencies/api/currency_api_service.dart';
import 'package:exchange_customer/pages/currencies/cubit/currencies_cubit.dart';
import 'package:exchange_customer/pages/exchange_rates/api/exchange_rates_api.dart';
import 'package:exchange_customer/pages/exchange_rates/api/exchange_rates_api_service.dart';
import 'package:exchange_customer/pages/exchange_rates/cubit/exchange_rates_cubit.dart';
import 'package:exchange_customer/pages/exchange_requests/api/exchange_requests_api.dart';
import 'package:exchange_customer/pages/exchange_requests/api/exchange_requests_api_service.dart';
import 'package:exchange_customer/pages/exchange_requests/cubit/exchange_requests_cubit.dart';
import 'package:exchange_customer/pages/notifications/api/notifications_api.dart';
import 'package:exchange_customer/pages/notifications/api/notifications_api_service.dart';
import 'package:exchange_customer/pages/notifications/cubit/notifications_cubit.dart';
import 'package:exchange_customer/pages/startup/cubit/startup_cubit.dart';
import 'package:get_it/get_it.dart';

import '../networking/dio_factory.dart';

final getIt = GetIt.instance;

Future<void> initDI() async {
  getIt.registerLazySingleton(() => DioFactory.getDio());

  getIt.registerLazySingleton(() => SigninApi(getIt()));
  getIt.registerLazySingleton(() => SigninApiService(getIt()));

  getIt.registerLazySingleton(() => CurrenciesApiService(getIt()));
  getIt.registerLazySingleton(() => CurrenciesApi(getIt()));

  getIt.registerLazySingleton(() => ExchangeRatesApiService(getIt()));
  getIt.registerLazySingleton(() => ExchangeRatesApi(getIt()));

  getIt.registerLazySingleton(() => ExchangeRequestsApiService(getIt()));
  getIt.registerLazySingleton(() => ExchangeRequestsApi(getIt()));

  getIt.registerFactory(() => StartupCubit());
  getIt.registerFactory(() => SigninCubit(getIt()));
  getIt.registerLazySingleton(() => NotificationsApiService(getIt()));
  getIt.registerLazySingleton(() => NotificationsApi(getIt()));
  getIt.registerFactory(() => NotificationsCubit(getIt()));
  getIt.registerFactory(() => CurrenciesCubit(getIt()));
  getIt.registerFactory(() => ExchangeRatesCubit(getIt()));
  getIt.registerFactory(() => ExchangeRequestsCubit(getIt()));
}
