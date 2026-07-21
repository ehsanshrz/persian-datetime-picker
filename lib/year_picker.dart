import 'package:flutter/material.dart' hide DateUtils;
import 'package:persian_datetime_picker/utils/consts.dart';
import 'package:persian_datetime_picker/utils/date.dart';
import 'package:persian_datetime_picker/widget/partition.dart';
import 'package:shamsi_date/shamsi_date.dart';

class PersianYearPicker extends StatefulWidget {
  final dynamic initDate;
  final Function(Jalali)? onSelectYear;
  final Function(String)? onChangePicker;

  const PersianYearPicker(
      {super.key, this.initDate, this.onSelectYear, this.onChangePicker});

  @override
  _PersianYearPickerState createState() => _PersianYearPickerState();
}

class _PersianYearPickerState extends State<PersianYearPicker>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  int selectedYear = 0;
  List years = [];
  late Jalali initDate;
  bool isSlideForward = true;

  String yearMonthNFormat(Date d) {
    final f = d.formatter;

    return '${f.mN} ${f.yy}';
  }

  _makeYearList() {
    setState(() {
      years = [];
      for (var i = this.selectedYear - 12; i < this.selectedYear + 13; i++) {
        years.add(i);
      }
    });
  }

  _changeYear(type) {
    setState(() {
      controller.forward(from: 0);
      int year = int.parse(initDate.formatter.y);
      var newDate = initDate;
      switch (type) {
        case 'prev':
          isSlideForward = true;
          newDate = initDate.copy(year: year - 15);
          break;
        case 'next':
          isSlideForward = false;

          newDate = initDate.copy(year: year + 15);
          break;
        case 'now':
          newDate = Jalali.now();
          break;
        default:
      }

      animation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          initDate = newDate;
          selectedYear = initDate.year;
          _makeYearList();
          isSlideForward = type == 'prev' ? false : true;
          controller.reverse();
        }
      });
    });
  }

  @override
  void initState() {
    years = [];
    super.initState();
    if (widget.initDate != null) {
      var splitInitDate = widget.initDate.split('#');
      var splitStartDate = splitInitDate[0].split('/');
      initDate = Jalali(int.parse(splitStartDate[0]),
          int.parse(splitStartDate[1]), int.parse(splitStartDate[2]));

      selectedYear = initDate.year;
    } else {
      initDate = Jalali.now();
      selectedYear = initDate.year;
    }

    _makeYearList();
    controller =
        AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> yearList = years.map<Widget>((year) {
      var dateUtiles = DateUtils();
      bool isDisable = dateUtiles.isDisable('$year');
      BoxDecoration decoration = BoxDecoration();
      if (initDate.year == year) {
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
      return GestureDetector(
        onTap: () {
          setState(() {
            if (!isDisable) initDate = initDate.copy(year: year);
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
                    initDate.year == year ? Colors.white : Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(50))),
            child: Center(
              child: Text(
                '$year',
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

    List chunks = partition(yearList, 5).toList();

    List rows = chunks.map((row) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
                    '${initDate.year}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ],
              )),
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    _changeYear('prev');
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
                            widget.onChangePicker?.call('month');
                          },
                          child: Text(yearMonthNFormat(initDate)),
                        ),
                      )),
                ),
                IconButton(
                  onPressed: () {
                    _changeYear('next');
                  },
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          Transform(
              transform: Matrix4.translationValues(
                  animation.value * (isSlideForward ? 300 : -300), 0, 0),
              child: Opacity(
                  opacity: 1 - animation.value,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: rows as List<Widget>,
                    ),
                  ))),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    widget.onSelectYear?.call(initDate);
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
                      selectedYear = initDate.year;
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
