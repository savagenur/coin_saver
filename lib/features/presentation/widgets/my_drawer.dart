import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/presentation/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            accountName: Text('John Doe'),
            accountEmail: Text('johndoe@example.com'),
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
              // Handle drawer item tap (navigate to home screen, etc.).
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
          ListTile(
            leading: const Icon(FontAwesomeIcons.rotate),
            title: const Text('Regular Payments'),
            onTap: () {
              // Handle drawer item tap (navigate to home screen, etc.).
            },
          ),
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
          ListTile(
            leading: const Icon(FontAwesomeIcons.dollarSign),
            title: const Text('Currency'),
            onTap: () {
              // Handle drawer item tap (navigate to settings screen, etc.).
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.gears),
            title: const Text('Settings'),
            onTap: () {
              // Handle drawer item tap (navigate to settings screen, etc.).
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.rectangleAd),
            title: const Text('Turn off ads'),
            onTap: () {
              // Handle drawer item tap (navigate to settings screen, etc.).
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.shareNodes),
            title: const Text('Share with friends'),
            onTap: () {
              // Handle drawer item tap (navigate to settings screen, etc.).
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
