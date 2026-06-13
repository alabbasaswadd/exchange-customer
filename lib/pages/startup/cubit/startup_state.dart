import 'package:freezed_annotation/freezed_annotation.dart';

part 'startup_state.freezed.dart';

@freezed
class StartupState<T> with _$StartupState<T> {
  const factory StartupState.initial() = _Initial;
  const factory StartupState.loading() = Loading;
  const factory StartupState.success(T data) = Success<T>;
  const factory StartupState.error(String errorMessage) = Error;
}
