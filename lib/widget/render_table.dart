import 'package:persian_datetime_picker/widget/day_container.dart';
import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/widget/partition.dart';
import 'package:shamsi_date/shamsi_date.dart';

class RenderTable extends StatefulWidget {
  final dynamic initDate;
  final dynamic startSelectedDate;
  final dynamic endSelectedDate;
  final Function(Jalali)? onSelect;

  const RenderTable({
    super.key,
    this.initDate,
    this.startSelectedDate,
    this.endSelectedDate,
    this.onSelect,
  });

  @override
  _RenderTableState createState() => _RenderTableState();
}

class _RenderTableState extends State<RenderTable> {
  var initDate;
  late int monthLength;
  late int currentDayOfMonth;
  late int numberOfFirstDayOfMonthInWeek;
  List allDaysOfTable = [];

  @override
  void didUpdateWidget(RenderTable oldWidget) {
    if (oldWidget.initDate != widget.initDate) {
      setState(() {
        allDaysOfTable = [];
        initDate = widget.initDate;
        monthLength = initDate.monthLength;
        currentDayOfMonth = int.parse(initDate.formatter.d);
        numberOfFirstDayOfMonthInWeek = initDate.copy(day: 1).weekDay;

        for (int i = 1; i <= 42; i++) {
          if (i < numberOfFirstDayOfMonthInWeek) {
            allDaysOfTable.add('');
          } else if (i < monthLength + numberOfFirstDayOfMonthInWeek) {
            allDaysOfTable.add(i - (numberOfFirstDayOfMonthInWeek - 1));
          } else {
            allDaysOfTable.add('');
          }
        }
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    allDaysOfTable = [];
    initDate = widget.initDate;
    monthLength = initDate.monthLength;
    currentDayOfMonth = int.parse(initDate.formatter.d);
    numberOfFirstDayOfMonthInWeek = initDate.copy(day: 1).weekDay;

    for (int i = 1; i <= 42; i++) {
      if (i < numberOfFirstDayOfMonthInWeek) {
        allDaysOfTable.add('');
      } else if (i < monthLength + numberOfFirstDayOfMonthInWeek) {
        allDaysOfTable.add(i - (numberOfFirstDayOfMonthInWeek - 1));
      } else {
        allDaysOfTable.add('');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const cellWidth = 42.0;
    const cellHeight = 35.0;

    List<Widget> allDaysWidget = allDaysOfTable.map<Widget>((dayNumber) {
      var date = dayNumber != '' ? initDate.copy(day: dayNumber) : '';
      return DayContainer(
        date: date,
        startDate: widget.startSelectedDate,
        endDate: widget.endSelectedDate,
        width: cellWidth,
        height: cellHeight,
        onSelect: (date) {
          widget.onSelect?.call(date);
        },
      );
    }).toList();

    List chunkAllDays = partition(allDaysWidget, 7).toList();

    List chunkWeeksWidget = chunkAllDays.map((week) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: week as List<Widget>,
        ),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: chunkWeeksWidget as List<Widget>,
        )
      ],
    );
  }
}
