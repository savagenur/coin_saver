import 'package:coin_saver/features/domain/entities/reminder/reminder_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class UpdateReminderUsecase {
  final BaseHiveRepository repository;
  UpdateReminderUsecase({
    required this.repository,
  });

  Future<void> call(ReminderEntity reminderEntity) async {
    return repository.updateReminder(reminderEntity: reminderEntity);
  }
}
