// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// const flashOn = 'FLASH ON';
// const flashOff = 'FLASH OFF';
// const frontCamera = 'FRONT CAMERA';
// const backCamera = 'BACK CAMERA';

// class QrScannerProvider with ChangeNotifier {
//   String _qrText = '';
//   String _flashState = flashOn;
//   String _cameraState = frontCamera;
//   QRViewController _controller;
//   final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

//   String get qrText {
//     return _qrText;
//   }

//   QRViewController get controller {
//     return _controller;
//   }

//   GlobalKey get qrKey {
//     return _qrKey;
//   }

//   void setQrText(String val) {
//     _qrText = val;
//     notifyListeners();
//   }

//   String get flashState {
//     return _flashState;
//   }

//   void setFlashState(String val) {
//     _flashState = val;
//     notifyListeners();
//   }

//   String get cameraState {
//     return _cameraState;
//   }

//   void setCameraState(String val) {
//     _cameraState = val;
//     notifyListeners();
//   }

//   bool isFlashOn(String current) {
//     return flashOn == current;
//   }

//   bool isBackCamera(String current) {
//     return backCamera == current;
//   }

//   Future<void> onQRViewCreated(QRViewController controller) {
//     _controller = controller;
//     _controller.scannedDataStream.listen((scanData) {
//       _controller?.pauseCamera();
//       _qrText = scanData;
//     });
//   }
// }

// class QRViewController {}
