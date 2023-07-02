part of 'main_transaction_bloc.dart';

abstract class MainTransactionEvent extends Equatable {
  const MainTransactionEvent();

  @override
  List<Object> get props => [];
}

class CreateMainTransaction extends MainTransactionEvent {
  final MainTransactionEntity mainTransaction;
  const CreateMainTransaction({
    required this.mainTransaction,
  });

  @override
  List<Object> get props => [mainTransaction];
}

class UpdateMainTransaction extends MainTransactionEvent {
  final MainTransactionEntity mainTransaction;
  final String oldKey;
  const UpdateMainTransaction({
    required this.mainTransaction,
    required this.oldKey,
  });

  @override
  List<Object> get props => [
        mainTransaction,
        oldKey,
      ];
}

class GetMainTransactions extends MainTransactionEvent {
  @override
  List<Object> get props => [];
}

class DeleteMainTransaction extends MainTransactionEvent {
  final String id;
  const DeleteMainTransaction({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
