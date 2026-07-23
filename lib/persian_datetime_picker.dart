<<<<<<< HEAD
library persian_datetime_picker;

import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/utils/consts.dart';
import 'package:persian_datetime_picker/widget/dialog.dart';

import 'handle_picker.dart';

class PersianDateTimePicker extends StatefulWidget {
  final dynamic initial;
  final dynamic type;
  final dynamic disable;
  final Color color;
  final Function(String)? onSelect;

  const PersianDateTimePicker(
      {super.key,
      this.type = 'date',
      this.initial,
      this.disable,
      this.color = Colors.blueAccent,
      this.onSelect});

  @override
  _PersianDateTimePickerState createState() => _PersianDateTimePickerState();
}

class _PersianDateTimePickerState extends State<PersianDateTimePicker> {
  @override
  void initState() {
    super.initState();
    Global.color = widget.color;
    Global.pickerType = widget.type;
    Global.disable = widget.disable;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CDialog(
        insetAnimationCurve: Curves.bounceInOut,
        insetAnimationDuration: const Duration(seconds: 2),
        child: HandlePicker(
          type: widget.type,
          initDateTime: widget.initial,
          onSelect: widget.onSelect,
        ),
      ),
    );
  }
}
=======
library;

export 'package:shamsi_date/shamsi_date.dart';

//export material pickers
export 'src/material/calendar_date_picker.dart';
export 'src/material/date.dart';
export 'src/material/date_picker.dart';
export 'src/material/date_picker_theme.dart';
export 'src/material/input_date_picker_form_field.dart';
export 'src/material/restoration_properties.dart';

//export cupertino pickers
export 'src/cupertino/date_picker.dart';

//export localizations
export 'src/localizations/default.dart';
export 'src/localizations/persian.dart';
export 'src/localizations/dari.dart';
export 'src/localizations/pashto.dart';
export 'src/localizations/sorani.dart';
>>>>>>> upstream/master
