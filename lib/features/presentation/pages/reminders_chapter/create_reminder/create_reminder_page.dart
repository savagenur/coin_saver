import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/presentation/bloc/reminder/reminder_bloc.dart';
import 'package:coin_saver/features/presentation/widgets/simple_calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:coin_saver/features/domain/entities/reminder/reminder_entity.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../widgets/my_button_widget.dart';

class CreateReminderPage extends StatefulWidget {
  final ReminderEntity? reminder;
  final bool isUpdate;
  const CreateReminderPage({
    Key? key,
    this.reminder,
    this.isUpdate = false,
  }) : super(key: key);

  @override
  State<CreateReminderPage> createState() => _CreateReminderPageState();
}

class _CreateReminderPageState extends State<CreateReminderPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _commentController;
  ReminderEntity? _reminder;
  late bool _isUpdate;
  late Frequency _frequency;
  TimeOfDay? _timeOfDay;
  late String _name;
  late DateTime _selectedDate;
  late bool _repeats;
  int? _weekday;

  @override
  void initState() {
    super.initState();
    _reminder = widget.reminder;
    _isUpdate = widget.isUpdate;
    _name = _reminder?.title ?? "";
    _repeats = _reminder?.repeats ?? false;
    _frequency = getFrequency();
    _weekday = _reminder?.weekday;
    _timeOfDay = _isUpdate
        ? TimeOfDay(hour: _reminder!.hour, minute: _reminder!.minute)
        : TimeOfDay.now();
    _selectedDate = _isUpdate
        ? DateTime(
            _reminder!.year,
            _reminder!.month,
            _reminder!.day,
          )
        : DateTime.now();
    _commentController = TextEditingController(text: _reminder?.body ?? "");
  }

  void setDate(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(FontAwesomeIcons.arrowLeft)),
          title: Text(_isUpdate ? "Update Reminder" : "Create Reminder"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Reminder name",
                style: TextStyle(color: secondaryColor),
              ),
              sizeVer(5),
              TextFormField(
                initialValue: _name,
                validator: (value) {
                  if ((value == null || value == "")) {
                    return "Please enter valid name";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _name = newValue!;
                },
                decoration: const InputDecoration(
                  hintText: "Name",
                ),
              ),
              sizeVer(30),
              const Text(
                "Reminder frequency",
                style: TextStyle(color: secondaryColor),
              ),
              sizeVer(5),
              PullDownButton(
                itemBuilder: (context) {
                  return frequencies
                      .map((frequency) => PullDownMenuItem(
                          onTap: () {
                            setState(() {
                              _frequency = frequency;
                            });
                          },
                          title: frequencyToString(frequency)))
                      .toList();
                },
                buttonBuilder: (context, showMenu) {
                  return GestureDetector(
                    onTap: showMenu,
                    child: Text(
                      frequencyToString(_frequency),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                  );
                },
              ),
              sizeVer(20),
              const Text(
                "Day",
                style: TextStyle(color: secondaryColor),
              ),
              sizeVer(5),
              GestureDetector(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: SimpleCalendarWidget(
                          selectedDate: _selectedDate,
                          firstDay: _isUpdate
                              ? DateTime(
                                  _reminder!.year,
                                  _reminder!.month,
                                  _reminder!.day,
                                )
                              : DateTime.now(),
                          setDate: setDate,
                          lastDay: DateTime(2010),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  DateFormat.yMMMMEEEEd().format(_selectedDate),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
              ),
              sizeVer(30),
              const Text(
                "Time",
                style: TextStyle(color: secondaryColor),
              ),
              sizeVer(5),
              GestureDetector(
                onTap: () async {
                  _timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: _timeOfDay!,
                  );
                  setState(() {
                    _timeOfDay == null ? _timeOfDay = TimeOfDay.now() : null;
                  });
                },
                child: Text(
                  "${_timeOfDay!.hour.toString().padLeft(2, "0")}:${_timeOfDay!.minute.toString().padLeft(2, "0")}",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
              ),
              sizeVer(30),
              const Text(
                "Comment",
                style: TextStyle(color: secondaryColor),
              ),
              sizeVer(5),
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: "Comment",
                ),
              ),
              sizeVer(20),
              _isUpdate
                  ? TextButton.icon(
                      onPressed: () {
                        _buildShowDialog(context);
                      },
                      icon: Icon(
                        FontAwesomeIcons.trashCan,
                        color: Colors.red.shade900,
                      ),
                      label: Text(
                        "Delete",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.red.shade900),
                      ))
                  : Container(),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: MediaQuery.of(context).viewInsets.bottom != 0
            ? null
            : MyButtonWidget(
                title: _isUpdate ? "Save" : "Create",
                width: MediaQuery.of(context).size.width * .9,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final id = _reminder?.id ?? generateIntUniqueId();
                    final ReminderEntity reminder = ReminderEntity(
                      id: id,
                      title: _name,
                      body: _commentController.text,
                      day: _selectedDate.day,
                      month: _selectedDate.month,
                      year: _selectedDate.year,
                      hour: _timeOfDay!.hour,
                      minute: _timeOfDay!.minute,
                      isActive: true,
                      repeats: _repeats,
                      weekday: _weekday,
                    );
                    if (_isUpdate) {
                      context
                          .read<ReminderBloc>()
                          .add(UpdateReminder(reminder: reminder));
                    } else {
                      context
                          .read<ReminderBloc>()
                          .add(CreateReminder(reminder: reminder));
                    }
                    Navigator.pop(context);
                  }
                },
              ),
      ),
    );
  }

  Future<void> _buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure you want to delete?"),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        context
                            .read<ReminderBloc>()
                            .add(DeleteReminder(reminder: _reminder!));
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Yes",
                      )),
                ),
                Expanded(
                  child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "No",
                      )),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  // Function to convert an enum value to the corresponding frequency string
  String frequencyToString(Frequency frequency) {
    switch (frequency) {
      case Frequency.once:
        _repeats = false;
        _weekday = null;
        return "Once";
      case Frequency.daily:
        _repeats = true;
        _weekday = null;
        return "Daily";
      case Frequency.onceAWeek:
        _repeats = true;
        _weekday = _selectedDate.weekday;
        return "Once a week";
      default:
        return '';
    }
  }

  Frequency getFrequency() {
    if (_reminder?.weekday != null) {
      return Frequency.onceAWeek;
    } else if (_repeats) {
      return Frequency.daily;
    } else {
      return Frequency.once;
    }
  }
}

enum Frequency {
  once,
  daily,
  onceAWeek,
}

List<Frequency> frequencies = [
  Frequency.once,
  Frequency.daily,
  Frequency.onceAWeek,
];
