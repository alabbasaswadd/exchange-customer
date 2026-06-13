import 'package:bloc/bloc.dart';
import 'package:exchange_customer/core/constants/cached/cached_helper.dart';
import 'package:exchange_customer/pages/startup/cubit/startup_state.dart';

enum StartupDestination { home, signin, onboarding }

class StartupCubit extends Cubit<StartupState<StartupDestination>> {
  StartupCubit() : super(const StartupState.initial());

  Future<void> isLogin() async {
    emit(const StartupState.loading());
    final token = await CacheHelper.getString('token');
    if (token.isNotEmpty) {
      await Future.delayed(const Duration(seconds: 2));
      emit(const StartupState.success(StartupDestination.home));
      return;
    } else {
      await Future.delayed(const Duration(seconds: 2));
      emit(const StartupState.success(StartupDestination.signin));
    }
  }
}
