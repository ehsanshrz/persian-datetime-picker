import 'package:flutter/material.dart' hide DateUtils;
import 'package:persian_datetime_picker/utils/consts.dart';
import 'package:persian_datetime_picker/utils/date.dart';
import 'package:persian_datetime_picker/widget/partition.dart';
import 'package:shamsi_date/shamsi_date.dart';

class PersianMonthPicker extends StatefulWidget {
  final dynamic initDate;
  final Function(Jalali)? onSelectMonth;

  const PersianMonthPicker({super.key, this.initDate, this.onSelectMonth});

  @override
  _PersianMonthPickerState createState() => _PersianMonthPickerState();
}

class _PersianMonthPickerState extends State<PersianMonthPicker>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  int selectedMonth = 1;
  List months = [];
  late Jalali initDate;

  String monthNFormat(Date d) {
    final f = d.formatter;

    return '${f.mN}';
  }

  _makeMonthList() {
    setState(() {
      months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    });
  }

  String outPutFormat(Date d) {
    final f = d.formatter;

    return '${f.yyyy}/${f.mm}/${f.dd}';
  }

  @override
  void initState() {
    months = [];
    super.initState();
    if (widget.initDate != null) {
      var splitInitDate = widget.initDate.split('#');
      var splitStartDate = splitInitDate[0].split('/');
      initDate = Jalali(int.parse(splitStartDate[0]),
          int.parse(splitStartDate[1]), int.parse(splitStartDate[2]));

      selectedMonth = initDate.month;
    } else {
      initDate = Jalali.now();
      selectedMonth = initDate.month;
    }

    _makeMonthList();
    controller =
        AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> monthList = months.map<Widget>((month) {
      BoxDecoration decoration = BoxDecoration();
      if (initDate.month == month) {
        decoration = BoxDecoration(
            color: Global.color,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0.0, 4.0),
                  spreadRadius: -2.0,
                  blurRadius: 1.0)
            ],
            borderRadius: const BorderRadius.all(Radius.circular(50.0)));
      }
      var dateUtiles = DateUtils();
      bool isDisable = dateUtiles.isDisable('$month');
      return GestureDetector(
        onTap: () {
          setState(() {
            if (!isDisable) initDate = initDate.copy(month: month);
          });
        },
        child: Container(
          decoration: decoration,
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(3),
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                color:
                    initDate.month == month ? Colors.white : Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(50))),
            child: Center(
              child: Text(
                '${monthNFormat(initDate.copy(month: month))}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: isDisable ? Colors.grey : Colors.black,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
        ),
      );
    }).toList();

    List chunks = partition(monthList, 3).toList();

    List rows = chunks.map((row) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: row as List<Widget>,
        ),
      );
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Global.color,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${monthNFormat(initDate)}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ],
              )),
          Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: rows as List<Widget>,
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    widget.onSelectMonth?.call(initDate);
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
                    setState(() {
                      initDate = Jalali.now();
                      selectedMonth = initDate.month;
                    });
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
      ),
    );
  }
}
