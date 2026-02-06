import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:gtr_app/routes/Routes.dart';
import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/utilities/Debug.dart';
import 'package:gtr_app/themes/Theme_Data.dart';
import 'package:gtr_app/routes/Navigator_Left.dart';

void main() {
  usePathUrlStrategy();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: HOST_API,
      theme: Theme_Data.get_theme(),
      routes: Routes.routes,
      home: const View_Form(
        input_json: {
          'image': "abc.png", //
          'name': 'Sample Name', //
          'position': 'View Sample', //
          'description': 'This is a sample description. \nIt can span multiple lines.', //
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class View_Form extends StatefulWidget {
  const View_Form({
    super.key, //
    required this.input_json, //
  });

  final Map<String, dynamic> input_json;

  @override
  State<View_Form> createState() => _View_FormState();
}

class _View_FormState extends State<View_Form> {
  //
  TextEditingController controller_input = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              width: 600,
              child: Column(
                children: [
                  widget.input_json['image'] == ''
                      ? //
                        Image.network('$MINIO_PUBLIC/logo.png', width: 200, height: 200)
                      : Image.network('$MINIO_PUBLIC/${widget.input_json['image']}', width: 200, height: 200, fit: BoxFit.cover),

                  Text(
                    widget.input_json['name'] ?? '', //
                    style: TextStyle(
                      fontSize: 24, //
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // SizedBox(height: 16),
                  Text(
                    widget.input_json['position'] ?? '',
                    style: TextStyle(
                      fontSize: 20, //
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.input_json['description'] ?? '',
                          style: TextStyle(fontSize: 16), //
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
