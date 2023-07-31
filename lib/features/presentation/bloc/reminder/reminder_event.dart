part of 'reminder_bloc.dart';

abstract class ReminderEvent extends Equatable {
  const ReminderEvent();

  @override
  List<Object> get props => [];
}

class CreateReminder extends ReminderEvent {
  final ReminderEntity reminder;
  const CreateReminder({
    required this.reminder,
  });

  @override
  List<Object> get props => [reminder];
}

class UpdateReminder extends ReminderEvent {
  final ReminderEntity reminder;
  const UpdateReminder({
    required this.reminder,
  });

  @override
  List<Object> get props => [reminder];
}

class DeleteReminder extends ReminderEvent {
  final ReminderEntity reminder;
  const DeleteReminder({
    required this.reminder,
  });

  @override
  List<Object> get props => [reminder];
}

class GetReminders extends ReminderEvent {
  const GetReminders();

  @override
  List<Object> get props => [];
}
