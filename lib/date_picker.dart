import 'package:persian_datetime_picker/utils/consts.dart';
import 'package:persian_datetime_picker/widget/render_table.dart';
import 'package:flutter/material.dart' hide DateUtils;
import 'package:shamsi_date/shamsi_date.dart';

class DatePicker extends StatefulWidget {
  final bool? isRangeDate;
  final bool isSecondDate;
  final dynamic startSelectedDate;
  final dynamic endSelectedDate;
  final Function(dynamic)? onSelectDate;
  final Function(String)? onConfirmedDate;
  final Function(String)? onChangePicker;

  const DatePicker(
      {super.key,
      this.isRangeDate,
      this.startSelectedDate = false,
      this.isSecondDate = false,
      this.endSelectedDate,
      this.onChangePicker,
      this.onSelectDate,
      this.onConfirmedDate});

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  late Jalali initDate;
  Jalali? startSelectedDate;
  Jalali? endSelectedDate;
  bool isRangeDate = false;

  bool isSlideForward = true;

  final weekDaysName = [
    'ش',
    'ی',
    'د',
    'س ',
    'چ',
    'پ',
    'ج',
  ];

  @override
  void didUpdateWidget(DatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      setState(() {
        isRangeDate = widget.isRangeDate ?? false;
        if (widget.endSelectedDate != null) {
          var splitStartDate = widget.startSelectedDate.split('/');
          var splitEndDate = widget.endSelectedDate.split('/');
          startSelectedDate = Jalali(int.parse(splitStartDate[0]),
              int.parse(splitStartDate[1]), int.parse(splitStartDate[2]));
          endSelectedDate = Jalali(int.parse(splitEndDate[0]),
              int.parse(splitEndDate[1]), int.parse(splitEndDate[2]));

          initDate = startSelectedDate = Jalali(int.parse(splitStartDate[0]),
              int.parse(splitStartDate[1]), int.parse(splitStartDate[2]));
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    isRangeDate = widget.isRangeDate ?? false;
    if (widget.endSelectedDate != null) {
      var splitStartDate = widget.startSelectedDate.split('/');
      var splitEndDate = widget.endSelectedDate.split('/');
      startSelectedDate = Jalali(int.parse(splitStartDate[0]),
          int.parse(splitStartDate[1]), int.parse(splitStartDate[2]));
      endSelectedDate = Jalali(int.parse(splitEndDate[0]),
          int.parse(splitEndDate[1]), int.parse(splitEndDate[2]));

      initDate = startSelectedDate = Jalali(int.parse(splitStartDate[0]),
          int.parse(splitStartDate[1]), int.parse(splitStartDate[2]));
    } else {
      initDate = Jalali.now();
      startSelectedDate = Jalali.now();
      endSelectedDate = Jalali.now();
    }

    controller =
        AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut)
      ..addListener(() {
        setState(() {});
      });
  }

  _changeMonth(type) {
    setState(() {
      controller.forward(from: 0);
      int year = int.parse(initDate.formatter.y);
      int month = int.parse(initDate.formatter.m);
      var newDate = initDate;
      switch (type) {
        case 'prev':
          isSlideForward = true;

          newDate = initDate.copy(
              month: month > 1 ? month - 1 : 12,
              year: month == 1 ? year - 1 : year);
          break;
        case 'next':
          isSlideForward = false;

          newDate = initDate.copy(
              month: month < 12 ? month + 1 : 1,
              year: month == 12 ? year + 1 : year);
          break;
        case 'now':
          newDate = Jalali.now();
          break;
        default:
      }

      animation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          initDate = newDate;

          isSlideForward = type == 'prev' ? false : true;
          controller.reverse();
        }
      });
    });
  }

  String outPutFormat(Date d) {
    final f = d.formatter;

    return '${f.yyyy}/${f.mm}/${f.dd}';
  }

  String fullFormat(Date d) {
    final f = d.formatter;

    return '${f.wN} ${f.d} ${f.mN} ${f.yy}';
  }

  String yearMonthNFormat(Date d) {
    final f = d.formatter;

    return '${f.mN} ${f.yy}';
  }

  String monthDayFormat(Date d) {
    final f = d.formatter;

    return '${f.wN} ${f.dd} ${f.mN}';
  }

  @override
  Widget build(BuildContext context) {
    const cellWidth = 42.0;
    const cellHeight = 35.0;
    List weekDaysWidget = weekDaysName.map((day) {
      return Container(
        width: cellWidth,
        height: cellHeight,
        child: Text(
          day,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      );
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
          child: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Global.color,
              ),
              child: isRangeDate
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'از ${fullFormat(startSelectedDate!)}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          'تا ${fullFormat(endSelectedDate!)}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${startSelectedDate!.formatter.yyyy}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          '${monthDayFormat(startSelectedDate!)}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
          Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          _changeMonth('prev');
                        },
                        icon: const Icon(Icons.chevron_left),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Transform(
                            transform: Matrix4.translationValues(
                                animation.value * (isSlideForward ? 100 : -100),
                                0,
                                0),
                            child: Opacity(
                              opacity: 1 - animation.value,
                              child: TextButton(
                                onPressed: () {
                                  widget.onChangePicker?.call('year');
                                },
                                child: Text(yearMonthNFormat(initDate)),
                              ),
                            )),
                      ),
                      IconButton(
                        onPressed: () {
                          _changeMonth('next');
                        },
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: weekDaysWidget as List<Widget>,
                  ),
                ),
                Transform(
                  transform: Matrix4.translationValues(
                      animation.value * (isSlideForward ? 300 : -300), 0, 0),
                  child: Opacity(
                    opacity: 1 - animation.value,
                    child: RenderTable(
                      initDate: initDate,
                      startSelectedDate: startSelectedDate,
                      endSelectedDate: endSelectedDate,
                      onSelect: (date) {
                        widget.onSelectDate?.call(date);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    if (isRangeDate) {
                      widget.onConfirmedDate?.call(
                          '${outPutFormat(startSelectedDate!)} # ${outPutFormat(endSelectedDate!)}');
                    } else {
                      widget.onConfirmedDate?.call(
                          '${outPutFormat(startSelectedDate!)}');
                    }
                  },
                  child: Text(
                    'تایید',
                    style: TextStyle(fontSize: 16, color: Global.color),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'انصراف',
                    style: TextStyle(fontSize: 16, color: Global.color),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    startSelectedDate = Jalali.now();
                    endSelectedDate = Jalali.now();
                    _changeMonth('now');
                  },
                  child: Text(
                    'اکنون',
                    style: TextStyle(fontSize: 16, color: Global.color),
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
