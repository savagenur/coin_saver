import 'package:coin_saver/features/domain/entities/reminder/reminder_entity.dart';
import 'package:hive/hive.dart';
part 'reminder_model.g.dart';

@HiveType(typeId: 4)
class ReminderModel extends ReminderEntity {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String body;
  @HiveField(3)
  final int day;
  @HiveField(4)
  final int month;
  @HiveField(5)
  final int year;
  @HiveField(6)
  final int hour;
  @HiveField(7)
  final int minute;
  @HiveField(8)
  final bool? repeats;
  @HiveField(9)
  final int? weekday;
  @HiveField(10)
  final bool isActive;
  const ReminderModel({
    required this.id,
    required this.title,
    required this.body,
    required this.day,
    required this.month,
    required this.year,
    required this.hour,
    required this.minute,
    required this.isActive,
    this.repeats,
    this.weekday,
  }) : super(
          id: id,
          title: title,
          body: body,
          day: day,
          month: month,
          year: year,
          hour: hour,
          minute: minute,
          repeats: repeats,
          isActive: isActive,
          weekday: weekday,
        );

  static ReminderModel fromEntity(ReminderEntity entity) {
    return ReminderModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      day: entity.day,
      month: entity.month,
      year: entity.year,
      hour: entity.hour,
      minute: entity.minute,
      repeats: entity.repeats,
      isActive: entity.isActive,
      weekday: entity.weekday,
    );
  }

  ReminderEntity toEntity() {
    return ReminderEntity(
      id: id,
      title: title,
      body: body,
      day: day,
      month: month,
      year: year,
      hour: hour,
      minute: minute,
      isActive:isActive,
      repeats: repeats,
      weekday: weekday,
    );
  }

  @override
  ReminderModel copyWith({
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
    return ReminderModel(
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
