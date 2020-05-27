import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../../../globals/colors.dart' as col;

class OutlineButtonsForRegistr extends StatelessWidget {
  final String name;
  final Function function;

  OutlineButtonsForRegistr({
    @required this.name,
    @required this.function,
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
            Icon(FontAwesome.arrows_v)
          ],
        ),
      ),
      onPressed: function,
    );
  }
}
