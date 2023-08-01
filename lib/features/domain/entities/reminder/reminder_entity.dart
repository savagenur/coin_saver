import 'package:equatable/equatable.dart';

class ReminderEntity extends Equatable {
  final int id;
  final String title;
  final String body;
  final int? day;
  final int? month;
  final int? year;
  final int hour;
  final int minute;
  final bool? repeats;
  final bool isActive;
  final int? weekday;
  const ReminderEntity({
    required this.id,
    required this.title,
    required this.body,
     this.day,
     this.month,
     this.year,
    required this.hour,
    required this.minute,
    this.repeats,
   required this.isActive,
    this.weekday,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        day,
        month,
        year,
        hour,
        minute,
        repeats,
        weekday,isActive,
      ];
  ReminderEntity copyWith({
    int? id,
    String? title,
    String? body,
    int? day,
    int? month,
    int? year,
    int? hour,
    int? minute,
    bool? repeats,
    bool? isActive,
    int? weekday,
  }) {
    return ReminderEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      day: day ?? this.day,
      month: month ?? this.month,
      year: year ?? this.year,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      repeats: repeats ?? this.repeats,
      isActive: isActive ?? this.isActive,
      weekday: weekday ?? this.weekday,
    );
  }
}
