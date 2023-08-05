import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/rate_my_app/rate_my_app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RateAppInitWidget extends StatefulWidget {
  final Widget Function(RateMyApp) builder;
  const RateAppInitWidget({super.key, required this.builder});

  @override
  State<RateAppInitWidget> createState() => RateAppInitWidgetState();
}

class RateAppInitWidgetState extends State<RateAppInitWidget> {
  RateMyApp? rateMyApp;
  
 

 

  static const String playStoreId = "com.savagenur.coin_saver";
  static const String appStoreId = "com.savagenur.coinSaver";
  @override
  Widget build(BuildContext context) {
    return RateMyAppBuilder(
      rateMyApp: RateMyApp(
          preferencesPrefix: "rateMyApp_",
          minDays: 3,
          minLaunches: 7,
          remindDays: 5,
          remindLaunches: 7,
          googlePlayIdentifier: playStoreId,
          appStoreIdentifier: appStoreId),
      onInitialized: (context, rateMyApp) {
        setState(() => this.rateMyApp = rateMyApp);
        context.read<RateMyAppCubit>().setRateMyApp(rateMyApp);
        if (rateMyApp.shouldOpenDialog) {
          rateMyApp.showStarRateDialog(
            context,
            title: AppLocalizations.of(context)!.enjoyingCoinSaver,
            message: AppLocalizations.of(context)!.tapAStarToRateIt,
            starRatingOptions: const StarRatingOptions(initialRating: 4),
            actionsBuilder: actionsBuilder,
          );
        }
      },
      builder: (context) {
        return rateMyApp == null
            ? Container(
                color: const Color(0xff095d9e),
                height: double.infinity,
                width: double.infinity,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : widget.builder(rateMyApp!);
      },
    );
  }

  List<Widget> actionsBuilder(BuildContext context, double? stars) {
    return stars == null
        ? [buildCancelBtn()]
        : [buildOkBtn(), buildCancelBtn()];
  }

  buildOkBtn() {
    return RateMyAppRateButton(rateMyApp!,
        text: AppLocalizations.of(context)!.ok);
  }

  buildCancelBtn() {
    return RateMyAppNoButton(rateMyApp!,
        text: AppLocalizations.of(context)!.cancel);
  }
}
