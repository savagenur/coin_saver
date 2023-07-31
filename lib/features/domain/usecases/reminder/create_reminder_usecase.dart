import 'package:coin_saver/features/domain/entities/reminder/reminder_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class CreateReminderUsecase {
  final BaseHiveRepository repository;
  CreateReminderUsecase({
    required this.repository,
  });

  Future<void> call(ReminderEntity reminderEntity) async {
    return repository.createReminder(reminderEntity: reminderEntity);
  }
}
