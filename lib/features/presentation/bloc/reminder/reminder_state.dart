part of 'reminder_bloc.dart';

abstract class ReminderState extends Equatable {
  const ReminderState();

  @override
  List<Object> get props => [];
}

class ReminderLoading extends ReminderState {
  @override
  List<Object> get props => [];
}

class ReminderLoaded extends ReminderState {
  final List<ReminderEntity> reminders;
  const ReminderLoaded({
    required this.reminders,
  });
  @override
  List<Object> get props => [
        reminders,
      ];
}

class ReminderFailure extends ReminderState {
  @override
  List<Object> get props => [];
}
