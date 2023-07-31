import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/domain/entities/reminder/reminder_entity.dart';
import 'package:coin_saver/features/presentation/pages/reminders_chapter/create_reminder/create_reminder_page.dart';
import 'package:coin_saver/features/presentation/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../injection_container.dart';
import '../../../bloc/reminder/reminder_bloc.dart';
import '../../../widgets/my_button_widget.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => RemindersPageState();
}

class RemindersPageState extends State<RemindersPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ReminderEntity> _reminders = [];
  @override
  void initState() {
    super.initState();
    sl<AwesomeNotifications>().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        sl<AwesomeNotifications>().requestPermissionToSendNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, (route) => route.isFirst);
        return true;
      },
      child: BlocBuilder<ReminderBloc, ReminderState>(
        builder: (context, reminderState) {
          if (reminderState is ReminderLoaded) {
            _reminders = reminderState.reminders;
            return Scaffold(
              key: _scaffoldKey,
              drawer: const MyDrawer(),
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    icon: const Icon(FontAwesomeIcons.bars)),
                centerTitle: true,
                title: const Text("Reminders"),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ...List.generate(_reminders.length, (index) {
                      final reminder = _reminders[index];
                      return ListTile(
                        onTap: () {
                          Navigator.pushNamed(
                              context, PageConst.createReminderPage,
                              arguments: CreateReminderPage(
                                reminder: reminder,
                                isUpdate:true,
                              ));
                        },
                        title: Text(reminder.title),
                        trailing: Switch(
                          value: reminder.isActive,
                          onChanged: (value) {
                            context.read<ReminderBloc>().add(UpdateReminder(
                                reminder: reminder.copyWith(isActive: value)));
                          },
                        ),
                      );
                    }),
                    sizeVer(80),
                  ],
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: MyButtonWidget(
                title: "+ Create",
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    PageConst.createReminderPage,
                    arguments: const CreateReminderPage(),
                  );
                },
              ),
            );
          }
          return const Scaffold();
        },
      ),
    );
  }
}
