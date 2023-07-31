import 'package:coin_saver/features/domain/entities/reminder/reminder_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class GetRemindersUsecase {
  final BaseHiveRepository repository;
  GetRemindersUsecase({
    required this.repository,
  });

  List<ReminderEntity> call()  {
    return repository.getReminders();
  }
}
