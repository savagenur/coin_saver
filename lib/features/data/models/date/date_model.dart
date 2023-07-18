import 'package:coin_saver/features/domain/entities/date/date_entity.dart';

class DateModel extends DateEntity {
  final String? name;
  final DateTime? dateTime;
  const DateModel({
    this.name,
    this.dateTime,
  }) : super(
          name: name,
          dateTime: dateTime,
        );

 
}
