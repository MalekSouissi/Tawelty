import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_picker_widget/time_picker_widget.dart';


class BookTableNow extends StatefulWidget {
  const BookTableNow({Key? key}) : super(key: key);

  @override
  _BookTableNowState createState() => _BookTableNowState();
}

class _BookTableNowState extends State<BookTableNow> {

  int _counter = 0;
  late TimeOfDay newTime;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  late DateTime datetime;

  String getText() {
    if (datetime == null) {
      return 'Select Date';
    } else {
      return DateFormat('dd-MM-yyyy').format(datetime);
    }
  }

  late TimeOfDay time;

  String getTextTime() {
    if (time == null) {
      return 'Select Time';
    } else {
      final hours = time.hour.toString().padLeft(2, '0');
      final minutes = time.minute.toString().padLeft(2, '0');

      //print('$hours:$minutes:00');
      return '$hours:$minutes';
    }}

  pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    showCustomTimePicker(
        context: context,
        // It is a must if you provide selectableTimePredicate
        onFailValidation: (context) => print('Unavailable selection'),
        initialTime: TimeOfDay(hour: 2, minute: 0),
        selectableTimePredicate: (time) =>
        // time.hour > 1 &&
        //     time.hour < 14 &&
        time!.minute % 30 == 0).then((time) =>
        setState(() => newTime = time!));

    if (newTime == null) return;

    setState(() => time = newTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }



}
