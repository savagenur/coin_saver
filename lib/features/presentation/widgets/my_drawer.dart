import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/presentation/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../injection_container.dart';
import '../bloc/reminder/reminder_bloc.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(

            accountName: Text("Sign up"),
            accountEmail: Text(""),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
          
          ListTile(
            leading: const Icon(FontAwesomeIcons.house),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.wallet),
            title: const Text('Accounts'),
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
            title: const Text('Charts'),
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
            title: const Text('Categories'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                PageConst.categoriesPage,
              );
            },
          ),
          // ListTile(
          //   leading: const Icon(FontAwesomeIcons.rotate),
          //   title: const Text('Regular Payments'),
          //   onTap: () {
          //     // Handle drawer item tap (navigate to home screen, etc.).
          //   },
          // ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.solidBell),
            title: const Text('Reminders'),
            onTap: () {
              // sl<ReminderBloc>().add(const GetReminders());
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                PageConst.remindersPage,
              );
            },
          ),
          // ListTile(
          //   leading: const Icon(FontAwesomeIcons.dollarSign),
          //   title: const Text('Currency'),
          //   onTap: () {
          //     // Handle drawer item tap (navigate to settings screen, etc.).
          //   },
          // ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.gears),
            title: const Text('Settings'),
            onTap: () {
              // Handle drawer item tap (navigate to settings screen, etc.).
            },
          ),
          const ListTile(
            leading: Icon(FontAwesomeIcons.rectangleAd),
            title: Text('Turn off ads'),
            onTap: null,
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.shareNodes),
            title: const Text('Share with friends'),
            onTap: () async {
              Share.share(
                """
I'm been using Coin Saver app and I really like it. You should try it, too!
Google Play https://play.google.com/store/apps/details?id=com.savagenur.coin_saver
""",
              );
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.star),
            title: const Text('Rate the app'),
            onTap: () {
              // Handle drawer item tap (navigate to settings screen, etc.).
            },
          ),
        ],
      ),
    );
  }
}
