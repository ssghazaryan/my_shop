import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PagerForAll extends StatefulWidget {
  final int index;
  final List list;
  final String keyOfId;
  final String id;
  final repeat;
  final dontShowFirstId;
  final invalidValue;
  final bool showCount;
  PagerForAll({
    @required this.list,
    this.index,
    this.keyOfId,
    this.id,
    this.invalidValue,
    this.dontShowFirstId = false,
    this.showCount = false,
    this.repeat = false,
  });

  @override
  _PagerForAllState createState() => _PagerForAllState();
}

class _PagerForAllState extends State<PagerForAll> {
  FixedExtentScrollController scrollController;
  int index;

  void getData() {
    index = widget.index;
    if (widget.index == null) {
      index = widget.list.indexOf(widget.list
          .firstWhere((element) => element['id'].toString() == widget.id));
      scrollController = FixedExtentScrollController(initialItem: index);
    }
    if (widget.index != null)
      scrollController = FixedExtentScrollController(initialItem: widget.index);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Container(
              height: 200,
              child: CupertinoPicker(
                scrollController: scrollController,
                //  magnification: 1.5,
                backgroundColor: Color(0xFF203040),
                children: <Widget>[
                  for (int i = 0; i < widget.list.length; i++)
                    Container(
                      height: widget.keyOfId != null ? 50 : 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (widget.keyOfId != null &&
                              widget.list[i][widget.keyOfId] != "")
                            Row(
//                          crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // if (widget.list[i]["act"] != null)
                                //   Container(
                                //     padding: EdgeInsets.all(0.0),
                                //     child: Icon(Octicons.primitive_dot,
                                //         size: 20,
                                //         color: globals.innerPageName ==
                                //                 "yad.settings"
                                //             ? widget.list[i]["act"] == 2
                                //                 ? Colors.green
                                //                 : Colors.grey[600]
                                //             : widget.list[i]["act"] == -1
                                //                 ? Colors.grey[400]
                                //                 : widget.list[i]["act"] == 1
                                //                     ? Colors.green
                                //                     : widget.list[i]["act"] == 2
                                //                         ? Colors.orangeAccent
                                //                         : widget.list[i]
                                //                                     ["act"] ==
                                //                                 3
                                //                             ? Colors.redAccent
                                //                             : widget.list[i][
                                //                                         "act"] ==
                                //                                     8
                                //                                 ? Colors.blue
                                //                                 : Colors
                                //                                     .grey[600]),
                                //   ),
                                if (widget.dontShowFirstId || i != 0)
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "ID ${widget.list[i][widget.keyOfId]}",
                                        style: TextStyle(
                                            fontSize: 11, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // if (widget.keyOfId != null &&
                              //     widget.list[i][widget.keyOfId] == "")
                                // Container(
                                //   padding: EdgeInsets.all(0.0),
                                //   child: Icon(Octicons.primitive_dot,
                                //       size: 20,
                                //       color: globals.innerPageName ==
                                //               "yad.settings"
                                //           ? widget.list[i]["act"] == 2
                                //               ? Colors.green
                                //               : Colors.grey[600]
                                //           : widget.list[i]["act"] == -1
                                //               ? Colors.grey[400]
                                //               : widget.list[i]["act"] == 1
                                //                   ? Colors.green
                                //                   : widget.list[i]["act"] == 2
                                //                       ? Colors.orangeAccent
                                //                       : widget.list[i]["act"] ==
                                //                               3
                                //                           ? Colors.redAccent
                                //                           : widget.list[i]
                                //                                       ["act"] ==
                                //                                   8
                                //                               ? Colors.blue
                                //                               : Colors
                                //                                   .grey[600]),
                                // ),
                                widget.list[i]["name"].toString().length > 50
                                    ? Expanded(
                                        child: Text(
                                        widget.invalidValue != null &&
                                                widget.list[i]["name"]
                                                        .toString() ==
                                                    widget.invalidValue
                                            ? "---"
                                            : "${widget.list[i]["name"]}",
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ))
                                    : Text(
                                        widget.invalidValue != null &&
                                                widget.list[i]["name"]
                                                        .toString() ==
                                                    widget.invalidValue
                                            ? "---"
                                            : "${widget.list[i]["name"]}",
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                              // if (widget.list[i]["widget"] != null)
                              //   widget.list[i]["widget"],
                            ],
                          ),
                        ],
                      ),
                    )
                ],
                itemExtent: widget.keyOfId != null ? 50 : 40,
                looping: widget.repeat != null
                    ? widget.repeat
                    : widget.list.length > 20 ? true : false,
                onSelectedItemChanged: (int ind) {
                  setState(() {
                    index = ind;
                  });
                },
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (widget.showCount)
                if (widget.list.length > 5)
                  Container(
                      padding: EdgeInsets.all(
                        5.0,
                      ),
                      child: Container(
                        margin: EdgeInsets.only(left: 5.0),
                        child: Text(
                          'Всего: ${widget.list.length}',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
              Spacer(),
              Container(
                  padding: EdgeInsets.all(5.0),
                  child: Container(
                    margin: EdgeInsets.only(right: 5.0),
                    child: RaisedButton(
                      padding: const EdgeInsets.all(10),
                      elevation: 3,
                      disabledColor: Colors.grey[300],
                      disabledTextColor: Colors.white,
                      color: Color(0xff1599F2),
                      child: Text(
                        'Применить',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: widget.invalidValue != null &&
                              widget.list[index]['name'].toString() ==
                                  widget.invalidValue
                          ? null
                          : () {
                              if (widget.id != null)
                                Navigator.pop(context,
                                    widget.list[index]['id'].toString());
                              else {
                                Navigator.pop(context, index);
                              }
                            },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
