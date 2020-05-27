import 'package:flutter/material.dart';
import '../../../globals/colors.dart' as col;

class TextFieldForRegistration extends StatelessWidget {
  final String hint;

  TextFieldForRegistration({
    @required this.hint,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Colors.white),
      decoration: new InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: col.light, width: 1.0),
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
    );
  }
}
