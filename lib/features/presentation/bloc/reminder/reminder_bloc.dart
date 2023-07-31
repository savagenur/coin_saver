import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:coin_saver/features/domain/entities/reminder/reminder_entity.dart';
import 'package:coin_saver/features/domain/usecases/reminder/create_reminder_usecase.dart';
import 'package:coin_saver/features/domain/usecases/reminder/delete_reminder_usecase.dart';
import 'package:coin_saver/features/domain/usecases/reminder/get_reminders_usecase.dart';
import 'package:coin_saver/features/domain/usecases/reminder/update_reminder_usecase.dart';

part 'reminder_event.dart';
part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final CreateReminderUsecase createReminderUsecase;
  final DeleteReminderUsecase deleteReminderUsecase;
  final UpdateReminderUsecase updateReminderUsecase;
  final GetRemindersUsecase getRemindersUsecase;
  ReminderBloc({
    required this.createReminderUsecase,
    required this.deleteReminderUsecase,
    required this.updateReminderUsecase,
    required this.getRemindersUsecase,
  }) : super(ReminderLoading()) {
    on<CreateReminder>(_onCreateReminder);
    on<DeleteReminder>(_onDeleteReminder);
    on<UpdateReminder>(_onUpdateReminder);
    on<GetReminders>(_onGetReminders);
  }

  FutureOr<void> _onCreateReminder(
      CreateReminder event, Emitter<ReminderState> emit) async {
    await createReminderUsecase.call(event.reminder);
    final reminders = getRemindersUsecase.call();
    emit(ReminderLoaded(reminders: reminders));
  }

  FutureOr<void> _onDeleteReminder(
      DeleteReminder event, Emitter<ReminderState> emit) async {
    await deleteReminderUsecase.call(event.reminder);
    final reminders = getRemindersUsecase.call();
    emit(ReminderLoaded(reminders: reminders));
  }

  FutureOr<void> _onUpdateReminder(
      UpdateReminder event, Emitter<ReminderState> emit) async {
    await updateReminderUsecase.call(event.reminder);
    final reminders = getRemindersUsecase.call();
    emit(ReminderLoaded(reminders: reminders));
  }

  FutureOr<void> _onGetReminders(
      GetReminders event, Emitter<ReminderState> emit) {
    final reminders = getRemindersUsecase.call();
    emit(ReminderLoaded(reminders: reminders));
  }
}
