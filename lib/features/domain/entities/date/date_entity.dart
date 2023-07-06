import 'package:equatable/equatable.dart';

class DateEntity extends Equatable {
  final String? name;
  final DateTime? dateTime;
  const DateEntity({
    this.name,
    this.dateTime,
  });

  @override
  List<Object?> get props => [name,dateTime,];
}
