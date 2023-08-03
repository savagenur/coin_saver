part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final String? language;
  final bool isDarkTheme;
  const SettingsState({
    this.language,
    required this.isDarkTheme,
  });

  @override
  List<Object?> get props => [
        language,
        isDarkTheme,
      ];
}
