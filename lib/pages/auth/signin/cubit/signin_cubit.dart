import 'package:exchange_customer/core/constants/base_cubit.dart';
import 'package:exchange_customer/core/constants/cached/cached_helper.dart';
import 'package:exchange_customer/core/constants/functions.dart';
import 'package:exchange_customer/core/services/notification_service.dart';
import 'package:exchange_customer/pages/auth/signin/cubit/signin_state.dart';
import 'package:flutter/material.dart';

import '../api/signin_api.dart';
import '../model/signin_request_model.dart';

class SigninCubit extends BaseCubit<SigninState> {
  final SigninApi api;

  SigninCubit(this.api) : super(const SigninState.initial());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signin() async {
    if (!validateForm()) return;

    final tokenFcm = await CacheHelper.getString('tokenFCM');
    await executeApi(
      onLoading: () => emit(const SigninState.loading()),

      request: () => api.signin(
        SigninRequestModel(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          tokenFcm: tokenFcm,
        ),
      ),

      onSuccess: (response) async {
        if (response.succeeded == true && response.data != null) {
          final token = response.data!.token;
          await UserSession.updateSession(response);
          await CacheHelper.setString('token', token ?? "");
          emit(SigninState.success(response));
        } else {
          emit(
            SigninState.error(response.error?.message ?? 'فشل تسجيل الدخول'),
          );
        }
      },
      onError: (message) {
        emit(SigninState.error(message));
      },
    );
  }

  @override
  Future<void> close() {
    disposeControllers([emailController, passwordController]);

    return super.close();
  }

  Future<void> logout() async {
    await UserSession.clear();
    await CacheHelper.remove('token');
    emit(const SigninState.initial());
  }
}
