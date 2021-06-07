// import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'camera_view.dart';
// import 'painters/barcode_detector_painter.dart';
//
// class BarcodeScannerView extends StatefulWidget {
//   @override
//   _BarcodeScannerViewState createState() => _BarcodeScannerViewState();
// }
//
// class _BarcodeScannerViewState extends State<BarcodeScannerView> {
//   BarcodeScanner barcodeScanner = GoogleMlKit.vision.barcodeScanner([
//     Barcode.FORMAT_Default,
//     Barcode.FORMAT_Code_128,
//     Barcode.FORMAT_Code_39,
//     Barcode.FORMAT_Code_93,
//     Barcode.FORMAT_Codabar,
//     Barcode.FORMAT_EAN_13,
//     Barcode.FORMAT_EAN_8,
//     Barcode.FORMAT_ITF,
//     Barcode.FORMAT_UPC_A,
//     Barcode.FORMAT_UPC_E,
//     Barcode.FORMAT_QR_Code,
//     Barcode.FORMAT_PDF417,
//     Barcode.FORMAT_Aztec,
//     Barcode.FORMAT_Data_Matrix
//   ]);
//
//   bool isBusy = false;
//   CustomPaint? customPaint;
//
//   @override
//   void dispose() {
//     barcodeScanner.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CameraView(
//       title: 'Barcode Scanner',
//       customPaint: customPaint,
//       onImage: (inputImage) {
//         processImage(inputImage);
//       },
//     );
//   }
//
//   Future<void> processImage(InputImage inputImage) async {
//     if (isBusy) return;
//     isBusy = true;
//     final barcodes = await barcodeScanner.processImage(inputImage);
//     print('Found ${barcodes.length} barcodes');
//     if (inputImage.inputImageData?.size != null &&
//         inputImage.inputImageData?.imageRotation != null) {
//       final painter = BarcodeDetectorPainter(
//           barcodes,
//           inputImage.inputImageData!.size,
//           inputImage.inputImageData!.imageRotation);
//       customPaint = CustomPaint(painter: painter);
//     } else {
//       customPaint = null;
//     }
//     isBusy = false;
//     if (mounted) {
//       setState(() {});
//     }
//   }
// }