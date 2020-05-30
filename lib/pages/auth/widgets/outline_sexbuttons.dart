import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../../../globals/colors.dart' as col;

class OutlineSexButtonsForRegistr extends StatelessWidget {
  final String name;
  final Function function;
  final bool value;

  OutlineSexButtonsForRegistr({
    @required this.name,
    @required this.function,
    @required this.value,
  });
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      borderSide: BorderSide(color: col.light),
      highlightedBorderColor: Colors.greenAccent,
      textColor: Colors.white,
      highlightColor: col.lowDarkColor,
      child: Container(
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: Text(name),
            ),
            Icon(value
                ? MaterialIcons.radio_button_checked
                : MaterialIcons.radio_button_unchecked)
          ],
        ),
      ),
      onPressed: function,
    );
  }
}
