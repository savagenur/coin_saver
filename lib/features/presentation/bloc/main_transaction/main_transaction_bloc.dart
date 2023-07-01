import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'main_transaction_event.dart';
part 'main_transaction_state.dart';

class MainTransactionBloc extends Bloc<MainTransactionEvent, MainTransactionState> {
  MainTransactionBloc() : super(MainTransactionInitial()) {
    on<MainTransactionEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
