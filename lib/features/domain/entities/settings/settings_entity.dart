import 'package:equatable/equatable.dart';

class SettingsEntity extends Equatable {
  final String? language;
  final bool isDarkTheme;
  const SettingsEntity({
    this.language,
     this.isDarkTheme=false,
  });
  @override
  List<Object?> get props => [
    language,
    isDarkTheme,
  ];
}
