import 'package:coin_saver/constants/period_enum.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/period/period_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../bloc/cubit/selected_date/selected_date_cubit.dart';
import '../bloc/home_time_period/home_time_period_bloc.dart';
import 'calendar_widget.dart';

class DayNavigationWidget extends StatefulWidget {
  final AccountEntity account;
  final DateTime dateTime;
  final bool isIncome;
  final Period selectedPeriod;
  const DayNavigationWidget({
    super.key,
    required this.account,
    required this.dateTime,
    required this.isIncome,
    this.selectedPeriod = Period.day,
  });

  @override
  State<DayNavigationWidget> createState() => _DayNavigationWidgetState();
}

class _DayNavigationWidgetState extends State<DayNavigationWidget> {
  String formatDateyMMMMd(DateTime dateTime) {
    String formattedDate = DateFormat.yMMMd().format(dateTime);

    return formattedDate;
  }

  String formatDateM(DateTime dateTime) {
    String formattedDate = DateFormat.MMMd().format(dateTime);

    return formattedDate;
  }

  String updateSelectedPeriodText(
    Period selectedPeriod,
    DateTime selectedDate,
    DateTime endDate,
  ) {
    switch (selectedPeriod) {
      case Period.day:
        context
            .read<HomeTimePeriodBloc>()
            .add(SetDayPeriod(selectedDate: selectedDate));
        return formatDateyMMMMd(selectedDate) ==
                formatDateyMMMMd(DateTime.now())
            ? "${AppLocalizations.of(context)!.today}, ${formatDateM(DateTime.now())}"
            : formatDateyMMMMd(selectedDate) ==
                    formatDateyMMMMd(
                        DateTime.now().subtract(const Duration(days: 1)))
                ? "${AppLocalizations.of(context)!.yesterday}, ${formatDateM(DateTime.now().subtract(const Duration(days: 1)))}"
                : formatDateyMMMMd(selectedDate);
      case Period.week:
        context
            .read<HomeTimePeriodBloc>()
            .add(SetWeekPeriod(selectedDate: selectedDate));
        return "${formatDateM(selectedDate.subtract(Duration(days: selectedDate.weekday - 1)))} - ${formatDateyMMMMd(selectedDate.subtract(Duration(days: selectedDate.weekday - 7)))}";

      case Period.month:
        context
            .read<HomeTimePeriodBloc>()
            .add(SetMonthPeriod(selectedDate: selectedDate));
        final startOfMonth = DateTime(selectedDate.year, selectedDate.month);
        final endOfMonth = DateTime(selectedDate.year, selectedDate.month + 1)
            .subtract(const Duration(days: 1));
        return "${formatDateM(startOfMonth)} - ${formatDateM(endOfMonth)}";
      case Period.year:
        context
            .read<HomeTimePeriodBloc>()
            .add(SetYearPeriod(selectedDate: selectedDate));
        return DateFormat("yyyy").format(selectedDate);
      case Period.period:
        context
            .read<HomeTimePeriodBloc>()
            .add(SetPeriod(selectedStart: selectedDate, selectedEnd: endDate));

        return "${formatDateM(selectedDate)} - ${formatDateM(endDate)}";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PeriodCubit, Period>(
      builder: (context, selectedPeriod) {
        return BlocBuilder<SelectedDateCubit, DateRange>(
          builder: (context, dateRange) {
            var selectedDate = dateRange.startDate;
            var endDate = dateRange.endDate;
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: selectedPeriod == Period.period
                              ? null
                              : () {
                                  // SelectedDate
                                  context
                                      .read<SelectedDateCubit>()
                                      .moveBackward(selectedPeriod);

                                  // MainTransactions Sort
                                  context
                                      .read<HomeTimePeriodBloc>()
                                      .add(SetDayPeriod(
                                        selectedDate: selectedDate,
                                      ));
                                  updateSelectedPeriodText(
                                      selectedPeriod, selectedDate, endDate);
                                },
                          icon: const Icon(
                                FontAwesomeIcons.chevronLeft
,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: selectedPeriod == Period.year ||
                                selectedPeriod == Period.period
                            ? null
                            : () {
                                _buildShowDialog(
                                  context,
                                  selectedDate,
                                );
                              },
                        child: Text(
                          updateSelectedPeriodText(
                              selectedPeriod, selectedDate, endDate),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          selectedPeriod == Period.period ||
                                  DateFormat.yMd().format(selectedDate) ==
                                      DateFormat.yMd().format(DateTime.now())
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    context
                                        .read<SelectedDateCubit>()
                                        .changeStartDate(DateTime.now());
                                  },
                                  child: const Icon(
                                    FontAwesomeIcons.calendarCheck,
                                  ),
                                ),
                          IconButton(
                            onPressed: selectedDate.isBefore(DateTime.now()
                                        .subtract(const Duration(days: 1))) &&
                                    selectedPeriod != Period.period
                                ? () {
                                    // SelectedDate
                                    context
                                        .read<SelectedDateCubit>()
                                        .moveForward(
                                          selectedPeriod,
                                        );
                                    updateSelectedPeriodText(
                                        selectedPeriod, selectedDate, endDate);
                                  }
                                : null,
                            icon: const Icon(
                                  FontAwesomeIcons.chevronRight
,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _buildShowDialog(
    BuildContext context,
    DateTime selectedDate,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return CalendarWidget(
          selectedDate: selectedDate,
        );
      },
    );
  }
}
