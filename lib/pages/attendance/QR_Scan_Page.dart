import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gtr_app/Environment.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('my_box');
  runApp(MaterialApp(home: QR_Scan_Page()));
}

class QR_Scan_Page extends StatefulWidget {
  const QR_Scan_Page({super.key});

  @override
  State<QR_Scan_Page> createState() => QR_Scan_PageState();
}

class QR_Scan_PageState extends State<QR_Scan_Page> {
  //

  MobileScannerController controller_scanner = MobileScannerController(facing: CameraFacing.back, torchEnabled: false);

  Dio dio = Dio(
    BaseOptions(
      baseUrl: HOST_API, //
      contentType: Headers.formUrlEncodedContentType, //
      connectTimeout: Duration(seconds: 5), //
    ),
  );

  FlutterSecureStorage secure_storage = FlutterSecureStorage();

  String? access_token;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    access_token = await secure_storage.read(key: 'access_token');

    if (access_token != null) {
      dio.options.headers['Authorization'] = 'Bearer $access_token';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan QR Page')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: MobileScanner(
                  controller: controller_scanner,
                  onDetect: (capture) async {
                    if (capture.barcodes.isNotEmpty) {
                      final barcode = capture.barcodes.first; // capture only one barcode

                      // print("Barcode detected: ${barcode.rawValue}");
                      if (barcode.rawValue != null) {
                        controller_scanner.stop();

                        dio
                            .post(
                              "/attendance/qr_scan",
                              data: FormData.fromMap({
                                "code": barcode.rawValue, //
                              }),
                            )
                            .then((response) {
                              controller_scanner.stop();
                              Navigator.pop(context);
                              show_snackbar_message(context: context, message: "Scan successful.", color: Colors.green);
                            })
                            .catchError((error) {
                              controller_scanner.start();
                              // pprint("Error scanning QR code: $error");
                              show_snackbar_message(context: context, message: "Scan failed.: $error", color: Colors.red);
                            });
                      }
                    }
                  },
                  tapToFocus: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void show_snackbar_message({
  required BuildContext context, //
  required String message, //
  required Color color, //
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: color,
      ),
    );
}
