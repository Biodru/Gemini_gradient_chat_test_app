part of 'app_cubit.dart';

@freezed
abstract class AppState with _$AppState {
  const factory AppState.initial({
    @Default([
      'Ile lat ma Lewis Hamilton?',
      'Kto jest najlepszym kierowcą F1?',
      'Czy Robert Pattinson jest najlepszym Batmanem?',
    ])
    List<String> prompts,
    @Default(false) bool isLoading,
    List<Message>? items,
  }) = _InitialState;
}
