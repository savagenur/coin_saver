import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:coin_saver/features/domain/entities/settings/settings_entity.dart';
import 'package:coin_saver/features/domain/usecases/settings/get_settings_usecase.dart';
import 'package:coin_saver/features/domain/usecases/settings/update_language_usecase.dart';
import 'package:coin_saver/features/domain/usecases/settings/update_theme_usecase.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettingsUsecase getSettingsUsecase;
  final UpdateLanguageUsecase updateLanguageUsecase;
  final UpdateThemeUsecase updateThemeUsecase;
  SettingsBloc({
    required this.getSettingsUsecase,
    required this.updateLanguageUsecase,
    required this.updateThemeUsecase,
  }) : super(const SettingsState(
          language: "en",
          isDarkTheme: false,
        )) {
    on<UpdateTheme>(_onUpdateTheme);
    on<UpdateLanguage>(_onUpdateLanguage);
    on<GetSettings>(_onGetSettings);
  }

  FutureOr<void> _onUpdateTheme(
      UpdateTheme event, Emitter<SettingsState> emit) async {
    await updateThemeUsecase.call(event.isDarkTheme);
    final SettingsEntity settingsEntity = await getSettingsUsecase.call();

    emit(SettingsState(
      isDarkTheme: settingsEntity.isDarkTheme,
      language: settingsEntity.language,
    ));
  }

  FutureOr<void> _onUpdateLanguage(
      UpdateLanguage event, Emitter<SettingsState> emit) async {
    await updateLanguageUsecase.call(event.language);
    final SettingsEntity settingsEntity = await getSettingsUsecase.call();
    emit(SettingsState(
      isDarkTheme: settingsEntity.isDarkTheme,
      language: settingsEntity.language,
    ));
  }

  FutureOr<void> _onGetSettings(
      GetSettings event, Emitter<SettingsState> emit) async {
    final SettingsEntity settingsEntity = await getSettingsUsecase.call();
    emit(SettingsState(
      isDarkTheme: settingsEntity.isDarkTheme,
      language: settingsEntity.language,
    ));
  }
}
