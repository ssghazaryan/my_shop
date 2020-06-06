import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

class ScanBarCode extends StatefulWidget {
  const ScanBarCode({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanBarCodeState();
}

class _ScanBarCodeState extends State<ScanBarCode> {
  var qrText = '';
  var flashState = flashOn;
  var cameraState = frontCamera;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (controller != null) {
                controller.toggleFlash();
                if (_isFlashOn(flashState)) {
                  setState(() {
                    flashState = flashOff;
                  });
                } else {
                  setState(() {
                    flashState = flashOn;
                  });
                }
              }
            },
            icon:
                Icon(flashState == flashOn ? Icons.flash_on : Icons.flash_off),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding:
                  EdgeInsets.only(bottom: MediaQuery.of(context).padding.top),
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.green,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300,
                ),
              ),
            ),
          ),
          // if (MediaQuery.of(context).viewInsets.bottom == 0.0)
          //   Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Container(
          //       // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       // children: <Widget>[
          //       //   Text('123213 $qrText'),
          //       //   Row(
          //       //     mainAxisAlignment: MainAxisAlignment.center,
          //       //     crossAxisAlignment: CrossAxisAlignment.center,
          //       //     children: <Widget>[
          //       //       // Container(
          //       //       //   margin: EdgeInsets.all(8),
          //       //       //   child: RaisedButton(
          //       //       //     onPressed: () {
          //       //       //       if (controller != null) {
          //       //       //         controller.flipCamera();
          //       //       //         if (_isBackCamera(cameraState)) {
          //       //       //           setState(() {
          //       //       //             cameraState = frontCamera;
          //       //       //           });
          //       //       //         } else {
          //       //       //           setState(() {
          //       //       //             cameraState = backCamera;
          //       //       //           });
          //       //       //         }
          //       //       //       }
          //       //       //     },
          //       //       //     child:
          //       //       //         Text(cameraState, style: TextStyle(fontSize: 20)),
          //       //       //   ),
          //       //       // )
          //       //     ],
          //       //   ),
          //       //   // Row(
          //       //   //   mainAxisAlignment: MainAxisAlignment.center,
          //       //   //   crossAxisAlignment: CrossAxisAlignment.center,
          //       //   //   children: <Widget>[
          //       //   //     Container(
          //       //   //       margin: EdgeInsets.all(8),
          //       //   //       child: RaisedButton(
          //       //   //         onPressed: () {
          //       //   //           controller?.pauseCamera();
          //       //   //         },
          //       //   //         child: Text('pause', style: TextStyle(fontSize: 20)),
          //       //   //       ),
          //       //   //     ),
          //       //   //     Container(
          //       //   //       margin: EdgeInsets.all(8),
          //       //   //       child: RaisedButton(
          //       //   //         onPressed: () {
          //       //   //           controller?.resumeCamera();
          //       //   //         },
          //       //   //         child: Text('resume', style: TextStyle(fontSize: 20)),
          //       //   //       ),
          //       //   //     )
          //       //   //   ],
          //       //   // ),
          //       // ],
          //     ),
          //   )
        ],
      ),
    );
  }

  bool _isFlashOn(String current) {
    return flashOn == current;
  }

  bool _isBackCamera(String current) {
    return backCamera == current;
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      print(scanData);
      setState(() {
        controller?.pauseCamera();
        qrText = scanData;
      });
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context1) {
          // return object of type Dialog
          return CupertinoAlertDialog(
            title: new Text("Сканированный код $scanData ?"),
            // content: new Text("Alert Dialog body"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Нет"),
                onPressed: () {
                  Navigator.of(context1).pop();
                  setState(() {
                    controller.resumeCamera();
                    qrText = '';
                  });
                },
              ),
              new FlatButton(
                child: new Text("Да"),
                onPressed: () {
                  Navigator.of(context1).pop();
                  Navigator.pop(context, qrText);
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
