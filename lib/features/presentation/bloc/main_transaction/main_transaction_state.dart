part of 'main_transaction_bloc.dart';

abstract class MainTransactionState extends Equatable {
  const MainTransactionState();
  
  @override
  List<Object> get props => [];
}

class MainTransactionInitial extends MainTransactionState {}
