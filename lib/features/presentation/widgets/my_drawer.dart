import 'package:coin_saver/features/presentation/bloc/cubit/rate_my_app/rate_my_app_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:coin_saver/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          //  UserAccountsDrawerHeader(

          //   accountName: Text(AppLocalizations.of(context)!.signUp),
          //   accountEmail: const Text(""),
          //   currentAccountPicture: const CircleAvatar(
          //     child: Icon(Icons.person),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Coin Saver",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(FontAwesomeIcons.house),
            title: Text(AppLocalizations.of(context)!.home),
            onTap: () {
              Navigator.pop(context);

              Navigator.popUntil(
                context,
                (route) {
                  return route.settings.name == PageConst.homePage;
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.wallet),
            title: Text(AppLocalizations.of(context)!.accounts),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                PageConst.accountsPage,
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.chartSimple),
            title: Text(AppLocalizations.of(context)!.charts),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                PageConst.chartsPage,
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.quoteRight),
            title: Text(AppLocalizations.of(context)!.categories),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                PageConst.categoriesPage,
              );
            },
          ),
          // ListTile(
          //   leading:  Icon(FontAwesomeIcons.rotate),
          //   title:  Text('Regular Payments'),
          //   onTap: () {
          //     // Handle drawer item tap (navigate to home screen, etc.).
          //   },
          // ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.solidBell),
            title: Text(AppLocalizations.of(context)!.reminders),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                PageConst.remindersPage,
              );
            },
          ),
          // ListTile(
          //   leading:  Icon(FontAwesomeIcons.dollarSign),
          //   title:  Text('Currency'),
          //   onTap: () {
          //     // Handle drawer item tap (navigate to settings screen, etc.).
          //   },
          // ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.gears),
            title: Text(AppLocalizations.of(context)!.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                PageConst.settingsPage,
              );
            },
          ),
          // ListTile(
          //   leading: const Icon(FontAwesomeIcons.rectangleAd),
          //   title: Text(AppLocalizations.of(context)!.turnOffAds),
          //   onTap: null,
          // ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.shareNodes),
            title: Text(AppLocalizations.of(context)!.shareWithFriends),
            onTap: () async {
              Share.share(
                AppLocalizations.of(context)!.shareLinkAnApp,
              );
            },
          ),
          BlocBuilder<RateMyAppCubit, RateMyApp?>(
            builder: (context, rateMyApp) {
              return ListTile(
                leading: const Icon(FontAwesomeIcons.star),
                title: Text(AppLocalizations.of(context)!.rateTheApp),
                onTap: () {
                  Navigator.pop(context);
                  rateMyApp!.showStarRateDialog(
                    context,
                    title: AppLocalizations.of(context)!.enjoyingCoinSaver,
                    message: AppLocalizations.of(context)!.tapAStarToRateIt,
                    starRatingOptions:
                        const StarRatingOptions(initialRating: 4),
                    actionsBuilder: (context, stars) {
                      return actionsBuilder(context, stars, rateMyApp);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> actionsBuilder(
      BuildContext context, double? stars, RateMyApp rateMyApp) {
    return stars == null
        ? [buildCancelBtn(rateMyApp, context)]
        : [buildOkBtn(rateMyApp, context), buildCancelBtn(rateMyApp, context)];
  }

  buildOkBtn(RateMyApp rateMyApp, BuildContext context) {
    return RateMyAppRateButton(rateMyApp,
        text: AppLocalizations.of(context)!.ok);
  }

  buildCancelBtn(RateMyApp rateMyApp, BuildContext context) {
    return RateMyAppNoButton(rateMyApp,
        text: AppLocalizations.of(context)!.cancel);
  }
}
