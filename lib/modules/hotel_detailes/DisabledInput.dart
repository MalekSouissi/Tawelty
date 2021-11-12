import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DisabledInput extends StatefulWidget {
  String inputHint;
  Color color;
  bool validate;
  TextEditingController controller;

  DisabledInput({required this.inputHint, required this.color, required this.validate,required this.controller});
  @override
  _DisabledInputState createState() => _DisabledInputState();
}

class _DisabledInputState extends State<DisabledInput> {
  bool isSubmitted = false;
  final checkBoxIcon = 'assets/checkbox.svg';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: widget.color , width: 1),
      ),
      child: TextFormField(
        controller: widget.controller,
        style: TextStyle(
            fontSize: 20,
            color: Color(0xFF1C3956),
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          errorText: widget.validate ? 'Value Can\'t Be Empty' : null,
          enabled: true,
          hintText: widget.inputHint,
          hintStyle: TextStyle(
              fontSize: 18,
              color: Colors.grey[350],
              fontWeight: FontWeight.w600),
          contentPadding:
          EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          focusColor: widget.color,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: widget.color),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
