import 'package:coin_saver/features/domain/entities/reminder/reminder_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class DeleteReminderUsecase {
  final BaseHiveRepository repository;
  DeleteReminderUsecase({
    required this.repository,
  });

  Future<void> call(ReminderEntity reminderEntity) async {
    return repository.deleteReminder(reminderEntity: reminderEntity);
  }
}
