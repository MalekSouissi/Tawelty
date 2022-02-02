import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProfileDialog extends StatefulWidget {
  String inputHint;
  String oldText;
  bool obscure;
  TextEditingController controller;
  Function onPressed;

  EditProfileDialog(
      this.inputHint,
      this.oldText,
      this.controller,
      this.obscure,
      this.onPressed,
      );

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  TextEditingController editingController=TextEditingController();
  @override
  void initState() {
    editingController = widget.controller;
    editingController.text = widget.oldText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 0),
      actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      buttonPadding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          Text(
            "Modifier ${widget.inputHint}",
            style: TextStyle(
              fontFamily: 'GandhiSans',
              fontSize: 16,
              fontWeight: FontWeight.w900,
           //   color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          InputField(
            inputHint: widget.inputHint,
            obscure: widget.obscure,
            controller: widget.controller,
          ),
          SizedBox(height: 20),
        ],
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            widget.onPressed();
            Navigator.pop(context);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Valider",
                  style: TextStyle(
                    fontFamily: 'GandhiSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class InputField extends StatefulWidget {
  final String inputHint;
  final bool obscure;
  final TextEditingController controller;

  InputField(
      {this.inputHint='',
        this.obscure=false,
        required this.controller,
       });
  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          // width: MediaQuery.of(context).size.width*0.7,
          decoration: BoxDecoration(
            border: Border.all(width: 1.5, color: Color(0xFFE7E6E9)),
            borderRadius: BorderRadius.circular(45),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                //validator: widget.validator,
                controller: widget.controller,
                obscureText: widget.obscure,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintText: widget.inputHint,
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFABA8B3),
                    fontFamily: 'Arial',
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
