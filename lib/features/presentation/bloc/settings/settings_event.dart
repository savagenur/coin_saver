part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class UpdateLanguage extends SettingsEvent {
  final String language;
  const UpdateLanguage({
    required this.language,
  });

  @override
  List<Object> get props => [
        language,
      ];
}

class UpdateTheme extends SettingsEvent {
  final bool isDarkTheme;
  const UpdateTheme({
    required this.isDarkTheme,
  });

  @override
  List<Object> get props => [
        isDarkTheme,
      ];
}

class GetSettings extends SettingsEvent {
  const GetSettings();

  @override
  List<Object> get props => [];
}
