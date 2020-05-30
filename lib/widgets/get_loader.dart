import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PreLoader extends StatefulWidget {
  final bool marigin;
  final bool color;

  PreLoader({this.marigin = false, this.color});
  @override
  _State createState() => _State();
}

class _State extends State<PreLoader> with TickerProviderStateMixin {
  GifController controller;

  getData() {
    controller = GifController(vsync: this);
    controller.repeat(min: 0, max: 91 * 1.0, period: Duration(seconds: 3));
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.marigin ? EdgeInsets.only(bottom: 80) : null,
      height: widget.color != null
          ? double.infinity
          : MediaQuery.of(context).size.width / 2 + 60,
      width: widget.color != null
          ? double.infinity
          : (MediaQuery.of(context).size.width / 2) + 60,
      color: widget.color != null ? Colors.black38 : null,
      child: Center(
        child: Container(
          //  child: Image.network(temp),
          // child: SpinKitFoldingCube(
          //   color: Colors.white,
          //   size: 50.0,
          // ),

          //https://media.giphy.com/media/L1Py5OFYUXmAFYxjh0/giphy.gif
          //https://media.giphy.com/media/ieCooaCygaupIVxG9P/giphy.gif
          child: GifImage(
            controller: controller,
            gaplessPlayback: true,
            image: NetworkImage(
                'https://media.giphy.com/media/Pmj6o3JpZU4v5EZSHa/giphy.gif'),
          ),
          height: (MediaQuery.of(context).size.width / 2) + 60,
          width: (MediaQuery.of(context).size.width / 2) + 60,
        ),
      ),
    );
  }
}
