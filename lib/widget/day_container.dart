import 'package:flutter/material.dart' hide DateUtils;
import 'package:persian_datetime_picker/utils/consts.dart';
import 'package:persian_datetime_picker/utils/date.dart';
import 'package:shamsi_date/shamsi_date.dart';

class DayContainer extends StatefulWidget {
  final dynamic date;
  final dynamic startDate;
  final dynamic endDate;
  final Function(Jalali)? onSelect;
  final dynamic width;
  final dynamic height;

  const DayContainer(
      {super.key,
      this.date,
      this.startDate,
      this.endDate,
      this.onSelect,
      this.height,
      this.width});

  @override
  _DayContainerState createState() => _DayContainerState();
}

class _DayContainerState extends State<DayContainer> {
  var date;
  bool isDisable = false;

  @override
  void initState() {
    date = widget.date;
    var dateUtiles = DateUtils();
    isDisable = date != '' ? dateUtiles.isDisable(outPutFormat(date)) : false;

    super.initState();
  }

  String outPutFormat(Date d) {
    final f = d.formatter;

    return '${f.yyyy}/${f.mm}/${f.dd}';
  }

  @override
  void didUpdateWidget(DayContainer oldWidget) {
    if (oldWidget != widget) {
      date = widget.date;
      var dateUtiles = DateUtils();
      isDisable = date != '' ? dateUtiles.isDisable(outPutFormat(date)) : false;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var decoration = BoxDecoration();

    bool isValid = date != '';
    bool isStart = isValid && date == widget.startDate;
    bool isBetween =
        isValid && date > widget.startDate && date < widget.endDate;
    bool isEnd = isValid && date == widget.endDate;

    if (isStart) {
      decoration = BoxDecoration(
          color: Global.color,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0.0, 2.0),
                spreadRadius: 1.0,
                blurRadius: 1.0)
          ],
          borderRadius:
              const BorderRadius.horizontal(right: Radius.circular(50.0)));
    }
    if (isEnd) {
      decoration = BoxDecoration(
          color: Global.color,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0.0, 4.0),
                spreadRadius: -2.0,
                blurRadius: 1.0)
          ],
          borderRadius:
              const BorderRadius.horizontal(left: Radius.circular(50.0)));
    }
    if (isEnd && isStart) {
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
    if (isBetween) {
      decoration = BoxDecoration(
        color: Global.color,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0.0, 4.0),
              spreadRadius: -2.0,
              blurRadius: 1.0)
        ],
      );
    }

    return InkWell(
      onTap: () {
        if (date != '' && !isDisable) {
          widget.onSelect?.call(date);
        }
      },
      child: date != ''
          ? Container(
              decoration: decoration,
              width: widget.width?.toDouble(),
              height: widget.height?.toDouble(),
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: isStart || isEnd ? Colors.white : Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(50))),
                child: Center(
                  child: Text(
                    date != '' ? date.formatter.d : '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color: isDisable ? Colors.grey : Colors.black,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            )
          : Container(
              width: widget.width?.toDouble(),
              height: widget.height?.toDouble(),
            ),
    );
  }
}
