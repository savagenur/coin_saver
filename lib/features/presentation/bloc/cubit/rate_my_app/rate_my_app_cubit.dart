import 'package:bloc/bloc.dart';
import 'package:rate_my_app/rate_my_app.dart';


class RateMyAppCubit extends Cubit<RateMyApp?> {
  RateMyAppCubit() : super(null);

  void setRateMyApp(RateMyApp? rateMyApp) {
    emit(rateMyApp);
  }

  void getRateMyApp() {
    emit(state);
  }
}
