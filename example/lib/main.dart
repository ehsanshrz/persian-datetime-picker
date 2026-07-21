import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'IS',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF43cea2)),
        primaryColor: Colors.white,
      ),
      home: const MyHomePage(title: 'دیت تایم پیکر فارسی'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String label = 'انتخاب تاریخ زمان';

  void _showDateTimePicker() {
    showDialog(
      context: context,
      builder: (BuildContext _) {
        return PersianDateTimePicker(
          initial: '1398/03/20 19:50',
          type: 'datetime',
          color: Colors.redAccent,
          onSelect: (date) {
            setState(() {
              label = date;
            });
          },
        );
      },
    );
  }

  void _showDatePicker() {
    showDialog(
      context: context,
      builder: (BuildContext _) {
        return PersianDateTimePicker(
          initial: '1398/3/20',
          disable: ['friday', '1398/3/21', '13985/3/21'],
          type: 'date',
          onSelect: (date) {
            setState(() {
              label = date;
            });
          },
        );
      },
    );
  }

  void _showYearPicker() {
    showDialog(
      context: context,
      builder: (BuildContext _) {
        return PersianDateTimePicker(
          initial: '1397',
          type: 'year',
          disable: ['1400', '1395'],
          onSelect: (date) {
            setState(() {
              label = date;
            });
          },
        );
      },
    );
  }

  void _showMonthPicker() {
    showDialog(
      context: context,
      builder: (BuildContext _) {
        return PersianDateTimePicker(
          initial: '03',
          disable: ['2', '03'],
          type: 'month',
          onSelect: (date) {
            setState(() {
              label = date;
            });
          },
        );
      },
    );
  }

  void _showTimePicker() {
    showDialog(
      context: context,
      builder: (BuildContext _) {
        return PersianDateTimePicker(
          initial: '19:50',
          disable: ['20:50', '20:51', '20:55'],
          type: 'time',
          onSelect: (date) {
            setState(() {
              label = date;
            });
          },
        );
      },
    );
  }

  void _showRangeDatePicker() {
    showDialog(
      context: context,
      builder: (BuildContext _) {
        return PersianDateTimePicker(
          initial: '1398/03/22#1399/03/25',
          type: 'rangedate',
          color: Colors.orangeAccent,
          onSelect: (date) {
            setState(() {
              label = date;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(fontFamily: 'IS'),
          ),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: _showDateTimePicker,
                child: const Text('تاریخ زمان'),
              ),
              ElevatedButton(
                onPressed: _showDatePicker,
                child: const Text('تاریخ '),
              ),
              ElevatedButton(
                onPressed: _showYearPicker,
                child: const Text('سال '),
              ),
              ElevatedButton(
                onPressed: _showMonthPicker,
                child: const Text('ماه '),
              ),
              ElevatedButton(
                onPressed: _showRangeDatePicker,
                child: const Text('بازه تاریخ '),
              ),
              ElevatedButton(
                onPressed: _showTimePicker,
                child: const Text(' زمان'),
              ),
              Text(label)
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showDatePicker,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
