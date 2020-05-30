import 'package:flutter/material.dart';
import '../globals/colors.dart' as col;

class TextFieldOutline extends StatelessWidget {
  final String hint;
  final Function(String) function;
  final bool obscureText;
  final TextEditingController controller;
  final Function(String) onChange;

  TextFieldOutline({
    @required this.hint,
    @required this.function,
    this.controller,
    this.obscureText = false,
    this.onChange,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChange ?? onChange,
      style: TextStyle(color: Colors.white),
      validator: function,
      decoration: new InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: col.light, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: TextStyle(color: Colors.grey[400]),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
      ),
    );
  }
}
